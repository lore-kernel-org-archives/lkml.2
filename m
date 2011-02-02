Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1BBAo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:35413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab1BBAo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028590"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: dilinger@queued.net, dsd@laptop.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [109/139] cs5535-gpio: handle GPIO regs where higher (clear) bits are set
Message-Id: <20110202004507.D4B563E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpio/cs5535-gpio.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/gpio/cs5535-gpio.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpio/cs5535-gpio.c
+++ linux-2.6.35.y/drivers/gpio/cs5535-gpio.c
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
 
