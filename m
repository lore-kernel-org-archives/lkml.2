Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1ABOw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 09:52:29 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59623 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab1ABOw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 09:52:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fHCf8og2pGqDh5jCqhZUro5j3wCvb72I0K5M7hP30uT6RlMziCq/+v+j5v1KgiXi6b
         3dYoasJ4etnddT5b2rdEGuaq5ZS9ei0/ecqz5A7lVbJBxpVL1w6ursXoJ13B5APXbac2
         RnZSqRaqua50+MdVSuPLANVZ6BxVCzm8XfWZU=
Message-ID: <4D209127.5080505@gmail.com>
Date: Sun, 02 Jan 2011 15:52:23 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: eepro testing positive EBUSY return by request_irq()?
References: <4D1DECFC.8020701@gmail.com> <1293809262.2870.45.camel@localhost>
In-Reply-To: <1293809262.2870.45.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> -		if (request_irq (*irqp, NULL, IRQF_SHARED, "bogus", dev) != EBUSY) {
>> +		if (request_irq (*irqp, NULL, IRQF_SHARED, "bogus", dev) != -EBUSY) {

> This condition is completely bogus - request_irq() with a NULL handler
> now returns -EINVAL before even checking whether the IRQ is in use.  The
> code should be fixed along the lines of what I did for 3c503 in commit
> b0cf4dfb7cd21556efd9a6a67edcba0840b4d98d.
> 
> The e2100 and hp net drivers have the same bug.
> 
> Ben.

I've made an attempt to fix the mentioned issues, but I'm not sure it is complete.
The commit made some other changes as well which didn't seem appropriate here to me.
And I didn't compile or run test this.

As a side note, in the function changed by the commit you mentioned, el2_open(), it
appears that in current git, boolean `seen' cannot ever become true, can it? So it
loops forever until the request_irq() returns an error other than -EBUSY. Not sure
how it should be fixed though.

------------->8-------------------8<----------------
Handle errors returned by request_irq() appropriately

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/e2100.c |   14 +++++++++-----
 drivers/net/eepro.c |   26 +++++++++++++++-----------
 drivers/net/hp.c    |   25 ++++++++++++++-----------
 3 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/drivers/net/e2100.c b/drivers/net/e2100.c
index 06e72fb..115fa16 100644
--- a/drivers/net/e2100.c
+++ b/drivers/net/e2100.c
@@ -217,11 +217,15 @@ static int __init e21_probe1(struct net_device *dev, int ioaddr)
 
 	if (dev->irq < 2) {
 		int irqlist[] = {15, 11, 10, 12, 5, 9, 3, 4};
-		for (i = 0; i < ARRAY_SIZE(irqlist); i++)
-			if (request_irq (irqlist[i], NULL, 0, "bogus", NULL) != -EBUSY) {
-				dev->irq = irqlist[i];
-				break;
-			}
+		for (i = 0; i < ARRAY_SIZE(irqlist); i++) {
+			retval = request_irq (irqlist[i], NULL, 0, "bogus", NULL);
+			if (retval != -EBUSY)
+				continue;
+			if (retval < 0)
+				goto out;
+			dev->irq = irqlist[i];
+			break;
+		}
 		if (i >= ARRAY_SIZE(irqlist)) {
 			printk(" unable to get IRQ %d.\n", dev->irq);
 			retval = -EAGAIN;
diff --git a/drivers/net/eepro.c b/drivers/net/eepro.c
index 7c82631..24ff522 100644
--- a/drivers/net/eepro.c
+++ b/drivers/net/eepro.c
@@ -897,6 +897,7 @@ static int	eepro_grab_irq(struct net_device *dev)
 {
 	int irqlist[] = { 3, 4, 5, 7, 9, 10, 11, 12, 0 };
 	int *irqp = irqlist, temp_reg, ioaddr = dev->base_addr;
+	int retval;
 
 	eepro_sw2bank1(ioaddr); /* be CAREFUL, BANK 1 now */
 
@@ -919,21 +920,24 @@ static int	eepro_grab_irq(struct net_device *dev)
 		outb((temp_reg & 0xf8) | irqrmap[*irqp], ioaddr + INT_NO_REG);
 
 		eepro_sw2bank0(ioaddr); /* Switch back to Bank 0 */
+		retval = request_irq (*irqp, NULL, IRQF_SHARED, "bogus", dev);
+		if (retval == -EBUSY)
+			continue;
+		if (retval < 0)
+			return retval;
 
-		if (request_irq (*irqp, NULL, IRQF_SHARED, "bogus", dev) != EBUSY) {
-			unsigned long irq_mask;
-			/* Twinkle the interrupt, and check if it's seen */
-			irq_mask = probe_irq_on();
+		unsigned long irq_mask;
+		/* Twinkle the interrupt, and check if it's seen */
+		irq_mask = probe_irq_on();
 
-			eepro_diag(ioaddr); /* RESET the 82595 */
-			mdelay(20);
+		eepro_diag(ioaddr); /* RESET the 82595 */
+		mdelay(20);
 
-			if (*irqp == probe_irq_off(irq_mask))  /* It's a good IRQ line */
-				break;
+		if (*irqp == probe_irq_off(irq_mask))  /* It's a good IRQ line */
+			break;
 
-			/* clear all interrupts */
-			eepro_clear_int(ioaddr);
-		}
+		/* clear all interrupts */
+		eepro_clear_int(ioaddr);
 	} while (*++irqp);
 
 	eepro_sw2bank1(ioaddr); /* Switch back to Bank 1 */
diff --git a/drivers/net/hp.c b/drivers/net/hp.c
index d15d2f2..aeb68a0 100644
--- a/drivers/net/hp.c
+++ b/drivers/net/hp.c
@@ -167,17 +167,20 @@ static int __init hp_probe1(struct net_device *dev, int ioaddr)
 		int *irqp = wordmode ? irq_16list : irq_8list;
 		do {
 			int irq = *irqp;
-			if (request_irq (irq, NULL, 0, "bogus", NULL) != -EBUSY) {
-				unsigned long cookie = probe_irq_on();
-				/* Twinkle the interrupt, and check if it's seen. */
-				outb_p(irqmap[irq] | HP_RUN, ioaddr + HP_CONFIGURE);
-				outb_p( 0x00 | HP_RUN, ioaddr + HP_CONFIGURE);
-				if (irq == probe_irq_off(cookie)		 /* It's a good IRQ line! */
-					&& request_irq (irq, eip_interrupt, 0, DRV_NAME, dev) == 0) {
-					printk(" selecting IRQ %d.\n", irq);
-					dev->irq = *irqp;
-					break;
-				}
+			retval = request_irq (irq, NULL, 0, "bogus", NULL);
+			if (retval == -EBUSY)
+				continue;
+			if (retval < 0)
+				goto out;
+			unsigned long cookie = probe_irq_on();
+			/* Twinkle the interrupt, and check if it's seen. */
+			outb_p(irqmap[irq] | HP_RUN, ioaddr + HP_CONFIGURE);
+			outb_p( 0x00 | HP_RUN, ioaddr + HP_CONFIGURE);
+			if (irq == probe_irq_off(cookie)		 /* It's a good IRQ line! */
+				&& request_irq (irq, eip_interrupt, 0, DRV_NAME, dev) == 0) {
+				printk(" selecting IRQ %d.\n", irq);
+				dev->irq = *irqp;
+				break;
 			}
 		} while (*++irqp);
 		if (*irqp == 0) {
