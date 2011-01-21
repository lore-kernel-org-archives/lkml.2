Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab1AVAou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:44:50 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:38781 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751138Ab1AVAot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:44:49 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1/jxE01qg3jPAjCQIU6XoBC38g1ODYhMjHilc2enK
	1ceTR/X2U7Dk/F
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 16/18] sparc: switch do_timer() to xtime_update()
Date: Sat, 22 Jan 2011 00:07:02 +0100
Message-Id: <1295651224-29823-17-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_update() takes the xtime_lock itself.

i dont think that pcic_clear_clock_irq() and clear_clock_irq need
to be protected by a lock.
it might make sense to move them after xtime_update() though.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/sparc/kernel/pcic.c    |    4 +---
 arch/sparc/kernel/time_32.c |    9 ++-------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index aeaa09a..2cdc131 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -700,10 +700,8 @@ static void pcic_clear_clock_irq(void)
 
 static irqreturn_t pcic_timer_handler (int irq, void *h)
 {
-	write_seqlock(&xtime_lock);	/* Dummy, to show that we remember */
 	pcic_clear_clock_irq();
-	do_timer(1);
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 9c743b1..4211bfc 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -85,7 +85,7 @@ int update_persistent_clock(struct timespec now)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 
 #define TICK_SIZE (tick_nsec / 1000)
@@ -96,14 +96,9 @@ static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 	profile_tick(CPU_PROFILING);
 #endif
 
-	/* Protect counter clear so that do_gettimeoffset works */
-	write_seqlock(&xtime_lock);
-
 	clear_clock_irq();
 
-	do_timer(1);
-
-	write_sequnlock(&xtime_lock);
+	xtime_update(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
-- 
1.7.2.3

