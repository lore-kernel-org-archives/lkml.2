Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964772Ab2GBWr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:47:57 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:42553 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab2GBWr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:47:56 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-160.messagelabs.com!1341269275!8517074!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/12] staging: comedi: das08_cs: refactor the pcmcia probe/remove
Date: Mon, 2 Jul 2012 15:47:47 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021547.48115.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the pcmcia_disable_device() call where needed in the pcmcia
probe/remove and delete the das08_pcmcia_release() function.

Move the logic of the das08_pcmcia_config() directly into the
probe function and properly return an error code when the config
fails.

Only set cur_dev, used by the comedi_driver, if the pcmcia probe
is successful. Also, make sure to NULL it in the remove.

Remove all the kernel messages in the pcmcia support code. They
are just added noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/das08_cs.c | 38 +++++++------------------------
 1 file changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index d02250e..f2f33e1 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -104,12 +104,6 @@ static int das08_cs_attach(struct comedi_device *dev,
 	return das08_common_attach(dev, iobase);
 }
 
-static void das08_pcmcia_release(struct pcmcia_device *link)
-{
-	dev_dbg(&link->dev, "das08_pcmcia_release\n");
-	pcmcia_disable_device(link);
-}
-
 static int das08_pcmcia_config_loop(struct pcmcia_device *p_dev,
 				void *priv_data)
 {
@@ -119,19 +113,15 @@ static int das08_pcmcia_config_loop(struct pcmcia_device *p_dev,
 	return pcmcia_request_io(p_dev);
 }
 
-static void das08_pcmcia_config(struct pcmcia_device *link)
+static int das08_pcmcia_attach(struct pcmcia_device *link)
 {
 	int ret;
 
-	dev_dbg(&link->dev, "das08_pcmcia_config\n");
-
 	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
 
 	ret = pcmcia_loop_config(link, das08_pcmcia_config_loop, NULL);
-	if (ret) {
-		dev_warn(&link->dev, "no configuration found\n");
+	if (ret)
 		goto failed;
-	}
 
 	if (!link->irq)
 		goto failed;
@@ -140,30 +130,18 @@ static void das08_pcmcia_config(struct pcmcia_device *link)
 	if (ret)
 		goto failed;
 
-	return;
-
-failed:
-	das08_pcmcia_release(link);
-
-}
-
-static int das08_pcmcia_attach(struct pcmcia_device *link)
-{
-	dev_dbg(&link->dev, "das08_pcmcia_attach()\n");
-
 	cur_dev = link;
-
-	das08_pcmcia_config(link);
-
 	return 0;
+
+failed:
+	pcmcia_disable_device(link);
+	return ret;
 }
 
 static void das08_pcmcia_detach(struct pcmcia_device *link)
 {
-
-	dev_dbg(&link->dev, "das08_pcmcia_detach\n");
-
-	das08_pcmcia_release(link);
+	pcmcia_disable_device(link);
+	cur_dev = NULL;
 }
 
 static const struct pcmcia_device_id das08_cs_id_table[] = {
-- 
1.7.11

