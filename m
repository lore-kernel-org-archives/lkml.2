Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab1ERVdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:33:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:54546 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab1ERVdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:33:41 -0400
Message-Id: <20110518210136.003081882@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 21:33:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>
Subject: [patch 1/7] clocksource: Restructure clocksource struct members
References: <20110518205713.947614271@linutronix.de>
Content-Disposition: inline; filename=clocksource-better-layout.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group the hot path members of struct clocksource together so we have a
better cache line footprint. Make it cacheline aligned.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/clocksource.h |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

Index: linux-2.6-tip/include/linux/clocksource.h
===================================================================
--- linux-2.6-tip.orig/include/linux/clocksource.h
+++ linux-2.6-tip/include/linux/clocksource.h
@@ -159,42 +159,38 @@ extern u64 timecounter_cyc2time(struct t
  */
 struct clocksource {
 	/*
-	 * First part of structure is read mostly
+	 * Hotpath data, fits in a single cache line when the
+	 * clocksource itself is cacheline aligned.
 	 */
-	const char *name;
-	struct list_head list;
-	int rating;
 	cycle_t (*read)(struct clocksource *cs);
-	int (*enable)(struct clocksource *cs);
-	void (*disable)(struct clocksource *cs);
+	cycle_t cycle_last;
 	cycle_t mask;
 	u32 mult;
 	u32 shift;
 	u64 max_idle_ns;
-	unsigned long flags;
-	cycle_t (*vread)(void);
-	void (*suspend)(struct clocksource *cs);
-	void (*resume)(struct clocksource *cs);
+
 #ifdef CONFIG_IA64
 	void *fsys_mmio;        /* used by fsyscall asm code */
 #define CLKSRC_FSYS_MMIO_SET(mmio, addr)      ((mmio) = (addr))
 #else
 #define CLKSRC_FSYS_MMIO_SET(mmio, addr)      do { } while (0)
 #endif
-
-	/*
-	 * Second part is written at each timer interrupt
-	 * Keep it in a different cache line to dirty no
-	 * more than one cache line.
-	 */
-	cycle_t cycle_last ____cacheline_aligned_in_smp;
+	const char *name;
+	struct list_head list;
+	int rating;
+	cycle_t (*vread)(void);
+	int (*enable)(struct clocksource *cs);
+	void (*disable)(struct clocksource *cs);
+	unsigned long flags;
+	void (*suspend)(struct clocksource *cs);
+	void (*resume)(struct clocksource *cs);
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
 	struct list_head wd_list;
 	cycle_t wd_last;
 #endif
-};
+} ____cacheline_aligned;
 
 /*
  * Clock source flags bits::


