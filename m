Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1EJSZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:25:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56575 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1EJSZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:25:13 -0400
Message-ID: <4DC982FF.6030502@kernel.org>
Date: Tue, 10 May 2011 11:25:03 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 1/2] pci, sysfs: move bus cpuaffinity to class dev_attrs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DC98307.00AD,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Requested by Greg KH

need to apply after
 [PATCH -v4 1/3] pci: add rescan to /sys/.../pci_bus/.../

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/bus.c       |    6 ------
 drivers/pci/pci-sysfs.c |   36 ++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h       |    2 --
 drivers/pci/probe.c     |   42 ------------------------------------------
 drivers/pci/remove.c    |    2 --
 5 files changed, 36 insertions(+), 52 deletions(-)

Index: linux-2.6/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6/drivers/pci/pci-sysfs.c
@@ -108,6 +108,40 @@ static ssize_t local_cpulist_show(struct
 	return len;
 }
 
+/*
+ * PCI Bus Class Devices
+ */
+static ssize_t pci_bus_show_cpuaffinity(struct device *dev,
+					int type,
+					struct device_attribute *attr,
+					char *buf)
+{
+	int ret;
+	const struct cpumask *cpumask;
+
+	cpumask = cpumask_of_pcibus(to_pci_bus(dev));
+	ret = type ?
+		cpulist_scnprintf(buf, PAGE_SIZE-2, cpumask) :
+		cpumask_scnprintf(buf, PAGE_SIZE-2, cpumask);
+	buf[ret++] = '\n';
+	buf[ret] = '\0';
+	return ret;
+}
+
+static inline ssize_t pci_bus_show_cpumaskaffinity(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return pci_bus_show_cpuaffinity(dev, 0, attr, buf);
+}
+
+static inline ssize_t pci_bus_show_cpulistaffinity(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return pci_bus_show_cpuaffinity(dev, 1, attr, buf);
+}
+
 /* show resources */
 static ssize_t
 resource_show(struct device * dev, struct device_attribute *attr, char * buf)
@@ -370,6 +404,8 @@ struct device_attribute pcibus_dev_attrs
 #ifdef CONFIG_HOTPLUG
 	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_bus_rescan_store),
 #endif
+	__ATTR(cpuaffinity, S_IRUGO, pci_bus_show_cpumaskaffinity, NULL),
+	__ATTR(cpulistaffinity, S_IRUGO, pci_bus_show_cpulistaffinity, NULL),
 	__ATTR_NULL,
 };
 
Index: linux-2.6/drivers/pci/bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/bus.c
+++ linux-2.6/drivers/pci/bus.c
@@ -163,12 +163,6 @@ int pci_bus_add_child(struct pci_bus *bu
 
 	bus->is_added = 1;
 
-	retval = device_create_file(&bus->dev, &dev_attr_cpuaffinity);
-	if (retval)
-		return retval;
-
-	retval = device_create_file(&bus->dev, &dev_attr_cpulistaffinity);
-
 	/* Create legacy_io and legacy_mem files for this bus */
 	pci_create_legacy_files(bus);
 
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -157,8 +157,6 @@ static inline int pci_no_d1d2(struct pci
 }
 extern struct device_attribute pci_dev_attrs[];
 extern struct device_attribute pcibus_dev_attrs[];
-extern struct device_attribute dev_attr_cpuaffinity;
-extern struct device_attribute dev_attr_cpulistaffinity;
 #ifdef CONFIG_HOTPLUG
 extern struct bus_attribute pci_bus_attrs[];
 #else
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -43,43 +43,6 @@ int no_pci_devices(void)
 EXPORT_SYMBOL(no_pci_devices);
 
 /*
- * PCI Bus Class Devices
- */
-static ssize_t pci_bus_show_cpuaffinity(struct device *dev,
-					int type,
-					struct device_attribute *attr,
-					char *buf)
-{
-	int ret;
-	const struct cpumask *cpumask;
-
-	cpumask = cpumask_of_pcibus(to_pci_bus(dev));
-	ret = type?
-		cpulist_scnprintf(buf, PAGE_SIZE-2, cpumask) :
-		cpumask_scnprintf(buf, PAGE_SIZE-2, cpumask);
-	buf[ret++] = '\n';
-	buf[ret] = '\0';
-	return ret;
-}
-
-static ssize_t inline pci_bus_show_cpumaskaffinity(struct device *dev,
-					struct device_attribute *attr,
-					char *buf)
-{
-	return pci_bus_show_cpuaffinity(dev, 0, attr, buf);
-}
-
-static ssize_t inline pci_bus_show_cpulistaffinity(struct device *dev,
-					struct device_attribute *attr,
-					char *buf)
-{
-	return pci_bus_show_cpuaffinity(dev, 1, attr, buf);
-}
-
-DEVICE_ATTR(cpuaffinity,     S_IRUGO, pci_bus_show_cpumaskaffinity, NULL);
-DEVICE_ATTR(cpulistaffinity, S_IRUGO, pci_bus_show_cpulistaffinity, NULL);
-
-/*
  * PCI Bus Class
  */
 static void release_pcibus_dev(struct device *dev)
@@ -1469,9 +1432,6 @@ struct pci_bus * pci_create_bus(struct d
 	error = device_register(&b->dev);
 	if (error)
 		goto class_dev_reg_err;
-	error = device_create_file(&b->dev, &dev_attr_cpuaffinity);
-	if (error)
-		goto dev_create_file_err;
 
 	/* Create legacy_io and legacy_mem files for this bus */
 	pci_create_legacy_files(b);
@@ -1482,8 +1442,6 @@ struct pci_bus * pci_create_bus(struct d
 
 	return b;
 
-dev_create_file_err:
-	device_unregister(&b->dev);
 class_dev_reg_err:
 	device_unregister(dev);
 dev_reg_err:
Index: linux-2.6/drivers/pci/remove.c
===================================================================
--- linux-2.6.orig/drivers/pci/remove.c
+++ linux-2.6/drivers/pci/remove.c
@@ -73,8 +73,6 @@ void pci_remove_bus(struct pci_bus *pci_
 		return;
 
 	pci_remove_legacy_files(pci_bus);
-	device_remove_file(&pci_bus->dev, &dev_attr_cpuaffinity);
-	device_remove_file(&pci_bus->dev, &dev_attr_cpulistaffinity);
 	device_unregister(&pci_bus->dev);
 }
 EXPORT_SYMBOL(pci_remove_bus);
