Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab0LNR5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:57:19 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:55749 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab0LNR5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:57:17 -0500
X-Loopcount0: from 10.170.28.41
From: <Narendra_K@Dell.com>
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: <Matt_Domsch@Dell.com>, <Jordan_Hargrave@Dell.com>,
        <Charles_Rose@Dell.com>
Date: Tue, 14 Dec 2010 09:57:12 -0800
Subject: [PATCH] Enable pci=bfsort by default on future Dell systems
Thread-Topic: [PATCH] Enable pci=bfsort by default on future Dell systems
Thread-Index: AcubuFW2NvdNfUxSRw6ZUWE/k2cS6Q==
Message-ID: <20101214175048.GC31345@fedora-14-r710.oslab.blr.amer.dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.5.21 (2010-09-15)
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch enables pci=bfsort by default on future Dell systems.
Please consider for inclusion if acceptable.

From: Jordan Hargrave <jordan_hargrave@dell.com>
Subject: [PATCH] Enable pci=bfsort by default on future Dell systems

This patch enables pci=bfsort by default on future Dell systems.
It reads SMBIOS type 0xB1 vendor specific record and sets pci=bfsort accordingly.

Offset  Name    Length  Value   Description

04      Flags0  Word    Varies  Bits 9-10
                                - 10:9 = 00  Unknown
                                - 10:9 = 01  Breadth First
                                - 10:9 = 10  Depth First
                                - 10:9 = 11  Reserved

1. Any time pci=bfsort has to be enabled on a system, we need to add the model
number of the system to the white list. With this patch, that is not required.

2. Typically, model number has to be added to the white list when the system is
under development. With this change, that is not required.

Signed-off-by: Jordan Hargrave <jordan_hargrave@dell.com>
Signed-off-by: Narendra K <narendra_k@dell.com>
---
 arch/x86/pci/common.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index f7c8a39..5fe7502 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -22,6 +22,7 @@ unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 
 unsigned int pci_early_dump_regs;
 static int pci_bf_sort;
+static int smbios_type_b1_flag;
 int pci_routeirq;
 int noioapicquirk;
 #ifdef CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS
@@ -185,6 +186,39 @@ static int __devinit set_bf_sort(const struct dmi_system_id *d)
 	return 0;
 }
 
+static void __devinit read_dmi_type_b1(const struct dmi_header *dm,
+				       void *private_data)
+{
+	u8 *d = (u8 *)dm + 4;
+
+	if (dm->type != 0xB1)
+		return;
+	switch (((*(u32 *)d) >> 9) & 0x03) {
+	case 0x00:
+		printk(KERN_INFO "dmi type 0xB1 record - unknown flag\n");
+		break;
+	case 0x01: /* set pci=bfsort */
+		smbios_type_b1_flag = 1;
+		break;
+	case 0x02: /* do not set pci=bfsort */
+		smbios_type_b1_flag = 2;
+		break;
+	default:
+		break;
+	}
+}
+
+static int __devinit find_sort_method(const struct dmi_system_id *d)
+{
+	dmi_walk(read_dmi_type_b1, NULL);
+
+	if (smbios_type_b1_flag == 1) {
+		set_bf_sort(d);
+		return 0;
+	}
+	return -1;
+}
+
 /*
  * Enable renumbering of PCI bus# ranges to reach all PCI busses (Cardbus)
  */
@@ -213,6 +247,13 @@ static const struct dmi_system_id __devinitconst pciprobe_dmi_table[] = {
 	},
 #endif		/* __i386__ */
 	{
+		.callback = find_sort_method,
+		.ident = "Dell System",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+		},
+	},
+	{
 		.callback = set_bf_sort,
 		.ident = "Dell PowerEdge 1950",
 		.matches = {
-- 
1.7.1

-- 
With regards,
Narendra K