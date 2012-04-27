Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2D0Vgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:36:47 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:21923 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2D0Vgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:36:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-131.messagelabs.com!1335562598!20664919!8
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor serial2002 driver to remove forward declarations
Date: Fri, 27 Apr 2012 14:36:26 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271436.26454.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_driver and other variables to the end of the source.
This is more typical of how other drivers are written and removes
the need for the forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index d880c2f..a034b10 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -43,20 +43,10 @@ Status: in development
 #include <linux/serial.h>
 #include <linux/poll.h>
 
-/*
- * Board descriptions for two imaginary boards.  Describing the
- * boards in this way is optional, and completely driver-dependent.
- * Some drivers use arrays such as this, other do not.
- */
 struct serial2002_board {
 	const char *name;
 };
 
-static const struct serial2002_board serial2002_boards[] = {
-	{
-	 .name = "serial2002"}
-};
-
 /*
  * Useful for shorthand access to the particular board structure
  */
@@ -89,35 +79,6 @@ struct serial2002_private {
  */
 #define devpriv ((struct serial2002_private *)dev->private)
 
-static int serial2002_attach(struct comedi_device *dev,
-			     struct comedi_devconfig *it);
-static int serial2002_detach(struct comedi_device *dev);
-struct comedi_driver driver_serial2002 = {
-	.driver_name = "serial2002",
-	.module = THIS_MODULE,
-	.attach = serial2002_attach,
-	.detach = serial2002_detach,
-	.board_name = &serial2002_boards[0].name,
-	.offset = sizeof(struct serial2002_board),
-	.num_names = ARRAY_SIZE(serial2002_boards),
-};
-
-static int serial2002_di_rinsn(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-static int serial2002_do_winsn(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-static int serial2002_ai_rinsn(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-static int serial2002_ao_winsn(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-static int serial2002_ao_rinsn(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_insn *insn, unsigned int *data);
-
 struct serial_data {
 	enum { is_invalid, is_digital, is_channel } kind;
 	int index;
@@ -901,17 +862,32 @@ static int serial2002_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static const struct serial2002_board serial2002_boards[] = {
+	{
+		.name	= "serial2002"
+	},
+};
+
+struct comedi_driver driver_serial2002 = {
+	.driver_name	= "serial2002",
+	.module		= THIS_MODULE,
+	.attach		= serial2002_attach,
+	.detach		= serial2002_detach,
+	.board_name	= &serial2002_boards[0].name,
+	.offset		= sizeof(struct serial2002_board),
+	.num_names	= ARRAY_SIZE(serial2002_boards),
+};
+
 static int __init driver_serial2002_init_module(void)
 {
 	return comedi_driver_register(&driver_serial2002);
 }
+module_init(driver_serial2002_init_module);
 
 static void __exit driver_serial2002_cleanup_module(void)
 {
 	comedi_driver_unregister(&driver_serial2002);
 }
-
-module_init(driver_serial2002_init_module);
 module_exit(driver_serial2002_cleanup_module);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
