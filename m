Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab1BJXgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:36:42 -0500
Received: from www.tglx.de ([62.245.132.106]:44005 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429Ab1BJXgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:36:37 -0500
Message-Id: <20110210222908.661199947@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:35:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-arch@vger.kernel.org,
        Linus Torvals <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 00/75] genirq: Overhaul for 2.6.39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a major overhaul of the generic interrupt layer.

     - Namespace cleanup

     - Further encapsulation of the core state

     - Spurious/Poll handling fixes

     - Stop setaffinity blindly manipulating affinity mask

     - Cleanups and enhancements all over the place

1) Namespace cleanup

   I reworked the slightly confusing (sorry, my bad) namespace of the
   various accessor functions. They follow a simple scheme now:

   irq_set/get_xxx(unsigned int irq, ...)
   irq_data_set/get_xxx(struct irq_data *d, ...)

   That's the first patch in the series and I'm going to apply it to
   a separate rc-4 based branch which everybody can pull in to
   do the changes now in his tree.

2) Encapsulation

   After __do_IRQ() was finally gone (Thanks to all involved!) I
   wanted to restructure the core status handling and cleanup the
   IRQ_* flag space.

   A quick grep over the tree made me really shudder, so I converted
   13 archs which are known to follow core changes slow to the new
   irq_chip callback functions and cleaned up the irq_desc accessors
   while at it. That way I learned also a lot about arch requirements.

   Then I looked at the remaining places which deal with
   irq_desc->status directly.

   1) Special EOI handling in sparc64/mips/sh. Easy to replace.

   2) Random abusers of chained_interrupt_handler. The worst offender
      is arch/powerpc/sysdev/fsl_msi.c, which implements a combo
      eoi/level flow handler instead of using the existing ones.

   3) Random places which quirk around their chip oddities instead of
      looking for solutions which can be made generic. One of them is
      the requirement to mask irq chips before setting the trigger
      type. Why is nobody talking to me ?

   4) Random leftovers from the __do_IRQ() semantics which are easy to
      cleanup.

   5) Initializations with IRQ_DISABLED and random IRQ_ flags.
      IRQ_DISABLED is core internal state and already set by default.
      The settable flags have to use the provided modifier functions.

   6) Weird flow handlers in m68knommu/arm/powerpc. All of them can
      be either replaced by existing handlers or can use an existing
      handler with minimal modifications. Patches are already out.

   7) Totally broken debug code in gpiolib and a copy of the same in
      some arm Soc code. Patch is in this series to kill it. Also
      remove unused code in arm/mach-tegra which seems to be some
      relict from the android mess.

   So there is no real requirement to expose the guts of the generic
   irq code to the world.

   Even if all is cleaned up, I'm tired of:

   	- Having to chase the creative abusage all the time

	- People not talking to me about their special requirements
	
	- Spending another day to find out that someone had typoed
	  desc->status |= IRQ_LEVEL; into desc->status = IRQ_LEVEL;
	  in some weird arch code and then complaining about the
	  core code playing silly buggers.

   So I decided to encapsulate the state into the core and make it
   hard to access and offenders easy to find. For now I keep the
   existing and used IRQ_* status bits up to date, unless
   GENERIC_HARDIRQS_NO_COMPAT=y which can be selected by the
   architecture. Be aware that not setting that config adds extra
   overhead to the core code.

   For all real requirements which I found, I provided solutions
   either in the core itself or information accessible via a state
   field in irq_data, which is handed to the irq_chip functions. So
   setting GENERIC_HARDIRQS_NO_COMPAT=y should be not a big deal on
   most architectures. There are some gpio and mfd drivers which need
   to be converted to threaded interrupts instead of having the old
   style racy and ugly disable_irq_nosync/schedule_work()
   implementation.

   There are a few places which need some thought like the powerpc
   kexec shutdown, but even that stuff should be generic as it makes
   sense to cleanup irqs before booting into a new kernel. Nothing
   which can't be solved though.

   Note that most accessors to irq_desc are going away sooner than
   later and long term I want to remove irq_desc from the public space
   completely.

   One step to this is a generic show_interrupts() function, which
   replaces the 23 copies with random modifications and different bugs
   inside. Unless you switch over you will be reminded by a nice
   deprecated warning.

3) Spurious/Poll 

   This is a long neglected piece of code and got an overhaul so it's
   simpler and less broken than it used to be.

4) irq_setaffinity()

   Does not longer blindly update the affinity mask before calling
   into the arch code. Also the chip functions can now return a 
   return code, which tells the core that it modified the mask
   itself. That's useful when arch code restricts the mask further
   than the core code can do.

5) Cleanups and enhancements

   Main cleanup happened in poll and the consolidation of the flow
   handlers which moved their duplicated code into handle_irq_event
   
   irq_set_type() now checks chip.flags for a chip flag, which indicates
   that the chip needs to be masked before setting the trigger type.
   That avoids duplicated code and fiddling with internal core state.

If no major outcry comes I'm going to push this into tip/irq/core and
next.

A preview is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-genirq.git irq/core

Thanks,

	tglx

