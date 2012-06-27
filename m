Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab2F0BBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:01:13 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:31802 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab2F0BBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:01:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1340758871!12612753!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/36] staging: comedi: cb_pcidas: cleanup ai_config_insn()
Date: Tue, 26 Jun 2012 18:01:05 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261801.05869.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Absorb the helper function ai_config_calibration_source() into
ai_config_insn() and remove the static const variable that
was in the helper function.

Return an error code (-EINVAL) when appropriate and the number
of data values used (insn->n) for success.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 3cdd026..a2901bb 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -439,38 +439,28 @@ static int cb_pcidas_ai_rinsn(struct comedi_device *dev,
 	return n;
 }
 
-static int ai_config_calibration_source(struct comedi_device *dev,
-					unsigned int *data)
-{
-	struct cb_pcidas_private *devpriv = dev->private;
-	static const int num_calibration_sources = 8;
-	unsigned int source = data[1];
-
-	if (source >= num_calibration_sources) {
-		dev_err(dev->class_dev, "invalid calibration source: %i\n",
-			source);
-		return -EINVAL;
-	}
-
-	devpriv->calibration_source = source;
-
-	return 2;
-}
-
 static int ai_config_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	struct cb_pcidas_private *devpriv = dev->private;
 	int id = data[0];
+	unsigned int source = data[1];
 
 	switch (id) {
 	case INSN_CONFIG_ALT_SOURCE:
-		return ai_config_calibration_source(dev, data);
+		if (source >= 8) {
+			dev_err(dev->class_dev,
+				"invalid calibration source: %i\n",
+				source);
+			return -EINVAL;
+		}
+		devpriv->calibration_source = source;
 		break;
 	default:
 		return -EINVAL;
 		break;
 	}
-	return -EINVAL;
+	return insn->n;
 }
 
 /* analog output insn for pcidas-1000 and 1200 series */
-- 
1.7.11

