Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab1AUXIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:08:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:51591 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754314Ab1AUXHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:07:23 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+P+RhNXMCPBWuTwEeMGwExPJLlx/Rp9iyMa+HF6D
	g93ohF9MjCt3eT
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 03/18] alpha: change do_timer() to xtime_update()
Date: Sat, 22 Jan 2011 00:06:49 +0100
Message-Id: <1295651224-29823-4-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_update() takes the xtime_lock itself.
this code looks like its protecting state with this lock.
but this is only touched here and during init.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/alpha/kernel/time.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index c1f3e7c..a58e84f 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -159,7 +159,7 @@ void read_persistent_clock(struct timespec *ts)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 irqreturn_t timer_interrupt(int irq, void *dev)
 {
@@ -172,8 +172,6 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 	profile_tick(CPU_PROFILING);
 #endif
 
-	write_seqlock(&xtime_lock);
-
 	/*
 	 * Calculate how many ticks have passed since the last update,
 	 * including any previous partial leftover.  Save any resulting
@@ -187,9 +185,7 @@ irqreturn_t timer_interrupt(int irq, void *dev)
 	nticks = delta >> FIX_SHIFT;
 
 	if (nticks)
-		do_timer(nticks);
-
-	write_sequnlock(&xtime_lock);
+		xtime_update(nticks);
 
 	if (test_irq_work_pending()) {
 		clear_irq_work_pending();
-- 
1.7.2.3

