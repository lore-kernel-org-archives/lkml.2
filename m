Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab1KGXXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:23:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab1KGXXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:23:35 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 1/4] ACPI: Fix possible alignment issues with GAS
	'address' references
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, rjw@sisk.pl, ying.huang@intel.com,
        bhelgaas@google.com, trenn@suse.de, linux-kernel@vger.kernel.org
Date: Mon, 07 Nov 2011 16:23:27 -0700
Message-ID: <20111107232327.13472.4785.stgit@amt.stowe>
In-Reply-To: <20111107232321.13472.52069.stgit@amt.stowe>
References: <20111107232321.13472.52069.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

