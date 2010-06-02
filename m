Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422Ab0FBPFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 11:05:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758358Ab0FBPFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 11:05:20 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: James Bottomley <James.Bottomley@suse.de>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Neil Brown <neilb@suse.de>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, mark.gross@intel.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>, felipe.balbi@nokia.com
In-Reply-To: <AANLkTilRcFZyYa-0HlaM-6IEZSyar3S9S_cCWSFax2Zo@mail.gmail.com>
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	 <20100601135102.GA8098@srcf.ucam.org>
	 <1275426085.21962.967.camel@mulgrave.site> <201006020024.14220.rjw@sisk.pl>
	 <1275431816.21962.1108.camel@mulgrave.site>
	 <AANLkTikObnAZbyOxeYAhXcEbimO3XTTO-HlC9CD_HH6t@mail.gmail.com>
	 <1275451342.21962.1777.camel@mulgrave.site>
	 <AANLkTilRcFZyYa-0HlaM-6IEZSyar3S9S_cCWSFax2Zo@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 10:05:11 -0500
Message-ID: <1275491111.2799.110.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 21:41 -0700, Arve Hjønnevåg wrote:
> 2010/6/1 James Bottomley <James.Bottomley@suse.de>:
> > On Tue, 2010-06-01 at 18:10 -0700, Arve Hjønnevåg wrote:
> >> On Tue, Jun 1, 2010 at 3:36 PM, James Bottomley <James.Bottomley@suse.de> wrote:
> >> > On Wed, 2010-06-02 at 00:24 +0200, Rafael J. Wysocki wrote:
> >> >> On Tuesday 01 June 2010, James Bottomley wrote:
> >> >> > On Tue, 2010-06-01 at 14:51 +0100, Matthew Garrett wrote:
> >> >> > > On Mon, May 31, 2010 at 04:21:09PM -0500, James Bottomley wrote:
> >> >> > >
> >> >> > > > You're the one mentioning x86, not me.  I already explained that some
> >> >> > > > MSM hardware (the G1 for example) has lower power consumption in S3
> >> >> > > > (which I'm using as an ACPI shorthand for suspend to ram) than any
> >> >> > > > suspend from idle C state.  The fact that current x86 hardware has the
> >> >> > > > same problem may be true, but it's not entirely relevant.
> >> >> > >
> >> >> > > As long as you can set a wakeup timer, an S state is just a C state with
> >> >> > > side effects. The significant one is that entering an S state stops the
> >> >> > > process scheduler and any in-kernel timers. I don't think Google care at
> >> >> > > all about whether suspend is entered through an explicit transition or
> >> >> > > something hooked into cpuidle - the relevant issue is that they want to
> >> >> > > be able to express a set of constraints that lets them control whether
> >> >> > > or not the scheduler keeps on scheduling, and which doesn't let them
> >> >> > > lose wakeup events in the process.
> >> >> >
> >> >> > Exactly, so my understanding of where we currently are is:
> >> >>
> >> >> Thanks for the recap.
> >> >>
> >> >> >      1. pm_qos will be updated to be able to express the android suspend
> >> >> >         blockers as interactivity constraints (exact name TBD, but
> >> >> >         probably /dev/cpu_interactivity)
> >> >>
> >> >> I think that's not been decided yet precisely enough.  I saw a few ideas
> >> >> here and there in the thread, but which of them are we going to follow?
> >> >
> >> > Well, android only needs two states (block and don't block), so that
> >> > gets translated as 2 s32 values (say 0 and INT_MAX).  I've seen defines
> >> > like QOS_INTERACTIVE and QOS_NONE (or QOS_DRECKLY or QOS_MANANA) to
> >> > describe these, but if all we're arguing over is the define name, that's
> >> > progress.
> >>
> >> I think we need separate state constraints for suspend and idle low
> >> power modes. On the msm platform only a subset of the interrupts can
> >> wake up from the low power mode, so we block the use if the low power
> >> mode from idle while other interrupts are enabled. We do not block
> >> suspend however if those interrupts are not marked as wakeup
> >> interrupts. Most constraints that prevent suspend are not hardware
> >> specific and should not prevent entering low power modes from idle. In
> >> other words we may need to prevent low power idle modes while allowing
> >> suspend, and we may need to prevent suspend while allowing low power
> >> idle modes.
> >
> > Well, as I said, pm_qos is s32 ... it's easy to make the constraint
> > ternary instead of binary.
> 
> No, they have to be two separate constraints, otherwise a constraint
> to block suspend would override a constraint to block a low power idle
> mode or the other way around.

Depends.  If you block the system from going into low power idle, does
that mean you still want it to be fully suspended?

If yes, then we do have independent constraints.  If not, they have a
hierarchy:

      * Fully Interactive (no low power idle or suspend)
      * Partially Interactive (may go into low power idle but not
        suspend)
      * None (may go into low power idle or suspend)

Which is expressable as a ternary constraint.

James


