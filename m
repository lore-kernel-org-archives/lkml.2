Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab1AVAPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:15:01 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:54652 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755093Ab1AVAO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:14:59 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+19bkrFJS1zfUKuufogQcX6MBK2OvcdQ5ix64MN/
	4cpcCpr/nEdyPb
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 14/18] mn10300: switch do_timer() to xtimer_update()
Date: Sat, 22 Jan 2011 00:07:00 +0100
Message-Id: <1295651224-29823-15-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtimer_update() properly takes the xtime_lock.
mn10300_last_tsc is only accessed from this function.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/mn10300/kernel/time.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index 75da468..5b95500 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -104,8 +104,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 	unsigned tsc, elapse;
 	irqreturn_t ret;
 
-	write_seqlock(&xtime_lock);
-
 	while (tsc = get_cycles(),
 	       elapse = tsc - mn10300_last_tsc, /* time elapsed since last
 						 * tick */
@@ -114,11 +112,9 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		mn10300_last_tsc += MN10300_TSC_PER_HZ;
 
 		/* advance the kernel's time tracking system */
-		do_timer(1);
+		xtime_update(1);
 	}
 
-	write_sequnlock(&xtime_lock);
-
 	ret = local_timer_interrupt();
 #ifdef CONFIG_SMP
 	send_IPI_allbutself(LOCAL_TIMER_IPI);
-- 
1.7.2.3

