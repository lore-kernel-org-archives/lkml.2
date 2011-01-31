Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab1AaOKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:10:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:42629 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab1AaOKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:10:19 -0500
Date: Mon, 31 Jan 2011 14:09:48 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sammy@sammy.net, peterz@infradead.org, torbenh@gmx.de,
        geert@linux-m68k.org, gerg@uclinux.org, tglx@linutronix.de,
        zippel@linux-m68k.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sammy@sammy.net, peterz@infradead.org, torbenh@gmx.de,
        geert@linux-m68k.org, gerg@uclinux.org, zippel@linux-m68k.org,
        tglx@linutronix.de
In-Reply-To: <20110127150006.23248.71790.stgit@localhost>
References: <20110127150006.23248.71790.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] m68k: Switch do_timer() to xtime_update()
Message-ID: <tip-e53f276beb655c711a5d1f25f800b61aa976e34f@git.kernel.org>
Git-Commit-ID: e53f276beb655c711a5d1f25f800b61aa976e34f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:09:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e53f276beb655c711a5d1f25f800b61aa976e34f
Gitweb:     http://git.kernel.org/tip/e53f276beb655c711a5d1f25f800b61aa976e34f
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 16:00:06 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:46 +0100

m68k: Switch do_timer() to xtime_update()

xtime_update() properly takes the xtime_lock

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Sam Creasey <sammy@sammy.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: hch@infradead.org
Cc: yong.zhang0@gmail.com
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
LKML-Reference: <20110127150006.23248.71790.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 
