Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab1ANIo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 03:44:28 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:56857 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab1ANIoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 03:44:21 -0500
Date: Fri, 14 Jan 2011 09:44:19 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@mocean-labs.com>
Subject: [PATCH] gpio: timbgpio: Fix up irq_data conversion breakage.
Message-ID: <20110114084419.GV15575@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a1f5f22adc3206c47e70652c12671666c65b579f ("gpio: timbgpio:
irq_data conversion") was slightly too enthusiastic in converting
timbgpio_irq() over to take an irq_data * argument instead of an
unsigned int irq argument, as it is a flow handler, which still take
IRQ numbers for now.  (And on top of that, it was using the wrong
accessors.)

This fixes it up, and seems to build without warnings.

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca> 

diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/timbgpio.c
index 349131e..58c8f30 100644
--- a/drivers/gpio/timbgpio.c
+++ b/drivers/gpio/timbgpio.c
@@ -193,13 +193,13 @@ out:
 	return ret;
 }
 
-static void timbgpio_irq(struct irq_data *d, struct irq_desc *desc)
+static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
 {
-	struct timbgpio *tgpio = irq_data_get_irq_data(d);
+	struct timbgpio *tgpio = get_irq_data(irq);
 	unsigned long ipr;
 	int offset;
 
-	desc->irq_data.chip->ack(irq_get_irq_data(d));
+	desc->irq_data.chip->irq_ack(irq_get_irq_data(irq));
 	ipr = ioread32(tgpio->membase + TGPIO_IPR);
 	iowrite32(ipr, tgpio->membase + TGPIO_ICR);

---
