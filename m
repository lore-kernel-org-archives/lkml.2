Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1K1EHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 23:07:39 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57699 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1K1EHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 23:07:38 -0500
Date: Sun, 27 Nov 2011 23:07:34 -0500
From: Edward Donovan <edward.donovan@numble.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        drivers_pci@kernel-bugs.osdl.org,
        =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] genirq: fix second 2.6.39 regression in irqfixup, irqpoll
Message-ID: <20111128040734.GA3590@Brahman>
References: <bug-41132-5003@https.bugzilla.kernel.org/>
 <201108160554.p7G5soeq002083@demeter2.kernel.org>
 <CAOtrxKP-0TfJa8dS8_uW195WO13YCy-UyaZfweYD4Tv_1gAmKQ@mail.gmail.com>
 <CA+55aFzh-ST1-Hu+Ny25X5DkEqktv3ZDFP2NDOWx6N+vFbTM8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzh-ST1-Hu+Ny25X5DkEqktv3ZDFP2NDOWx6N+vFbTM8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit fa27271bc8d2("genirq: Fixup poll handling") introduced a
regression that broke irqfixup/irqpoll for some hardware
configurations.  Amidst reorganizing 'try_one_irq', that patch removed
a test that checked for 'action->handler' returning IRQ_HANDLED,
before acting on the interrupt.  Restoring this test back returns the
functionality lost since 2.6.39.  In the current set of tests, after
'action' is set, it must precede '!action->next' to take effect.

With this and my previous patch to irq/spurious.c, c75d720fca8a, all
IRQ regressions that I have encountered are fixed.

Signed-off-by: Edward Donovan <edward.donovan@numble.net>
---
 kernel/irq/spurious.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index b5f4742..dc813a9 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -84,7 +84,9 @@ static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 	 */
 	action = desc->action;
 	if (!action || !(action->flags & IRQF_SHARED) ||
-	    (action->flags & __IRQF_TIMER) || !action->next)
+	    (action->flags & __IRQF_TIMER) ||
+	    (action->handler(irq, action->dev_id) == IRQ_HANDLED) ||
+	    !action->next)
 		goto out;
 
 	/* Already running on another processor */
