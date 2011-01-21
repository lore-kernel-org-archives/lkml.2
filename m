Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1AVAOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:14:50 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:35541 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755043Ab1AVAOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:14:48 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/MjMAPAjXMyOifTKMWAz88AfShJNbYwEdZUjGaGs
	NyMnLlsA3nQC9+
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 13/18] m68k: switch do_timer() to xtime_update()
Date: Sat, 22 Jan 2011 00:06:59 +0100
Message-Id: <1295651224-29823-14-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_update() properly takes the xtime_lock

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/m68k/bvme6000/config.c  |    4 ++--
 arch/m68k/kernel/time.c      |    4 ++--
 arch/m68k/mvme147/config.c   |    4 ++--
 arch/m68k/mvme16x/config.c   |    4 ++--
 arch/m68k/sun3/sun3ints.c    |    2 +-
 arch/m68knommu/kernel/time.c |    8 ++------
 6 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/arch/m68k/bvme6000/config.c b/arch/m68k/bvme6000/config.c
index 9fe6fef..1edd950 100644
--- a/arch/m68k/bvme6000/config.c
+++ b/arch/m68k/bvme6000/config.c
@@ -45,8 +45,8 @@ extern int bvme6000_set_clock_mmss (unsigned long);
 extern void bvme6000_reset (void);
 void bvme6000_set_vectors (void);
 
-/* Save tick handler routine pointer, will point to do_timer() in
- * kernel/sched.c, called via bvme6000_process_int() */
+/* Save tick handler routine pointer, will point to xtime_update() in
+ * kernel/timer/timekeeping.c, called via bvme6000_process_int() */
 
 static irq_handler_t tick_handler;
 
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 06438da..18b34ee 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -37,11 +37,11 @@ static inline int set_rtc_mmss(unsigned long nowtime)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 static irqreturn_t timer_interrupt(int irq, void *dummy)
 {
-	do_timer(1);
+	xtime_update(1);
 	update_process_times(user_mode(get_irq_regs()));
 	profile_tick(CPU_PROFILING);
 
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 100baaa..6cb9c3a 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -46,8 +46,8 @@ extern void mvme147_reset (void);
 
 static int bcd2int (unsigned char b);
 
-/* Save tick handler routine pointer, will point to do_timer() in
- * kernel/sched.c, called via mvme147_process_int() */
+/* Save tick handler routine pointer, will point to xtime_update() in
+ * kernel/time/timekeeping.c, called via mvme147_process_int() */
 
 irq_handler_t tick_handler;
 
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index 11edf61..0b28e26 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -51,8 +51,8 @@ extern void mvme16x_reset (void);
 
 int bcd2int (unsigned char b);
 
-/* Save tick handler routine pointer, will point to do_timer() in
- * kernel/sched.c, called via mvme16x_process_int() */
+/* Save tick handler routine pointer, will point to xtime_update() in
+ * kernel/time/timekeeping.c, called via mvme16x_process_int() */
 
 static irq_handler_t tick_handler;
 
diff --git a/arch/m68k/sun3/sun3ints.c b/arch/m68k/sun3/sun3ints.c
index 2d9e21b..6464ad3 100644
--- a/arch/m68k/sun3/sun3ints.c
+++ b/arch/m68k/sun3/sun3ints.c
@@ -66,7 +66,7 @@ static irqreturn_t sun3_int5(int irq, void *dev_id)
 #ifdef CONFIG_SUN3
 	intersil_clear();
 #endif
-        do_timer(1);
+	xtime_update(1);
 	update_process_times(user_mode(get_irq_regs()));
         if (!(kstat_cpu(0).irqs[irq] % 20))
                 sun3_leds(led_pattern[(kstat_cpu(0).irqs[irq] % 160) / 20]);
diff --git a/arch/m68knommu/kernel/time.c b/arch/m68knommu/kernel/time.c
index d6ac2a4..6623909 100644
--- a/arch/m68knommu/kernel/time.c
+++ b/arch/m68knommu/kernel/time.c
@@ -36,7 +36,7 @@ static inline int set_rtc_mmss(unsigned long nowtime)
 #ifndef CONFIG_GENERIC_CLOCKEVENTS
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 irqreturn_t arch_timer_interrupt(int irq, void *dummy)
 {
@@ -44,11 +44,7 @@ irqreturn_t arch_timer_interrupt(int irq, void *dummy)
 	if (current->pid)
 		profile_tick(CPU_PROFILING);
 
-	write_seqlock(&xtime_lock);
-
-	do_timer(1);
-
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 
 	update_process_times(user_mode(get_irq_regs()));
 
-- 
1.7.2.3

