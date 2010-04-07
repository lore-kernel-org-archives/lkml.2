Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab0DGMu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:50:28 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:34136 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab0DGMsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:48:05 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i87h6bh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0IBJS-01-9UO-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/12] x86/amd-iommu: Report errors in acpi parsing functions upstream
Date: Wed, 7 Apr 2010 14:46:41 +0200
Message-ID: <1270644409-10123-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
References: <1270644409-10123-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Apr 2010 12:46:55.0836 (UTC) FILETIME=[67A959C0:01CAD650]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since acpi_table_parse ignores the return values of the
parsing function this patch introduces a workaround and
reports these errors upstream via a global variable.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   38 +++++++++++++++++++++++++++-----------
 1 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 9dc91b4..feaf471 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -138,9 +138,9 @@ int amd_iommus_present;
 bool amd_iommu_np_cache __read_mostly;
 
 /*
- * Set to true if ACPI table parsing and hardware intialization went properly
+ * The ACPI table parsing functions set this variable on an error
  */
-static bool amd_iommu_initialized;
+static int __initdata amd_iommu_init_err;
 
 /*
  * List of protection domains - used during resume
@@ -391,9 +391,11 @@ static int __init find_last_devid_acpi(struct acpi_table_header *table)
 	 */
 	for (i = 0; i < table->length; ++i)
 		checksum += p[i];
-	if (checksum != 0)
+	if (checksum != 0) {
 		/* ACPI table corrupt */
-		return -ENODEV;
+		amd_iommu_init_err = -ENODEV;
+		return 0;
+	}
 
 	p += IVRS_HEADER_LENGTH;
 
@@ -920,11 +922,16 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 				    h->mmio_phys);
 
 			iommu = kzalloc(sizeof(struct amd_iommu), GFP_KERNEL);
-			if (iommu == NULL)
-				return -ENOMEM;
+			if (iommu == NULL) {
+				amd_iommu_init_err = -ENOMEM;
+				return 0;
+			}
+
 			ret = init_iommu_one(iommu, h);
-			if (ret)
-				return ret;
+			if (ret) {
+				amd_iommu_init_err = ret;
+				return 0;
+			}
 			break;
 		default:
 			break;
@@ -934,8 +941,6 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 	}
 	WARN_ON(p != end);
 
-	amd_iommu_initialized = true;
-
 	return 0;
 }
 
@@ -1211,6 +1216,10 @@ static int __init amd_iommu_init(void)
 	if (acpi_table_parse("IVRS", find_last_devid_acpi) != 0)
 		return -ENODEV;
 
+	ret = amd_iommu_init_err;
+	if (ret)
+		goto out;
+
 	dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE);
 	alias_table_size   = tbl_size(ALIAS_TABLE_ENTRY_SIZE);
 	rlookup_table_size = tbl_size(RLOOKUP_TABLE_ENTRY_SIZE);
@@ -1270,12 +1279,19 @@ static int __init amd_iommu_init(void)
 	if (acpi_table_parse("IVRS", init_iommu_all) != 0)
 		goto free;
 
-	if (!amd_iommu_initialized)
+	if (amd_iommu_init_err) {
+		ret = amd_iommu_init_err;
 		goto free;
+	}
 
 	if (acpi_table_parse("IVRS", init_memory_definitions) != 0)
 		goto free;
 
+	if (amd_iommu_init_err) {
+		ret = amd_iommu_init_err;
+		goto free;
+	}
+
 	ret = sysdev_class_register(&amd_iommu_sysdev_class);
 	if (ret)
 		goto free;
-- 
1.7.0.4


