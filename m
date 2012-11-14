Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161037Ab2KNJnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:43:40 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:47133 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856Ab2KNJme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:42:34 -0500
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [RFC PATCH 08/10] s390/pci: s390 specific PCI sysfs attributes
Date: Wed, 14 Nov 2012 10:41:40 +0100
Message-Id: <78e3640d9d30e04c2dc17edc5480ee0938313ff0.1352719878.git.jang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <cover.1352719877.git.jang@linux.vnet.ibm.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com>
In-Reply-To: <cover.1352719877.git.jang@linux.vnet.ibm.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com>
x-cbid: 12111409-2966-0000-0000-000005DD565F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some s390 specific sysfs attributes to the PCI device directory.
The following attributes are introduced:
- function_id (PCI function ID)
- function_handle (PCI function handle)
- pchid (PCI channel ID)
- pfgid (PCI function group ID aka PCI root complex)

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/include/asm/pci.h |  4 +++
 arch/s390/pci/Makefile      |  2 +-
 arch/s390/pci/pci.c         |  6 ++++
 arch/s390/pci/pci_sysfs.c   | 86 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 97 insertions(+), 1 deletion(-)
 create mode 100644 arch/s390/pci/pci_sysfs.c

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 739d9f1..39057e4 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -141,6 +141,10 @@ struct zpci_dev *get_zdev(struct pci_dev *);
 struct zpci_dev *get_zdev_by_fid(u32);
 bool zpci_fid_present(u32);
 
+/* sysfs */
+int zpci_sysfs_add_device(struct device *);
+void zpci_sysfs_remove_device(struct device *);
+
 /* DMA */
 int zpci_dma_init(void);
 void zpci_dma_exit(void);
diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
index 7e36f42..ab0827b 100644
--- a/arch/s390/pci/Makefile
+++ b/arch/s390/pci/Makefile
@@ -3,4 +3,4 @@
 #
 
 obj-$(CONFIG_PCI)	+= pci.o pci_dma.o pci_clp.o pci_msi.o \
-			   pci_event.o
+			   pci_sysfs.o pci_event.o
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index c523594..0723b10 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -628,6 +628,7 @@ static void zpci_remove_device(struct pci_dev *pdev)
 	dev_info(&pdev->dev, "Removing device %u\n", zdev->domain);
 	zdev->state = ZPCI_FN_STATE_CONFIGURED;
 	zpci_dma_exit_device(zdev);
+	zpci_sysfs_remove_device(&pdev->dev);
 	zpci_unmap_resources(pdev);
 	list_del(&zdev->entry);		/* can be called from init */
 	zdev->pdev = NULL;
@@ -676,6 +677,11 @@ void pcibios_disable_device(struct pci_dev *pdev)
 	pdev->sysdata = NULL;
 }
 
+int pcibios_add_platform_entries(struct pci_dev *pdev)
+{
+	return zpci_sysfs_add_device(&pdev->dev);
+}
+
 int zpci_request_irq(unsigned int irq, irq_handler_t handler, void *data)
 {
 	int msi_nr = irq_to_msi_nr(irq);
diff --git a/arch/s390/pci/pci_sysfs.c b/arch/s390/pci/pci_sysfs.c
new file mode 100644
index 0000000..a42cce6
--- /dev/null
+++ b/arch/s390/pci/pci_sysfs.c
@@ -0,0 +1,86 @@
+/*
+ * Copyright IBM Corp. 2012
+ *
+ * Author(s):
+ *   Jan Glauber <jang@linux.vnet.ibm.com>
+ */
+
+#define COMPONENT "zPCI"
+#define pr_fmt(fmt) COMPONENT ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/stat.h>
+#include <linux/pci.h>
+
+static ssize_t show_fid(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct zpci_dev *zdev = get_zdev(container_of(dev, struct pci_dev, dev));
+
+	sprintf(buf, "0x%08x\n", zdev->fid);
+	return strlen(buf);
+}
+static DEVICE_ATTR(function_id, S_IRUGO, show_fid, NULL);
+
+static ssize_t show_fh(struct device *dev, struct device_attribute *attr,
+		       char *buf)
+{
+	struct zpci_dev *zdev = get_zdev(container_of(dev, struct pci_dev, dev));
+
+	sprintf(buf, "0x%08x\n", zdev->fh);
+	return strlen(buf);
+}
+static DEVICE_ATTR(function_handle, S_IRUGO, show_fh, NULL);
+
+static ssize_t show_pchid(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct zpci_dev *zdev = get_zdev(container_of(dev, struct pci_dev, dev));
+
+	sprintf(buf, "0x%04x\n", zdev->pchid);
+	return strlen(buf);
+}
+static DEVICE_ATTR(pchid, S_IRUGO, show_pchid, NULL);
+
+static ssize_t show_pfgid(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct zpci_dev *zdev = get_zdev(container_of(dev, struct pci_dev, dev));
+
+	sprintf(buf, "0x%02x\n", zdev->pfgid);
+	return strlen(buf);
+}
+static DEVICE_ATTR(pfgid, S_IRUGO, show_pfgid, NULL);
+
+static struct device_attribute *zpci_dev_attrs[] = {
+	&dev_attr_function_id,
+	&dev_attr_function_handle,
+	&dev_attr_pchid,
+	&dev_attr_pfgid,
+	NULL,
+};
+
+int zpci_sysfs_add_device(struct device *dev)
+{
+	int i, rc = 0;
+
+	for (i = 0; zpci_dev_attrs[i]; i++) {
+		rc = device_create_file(dev, zpci_dev_attrs[i]);
+		if (rc)
+			goto error;
+	}
+	return 0;
+
+error:
+	while (--i >= 0)
+		device_remove_file(dev, zpci_dev_attrs[i]);
+	return rc;
+}
+
+void zpci_sysfs_remove_device(struct device *dev)
+{
+	int i;
+
+	for (i = 0; zpci_dev_attrs[i]; i++)
+		device_remove_file(dev, zpci_dev_attrs[i]);
+}
-- 
1.7.12.4

