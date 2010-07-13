Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab0GMFCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 01:02:15 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43713 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0GMFCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 01:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=GcRxP1ntu9CVna6wlutOIAWiuzxVZrIgDVnuYWc+bWypGIglXcd4KNaKj4xKXh2chc
         xCemC0wALOu7dIsqbtDUMb1PMatAou69p83RW68cLwqe565HAC6ibIXYwh0RlEBvHTnp
         R0SVoQ296qzbJXVHt5nF/TO1D1utzVIyPhT3Y=
Subject: [PATCH v3] edd: fix possible memory leak in edd_init() error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        David Teigland <teigland@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Jul 2010 13:02:38 +0800
Message-Id: <1278997358.4112.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version simply fix the coding style in v2. ( warnning by checkpatch.pl )

>From 7400dff50f7a6036839009d6990fd5c11f0654db Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 13 Jul 2010 12:56:19 +0800
Subject: [PATCH v3] edd: fix possible memory leak in edd_init() error path

The error may happen at any iteration of the for loop,
this patch properly unregisters already registed edd_devices in error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/firmware/edd.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index 110e24e..f287fe7 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -744,7 +744,7 @@ static inline int edd_num_devices(void)
 static int __init
 edd_init(void)
 {
-	unsigned int i;
+	int i;
 	int rc=0;
 	struct edd_device *edev;
 
@@ -760,21 +760,27 @@ edd_init(void)
 	if (!edd_kset)
 		return -ENOMEM;
 
-	for (i = 0; i < edd_num_devices() && !rc; i++) {
+	for (i = 0; i < edd_num_devices(); i++) {
 		edev = kzalloc(sizeof (*edev), GFP_KERNEL);
-		if (!edev)
-			return -ENOMEM;
+		if (!edev) {
+			rc = -ENOMEM;
+			goto out;
+		}
 
 		rc = edd_device_register(edev, i);
 		if (rc) {
 			kfree(edev);
-			break;
+			goto out;
 		}
 		edd_devices[i] = edev;
 	}
 
-	if (rc)
-		kset_unregister(edd_kset);
+	return 0;
+
+out:
+	while (--i >= 0)
+		edd_device_unregister(edd_devices[i]);
+	kset_unregister(edd_kset);
 	return rc;
 }
 
-- 
1.5.4.3



