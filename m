Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab1KQQin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:38:43 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57639 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755519Ab1KQQim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:38:42 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/RE+1s+ijRSyOnHvHs7cuVtfAk/ZCG/i9QpZFwEt
	/0DZAHJCL4bg3G
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321545376.2495.1.camel@laptop>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 17:38:37 +0100
Message-ID: <1321547917.6308.48.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 16:56 +0100, Peter Zijlstra wrote:
> On Thu, 2011-11-17 at 16:38 +0100, Mike Galbraith wrote:
> > On Thu, 2011-11-17 at 02:59 +0100, Mike Galbraith wrote:
> > > On Wed, 2011-11-16 at 10:37 -0800, Suresh Siddha wrote:
> > 
> > > > It should be ok. Isn't it?
> > > 
> > > Nope, wasn't ok.
> > 
> > Because you can't get to again: with a single E5620 package, it having
> > only SIBLING and MC domains.
> >  
> > again:
> >         for_each_domain(target, sd) {
> >                 if (!smt && (sd->flags & SD_SHARE_CPUPOWER))
> >                         continue;
> > 
> >                 if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
> >                         if (!smt) {
> >                                 smt = 1;
> >                                 goto again;
> > 
> 
> D'0h, indeed.. 
> 
> Something like the below maybe, although I'm certain it all can be
> written much nicer indeed.

I'll give it a go.

Squabbling with bouncing buddies in an isolated and otherwise idle
cpuset ate my day.
 
> ---
>  kernel/sched/fair.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index cd3b642..340e62e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2676,13 +2676,11 @@ static int select_idle_sibling(struct task_struct *p, int target)
>  		if (!smt && (sd->flags & SD_SHARE_CPUPOWER))
>  			continue;
>  
> -		if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
> -			if (!smt) {
> -				smt = 1;
> -				goto again;
> -			}
> +		if (smt && !(sd->flags & SD_SHARE_CPUPOWER))
> +			break;
> +
> +		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
>  			break;
> -		}
>  
>  		sg = sd->groups;
>  		do {
> @@ -2702,6 +2700,10 @@ static int select_idle_sibling(struct task_struct *p, int target)
>  			sg = sg->next;
>  		} while (sg != sd->groups);
>  	}
> +	if (!smt) {
> +		smt = 1;
> +		goto again;
> +	}
>  done:
>  	rcu_read_unlock();
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


