Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030447Ab2HQCpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:45:09 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:37954 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab2HQCpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:45:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-209.messagelabs.com!1345171504!3480203!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/35] staging: comedi: cb_pcidda: remove thisboard and devpriv macros
Date: Thu, 16 Aug 2012 19:44:59 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161944.59593.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros rely on a local variable having a specific name.
Remove them and use the comedi_board() helper to get the thisboard
pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidda.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 12660a3..63f5d70 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -203,11 +203,6 @@ static const struct cb_pcidda_board cb_pcidda_boards[] = {
 };
 
 /*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct cb_pcidda_board *)dev->board_ptr)
-
-/*
  * this structure is for data unique to this hardware driver.  If
  * several hardware drivers keep similar information in this structure,
  * feel free to suggest moving the variable to the struct comedi_device
@@ -229,12 +224,6 @@ struct cb_pcidda_private {
 	u16 eeprom_data[EEPROM_SIZE];	/*  software copy of board's eeprom */
 };
 
-/*
- * most drivers define the following macro to make it easy to
- * access the private structure.
- */
-#define devpriv ((struct cb_pcidda_private *)dev->private)
-
 /* static int cb_pcidda_ai_rinsn(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data); */
 static int cb_pcidda_ao_winsn(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
@@ -289,21 +278,23 @@ static struct pci_dev *cb_pcidda_find_pci_dev(struct comedi_device *dev,
 static int cb_pcidda_attach(struct comedi_device *dev,
 			    struct comedi_devconfig *it)
 {
+	const struct cb_pcidda_board *thisboard;
+	struct cb_pcidda_private *devpriv;
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
 	int index;
 	int ret;
 
-/*
- * Allocate the private structure area.
- */
-	if (alloc_private(dev, sizeof(struct cb_pcidda_private)) < 0)
-		return -ENOMEM;
+	ret = alloc_private(dev, sizeof(*devpriv));
+	if (ret)
+		return ret;
+	devpriv = dev->private;
 
 	pcidev = cb_pcidda_find_pci_dev(dev, it);
 	if (!pcidev)
 		return -EIO;
 	comedi_set_hw_dev(dev, &pcidev->dev);
+	thisboard = comedi_board(dev);
 
 	/*
 	 * Enable PCI device and request regions.
@@ -585,6 +576,7 @@ static int cb_pcidda_ao_winsn(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data)
 {
+	struct cb_pcidda_private *devpriv = dev->private;
 	unsigned int command;
 	unsigned int channel, range;
 
@@ -634,6 +626,7 @@ static int cb_pcidda_ao_winsn(struct comedi_device *dev,
 /* lowlevel read from eeprom */
 static unsigned int cb_pcidda_serial_in(struct comedi_device *dev)
 {
+	struct cb_pcidda_private *devpriv = dev->private;
 	unsigned int value = 0;
 	int i;
 	const int value_width = 16;	/*  number of bits wide values are */
@@ -651,6 +644,7 @@ static unsigned int cb_pcidda_serial_in(struct comedi_device *dev)
 static void cb_pcidda_serial_out(struct comedi_device *dev, unsigned int value,
 				 unsigned int num_bits)
 {
+	struct cb_pcidda_private *devpriv = dev->private;
 	int i;
 
 	for (i = 1; i <= num_bits; i++) {
@@ -667,6 +661,7 @@ static void cb_pcidda_serial_out(struct comedi_device *dev, unsigned int value,
 static unsigned int cb_pcidda_read_eeprom(struct comedi_device *dev,
 					  unsigned int address)
 {
+	struct cb_pcidda_private *devpriv = dev->private;
 	unsigned int i;
 	unsigned int cal2_bits;
 	unsigned int value;
@@ -703,6 +698,7 @@ static void cb_pcidda_write_caldac(struct comedi_device *dev,
 				   unsigned int caldac, unsigned int channel,
 				   unsigned int value)
 {
+	struct cb_pcidda_private *devpriv = dev->private;
 	unsigned int cal2_bits;
 	unsigned int i;
 	/* caldacs use 3 bit channel specification */
@@ -797,6 +793,7 @@ static unsigned int eeprom_fine_byte(unsigned int word)
 static void cb_pcidda_calibrate(struct comedi_device *dev, unsigned int channel,
 				unsigned int range)
 {
+	struct cb_pcidda_private *devpriv = dev->private;
 	unsigned int coarse_offset, fine_offset, coarse_gain, fine_gain;
 
 	/* remember range so we can tell when we need to readjust calibration */
-- 
1.7.11

