Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1BBAw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:52:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:3685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab1BBAo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960853"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: dilinger@queued.net, dsd@laptop.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [108/139] cs5535-gpio: don't apply errata #36 to edge detect GPIOs
Message-Id: <20110202004506.C82143E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpio/cs5535-gpio.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/gpio/cs5535-gpio.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpio/cs5535-gpio.c
+++ linux-2.6.35.y/drivers/gpio/cs5535-gpio.c
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
