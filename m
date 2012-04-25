Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab2DYHev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 03:34:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab2DYHer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 03:34:47 -0400
From: NeilBrown <neilb@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 25 Apr 2012 17:33:10 +1000
Subject: [PATCH 3/6] twl4030_charger: allow charging whenever VBUS is present.
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, NeilBrown <neilb@suse.de>
Message-ID: <20120425073310.20124.15112.stgit@notabene.brown>
In-Reply-To: <20120425072931.20124.56635.stgit@notabene.brown>
References: <20120425072931.20124.56635.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently refuse to charge if the USB ID pin is grounded, even
though VBUS might be present.
However some chargers do pull the ID pin low through a resistor which
might be as low as 47Kohm (openmoko charger).

The documentation is unclear but some experimental evidence suggests
that when the charge pump provides VBUS that doesn't get reflected in
HW_CONDITIONS, so we should be safe to ignore the ID pin.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/power/twl4030_charger.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index 0511610..684662a 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -155,11 +155,7 @@ static int twl4030_bci_have_vbus(struct twl4030_bci *bci)
 
 	dev_dbg(bci->dev, "check_vbus: HW_CONDITIONS %02x\n", hwsts);
 
-	/* in case we also have STS_USB_ID, VBUS is driven by TWL itself */
-	if ((hwsts & TWL4030_STS_VBUS) && !(hwsts & TWL4030_STS_USB_ID))
-		return 1;
-
-	return 0;
+	return (hwsts & TWL4030_STS_VBUS);
 }
 
 /*


