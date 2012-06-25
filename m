Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab2FYWVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:21:07 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:26869 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393Ab2FYWVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:21:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-209.messagelabs.com!1340662830!6919855!41
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/33] staging: comedi: cb_das13_cs: change driver registration order
Date: Mon, 25 Jun 2012 15:20:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251520.54274.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As done with the other comedi driver types, register the
comedi_driver first then the pcmcia_driver. Also, make
sure the pcmcia_driver registration succeeds and unregister
the comedi_driver it it fails.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 624e005..625134f 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -784,11 +784,17 @@ static int __init das16cs_init(void)
 {
 	int ret;
 
-	ret = pcmcia_register_driver(&das16cs_driver);
+	ret = comedi_driver_register(&driver_das16cs);
 	if (ret < 0)
 		return ret;
 
-	return comedi_driver_register(&driver_das16cs);
+	ret = pcmcia_register_driver(&das16cs_driver);
+	if (ret < 0) {
+		comedi_driver_unregister(&driver_das16cs);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(das16cs_init);
 
-- 
1.7.11

