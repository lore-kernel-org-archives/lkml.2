Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab0FMPca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:32:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:37777 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab0FMPcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:32:21 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Subject: [PATCHSET] irq: better lost/spurious irq handling
Date: Sun, 13 Jun 2010 17:31:26 +0200
Message-Id: <1276443098-20653-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 13 Jun 2010 15:31:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the first take of better-lost-spurious-irq-handling patchset.

IRQs can go wrong in two opposite directions.  There can be too many
or too few.  Currently, the former is handled by spurious IRQ
detection and polling (the "nobody cared" thing) and the latter by
irqpoll kernel parameter, which currently is broken on many
configurations due to tickless timer and missing IRQF_IRQPOLL.

Certain hardware classes are inherently prone to IRQ related problems.
ATA is one very good example.  When the traditional IDE interface is
used, regardless of PATA or SATA, handling of IRQ is very fragile.
There is no reliable way to tell whether the controller is raising an
interrupt or not and the driver should expect IRQ according to HSM
transitions and hope that the host controller stays in sync and does
what it's expected to do.  Occasionally but surely something goes
wrong and IRQ storm or timeout follows.  Furthermore, the IRQ is
ultimately under the control of the ATA device not the ATA controller
making things a whole lot more fragile and prone to permanent and
transient IRQ problems.

Even if the controller and hardware themselves are okay, IRQ sharing
means that any device can be a victim of rogue interrupts.  For
example, there was an I2C device for which the driver didn't use IRQ
but when the configuration is right (well, rather, wrong), its IRQ
line would assert and cause IRQ storm and there wasn't much the driver
could do to prevent that.  There's also the BIOS and OS expecting
different things especially during suspend and resume.  On my x61s
when resuming from STR something funny happens and the IRQ line for a
USB host gets stuck once in a while.

Most of these problems can be worked around much more efficiently
without adding noticeable runtime overhead or driver complexity by
using polling carefully.  This patchset improves the existing spurious
IRQ handling and implements two mechanisms to work around lost
interrupts.

Emphasis was put on making it easy to use for drivers.  Drivers only
need IRQF_SHARED on the interrupt handler and add some function calls
here and there.  Functions which can be used in hot paths are
efficient and can be called without worrying about performance
implications by virtually any driver which deals with an actual
hardware.  Except for init functions, all don't care about calling
context and won't fail catastrophically even if used incorrectly.
Also, operational parameters are predetermined and/or self regulating.

After this patchset, the following three mechanisms are in place to
deal with IRQ problems.

* IRQ expecting: Tightly coupled with controller operation.  Provides
  strong protection against most lost IRQ problems.  Applied to
  libata.

* IRQ watching: Loosely coupled with controller operation.  Provides
  protection against common lost IRQ problems (misrouting).  Applied
  to usb.

* Spurious IRQ handling: More responsive and less expensive than the
  existing implementation.  Tries to disengage after some period so
  that transient problems don't end up having prolonged effects.

With the patchset applied, my test machine works fine with IRQ routing
messed up.  By applying the mechanism to more drivers, things will
improve but, even in the current state, many systems with IRQ problems
will be able to cope with transient problems much better and install
and run the base system well enough to allow bug reporting and
debugging of persistent ones.

This patchset contains the following 12 patches.

 0001-irq-cleanup-irqfixup.patch
 0002-irq-make-spurious-poll-timer-per-desc.patch
 0003-irq-use-desc-poll_timer-for-irqpoll.patch
 0004-irq-kill-IRQF_IRQPOLL.patch
 0005-irq-misc-preparations-for-further-changes.patch
 0006-irq-implement-irq_schedule_poll.patch
 0007-irq-improve-spurious-IRQ-handling.patch
 0008-irq-implement-IRQ-watching.patch
 0009-irq-implement-IRQ-expecting.patch
 0010-irq-add-comment-about-overall-design-of-lost-spuriou.patch
 0011-libata-use-IRQ-expecting.patch
 0012-usb-use-IRQ-watching.patch

0001 is cleanup.

0002-0004 convert the existing polling mechanisms to use per-desc
timer instead of IRQF_IRQPOLL.  This is more reliable and cheaper and
easier to maintain.

0005-0006 prepare for further changes.

0007-0010 implement better lost/spurious interrupt handling
mechanisms.

0011-0012 apply them to libata and usb.

This patchset is available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git lost-spurious-irq

and contains the following changes.

 arch/arm/mach-aaec2000/core.c            |    2 
 arch/arm/mach-at91/at91rm9200_time.c     |    2 
 arch/arm/mach-at91/at91sam926x_time.c    |    2 
 arch/arm/mach-bcmring/core.c             |    2 
 arch/arm/mach-clps711x/time.c            |    2 
 arch/arm/mach-cns3xxx/core.c             |    2 
 arch/arm/mach-ebsa110/core.c             |    2 
 arch/arm/mach-ep93xx/core.c              |    2 
 arch/arm/mach-footbridge/dc21285-timer.c |    2 
 arch/arm/mach-footbridge/isa-timer.c     |    2 
 arch/arm/mach-h720x/cpu-h7201.c          |    2 
 arch/arm/mach-h720x/cpu-h7202.c          |    2 
 arch/arm/mach-integrator/integrator_ap.c |    2 
 arch/arm/mach-ixp2000/core.c             |    2 
 arch/arm/mach-ixp23xx/core.c             |    2 
 arch/arm/mach-ixp4xx/common.c            |    2 
 arch/arm/mach-lh7a40x/time.c             |    2 
 arch/arm/mach-mmp/time.c                 |    2 
 arch/arm/mach-netx/time.c                |    2 
 arch/arm/mach-ns9xxx/irq.c               |    3 
 arch/arm/mach-ns9xxx/time-ns9360.c       |    2 
 arch/arm/mach-nuc93x/time.c              |    2 
 arch/arm/mach-omap1/time.c               |    2 
 arch/arm/mach-omap1/timer32k.c           |    2 
 arch/arm/mach-omap2/timer-gp.c           |    2 
 arch/arm/mach-pnx4008/time.c             |    2 
 arch/arm/mach-pxa/time.c                 |    2 
 arch/arm/mach-sa1100/time.c              |    2 
 arch/arm/mach-shark/core.c               |    2 
 arch/arm/mach-u300/timer.c               |    2 
 arch/arm/mach-w90x900/time.c             |    2 
 arch/arm/plat-iop/time.c                 |    2 
 arch/arm/plat-mxc/time.c                 |    2 
 arch/arm/plat-samsung/time.c             |    2 
 arch/arm/plat-versatile/timer-sp.c       |    2 
 arch/blackfin/kernel/time-ts.c           |    6 
 arch/ia64/kernel/time.c                  |    2 
 arch/parisc/kernel/irq.c                 |    2 
 arch/powerpc/platforms/cell/interrupt.c  |    5 
 arch/x86/kernel/time.c                   |    2 
 drivers/ata/libata-core.c                |   15 
 drivers/ata/libata-eh.c                  |    4 
 drivers/ata/libata-sff.c                 |   37 -
 drivers/clocksource/sh_cmt.c             |    3 
 drivers/clocksource/sh_mtu2.c            |    3 
 drivers/clocksource/sh_tmu.c             |    3 
 drivers/usb/core/hcd.c                   |    1 
 include/linux/interrupt.h                |   43 -
 include/linux/irq.h                      |   40 +
 include/linux/libata.h                   |    2 
 kernel/irq/chip.c                        |   20 
 kernel/irq/handle.c                      |    7 
 kernel/irq/internals.h                   |   10 
 kernel/irq/manage.c                      |   18 
 kernel/irq/proc.c                        |    5 
 kernel/irq/spurious.c                    |  978 ++++++++++++++++++++++++++-----
 56 files changed, 1008 insertions(+), 269 deletions(-)

Thanks.

--
tejun
