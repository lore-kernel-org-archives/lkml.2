Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab1FILRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:17:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:41162 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab1FILRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:17:40 -0400
Date: Thu, 9 Jun 2011 11:17:15 GMT
From: tip-bot for Ralf Baechle <ralf@linux-mips.org>
Message-ID: <tip-78efffd9d7f2a988afecf0c281da3fac3d195120@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, linux@arm.linux.org.uk, tglx@linutronix.de
In-Reply-To: <20110601180610.221426078@duck.linux-mips.net>
References: <20110601180610.221426078@duck.linux-mips.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] i8253: Consolidate all kernel definitions of i8253_lock
Git-Commit-ID: 78efffd9d7f2a988afecf0c281da3fac3d195120
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 11:17:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78efffd9d7f2a988afecf0c281da3fac3d195120
Gitweb:     http://git.kernel.org/tip/78efffd9d7f2a988afecf0c281da3fac3d195120
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Wed, 1 Jun 2011 19:04:59 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jun 2011 12:03:49 +0200

i8253: Consolidate all kernel definitions of i8253_lock

Move them to drivers/clocksource/i8253.c and remove the
implementations in arch/

[ tglx: Avoid the extra file in lib - folded arch patches in. The
  export will become conditional in a later step ]

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Link: http://lkml.kernel.org/r/20110601180610.221426078@duck.linux-mips.net
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/arm/mach-footbridge/isa-timer.c |    2 --
 arch/mips/kernel/i8253.c             |    3 ---
 arch/x86/kernel/i8253.c              |    3 ---
 drivers/clocksource/Kconfig          |    6 ++++++
 drivers/clocksource/Makefile         |    2 +-
 drivers/clocksource/i8253.c          |   13 ++++++++++++-
 init/Kconfig                         |    1 +
 7 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-footbridge/isa-timer.c b/arch/arm/mach-footbridge/isa-timer.c
index 3c7367b..71fd96d 100644
--- a/arch/arm/mach-footbridge/isa-timer.c
+++ b/arch/arm/mach-footbridge/isa-timer.c
@@ -19,8 +19,6 @@
 
 #include "common.h"
 
-DEFINE_RAW_SPINLOCK(i8253_lock);
-
 static void pit_set_mode(enum clock_event_mode mode,
 	struct clock_event_device *evt)
 {
diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index 82b5a9f..3d2ff57 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -16,9 +16,6 @@
 #include <asm/io.h>
 #include <asm/time.h>
 
-DEFINE_RAW_SPINLOCK(i8253_lock);
-EXPORT_SYMBOL(i8253_lock);
-
 /*
  * Initialize the PIT timer.
  *
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 3235550..9c92b6f 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -16,9 +16,6 @@
 #include <asm/hpet.h>
 #include <asm/smp.h>
 
-DEFINE_RAW_SPINLOCK(i8253_lock);
-EXPORT_SYMBOL(i8253_lock);
-
 /*
  * HPET replaces the PIT, when enabled. So we need to know, which of
  * the two timers is used
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 96c9219..330343b 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -1,5 +1,11 @@
 config CLKSRC_I8253
 	bool
 
+config I8253_LOCK
+	bool
+
+config CLKBLD_I8253
+	def_bool y if CLKSRC_I8253 || I8253_LOCK
+
 config CLKSRC_MMIO
 	bool
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index b995942..7922a0c 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -6,5 +6,5 @@ obj-$(CONFIG_CS5535_CLOCK_EVENT_SRC)	+= cs5535-clockevt.o
 obj-$(CONFIG_SH_TIMER_CMT)	+= sh_cmt.o
 obj-$(CONFIG_SH_TIMER_MTU2)	+= sh_mtu2.o
 obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
-obj-$(CONFIG_CLKSRC_I8253)	+= i8253.o
+obj-$(CONFIG_CLKBLD_I8253)	+= i8253.o
 obj-$(CONFIG_CLKSRC_MMIO)	+= mmio.o
diff --git a/drivers/clocksource/i8253.c b/drivers/clocksource/i8253.c
index 33735eb..e594f52 100644
--- a/drivers/clocksource/i8253.c
+++ b/drivers/clocksource/i8253.c
@@ -6,10 +6,20 @@
 #include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/timex.h>
-
+#include <linux/module.h>
 #include <linux/i8253.h>
 
 /*
+ * Protects access to I/O ports
+ *
+ * 0040-0043 : timer0, i8253 / i8254
+ * 0061-0061 : NMI Control Register which contains two speaker control bits.
+ */
+DEFINE_RAW_SPINLOCK(i8253_lock);
+EXPORT_SYMBOL(i8253_lock);
+
+#ifdef CONFIG_CLKSRC_I8253
+/*
  * Since the PIT overflows every tick, its not very useful
  * to just read by itself. So use jiffies to emulate a free
  * running counter:
@@ -86,3 +96,4 @@ int __init clocksource_i8253_init(void)
 {
 	return clocksource_register_hz(&i8253_cs, PIT_TICK_RATE);
 }
+#endif
diff --git a/init/Kconfig b/init/Kconfig
index ebafac4..2d2ef44 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1002,6 +1002,7 @@ config ELF_CORE
 config PCSPKR_PLATFORM
 	bool "Enable PC-Speaker support" if EXPERT
 	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
+	select I8253_LOCK
 	default y
 	help
           This option allows to disable the internal PC-Speaker
