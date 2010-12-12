Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab0LLX7Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:59:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36591 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab0LLXr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:57 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: dilinger@queued.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [171/223] cs5535-gpio: apply CS5536 errata workaround for GPIOs
Message-Id: <20101212234755.C7690B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andres Salomon <dilinger@queued.net>

commit 853ff88324a248a9f5da6e110850223db353ec07 upstream.

The AMD Geode CS5536 Companion Device Silicon Revision B1 Specification
Update mentions the follow as issue #36:

 "Atomic write transactions to the atomic GPIO High Bank Feature Bit
  registers should only affect the bits selected [...]"

 "after Suspend, an atomic write transaction [...] will clear all
  non-selected bits of the accessed register."

In other words, writing to the high bank for a single GPIO bit will
clear every other GPIO bit (but only sometimes after a suspend).

The workaround described is obvious and simple; do a read-modify-write.
This patch does that, and documents why we're doing it.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpio/cs5535-gpio.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Index: linux/drivers/gpio/cs5535-gpio.c
===================================================================
--- linux.orig/drivers/gpio/cs5535-gpio.c
+++ linux/drivers/gpio/cs5535-gpio.c
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
@@ -64,7 +76,7 @@ static void __cs5535_gpio_set(struct cs5
 		outl(1 << offset, chip->base + reg);
 	else
 		/* high bank register */
-		outl(1 << (offset - 16), chip->base + 0x80 + reg);
+		errata_outl(1 << (offset - 16), chip->base + 0x80 + reg);
 }
 
 void cs5535_gpio_set(unsigned offset, unsigned int reg)
@@ -86,7 +98,7 @@ static void __cs5535_gpio_clear(struct c
 		outl(1 << (offset + 16), chip->base + reg);
 	else
 		/* high bank register */
-		outl(1 << offset, chip->base + 0x80 + reg);
+		errata_outl(1 << offset, chip->base + 0x80 + reg);
 }
 
 void cs5535_gpio_clear(unsigned offset, unsigned int reg)
