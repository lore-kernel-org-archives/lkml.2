Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964775Ab2KHVCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:02:15 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60033 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab2KHVCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:02:08 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH 00/11] arch_gettimeoffset and ARM timer rework
Date: Thu,  8 Nov 2012 14:01:44 -0700
Message-Id: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The overall aim of this series is to allow ARM (or indeed any) timer
drivers to be moved into drivers/clocksource without requiring a
struct or function prototype for each individual driver in include/linux.
The intent is eventually to create a single e.g. of_clocksource_init()
function that determines which timer driver to initialize by scanning
the device dtree, much like the proposed irqchip_init() at:
http://www.spinics.net/lists/arm-kernel/msg203686.html

This requires some rework prior to implementing of_clocksource_init():

ARM uses struct sys_timer to represent the individual machine's timer
driver. Many of the patches in this series are ARM-specific changes to
get rid of this struct, leaving just a single init function instead.

One function pointer in the struct provides the implementation of
arch_gettimeoffset(). Removing the struct and moving drivers into the
generic drivers/clocksource directory requires an arch-agnostic way of
registering the implementation of this function. The first few patches
in the series provide that, and rework various architectures to make use
of this facility rather than implementing the same thing themselves.

It would probably be easiest to merge this whole series through the
arm-soc tree. Anything else would require some co-ordination.

Stephen Warren (11):
  cris: move usec/nsec conversion to do_slow_gettimeoffset
  time: convert arch_gettimeoffset to a pointer
  m68k: set arch_gettimeoffset directly
  ARM: set arch_gettimeoffset directly
  ARM: at91: convert timer suspend/resume to clock_event_device
  ARM: pxa: convert timer suspend/resume to clock_event_device
  ARM: sa1100: convert timer suspend/resume to clock_event_device
  ARM: ux500: convert timer suspend/resume to clock_event_device
  ARM: samsung: register syscore_ops for timer resume directly
  ARM: remove struct sys_timer suspend and resume fields
  ARM: delete struct sys_timer

 arch/arm/include/asm/mach/arch.h       |    3 +-
 arch/arm/include/asm/mach/time.h       |   30 ------------
 arch/arm/kernel/time.c                 |   53 +----------------------
 arch/arm/mach-at91/at91sam926x_time.c  |   47 +++++++++++---------
 arch/arm/mach-at91/at91x40_time.c      |    8 ++-
 arch/arm/mach-ebsa110/core.c           |    7 ++-
 arch/arm/mach-ep93xx/core.c            |   23 +++++-----
 arch/arm/mach-h720x/common.c           |    6 +-
 arch/arm/mach-h720x/common.h           |    2 +-
 arch/arm/mach-h720x/cpu-h7201.c        |    3 +-
 arch/arm/mach-h720x/cpu-h7202.c        |    3 +-
 arch/arm/mach-pxa/time.c               |   76 ++++++++++++++++----------------
 arch/arm/mach-rpc/time.c               |    6 +-
 arch/arm/mach-sa1100/time.c            |   66 ++++++++++++++--------------
 arch/arm/mach-tegra/board-dt-tegra20.c |    2 +-
 arch/arm/mach-tegra/board-dt-tegra30.c |    2 +-
 arch/arm/mach-tegra/board.h            |    2 +-
 arch/arm/mach-tegra/timer.c            |    6 +--
 arch/arm/mach-ux500/timer.c            |    7 ---
 arch/arm/plat-samsung/time.c           |   14 ++++--
 arch/blackfin/kernel/time.c            |    6 ++-
 arch/cris/arch-v10/kernel/time.c       |   10 +++--
 arch/cris/kernel/time.c                |   11 -----
 arch/m32r/kernel/time.c                |    4 +-
 arch/m68k/amiga/config.c               |   10 ++--
 arch/m68k/apollo/config.c              |    9 ++--
 arch/m68k/atari/config.c               |    4 +-
 arch/m68k/atari/time.c                 |    6 +-
 arch/m68k/bvme6000/config.c            |   10 ++--
 arch/m68k/hp300/config.c               |    2 +-
 arch/m68k/hp300/time.c                 |    4 +-
 arch/m68k/hp300/time.h                 |    2 +-
 arch/m68k/include/asm/machdep.h        |    2 +-
 arch/m68k/kernel/setup_mm.c            |    1 -
 arch/m68k/kernel/time.c                |   15 ++----
 arch/m68k/mac/config.c                 |    4 +-
 arch/m68k/mac/via.c                    |    4 +-
 arch/m68k/mvme147/config.c             |    8 ++--
 arch/m68k/mvme16x/config.c             |    8 ++--
 arch/m68k/q40/config.c                 |    8 ++--
 arch/m68k/sun3/config.c                |    4 +-
 arch/m68k/sun3/intersil.c              |    4 +-
 arch/m68k/sun3x/config.c               |    2 +-
 arch/m68k/sun3x/time.c                 |    2 +-
 arch/m68k/sun3x/time.h                 |    2 +-
 drivers/clocksource/nomadik-mtu.c      |   33 ++++++++-----
 include/linux/time.h                   |    4 +-
 kernel/time/timekeeping.c              |   20 +++++++-
 48 files changed, 249 insertions(+), 316 deletions(-)

