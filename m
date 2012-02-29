Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965795Ab2B2XMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:12:54 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:26555 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965593Ab2B2XJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:09:35 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/39] x86, PCI: allocate temp range array in amd_bus pci_root_info probing
Date: Wed, 29 Feb 2012 15:07:13 -0800
Message-Id: <1330556858-11768-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
References: <1330556858-11768-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F4EAFEA.008A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/amd_bus.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 5f30a98..aff155d 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -30,7 +30,7 @@ static struct pci_hostbridge_probe pci_probes[] __initdata = {
 	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 },
 };
 
-#define RANGE_NUM 16
+#define RANGE_NUM 128
 
 static struct pci_root_info __init *find_pci_root_info(int node, int link)
 {
@@ -64,7 +64,7 @@ static int __init early_fill_mp_bus_info(void)
 	u32 reg;
 	u64 start;
 	u64 end;
-	struct range range[RANGE_NUM];
+	struct range *range;
 	u64 val;
 	u32 address;
 	bool found;
@@ -125,7 +125,10 @@ static int __init early_fill_mp_bus_info(void)
 	reg = read_pci_config(bus, slot, 0, 0x64);
 	def_link = (reg >> 8) & 0x03;
 
-	memset(range, 0, sizeof(range));
+	range = kcalloc(RANGE_NUM, sizeof(struct range), GFP_KERNEL);
+	if (!range)
+		return -ENOMEM;
+
 	add_range(range, RANGE_NUM, 0, 0, 0xffff + 1);
 	/* io port resource */
 	for (i = 0; i < 4; i++) {
@@ -291,6 +294,8 @@ static int __init early_fill_mp_bus_info(void)
 		}
 	}
 
+	kfree(range);
+
 	print_all_pci_root_info("ht link", true);
 
 	return 0;
-- 
1.7.7

