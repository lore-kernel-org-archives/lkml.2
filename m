Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab1LHDpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 22:45:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53498 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab1LHDpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 22:45:02 -0500
Date: Wed, 7 Dec 2011 19:44:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Frantisek Hrbata <fhrbata@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, minchan.kim@gmail.com,
        stable@kernel.org, eteo@redhat.com, pmatouse@redhat.com,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v2 RESEND] oom: fix integer overflow of points in
 oom_badness
In-Reply-To: <20111202174526.GA11483@dhcp-26-164.brq.redhat.com>
Message-ID: <alpine.DEB.2.00.1112071944210.636@chino.kir.corp.google.com>
References: <1320048865-13175-1-git-send-email-fhrbata@redhat.com> <20111202174526.GA11483@dhcp-26-164.brq.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011, Frantisek Hrbata wrote:

> An integer overflow will happen on 64bit archs if task's sum of rss, swapents
> and nr_ptes exceeds (2^31)/1000 value. This was introduced by commit
> 
> f755a04 oom: use pte pages in OOM score
> 
> where the oom score computation was divided into several steps and it's no
> longer computed as one expression in unsigned long(rss, swapents, nr_pte are
> unsigned long), where the result value assigned to points(int) is in
> range(1..1000). So there could be an int overflow while computing
> 
> 176          points *= 1000;
> 
> and points may have negative value. Meaning the oom score for a mem hog task
> will be one.
> 
> 196          if (points <= 0)
> 197                  return 1;
> 
> For example:
> [ 3366]     0  3366 35390480 24303939   5       0             0 oom01
> Out of memory: Kill process 3366 (oom01) score 1 or sacrifice child
> 
> Here the oom1 process consumes more than 24303939(rss)*4096~=92GB physical
> memory, but it's oom score is one.
> 
> In this situation the mem hog task is skipped and oom killer kills another and
> most probably innocent task with oom score greater than one.
> 
> The points variable should be of type long instead of int to prevent the int
> overflow.
> 
> Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Cc: stable@kernel.org [2.6.36+]

Andrew, this looks like 3.2-rc5 material.

> ---
>  mm/oom_kill.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 626303b..e9a1785 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -162,7 +162,7 @@ static bool oom_unkillable_task(struct task_struct *p,
>  unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>  		      const nodemask_t *nodemask, unsigned long totalpages)
>  {
> -	int points;
> +	long points;
>  
>  	if (oom_unkillable_task(p, mem, nodemask))
>  		return 0;
