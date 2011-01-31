Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1AaOG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:06:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:46519 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609Ab1AaOGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:06:25 -0500
Date: Mon, 31 Jan 2011 14:05:55 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, torbenh@gmx.de, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, mattst88@gmail.com, peterz@infradead.org,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net
In-Reply-To: <20110127145915.23248.20919.stgit@localhost>
References: <20110127145915.23248.20919.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] alpha: Change do_timer() to xtime_update()
Message-ID: <tip-1340f3e0b29b745a33f431455c3a37f48197bc81@git.kernel.org>
Git-Commit-ID: 1340f3e0b29b745a33f431455c3a37f48197bc81
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:05:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1340f3e0b29b745a33f431455c3a37f48197bc81
Gitweb:     http://git.kernel.org/tip/1340f3e0b29b745a33f431455c3a37f48197bc81
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 15:59:15 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:43 +0100

alpha: Change do_timer() to xtime_update()

xtime_update() takes the xtime_lock itself.

timer_interrupt() is only called on the boot cpu. See do_entInt(). So
"state" in timer_interrupt does not require protection by xtime_lock.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: hch@infradead.org
Cc: yong.zhang0@gmail.com
LKML-Reference: <20110127145915.23248.20919.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
