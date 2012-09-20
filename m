Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab2ITHoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:44:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52203 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab2ITHn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:43:56 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] ARM: pci: Allow passing per-controller private data
Date: Thu, 20 Sep 2012 09:43:45 +0200
Message-Id: <1348127025-29461-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348127025-29461-1-git-send-email-thierry.reding@avionic-design.de>
References: <1348127025-29461-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:7c6MoA0dLGYKrnOxXNR3s+MmlJCtgkKL3xIGpWvXlx6
 b81/Rw8pEoEelQqtieieeJUREwRBaeT78cWgYBK6YwHHnyZqZk
 +gCxbFbb+Usn5YuZnPc2q7IICms1xtlDApupqB90lB7DSQcQOI
 H1eJlUgvjNocRIjM79A0Jr/YnDwIiEnuY300B9rcgXHmXfWcG0
 9snOpO+H87LUNMnzT53OryGavGI/85tbNSz0wtI5jqCDELcd8N
 rFGwe+Ck2pvEj+LnHrdb2BvdCQhFzJj9CZk5XRMLOEE3o8kXsQ
 S95v2c1Y2PdaYjp7WXllRN1MaZLgIi9HoNpj6GVdwF85CHMOnS
 WUa5WJNgFSYrjijQcLrJiA5eRKMFRb2bdrrdHTVikRQZPjyIZW
 hz3ePD9AWt+OAFRuDgrU3dmVovA/f6EKIhaFI8USIxwlhcl/6i
 TxDK4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow drivers to specify private data for each controller,
this commit adds a private_data field to the struct hw_pci. This field
is an array of nr_controllers pointers that will be used to initialize
the private_data field of the corresponding controller's pci_sys_data
structure.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/include/asm/mach/pci.h | 1 +
 arch/arm/kernel/bios32.c        | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/include/asm/mach/pci.h b/arch/arm/include/asm/mach/pci.h
index db9fedb..5cf2e97 100644
--- a/arch/arm/include/asm/mach/pci.h
+++ b/arch/arm/include/asm/mach/pci.h
@@ -23,6 +23,7 @@ struct hw_pci {
 #endif
 	struct pci_ops	*ops;
 	int		nr_controllers;
+	void		**private_data;
 	int		(*setup)(int nr, struct pci_sys_data *);
 	struct pci_bus *(*scan)(int nr, struct pci_sys_data *);
 	void		(*preinit)(void);
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 2c80f36..88da2d4 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -475,6 +475,9 @@ static void pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 		sys->map_irq = hw->map_irq;
 		INIT_LIST_HEAD(&sys->resources);
 
+		if (hw->private_data)
+			sys->private_data = hw->private_data[nr];
+
 		ret = hw->setup(nr, sys);
 
 		if (ret > 0) {
-- 
1.7.12

