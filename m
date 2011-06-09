Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1FIVXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:23:20 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16610 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab1FIVXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:23:18 -0400
Date: Thu, 9 Jun 2011 23:14:58 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Avoid potential NULL deref in irq_set_irq_wake()
Message-ID: <alpine.LNX.2.00.1106092300360.17868@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel/irq/manage.c::irq_set_irq_wake() we call irq_get_desc_buslock() 
which may return NULL (it calls into 
__irq_get_desc_lock()-->irq_to_desc()-->radix_tree_lookup()-->radix_tree_lookup_element() 
which can return NULL in a number of different situations). If it does 
we'll dereference a NULL pointer - *Boom*.

irq_set_irq_wake() has lots of callers - I checked a few and I couldn't 
find anything that guarantees that they won't call it with some input that 
will cause irq_get_desc_buslock() to return NULL, so I think it's a good 
thing to test and -EINVAL was the most sane error code in this situation 
that I could think of.

Not all callers test the return value of irq_set_irq_wake(), but those 
that do take != 0 to mean error as far as I can see, so they should be 
fine. I guess those that don't test actually should, but that's a 
different issue.

Feedback welcome.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 manage.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

 Found by the Coverity checker.
 Untested except for build test.

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index d64bafb..b42c15c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -488,8 +488,11 @@ static int set_irq_wake_real(unsigned int irq, unsigned int on)
 int irq_set_irq_wake(unsigned int irq, unsigned int on)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
 	int ret = 0;
+	struct irq_desc *desc = irq_get_desc_buslock(irq, &flags);
+
+	if (!desc)
+		return -EINVAL;
 
 	/* wakeup-capable irqs can be shared between drivers that
 	 * don't need to have the same sleep mode behaviors.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

