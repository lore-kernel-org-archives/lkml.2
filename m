Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab0LUVE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:04:57 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56739 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab0LUVEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:04:55 -0500
Date: Tue, 21 Dec 2010 13:04:52 -0800
From: Andres Salomon <dilinger@queued.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dsd@laptop.org,
        linux-geode@lists.infradead.org, pgf@laptop.org
Subject: [PATCH 2/2] cs5535-gpio: handle GPIO regs where higher (clear) bits
 are set
Message-ID: <20101221130452.083447a2@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The default for non-READ_BACK GPIO regs is to have the clear bits set;
this means that our original errata fix was too simplistic.  This
changes it to the following behavior:

 - when setting GPIOs, ignore the higher order bits (they're for clearing,
   we don't need to care about them).
 - when clearing GPIOs, keep all the bits, but unset (via XOR) the
   lower order bit that negates the clear bit that we care about.  That is,
   if we're clearing GPIO 26 (val = 0x04000000), we first XOR what's currently
   in the register with 0x0400 (GPIO 26's SET bit), and then OR that with
   the GPIO 26's CLEAR bit.

Tested-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/gpio/cs5535-gpio.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index 79eb9c5..d3e55a0 100644
--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -70,8 +70,12 @@ static void errata_outl(struct cs5535_gpio_chip *chip, u32 val,
 	 * Don't apply this errata to the edge status GPIOs, as writing
 	 * to their lower bits will clear them.
 	 */
-	if (reg != GPIO_POSITIVE_EDGE_STS && reg != GPIO_NEGATIVE_EDGE_STS)
-		val |= inl(addr);
+	if (reg != GPIO_POSITIVE_EDGE_STS && reg != GPIO_NEGATIVE_EDGE_STS) {
+		if (val & 0xffff)
+			val |= (inl(addr) & 0xffff); /* ignore the high bits */
+		else
+			val |= (inl(addr) ^ (val >> 16));
+	}
 	outl(val, addr);
 }
 
-- 
1.7.2.3

