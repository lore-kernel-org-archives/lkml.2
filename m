Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2D0WsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:48:18 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:58181 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab2D0WsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:48:17 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1335566873!4212547!32
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: refactor pcmad driver to remove forward declarations
Date: Fri, 27 Apr 2012 15:48:07 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204271548.07918.hartleys@visionengravers.com>
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

diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index 23b3d77..fe8ef66 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -57,19 +57,8 @@ struct pcmad_board_struct {
 	const char *name;
 	int n_ai_bits;
 };
-static const struct pcmad_board_struct pcmad_boards[] = {
-	{
-	 .name = "pcmad12",
-	 .n_ai_bits = 12,
-	 },
-	{
-	 .name = "pcmad16",
-	 .n_ai_bits = 16,
-	 },
-};
 
 #define this_board ((const struct pcmad_board_struct *)(dev->board_ptr))
-#define n_pcmad_boards ARRAY_SIZE(pcmad_boards)
 
 struct pcmad_priv_struct {
 	int differential;
@@ -77,31 +66,6 @@ struct pcmad_priv_struct {
 };
 #define devpriv ((struct pcmad_priv_struct *)dev->private)
 
-static int pcmad_attach(struct comedi_device *dev, struct comedi_devconfig *it);
-static int pcmad_detach(struct comedi_device *dev);
-static struct comedi_driver driver_pcmad = {
-	.driver_name = "pcmad",
-	.module = THIS_MODULE,
-	.attach = pcmad_attach,
-	.detach = pcmad_detach,
-	.board_name = &pcmad_boards[0].name,
-	.num_names = n_pcmad_boards,
-	.offset = sizeof(pcmad_boards[0]),
-};
-
-static int __init driver_pcmad_init_module(void)
-{
-	return comedi_driver_register(&driver_pcmad);
-}
-
-static void __exit driver_pcmad_cleanup_module(void)
-{
-	comedi_driver_unregister(&driver_pcmad);
-}
-
-module_init(driver_pcmad_init_module);
-module_exit(driver_pcmad_cleanup_module);
-
 #define TIMEOUT	100
 
 static int pcmad_ai_insn_read(struct comedi_device *dev,
@@ -188,6 +152,37 @@ static int pcmad_detach(struct comedi_device *dev)
 	return 0;
 }
 
+static const struct pcmad_board_struct pcmad_boards[] = {
+	{
+		.name		= "pcmad12",
+		.n_ai_bits	= 12,
+	}, {
+		.name		= "pcmad16",
+		.n_ai_bits	= 16,
+	},
+};
+static struct comedi_driver driver_pcmad = {
+	.driver_name	= "pcmad",
+	.module		= THIS_MODULE,
+	.attach		= pcmad_attach,
+	.detach		= pcmad_detach,
+	.board_name	= &pcmad_boards[0].name,
+	.num_names	= ARRAY_SIZE(pcmad_boards),
+	.offset		= sizeof(pcmad_boards[0]),
+};
+
+static int __init driver_pcmad_init_module(void)
+{
+	return comedi_driver_register(&driver_pcmad);
+}
+module_init(driver_pcmad_init_module);
+
+static void __exit driver_pcmad_cleanup_module(void)
+{
+	comedi_driver_unregister(&driver_pcmad);
+}
+module_exit(driver_pcmad_cleanup_module);
+
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
 MODULE_LICENSE("GPL");
