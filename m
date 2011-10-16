Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1JPBcq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 21:32:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47580 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab1JPBcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 21:32:42 -0400
Message-ID: <4E9A3430.2070104@oracle.com>
Date: Sat, 15 Oct 2011 18:32:32 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/8] PCI, sysfs: merge dev and bus cpuaffinity show handling
References: <4E9A3092.4080309@oracle.com>
In-Reply-To: <4E9A3092.4080309@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4E9A343A.0099,ss=1,re=0.000,fgs=0
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
