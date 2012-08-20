Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2HTVa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:30:27 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:30500 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab2HTVaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:30:21 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1345498212!8081128!34
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] staging: comedi: comedi_parport: remove devpriv macro
Date: Mon, 20 Aug 2012 14:30:08 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201430.09020.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro relies on a local variable having a specific name, Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/comedi_parport.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index 9a63cac..fcad423 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -96,11 +96,12 @@ struct parport_private {
 	unsigned int c_data;
 	int enable_irq;
 };
-#define devpriv ((struct parport_private *)(dev->private))
 
 static int parport_insn_a(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	struct parport_private *devpriv = dev->private;
+
 	if (data[0]) {
 		devpriv->a_data &= ~data[0];
 		devpriv->a_data |= (data[0] & data[1]);
@@ -117,6 +118,8 @@ static int parport_insn_config_a(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
 {
+	struct parport_private *devpriv = dev->private;
+
 	if (data[0]) {
 		s->io_bits = 0xff;
 		devpriv->c_data &= ~(1 << 5);
@@ -145,6 +148,8 @@ static int parport_insn_b(struct comedi_device *dev, struct comedi_subdevice *s,
 static int parport_insn_c(struct comedi_device *dev, struct comedi_subdevice *s,
 			  struct comedi_insn *insn, unsigned int *data)
 {
+	struct parport_private *devpriv = dev->private;
+
 	data[0] &= 0x0f;
 	if (data[0]) {
 		devpriv->c_data &= ~data[0];
@@ -245,6 +250,8 @@ static int parport_intr_cmdtest(struct comedi_device *dev,
 static int parport_intr_cmd(struct comedi_device *dev,
 			    struct comedi_subdevice *s)
 {
+	struct parport_private *devpriv = dev->private;
+
 	devpriv->c_data |= 0x10;
 	outb(devpriv->c_data, dev->iobase + PARPORT_C);
 
@@ -256,6 +263,8 @@ static int parport_intr_cmd(struct comedi_device *dev,
 static int parport_intr_cancel(struct comedi_device *dev,
 			       struct comedi_subdevice *s)
 {
+	struct parport_private *devpriv = dev->private;
+
 	printk(KERN_DEBUG "parport_intr_cancel()\n");
 
 	devpriv->c_data &= ~0x10;
@@ -269,6 +278,7 @@ static int parport_intr_cancel(struct comedi_device *dev,
 static irqreturn_t parport_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
+	struct parport_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->subdevices + 3;
 
 	if (!devpriv->enable_irq) {
@@ -286,6 +296,7 @@ static irqreturn_t parport_interrupt(int irq, void *d)
 static int parport_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	struct parport_private *devpriv;
 	int ret;
 	unsigned int irq;
 	unsigned long iobase;
@@ -316,9 +327,10 @@ static int parport_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	ret = alloc_private(dev, sizeof(struct parport_private));
+	ret = alloc_private(dev, sizeof(*devpriv));
 	if (ret < 0)
 		return ret;
+	devpriv = dev->private;
 
 	s = dev->subdevices + 0;
 	s->type = COMEDI_SUBD_DIO;
-- 
1.7.11

