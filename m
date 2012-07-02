Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2GBWnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:43:33 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:13907 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2GBWnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:43:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1341269009!13205269!2
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/12] staging: comedi: das08_cs: consolidate the init and exit functions
Date: Mon, 2 Jul 2012 15:43:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021543.19612.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The register/unregister of the pcmcia driver is done in separate
functions that are called by the module_{init,exit} routines.
Simplify the code a bit by moving the register/unregister into
the module_{init,exit} routines.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08_cs.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index f62e5f8..14dfc81 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -235,36 +235,23 @@ struct pcmcia_driver das08_cs_driver = {
 	.name = "pcm-das08",
 };
 
-static int __init init_das08_pcmcia_cs(void)
-{
-	pcmcia_register_driver(&das08_cs_driver);
-	return 0;
-}
-
-static void __exit exit_das08_pcmcia_cs(void)
-{
-	pr_debug("das08_pcmcia_cs: unloading\n");
-	pcmcia_unregister_driver(&das08_cs_driver);
-}
-
 static int __init das08_cs_init_module(void)
 {
 	int ret;
 
-	ret = init_das08_pcmcia_cs();
+	ret = pcmcia_register_driver(&das08_cs_driver);
 	if (ret < 0)
 		return ret;
 
 	return comedi_driver_register(&driver_das08_cs);
 }
+module_init(das08_cs_init_module);
 
 static void __exit das08_cs_exit_module(void)
 {
-	exit_das08_pcmcia_cs();
+	pcmcia_unregister_driver(&das08_cs_driver);
 	comedi_driver_unregister(&driver_das08_cs);
 }
-
-module_init(das08_cs_init_module);
 module_exit(das08_cs_exit_module);
 
 MODULE_AUTHOR("David A. Schleef <ds@schleef.org>, "
-- 
1.7.11

