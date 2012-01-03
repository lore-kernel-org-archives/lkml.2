Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2ACWiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:38:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707Ab2ACWhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:37:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:36 2012
Message-Id: <20120103223036.627031682@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:30:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sanjeev Premi <premi@ti.com>,
        Keerthy <j-keerthy@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [63/67] mfd: Fix mismatch in twl4030 mutex lock-unlock
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanjeev Premi <premi@ti.com>

commit e178ccb33569da17dc897a08a3865441b813bdfb upstream.

A mutex is locked on entry into twl4030_madc_conversion().
Immediate return on some error conditions leaves the
mutex locked.

This patch ensures that mutex is always unlocked before
leaving the function.

Signed-off-by: Sanjeev Premi <premi@ti.com>
Cc: Keerthy <j-keerthy@ti.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/twl4030-madc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -530,13 +530,13 @@ int twl4030_madc_conversion(struct twl40
 	if (ret) {
 		dev_err(twl4030_madc->dev,
 			"unable to write sel register 0x%X\n", method->sel + 1);
-		return ret;
+		goto out;
 	}
 	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, ch_lsb, method->sel);
 	if (ret) {
 		dev_err(twl4030_madc->dev,
 			"unable to write sel register 0x%X\n", method->sel + 1);
-		return ret;
+		goto out;
 	}
 	/* Select averaging for all channels if do_avg is set */
 	if (req->do_avg) {
@@ -546,7 +546,7 @@ int twl4030_madc_conversion(struct twl40
 			dev_err(twl4030_madc->dev,
 				"unable to write avg register 0x%X\n",
 				method->avg + 1);
-			return ret;
+			goto out;
 		}
 		ret = twl_i2c_write_u8(TWL4030_MODULE_MADC,
 				       ch_lsb, method->avg);
@@ -554,7 +554,7 @@ int twl4030_madc_conversion(struct twl40
 			dev_err(twl4030_madc->dev,
 				"unable to write sel reg 0x%X\n",
 				method->sel + 1);
-			return ret;
+			goto out;
 		}
 	}
 	if (req->type == TWL4030_MADC_IRQ_ONESHOT && req->func_cb != NULL) {


