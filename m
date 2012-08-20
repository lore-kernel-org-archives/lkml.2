Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab2HTS2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:28:25 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:58797 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab2HTS2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:28:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1345487300!12182654!3
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] staging: comedi: aio_aio12_8: remove devpriv macro
Date: Mon, 20 Aug 2012 11:28:07 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208201128.07721.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro relies on a local variable having a specific name. Remove
it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/aio_aio12_8.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index f7d453f..71364c6 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -84,8 +84,6 @@ struct aio12_8_private {
 	unsigned int ao_readback[4];
 };
 
-#define devpriv	((struct aio12_8_private *) dev->private)
-
 static int aio_aio12_8_ai_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
@@ -125,6 +123,7 @@ static int aio_aio12_8_ao_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn, unsigned int *data)
 {
+	struct aio12_8_private *devpriv = dev->private;
 	int i;
 	int val = devpriv->ao_readback[CR_CHAN(insn->chanspec)];
 
@@ -137,6 +136,7 @@ static int aio_aio12_8_ao_write(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
+	struct aio12_8_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 	unsigned long port = dev->iobase + AIO12_8_DAC_0 + (2 * chan);
@@ -166,6 +166,7 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
 	const struct aio12_8_boardtype *board = comedi_board(dev);
+	struct aio12_8_private *devpriv;
 	int iobase;
 	struct comedi_subdevice *s;
 	int ret;
@@ -180,8 +181,10 @@ static int aio_aio12_8_attach(struct comedi_device *dev,
 
 	dev->iobase = iobase;
 
-	if (alloc_private(dev, sizeof(struct aio12_8_private)) < 0)
-		return -ENOMEM;
+	ret = alloc_private(dev, sizeof(*devpriv));
+	if (ret)
+		return ret;
+	devpriv = dev->private;
 
 	ret = comedi_alloc_subdevices(dev, 3);
 	if (ret)
-- 
1.7.11

