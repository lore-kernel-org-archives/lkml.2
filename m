Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab2FLTAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:00:12 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:30836 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab2FLTAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:00:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-127.messagelabs.com!1339527603!8255940!12
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] staging: comedi: cleanup comedi_alloc_subdevices
Date: Tue, 12 Jun 2012 11:59:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201206121159.55522.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 65db79e570481b04bfc13663fd40de18560f0aa4 Mon Sep 17 00:00:00 2001
From: H Hartley Sweeten <hsweeten@visionengravers.com>
Date: Tue, 12 Jun 2012 11:37:09 -0700
Subject: [PATCH 8/8] staging: comedi: cleanup comedi_alloc_subdevices

Access the individual comedi_subdevices using a pointer instead
of directly accessing as an array. This is how the rest of the
comedi core accesses them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbott@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 238c29d..c41ddb3 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -58,21 +58,24 @@ struct comedi_driver *comedi_drivers;
 
 int comedi_alloc_subdevices(struct comedi_device *dev, int num_subdevices)
 {
+	struct comedi_subdevice *s;
 	int i;
 
 	if (num_subdevices < 1)
 		return -EINVAL;
-	dev->subdevices =
-	    kcalloc(num_subdevices, sizeof(struct comedi_subdevice),
-		    GFP_KERNEL);
-	if (!dev->subdevices)
+
+	s = kcalloc(num_subdevices, sizeof(*s), GFP_KERNEL);
+	if (!s)
 		return -ENOMEM;
+	dev->subdevices = s;
 	dev->n_subdevices = num_subdevices;
+
 	for (i = 0; i < num_subdevices; ++i) {
-		dev->subdevices[i].device = dev;
-		dev->subdevices[i].async_dma_dir = DMA_NONE;
-		spin_lock_init(&dev->subdevices[i].spin_lock);
-		dev->subdevices[i].minor = -1;
+		s = dev->subdevices + i;
+		s->device = dev;
+		s->async_dma_dir = DMA_NONE;
+		spin_lock_init(&s->spin_lock);
+		s->minor = -1;
 	}
 	return 0;
 }
-- 
1.7.7

