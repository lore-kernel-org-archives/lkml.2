Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1A0O7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:59:54 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:47439 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752669Ab1A0O7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:59:52 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX19SWKEV/X9SAOH3Ka32DLqzHbQt6EEHInMvKbKlQ/
	nrzM9s7sqHeQdv
Subject: [PATCH v2 11/20] frv: switch do_timer() to xtime_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: hch@infradead.org, Peter Zijlstra <peterz@infradead.org>,
        johnstul@us.ibm.com, David Howells <dhowells@redhat.com>,
        yong.zhang0@gmail.com, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Jan 2011 15:59:46 +0100
Message-ID: <20110127145946.23248.57952.stgit@localhost>
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

__set_LEDS() does not need to be protected by the lock.
its used unprotected in other places.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/frv/kernel/time.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/frv/kernel/time.c b/arch/frv/kernel/time.c
index 0ddbbae..dde2a8e 100644
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
+	 * xtime_update() does poper locking.
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

