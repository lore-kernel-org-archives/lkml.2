Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202Ab2K2BLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:11:16 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40971 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030187Ab2K2BLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:11:12 -0500
From: Cong Ding <dinggnu@gmail.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Cong Ding <dinggnu@gmail.com>
Subject: [PATCH 1/1] solve memory leak for uio
Date: Thu, 29 Nov 2012 01:09:50 +0000
Message-Id: <1354151390-22108-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we have to call kobject_put() to clean up the kobject after function
kobject_init(), kobject_add(), or kobject_uevent() is called. 

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/uio/uio.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 5110f36..40566fd 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -317,16 +317,18 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		ret = kobject_add(&portio->kobj, idev->portio_dir,
 							"port%d", pi);
 		if (ret)
-			goto err_portio;
+			goto err_portio_kobj;
 		ret = kobject_uevent(&portio->kobj, KOBJ_ADD);
 		if (ret)
-			goto err_portio;
+			goto err_portio_kobj;
 	}
 
 	return 0;
 
 err_portio:
-	for (pi--; pi >= 0; pi--) {
+	pi--;
+err_portio_kobj:
+	for (; pi >= 0; pi--) {
 		port = &idev->info->port[pi];
 		portio = port->portio;
 		kobject_put(&portio->kobj);
-- 
1.7.4.5

