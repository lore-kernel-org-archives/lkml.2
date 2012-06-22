Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762879Ab2FVXkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:40:53 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:62695 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab2FVXkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:40:52 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1340408450!12239790!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 31/31] staging: comedi: ni_daq_700: refactor the pcmcia attach/detach
Date: Fri, 22 Jun 2012 16:40:40 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221640.40813.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the pcmcia_disable_device() call where needed in the
pcmcia attach/detach and delete the dio700_release() function.

Move the logic of dio700_config() directly into the attach
function and properly return an error code when the config
fails.

Only set the pcmcia_cur_dev, used by the comedi_driver, if
the pcmcia attach is successful. Also, make sure to NULL it
in the detach.

Remove all the kernel messages in the pcmcia support code. They
are just added noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 39 +++++++----------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index c57300f..83016b41 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -164,13 +164,6 @@ static struct comedi_driver driver_dio700 = {
 	.offset		= sizeof(struct dio700_board),
 };
 
-static void dio700_release(struct pcmcia_device *link)
-{
-	dev_dbg(&link->dev, "%s\n", __func__);
-
-	pcmcia_disable_device(link);
-}
-
 static int dio700_pcmcia_config_loop(struct pcmcia_device *p_dev,
 				void *priv_data)
 {
@@ -180,50 +173,36 @@ static int dio700_pcmcia_config_loop(struct pcmcia_device *p_dev,
 	return pcmcia_request_io(p_dev);
 }
 
-static void dio700_config(struct pcmcia_device *link)
+static int dio700_cs_attach(struct pcmcia_device *link)
 {
 	int ret;
 
-	dev_dbg(&link->dev, "%s\n", __func__);
-
 	link->config_flags |= CONF_ENABLE_IRQ | CONF_AUTO_AUDIO |
 		CONF_AUTO_SET_IO;
 
 	ret = pcmcia_loop_config(link, dio700_pcmcia_config_loop, NULL);
-	if (ret) {
-		dev_warn(&link->dev, "no configuration found\n");
+	if (ret)
 		goto failed;
-	}
 
 	if (!link->irq)
 		goto failed;
 
 	ret = pcmcia_enable_device(link);
-	if (ret != 0)
+	if (ret)
 		goto failed;
 
-	return;
-
-failed:
-	dev_dbg(&link->dev, "%s failed\n", __func__);
-	dio700_release(link);
-
-}
-
-static int dio700_cs_attach(struct pcmcia_device *link)
-{
-	dev_dbg(&link->dev, "%s\n", __func__);
-
 	pcmcia_cur_dev = link;
-
-	dio700_config(link);
-
 	return 0;
+
+failed:
+	pcmcia_disable_device(link);
+	return ret;
 }
 
 static void dio700_cs_detach(struct pcmcia_device *link)
 {
-	dio700_release(link);
+	pcmcia_disable_device(link);
+	pcmcia_cur_dev = NULL;
 }
 
 static const struct pcmcia_device_id dio700_cs_ids[] = {
-- 
1.7.11

