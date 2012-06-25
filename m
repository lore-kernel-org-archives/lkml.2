Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2FYXPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:15:48 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:52216 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab2FYXPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:15:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-160.messagelabs.com!1340666145!5137710!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/33] staging: comedi: cb_das16_cs: refactor the pcmcia support code
Date: Mon, 25 Jun 2012 16:15:40 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251615.41192.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the pcmcia support code to remove the need for the
forward declarations.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 68 ++++++++++++----------------
 1 file changed, 30 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 2063215..dc9c823 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -623,48 +623,16 @@ static int das16cs_timer_insn_config(struct comedi_device *dev,
 	return -EINVAL;
 }
 
-static void das16cs_pcmcia_config(struct pcmcia_device *link);
-static void das16cs_pcmcia_release(struct pcmcia_device *link);
-static int das16cs_pcmcia_suspend(struct pcmcia_device *p_dev);
-static int das16cs_pcmcia_resume(struct pcmcia_device *p_dev);
-
-static int das16cs_pcmcia_attach(struct pcmcia_device *);
-static void das16cs_pcmcia_detach(struct pcmcia_device *);
-
 struct local_info_t {
 	struct pcmcia_device *link;
 	int stop;
 	struct bus_operations *bus;
 };
 
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
-	cur_dev = link;
-
-	das16cs_pcmcia_config(link);
-
-	return 0;
-}
-
-static void das16cs_pcmcia_detach(struct pcmcia_device *link)
+static void das16cs_pcmcia_release(struct pcmcia_device *link)
 {
-	dev_dbg(&link->dev, "das16cs_pcmcia_detach\n");
-
-	((struct local_info_t *)link->priv)->stop = 1;
-	das16cs_pcmcia_release(link);
-	/* This points to the parent struct local_info_t struct */
-	kfree(link->priv);
+	dev_dbg(&link->dev, "das16cs_pcmcia_release\n");
+	pcmcia_disable_device(link);
 }
 
 static int das16cs_pcmcia_config_loop(struct pcmcia_device *p_dev,
@@ -704,10 +672,34 @@ failed:
 	das16cs_pcmcia_release(link);
 }
 
-static void das16cs_pcmcia_release(struct pcmcia_device *link)
+static int das16cs_pcmcia_attach(struct pcmcia_device *link)
 {
-	dev_dbg(&link->dev, "das16cs_pcmcia_release\n");
-	pcmcia_disable_device(link);
+	struct local_info_t *local;
+
+	dev_dbg(&link->dev, "das16cs_pcmcia_attach()\n");
+
+	/* Allocate space for private device-specific data */
+	local = kzalloc(sizeof(struct local_info_t), GFP_KERNEL);
+	if (!local)
+		return -ENOMEM;
+	local->link = link;
+	link->priv = local;
+
+	cur_dev = link;
+
+	das16cs_pcmcia_config(link);
+
+	return 0;
+}
+
+static void das16cs_pcmcia_detach(struct pcmcia_device *link)
+{
+	dev_dbg(&link->dev, "das16cs_pcmcia_detach\n");
+
+	((struct local_info_t *)link->priv)->stop = 1;
+	das16cs_pcmcia_release(link);
+	/* This points to the parent struct local_info_t struct */
+	kfree(link->priv);
 }
 
 static int das16cs_pcmcia_suspend(struct pcmcia_device *link)
-- 
1.7.11

