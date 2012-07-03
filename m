Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab2GCPt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:49:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39310 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792Ab2GCPst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:48:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/4] xen/acpi: Fix potential memory leak.
Date: Tue,  3 Jul 2012 11:40:37 -0400
Message-Id: <1341330038-21686-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
References: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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

