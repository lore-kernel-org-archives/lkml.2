Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab1GFDlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 23:41:52 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34941 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1GFDlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 23:41:51 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 131.252.246.213
Date: Tue, 5 Jul 2011 20:41:40 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Paul Mundt <lethal@linux-sh.org>,
        Ben Dooks <ben@simtec.co.uk>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        psas-avionics@lists.psas.pdx.edu
Subject: [PATCH] sm501: When registering the GPIO, turn on the GPIO unit's
 power
Message-ID: <20110706034138.GA8987@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When attempting to use GPIO via the sm501 unit on the TQM5200 board,
GPIO operations would only function if during the same boot u-boot's
"fkt led" command had initialized the sm501.  Comparing the sm501's
registers with and without running the "fkt led" command turned up one
significant difference: u-boot had enabled the GPIO power gate.
Changing the Linux sm501 driver to enable the GPIO power gate allows
GPIO to work without first initializing it with u-boot.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/mfd/sm501.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index df3702c..d7a0ab9 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1089,6 +1089,7 @@ static int __devinit sm501_register_gpio(struct sm501_devdata *sm)
 		goto err_low_chip;
 	}
 
+	sm501_unit_power(sm->dev, SM501_GATE_GPIO, 1);
 	gpio->registered = 1;
 
 	return 0;
@@ -1118,6 +1119,8 @@ static void sm501_gpio_remove(struct sm501_devdata *sm)
 	if (!sm->gpio.registered)
 		return;
 
+	sm501_unit_power(sm->dev, SM501_GATE_GPIO, 0);
+
 	ret = gpiochip_remove(&gpio->low.gpio);
 	if (ret)
 		dev_err(sm->dev, "cannot remove low chip, cannot tidy up\n");
-- 
1.7.5.4

