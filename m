Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab1BYVVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 16:21:49 -0500
Received: from adelie.canonical.com ([91.189.90.139]:57863 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab1BYVVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 16:21:47 -0500
Date: Fri, 25 Feb 2011 15:21:42 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: Performance/resume issues on Toshiba NB305
Message-ID: <20110225212142.GC24686@thinkpad-t410>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>
References: <20110225164239.GA24686@thinkpad-t410>
 <alpine.LFD.2.00.1102252108190.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102252108190.2701@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 09:37:39PM +0100, Thomas Gleixner wrote:
> On Fri, 25 Feb 2011, Seth Forshee wrote:
> 
> Please always Cc the relevant maintainers. I just got notified by
> someone who accidentaly stumbled over that.

I'll be sure to remember that in the future.

> > I've been looking into a couple of problems with this machine that have
> > me a bit stumped at the moment. The two problems may or may not be
> > related, so I'm including details about both issues below. If anyone has
> > any ideas, I'd love to hear them. Note that these are not recent
> > regressions; they've been around since at least 2.6.32.
> > 
> > The CPU in this machine is an Atom N450.
> > 
> > When booted normally the performance on this machine is very poor, but
> > when booted with any of nohz=off, nolapic, or nohpet it improves
> > significantly. The performance also improves if I use the patch below to
> > force the hpet to remain in periodic mode (with hpet=periodic on the
> > command line).
> > 
> > One other thing I noticed when I had added some logging related to hpet
> > rearming is 3-5 second periods of no log activity occurring fairly
> > frequently, whereas such inactive periods are infrequent when
> > performance is good and are also infrequent on another machine with very
> > similar hardware and no performance issues.
> 
> That seems to be related to low power states. When the machine goes
> idle we switch into lower power states and that requires to use the
> hpet instead of the local apic timer as that one stops.
> 
> You could verify that theory by booting with processor.max_cstate=1

This fixes the performance in combination with intel_idle.max_cstate=0.
Alternately, intel_idle.max_cstate=1 works. But the resume still hangs.

> > The machine also hangs for 5 minutes during resume, unless booted with
> > both nohz=off and highres=off, or with hpet=periodic using the patch
> > below. I've traced this down to hanging in an SMI handler during the
> > ACPI _WAK method execution. The 5 minutes corresponds to how long it
> > takes for the low 32 bits of the hpet to wrap in this machine, and since
> > the options that eliminate the hang result in the hpet being in periodic
> > mode during _WAK method execution I suspect that the SMI handler is
> > hanging until a timer interrupt happens.
> > 
> > One possible explanation here is that the performance problems are also
> > related to hangs in SMI handlers until there's a timer interrupt,
> > although I don't know how that explains why some of the command line
> > options eliminate the performance issues.
> 
> Well, that's simple. If you disable NOHZ then we never go into deep
> idle because the next timer interrupt will arrive in a very short time
> span. nohpet makes it use the PIT which has a very short (25ms)
> maximum oneshot time. nolapic disables a lot of the functionality as
> well.

Makes sense.

Is the answer to quirk the machine to avoid deep C-states, or is there
some better way I can fix this?

> > --- a/kernel/time/tick-broadcast.c
> > +++ b/kernel/time/tick-broadcast.c
> > @@ -565,10 +565,15 @@ void tick_broadcast_switch_to_oneshot(void)
> >  
> >  	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
> >  
> > -	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
> >  	bc = tick_broadcast_device.evtdev;
> > +	if (bc && !(bc->features & CLOCK_EVT_FEAT_ONESHOT))
> > +		goto unlock;
> > +
> > +	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
> >  	if (bc)
> >  		tick_broadcast_setup_oneshot(bc);
> > +
> > +unlock:
> >  	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
> >  }
> 
> Why would you need that? We should not call that when the broadcast
> device does not have TICKDEV_MODE_ONESHOT. If we do the bug is
> somewhere else.

Then there must be a bug. When I cleared CLOCK_EVT_FEAT_ONESHOT for the
HPET without this change the HPET got put into oneshot mode. The local
tick device is checked before switching to nohz, but not the broadcast
device. This change was just a quick hack to get around that and test my
theory.

