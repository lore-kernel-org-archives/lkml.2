Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1A0PAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:00:33 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:50298 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751598Ab1A0PAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:00:31 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX196bwxpkD96k0eCOLkPJTubg8QJEcDjl75qGNhfuL
	jNtpkxQiIPeXMy
Subject: [PATCH v2 18/20] sparc: switch do_timer() to xtime_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        hch@infradead.org, yong.zhang0@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 27 Jan 2011 16:00:22 +0100
Message-ID: <20110127150022.23248.80369.stgit@localhost>
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

pcic_clear_clock_irq() and clear_clock_irq do not need
to be protected by a lock.
it might make sense to move them after xtime_update() though.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Acked-by: David S. Miller <davem@davemloft.net>
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

