Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1AUXH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:07:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46984 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754386Ab1AUXHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:07:24 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18NhnNpEX0NhgkVNuhUm0a/6SBSs/8lW019vIGVC2
	Usp0QQUr2aOJ26
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 09/18] frv: switch do_timer() to xtime_update()
Date: Sat, 22 Jan 2011 00:06:55 +0100
Message-Id: <1295651224-29823-10-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this code looks like its protecting __set_LEDS() with this lock also.
i dont think thats necessary.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/frv/kernel/time.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index 0ddbbae..0d95162 100644
--- a/arch/frv/kernel/time.c
+++ b/arch/frv/kernel/time.c
@@ -50,7 +50,7 @@ static struct irqaction timer_irq  = {
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 static irqreturn_t timer_interrupt(int irq, void *dummy)
 {
@@ -61,10 +61,11 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 	 * CPU. We need to avoid to SMP race with it. NOTE: we don't need
 	 * the irq version of write_lock because as just said we have irq
 	 * locally disabled. -arca
+	 *
+	 * xtime_update takes the writelock.
 	 */
-	write_seqlock(&xtime_lock);
 
-	do_timer(1);
+	xtime_update(1);
 
 #ifdef CONFIG_HEARTBEAT
 	static unsigned short n;
@@ -72,8 +73,6 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 	__set_LEDS(n);
 #endif /* CONFIG_HEARTBEAT */
 
-	write_sequnlock(&xtime_lock);
-
 	update_process_times(user_mode(get_irq_regs()));
 
 	return IRQ_HANDLED;
-- 
1.7.2.3

