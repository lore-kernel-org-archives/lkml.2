Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577Ab1ERShZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:37:25 -0400
Received: from [138.40.68.24] ([138.40.68.24]:52701 "EHLO optosun2.city.ac.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933460Ab1ERShW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:37:22 -0400
From: "J. Ali Harlow" <ali@optosun7.city.ac.uk>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: devel@linuxdriverproject.org, Manuel Gebele <forensixs@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] comedi vmk80xx: simplify rinsn output calculation
Date: Wed, 18 May 2011 19:18:53 +0100
Message-Id: <1305742736-19434-3-git-send-email-ali@avrc.city.ac.uk>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmk80xx_di_rinsn() and vmk80xx_do_rinsn() extract the required channel
data by inconsistent and overly-complex algorithms. Simplify them both.

Signed-off-by: J. Ali Harlow <ali@avrc.city.ac.uk>
---
 drivers/staging/comedi/drivers/vmk80xx.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 01cfb76..c86c866 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -747,7 +747,7 @@ static int vmk80xx_di_rinsn(struct comedi_device *cdev,
 		else
 			inp = rx_buf[reg];
 
-		data[n] = ((inp & (1 << chan)) > 0);
+		data[n] = (inp >> chan) & 1;
 	}
 
 	up(&dev->limit_sem);
@@ -812,7 +812,6 @@ static int vmk80xx_do_rinsn(struct comedi_device *cdev,
 	struct vmk80xx_usb *dev = cdev->private;
 	int chan;
 	int reg;
-	int mask;
 	int n;
 
 	dbgvm("vmk80xx: %s\n", __func__);
@@ -825,7 +824,6 @@ static int vmk80xx_do_rinsn(struct comedi_device *cdev,
 	chan = CR_CHAN(insn->chanspec);
 
 	reg = VMK8061_DO_REG;
-	mask = 1 << chan;
 
 	dev->usb_tx_buf[0] = VMK8061_CMD_RD_DO;
 
@@ -833,7 +831,7 @@ static int vmk80xx_do_rinsn(struct comedi_device *cdev,
 		if (vmk80xx_read_packet(dev))
 			break;
 
-		data[n] = (dev->usb_rx_buf[reg] & mask) >> chan;
+		data[n] = (dev->usb_rx_buf[reg] >> chan) & 1;
 	}
 
 	up(&dev->limit_sem);
-- 
1.7.4.1

