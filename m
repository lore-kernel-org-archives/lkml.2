Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965419Ab2JCRvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:51:54 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34194 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823Ab2JCRvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:51:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>, yuvalmin@broadcom.com,
        bhutchings@solarflare.com, gregory.v.rose@intel.com,
        davem@davemloft.net--no-chain-reply-to,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/5] PCI: Add pci_dev_type
Date: Wed,  3 Oct 2012 10:51:31 -0700
Message-Id: <1349286695-26713-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1349286695-26713-1-git-send-email-yinghai@kernel.org>
References: <506C3B11.9010009@redhat.com>
 <1349286695-26713-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need to use it for visiable attribute control in syfsfs for pci_dev.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-sysfs.c |   24 ++++++++++++++++++++++++
 drivers/pci/pci.h       |    1 +
 drivers/pci/probe.c     |    1 +
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 02d107b..3d160aa 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1411,3 +1411,27 @@ static int __init pci_sysfs_init(void)
 }
 
 late_initcall(pci_sysfs_init);
+
+static struct attribute *pci_dev_dev_attrs[] = {
+	NULL,
+};
+
+static umode_t pci_dev_attrs_are_visible(struct kobject *kobj,
+						struct attribute *a, int n)
+{
+	return a->mode;
+}
+
+static struct attribute_group pci_dev_attr_group = {
+	.attrs = pci_dev_dev_attrs,
+	.is_visible = pci_dev_attrs_are_visible,
+};
+
+static const struct attribute_group *pci_dev_attr_groups[] = {
+	&pci_dev_attr_group,
+	NULL,
+};
+
+struct device_type pci_dev_type = {
+	.groups = pci_dev_attr_groups,
+};
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index bacbcba..6f6cd14 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -157,6 +157,7 @@ static inline int pci_no_d1d2(struct pci_dev *dev)
 }
 extern struct device_attribute pci_dev_attrs[];
 extern struct device_attribute pcibus_dev_attrs[];
+extern struct device_type pci_dev_type;
 #ifdef CONFIG_HOTPLUG
 extern struct bus_attribute pci_bus_attrs[];
 #else
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ec909af..0312f1c48 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -975,6 +975,7 @@ int pci_setup_device(struct pci_dev *dev)
 	dev->sysdata = dev->bus->sysdata;
 	dev->dev.parent = dev->bus->bridge;
 	dev->dev.bus = &pci_bus_type;
+	dev->dev.type = &pci_dev_type;
 	dev->hdr_type = hdr_type & 0x7f;
 	dev->multifunction = !!(hdr_type & 0x80);
 	dev->error_state = pci_channel_io_normal;
-- 
1.7.7

