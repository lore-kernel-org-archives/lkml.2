Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab1AaOKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:10:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:42652 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab1AaOKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:10:54 -0500
Date: Mon, 31 Jan 2011 14:10:36 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de,
        davem@davemloft.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de,
        davem@davemloft.net
In-Reply-To: <20110127150022.23248.80369.stgit@localhost>
References: <20110127150022.23248.80369.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] sparc: Switch do_timer() to xtime_update()
Message-ID: <tip-4ea1b72551d052a3993ef72ce06ecf5bdd125859@git.kernel.org>
Git-Commit-ID: 4ea1b72551d052a3993ef72ce06ecf5bdd125859
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:10:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ea1b72551d052a3993ef72ce06ecf5bdd125859
Gitweb:     http://git.kernel.org/tip/4ea1b72551d052a3993ef72ce06ecf5bdd125859
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 16:00:22 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:46 +0100

sparc: Switch do_timer() to xtime_update()

xtime_update() takes the xtime_lock itself.

pcic_clear_clock_irq() and clear_clock_irq do not need
to be protected by xtime_lock.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: hch@infradead.org
Cc: yong.zhang0@gmail.com
LKML-Reference: <20110127150022.23248.80369.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
