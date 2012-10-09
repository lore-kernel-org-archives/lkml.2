Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2JIJgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:36:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:50813 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2JIJgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:36:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,560,1344236400"; 
   d="scan'208";a="202255269"
From: gang.wei@intel.com
To: key@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
        ebiederm@xmission.com, ben@guthro.net, Gang Wei <gang.wei@intel.com>
Subject: [PATCH] driver/char/tpm: fix regression causesd by ppi
Date: Tue,  9 Oct 2012 17:35:22 +0800
Message-Id: <1349775322-7896-1-git-send-email-gang.wei@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gang Wei <gang.wei@intel.com>

This patch try to fix the S3 regression https://lkml.org/lkml/2012/10/5/433,
which includes below line:
[ 1554.684638] sysfs: cannot create duplicate filename '/devices/pnp0/00:0c/ppi'

The root cause is that ppi sysfs teardown code is MIA, so while S3 resume,
the ppi kobject will be created again upon existing one.

To make the tear down code simple, change the ppi subfolder creation from
using kobject_create_and_add to just using a named ppi attribute_group. Then
ppi sysfs teardown could be done with a simple sysfs_remove_group call.

Adjusted the name & return type for ppi sysfs init function.

Reported-by: Ben Guthro <ben@guthro.net>
Signed-off-by: Gang Wei <gang.wei@intel.com>
---
 drivers/char/tpm/tpm.c     |    3 ++-
 drivers/char/tpm/tpm.h     |    9 +++++++--
 drivers/char/tpm/tpm_ppi.c |   18 ++++++++++--------
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index f26afdb..b429f1e 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1259,6 +1259,7 @@ void tpm_remove_hardware(struct device *dev)
 
 	misc_deregister(&chip->vendor.miscdev);
 	sysfs_remove_group(&dev->kobj, chip->vendor.attr_group);
+	tpm_remove_ppi(&dev->kobj);
 	tpm_bios_log_teardown(chip->bios_dir);
 
 	/* write it this way to be explicit (chip->dev == dev) */
@@ -1476,7 +1477,7 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 		goto put_device;
 	}
 
-	if (sys_add_ppi(&dev->kobj)) {
+	if (tpm_add_ppi(&dev->kobj)) {
 		misc_deregister(&chip->vendor.miscdev);
 		goto put_device;
 	}
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 02c266a..8ef7649 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -329,10 +329,15 @@ extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 			     wait_queue_head_t *);
 
 #ifdef CONFIG_ACPI
-extern ssize_t sys_add_ppi(struct kobject *parent);
+extern int tpm_add_ppi(struct kobject *);
+extern void tpm_remove_ppi(struct kobject *);
 #else
-static inline ssize_t sys_add_ppi(struct kobject *parent)
+static inline int tpm_add_ppi(struct kobject *parent)
 {
 	return 0;
 }
+
+static inline void tpm_remove_ppi(struct kobject *parent)
+{
+}
 #endif
diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index f27b58c..720ebcf 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -444,18 +444,20 @@ static struct attribute *ppi_attrs[] = {
 	&dev_attr_vs_operations.attr, NULL,
 };
 static struct attribute_group ppi_attr_grp = {
+	.name = "ppi",
 	.attrs = ppi_attrs
 };
 
-ssize_t sys_add_ppi(struct kobject *parent)
+int tpm_add_ppi(struct kobject *parent)
 {
-	struct kobject *ppi;
-	ppi = kobject_create_and_add("ppi", parent);
-	if (sysfs_create_group(ppi, &ppi_attr_grp))
-		return -EFAULT;
-	else
-		return 0;
+	return sysfs_create_group(parent, &ppi_attr_grp);
+}
+EXPORT_SYMBOL_GPL(tpm_add_ppi);
+
+void tpm_remove_ppi(struct kobject *parent)
+{
+	sysfs_remove_group(parent, &ppi_attr_grp);
 }
-EXPORT_SYMBOL_GPL(sys_add_ppi);
+EXPORT_SYMBOL_GPL(tpm_remove_ppi);
 
 MODULE_LICENSE("GPL");
-- 
1.7.7.6

