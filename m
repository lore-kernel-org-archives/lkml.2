Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1GMWyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:54:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52728 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab1GMWyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:54:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=PrKod9sB7JiWqxC06IwKqTRUmsnRLRy6Jpoa14WIKo/G1xjbmnem6/wrJCZTJ2i0X
	8Pb0Si+l4Y5MIlWUVLkCA==
Date: Wed, 13 Jul 2011 15:53:07 -0700
From: Todd Poynor <toddpoynor@google.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] ARM: Call idle notifiers
Message-ID: <20110713225307.GA17946@google.com>
References: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
 <1309229190-25006-3-git-send-email-toddpoynor@google.com>
 <20110711195000.GH4109@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711195000.GH4109@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 09:50:04PM +0200, Frederic Weisbecker wrote:
> On Mon, Jun 27, 2011 at 07:46:29PM -0700, Todd Poynor wrote:
> > Change-Id: Id833e61c13baa1783705ac9e9046d1f0cc90c95e
> > Signed-off-by: Todd Poynor <toddpoynor@google.com>
> > ---
> >  arch/arm/kernel/process.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> > index 5e1e541..1b9101e 100644
> > --- a/arch/arm/kernel/process.c
> > +++ b/arch/arm/kernel/process.c
> > @@ -184,6 +184,7 @@ void cpu_idle(void)
> >  	while (1) {
> >  		tick_nohz_stop_sched_tick(1);
> >  		leds_event(led_idle_start);
> > +		idle_notifier_call_chain(IDLE_START);
> >  		while (!need_resched()) {
> >  #ifdef CONFIG_HOTPLUG_CPU
> >  			if (cpu_is_offline(smp_processor_id()))
> > @@ -208,6 +209,7 @@ void cpu_idle(void)
> >  			}
> >  		}
> >  		leds_event(led_idle_end);
> > +		idle_notifier_call_chain(IDLE_END);
> >  		tick_nohz_restart_sched_tick();
> >  		preempt_enable_no_resched();
> >  		schedule();
> 
> You seem to use this notifier with different semantics than x86.
> x86 notifies idle state when it knows it goes to sleep and exit it any
> time it gets interrupted. And it does that every time in the need_resched()
> loop.
> 
> But here in ARM you enter idle only once before the loop (and you don't even
> know if you will enter the loop). And you don't notify idle exit state on interrupts.
> 
> So if in the end this idle notifier is something that is really wanted, it needs
> to have a consistant behaviour across archs.

Yes, I didn't want to change the behavior of the existing notifiers
being converted in these patches, but eventually one would want
cross-arch idle callbacks with consistent behavior, and the
existing arch-specific notifications have different semantics.
My goal is to notify when the OS scheduler enters and exits its idle
loop, so the existing ARM semantics are what I'm aiming for; the x86_64
behavior is probably further evidence that it is really a
cpuidle-style operation being performed.  If the idle notifiers do
find any traction then it sounds like moving the notification to the
common schedule code would be the right thing to do.


Thanks -- Todd
