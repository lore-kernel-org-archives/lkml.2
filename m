Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1HRGIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:08:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:33831 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab1HRGIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:08:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:in-reply-to:message-id:
	user-agent:mime-version:content-type;
	b=o4dSw5gVbH3gLUPjPFvhU1Dr6R/zEpqVsNkm7YSXYoGy78RzeWAquOcKv1VvZoT/T
	S5s0eUhvjYTGm+vJONS+Q==
From: Greg Thelen <gthelen@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <david@fromorbit.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v9 03/13] memcg: add dirty page accounting infrastructure
References: <1313597705-6093-1-git-send-email-gthelen@google.com>
	<1313597705-6093-4-git-send-email-gthelen@google.com>
	<20110818093959.cdf501ae.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 17 Aug 2011 23:07:29 -0700
In-Reply-To: <20110818093959.cdf501ae.kamezawa.hiroyu@jp.fujitsu.com>
	(KAMEZAWA Hiroyuki's message of "Thu, 18 Aug 2011 09:39:59 +0900")
Message-ID: <xr93bovnuuam.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> On Wed, 17 Aug 2011 09:14:55 -0700
> Greg Thelen <gthelen@google.com> wrote:
>
>> Add memcg routines to count dirty, writeback, and unstable_NFS pages.
>> These routines are not yet used by the kernel to count such pages.  A
>> later change adds kernel calls to these new routines.
>> 
>> As inode pages are marked dirty, if the dirtied page's cgroup differs
>> from the inode's cgroup, then mark the inode shared across several
>> cgroup.
>> 
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>> Signed-off-by: Andrea Righi <andrea@betterlinux.com>
>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> A nitpick..
>
>
>
>> +static inline
>> +void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
>> +				       struct mem_cgroup *to,
>> +				       enum mem_cgroup_stat_index idx)
>> +{
>> +	preempt_disable();
>> +	__this_cpu_dec(from->stat->count[idx]);
>> +	__this_cpu_inc(to->stat->count[idx]);
>> +	preempt_enable();
>> +}
>> +
>
> this_cpu_dec()
> this_cpu_inc()
>
> without preempt_disable/enable will work. CPU change between dec/inc will
> not be problem.
>
> Thanks,
> -Kame

I agree, but this fix is general cleanup, which seems independent of
memcg dirty accounting.  This preemption disable/enable pattern exists
before this patch series in both mem_cgroup_charge_statistics() and
mem_cgroup_move_account().  For consistency we should change both.  To
keep the dirty page accounting series simple, I would like to make these
changes outside of this series.  On x86 usage of this_cpu_dec/inc looks
equivalent to __this_cpu_inc(), so I assume the only trade off is that
preemptible non-x86 using generic this_this_cpu() will internally
disable/enable preemption in this_cpu_*() operations.

I'll submit a cleanup patch outside of the dirty limit patches for this.
