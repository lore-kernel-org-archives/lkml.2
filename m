Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0CVHkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:40:36 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:43579 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507Ab0CVHke convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:40:34 -0400
Date: Mon, 22 Mar 2010 07:39:46 +0000
From: Marc Zyngier <maz@misterjones.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Jebediah Huang <jebediah.huang@gmail.com>
Subject: Re: [PATCH] gpio: add interrupt handling capability to max732x
Message-ID: <20100322073946.5277f6ed@taxman.wild-wind.fr.eu.org>
In-Reply-To: <20100319164156.87b6fc43.akpm@linux-foundation.org>
References: <4ed0c90d27185c38ccb15d6d4442cfd4@localhost>
	<20100319164156.87b6fc43.akpm@linux-foundation.org>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 93.97.26.37
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, eric.y.miao@gmail.com, linux-kernel@vger.kernel.org, jebediah.huang@gmail.com
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010 16:41:56 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 16 Mar 2010 11:34:52 +0100
> Marc Zyngier <maz@misterjones.org> wrote:
> 
> > +static irqreturn_t max732x_irq_handler(int irq, void *devid)
> > +{
> > +	struct max732x_chip *chip = devid;
> > +	uint8_t pending;
> > +	uint8_t level;
> > +
> > +	pending = max732x_irq_pending(chip);
> > +
> > +	if (!pending)
> > +		return IRQ_HANDLED;
> 
> Should be IRQ_NONE?
> 
> If this device was on a shared interrupt line and the interrupt was
> caused by some other device, and this handler is called first then the
> incorrect IRQ_HANDLED return could cause the irq core to do wrong things.

Hi Andrew,

Would the following patch (against the original version) address your
concerns?

Thanks,

	M.

>From a8d40580ad5fe23e0737bac5f8b04dfd8cb93fe5 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@misterjones.org>
Date: Mon, 22 Mar 2010 07:28:30 +0000
Subject: [PATCH] gpio: max732x: allow IRQF_SHARED when hardware mask is available

Signed-off-by: Marc Zyngier <maz@misterjones.org>
---
 drivers/gpio/max732x.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/max732x.c b/drivers/gpio/max732x.c
index 647ae6f..07a9405 100644
--- a/drivers/gpio/max732x.c
+++ b/drivers/gpio/max732x.c
@@ -293,6 +293,14 @@ static int max732x_readw(struct max732x_chip *chip, uint16_t *val)
 	return 0;
 }
 
+static inline int max732x_has_irqmask(struct max732x_chip *chip)
+{
+	if (chip->irq_features == INT_NO_MASK)
+		return 0;
+
+	return 1;
+}
+
 static void max732x_irq_update_mask(struct max732x_chip *chip)
 {
 	uint16_t msg;
@@ -302,7 +310,7 @@ static void max732x_irq_update_mask(struct max732x_chip *chip)
 
 	chip->irq_mask = chip->irq_mask_cur;
 
-	if (chip->irq_features == INT_NO_MASK)
+	if (!max732x_has_irqmask(chip))
 		return;
 
 	mutex_lock(&chip->lock);
@@ -439,8 +447,14 @@ static irqreturn_t max732x_irq_handler(int irq, void *devid)
 
 	pending = max732x_irq_pending(chip);
 
-	if (!pending)
+	if (!pending) {
+		/* if we have a hardware mask, then the interrupt must
+		 * come from another device */
+		if (max732x_has_irqmask(chip))
+			return IRQ_NONE;
+
 		return IRQ_HANDLED;
+	}
 
 	do {
 		level = __ffs(pending);
@@ -462,6 +476,7 @@ static int max732x_irq_setup(struct max732x_chip *chip,
 
 	if (pdata->irq_base && has_irq != INT_NONE) {
 		int lvl;
+		int irq_flags;
 
 		chip->irq_base = pdata->irq_base;
 		chip->irq_features = has_irq;
@@ -484,10 +499,14 @@ static int max732x_irq_setup(struct max732x_chip *chip,
 #endif
 		}
 
+		irq_flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
+		if (max732x_has_irqmask(chip))
+			irq_flags |= IRQF_SHARED;
+
 		ret = request_threaded_irq(client->irq,
 					   NULL,
 					   max732x_irq_handler,
-					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					   irq_flags,
 					   dev_name(&client->dev), chip);
 		if (ret) {
 			dev_err(&client->dev, "failed to request irq %d\n",
-- 
1.7.0.2



-- 
I'm the slime oozin' out from your TV set...
