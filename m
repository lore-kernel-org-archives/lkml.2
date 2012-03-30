Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278Ab2C3MTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:19:18 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48688 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760384Ab2C3MSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:43 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 27/76] ACPICA: Expand OSL memory read/write interfaces to 64
 bits
Date: Fri, 30 Mar 2012 06:13:30 -0400
Message-id: <653f4b538f66d37db560e0f56af08117136d29b7.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

This change expands acpi_os_read_memory and acpi_os_write_memory to a
full 64 bits. This allows 64 bit transfers via the acpi_read and
acpi_write interfaces. Note: The internal acpi_hw_read and acpi_hw_write
interfaces remain at 32 bits, because 64 bits is not needed to
access the standard ACPI registers.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/hwregs.c  |    8 +++-
 drivers/acpi/acpica/hwxface.c |   44 ++++++---------------
 drivers/acpi/apei/apei-base.c |    4 +-
 drivers/acpi/osl.c            |   86 +----------------------------------------
 include/acpi/acpiosxf.h       |    8 +---
 5 files changed, 23 insertions(+), 127 deletions(-)

diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
index 17a78e5..6b6c83b 100644
--- a/drivers/acpi/acpica/hwregs.c
+++ b/drivers/acpi/acpica/hwregs.c
@@ -157,6 +157,7 @@ acpi_hw_validate_register(struct acpi_generic_address *reg,
 acpi_status acpi_hw_read(u32 *value, struct acpi_generic_address *reg)
 {
 	u64 address;
+	u64 value64;
 	acpi_status status;
 
 	ACPI_FUNCTION_NAME(hw_read);
@@ -178,7 +179,9 @@ acpi_status acpi_hw_read(u32 *value, struct acpi_generic_address *reg)
 	 */
 	if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
 		status = acpi_os_read_memory((acpi_physical_address)
-					     address, value, reg->bit_width);
+					     address, &value64, reg->bit_width);
+
+		*value = (u32)value64;
 	} else {		/* ACPI_ADR_SPACE_SYSTEM_IO, validated earlier */
 
 		status = acpi_hw_read_port((acpi_io_address)
@@ -228,7 +231,8 @@ acpi_status acpi_hw_write(u32 value, struct acpi_generic_address *reg)
 	 */
 	if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
 		status = acpi_os_write_memory((acpi_physical_address)
-					      address, value, reg->bit_width);
+					      address, (u64)value,
+					      reg->bit_width);
 	} else {		/* ACPI_ADR_SPACE_SYSTEM_IO, validated earlier */
 
 		status = acpi_hw_write_port((acpi_io_address)
diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index bb8dba6..a716fed 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -138,11 +138,6 @@ acpi_status acpi_read(u64 *return_value, struct acpi_generic_address *reg)
 		return (status);
 	}
 
-	width = reg->bit_width;
-	if (width == 64) {
-		width = 32;	/* Break into two 32-bit transfers */
-	}
-
 	/* Initialize entire 64-bit return value to zero */
 
 	*return_value = 0;
@@ -154,24 +149,17 @@ acpi_status acpi_read(u64 *return_value, struct acpi_generic_address *reg)
 	 */
 	if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
 		status = acpi_os_read_memory((acpi_physical_address)
-					     address, &value, width);
+					     address, return_value,
+					     reg->bit_width);
 		if (ACPI_FAILURE(status)) {
 			return (status);
 		}
-		*return_value = value;
-
-		if (reg->bit_width == 64) {
-
-			/* Read the top 32 bits */
+	} else {		/* ACPI_ADR_SPACE_SYSTEM_IO, validated earlier */
 
-			status = acpi_os_read_memory((acpi_physical_address)
-						     (address + 4), &value, 32);
-			if (ACPI_FAILURE(status)) {
-				return (status);
-			}
-			*return_value |= ((u64)value << 32);
+		width = reg->bit_width;
+		if (width == 64) {
+			width = 32;	/* Break into two 32-bit transfers */
 		}
-	} else {		/* ACPI_ADR_SPACE_SYSTEM_IO, validated earlier */
 
 		status = acpi_hw_read_port((acpi_io_address)
 					   address, &value, width);
@@ -231,32 +219,22 @@ acpi_status acpi_write(u64 value, struct acpi_generic_address *reg)
 		return (status);
 	}
 
-	width = reg->bit_width;
-	if (width == 64) {
-		width = 32;	/* Break into two 32-bit transfers */
-	}
-
 	/*
 	 * Two address spaces supported: Memory or IO. PCI_Config is
 	 * not supported here because the GAS structure is insufficient
 	 */
 	if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
 		status = acpi_os_write_memory((acpi_physical_address)
-					      address, ACPI_LODWORD(value),
-					      width);
+					      address, value, reg->bit_width);
 		if (ACPI_FAILURE(status)) {
 			return (status);
 		}
+	} else {		/* ACPI_ADR_SPACE_SYSTEM_IO, validated earlier */
 
-		if (reg->bit_width == 64) {
-			status = acpi_os_write_memory((acpi_physical_address)
-						      (address + 4),
-						      ACPI_HIDWORD(value), 32);
-			if (ACPI_FAILURE(status)) {
-				return (status);
-			}
+		width = reg->bit_width;
+		if (width == 64) {
+			width = 32;	/* Break into two 32-bit transfers */
 		}
-	} else {		/* ACPI_ADR_SPACE_SYSTEM_IO, validated earlier */
 
 		status = acpi_hw_write_port((acpi_io_address)
 					    address, ACPI_LODWORD(value),
diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
index e5d53b7..ca77368 100644
--- a/drivers/acpi/apei/apei-base.c
+++ b/drivers/acpi/apei/apei-base.c
@@ -605,7 +605,7 @@ int apei_read(u64 *val, struct acpi_generic_address *reg)
 	*val = 0;
 	switch(reg->space_id) {
 	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
-		status = acpi_os_read_memory64((acpi_physical_address)
+		status = acpi_os_read_memory((acpi_physical_address)
 					     address, val, reg->bit_width);
 		if (ACPI_FAILURE(status))
 			return -EIO;
@@ -636,7 +636,7 @@ int apei_write(u64 val, struct acpi_generic_address *reg)
 
 	switch (reg->space_id) {
 	case ACPI_ADR_SPACE_SYSTEM_MEMORY:
-		status = acpi_os_write_memory64((acpi_physical_address)
+		status = acpi_os_write_memory((acpi_physical_address)
 					      address, val, reg->bit_width);
 		if (ACPI_FAILURE(status))
 			return -EIO;
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 412a1e0..1dea025 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -699,49 +699,6 @@ acpi_status acpi_os_write_port(acpi_io_address port, u32 value, u32 width)
 
 EXPORT_SYMBOL(acpi_os_write_port);
 
-acpi_status
-acpi_os_read_memory(acpi_physical_address phys_addr, u32 * value, u32 width)
-{
-	void __iomem *virt_addr;
-	unsigned int size = width / 8;
-	bool unmap = false;
-	u32 dummy;
-
-	rcu_read_lock();
-	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
-	if (!virt_addr) {
-		rcu_read_unlock();
-		virt_addr = acpi_os_ioremap(phys_addr, size);
-		if (!virt_addr)
-			return AE_BAD_ADDRESS;
-		unmap = true;
-	}
-
-	if (!value)
-		value = &dummy;
-
-	switch (width) {
-	case 8:
-		*(u8 *) value = readb(virt_addr);
-		break;
-	case 16:
-		*(u16 *) value = readw(virt_addr);
-		break;
-	case 32:
-		*(u32 *) value = readl(virt_addr);
-		break;
-	default:
-		BUG();
-	}
-
-	if (unmap)
-		iounmap(virt_addr);
-	else
-		rcu_read_unlock();
-
-	return AE_OK;
-}
-
 #ifdef readq
 static inline u64 read64(const volatile void __iomem *addr)
 {
@@ -758,7 +715,7 @@ static inline u64 read64(const volatile void __iomem *addr)
 #endif
 
 acpi_status
-acpi_os_read_memory64(acpi_physical_address phys_addr, u64 *value, u32 width)
+acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
 {
 	void __iomem *virt_addr;
 	unsigned int size = width / 8;
@@ -803,45 +760,6 @@ acpi_os_read_memory64(acpi_physical_address phys_addr, u64 *value, u32 width)
 	return AE_OK;
 }
 
-acpi_status
-acpi_os_write_memory(acpi_physical_address phys_addr, u32 value, u32 width)
-{
-	void __iomem *virt_addr;
-	unsigned int size = width / 8;
-	bool unmap = false;
-
-	rcu_read_lock();
-	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
-	if (!virt_addr) {
-		rcu_read_unlock();
-		virt_addr = acpi_os_ioremap(phys_addr, size);
-		if (!virt_addr)
-			return AE_BAD_ADDRESS;
-		unmap = true;
-	}
-
-	switch (width) {
-	case 8:
-		writeb(value, virt_addr);
-		break;
-	case 16:
-		writew(value, virt_addr);
-		break;
-	case 32:
-		writel(value, virt_addr);
-		break;
-	default:
-		BUG();
-	}
-
-	if (unmap)
-		iounmap(virt_addr);
-	else
-		rcu_read_unlock();
-
-	return AE_OK;
-}
-
 #ifdef writeq
 static inline void write64(u64 val, volatile void __iomem *addr)
 {
@@ -856,7 +774,7 @@ static inline void write64(u64 val, volatile void __iomem *addr)
 #endif
 
 acpi_status
-acpi_os_write_memory64(acpi_physical_address phys_addr, u64 value, u32 width)
+acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
 {
 	void __iomem *virt_addr;
 	unsigned int size = width / 8;
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index 7c9aebe..1cd2204 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -217,14 +217,10 @@ acpi_status acpi_os_write_port(acpi_io_address address, u32 value, u32 width);
  * Platform and hardware-independent physical memory interfaces
  */
 acpi_status
-acpi_os_read_memory(acpi_physical_address address, u32 * value, u32 width);
-acpi_status
-acpi_os_read_memory64(acpi_physical_address address, u64 *value, u32 width);
+acpi_os_read_memory(acpi_physical_address address, u64 *value, u32 width);
 
 acpi_status
-acpi_os_write_memory(acpi_physical_address address, u32 value, u32 width);
-acpi_status
-acpi_os_write_memory64(acpi_physical_address address, u64 value, u32 width);
+acpi_os_write_memory(acpi_physical_address address, u64 value, u32 width);
 
 /*
  * Platform and hardware-independent PCI configuration space access
-- 
1.7.10.rc2.19.gfae9d

