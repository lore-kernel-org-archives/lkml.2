Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab1GGUc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 16:32:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:47374 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab1GGUc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 16:32:28 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] irq: always set IRQF_ONESHOT if no primary handler is specified
Date: Thu,  7 Jul 2011 22:32:17 +0200
Message-Id: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no primary handler is specified then a default one is assigned which
always returns IRQ_WAKE_THREAD. This handler requires the IRQF_ONESHOT
flag on LEVEL / EIO typed irqs because the source of interrupt is not
disabled.
Since it is required for those users and there is no difference for others
it makes sense to add this flag unconditionally.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
A quick grep shows that drivers/staging/iio/adc/ad7816.c is the only
driver in tree doing it wrong i.e. request_threaded_irq with
IRQF_TRIGGER_{LOW|HIGH} but without ONEHOST.

There are 59 users in tree which request an edge typed interrupt. 24 of
them specify the ONEHOST flag the others don't. Both variants are valid
and identical but a consistent behavior would be nice.

There is a total of 134 users and 87 specify the irq type directly. For
the remaining 47 the type depends on initial configuration of the irq chip
or it might be specified via the device tree, dunno. 
Should that patch be accepted I suggest to remove the ONESHOT flag from
every request_th.* which uses NULL as the primary handler so we have a
consistent behavior here.

 kernel/irq/manage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a7840ae..3f9cd47 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1322,6 +1322,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 		if (!thread_fn)
 			return -EINVAL;
 		handler = irq_default_primary_handler;
+		irqflags |= IRQF_ONESHOT;
 	}
 
 	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
-- 
1.7.4.4

