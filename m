Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab2CFHRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:17:04 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:17461 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758322Ab2CFHRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:17:00 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH 19/23] PCI: add /sys/bus/pci/rescan_root
Date: Mon,  5 Mar 2012 23:13:56 -0800
Message-Id: <1331018040-30725-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F55B9E8.006E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be used to rediscover removed pci root buses.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
---
 Documentation/ABI/testing/sysfs-bus-pci |    9 +++++++++
 drivers/pci/pci-sysfs.c                 |   21 +++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 22392de..eb826bd 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -66,6 +66,15 @@ Description:
 		re-discover previously removed devices.
 		Depends on CONFIG_HOTPLUG.
 
+What:		/sys/bus/pci/rescan_root
+Date:		March 2012
+Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
+Description:
+		Writing a non-zero value to this attribute will
+		cause a rescan of all PCI root buses in the system, and
+		re-discover previously removed PCI root buses.
+		Depends on CONFIG_HOTPLUG.
+
 What:		/sys/bus/pci/devices/.../msi_irqs/
 Date:		September, 2011
 Contact:	Neil Horman <nhorman@tuxdriver.com>
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index f855b4b..d6221e5 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -302,8 +302,29 @@ static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 	return count;
 }
 
+void __weak acpi_pci_root_rescan(void) { }
+void __weak pcibios_root_rescan(void) { }
+
+static ssize_t bus_rescan_root_store(struct bus_type *bus, const char *buf,
+				size_t count)
+{
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val) {
+		mutex_lock(&pci_remove_rescan_mutex);
+		acpi_pci_root_rescan();
+		pcibios_root_rescan();
+		mutex_unlock(&pci_remove_rescan_mutex);
+	}
+	return count;
+}
+
 struct bus_attribute pci_bus_attrs[] = {
 	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, bus_rescan_store),
+	__ATTR(rescan_root, (S_IWUSR|S_IWGRP), NULL, bus_rescan_root_store),
 	__ATTR_NULL
 };
 
-- 
1.7.7

