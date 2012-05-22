Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2EVWcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:32:07 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:30835 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab2EVWcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:32:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1337725824!7225373!54
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove this_board macro in the acl7225b driver
Date: Tue, 22 May 2012 15:31:41 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221531.42335.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'this_board' macro depends on having a local variable with
a magic name. The CodingStyle document suggests not doing this
to avoid confusion. Remove the macro and use the comedi_board()
inline helper to get the dev->board_ptr information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index 4e4fc41..c1963ad 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -27,8 +27,6 @@ struct boardtype {
 	int io_range;		/*  len of I/O space */
 };
 
-#define this_board ((const struct boardtype *)dev->board_ptr)
-
 static int acl7225b_do_insn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
@@ -67,19 +65,20 @@ static int acl7225b_di_insn(struct comedi_device *dev,
 static int acl7225b_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
+	const struct boardtype *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	int iobase, iorange;
 
 	iobase = it->options[0];
-	iorange = this_board->io_range;
+	iorange = board->io_range;
 	printk(KERN_INFO "comedi%d: acl7225b: board=%s 0x%04x\n", dev->minor,
-	       this_board->name, iobase);
+	       board->name, iobase);
 	if (!request_region(iobase, iorange, "acl7225b")) {
 		printk(KERN_ERR "comedi%d: request_region failed - I/O port conflict\n",
 			dev->minor);
 		return -EIO;
 	}
-	dev->board_name = this_board->name;
+	dev->board_name = board->name;
 	dev->iobase = iobase;
 	dev->irq = 0;
 
@@ -121,8 +120,10 @@ static int acl7225b_attach(struct comedi_device *dev,
 
 static void acl7225b_detach(struct comedi_device *dev)
 {
+	const struct boardtype *board = comedi_board(dev);
+
 	if (dev->iobase)
-		release_region(dev->iobase, this_board->io_range);
+		release_region(dev->iobase, board->io_range);
 }
 
 static const struct boardtype boardtypes[] = {
