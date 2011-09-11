Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078Ab1IKMAB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 08:00:01 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:38222 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab1IKL77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 07:59:59 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/28 v6] m68k: Convert to genirq
Date: Sun, 11 Sep 2011 13:59:26 +0200
Message-Id: <1315742394-16036-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series converts the m68k/mmu (nommu was converted before)
architecture to the generic hardirq framework.

  - [01/28] genirq: Add missing "else" in irq_shutdown()
  - [02/28] ide-{cd,floppy,tape}: Do not include <linux/irq.>
  - [03/28] keyboard: Do not include <linux/irq.>
  - [04/28] m68k/irq: Rename irq_controller to irq_chip
  - [05/28] m68k/irq: Kill irq_node_t typedef, always use struct irq_node
  - [06/28] m68k/irq: Rename irq_node to irq_data
  - [07/28] m68k/irq: Switch irq_chip methods to "struct irq_data *data"
  - [08/28] m68k/irq: Rename setup_irq() to m68k_setup_irq() and make it static
  - [09/28] m68k/irq: Extract irq_set_chip()
  - [10/28] m68k/irq: Add m68k_setup_irq_controller()
  - [11/28] m68k/irq: Rename {,__}m68k_handle_int()
  - [12/28] m68k/irq: Remove obsolete IRQ_FLG_* definitions and users
  - [13/28] m68k/irq: Add genirq support
  - [14/28] m68k/atari: Convert Atari to genirq
  - [15/28] m68k/atari: Remove code and comments about different irq types
  - [16/28] m68k/amiga: Refactor amiints.c
  - [17/28] m68k/amiga: Convert Amiga to genirq
  - [18/28] m68k/amiga: Optimize interrupts using chain handlers
  - [19/28] m68k/mac: Convert Mac to genirq
  - [20/28] m68k/mac: Optimize interrupts using chain handlers
  - [21/28] m68k/hp300: Convert HP9000/300 and HP9000/400 to genirq
  - [22/28] m68k/vme: Convert VME to genirq
  - [23/28] m68k/apollo: Convert Apollo to genirq
  - [24/28] m68k/sun3: Use the kstat_irqs_cpu() wrapper
  - [25/28] m68k/sun3: Convert Sun3/3x to genirq
  - [26/28] m68k/q40: Convert Q40/Q60 to genirq
  - [27/28] m68k/irq: Remove obsolete m68k irq framework
  - [28/28] m68k/irq: Remove obsolete support for user vector interrupt fixups

Overview:
  - [01] is a fix for the core genirq code,
  - [02-03] are fixes to avoid compile problems later in the conversion
    process,
  - [04-12] refactor the current m68k irq framework to match the generic
    hardirq framework more closely w.r.t. to its (platform) users,
  - [13] adds generic hardirq support to the core, which can be enabled through
    a config option, so both legacy and generic hardirq can coexist at the
    source level during the migration,
  - [14-26] convert the individual platforms to use generic hardirqs,
  - [27] removes support for the legacy m68k irq framework,
  - [28] removes a now unused feature.

The code has received some testing on Amiga, Atari (mainly ARAnyM), and Mac.
There are some known issues with drivers, which Finn and Michael are looking
into.

I will update my m68k-genirq branch as soon as master.kernel.org is available
again.

Thanks for your comments, feedback, and testing!

Changelog:

  v6:
    - Add [01] genirq: Add missing "else" in irq_shutdown()
    - Add [27] m68k/irq: Remove obsolete m68k irq framework
    - Add [28] m68k/irq: Remove obsolete support for user vector interrupt
      fixups
    - Split off [02] ide-{cd,floppy,tape}: Do not include <linux/irq.>
    - Split off [03] keyboard: Do not include <linux/irq.>
    - Keep irq_canonicalize(), which is needed for ac3200, atari_91C111,
      serial_core, and 8250. 
    - Correct irq args of irq_set_handler_data() calls in Mac PSC chain
      handlers, as reported by Finn

  v5:
    - Add [20] m68k/mac: Optimize interrupts using chain handlers
    - Add [26] m68k/q40: Convert Q40/Q60 to genirq
    - Keep m68k_setup_auto_interrupt(), it's still needed for Q40

  v4:
    - Add [15] m68k/atari: Remove code and comments about different irq
      types
    - Add [23] m68k/apollo: Convert Apollo to genirq
    - Add [24] m68k/sun3: Use the kstat_irqs_cpu() wrapper
    - Add [25] m68k/sun3: Convert Sun3/3x to genirq

  v3:
    - Add [11] m68k/irq: Rename {,__}m68k_handle_int()
    - Add [12] m68k/irq: Remove obsolete IRQ_FLG_* definitions and users
    - Add [19] m68k/mac: Convert Mac to genirq
    - Add [21] m68k/hp300: Convert HP9000/300 and HP9000/400 to genirq
    - Add [22] m68k/vme: Convert VME to genirq
    - Use handle_simple_irq() instead of handle_level_irq(), which also
      means we don't need the .irq_{,un}mask methods anymore, so they can
      be removed again.
    - Wrapper __m68k_handle_int() for do_IRQ() is no longer needed
    - Keep track of spurious interrupts

  v2:
    - Add [10] m68k/irq: Add m68k_setup_irq_controller()
    - Add [16] m68k/amiga: Refactor amiints.c
    - Add [17] m68k/amiga: Convert Amiga to genirq
    - Add [18] m68k/amiga: Optimize interrupts using chain handlers]
    - Add missing "irq" offset in m68k_setup_irq_controller()
    - Set up default handlers for autovector interrupts, and fill in missing
      .irq_{,un}mask methods,

  v1:
    - Initial version, acked by Thomas Gleixner

 arch/m68k/Kconfig                |    4 +-
 arch/m68k/amiga/amiints.c        |  168 ++++++++------------
 arch/m68k/amiga/cia.c            |   39 +++--
 arch/m68k/apollo/dn_ints.c       |   35 +++--
 arch/m68k/atari/ataints.c        |  274 +++-----------------------------
 arch/m68k/bvme6000/config.c      |    2 +-
 arch/m68k/hp300/time.c           |    2 +-
 arch/m68k/include/asm/hardirq.h  |    5 +
 arch/m68k/include/asm/irq.h      |   82 ++--------
 arch/m68k/include/asm/q40ints.h  |    3 -
 arch/m68k/kernel/Makefile_mm     |    2 +-
 arch/m68k/kernel/entry_mm.S      |    7 +-
 arch/m68k/kernel/ints.c          |  323 ++++----------------------------------
 arch/m68k/mac/baboon.c           |   14 +-
 arch/m68k/mac/iop.c              |   10 +-
 arch/m68k/mac/macints.c          |   19 ++-
 arch/m68k/mac/oss.c              |   54 +++----
 arch/m68k/mac/psc.c              |   49 +++---
 arch/m68k/mac/via.c              |   74 ++++------
 arch/m68k/mvme147/config.c       |    5 +-
 arch/m68k/mvme16x/config.c       |    2 +-
 arch/m68k/q40/q40ints.c          |   60 ++++----
 arch/m68k/sun3/sun3ints.c        |   46 +++---
 drivers/ide/ide-cd.c             |    1 -
 drivers/ide/ide-floppy.c         |    1 -
 drivers/ide/ide-tape.c           |    1 -
 drivers/macintosh/via-macii.c    |    2 +-
 drivers/macintosh/via-maciisi.c  |    4 +-
 drivers/net/macsonic.c           |    7 +-
 drivers/scsi/mac_scsi.c          |    3 +-
 drivers/tty/serial/68360serial.c |    4 +-
 drivers/tty/vt/keyboard.c        |    3 +-
 kernel/irq/chip.c                |    2 +-
 33 files changed, 358 insertions(+), 949 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
