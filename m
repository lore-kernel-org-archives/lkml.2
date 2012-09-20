Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab2ITHWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:22:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2ITHWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:22:04 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 2/2] ARM: pci: Allow passing per-controller private data
Date: Thu, 20 Sep 2012 09:21:50 +0200
Message-Id: <1348125710-28726-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348125710-28726-1-git-send-email-thierry.reding@avionic-design.de>
References: <1348125710-28726-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:yFg2sZ6WxDnIMWoVytGKNqv0XTMphWuCuUOqJVXZI/M
 GaeHuFq5iAsFTrNUuD0mEoomEamAHiv5IMXCjl+2BvRvkBhClo
 HwaP1zwpz1TRkl6ghnsf5rp4V+ZUs3wNWSGiP4d3Sh1njibmS2
 AUMwhDc1LN066IMY76YfKvOvyLuLpt/Ke9ZeYAyhL0/ZRgZfXw
 f1d7j0pCPlusGZWvddN/VBEKnRzQebmj4ED5i7XMcc2N9LYmf3
 g8ypaj6uzCJP8PvSa4erKwnas/3bW2UmfPmuJ79ripAatoeeqz
 kJSM2k/q3WkEYAXTimjkGWpNFZxxZHkV+kFGkZPHpmWiSjv8R2
 BkKgVkyp+27qvXpkR1jhEJN8BCg7yBz1cacai8CAtO3oA/B420
 6o8s0vMFevddVJ7rfWdWy5mKNCtY3fFikvRmpR6OLZlhmDeR+Y
 vWvDA
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
index 26c511f..736cb8d 100644
--- a/arch/arm/include/asm/mach/pci.h
+++ b/arch/arm/include/asm/mach/pci.h
@@ -21,6 +21,7 @@ struct hw_pci {
 #endif
 	struct pci_ops	*ops;
 	int		nr_controllers;
+	void		**private_data;
 	int		(*setup)(int nr, struct pci_sys_data *);
 	struct pci_bus *(*scan)(int nr, struct pci_sys_data *);
 	void		(*preinit)(void);
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 6f1d75f..d69bf81 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -442,6 +442,9 @@ static void pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 		sys->map_irq = hw->map_irq;
 		INIT_LIST_HEAD(&sys->resources);
 
+		if (hw->private_data)
+			sys->private_data = hw->private_data[nr];
+
 		ret = hw->setup(nr, sys);
 
 		if (ret > 0) {
-- 
1.7.12

