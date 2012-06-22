Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810Ab2FVXXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:23:16 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:13823 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab2FVXXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:23:15 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-127.messagelabs.com!1340407394!6581103!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/31] staging: comedi: ni_daq_700: Remove bustype variable from the boardinfo
Date: Fri, 22 Jun 2012 16:23:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221623.04580.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is only used for pcmcia type devices. There is no need for
the 'bustype' check. Remove the variable from the boardinfo and refactor
the code based on it's removal.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 47e8cf4..106da08 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -55,21 +55,16 @@ static struct pcmcia_device *pcmcia_cur_dev;
 
 #define DIO700_SIZE 8		/*  size of io region used by board */
 
-enum dio700_bustype { pcmcia_bustype };
-
 struct dio700_board {
 	const char *name;
-	enum dio700_bustype bustype;	/*  PCMCIA */
 };
 
 static const struct dio700_board dio700_boards[] = {
 	{
 	 .name = "daqcard-700",
-	 .bustype = pcmcia_bustype,
 	 },
 	{
 	 .name = "ni_daq_700",
-	 .bustype = pcmcia_bustype,
 	 },
 };
 
@@ -200,22 +195,14 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct pcmcia_device *link;
 	int ret;
 
-	/*  get base address, irq etc. based on bustype */
-	switch (thisboard->bustype) {
-	case pcmcia_bustype:
-		link = pcmcia_cur_dev;	/* XXX hack */
-		if (!link)
-			return -EIO;
-		iobase = link->resource[0]->start;
+	link = pcmcia_cur_dev;	/* XXX hack */
+	if (!link)
+		return -EIO;
+	iobase = link->resource[0]->start;
 #ifdef incomplete
-		irq = link->irq;
+	irq = link->irq;
 #endif
-		break;
-	default:
-		printk(KERN_ERR "bug! couldn't determine board type\n");
-		return -EINVAL;
-		break;
-	}
+
 	printk(KERN_ERR "comedi%d: ni_daq_700: %s, io 0x%lx", dev->minor,
 	       thisboard->name, iobase);
 #ifdef incomplete
@@ -255,8 +242,6 @@ static void dio700_detach(struct comedi_device *dev)
 {
 	if (dev->subdevices)
 		subdev_700_cleanup(dev, dev->subdevices + 0);
-	if (thisboard->bustype != pcmcia_bustype && dev->iobase)
-		release_region(dev->iobase, DIO700_SIZE);
 	if (dev->irq)
 		free_irq(dev->irq, dev);
 };
-- 
1.7.11

