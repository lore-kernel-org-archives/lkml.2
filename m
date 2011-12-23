Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1LWMGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 07:06:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40913 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1LWMGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 07:06:18 -0500
Message-ID: <1324641960.24803.50.camel@twins>
Subject: Re: [rfc] disable scheduler warnings during oopses.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 23 Dec 2011 13:06:00 +0100
In-Reply-To: <20111223101917.GA4749@elte.hu>
References: <20111222213929.GA4722@redhat.com>
	 <20111223101917.GA4749@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-23 at 11:19 +0100, Ingo Molnar wrote:
> * Dave Jones <davej@redhat.com> wrote:
> 
> > The panic-on-framebuffer code seems to cause a schedule
> > to occur during an oops. This causes a bunch of extra
> > spew as can be seen in https://bugzilla.redhat.com/attachment.cgi?id=549230
> > 
> > Would this (untested) patch be sufficient here, or does the drm
> > code need rearchitecting to not perform allocations during panic ?
> > 
> > Signed-off-by: Dave Jones <davej@redhat.com>
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index d6b149c..627f788 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -4321,6 +4321,9 @@ static noinline void __schedule_bug(struct task_struct *prev)
> >  {
> >  	struct pt_regs *regs = get_irq_regs();
> >  
> > +	if (oops_in_progress)
> > +		return;
> > +
> >  	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
> >  		prev->comm, prev->pid, preempt_count());
> >  
> 
> Doing that makes sense - if an oops in going on we don't want to 
> produce recursive messages. Note that scheduler code has been 
> moved to kernel/sched/, so i've changed the patch accordingly.

Urgh I would actually argue against merging this. What the KSM console
does is horridly wrong, and simply papering over it doesn't help its
cause. Its up there with USB-Serial console on wrongness.

> Note that despite that, the DRM code *definitely* needs to be 
> fixed to not allocate and schedule while printing on the 
> framebuffer in KMS mode ...

For sure, its plain insane and completely unreliable.
