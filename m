Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0IBBtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 21:49:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:4853 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab0IBBtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 21:49:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,307,1280732400"; 
   d="scan'208";a="550906722"
Subject: [BUGFIX for 2.6.36] ACPI, APEI, Fix error path for memory
 allocation
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 09:49:01 +0800
Message-ID: <1283392141.13175.45.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ERST debug/test support patch, a dynamic allocated buffer is
used. The may-failed memory allocation should be tried firstly before
free the previous buffer.

APEI resource management memory allocation related error path is fixed
too.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/apei-base.c |   25 ++++++++++++++++++++-----
 drivers/acpi/apei/erst-dbg.c  |   16 ++++++++++------
 2 files changed, 30 insertions(+), 11 deletions(-)

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
@@ -475,7 +479,13 @@ int apei_resources_request(struct apei_r
 		}
 	}
 
-	apei_resources_merge(&apei_resources_all, resources);
+	rc = apei_resources_merge(&apei_resources_all, resources);
+	if (rc) {
+		pr_err(APEI_PFX
+"Error in APEI internal resource management, there may be inconsistent "
+"between APEI internal and system resource management.");
+		goto err_unmap_ioport;
+	}
 
 	return 0;
 err_unmap_ioport:
@@ -491,12 +501,13 @@ err_unmap_iomem:
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
@@ -504,7 +515,11 @@ void apei_resources_release(struct apei_
 	list_for_each_entry(res, &resources->ioport, list)
 		release_region(res->start, res->end - res->start);
 
-	apei_resources_sub(&apei_resources_all, resources);
+	rc = apei_resources_sub(&apei_resources_all, resources);
+	if (rc)
+		pr_err(APEI_PFX
+"Error in APEI internal resource management, there may be inconsistent "
+"between APEI internal and system resource management.");
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


