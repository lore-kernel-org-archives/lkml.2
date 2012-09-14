Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab2INVLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:11:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab2INVL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:11:28 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: pci: Allow passing per-controller private data
Date: Fri, 14 Sep 2012 23:11:18 +0200
Message-Id: <1347657078-32230-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347657078-32230-1-git-send-email-thierry.reding@avionic-design.de>
References: <1347657078-32230-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:jJ4e3rQerPYB3n6zHx4Lc4yTYsnfsprxeaOlVca//rw
 xi1Afl6aqCcL2xRddnW5i2IfT9OQ3cuSkVwNDTrW1z+Ey9k2MS
 Llpb7JI7/66m7Fi/peeQ7bkM/h2s+ZniQnOcrFWNHULNefnWua
 O49ERjQ1JzXOCAK9oVTcFJAZNoc+8hs2yITnkNs/j6DSIrhgTP
 e0T6u8sV9MaanBo5fpmQwwx/04WQDZpe7pM0ZSI+v97jU540S3
 UqwkLTUXQgOzZDQFXM/v/1GktBU2cMJvFmhl3WRufB74pbf9CI
 yIQkHtnn5JKat/+5ZZR1V/J3oz23mcPKkzJkcjY19FQh/RzyAO
 JBI9JmaPhtTrj/zTFmTFPbEYxgOqD83wWrr9ois5Vr+syawyK4
 nUS7NFmmGyM31iy7hn0ZMV1iQxOeihDR3yDQ7peXprQWIdU8vf
 ZVaAb
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
index 7288093..07a38d8 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -442,6 +442,9 @@ static void __devinit pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 		sys->map_irq = hw->map_irq;
 		INIT_LIST_HEAD(&sys->resources);
 
+		if (hw->private_data)
+			sys->private_data = hw->private_data[nr];
+
 		ret = hw->setup(nr, sys);
 
 		if (ret > 0) {
-- 
1.7.12

