Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab1EJS0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:26:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57655 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1EJS0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:26:30 -0400
Message-ID: <4DC98349.1000101@kernel.org>
Date: Tue, 10 May 2011 11:26:17 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 2/2] pci, sysfs: merge dev and bus cpuaffinity
References: <4DC982FF.6030502@kernel.org>
In-Reply-To: <4DC982FF.6030502@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090205.4DC98352.00EE,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


merge them one function with two extra parameters.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/pci-sysfs.c |   69 ++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 42 deletions(-)

Index: linux-2.6/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6/drivers/pci/pci-sysfs.c
@@ -71,75 +71,60 @@ static ssize_t broken_parity_status_stor
 	return count;
 }
 
-static ssize_t local_cpus_show(struct device *dev,
-			struct device_attribute *attr, char *buf)
-{		
-	const struct cpumask *mask;
+static ssize_t pci_show_cpuaffinity(struct device *dev,
+					int type, bool is_pci_dev,
+					struct device_attribute *attr,
+					char *buf)
+{
 	int len;
+	const struct cpumask *mask;
 
+	if (is_pci_dev) {
 #ifdef CONFIG_NUMA
-	mask = (dev_to_node(dev) == -1) ? cpu_online_mask :
-					  cpumask_of_node(dev_to_node(dev));
+		int node = dev_to_node(dev);
+
+		mask = (node == -1) ? cpu_online_mask : cpumask_of_node(node);
 #else
-	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
+		mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
 #endif
-	len = cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
+	} else
+		mask = cpumask_of_pcibus(to_pci_bus(dev));
+	len = type ?
+		cpulist_scnprintf(buf, PAGE_SIZE-2, mask) :
+		cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
 }
 
+static ssize_t local_cpus_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return pci_show_cpuaffinity(dev, 0, true, attr, buf);
+}
+
 
 static ssize_t local_cpulist_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	const struct cpumask *mask;
-	int len;
-
-#ifdef CONFIG_NUMA
-	mask = (dev_to_node(dev) == -1) ? cpu_online_mask :
-					  cpumask_of_node(dev_to_node(dev));
-#else
-	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
-#endif
-	len = cpulist_scnprintf(buf, PAGE_SIZE-2, mask);
-	buf[len++] = '\n';
-	buf[len] = '\0';
-	return len;
+	return pci_show_cpuaffinity(dev, 1, true, attr, buf);
 }
 
 /*
  * PCI Bus Class Devices
  */
-static ssize_t pci_bus_show_cpuaffinity(struct device *dev,
-					int type,
-					struct device_attribute *attr,
-					char *buf)
-{
-	int ret;
-	const struct cpumask *cpumask;
-
-	cpumask = cpumask_of_pcibus(to_pci_bus(dev));
-	ret = type ?
-		cpulist_scnprintf(buf, PAGE_SIZE-2, cpumask) :
-		cpumask_scnprintf(buf, PAGE_SIZE-2, cpumask);
-	buf[ret++] = '\n';
-	buf[ret] = '\0';
-	return ret;
-}
-
-static inline ssize_t pci_bus_show_cpumaskaffinity(struct device *dev,
+static ssize_t pci_bus_show_cpumaskaffinity(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	return pci_bus_show_cpuaffinity(dev, 0, attr, buf);
+	return pci_show_cpuaffinity(dev, 0, false, attr, buf);
 }
 
-static inline ssize_t pci_bus_show_cpulistaffinity(struct device *dev,
+static ssize_t pci_bus_show_cpulistaffinity(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	return pci_bus_show_cpuaffinity(dev, 1, attr, buf);
+	return pci_show_cpuaffinity(dev, 1, false, attr, buf);
 }
 
 /* show resources */
