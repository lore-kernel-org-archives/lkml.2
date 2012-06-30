Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2F3Agx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 20:36:53 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:24783 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2F3Agw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 20:36:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-209.messagelabs.com!1341016610!7343737!2
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/10] staging: comedi: ni_670x: remove thisboard and devpriv macros
Date: Fri, 29 Jun 2012 17:36:45 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206291736.45750.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'thisboard' and 'devpriv' macros rely on a local variable having
a specific name and yield pointers derived from that local variable.
Replace the macros with local variables where used. Use the
comedi_board() helper to get the 'thisboard' pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_670x.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index e9270af..b75eed4 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -88,8 +88,6 @@ static const struct ni_670x_board ni_670x_boards[] = {
 	 },
 };
 
-#define thisboard ((struct ni_670x_board *)dev->board_ptr)
-
 struct ni_670x_private {
 
 	struct mite_struct *mite;
@@ -98,7 +96,6 @@ struct ni_670x_private {
 	unsigned int ao_readback[32];
 };
 
-#define devpriv ((struct ni_670x_private *)dev->private)
 #define n_ni_670x_boards ARRAY_SIZE(ni_670x_boards)
 
 static struct comedi_lrange range_0_20mA = { 1, {RANGE_mA(0, 20)} };
@@ -107,6 +104,7 @@ static int ni_670x_ao_winsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct ni_670x_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -137,6 +135,7 @@ static int ni_670x_ao_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
 {
+	struct ni_670x_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
@@ -150,6 +149,8 @@ static int ni_670x_dio_insn_bits(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct ni_670x_private *devpriv = dev->private;
+
 	/* The insn data is a mask in data[0] and the new data
 	 * in data[1], each channel cooresponding to a bit. */
 	if (data[0]) {
@@ -170,6 +171,7 @@ static int ni_670x_dio_insn_config(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn, unsigned int *data)
 {
+	struct ni_670x_private *devpriv = dev->private;
 	int chan = CR_CHAN(insn->chanspec);
 
 	switch (data[0]) {
@@ -195,6 +197,7 @@ static int ni_670x_dio_insn_config(struct comedi_device *dev,
 
 static int ni_670x_find_device(struct comedi_device *dev, int bus, int slot)
 {
+	struct ni_670x_private *devpriv = dev->private;
 	struct mite_struct *mite;
 	int i;
 
@@ -224,19 +227,23 @@ static int ni_670x_find_device(struct comedi_device *dev, int bus, int slot)
 static int ni_670x_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct ni_670x_board *thisboard;
+	struct ni_670x_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
 	int i;
 
 	printk(KERN_INFO "comedi%d: ni_670x: ", dev->minor);
 
-	ret = alloc_private(dev, sizeof(struct ni_670x_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	ret = ni_670x_find_device(dev, it->options[0], it->options[1]);
 	if (ret < 0)
 		return ret;
+	thisboard = comedi_board(dev);
 
 	ret = mite_setup(devpriv->mite);
 	if (ret < 0) {
@@ -297,8 +304,10 @@ static int ni_670x_attach(struct comedi_device *dev,
 
 static void ni_670x_detach(struct comedi_device *dev)
 {
+	struct ni_670x_private *devpriv = dev->private;
+
 	kfree(dev->subdevices[0].range_table_list);
-	if (dev->private && devpriv->mite)
+	if (devpriv && devpriv->mite)
 		mite_unsetup(devpriv->mite);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-- 
1.7.11

