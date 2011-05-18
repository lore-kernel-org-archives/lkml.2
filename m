Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604Ab1ERSht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:37:49 -0400
Received: from [138.40.68.24] ([138.40.68.24]:52713 "EHLO optosun2.city.ac.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933460Ab1ERSho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:37:44 -0400
From: "J. Ali Harlow" <ali@optosun7.city.ac.uk>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: devel@linuxdriverproject.org, Manuel Gebele <forensixs@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] comedi vmk80xx: make rudimentary_check a static function
Date: Wed, 18 May 2011 19:18:51 +0100
Message-Id: <1305742736-19434-1-git-send-email-ali@avrc.city.ac.uk>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rudimentary_check is a macro with side-effects (it returns
on error) which is contary to CodingStyle. Replace it with
a static function.

Signed-off-by: J. Ali Harlow <ali@avrc.city.ac.uk>
---
 drivers/staging/comedi/drivers/vmk80xx.c |   78 +++++++++++++++++++----------
 1 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index e475133..5d83bb6 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -557,22 +557,24 @@ exit:
 #define DIR_IN  1
 #define DIR_OUT 2
 
-#define rudimentary_check(dir)                             \
-do {                                                       \
-	if (!dev)                                          \
-		return -EFAULT;                            \
-	if (!dev->probed)                                  \
-		return -ENODEV;                            \
-	if (!dev->attached)                                \
-		return -ENODEV;                            \
-	if ((dir) & DIR_IN) {                              \
-		if (test_bit(TRANS_IN_BUSY, &dev->flags))  \
-			return -EBUSY;                     \
-	} else {  /* DIR_OUT */                            \
-		if (test_bit(TRANS_OUT_BUSY, &dev->flags)) \
-			return -EBUSY;                     \
-	}                                                  \
-} while (0)
+static int rudimentary_check(struct vmk80xx_usb *dev, int dir)
+{
+	if (!dev)
+		return -EFAULT;
+	if (!dev->probed)
+		return -ENODEV;
+	if (!dev->attached)
+		return -ENODEV;
+	if (dir & DIR_IN) {
+		if (test_bit(TRANS_IN_BUSY, &dev->flags))
+			return -EBUSY;
+	} else {  /* DIR_OUT */
+		if (test_bit(TRANS_OUT_BUSY, &dev->flags))
+			return -EBUSY;
+	}
+
+	return 0;
+}
 
 static int vmk80xx_ai_rinsn(struct comedi_device *cdev,
 			    struct comedi_subdevice *s,
@@ -585,7 +587,9 @@ static int vmk80xx_ai_rinsn(struct comedi_device *cdev,
 
 	dbgvm("vmk80xx: %s\n", __func__);
 
-	rudimentary_check(DIR_IN);
+	n = rudimentary_check(dev, DIR_IN);
+	if (n)
+		return n;
 
 	down(&dev->limit_sem);
 	chan = CR_CHAN(insn->chanspec);
@@ -636,7 +640,9 @@ static int vmk80xx_ao_winsn(struct comedi_device *cdev,
 
 	dbgvm("vmk80xx: %s\n", __func__);
 
-	rudimentary_check(DIR_OUT);
+	n = rudimentary_check(dev, DIR_OUT);
+	if (n)
+		return n;
 
 	down(&dev->limit_sem);
 	chan = CR_CHAN(insn->chanspec);
@@ -679,7 +685,9 @@ static int vmk80xx_ao_rinsn(struct comedi_device *cdev,
 
 	dbgvm("vmk80xx: %s\n", __func__);
 
-	rudimentary_check(DIR_IN);
+	n = rudimentary_check(dev, DIR_IN);
+	if (n)
+		return n;
 
 	down(&dev->limit_sem);
 	chan = CR_CHAN(insn->chanspec);
@@ -713,7 +721,9 @@ static int vmk80xx_di_rinsn(struct comedi_device *cdev,
 
 	dbgvm("vmk80xx: %s\n", __func__);
 
-	rudimentary_check(DIR_IN);
+	n = rudimentary_check(dev, DIR_IN);
+	if (n)
+		return n;
 
 	down(&dev->limit_sem);
 	chan = CR_CHAN(insn->chanspec);
@@ -758,7 +768,9 @@ static int vmk80xx_do_winsn(struct comedi_device *cdev,
 
 	dbgvm("vmk80xx: %s\n", __func__);
 
-	rudimentary_check(DIR_OUT);
+	n = rudimentary_check(dev, DIR_OUT);
+	if (n)
+		return n;
 
 	down(&dev->limit_sem);
 	chan = CR_CHAN(insn->chanspec);
@@ -805,7 +817,9 @@ static int vmk80xx_do_rinsn(struct comedi_device *cdev,
 
 	dbgvm("vmk80xx: %s\n", __func__);
 
-	rudimentary_check(DIR_IN);
+	n = rudimentary_check(dev, DIR_IN);
+	if (n)
+		return n;
 
 	down(&dev->limit_sem);
 	chan = CR_CHAN(insn->chanspec);
@@ -838,7 +852,9 @@ static int vmk80xx_cnt_rinsn(struct comedi_device *cdev,
 
 	dbgvm("vmk80xx: %s\n", __func__);
 
-	rudimentary_check(DIR_IN);
+	n = rudimentary_check(dev, DIR_IN);
+	if (n)
+		return n;
 
 	down(&dev->limit_sem);
 	chan = CR_CHAN(insn->chanspec);
@@ -886,7 +902,9 @@ static int vmk80xx_cnt_cinsn(struct comedi_device *cdev,
 
 	dbgvm("vmk80xx: %s\n", __func__);
 
-	rudimentary_check(DIR_OUT);
+	n = rudimentary_check(dev, DIR_OUT);
+	if (n)
+		return n;
 
 	down(&dev->limit_sem);
 
@@ -932,7 +950,9 @@ static int vmk80xx_cnt_winsn(struct comedi_device *cdev,
 
 	dbgvm("vmk80xx: %s\n", __func__);
 
-	rudimentary_check(DIR_OUT);
+	n = rudimentary_check(dev, DIR_OUT);
+	if (n)
+		return n;
 
 	down(&dev->limit_sem);
 	chan = CR_CHAN(insn->chanspec);
@@ -976,7 +996,9 @@ static int vmk80xx_pwm_rinsn(struct comedi_device *cdev,
 
 	dbgvm("vmk80xx: %s\n", __func__);
 
-	rudimentary_check(DIR_IN);
+	n = rudimentary_check(dev, DIR_IN);
+	if (n)
+		return n;
 
 	down(&dev->limit_sem);
 
@@ -1009,7 +1031,9 @@ static int vmk80xx_pwm_winsn(struct comedi_device *cdev,
 
 	dbgvm("vmk80xx: %s\n", __func__);
 
-	rudimentary_check(DIR_OUT);
+	n = rudimentary_check(dev, DIR_OUT);
+	if (n)
+		return n;
 
 	down(&dev->limit_sem);
 
-- 
1.7.4.1

