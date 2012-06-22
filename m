Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762433Ab2FVXP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:15:28 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:33390 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2FVXP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:15:27 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-127.messagelabs.com!1340406926!6562773!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/31] staging: comedi: ni_daq_700: change driver registration order
Date: Fri, 22 Jun 2012 16:15:16 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221615.16738.hartleys@visionengravers.com>
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
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index b06792b..af4f10f 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -443,11 +443,17 @@ static int __init dio700_cs_init(void)
 {
 	int ret;
 
-	ret = pcmcia_register_driver(&dio700_cs_driver);
+	ret = comedi_driver_register(&driver_dio700);
 	if (ret < 0)
 		return ret;
 
-	return comedi_driver_register(&driver_dio700);
+	ret = pcmcia_register_driver(&dio700_cs_driver);
+	if (ret < 0) {
+		comedi_driver_unregister(&driver_dio700);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(dio700_cs_init);
 
-- 
1.7.11

