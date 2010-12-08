Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab0LHBD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:28 -0500
Received: from kroah.org ([198.145.64.141]:33673 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446Ab0LHBDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:20 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:44 2010
Message-Id: <20101208005744.039514497@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andres Salomon <dilinger@queued.net>
Subject: [226/289] cs5535-gpio: apply CS5536 errata workaround for GPIOs
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/gpio/cs5535-gpio.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

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


