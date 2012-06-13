Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2FMWmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:42:24 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:38054 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab2FMWmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:42:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-209.messagelabs.com!1339627322!8436509!6
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/15] staging: comedi: 8255: push out the 8255's private data variable rename
Date: Wed, 13 Jun 2012 15:42:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131542.02993.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push out the rename of the private variables to improve the readability
of the driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c |   32 +++++++++++++++-----------------
 drivers/staging/comedi/drivers/8255.h |    8 ++++----
 2 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 7b7768b..80ef031 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -60,15 +60,15 @@ I/O port base address can be found in the output of 'lspci -v'.
    set up the subdevice in the attach function of the driver by
    calling:
 
-     subdev_8255_init(device, subdevice, callback_function, arg)
+     subdev_8255_init(device, subdevice, io_function, iobase)
 
    device and subdevice are pointers to the device and subdevice
-   structures.  callback_function will be called to provide the
+   structures.  io_function will be called to provide the
    low-level input/output to the device, i.e., actual register
-   access.  callback_function will be called with the value of arg
+   access.  io_function will be called with the value of iobase
    as the last parameter.  If the 8255 device is mapped as 4
-   consecutive I/O ports, you can use NULL for callback_function
-   and the I/O port base for arg, and an internal function will
+   consecutive I/O ports, you can use NULL for io_function
+   and the I/O port base for iobase, and an internal function will
    handle the register access.
 
    In addition, if the main driver handles interrupts, you can
@@ -119,10 +119,8 @@ void subdev_8255_interrupt(struct comedi_device *dev,
 }
 EXPORT_SYMBOL(subdev_8255_interrupt);
 
-static int subdev_8255_cb(int dir, int port, int data, unsigned long arg)
+static int subdev_8255_io(int dir, int port, int data, unsigned long iobase)
 {
-	unsigned long iobase = arg;
-
 	if (dir) {
 		outb(data, iobase + port);
 		return 0;
@@ -307,8 +305,8 @@ static int subdev_8255_cancel(struct comedi_device *dev,
 }
 
 int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
-		     int (*cb) (int, int, int, unsigned long),
-		     unsigned long arg)
+		     int (*io) (int, int, int, unsigned long),
+		     unsigned long iobase)
 {
 	struct subdev_8255_private *spriv;
 
@@ -323,11 +321,11 @@ int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
 		return -ENOMEM;
 	s->private = spriv;
 
-	spriv->iobase = arg;
-	if (cb == NULL)
-		spriv->io = subdev_8255_cb;
+	spriv->iobase = iobase;
+	if (io == NULL)
+		spriv->io = subdev_8255_io;
 	else
-		spriv->io = cb;
+		spriv->io = io;
 	s->insn_bits = subdev_8255_insn;
 	s->insn_config = subdev_8255_insn_config;
 
@@ -340,13 +338,13 @@ int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
 EXPORT_SYMBOL(subdev_8255_init);
 
 int subdev_8255_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,
-			 int (*cb) (int, int, int, unsigned long),
-			 unsigned long arg)
+			 int (*io) (int, int, int, unsigned long),
+			 unsigned long iobase)
 {
 	struct subdev_8255_private *spriv;
 	int ret;
 
-	ret = subdev_8255_init(dev, s, cb, arg);
+	ret = subdev_8255_init(dev, s, io, iobase);
 	if (ret < 0)
 		return ret;
 	spriv = s->private;
diff --git a/drivers/staging/comedi/drivers/8255.h b/drivers/staging/comedi/drivers/8255.h
index b6314c9..1e589b4 100644
--- a/drivers/staging/comedi/drivers/8255.h
+++ b/drivers/staging/comedi/drivers/8255.h
@@ -27,11 +27,11 @@
 #include "../comedidev.h"
 
 int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
-		     int (*cb) (int, int, int, unsigned long),
-		     unsigned long arg);
+		     int (*io) (int, int, int, unsigned long),
+		     unsigned long iobase);
 int subdev_8255_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,
-			 int (*cb) (int, int, int, unsigned long),
-			 unsigned long arg);
+			 int (*io) (int, int, int, unsigned long),
+			 unsigned long iobase);
 void subdev_8255_cleanup(struct comedi_device *dev, struct comedi_subdevice *s);
 void subdev_8255_interrupt(struct comedi_device *dev,
 			   struct comedi_subdevice *s);
-- 
1.7.7

