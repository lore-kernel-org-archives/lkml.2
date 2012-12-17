Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2LQPfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:35:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:36382 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2LQPfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:35:51 -0500
Date: Mon, 17 Dec 2012 16:35:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <bitbucket@online.de>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.9-rt21
In-Reply-To: <1355543529.20987.6.camel@marge.simpson.net>
Message-ID: <alpine.LFD.2.02.1212171634070.3148@ionos>
References: <alpine.LFD.2.02.1212051659160.2701@ionos> <1355543529.20987.6.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Dec 2012, Mike Galbraith wrote:
> On Wed, 2012-12-05 at 17:05 +0100, Thomas Gleixner wrote: 
> > Dear RT Folks,
> > 
> > I'm pleased to announce the 3.6.9-rt21 release. 3.6.7-rt18, 3.6.8-rt19
> > and 3.6.9-rt20 are not announced updates to the respective 3.6.y
> > stable releases without any RT changes
> > 
> > Changes since 3.6.9-rt20:
> > 
> >    * Fix the PREEMPT_LAZY implementation on ARM
> > 
> >    * Fix the RCUTINY issues
> > 
> >    * Fix a long standing scheduler bug (See commit log of
> >      sched-enqueue-to-head.patch)
> 
> That last has an oversight buglet.
> 
> sched: add missing userspace->kernel struct sched_param.sched_priority inversion
> 
> Signed-off-by: Mike Galbraith <bitbucket@online.de>
> ---
>  kernel/sched/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4624,7 +4624,7 @@ static int __sched_setscheduler(struct t
>  	p->sched_reset_on_fork = reset_on_fork;
>  
>  	oldprio = p->prio;
> -	if (oldprio == param->sched_priority)
> +	if (oldprio == (MAX_RT_PRIO - 1) - param->sched_priority)
>  		goto out;
>  
>  	on_rq = p->on_rq;

Duh, yes. But there is another one here:

+               enqueue_task(rq, p, oldprio < param->sched_priority ?
+                            ENQUEUE_HEAD : 0);

Bah. This reverse user/kernel priority nonsense really should go away!

Thanks,

	tglx
