Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab2EWGgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:36:16 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34517 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965122Ab2EWGfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:35:01 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/11] PCI: Add is_pci_iov_resource_idx()
Date: Tue, 22 May 2012 23:34:35 -0700
Message-Id: <1337754877-19759-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we can remove one ifdef in setup-bus.c. and will share the code in that
ifdef block.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |    7 +++----
 include/linux/pci.h     |    8 ++++++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 4d6823f..99bc728 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -813,16 +813,15 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			if (r->parent || (r->flags & mask) != type)
 				continue;
 			r_size = resource_size(r);
-#ifdef CONFIG_PCI_IOV
+
 			/* put SRIOV requested res to the optional list */
-			if (realloc_head && i >= PCI_IOV_RESOURCES &&
-					i <= PCI_IOV_RESOURCE_END) {
+			if (realloc_head && is_pci_iov_resource_idx(i)) {
 				r->end = r->start - 1;
 				add_to_list(realloc_head, dev, r, r_size, 0/* dont' care */);
 				children_add_size += r_size;
 				continue;
 			}
-#endif
+
 			/* For bridges size != alignment */
 			align = pci_resource_alignment(dev, r);
 			order = __ffs(align) - 20;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c0704a0..0d254d9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -114,6 +114,14 @@ enum {
 	DEVICE_COUNT_RESOURCE = PCI_NUM_RESOURCES,
 };
 
+static inline bool is_pci_iov_resource_idx(int i)
+{
+#ifdef CONFIG_PCI_IOV
+	return i >= PCI_IOV_RESOURCES && i <= PCI_IOV_RESOURCE_END;
+#endif
+	return false;
+}
+
 typedef int __bitwise pci_power_t;
 
 #define PCI_D0		((pci_power_t __force) 0)
-- 
1.7.7

