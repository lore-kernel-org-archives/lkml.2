Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288Ab3AIUrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:47:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62776 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934192Ab3AIUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:43:35 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-tegra@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 07/14] ARM: pci: Allow passing per-controller private data
Date: Wed,  9 Jan 2013 21:43:07 +0100
Message-Id: <1357764194-12677-8-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:zLy3uHxgi0lWtkU6dlZRykrK7CS/ABTiF8VUeNP7JYR
 xBZAufCHLW6G1jrx4AZXw6hp/9yCLInN4f+TZvp3J7L3/Ibjo+
 gaJwaGiWme1LvM8QmBMX7H6nVlpbmU71dEfzbHu4ie6jhnHt9y
 qjXOl8ZOiDN6FjehloKEgDqUxZLF2ph/xmSYMtCHQMgM81hxg3
 FTA3S6oH+N4zO2NlEoxg/TlO58a+jEDBhIb9BXIygqdLhANUMc
 TEpSCCe5sefOhuOJHShKXbrIvhp3CUy7uFrBVmpc7qNmd7yEv9
 yQqV8BfUtztxMlX9+8lEIG69uWWgJ1WYh88dGcVYcEZuyqHZZD
 0g1a0xn1+93ruumnB0c60lpTo31yDA/PdchGzY95Kp72aMqngD
 biWps6Vn3oqOVTpUFVYb66IyHk/8y33LO6tNXNj6frlWchRViQ
 EzLoF
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
index da7b0c9..a1f73b5 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -464,6 +464,9 @@ static void pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 		sys->map_irq = hw->map_irq;
 		INIT_LIST_HEAD(&sys->resources);
 
+		if (hw->private_data)
+			sys->private_data = hw->private_data[nr];
+
 		ret = hw->setup(nr, sys);
 
 		if (ret > 0) {
-- 
1.8.1

