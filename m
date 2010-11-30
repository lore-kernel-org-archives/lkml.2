Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0K3BTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 20:19:36 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:42132 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab0K3BTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 20:19:35 -0500
Date: Mon, 29 Nov 2010 17:19:30 -0800
From: Andres Salomon <dilinger@queued.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
        dsd@laptop.org, cjb@laptop.org, stable@kernel.org
Subject: [PATCH] cs5535-gpio: apply CS5536 errata workaround for GPIOs
Message-ID: <20101129171930.2297083d@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The AMD Geode CS5536 Companion Device Silicon Revision B1 Specification Update
mentions the follow as issue #36:

"Atomic write transactions to the atomic GPIO High Bank Feature Bit registers
should only affect the bits selected [...]"
"after Suspend, an atomic write transaction [...] will clear all non-selected
bits of the accessed register."

In other words, writing to the high bank for a single GPIO bit will clear
every other GPIO bit (but only sometimes after a suspend).  The workaround
described is obvious and simple; do a read-modify-write.  This patch does
that, and documents why we're doing it.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/gpio/cs5535-gpio.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index e23c068..599f6c9 100644
--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -56,6 +56,18 @@ static struct cs5535_gpio_chip {
  * registers, see include/linux/cs5535.h.
  */
 
+static void errata_outl(u32 val, unsigned long addr)
+{
+	/*
+	 * According to the CS5536 errata (#36), after suspend
+	 * a write to the high bank GPIO register will clear all
+	 * non-selected bits; the recommended workaround is a
+	 * read-modify-write operation.
+	 */
+	val |= inl(addr);
+	outl(val, addr);
+}
+
 static void __cs5535_gpio_set(struct cs5535_gpio_chip *chip, unsigned offset,
 		unsigned int reg)
 {
@@ -64,7 +76,7 @@ static void __cs5535_gpio_set(struct cs5535_gpio_chip *chip, unsigned offset,
 		outl(1 << offset, chip->base + reg);
 	else
 		/* high bank register */
-		outl(1 << (offset - 16), chip->base + 0x80 + reg);
+		errata_outl(1 << (offset - 16), chip->base + 0x80 + reg);
 }
 
 void cs5535_gpio_set(unsigned offset, unsigned int reg)
@@ -86,7 +98,7 @@ static void __cs5535_gpio_clear(struct cs5535_gpio_chip *chip, unsigned offset,
 		outl(1 << (offset + 16), chip->base + reg);
 	else
 		/* high bank register */
-		outl(1 << offset, chip->base + 0x80 + reg);
+		errata_outl(1 << offset, chip->base + 0x80 + reg);
 }
 
 void cs5535_gpio_clear(unsigned offset, unsigned int reg)
-- 
1.5.6.5

