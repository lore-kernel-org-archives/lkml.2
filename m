Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab1CaOwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:52:55 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57377 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015Ab1CaOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [RFC PATCH 00/21] IIO: Channel registration rework, buffer chardev combining and rewrite of triggers as 'virtual' irq_chips.
Date: Thu, 31 Mar 2011 15:53:54 +0100
Message-Id: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I'm afraid what in many ways makes sense as three separate
series have gotten rather intertwined.  I can probably unpick
them but it will involve a lot of intermediate code in
lis3l02dq (which is our fiddly example for this set) that I'd
rather avoid.  Hence lets have a guide to what various people
might be interested in:

1) Channel registration rework (this has previous been in linux-iio
   but really comes into it's own after we remove various special
   cases later in this code).

   Patches 1, 2, 3, 21
   (8) - cleanups Arnd Bergmann pointed out in passing.
   
2) Flattening together of (some) of the chardevs (buffer related ones).
   As Arnd pointed out, there is really a use case for having multiple
   watershed type events from ring buffers.  Much better to have a
   single one (be that at a controllable point).  Firstly this removes
   the need for the event escalation code.  Second, this single 'event'
   can then be indicated to user space purely using polling on the
   access chrdev.  This approach does need an additional attribute to
   tell user space what the poll succeeding indicates (tbd).

   I haven't for now merged the ring handling with the more general
   event handling as Arnd suggested.  This is for two reasons
   1) It's much easier to debug this done in a couple of steps
   2) The approach Arnd suggested may work well, but it is rather
   different to how other bits of the kernel pass event type data
   to user space.  It's an interesting idea, but I'd rather any
   discussion of that approach was separate from the obviously
   big gains seen here.

   Patches 4, 5, 6, 7, 17

3) Reworking the triggering infrastructure to use 'virtual' irq_chips
   This approach was suggested by Thomas Gleixner.

   Before we had explicit trigger consumer lists.  This made for a very
   clunky implementation when we considered moving things over to
   threaded interrupts.  Thomas pointed out we were reinventing the
   wheel and suggested more or less what we have here (I hope ;)

   Patches 9 and 10 are minor rearrangements of code in the one
   driver I know of where the physical interrupt line for events
   is the same as that for data ready signals (though not at the
   same time).

   In a rare situation we have complete control of these virtual
   interrupts within the subsystem.  As such we want to be able to
   continue to build the subsystem as a module.  This requires a
   couple of additional exports in the generic irq core code and
   also arm (for my test board anyway).
   Patches 13 and 14 make these changes.  I hope they won't prove
   to controversial.

   Patch 15 adds a board info built in element to the IIO subsystem
   so we have a means of platform data telling us what interrupt
   numbers are available for us to play with.  Does anyone have
   a better way of doing this?  Patch 16 is an example of what
   needs to go in board files.

   18, 19 move lis3l02dq over to the threaded interrupts.

   20 rips out the old approach.  Until this patch current drivers
   using the old system should still work. I make no guarantees
   about combining consumers of both types though!


Note that this series sits on top of the cleanup series:
[PATCH 0/8] staging:iio:mixed bag of fixes and cleanups
http://marc.info/?l=linux-iio&m=130039556909192&w=2
on top of staging-next (which right now might mean mainline is
also fine).

There are clearly corners to be cleaned up and exact interfaces
elements to be pinned down, but I'd like to get some opinions
on what we have here.

All comments welcomed!

Note, wrt to the recent discussion on a strategy for moving IIO
out of staging, my intent is to pin down these big changes before
we attempt to move these elements out.  Note that the initial
steps of that move may occur in parallel with these changes.

Some of these patches may only be applied during that move as
that is a sensible point to update and test every driver.

Thanks to Arnd and Thomas for their contributions to this.

Jonathan      

Jonathan Cameron (21):
  staging:iio: allow channels to be set up using a table of
    iio_channel_spec structures.
  staging:iio:lis3l02dq - experimental move to new channel_spec
    approach.
  staging:iio:max1363 - experimental move to channel_spec registration.
  staging:iio: remove ability to escalate events.
  staging:iio: Add polling of events on the ring access chrdev.
  staging:iio: remove legacy event chrdev for the buffers
  staging:iio: Buffer device flattening.
  staging:iio:lis3l02dq: General cleanup
  staging:iio: Push interrupt setup down into the drivers for event
    lines.
  staging:iio: lis3l02dq - separate entirely interrupt handling for
    thesholds from that for the datardy signal.
  staging:iio: Remove legacy event handling.
  staging:iio:lis3l02dq make threshold interrupt threaded.
  arm: irq: export set flags
  irq: export handle_simple_irq and irq_to_desc to allow for virtual
    irqs in IIO
  staging:iio: Add infrastructure for irq_chip based triggers
  stargate2 - add an IIO interrupt pool
  staging:iio:Documentation generic_buffer.c update to new abi for
    buffers.
  staging:iio:ring_sw add function needed for threaded irq.
  staging:iio:lis3l02dq move to threaded trigger handling.
  staging:iio:trigger remove legacy pollfunc elements.
  staging:iio: rip out scan_el attributes.  Now handled as
    iio_dev_attrs like everything else.

 arch/arm/kernel/irq.c                              |    1 +
 arch/arm/mach-pxa/stargate2.c                      |    6 +-
 drivers/staging/Makefile                           |    2 +-
 drivers/staging/iio/Documentation/generic_buffer.c |   53 +-
 drivers/staging/iio/Kconfig                        |   12 +
 drivers/staging/iio/Makefile                       |    2 +
 drivers/staging/iio/accel/lis3l02dq.h              |   25 +-
 drivers/staging/iio/accel/lis3l02dq_core.c         |  700 +++++-------
 drivers/staging/iio/accel/lis3l02dq_ring.c         |  421 +++----
 drivers/staging/iio/adc/max1363.h                  |    8 +-
 drivers/staging/iio/adc/max1363_core.c             | 1277 ++++++++------------
 drivers/staging/iio/adc/max1363_ring.c             |    1 -
 drivers/staging/iio/chrdev.h                       |   33 +-
 drivers/staging/iio/iio-board-info.h               |   24 +
 drivers/staging/iio/iio-core.h                     |   13 +
 drivers/staging/iio/iio.h                          |  250 +++--
 drivers/staging/iio/industrialio-board-info.c      |   25 +
 drivers/staging/iio/industrialio-core.c            |  724 ++++++++---
 drivers/staging/iio/industrialio-ring.c            |  315 +++---
 drivers/staging/iio/industrialio-trigger.c         |  150 ++--
 drivers/staging/iio/ring_generic.h                 |   79 +-
 drivers/staging/iio/ring_sw.c                      |   42 +-
 drivers/staging/iio/ring_sw.h                      |    1 +
 drivers/staging/iio/sysfs.h                        |  152 +--
 drivers/staging/iio/trigger.h                      |   68 +-
 kernel/irq/chip.c                                  |    1 +
 kernel/irq/irqdesc.c                               |    1 +
 27 files changed, 2116 insertions(+), 2270 deletions(-)
 create mode 100644 drivers/staging/iio/iio-board-info.h
 create mode 100644 drivers/staging/iio/iio-core.h
 create mode 100644 drivers/staging/iio/industrialio-board-info.c

-- 
1.7.3.4

