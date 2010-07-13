Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab0GMBab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:30:31 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37060 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab0GMBaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:30:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=DoSKAOqooPPjnTQmZSvyI91gkdFU4oiG60hyT9PSE9EsE9N0DU3J9cP6PueJ7QlvOl
         AW/eUsJhBkn3VRhySinFiLR8gvIyZpdz7BupL/+8KFaVDdHGNMHcMqv2KVe7Jias3hqf
         W1MBTBUI1NMGtO7j0l2H8XZb9Ow31Vdk4aJ+E=
Subject: [PATCH v2] edd: fix possible memory leak in edd_init() error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        David Teigland <teigland@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Jul 2010 09:30:57 +0800
Message-Id: <1278984657.28233.2.camel@mola>
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
 drivers/firmware/edd.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index 110e24e..37a56be 100644
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
 
@@ -760,21 +760,28 @@ edd_init(void)
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
+		edd_device_unregister(edd_devices[i]);
+	}
+	kset_unregister(edd_kset);
 	return rc;
 }
 
-- 
1.5.4.3



