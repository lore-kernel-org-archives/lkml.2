Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab1AFAj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:39:56 -0500
Received: from kroah.org ([198.145.64.141]:35986 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab1AFAbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:11 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:07 2011
Message-Id: <20110106002307.637727280@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andres Salomon <dilinger@queued.net>
Subject: [115/152] cs5535-gpio: dont apply errata #36 to edge detect GPIOs
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andres Salomon <dilinger@queued.net>

commit 001851659354cce436b749a793f3512a53394d80 upstream.

The edge detect status GPIOs function differently from the other atomic
model CS5536 GPIO registers; writing 1 to the high bits clears the GPIO,
but writing 1 to the lower bits also clears the bit.

This means that read-modify-write doesn't actually work for it, so don't
apply the errata here.  If a negative edge status gets lost after
resume..  well, we tried our best!

Tested-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Andres Salomon <dilinger@queued.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpio/cs5535-gpio.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -56,15 +56,22 @@ static struct cs5535_gpio_chip {
  * registers, see include/linux/cs5535.h.
  */
 
-static void errata_outl(u32 val, unsigned long addr)
+static void errata_outl(struct cs5535_gpio_chip *chip, u32 val,
+		unsigned int reg)
 {
+	unsigned long addr = chip->base + 0x80 + reg;
+
 	/*
 	 * According to the CS5536 errata (#36), after suspend
 	 * a write to the high bank GPIO register will clear all
 	 * non-selected bits; the recommended workaround is a
 	 * read-modify-write operation.
+	 *
+	 * Don't apply this errata to the edge status GPIOs, as writing
+	 * to their lower bits will clear them.
 	 */
-	val |= inl(addr);
+	if (reg != GPIO_POSITIVE_EDGE_STS && reg != GPIO_NEGATIVE_EDGE_STS)
+		val |= inl(addr);
 	outl(val, addr);
 }
 
@@ -76,7 +83,7 @@ static void __cs5535_gpio_set(struct cs5
 		outl(1 << offset, chip->base + reg);
 	else
 		/* high bank register */
-		errata_outl(1 << (offset - 16), chip->base + 0x80 + reg);
+		errata_outl(chip, 1 << (offset - 16), reg);
 }
 
 void cs5535_gpio_set(unsigned offset, unsigned int reg)
@@ -98,7 +105,7 @@ static void __cs5535_gpio_clear(struct c
 		outl(1 << (offset + 16), chip->base + reg);
 	else
 		/* high bank register */
-		errata_outl(1 << offset, chip->base + 0x80 + reg);
+		errata_outl(chip, 1 << offset, reg);
 }
 
 void cs5535_gpio_clear(unsigned offset, unsigned int reg)


