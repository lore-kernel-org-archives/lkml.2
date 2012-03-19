Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161839Ab2CSFtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:49:22 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30980 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161752Ab2CSFsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:48:35 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH -v3 47/47] PCI: Add /sys/bus/pci/rescan_root
Date: Sun, 18 Mar 2012 22:46:36 -0700
Message-Id: <1332135996-13860-48-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090202.4F66C8AF.00C3,ss=1,re=0.000,fgs=0
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
 drivers/pci/pci-sysfs.c                 |   19 +++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

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
index afba77b..c348048 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -302,8 +302,27 @@ static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
 	return count;
 }
 
+void __weak arch_pci_root_rescan(void) { }
+
+static ssize_t bus_rescan_root_store(struct bus_type *bus, const char *buf,
+				size_t count)
+{
+	unsigned long val;
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val) {
+		mutex_lock(&pci_remove_rescan_mutex);
+		arch_pci_root_rescan();
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

