Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762779Ab2FVXR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:17:29 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:52957 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab2FVXR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:17:27 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1340407045!23230012!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/31] staging: comedi: ni_daq_700: refactor the pcmcia support code
Date: Fri, 22 Jun 2012 16:17:20 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221617.20738.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the pcmcia support code to remove the need for the
forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 80 +++++++++++++----------------
 1 file changed, 36 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 1059297..f9b0d67 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -306,49 +306,11 @@ static void dio700_detach(struct comedi_device *dev)
 		free_irq(dev->irq, dev);
 };
 
-static void dio700_config(struct pcmcia_device *link);
-static void dio700_release(struct pcmcia_device *link);
-static int dio700_cs_suspend(struct pcmcia_device *p_dev);
-static int dio700_cs_resume(struct pcmcia_device *p_dev);
-
-static int dio700_cs_attach(struct pcmcia_device *);
-static void dio700_cs_detach(struct pcmcia_device *);
-
-struct local_info_t {
-	struct pcmcia_device *link;
-	int stop;
-	struct bus_operations *bus;
-};
-
-static int dio700_cs_attach(struct pcmcia_device *link)
-{
-	struct local_info_t *local;
-
-	printk(KERN_INFO "ni_daq_700:  cs-attach\n");
-
-	dev_dbg(&link->dev, "dio700_cs_attach()\n");
-
-	/* Allocate space for private device-specific data */
-	local = kzalloc(sizeof(struct local_info_t), GFP_KERNEL);
-	if (!local)
-		return -ENOMEM;
-	local->link = link;
-	link->priv = local;
-
-	pcmcia_cur_dev = link;
-
-	dio700_config(link);
-
-	return 0;
-}
-
-static void dio700_cs_detach(struct pcmcia_device *link)
+static void dio700_release(struct pcmcia_device *link)
 {
-	((struct local_info_t *)link->priv)->stop = 1;
-	dio700_release(link);
+	dev_dbg(&link->dev, "dio700_release\n");
 
-	/* This points to the parent struct local_info_t struct */
-	kfree(link->priv);
+	pcmcia_disable_device(link);
 }
 
 static int dio700_pcmcia_config_loop(struct pcmcia_device *p_dev,
@@ -392,11 +354,41 @@ failed:
 
 }
 
-static void dio700_release(struct pcmcia_device *link)
+struct local_info_t {
+	struct pcmcia_device *link;
+	int stop;
+	struct bus_operations *bus;
+};
+
+static int dio700_cs_attach(struct pcmcia_device *link)
 {
-	dev_dbg(&link->dev, "dio700_release\n");
+	struct local_info_t *local;
 
-	pcmcia_disable_device(link);
+	printk(KERN_INFO "ni_daq_700:  cs-attach\n");
+
+	dev_dbg(&link->dev, "dio700_cs_attach()\n");
+
+	/* Allocate space for private device-specific data */
+	local = kzalloc(sizeof(struct local_info_t), GFP_KERNEL);
+	if (!local)
+		return -ENOMEM;
+	local->link = link;
+	link->priv = local;
+
+	pcmcia_cur_dev = link;
+
+	dio700_config(link);
+
+	return 0;
+}
+
+static void dio700_cs_detach(struct pcmcia_device *link)
+{
+	((struct local_info_t *)link->priv)->stop = 1;
+	dio700_release(link);
+
+	/* This points to the parent struct local_info_t struct */
+	kfree(link->priv);
 }
 
 static int dio700_cs_suspend(struct pcmcia_device *link)
-- 
1.7.11

