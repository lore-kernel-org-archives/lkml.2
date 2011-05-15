Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab1EOXhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:37:14 -0400
Received: from mail.df.lth.se ([194.47.250.12]:22975 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab1EOXhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:37:13 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Dave Jones <davej@redhat.com>
Subject: [PATCH 00/13] Ux500 PRCMU into MFD v3
Date: Mon, 16 May 2011 01:37:04 +0200
Message-Id: <1305502624-32418-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@stericsson.com>

This moves the DB8500 PRCMU core driver from the
arch/arm/mach-ux500/ dir to MFD, updates it, adds the missing
DB5500 PRCMU driver, updates some dependent register files etc,
and also updates the CPUfreq driver that use the PRCMU and moves
it to drivers/cpufreq as discussed recently.

The PRCMU driver does not do anything but mediate calls to
sub-drivers really, and later parts of the patch set breaks
out the CPUfreq and on-chip regulators to their own respective
subsystems.

We cannot avoid doing some updates to the mach-ux500/* files in
the process, but I think this turns out on the positive side
anyway, removing some 500+ lines and 6 whole files from arch/arm/*
and a much more appealing architecture.

All but the last two patches have been pushed to -next for
testing. Target is 2.6.40 indeed.

12/13 collides with cpufreq movement and need to be merged after
the cpufreq tree in the merge window.

13/13 collides with changes in the regulator tree and also use
the mfd_data per cell, so will need adjusting in the merge window
as well.

Comments/ACKs/etc requested.


Bengt Jonsson (1):
  mach-ux500: voltage domain regulators for DB8500

Linus Walleij (10):
  mach-ux500: update the DB8500 register file
  mach-ux500: update the DB5500 register file
  mach-ux500: update ASIC version detection
  mach-ux500: rename PRCMU driver per SoC
  mach-ux500: make PRCMU base address dynamic
  mach-ux500: move the DB8500 PRCMU driver to MFD
  mfd: add DB5500 PRCMU driver
  mach-ux500: move CPUfreq driver to cpufreq subsystem
  cpufreq: update DB8500 cpufreq driver
  cpufreq: make DB8500 cpufreq driver compile

Mattias Nilsson (1):
  mfd: update DB8500 PRCMU driver

Rabin Vincent (1):
  mach-ux500: update SoC and board IRQ handling

 arch/arm/mach-ux500/Kconfig                        |    3 +
 arch/arm/mach-ux500/Makefile                       |    4 +-
 arch/arm/mach-ux500/cpu-db5500.c                   |    2 +
 arch/arm/mach-ux500/cpu-db8500.c                   |    7 +
 arch/arm/mach-ux500/cpu.c                          |    7 +-
 arch/arm/mach-ux500/cpufreq.c                      |  211 --
 arch/arm/mach-ux500/include/mach/db5500-regs.h     |   20 +-
 arch/arm/mach-ux500/include/mach/db8500-regs.h     |   37 +-
 arch/arm/mach-ux500/include/mach/hardware.h        |    1 +
 arch/arm/mach-ux500/include/mach/id.h              |   20 +
 .../mach-ux500/include/mach/irqs-board-mop500.h    |    5 +
 .../arm/mach-ux500/include/mach/irqs-board-u5500.h |   21 +
 arch/arm/mach-ux500/include/mach/irqs-db5500.h     |   27 +
 arch/arm/mach-ux500/include/mach/irqs-db8500.h     |   54 +
 arch/arm/mach-ux500/include/mach/irqs.h            |   46 +-
 arch/arm/mach-ux500/include/mach/prcmu-defs.h      |   30 -
 arch/arm/mach-ux500/include/mach/prcmu-regs.h      |   96 -
 arch/arm/mach-ux500/include/mach/prcmu.h           |   28 -
 arch/arm/mach-ux500/prcmu.c                        |  394 ----
 drivers/cpufreq/Makefile                           |    1 +
 drivers/cpufreq/db8500-cpufreq.c                   |  169 ++
 drivers/mfd/Kconfig                                |   22 +-
 drivers/mfd/Makefile                               |    5 +-
 drivers/mfd/ab8500-i2c.c                           |    3 +-
 drivers/mfd/db5500-prcmu-regs.h                    |  115 ++
 drivers/mfd/db5500-prcmu.c                         |  448 +++++
 drivers/mfd/db8500-prcmu-regs.h                    |  166 ++
 drivers/mfd/db8500-prcmu.c                         | 2069 ++++++++++++++++++++
 drivers/regulator/Kconfig                          |    7 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/db8500-prcmu.c                   |  560 ++++++
 include/linux/mfd/db5500-prcmu.h                   |   45 +
 include/linux/mfd/db8500-prcmu.h                   |  978 +++++++++
 include/linux/regulator/db8500-prcmu.h             |   45 +
 34 files changed, 4848 insertions(+), 799 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/cpufreq.c
 create mode 100644 arch/arm/mach-ux500/include/mach/irqs-board-u5500.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/prcmu-defs.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/prcmu-regs.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/prcmu.h
 delete mode 100644 arch/arm/mach-ux500/prcmu.c
 create mode 100644 drivers/cpufreq/db8500-cpufreq.c
 create mode 100644 drivers/mfd/db5500-prcmu-regs.h
 create mode 100644 drivers/mfd/db5500-prcmu.c
 create mode 100644 drivers/mfd/db8500-prcmu-regs.h
 create mode 100644 drivers/mfd/db8500-prcmu.c
 create mode 100644 drivers/regulator/db8500-prcmu.c
 create mode 100644 include/linux/mfd/db5500-prcmu.h
 create mode 100644 include/linux/mfd/db8500-prcmu.h
 create mode 100644 include/linux/regulator/db8500-prcmu.h

-- 
1.7.4.4

