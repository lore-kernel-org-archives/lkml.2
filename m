Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161743Ab2CSFsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:48:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29608 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161609Ab2CSFsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:48:25 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 42/47] PCI: Add __pci_scan_root_bus() that can skip bus_add
Date: Sun, 18 Mar 2012 22:46:31 -0700
Message-Id: <1332135996-13860-43-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F66C8A6.0099,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So could insert pus pci_assign_unassigned_bus_resources() before do bus_add.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |   13 ++++++++++---
 include/linux/pci.h |    3 +++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 14f2e69..d626c4e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1938,8 +1938,9 @@ void pci_bus_release_busn_res(struct pci_bus *b)
 			res, ret ? "can not be" : "is");
 }
 
-struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
-		struct pci_ops *ops, void *sysdata, struct list_head *resources)
+struct pci_bus * __devinit __pci_scan_root_bus(struct device *parent, int bus,
+		struct pci_ops *ops, void *sysdata, struct list_head *resources,
+		bool bus_add)
 {
 	struct pci_bus *b;
 	struct pci_host_bridge_window *window, *n;
@@ -1970,9 +1971,15 @@ struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 	if (!found)
 		pci_bus_update_busn_res_end(b, b->subordinate);
 
-	pci_bus_add_devices(b);
+	if (bus_add)
+		pci_bus_add_devices(b);
 	return b;
 }
+struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
+		struct pci_ops *ops, void *sysdata, struct list_head *resources)
+{
+	return __pci_scan_root_bus(parent, bus, ops, sysdata, resources, true);
+}
 EXPORT_SYMBOL(pci_scan_root_bus);
 
 /* Deprecated; use pci_scan_root_bus() instead */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index aec945d..161f6c0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -676,6 +676,9 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
 void pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
 void pci_bus_release_busn_res(struct pci_bus *b);
+struct pci_bus * __devinit __pci_scan_root_bus(struct device *parent, int bus,
+		struct pci_ops *ops, void *sysdata, struct list_head *resources,
+		bool bus_add);
 struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
 					     struct pci_ops *ops, void *sysdata,
 					     struct list_head *resources);
-- 
1.7.7

