Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab2DYHfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 03:35:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58742 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab2DYHfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 03:35:09 -0400
From: NeilBrown <neilb@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 25 Apr 2012 17:33:11 +1000
Subject: [PATCH 5/6] twl4030-usb: Don't power down phy when it is in-use by
 charger.
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, NeilBrown <neilb@suse.de>
Message-ID: <20120425073311.20124.75294.stgit@notabene.brown>
In-Reply-To: <20120425072931.20124.56635.stgit@notabene.brown>
References: <20120425072931.20124.56635.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB phy is used both for data transfer and to charge the battery.
If the charger it active it will hold a reference to
usb3v1.  In that case we don't want to power-down the phy.

This allows charging to continue while the device is suspended.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/usb/otg/twl4030-usb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index c4a86da..bd8fe9b 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -388,10 +388,16 @@ static void twl4030_phy_power(struct twl4030_usb *twl, int on)
 					(PHY_CLK_CTRL_CLOCKGATING_EN |
 						PHY_CLK_CTRL_CLK32K_EN));
 	} else {
-		__twl4030_phy_power(twl, 0);
 		regulator_disable(twl->usb1v5);
 		regulator_disable(twl->usb1v8);
 		regulator_disable(twl->usb3v1);
+		if (!regulator_is_enabled(twl->usb3v1))
+			/* no-one else is requesting this
+			 * so it is OK to power-down the
+			 * phy.  Sometimes a charger might
+			 * hold the regulator active.
+			 */
+			__twl4030_phy_power(twl, 0);
 	}
 }
 


