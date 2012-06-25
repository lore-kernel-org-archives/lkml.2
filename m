Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab2FYXTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:19:54 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:25802 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab2FYXTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:19:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-132.messagelabs.com!1340666390!12496135!3
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/33] staging: comedi: cb_das16_cs: refactor the pcmcia attach/detach
Date: Mon, 25 Jun 2012 16:19:32 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251619.32561.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the pcmcia_disable_device() call where needed in the
pcmcia attach/detach and delete the das16cs_pcmcia_release()
function.

Move the logic of das16cs_pcmcia_config() directly into the
attach function and properly return an error code when the
config fails.

Only set the cur_dev, used by the comedi_driver, if the pcmcia
attach is successful. Also, make sure to NULL it in the detach.

Remove all the kernel messages in the pcmcia support code. They
are just added noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 51 ++++++++--------------------
 1 file changed, 15 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index dc9c823..5171cfe 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -629,12 +629,6 @@ struct local_info_t {
 	struct bus_operations *bus;
 };
 
-static void das16cs_pcmcia_release(struct pcmcia_device *link)
-{
-	dev_dbg(&link->dev, "das16cs_pcmcia_release\n");
-	pcmcia_disable_device(link);
-}
-
 static int das16cs_pcmcia_config_loop(struct pcmcia_device *p_dev,
 				void *priv_data)
 {
@@ -644,20 +638,24 @@ static int das16cs_pcmcia_config_loop(struct pcmcia_device *p_dev,
 	return pcmcia_request_io(p_dev);
 }
 
-static void das16cs_pcmcia_config(struct pcmcia_device *link)
+static int das16cs_pcmcia_attach(struct pcmcia_device *link)
 {
+	struct local_info_t *local;
 	int ret;
 
-	dev_dbg(&link->dev, "das16cs_pcmcia_config\n");
+	/* Allocate space for private device-specific data */
+	local = kzalloc(sizeof(struct local_info_t), GFP_KERNEL);
+	if (!local)
+		return -ENOMEM;
+	local->link = link;
+	link->priv = local;
 
 	/* Do we need to allocate an interrupt? */
 	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_SET_IO;
 
 	ret = pcmcia_loop_config(link, das16cs_pcmcia_config_loop, NULL);
-	if (ret) {
-		dev_warn(&link->dev, "no configuration found\n");
+	if (ret)
 		goto failed;
-	}
 
 	if (!link->irq)
 		goto failed;
@@ -666,40 +664,21 @@ static void das16cs_pcmcia_config(struct pcmcia_device *link)
 	if (ret)
 		goto failed;
 
-	return;
-
-failed:
-	das16cs_pcmcia_release(link);
-}
-
-static int das16cs_pcmcia_attach(struct pcmcia_device *link)
-{
-	struct local_info_t *local;
-
-	dev_dbg(&link->dev, "das16cs_pcmcia_attach()\n");
-
-	/* Allocate space for private device-specific data */
-	local = kzalloc(sizeof(struct local_info_t), GFP_KERNEL);
-	if (!local)
-		return -ENOMEM;
-	local->link = link;
-	link->priv = local;
-
 	cur_dev = link;
-
-	das16cs_pcmcia_config(link);
-
 	return 0;
+
+failed:
+	pcmcia_disable_device(link);
+	return ret;
 }
 
 static void das16cs_pcmcia_detach(struct pcmcia_device *link)
 {
-	dev_dbg(&link->dev, "das16cs_pcmcia_detach\n");
-
 	((struct local_info_t *)link->priv)->stop = 1;
-	das16cs_pcmcia_release(link);
+	pcmcia_disable_device(link);
 	/* This points to the parent struct local_info_t struct */
 	kfree(link->priv);
+	cur_dev = NULL;
 }
 
 static int das16cs_pcmcia_suspend(struct pcmcia_device *link)
-- 
1.7.11

