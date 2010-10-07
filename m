Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206Ab0JGJKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 05:10:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36708 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0JGJKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 05:10:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 7 Oct 2010 18:05:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>, Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] memcg: lock-free clear page writeback  (Was Re: [PATCH
 04/10] memcg: disable local interrupts in lock_page_cgroup()
Message-Id: <20101007180529.1240e79a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101007152422.c5919517.kamezawa.hiroyu@jp.fujitsu.com>
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
	<1286175485-30643-5-git-send-email-gthelen@google.com>
	<20101005160332.GB9515@barrios-desktop>
	<xr93wrpwkypv.fsf@ninji.mtv.corp.google.com>
	<AANLkTikKXNx-Cj2UY+tJj8ifC+Je5WDbS=eR6xsKM1uU@mail.gmail.com>
	<20101007093545.429fe04a.kamezawa.hiroyu@jp.fujitsu.com>
	<20101007105456.d86d8092.nishimura@mxp.nes.nec.co.jp>
	<20101007111743.322c3993.kamezawa.hiroyu@jp.fujitsu.com>
	<20101007152111.df687a62.kamezawa.hiroyu@jp.fujitsu.com>
	<20101007152422.c5919517.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010 15:24:22 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Greg, I think clear_page_writeback() will not require _any_ locks with this patch.
> But set_page_writeback() requires it...
> (Maybe adding a special function for clear_page_writeback() is better rather than
>  adding some complex to switch() in update_page_stat())
> 

I'm testing a code like this.
==
       /* pc->mem_cgroup is unstable ? */
        if (unlikely(mem_cgroup_stealed(mem))) {
                /* take a lock against to access pc->mem_cgroup */
                if (!in_interrupt()) {
                        lock_page_cgroup(pc);
                        need_unlock = true;
                        mem = pc->mem_cgroup;
                        if (!mem || !PageCgroupUsed(pc))
                                goto out;
                } else if (idx == MEMCG_NR_FILE_WRITEBACK && (val < 0)) {
                        /* This is allowed */
                } else
                        BUG();
        }
==
Thanks,
-Kame

