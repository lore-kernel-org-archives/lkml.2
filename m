Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2AQM0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:26:54 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:39595 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab2AQMWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:22:20 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Myron Stowe <mstowe@redhat.com>, Myron Stowe <myron.stowe@redhat.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 39/50] ACPI: Fix possible alignment issues with GAS 'address'
 references
Date: Tue, 17 Jan 2012 07:21:31 -0500
Message-id: <bc9ffce27962c0c5fdc6adf74790ea0fcbe4a99c.1326802230.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <mstowe@redhat.com>

Generic Address Structures (GAS) may reside within ACPI tables which
are byte aligned.  This patch copies GAS 'address' references to a local
variable, which will be naturally aligned, to be used going forward.

ACPI Generic Address Structure (GAS) reference:
  ACPI Specification, Revision 4.0, Section 5.2.3.1, "Generic Address
  Structure"

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/osl.c |   38 ++++++++++++++++++++++++--------------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index f31c5c5..2e285cd 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -166,17 +166,21 @@ static u32 acpi_osi_handler(acpi_string interface, u32 supported)
 	return supported;
 }
 
-static void __init acpi_request_region (struct acpi_generic_address *addr,
+static void __init acpi_request_region (struct acpi_generic_address *gas,
 	unsigned int length, char *desc)
 {
-	if (!addr->address || !length)
+	u64 addr;
+
+	/* Handle possible alignment issues */
+	memcpy(&addr, &gas->address, sizeof(addr));
+	if (!addr || !length)
 		return;
 
 	/* Resources are never freed */
-	if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_IO)
-		request_region(addr->address, length, desc);
-	else if (addr->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
-		request_mem_region(addr->address, length, desc);
+	if (gas->space_id == ACPI_ADR_SPACE_SYSTEM_IO)
+		request_region(addr, length, desc);
+	else if (gas->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
+		request_mem_region(addr, length, desc);
 }
 
 static int __init acpi_reserve_resources(void)
@@ -427,35 +431,41 @@ void __init early_acpi_os_unmap_memory(void __iomem *virt, acpi_size size)
 		__acpi_unmap_table(virt, size);
 }
 
-static int acpi_os_map_generic_address(struct acpi_generic_address *addr)
+static int acpi_os_map_generic_address(struct acpi_generic_address *gas)
 {
+	u64 addr;
 	void __iomem *virt;
 
-	if (addr->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
+	if (gas->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		return 0;
 
-	if (!addr->address || !addr->bit_width)
+	/* Handle possible alignment issues */
+	memcpy(&addr, &gas->address, sizeof(addr));
+	if (!addr || !gas->bit_width)
 		return -EINVAL;
 
-	virt = acpi_os_map_memory(addr->address, addr->bit_width / 8);
+	virt = acpi_os_map_memory(addr, gas->bit_width / 8);
 	if (!virt)
 		return -EIO;
 
 	return 0;
 }
 
-static void acpi_os_unmap_generic_address(struct acpi_generic_address *addr)
+static void acpi_os_unmap_generic_address(struct acpi_generic_address *gas)
 {
+	u64 addr;
 	struct acpi_ioremap *map;
 
-	if (addr->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
+	if (gas->space_id != ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		return;
 
-	if (!addr->address || !addr->bit_width)
+	/* Handle possible alignment issues */
+	memcpy(&addr, &gas->address, sizeof(addr));
+	if (!addr || !gas->bit_width)
 		return;
 
 	mutex_lock(&acpi_ioremap_lock);
-	map = acpi_map_lookup(addr->address, addr->bit_width / 8);
+	map = acpi_map_lookup(addr, gas->bit_width / 8);
 	if (!map) {
 		mutex_unlock(&acpi_ioremap_lock);
 		return;
-- 
1.7.9.rc1

