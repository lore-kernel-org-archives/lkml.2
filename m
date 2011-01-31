Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1AaOIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:08:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:42562 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab1AaOIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:08:32 -0500
Date: Mon, 31 Jan 2011 14:08:15 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dhowells@redhat.com, torbenh@gmx.de, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, dhowells@redhat.com, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <20110127145946.23248.57952.stgit@localhost>
References: <20110127145946.23248.57952.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] frv: Switch do_timer() to xtime_update()
Message-ID: <tip-57464bd87f708e75b47312766e3fc8dc3aaf66ad@git.kernel.org>
Git-Commit-ID: 57464bd87f708e75b47312766e3fc8dc3aaf66ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:08:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57464bd87f708e75b47312766e3fc8dc3aaf66ad
Gitweb:     http://git.kernel.org/tip/57464bd87f708e75b47312766e3fc8dc3aaf66ad
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 15:59:46 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:45 +0100

frv: Switch do_timer() to xtime_update()

__set_LEDS() does not need to be protected by xtime_lock.
its used unprotected in other places.

[ tglx: Removed stale comment ]

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: hch@infradead.org
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: David Howells <dhowells@redhat.com>
Cc: yong.zhang0@gmail.com
LKML-Reference: <20110127145946.23248.57952.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/frv/kernel/time.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index 0ddbbae..b457de4 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -50,21 +50,13 @@ static struct irqaction timer_irq  = {
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 static irqreturn_t timer_interrupt(int irq, void *dummy)
 {
 	profile_tick(CPU_PROFILING);
-	/*
-	 * Here we are in the timer irq handler. We just have irqs locally
-	 * disabled but we don't know if the timer_bh is running on the other
-	 * CPU. We need to avoid to SMP race with it. NOTE: we don't need
-	 * the irq version of write_lock because as just said we have irq
-	 * locally disabled. -arca
-	 */
-	write_seqlock(&xtime_lock);
 
-	do_timer(1);
+	xtime_update(1);
 
 #ifdef CONFIG_HEARTBEAT
 	static unsigned short n;
@@ -72,8 +64,6 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 	__set_LEDS(n);
 #endif /* CONFIG_HEARTBEAT */
 
-	write_sequnlock(&xtime_lock);
-
 	update_process_times(user_mode(get_irq_regs()));
 
 	return IRQ_HANDLED;
