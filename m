Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab2HPVFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:05:53 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:55510 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757287Ab2HPVFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:05:52 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] [media] ddbridge: fix error handling in module_init_ddbridge()
Date: Fri, 17 Aug 2012 01:05:38 +0400
Message-Id: <1345151138-12855-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pci_register_driver() failed, resources allocated in
ddb_class_create() are leaked. The patch fixes it
as well as it replaces -1 with correct error code
in ddb_class_create().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/dvb/ddbridge/ddbridge-core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index ebf3f05..feff57e 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -1497,7 +1497,7 @@ static int ddb_class_create(void)
 	ddb_class = class_create(THIS_MODULE, DDB_NAME);
 	if (IS_ERR(ddb_class)) {
 		unregister_chrdev(ddb_major, DDB_NAME);
-		return -1;
+		return PTR_ERR(ddb_class);
 	}
 	ddb_class->devnode = ddb_devnode;
 	return 0;
@@ -1701,11 +1701,18 @@ static struct pci_driver ddb_pci_driver = {
 
 static __init int module_init_ddbridge(void)
 {
+	int ret;
+
 	printk(KERN_INFO "Digital Devices PCIE bridge driver, "
 	       "Copyright (C) 2010-11 Digital Devices GmbH\n");
-	if (ddb_class_create())
-		return -1;
-	return pci_register_driver(&ddb_pci_driver);
+
+	ret = ddb_class_create();
+	if (ret < 0)
+		return ret;
+	ret = pci_register_driver(&ddb_pci_driver);
+	if (ret < 0)
+		ddb_class_destroy();
+	return ret;
 }
 
 static __exit void module_exit_ddbridge(void)
-- 
1.7.9.5

