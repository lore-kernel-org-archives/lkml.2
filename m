Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1A0O7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:59:23 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:34891 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752041Ab1A0O7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:59:21 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18YlWolEqYYcYdW6Fy3GT//HJ9NGdmakOBgwHLhSL
	zdKfQNjOaklRu3
Subject: [PATCH v2 05/20] alpha: change do_timer() to xtime_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        hch@infradead.org, yong.zhang0@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>, Matt Turner <mattst88@gmail.com>,
        Richard Henderson <rth@twiddle.net>
Date: Thu, 27 Jan 2011 15:59:15 +0100
Message-ID: <20110127145915.23248.20919.stgit@localhost>
In-Reply-To: <20110127145741.23248.68098.stgit@localhost>
References: <20110127145741.23248.68098.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_update() takes the xtime_lock itself.
state does not to be protected with this lock.
its only touched here and during init.

Cc: Richard Henderson <rth@twiddle.net>
Cc:Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
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

