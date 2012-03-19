Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030960Ab2CSFs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:48:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30905 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161156Ab2CSFsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:48:24 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org
Subject: [PATCH -v3 41/47] PCI, ACPI: Add acpi_pci_root_rescan()
Date: Sun, 18 Mar 2012 22:46:30 -0700
Message-Id: <1332135996-13860-42-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090202.4F66C8A6.001D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will rescan all acpi pci root if related pci root bus get removed before.

Signed-off-by: Yinghai <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
---
 drivers/acpi/pci_root_hp.c |   17 +++++++++++++++++
 include/linux/pci-acpi.h   |    7 +++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_root_hp.c b/drivers/acpi/pci_root_hp.c
index d2ace81..e16b53d 100644
--- a/drivers/acpi/pci_root_hp.c
+++ b/drivers/acpi/pci_root_hp.c
@@ -269,3 +269,20 @@ static int __init acpi_pci_root_hp_init(void)
 }
 
 subsys_initcall(acpi_pci_root_hp_init);
+
+static acpi_status
+rescan_root_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
+{
+	if (!acpi_is_root_bridge(handle))
+		return AE_OK;
+
+	handle_root_bridge_insertion(handle);
+
+	return AE_OK;
+}
+
+void acpi_pci_root_rescan(void)
+{
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+		ACPI_UINT32_MAX, rescan_root_bridge, NULL, NULL, NULL);
+}
diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
index 4462350..ac93634 100644
--- a/include/linux/pci-acpi.h
+++ b/include/linux/pci-acpi.h
@@ -35,6 +35,13 @@ static inline acpi_handle acpi_pci_get_bridge_handle(struct pci_bus *pbus)
 	return acpi_get_pci_rootbridge_handle(pci_domain_nr(pbus),
 					      pbus->number);
 }
+
+void acpi_pci_root_rescan(void);
+
+#else
+
+static inline void acpi_pci_root_rescan(void) { }
+
 #endif
 
 #ifdef CONFIG_ACPI_APEI
-- 
1.7.7

