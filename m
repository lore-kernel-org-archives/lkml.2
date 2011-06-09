Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab1FILUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:20:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:57152 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757287Ab1FILUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:20:00 -0400
Date: Thu, 9 Jun 2011 11:19:53 GMT
From: tip-bot for Ralf Baechle <ralf@linux-mips.org>
Message-ID: <tip-219c54629c73323ddd5281de1bb1dfe0004185dd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ralf@linux-mips.org, tglx@linutronix.de, venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, tglx@linutronix.de, venki@google.com
In-Reply-To: <20110601180610.762763451@duck.linux-mips.net>
References: <20110601180610.762763451@duck.linux-mips.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] x86: i8253: Consolidate definitions of global_clock_event
Git-Commit-ID: 219c54629c73323ddd5281de1bb1dfe0004185dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 11:19:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  219c54629c73323ddd5281de1bb1dfe0004185dd
Gitweb:     http://git.kernel.org/tip/219c54629c73323ddd5281de1bb1dfe0004185dd
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Wed, 1 Jun 2011 19:05:06 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jun 2011 12:03:51 +0200

x86: i8253: Consolidate definitions of global_clock_event

There are multiple declarations of global_clock_event in header files
specific to particular clock event implementations.  Consolidate them
in <asm/time.h> and make sure all users include that header.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Venkatesh Pallipadi (Venki) <venki@google.com>
Link: http://lkml.kernel.org/r/20110601180610.762763451@duck.linux-mips.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/apb_timer.h |    1 -
 arch/x86/include/asm/i8253.h     |    2 --
 arch/x86/include/asm/time.h      |    6 ++++--
 arch/x86/kernel/apb_timer.c      |    1 +
 arch/x86/kernel/apic/apic.c      |    1 +
 arch/x86/kernel/hpet.c           |    1 +
 arch/x86/kernel/i8253.c          |    1 +
 7 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/apb_timer.h b/arch/x86/include/asm/apb_timer.h
index 2fefa50..963f7d4 100644
--- a/arch/x86/include/asm/apb_timer.h
+++ b/arch/x86/include/asm/apb_timer.h
@@ -50,7 +50,6 @@
 #define APBT_DEV_USED  1
 
 extern void apbt_time_init(void);
-extern struct clock_event_device *global_clock_event;
 extern unsigned long apbt_quick_calibrate(void);
 extern int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu);
 extern void apbt_setup_secondary_clock(void);
diff --git a/arch/x86/include/asm/i8253.h b/arch/x86/include/asm/i8253.h
index 20480ce..3d5f5ee 100644
--- a/arch/x86/include/asm/i8253.h
+++ b/arch/x86/include/asm/i8253.h
@@ -3,8 +3,6 @@
 
 #define PIT_LATCH	LATCH
 
-extern struct clock_event_device *global_clock_event;
-
 extern void setup_pit_timer(void);
 
 #endif /* _ASM_X86_I8253_H */
diff --git a/arch/x86/include/asm/time.h b/arch/x86/include/asm/time.h
index 7bdec4e..92b8aec 100644
--- a/arch/x86/include/asm/time.h
+++ b/arch/x86/include/asm/time.h
@@ -1,10 +1,12 @@
 #ifndef _ASM_X86_TIME_H
 #define _ASM_X86_TIME_H
 
-extern void hpet_time_init(void);
-
+#include <linux/clocksource.h>
 #include <asm/mc146818rtc.h>
 
+extern void hpet_time_init(void);
 extern void time_init(void);
 
+extern struct clock_event_device *global_clock_event;
+
 #endif /* _ASM_X86_TIME_H */
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 289e928..2b6630d 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -44,6 +44,7 @@
 #include <asm/fixmap.h>
 #include <asm/apb_timer.h>
 #include <asm/mrst.h>
+#include <asm/time.h>
 
 #define APBT_MASK			CLOCKSOURCE_MASK(32)
 #define APBT_SHIFT			22
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f3c3784..9da0dc0 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -48,6 +48,7 @@
 #include <asm/hpet.h>
 #include <asm/idle.h>
 #include <asm/mtrr.h>
+#include <asm/time.h>
 #include <asm/smp.h>
 #include <asm/mce.h>
 #include <asm/tsc.h>
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 85b8a8a..0f4b065 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -14,6 +14,7 @@
 
 #include <asm/fixmap.h>
 #include <asm/hpet.h>
+#include <asm/time.h>
 
 #define HPET_MASK			CLOCKSOURCE_MASK(32)
 
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 9c92b6f..5783e6d 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -14,6 +14,7 @@
 #include <linux/io.h>
 
 #include <asm/hpet.h>
+#include <asm/time.h>
 #include <asm/smp.h>
 
 /*
