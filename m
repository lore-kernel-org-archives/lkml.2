Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1IWQC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 12:02:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41737 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754776Ab1IWQC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 12:02:56 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH v3 0/3] genirq: handling GIC per-cpu interrupts
Date: Fri, 23 Sep 2011 17:03:05 +0100
Message-Id: <1316793788-14500-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 23 Sep 2011 16:02:49.0818 (UTC) FILETIME=[3E2B2BA0:01CC7A0A]
X-MC-Unique: 111092317025203701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id p8NG3Alh005782

The current GIC per-cpu interrupts (aka PPIs) suffer from a number of
problems:

- They use a completely separate scheme to handle the interrupts,
  mostly because the PPI concept doesn't really match the kernel view
  of an interrupt.
- PPIs can only be used by the timer code, unless we add more low-level
  assembly code.
- The local timer code can only be used by devices generating PPIs,
  and not SPIs.
- At least one platform (msm) has started implementing its own
  alternative scheme.
- Some low-level code gets duplicated, as usual...

The proposed solution is to handle the PPIs using the same path as
SPIs. A new core API is added to deal with per-cpu interrupts in a
less awkward way. The local timer code is updated to reflect these
changes.

The core API changes are based on an initial idea by Thomas Gleixner.

Tested on ARM Versatile Express (Cortex A15), ARM RealView PB11MP,
OMAP4 (Panda) and Tegra (Harmony). Patch series against next-20110923.

>From v2:
- Fixed !GENERIC_HARDIRQS build
- Fixed request_percpu_irq documentation

>From v1:
- General tidy-up after Thomas' review. I've kept the config option
  for the time being until we can sort out the anonymous union
  problem.

Marc Zyngier (3):
  genirq: add support for per-cpu dev_id interrupts
  ARM: gic: consolidate PPI handling
  ARM: gic, local timers: use the request_percpu_irq() interface

 arch/arm/common/Kconfig                           |    1 +
 arch/arm/common/gic.c                             |   38 +++-
 arch/arm/include/asm/entry-macro-multi.S          |    7 -
 arch/arm/include/asm/hardirq.h                    |    3 -
 arch/arm/include/asm/hardware/entry-macro-gic.S   |   19 +--
 arch/arm/include/asm/hardware/gic.h               |    1 -
 arch/arm/include/asm/localtimer.h                 |   19 +-
 arch/arm/include/asm/smp.h                        |    5 -
 arch/arm/include/asm/smp_twd.h                    |    2 +-
 arch/arm/kernel/irq.c                             |    3 -
 arch/arm/kernel/smp.c                             |   33 +----
 arch/arm/kernel/smp_twd.c                         |   47 +++++-
 arch/arm/mach-exynos4/include/mach/entry-macro.S  |    6 +-
 arch/arm/mach-exynos4/mct.c                       |    5 -
 arch/arm/mach-msm/board-msm8x60.c                 |   11 -
 arch/arm/mach-msm/include/mach/entry-macro-qgic.S |   73 +-------
 arch/arm/mach-msm/timer.c                         |   69 ++++---
 arch/arm/mach-omap2/include/mach/entry-macro.S    |   14 +--
 arch/arm/mach-shmobile/entry-intc.S               |    3 -
 arch/arm/mach-shmobile/include/mach/entry-macro.S |    3 -
 include/linux/interrupt.h                         |   40 +++-
 include/linux/irq.h                               |   16 ++-
 include/linux/irqdesc.h                           |    1 +
 kernel/irq/Kconfig                                |    4 +
 kernel/irq/chip.c                                 |   54 ++++++
 kernel/irq/internals.h                            |    2 +
 kernel/irq/irqdesc.c                              |   25 +++
 kernel/irq/manage.c                               |  206 ++++++++++++++++++++-
 kernel/irq/settings.h                             |    7 +
 29 files changed, 468 insertions(+), 249 deletions(-)


