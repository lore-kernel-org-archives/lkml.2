Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab2GBWoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:44:00 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:31123 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2GBWn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:43:59 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-131.messagelabs.com!1341269038!22235823!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/12] staging: comedi: das08_cs: change driver registration order
Date: Mon, 2 Jul 2012 15:43:52 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021543.52858.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As done with the other comedi driver types, register the
comedi_driver first then the pcmcia_driver. Also, make sure
the pcmcia_driver registration succeeds and unregister the
comedi_driver if it fails.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08_cs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index 14dfc81..493078a 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -239,11 +239,18 @@ static int __init das08_cs_init_module(void)
 {
 	int ret;
 
-	ret = pcmcia_register_driver(&das08_cs_driver);
+	ret = comedi_driver_register(&driver_das08_cs);
 	if (ret < 0)
 		return ret;
 
-	return comedi_driver_register(&driver_das08_cs);
+	ret = pcmcia_register_driver(&das08_cs_driver);
+	if (ret < 0) {
+		comedi_driver_unregister(&driver_das08_cs);
+		return ret;
+	}
+
+	return 0;
+
 }
 module_init(das08_cs_init_module);
 
-- 
1.7.11

