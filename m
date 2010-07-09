Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab0GIKtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:49:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43105 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab0GIKtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 06:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wnckLg74E+t8Ju0NYIPkH6UNwoF3UjRUX8q1N2QditBlzlxorejUUTbleofxWfJw1g
         78xGI+u48BR6o5M2QE1U3V1rpQMK5oyhuvdQ+f7O3cWa5xf2EIFs0yvAyn5GkchCcyzN
         2mef3dhMDZjomeInKKSuw+Pxxmxdui7d0duEw=
Subject: [PATCH] edd: fix possible memory leak in edd_init() error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       David Teigland <teigland@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Hans J. Koch" <hjk@linutronix.de>
Content-Type: text/plain
Date: Fri, 09 Jul 2010 18:50:07 +0800
Message-Id: <1278672607.1335.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error may happen at any iteration of the for loop,
this patch properly unregisters already registed edd_devices in error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/firmware/edd.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index 110e24e..b75082c 100644
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
 
@@ -760,21 +760,30 @@ edd_init(void)
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
+	while (--i >= 0) {
+		edev = edd_devices[i];
+		if (edev)
+			edd_device_unregister(edev);
+	}
+	kset_unregister(edd_kset);
 	return rc;
 }
 
-- 
1.5.4.3



