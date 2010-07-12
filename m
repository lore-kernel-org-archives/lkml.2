Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0GLOsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 10:48:25 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51172 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab0GLOsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 10:48:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Vdb1Dqjdv3S4r1psvXetqUu6TVVK3ZUAxAP55qRcFuREfEBWFTtaTj7bP45bp9lyMO
         wFnL2+Sak0AFBeXVSV2iSkY+6wNH7l7NbgpRbbjoA3IFm9qe9zt70MJ4eu3BRABYH/uO
         GYI5Gqc+GP4nkbJH8cMbjTskSaRJ2mqdcws5k=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Dan Carpenter <error27@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: mrst-touchscreen: fix leaks
Date: Mon, 12 Jul 2010 18:48:04 +0400
Message-Id: <1278946084-30228-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mrstouch_probe() must unregister input device, free requested IRQ and
input device in error path.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/mrst-touchscreen/intel-mid-touch.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/mrst-touchscreen/intel-mid-touch.c b/drivers/staging/mrst-touchscreen/intel-mid-touch.c
index abba22f..8a72bbf 100644
--- a/drivers/staging/mrst-touchscreen/intel-mid-touch.c
+++ b/drivers/staging/mrst-touchscreen/intel-mid-touch.c
@@ -779,7 +779,7 @@ static int __devinit mrstouch_probe(struct spi_device *mrstouch_spi)
 				0, "mrstouch", tsdev);
 	if (err) {
 		dev_err(&tsdev->spi->dev, "unable to allocate irq\n");
-		goto mrstouch_err_free_mem;
+		goto mrstouch_err_unreg_input;
 	}
 
 	tsdev->pendet_thrd = kthread_run(mrstouch_pendet,
@@ -787,11 +787,16 @@ static int __devinit mrstouch_probe(struct spi_device *mrstouch_spi)
 	if (IS_ERR(tsdev->pendet_thrd)) {
 		dev_err(&tsdev->spi->dev, "kthread_run failed\n");
 		err = PTR_ERR(tsdev->pendet_thrd);
-		goto mrstouch_err_free_mem;
+		goto mrstouch_err_free_irq;
 	}
 	mrstouch_debug("%s", "Driver initialized");
 	return 0;
 
+mrstouch_err_free_irq:
+	free_irq(myirq, tsdev);
+mrstouch_err_unreg_input:
+	input_unregister_device(mrstouchdevp->input);
+	input_free_device(mrstouchdevp->input);
 mrstouch_err_free_mem:
 	kfree(tsdev);
 	return err;
-- 
1.7.0.4

