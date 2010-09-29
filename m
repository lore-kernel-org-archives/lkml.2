Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0I2LyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 07:54:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:51878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab0I2LyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:54:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,252,1283756400"; 
   d="scan'208";a="559002015"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Subject: [PATCH -v2 4/5] ACPI, APEI, Fix error path for memory allocation
Date: Wed, 29 Sep 2010 19:53:54 +0800
Message-Id: <1285761235-4751-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
References: <1285761235-4751-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ERST debug/test support patch, a dynamic allocated buffer is
used. The may-failed memory allocation should be tried firstly before
free the previous buffer.

APEI resource management memory allocation related error path is fixed
too.

v2:

- Fix error messages for APEI resources management

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/apei-base.c |   21 ++++++++++++++++-----
 drivers/acpi/apei/erst-dbg.c  |   16 ++++++++++------
 2 files changed, 26 insertions(+), 11 deletions(-)

--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -445,11 +445,15 @@ EXPORT_SYMBOL_GPL(apei_resources_sub);
 int apei_resources_request(struct apei_resources *resources,
 			   const char *desc)
 {
-	struct apei_res *res, *res_bak;
+	struct apei_res *res, *res_bak = NULL;
 	struct resource *r;
+	int rc;
 
-	apei_resources_sub(resources, &apei_resources_all);
+	rc = apei_resources_sub(resources, &apei_resources_all);
+	if (rc)
+		return rc;
 
+	rc = -EINVAL;
 	list_for_each_entry(res, &resources->iomem, list) {
 		r = request_mem_region(res->start, res->end - res->start,
 				       desc);
@@ -475,7 +479,11 @@ int apei_resources_request(struct apei_r
 		}
 	}
 
-	apei_resources_merge(&apei_resources_all, resources);
+	rc = apei_resources_merge(&apei_resources_all, resources);
+	if (rc) {
+		pr_err(APEI_PFX "Fail to merge resources!\n");
+		goto err_unmap_ioport;
+	}
 
 	return 0;
 err_unmap_ioport:
@@ -491,12 +499,13 @@ err_unmap_iomem:
 			break;
 		release_mem_region(res->start, res->end - res->start);
 	}
-	return -EINVAL;
+	return rc;
 }
 EXPORT_SYMBOL_GPL(apei_resources_request);
 
 void apei_resources_release(struct apei_resources *resources)
 {
+	int rc;
 	struct apei_res *res;
 
 	list_for_each_entry(res, &resources->iomem, list)
@@ -504,7 +513,9 @@ void apei_resources_release(struct apei_
 	list_for_each_entry(res, &resources->ioport, list)
 		release_region(res->start, res->end - res->start);
 
-	apei_resources_sub(&apei_resources_all, resources);
+	rc = apei_resources_sub(&apei_resources_all, resources);
+	if (rc)
+		pr_err(APEI_PFX "Fail to sub resources!\n");
 }
 EXPORT_SYMBOL_GPL(apei_resources_release);
 
--- a/drivers/acpi/apei/erst-dbg.c
+++ b/drivers/acpi/apei/erst-dbg.c
@@ -111,11 +111,13 @@ retry:
 		goto out;
 	}
 	if (len > erst_dbg_buf_len) {
-		kfree(erst_dbg_buf);
+		void *p;
 		rc = -ENOMEM;
-		erst_dbg_buf = kmalloc(len, GFP_KERNEL);
-		if (!erst_dbg_buf)
+		p = kmalloc(len, GFP_KERNEL);
+		if (!p)
 			goto out;
+		kfree(erst_dbg_buf);
+		erst_dbg_buf = p;
 		erst_dbg_buf_len = len;
 		goto retry;
 	}
@@ -150,11 +152,13 @@ static ssize_t erst_dbg_write(struct fil
 	if (mutex_lock_interruptible(&erst_dbg_mutex))
 		return -EINTR;
 	if (usize > erst_dbg_buf_len) {
-		kfree(erst_dbg_buf);
+		void *p;
 		rc = -ENOMEM;
-		erst_dbg_buf = kmalloc(usize, GFP_KERNEL);
-		if (!erst_dbg_buf)
+		p = kmalloc(usize, GFP_KERNEL);
+		if (!p)
 			goto out;
+		kfree(erst_dbg_buf);
+		erst_dbg_buf = p;
 		erst_dbg_buf_len = usize;
 	}
 	rc = copy_from_user(erst_dbg_buf, ubuf, usize);
