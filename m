Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760Ab1FATt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:49:56 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59165 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759685Ab1FATrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:47:45 -0400
Message-Id: <20110601180610.762763451@duck.linux-mips.net>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 19:05:06 +0100
From: ralf@linux-mips.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>
Subject: [patch 10/14] i8253: x86: Consolidate definitions of global_clock_event
References: <20110601180456.801265664@duck.linux-mips.net>
Content-Disposition: inline; filename=i8253-cleanup-x86-global_clock_event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are multiple declarations of global_clock_event in header files
specific to particular clock event implementatiosn.  Consolidate them
in <asm/time.h> and make sure all users include that header.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: "Venkatesh Pallipadi (Venki)" <venki@google.com>

 arch/x86/include/asm/apb_timer.h |    1 -
 arch/x86/include/asm/i8253.h     |    2 --
 arch/x86/include/asm/time.h      |    6 ++++--
 arch/x86/kernel/apb_timer.c      |    1 +
 arch/x86/kernel/apic/apic.c      |    1 +
 arch/x86/kernel/hpet.c           |    1 +
 arch/x86/kernel/i8253.c          |    1 +
 7 files changed, 8 insertions(+), 5 deletions(-)

Index: linux-mips/arch/x86/include/asm/apb_timer.h
===================================================================
--- linux-mips.orig/arch/x86/include/asm/apb_timer.h
+++ linux-mips/arch/x86/include/asm/apb_timer.h
@@ -50,7 +50,6 @@
 #define APBT_DEV_USED  1
 
 extern void apbt_time_init(void);
-extern struct clock_event_device *global_clock_event;
 extern unsigned long apbt_quick_calibrate(void);
 extern int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu);
 extern void apbt_setup_secondary_clock(void);
Index: linux-mips/arch/x86/include/asm/i8253.h
===================================================================
--- linux-mips.orig/arch/x86/include/asm/i8253.h
+++ linux-mips/arch/x86/include/asm/i8253.h
@@ -3,8 +3,6 @@
 
 #define PIT_LATCH	LATCH
 
-extern struct clock_event_device *global_clock_event;
-
 extern void setup_pit_timer(void);
 
 #endif /* _ASM_X86_I8253_H */
Index: linux-mips/arch/x86/include/asm/time.h
===================================================================
--- linux-mips.orig/arch/x86/include/asm/time.h
+++ linux-mips/arch/x86/include/asm/time.h
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
Index: linux-mips/arch/x86/kernel/apb_timer.c
===================================================================
--- linux-mips.orig/arch/x86/kernel/apb_timer.c
+++ linux-mips/arch/x86/kernel/apb_timer.c
@@ -44,6 +44,7 @@
 #include <asm/fixmap.h>
 #include <asm/apb_timer.h>
 #include <asm/mrst.h>
+#include <asm/time.h>
 
 #define APBT_MASK			CLOCKSOURCE_MASK(32)
 #define APBT_SHIFT			22
Index: linux-mips/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-mips.orig/arch/x86/kernel/apic/apic.c
+++ linux-mips/arch/x86/kernel/apic/apic.c
@@ -48,6 +48,7 @@
 #include <asm/hpet.h>
 #include <asm/idle.h>
 #include <asm/mtrr.h>
+#include <asm/time.h>
 #include <asm/smp.h>
 #include <asm/mce.h>
 #include <asm/tsc.h>
Index: linux-mips/arch/x86/kernel/hpet.c
===================================================================
--- linux-mips.orig/arch/x86/kernel/hpet.c
+++ linux-mips/arch/x86/kernel/hpet.c
@@ -14,6 +14,7 @@
 
 #include <asm/fixmap.h>
 #include <asm/hpet.h>
+#include <asm/time.h>
 
 #define HPET_MASK			CLOCKSOURCE_MASK(32)
 
Index: linux-mips/arch/x86/kernel/i8253.c
===================================================================
--- linux-mips.orig/arch/x86/kernel/i8253.c
+++ linux-mips/arch/x86/kernel/i8253.c
@@ -14,6 +14,7 @@
 #include <linux/io.h>
 
 #include <asm/hpet.h>
+#include <asm/time.h>
 #include <asm/smp.h>
 
 /*


