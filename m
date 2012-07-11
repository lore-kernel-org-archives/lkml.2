Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab2GKM2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:28:41 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:33929 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab2GKM2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:28:40 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: comedi: rtd520: add a few comments
Date: Wed, 11 Jul 2012 13:28:19 +0100
Message-ID: <1342009699-7031-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <4FFD5665.7040901@mev.co.uk>
References: <4FFD5665.7040901@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten's recent series of patches to clean up the rtd520
driver made some of the register accesses harder to understand.  Add a
few comments to provide some clues to the reader.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
To be applied after Hartley's 83 patches.
---
 drivers/staging/comedi/drivers/rtd520.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 5a2953e..9998d6b 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -494,6 +494,7 @@ static int rtd520_probe_fifo_depth(struct comedi_device *dev)
 
 	writel(0, devpriv->las0 + LAS0_ADC_FIFO_CLEAR);
 	rtd_load_channelgain_list(dev, 1, &chanspec);
+	/* ADC conversion trigger source: SOFTWARE */
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	/* convert  samples */
 	for (i = 0; i < limit; ++i) {
@@ -544,7 +545,7 @@ static int rtd_ai_rinsn(struct comedi_device *dev,
 	/* write channel to multiplexer and clear channel gain table */
 	rtd_load_channelgain_list(dev, 1, &insn->chanspec);
 
-	/* set conversion source */
+	/* ADC conversion trigger source: SOFTWARE */
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 
 	/* convert n samples */
@@ -908,8 +909,9 @@ abortTransfer:
 	/* fall into transferDone */
 
 transferDone:
+	/* pacer stop source: SOFTWARE */
 	writel(0, devpriv->las0 + LAS0_PACER_STOP);
-	writel(0, devpriv->las0 + LAS0_PACER);
+	writel(0, devpriv->las0 + LAS0_PACER);	/* stop pacer */
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	devpriv->intMask = 0;
 	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
@@ -1180,8 +1182,9 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	int timer;
 
 	/* stop anything currently running */
+	/* pacer stop source: SOFTWARE */
 	writel(0, devpriv->las0 + LAS0_PACER_STOP);
-	writel(0, devpriv->las0 + LAS0_PACER);
+	writel(0, devpriv->las0 + LAS0_PACER);	/* stop pacer */
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	devpriv->intMask = 0;
 	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
@@ -1215,12 +1218,17 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	/* setup the common case and override if needed */
 	if (cmd->chanlist_len > 1) {
 		/*DPRINTK ("rtd520: Multi channel setup\n"); */
+		/* pacer start source: SOFTWARE */
 		writel(0, devpriv->las0 + LAS0_PACER_START);
+		/* burst trigger source: PACER */
 		writel(1, devpriv->las0 + LAS0_BURST_START);
+		/* ADC conversion trigger source: BURST */
 		writel(2, devpriv->las0 + LAS0_ADC_CONVERSION);
 	} else {		/* single channel */
 		/*DPRINTK ("rtd520: single channel setup\n"); */
+		/* pacer start source: SOFTWARE */
 		writel(0, devpriv->las0 + LAS0_PACER_START);
+		/* ADC conversion trigger source: PACER */
 		writel(1, devpriv->las0 + LAS0_ADC_CONVERSION);
 	}
 	writel((devpriv->fifoLen / 2 - 1) & 0xffff, devpriv->las0 + LAS0_ACNT);
@@ -1269,7 +1277,9 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->transCount = 0;
 		devpriv->flags &= ~SEND_EOS;
 	}
+	/* pacer clock source: INTERNAL 8MHz */
 	writel(1, devpriv->las0 + LAS0_PACER_SELECT);
+	/* just interrupt, don't stop */
 	writel(1, devpriv->las0 + LAS0_ACNT_STOP_ENABLE);
 
 	/* BUG??? these look like enumerated values, but they are bit fields */
@@ -1305,6 +1315,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		break;
 
 	case TRIG_EXT:
+		/* pacer start source: EXTERNAL */
 		writel(1, devpriv->las0 + LAS0_PACER_START);
 		break;
 
@@ -1327,6 +1338,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		break;
 
 	case TRIG_EXT:		/* external */
+		/* burst trigger source: EXTERNAL */
 		writel(2, devpriv->las0 + LAS0_BURST_START);
 		break;
 
@@ -1378,7 +1390,7 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	/* BUG: start_src is ASSUMED to be TRIG_NOW */
 	/* BUG? it seems like things are running before the "start" */
-	readl(devpriv->las0 + LAS0_PACER);
+	readl(devpriv->las0 + LAS0_PACER);	/* start pacer */
 	return 0;
 }
 
@@ -1391,8 +1403,9 @@ static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 	u32 overrun;
 	u16 status;
 
+	/* pacer stop source: SOFTWARE */
 	writel(0, devpriv->las0 + LAS0_PACER_STOP);
-	writel(0, devpriv->las0 + LAS0_PACER);
+	writel(0, devpriv->las0 + LAS0_PACER);	/* stop pacer */
 	writel(0, devpriv->las0 + LAS0_ADC_CONVERSION);
 	devpriv->intMask = 0;
 	writew(devpriv->intMask, devpriv->las0 + LAS0_IT);
-- 
1.7.8.6

