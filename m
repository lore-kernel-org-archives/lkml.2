Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0LUVEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:04:47 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56733 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab0LUVEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:04:46 -0500
Date: Tue, 21 Dec 2010 13:04:42 -0800
From: Andres Salomon <dilinger@queued.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
        dsd@laptop.org, pgf@laptop.org
Subject: [PATCH 1/2] cs5535-gpio: don't apply errata #36 to edge detect
 GPIOs
Message-ID: <20101221130442.3fcd84fb@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These two should go in before 2.6.37; they fix regressions with
853ff883.


From: Andres Salomon <dilinger@queued.net>

The edge detect status GPIOs function differently from the other atomic model
CS5536 GPIO registers; writing 1 to the high bits clears the GPIO, but writing
1 to the lower bits also clears the bit.  This means that read-modify-write
doesn't actually work for it, so don't apply the errata here.  If a negative
edge status gets lost after resume.. well, we tried our best!

Tested-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/gpio/cs5535-gpio.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index 599f6c9..79eb9c5 100644
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
 
@@ -76,7 +83,7 @@ static void __cs5535_gpio_set(struct cs5535_gpio_chip *chip, unsigned offset,
 		outl(1 << offset, chip->base + reg);
 	else
 		/* high bank register */
-		errata_outl(1 << (offset - 16), chip->base + 0x80 + reg);
+		errata_outl(chip, 1 << (offset - 16), reg);
 }
 
 void cs5535_gpio_set(unsigned offset, unsigned int reg)
@@ -98,7 +105,7 @@ static void __cs5535_gpio_clear(struct cs5535_gpio_chip *chip, unsigned offset,
 		outl(1 << (offset + 16), chip->base + reg);
 	else
 		/* high bank register */
-		errata_outl(1 << offset, chip->base + 0x80 + reg);
+		errata_outl(chip, 1 << offset, reg);
 }
 
 void cs5535_gpio_clear(unsigned offset, unsigned int reg)
-- 
1.7.2.3

