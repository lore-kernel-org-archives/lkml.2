Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967153Ab2EPA3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 20:29:13 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:16679 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966208Ab2EPA3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 20:29:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1337128136!11725328!16
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor ni_atmio16d driver and use module_comedi_driver
Date: Tue, 15 May 2012 17:28:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205151728.53691.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the module_init/module_exit routines and the associated
struct comedi_drive to the end of the source. This is more
typical of how other drivers are written and removes the need
for the forward declarations.

Convert the driver to use the module_comedi_driver() macro
which makes the code smaller and a bit simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

 drivers/staging/comedi/drivers/ni_atmio16d.c |   73 +++++++------------------
 1 files changed, 21 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 285b933..8044e92 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -110,60 +110,8 @@ struct atmio16_board_t {
 	int has_8255;
 };
 
-static const struct atmio16_board_t atmio16_boards[] = {
-	{
-	 .name = "atmio16",
-	 .has_8255 = 0,
-	 },
-	{
-	 .name = "atmio16d",
-	 .has_8255 = 1,
-	 },
-};
-
-#define n_atmio16_boards ARRAY_SIZE(atmio16_boards)
-
 #define boardtype ((const struct atmio16_board_t *)dev->board_ptr)
 
-/* function prototypes */
-static int atmio16d_attach(struct comedi_device *dev,
-			   struct comedi_devconfig *it);
-static int atmio16d_detach(struct comedi_device *dev);
-static irqreturn_t atmio16d_interrupt(int irq, void *d);
-static int atmio16d_ai_cmdtest(struct comedi_device *dev,
-			       struct comedi_subdevice *s,
-			       struct comedi_cmd *cmd);
-static int atmio16d_ai_cmd(struct comedi_device *dev,
-			   struct comedi_subdevice *s);
-static int atmio16d_ai_cancel(struct comedi_device *dev,
-			      struct comedi_subdevice *s);
-static void reset_counters(struct comedi_device *dev);
-static void reset_atmio16d(struct comedi_device *dev);
-
-/* main driver struct */
-static struct comedi_driver driver_atmio16d = {
-	.driver_name = "atmio16",
-	.module = THIS_MODULE,
-	.attach = atmio16d_attach,
-	.detach = atmio16d_detach,
-	.board_name = &atmio16_boards[0].name,
-	.num_names = n_atmio16_boards,
-	.offset = sizeof(struct atmio16_board_t),
-};
-
-static int __init driver_atmio16d_init_module(void)
-{
-	return comedi_driver_register(&driver_atmio16d);
-}
-
-static void __exit driver_atmio16d_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_atmio16d);
-}
-
-module_init(driver_atmio16d_init_module);
-module_exit(driver_atmio16d_cleanup_module);
-
 /* range structs */
 static const struct comedi_lrange range_atmio16d_ai_10_bipolar = { 4, {
 								       BIP_RANGE
@@ -899,6 +847,27 @@ static int atmio16d_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static const struct atmio16_board_t atmio16_boards[] = {
+	{
+		.name		= "atmio16",
+		.has_8255	= 0,
+	}, {
+		.name		= "atmio16d",
+		.has_8255	= 1,
+	},
+};
+
+static struct comedi_driver atmio16d_driver = {
+	.driver_name	= "atmio16",
+	.module		= THIS_MODULE,
+	.attach		= atmio16d_attach,
+	.detach		= atmio16d_detach,
+	.board_name	= &atmio16_boards[0].name,
+	.num_names	= ARRAY_SIZE(atmio16_boards),
+	.offset		= sizeof(struct atmio16_board_t),
+};
+module_comedi_driver(atmio16d_driver);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
