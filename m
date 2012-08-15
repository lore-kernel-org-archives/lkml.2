Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2HOUma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:42:30 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:54952 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152Ab2HOUm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:42:29 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] [media] ddbridge: fix error handling in module_init_ddbridge()
Date: Thu, 16 Aug 2012 00:42:25 +0400
Message-Id: <1345063345-31131-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pci_register_driver() failed, resources allocated in
ddb_class_create() are leaked. The patch fixes it.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/dvb/ddbridge/ddbridge-core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index ebf3f05..36aa4e4 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -1705,7 +1705,11 @@ static __init int module_init_ddbridge(void)
 	       "Copyright (C) 2010-11 Digital Devices GmbH\n");
 	if (ddb_class_create())
 		return -1;
-	return pci_register_driver(&ddb_pci_driver);
+	if (pci_register_driver(&ddb_pci_driver) < 0) {
+		ddb_class_destroy();
+		return -1;
+	}
+	return 0;
 }
 
 static __exit void module_exit_ddbridge(void)
-- 
1.7.9.5

