Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab2GKTLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:11:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21471 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab2GKTLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:11:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/3] xen/acpi: Fix potential memory leak.
Date: Wed, 11 Jul 2012 15:03:19 -0400
Message-Id: <1342033400-22505-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342033400-22505-1-git-send-email-konrad.wilk@oracle.com>
References: <1342033400-22505-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity points out that we do not free in one case the
pr_backup - and sure enough we forgot.

Found by Coverity (CID 401970)

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-acpi-processor.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 7ff2569e..b590ee0 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -520,15 +520,18 @@ static int __init xen_acpi_processor_init(void)
 
 		if (!pr_backup) {
 			pr_backup = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
-			memcpy(pr_backup, _pr, sizeof(struct acpi_processor));
+			if (pr_backup)
+				memcpy(pr_backup, _pr, sizeof(struct acpi_processor));
 		}
 		(void)upload_pm_data(_pr);
 	}
 	rc = check_acpi_ids(pr_backup);
-	if (rc)
-		goto err_unregister;
 
 	kfree(pr_backup);
+	pr_backup = NULL;
+
+	if (rc)
+		goto err_unregister;
 
 	return 0;
 err_unregister:
-- 
1.7.7.6

