Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1A0PAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:00:23 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:33884 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753185Ab1A0PAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:00:19 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+V8U0UFGeVjcnpPbjpMZ6wBQFU6BqFMUBGCtv4/j
	YjbByFNEJMt/h0
Subject: [PATCH v2 16/20] mn10300: switch do_timer() to xtimer_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: hch@infradead.org, Peter Zijlstra <peterz@infradead.org>,
        johnstul@us.ibm.com, David Howells <dhowells@redhat.com>,
        yong.zhang0@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Date: Thu, 27 Jan 2011 16:00:12 +0100
Message-ID: <20110127150011.23248.62040.stgit@localhost>
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

xtimer_update() properly takes the xtime_lock.
mn10300_last_tsc is only accessed from this function.

Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
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

