Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0JRAuG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 20:50:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37023 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0JRAuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 20:50:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 18 Oct 2010 09:44:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 04/11] memcg: disable softirq in lock_page_cgroup()
Message-Id: <20101018094437.e12aae49.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1287177279-30876-5-git-send-email-gthelen@google.com>
References: <1287177279-30876-1-git-send-email-gthelen@google.com>
	<1287177279-30876-5-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010 14:14:32 -0700
Greg Thelen <gthelen@google.com> wrote:

> If pages are being migrated from a memcg, then updates to that
> memcg's page statistics are protected by grabbing a bit spin lock
> using lock_page_cgroup().  In an upcoming commit memcg dirty page
> accounting will be updating memcg page accounting (specifically:
> num writeback pages) from softirq.  Avoid a deadlocking nested
> spin lock attempt by disabling softirq on the local processor
> when grabbing the page_cgroup bit_spin_lock in lock_page_cgroup().
> This avoids the following deadlock:
> statistic
>       CPU 0             CPU 1
>                     inc_file_mapped
>                     rcu_read_lock
>   start move
>   synchronize_rcu
>                     lock_page_cgroup
>                       softirq
>                       test_clear_page_writeback
>                       mem_cgroup_dec_page_stat(NR_WRITEBACK)
>                       rcu_read_lock
>                       lock_page_cgroup   /* deadlock */
>                       unlock_page_cgroup
>                       rcu_read_unlock
>                     unlock_page_cgroup
>                     rcu_read_unlock
> 
> By disabling softirq in lock_page_cgroup, nested calls are avoided.
> The softirq would be delayed until after inc_file_mapped enables
> softirq when calling unlock_page_cgroup().
> 
> The normal, fast path, of memcg page stat updates typically
> does not need to call lock_page_cgroup(), so this change does
> not affect the performance of the common case page accounting.
> 
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>

I have a patch for this problem.
So, could you reorder patch as

	1,2,3,5,6,7,8,9,10,11 

I'll post an add-on patch."12"

move_charge performance improbement patches will be posted later.

Thanks,
-Kame

