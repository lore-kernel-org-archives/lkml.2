Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab1A0Aqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:46:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50490 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1A0Aqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:46:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 Jan 2011 09:40:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: handle overflow in mem_cgroup_out_of_memory()
Message-Id: <20110127094031.04cc2be2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <xr93y667lgdm.fsf@gthelen.mtv.corp.google.com>
References: <1296030555-3594-1-git-send-email-gthelen@google.com>
	<20110126170713.GA2401@cmpxchg.org>
	<xr93y667lgdm.fsf@gthelen.mtv.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 09:33:09 -0800
Greg Thelen <gthelen@google.com> wrote:

> Johannes Weiner <hannes@cmpxchg.org> writes:
> 
> > On Wed, Jan 26, 2011 at 12:29:15AM -0800, Greg Thelen wrote:
> >> mem_cgroup_get_limit() returns a byte limit as a unsigned 64 bit value,
> >> which is converted to a page count by mem_cgroup_out_of_memory().  Prior
> >> to this patch the conversion could overflow on 32 bit platforms
> >> yielding a limit of zero.
> >
> > Balbir: It can truncate, because the conversion shrinks the required
> > bits of this 64-bit number by only PAGE_SHIFT (12).  Trying to store
> > the resulting up to 52 significant bits in a 32-bit integer will cut
> > up to 20 significant bits off.
> >
> >> Signed-off-by: Greg Thelen <gthelen@google.com>
> >> ---
> >>  mm/oom_kill.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >> 
> >> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> >> index 7dcca55..3fcac51 100644
> >> --- a/mm/oom_kill.c
> >> +++ b/mm/oom_kill.c
> >> @@ -538,7 +538,7 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
> >>  	struct task_struct *p;
> >>  
> >>  	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
> >> -	limit = mem_cgroup_get_limit(mem) >> PAGE_SHIFT;
> >> +	limit = min(mem_cgroup_get_limit(mem) >> PAGE_SHIFT, (u64)ULONG_MAX);
> >
> > I would much prefer using min_t(u64, ...).  To make it really, really
> > explicit that this is 64-bit arithmetic.  But that is just me, no
> > correctness issue.
> >
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> I agree that min_t() is clearer.  Does the following look better?
> 
> Author: Greg Thelen <gthelen@google.com>
> Date:   Wed Jan 26 00:05:59 2011 -0800
> 
>     oom: handle truncation in mem_cgroup_out_of_memory()
>     
>     mem_cgroup_get_limit() returns a byte limit as an unsigned 64 bit value.
>     mem_cgroup_out_of_memory() converts this byte limit to an unsigned long
>     page count.  Prior to this patch, the 32 bit version of
>     mem_cgroup_out_of_memory() would silently truncate the most significant
>     20 bits from byte limit when constructing the limit as a page count.
>     For byte limits with the lowest 44 bits set to zero, this truncation
>     would compute a page limit of zero.
>     
>     This patch checks for such large byte limits that cannot be converted to
>     page counts without loosing information.  In such situations, where a 32
>     bit page counter is too small to represent the corresponding byte count,
>     select a maximal page count.
>     
>     Signed-off-by: Greg Thelen <gthelen@google.com>
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 7dcca55..0164060 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -538,7 +538,7 @@ void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
>  	struct task_struct *p;
>  
>  	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
> -	limit = mem_cgroup_get_limit(mem) >> PAGE_SHIFT;
> +	limit = min_t(u64, mem_cgroup_get_limit(mem) >> PAGE_SHIFT, ULONG_MAX);
>  	read_lock(&tasklist_lock);
>  retry:
>  	p = select_bad_process(&points, limit, mem, NULL);
> 

Thank you for catching.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


