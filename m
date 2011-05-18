Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab1ERShk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:37:40 -0400
Received: from [138.40.68.24] ([138.40.68.24]:52709 "EHLO optosun2.city.ac.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933460Ab1ERShh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:37:37 -0400
From: "J. Ali Harlow" <ali@optosun7.city.ac.uk>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: devel@linuxdriverproject.org, Manuel Gebele <forensixs@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] comedi vmk80xx: support bits instruction
Date: Wed, 18 May 2011 19:18:55 +0100
Message-Id: <1305742736-19434-5-git-send-email-ali@avrc.city.ac.uk>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling comedi_dio_bifield2() returns EBUSY permanently. Implementing
the insn_bits call fixes the problem and is good in its own right since
one can then read and write to all the digitial lines at the same time.
Tested on a K8055, but not on a K8061.

Signed-off-by: J. Ali Harlow <ali@avrc.city.ac.uk>
---
 drivers/staging/comedi/drivers/vmk80xx.c |  113 ++++++++++++++++++++++++++++++
 1 files changed, 113 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 669ebf85..04c085f 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -709,6 +709,50 @@ static int vmk80xx_ao_rinsn(struct comedi_device *cdev,
 	return n;
 }
 
+static int vmk80xx_di_bits(struct comedi_device *cdev,
+			   struct comedi_subdevice *s,
+			   struct comedi_insn *insn, unsigned int *data)
+{
+	struct vmk80xx_usb *dev = cdev->private;
+	unsigned char *rx_buf;
+	int reg;
+	int retval;
+
+	dbgvm("vmk80xx: %s\n", __func__);
+
+	retval = rudimentary_check(dev, DIR_IN);
+	if (retval)
+		return retval;
+
+	down(&dev->limit_sem);
+
+	rx_buf = dev->usb_rx_buf;
+
+	if (dev->board.model == VMK8061_MODEL) {
+		reg = VMK8061_DI_REG;
+		dev->usb_tx_buf[0] = VMK8061_CMD_RD_DI;
+	} else {
+		reg = VMK8055_DI_REG;
+	}
+
+	retval = vmk80xx_read_packet(dev);
+
+	if (!retval) {
+		if (dev->board.model == VMK8055_MODEL)
+			data[1] = (((rx_buf[reg] >> 4) & 0x03) |
+				  ((rx_buf[reg] << 2) & 0x04) |
+				  ((rx_buf[reg] >> 3) & 0x18));
+		else
+			data[1] = rx_buf[reg];
+
+		retval = 2;
+	}
+
+	up(&dev->limit_sem);
+
+	return retval;
+}
+
 static int vmk80xx_di_rinsn(struct comedi_device *cdev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
@@ -840,6 +884,73 @@ static int vmk80xx_do_rinsn(struct comedi_device *cdev,
 	return n;
 }
 
+static int vmk80xx_do_bits(struct comedi_device *cdev,
+			   struct comedi_subdevice *s,
+			   struct comedi_insn *insn, unsigned int *data)
+{
+	struct vmk80xx_usb *dev = cdev->private;
+	unsigned char *rx_buf, *tx_buf;
+	int dir, reg, cmd;
+	int retval;
+
+	dbgvm("vmk80xx: %s\n", __func__);
+
+	dir = 0;
+
+	if (data[0])
+		dir |= DIR_OUT;
+
+	if (dev->board.model == VMK8061_MODEL)
+		dir |= DIR_IN;
+
+	retval = rudimentary_check(dev, dir);
+	if (retval)
+		return retval;
+
+	down(&dev->limit_sem);
+
+	rx_buf = dev->usb_rx_buf;
+	tx_buf = dev->usb_tx_buf;
+
+	if (data[0]) {
+		if (dev->board.model == VMK8055_MODEL) {
+			reg = VMK8055_DO_REG;
+			cmd = VMK8055_CMD_WRT_AD;
+		} else { /* VMK8061_MODEL */
+			reg = VMK8061_DO_REG;
+			cmd = VMK8061_CMD_DO;
+		}
+
+		tx_buf[reg] &= ~data[0];
+		tx_buf[reg] |= (data[0] & data[1]);
+
+		retval = vmk80xx_write_packet(dev, cmd);
+
+		if (retval)
+			goto out;
+	}
+
+	if (dev->board.model == VMK8061_MODEL) {
+		reg = VMK8061_DO_REG;
+		tx_buf[0] = VMK8061_CMD_RD_DO;
+
+		retval = vmk80xx_read_packet(dev);
+
+		if (!retval) {
+			data[1] = rx_buf[reg];
+			retval = 2;
+		}
+	} else {
+		data[1] = tx_buf[reg];
+		retval = 2;
+	}
+
+out:
+	up(&dev->limit_sem);
+
+	return retval;
+}
+
 static int vmk80xx_cnt_rinsn(struct comedi_device *cdev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn, unsigned int *data)
@@ -1139,6 +1250,7 @@ static int vmk80xx_attach(struct comedi_device *cdev,
 	s->n_chan = dev->board.di_chans;
 	s->maxdata = 1;
 	s->insn_read = vmk80xx_di_rinsn;
+	s->insn_bits = vmk80xx_di_bits;
 
 	/* Digital output subdevice */
 	s = cdev->subdevices + VMK80XX_SUBD_DO;
@@ -1147,6 +1259,7 @@ static int vmk80xx_attach(struct comedi_device *cdev,
 	s->n_chan = dev->board.do_chans;
 	s->maxdata = 1;
 	s->insn_write = vmk80xx_do_winsn;
+	s->insn_bits = vmk80xx_do_bits;
 
 	if (dev->board.model == VMK8061_MODEL) {
 		s->subdev_flags |= SDF_READABLE;
-- 
1.7.4.1

