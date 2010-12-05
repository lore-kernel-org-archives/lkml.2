Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab0LERvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:51:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab0LERvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vlFqtQ6l2bp1fPR4wgPBblED9ET8+cPeAW76xaExQJzpZJWYY4O2ToKYeYQ4TpS/i/
         t+27uXSVDMU8m8hq0Nkmm5ihpUzur3iGUih/xGPitRv3Xu3JKllKM983jWlmtoBL83v3
         irObjNDOdOy0e1wk+Mwrsy+vfoXOG+mXfZWXw=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 34/45] kstrtox: convert drivers/pci/
Date: Sun,  5 Dec 2010 19:49:31 +0200
Message-Id: <1291571382-2719-34-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/pci/hotplug/fakephp.c |    2 +-
 drivers/pci/pci-sysfs.c       |   45 ++++++++++++++++++++++------------------
 2 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index 17d10e2..aaf2529 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -49,7 +49,7 @@ static ssize_t legacy_store(struct kobject *kobj, struct attribute *attr,
 	struct legacy_slot *slot = container_of(kobj, typeof(*slot), kobj);
 	unsigned long val;
 
-	if (strict_strtoul(buf, 0, &val) < 0)
+	if (kstrtoul(buf, 0, &val) < 0)
 		return -EINVAL;
 
 	if (val)
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 63d5042..1105790 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -61,9 +61,11 @@ static ssize_t broken_parity_status_store(struct device *dev,
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	unsigned long val;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &val) < 0)
-		return -EINVAL;
+	rv = kstrtoul(buf, 0, &val);
+	if (rv < 0)
+		return rv;
 
 	pdev->broken_parity_status = !!val;
 
@@ -150,15 +152,16 @@ static ssize_t is_enabled_store(struct device *dev,
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	unsigned long val;
-	ssize_t result = strict_strtoul(buf, 0, &val);
-
-	if (result < 0)
-		return result;
+	int result;
 
 	/* this can crash the machine when done on the "wrong" device */
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	result = kstrtoul(buf, 0, &val);
+	if (result < 0)
+		return result;
+
 	if (!val) {
 		if (pci_is_enabled(pdev))
 			pci_disable_device(pdev);
@@ -221,14 +224,14 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
 	struct pci_dev *pdev = to_pci_dev(dev);
 	unsigned long val;
 
-	if (strict_strtoul(buf, 0, &val) < 0)
-		return -EINVAL;
-
 	/* bad things may happen if the no_msi flag is changed
 	 * while some drivers are loaded */
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (kstrtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
 	/* Maybe pci devices without subordinate busses shouldn't even have this
 	 * attribute in the first place?  */
 	if (!pdev->subordinate)
@@ -254,7 +257,7 @@ static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 	unsigned long val;
 	struct pci_bus *b = NULL;
 
-	if (strict_strtoul(buf, 0, &val) < 0)
+	if (kstrtoul(buf, 0, &val) < 0)
 		return -EINVAL;
 
 	if (val) {
@@ -278,7 +281,7 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
 	unsigned long val;
 	struct pci_dev *pdev = to_pci_dev(dev);
 
-	if (strict_strtoul(buf, 0, &val) < 0)
+	if (kstrtoul(buf, 0, &val) < 0)
 		return -EINVAL;
 
 	if (val) {
@@ -302,19 +305,21 @@ static ssize_t
 remove_store(struct device *dev, struct device_attribute *dummy,
 	     const char *buf, size_t count)
 {
-	int ret = 0;
 	unsigned long val;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &val) < 0)
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &val);
+	if (ret < 0)
+		return ret;
 
 	/* An attribute cannot be unregistered by one of its own methods,
 	 * so we have to use this roundabout approach.
 	 */
-	if (val)
+	if (val) {
 		ret = device_schedule_callback(dev, remove_callback);
-	if (ret)
-		count = ret;
+		if (ret < 0)
+			return ret;
+	}
 	return count;
 }
 #endif
@@ -1050,12 +1055,12 @@ static ssize_t reset_store(struct device *dev,
 			   size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	unsigned long val;
-	ssize_t result = strict_strtoul(buf, 0, &val);
+	int val;
+	int result;
 
+	result = kstrtoint(buf, 0, &val);
 	if (result < 0)
 		return result;
-
 	if (val != 1)
 		return -EINVAL;
 
-- 
1.7.2.2

