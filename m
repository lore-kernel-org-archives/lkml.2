Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab2ISTCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:02:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47974 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab2ISSzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:25 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 18/40] PCI: Rescan bus using callback method too
Date: Wed, 19 Sep 2012 11:54:32 -0700
Message-Id: <1348080894-23412-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like removal.

Because We could add new bus under the bridges...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-sysfs.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 02d107b..60e04b2 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -356,24 +356,34 @@ remove_store(struct device *dev, struct device_attribute *dummy,
 	return count;
 }
 
+static void bus_rescan_callback(struct device *dev)
+{
+	struct pci_bus *bus = to_pci_bus(dev);
+
+	mutex_lock(&pci_remove_rescan_mutex);
+	if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
+		pci_rescan_bus_bridge_resize(bus->self);
+	else
+		pci_rescan_bus(bus);
+	mutex_unlock(&pci_remove_rescan_mutex);
+}
+
 static ssize_t
 dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
 		 const char *buf, size_t count)
 {
+	int ret = 0;
 	unsigned long val;
-	struct pci_bus *bus = to_pci_bus(dev);
 
 	if (strict_strtoul(buf, 0, &val) < 0)
 		return -EINVAL;
 
-	if (val) {
-		mutex_lock(&pci_remove_rescan_mutex);
-		if (!pci_is_root_bus(bus) && list_empty(&bus->devices))
-			pci_rescan_bus_bridge_resize(bus->self);
-		else
-			pci_rescan_bus(bus);
-		mutex_unlock(&pci_remove_rescan_mutex);
-	}
+	if (val)
+		ret = device_schedule_callback(dev, bus_rescan_callback);
+
+	if (ret)
+		count = ret;
+
 	return count;
 }
 
-- 
1.7.7

