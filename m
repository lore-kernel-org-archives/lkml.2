Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936194Ab2C3VcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:32:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55525 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936190Ab2C3Vbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:31:55 -0400
X-Sasl-enc: y8nk0feTdZwmUkPDmbSOgQJ6TWGADnicvisCvI6V6Zo8 1333143113
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:55 2012
Message-Id: <20120330194855.649563238@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [ 146/175] mfd: Test for jack detection when deciding if wm8994 should suspend
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit d2cb87c23e8514ca49c85adc5924999927bb9494 upstream.

The jack detection on WM1811 is often required during system suspend, add
it as another check when deciding if we should suspend.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/wm8994-core.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -270,6 +270,20 @@ static int wm8994_suspend(struct device
 		break;
 	}
 
+	switch (wm8994->type) {
+	case WM1811:
+		ret = wm8994_reg_read(wm8994, WM8994_ANTIPOP_2);
+		if (ret < 0) {
+			dev_err(dev, "Failed to read jackdet: %d\n", ret);
+		} else if (ret & WM1811_JACKDET_MODE_MASK) {
+			dev_dbg(dev, "CODEC still active, ignoring suspend\n");
+			return 0;
+		}
+		break;
+	default:
+		break;
+	}
+
 	/* Disable LDO pulldowns while the device is suspended if we
 	 * don't know that something will be driving them. */
 	if (!wm8994->ldo_ena_always_driven)


