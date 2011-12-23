Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab1LWKVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:21:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42852 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1LWKVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:21:14 -0500
Date: Fri, 23 Dec 2011 11:19:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rfc] disable scheduler warnings during oopses.
Message-ID: <20111223101917.GA4749@elte.hu>
References: <20111222213929.GA4722@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222213929.GA4722@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> The panic-on-framebuffer code seems to cause a schedule
> to occur during an oops. This causes a bunch of extra
> spew as can be seen in https://bugzilla.redhat.com/attachment.cgi?id=549230
> 
> Would this (untested) patch be sufficient here, or does the drm
> code need rearchitecting to not perform allocations during panic ?
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index d6b149c..627f788 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4321,6 +4321,9 @@ static noinline void __schedule_bug(struct task_struct *prev)
>  {
>  	struct pt_regs *regs = get_irq_regs();
>  
> +	if (oops_in_progress)
> +		return;
> +
>  	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
>  		prev->comm, prev->pid, preempt_count());
>  

Doing that makes sense - if an oops in going on we don't want to 
produce recursive messages. Note that scheduler code has been 
moved to kernel/sched/, so i've changed the patch accordingly.

Note that despite that, the DRM code *definitely* needs to be 
fixed to not allocate and schedule while printing on the 
framebuffer in KMS mode ...

Thanks,

	Ingo
