Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab1AFAjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:39:43 -0500
Received: from kroah.org ([198.145.64.141]:35990 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab1AFAbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:12 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:07 2011
Message-Id: <20110106002307.729699204@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andres Salomon <dilinger@queued.net>
Subject: [116/152] cs5535-gpio: handle GPIO regs where higher (clear) bits are set
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andres Salomon <dilinger@queued.net>

commit 44658a11f312fb9217674cb90b1a11cbe17fd18d upstream.

The default for non-READ_BACK GPIO regs is to have the clear bits set;
this means that our original errata fix was too simplistic.  This
changes it to the following behavior:

 - when setting GPIOs, ignore the higher order bits (they're for
   clearing, we don't need to care about them).

 - when clearing GPIOs, keep all the bits, but unset (via XOR) the
   lower order bit that negates the clear bit that we care about.  That
   is, if we're clearing GPIO 26 (val = 0x04000000), we first XOR what's
   currently in the register with 0x0400 (GPIO 26's SET bit), and then
   OR that with the GPIO 26's CLEAR bit.

Tested-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Andres Salomon <dilinger@queued.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpio/cs5535-gpio.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -70,8 +70,12 @@ static void errata_outl(struct cs5535_gp
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
 


