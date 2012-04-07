Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2DGXUH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 19:20:07 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:5601 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab2DGXUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 19:20:05 -0400
Message-Id: <201204072319.q37NJgrI019382@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sat, 7 Apr 2012 16:53:03 -0400
Subject: [PATCH 1/3] arch/tile: provide kernel support for the tilegx TRIO shim
In-Reply-To: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com>
References: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com>
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 07 Apr 2012 23:19:42.0548 (UTC) FILETIME=[E98D1940:01CD1514]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide kernel support for the tilegx "Transaction I/O" (TRIO) on-chip
hardware.  This hardware implements the PCIe interface for tilegx;
the driver changes to use TRIO for PCIe are in a subsequent commit.

The change is layered on top of the tilegx GXIO IORPC subsystem.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/gxio/Kconfig                       |    9 +
 arch/tile/gxio/Makefile                      |    1 +
 arch/tile/gxio/iorpc_trio.c                  |  352 ++++++++++++++++++++++++++
 arch/tile/gxio/trio.c                        |   49 ++++
 arch/tile/include/arch/trio.h                |   68 +++++
 arch/tile/include/arch/trio_constants.h      |   36 +++
 arch/tile/include/arch/trio_def.h            |   41 +++
 arch/tile/include/arch/trio_pcie_intfc.h     |  203 +++++++++++++++
 arch/tile/include/arch/trio_pcie_intfc_def.h |   32 +++
 arch/tile/include/arch/trio_pcie_rc.h        |  144 +++++++++++
 arch/tile/include/arch/trio_pcie_rc_def.h    |   24 ++
 arch/tile/include/arch/trio_shm.h            |  111 ++++++++
 arch/tile/include/arch/trio_shm_def.h        |   19 ++
 arch/tile/include/gxio/iorpc_trio.h          |  198 +++++++++++++++
 arch/tile/include/gxio/trio.h                |  303 ++++++++++++++++++++++
 arch/tile/include/hv/drv_trio_intf.h         |  196 ++++++++++++++
 16 files changed, 1786 insertions(+), 0 deletions(-)
 create mode 100644 arch/tile/gxio/iorpc_trio.c
 create mode 100644 arch/tile/gxio/trio.c
 create mode 100644 arch/tile/include/arch/trio.h
 create mode 100644 arch/tile/include/arch/trio_constants.h
 create mode 100644 arch/tile/include/arch/trio_def.h
 create mode 100644 arch/tile/include/arch/trio_pcie_intfc.h
 create mode 100644 arch/tile/include/arch/trio_pcie_intfc_def.h
 create mode 100644 arch/tile/include/arch/trio_pcie_rc.h
 create mode 100644 arch/tile/include/arch/trio_pcie_rc_def.h
 create mode 100644 arch/tile/include/arch/trio_shm.h
 create mode 100644 arch/tile/include/arch/trio_shm_def.h
 create mode 100644 arch/tile/include/gxio/iorpc_trio.h
 create mode 100644 arch/tile/include/gxio/trio.h
 create mode 100644 arch/tile/include/hv/drv_trio_intf.h

diff --git a/arch/tile/gxio/Kconfig b/arch/tile/gxio/Kconfig
index ec20e8c..ed0cd48 100644
--- a/arch/tile/gxio/Kconfig
+++ b/arch/tile/gxio/Kconfig
@@ -23,3 +23,12 @@ config TILE_GXIO_MPIPE
 	  This option supports direct access to the TILE-Gx mPIPE hardware
 	  from kernel space.  It is not required in order to use the gxio
 	  library to access mPIPE from user space.
+
+config TILE_GXIO_TRIO
+	bool "Tilera Gx TRIO I/O support"
+	select TILE_GXIO
+	select TILE_GXIO_DMA
+	---help---
+	  This option supports direct access to the TILE-Gx TRIO hardware
+	  from kernel space.  It is not required in order to use the gxio
+	  library to access TRIO from user space.
diff --git a/arch/tile/gxio/Makefile b/arch/tile/gxio/Makefile
index 130eec4..2389ef3 100644
--- a/arch/tile/gxio/Makefile
+++ b/arch/tile/gxio/Makefile
@@ -5,3 +5,4 @@
 obj-$(CONFIG_TILE_GXIO) += iorpc_globals.o kiorpc.o
 obj-$(CONFIG_TILE_GXIO_DMA) += dma_queue.o
 obj-$(CONFIG_TILE_GXIO_MPIPE) += mpipe.o iorpc_mpipe.o iorpc_mpipe_info.o
+obj-$(CONFIG_TILE_GXIO_TRIO) += trio.o iorpc_trio.o
diff --git a/arch/tile/gxio/iorpc_trio.c b/arch/tile/gxio/iorpc_trio.c
new file mode 100644
index 0000000..4ca91ab
--- /dev/null
+++ b/arch/tile/gxio/iorpc_trio.c
@@ -0,0 +1,352 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* This file is machine-generated; DO NOT EDIT! */
+#include "gxio/iorpc_trio.h"
+
+typedef struct {
+	unsigned int count;
+	unsigned int first;
+	unsigned int flags;
+} alloc_asids_param_t;
+
+int gxio_trio_alloc_asids(gxio_trio_context_t * context, unsigned int count,
+			  unsigned int first, unsigned int flags)
+{
+	uint64_t __offset;
+	int __result;
+	alloc_asids_param_t temp;
+	alloc_asids_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->count = count;
+	params->first = first;
+	params->flags = flags;
+
+	__offset = GXIO_TRIO_OP_ALLOC_ASIDS;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_trio_alloc_asids);
+
+
+typedef struct {
+	unsigned int count;
+	unsigned int first;
+	unsigned int flags;
+} alloc_memory_maps_param_t;
+
+int gxio_trio_alloc_memory_maps(gxio_trio_context_t * context,
+				unsigned int count, unsigned int first,
+				unsigned int flags)
+{
+	uint64_t __offset;
+	int __result;
+	alloc_memory_maps_param_t temp;
+	alloc_memory_maps_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->count = count;
+	params->first = first;
+	params->flags = flags;
+
+	__offset = GXIO_TRIO_OP_ALLOC_MEMORY_MAPS;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_trio_alloc_memory_maps);
+
+
+typedef struct {
+	unsigned int count;
+	unsigned int first;
+	unsigned int flags;
+} alloc_pio_regions_param_t;
+
+int gxio_trio_alloc_pio_regions(gxio_trio_context_t * context,
+				unsigned int count, unsigned int first,
+				unsigned int flags)
+{
+	uint64_t __offset;
+	int __result;
+	alloc_pio_regions_param_t temp;
+	alloc_pio_regions_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->count = count;
+	params->first = first;
+	params->flags = flags;
+
+	__offset = GXIO_TRIO_OP_ALLOC_PIO_REGIONS;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_trio_alloc_pio_regions);
+
+typedef struct {
+	unsigned int pio_region;
+	unsigned int mac;
+	uint32_t bus_address_hi;
+	unsigned int flags;
+} init_pio_region_aux_param_t;
+
+int gxio_trio_init_pio_region_aux(gxio_trio_context_t * context,
+				  unsigned int pio_region, unsigned int mac,
+				  uint32_t bus_address_hi, unsigned int flags)
+{
+	uint64_t __offset;
+	int __result;
+	init_pio_region_aux_param_t temp;
+	init_pio_region_aux_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->pio_region = pio_region;
+	params->mac = mac;
+	params->bus_address_hi = bus_address_hi;
+	params->flags = flags;
+
+	__offset = GXIO_TRIO_OP_INIT_PIO_REGION_AUX;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_trio_init_pio_region_aux);
+
+
+typedef struct {
+	unsigned int map;
+	unsigned long va;
+	uint64_t size;
+	unsigned int asid;
+	unsigned int mac;
+	uint64_t bus_address;
+	unsigned int node;
+	unsigned int order_mode;
+} init_memory_map_mmu_aux_param_t;
+
+int gxio_trio_init_memory_map_mmu_aux(gxio_trio_context_t * context,
+				      unsigned int map, unsigned long va,
+				      uint64_t size, unsigned int asid,
+				      unsigned int mac, uint64_t bus_address,
+				      unsigned int node,
+				      unsigned int order_mode)
+{
+	uint64_t __offset;
+	int __result;
+	init_memory_map_mmu_aux_param_t temp;
+	init_memory_map_mmu_aux_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->map = map;
+	params->va = va;
+	params->size = size;
+	params->asid = asid;
+	params->mac = mac;
+	params->bus_address = bus_address;
+	params->node = node;
+	params->order_mode = order_mode;
+
+	__offset = GXIO_TRIO_OP_INIT_MEMORY_MAP_MMU_AUX;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_trio_init_memory_map_mmu_aux);
+
+
+typedef struct {
+	iorpc_interrupt_t interrupt;
+	unsigned int mac;
+	unsigned int intx;
+} config_legacy_intr_param_t;
+
+int gxio_trio_config_legacy_intr(gxio_trio_context_t * context, int inter_x,
+				 int inter_y, int inter_ipi, int inter_event,
+				 unsigned int mac, unsigned int intx)
+{
+	uint64_t __offset;
+	int __result;
+	config_legacy_intr_param_t temp;
+	config_legacy_intr_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->interrupt.kernel.x = inter_x;
+	params->interrupt.kernel.y = inter_y;
+	params->interrupt.kernel.ipi = inter_ipi;
+	params->interrupt.kernel.event = inter_event;
+	params->mac = mac;
+	params->intx = intx;
+
+	__offset = GXIO_TRIO_OP_CONFIG_LEGACY_INTR;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_trio_config_legacy_intr);
+
+typedef struct {
+	iorpc_interrupt_t interrupt;
+	unsigned int mac;
+	unsigned int mem_map;
+	uint64_t mem_map_base;
+	uint64_t mem_map_limit;
+	unsigned int asid;
+} config_msi_intr_param_t;
+
+int gxio_trio_config_msi_intr(gxio_trio_context_t * context, int inter_x,
+			      int inter_y, int inter_ipi, int inter_event,
+			      unsigned int mac, unsigned int mem_map,
+			      uint64_t mem_map_base, uint64_t mem_map_limit,
+			      unsigned int asid)
+{
+	uint64_t __offset;
+	int __result;
+	config_msi_intr_param_t temp;
+	config_msi_intr_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->interrupt.kernel.x = inter_x;
+	params->interrupt.kernel.y = inter_y;
+	params->interrupt.kernel.ipi = inter_ipi;
+	params->interrupt.kernel.event = inter_event;
+	params->mac = mac;
+	params->mem_map = mem_map;
+	params->mem_map_base = mem_map_base;
+	params->mem_map_limit = mem_map_limit;
+	params->asid = asid;
+
+	__offset = GXIO_TRIO_OP_CONFIG_MSI_INTR;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_trio_config_msi_intr);
+
+
+typedef struct {
+	uint16_t mps;
+	uint16_t mrs;
+	unsigned int mac;
+} set_mps_mrs_param_t;
+
+int gxio_trio_set_mps_mrs(gxio_trio_context_t * context, uint16_t mps,
+			  uint16_t mrs, unsigned int mac)
+{
+	uint64_t __offset;
+	int __result;
+	set_mps_mrs_param_t temp;
+	set_mps_mrs_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->mps = mps;
+	params->mrs = mrs;
+	params->mac = mac;
+
+	__offset = GXIO_TRIO_OP_SET_MPS_MRS;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_trio_set_mps_mrs);
+
+typedef struct {
+	unsigned int mac;
+} force_link_up_param_t;
+
+int gxio_trio_force_link_up(gxio_trio_context_t * context, unsigned int mac)
+{
+	uint64_t __offset;
+	int __result;
+	force_link_up_param_t temp;
+	force_link_up_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->mac = mac;
+
+	__offset = GXIO_TRIO_OP_FORCE_LINK_UP;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_trio_force_link_up);
+
+typedef struct {
+	HV_PTE base;
+} get_mmio_base_param_t;
+
+int gxio_trio_get_mmio_base(gxio_trio_context_t * context, HV_PTE *base)
+{
+	uint64_t __offset;
+	int __result;
+	get_mmio_base_param_t temp;
+	get_mmio_base_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	__offset = GXIO_TRIO_OP_GET_MMIO_BASE;
+	__result =
+	    hv_dev_pread(context->fd, 0, (HV_VirtAddr) params, __size,
+			 __offset);
+	*base = params->base;
+
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_trio_get_mmio_base);
+
+typedef struct {
+	unsigned long offset;
+	unsigned long size;
+} check_mmio_offset_param_t;
+
+int gxio_trio_check_mmio_offset(gxio_trio_context_t * context,
+				unsigned long offset, unsigned long size)
+{
+	uint64_t __offset;
+	int __result;
+	check_mmio_offset_param_t temp;
+	check_mmio_offset_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->offset = offset;
+	params->size = size;
+
+	__offset = GXIO_TRIO_OP_CHECK_MMIO_OFFSET;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_trio_check_mmio_offset);
diff --git a/arch/tile/gxio/trio.c b/arch/tile/gxio/trio.c
new file mode 100644
index 0000000..cd5c103
--- /dev/null
+++ b/arch/tile/gxio/trio.c
@@ -0,0 +1,49 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/*
+ * Implementation of trio gxio calls.
+ */
+
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/module.h>
+
+#include <gxio/trio.h>
+#include <gxio/iorpc_globals.h>
+#include <gxio/iorpc_trio.h>
+#include <gxio/kiorpc.h>
+
+int gxio_trio_init(gxio_trio_context_t * context, unsigned int trio_index)
+{
+	char file[32];
+	int fd;
+
+	snprintf(file, sizeof(file), "trio/%d/iorpc", trio_index);
+	fd = hv_dev_open((HV_VirtAddr) file, 0);
+	if (fd < 0) {
+		context->fd = -1;
+
+		if (fd >= GXIO_ERR_MIN && fd <= GXIO_ERR_MAX)
+			return fd;
+		else
+			return -ENODEV;
+	}
+
+	context->fd = fd;
+
+	return 0;
+}
+
+EXPORT_SYMBOL(gxio_trio_init);
diff --git a/arch/tile/include/arch/trio.h b/arch/tile/include/arch/trio.h
new file mode 100644
index 0000000..b1f6bdf
--- /dev/null
+++ b/arch/tile/include/arch/trio.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* Machine-generated file; do not edit. */
+
+#ifndef __ARCH_TRIO_H__
+#define __ARCH_TRIO_H__
+
+#include <arch/abi.h>
+#include <arch/trio_def.h>
+
+#ifndef __ASSEMBLER__
+
+// Tile PIO Region Configuration - CFG Address Format.
+// This register describes the address format for PIO accesses when the
+// associated region is setup with TYPE=CFG.
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    // Register Address (full byte address).
+    uint_reg_t reg_addr     : 12;
+    // Function Number
+    uint_reg_t fn           : 3;
+    // Device Number
+    uint_reg_t dev          : 5;
+    // BUS Number
+    uint_reg_t bus          : 8;
+    // Config Type: 0 for access to directly-attached device.  1 otherwise.
+    uint_reg_t type         : 1;
+    // Reserved.
+    uint_reg_t __reserved_0 : 1;
+    // MAC select.  This must match the configuration in
+    // TILE_PIO_REGION_SETUP.MAC.
+    uint_reg_t mac          : 2;
+    // Reserved.
+    uint_reg_t __reserved_1 : 32;
+#else   // __BIG_ENDIAN__
+    uint_reg_t __reserved_1 : 32;
+    uint_reg_t mac          : 2;
+    uint_reg_t __reserved_0 : 1;
+    uint_reg_t type         : 1;
+    uint_reg_t bus          : 8;
+    uint_reg_t dev          : 5;
+    uint_reg_t fn           : 3;
+    uint_reg_t reg_addr     : 12;
+#endif
+  };
+
+  uint_reg_t word;
+} TRIO_TILE_PIO_REGION_SETUP_CFG_ADDR_t;
+#endif /* !defined(__ASSEMBLER__) */
+
+#endif /* !defined(__ARCH_TRIO_H__) */
diff --git a/arch/tile/include/arch/trio_constants.h b/arch/tile/include/arch/trio_constants.h
new file mode 100644
index 0000000..628b045
--- /dev/null
+++ b/arch/tile/include/arch/trio_constants.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+
+#ifndef __ARCH_TRIO_CONSTANTS_H__
+#define __ARCH_TRIO_CONSTANTS_H__
+
+#define TRIO_NUM_ASIDS 16
+#define TRIO_NUM_TLBS_PER_ASID 16
+
+#define TRIO_NUM_TPIO_REGIONS 8
+#define TRIO_LOG2_NUM_TPIO_REGIONS 3
+
+#define TRIO_NUM_MAP_MEM_REGIONS 16
+#define TRIO_LOG2_NUM_MAP_MEM_REGIONS 4
+#define TRIO_NUM_MAP_SQ_REGIONS 8
+#define TRIO_LOG2_NUM_MAP_SQ_REGIONS 3
+
+#define TRIO_LOG2_NUM_SQ_FIFO_ENTRIES 6
+
+#define TRIO_NUM_PUSH_DMA_RINGS 32
+
+#define TRIO_NUM_PULL_DMA_RINGS 32
+
+#endif /* __ARCH_TRIO_CONSTANTS_H__ */
diff --git a/arch/tile/include/arch/trio_def.h b/arch/tile/include/arch/trio_def.h
new file mode 100644
index 0000000..e805003
--- /dev/null
+++ b/arch/tile/include/arch/trio_def.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* Machine-generated file; do not edit. */
+
+#ifndef __ARCH_TRIO_DEF_H__
+#define __ARCH_TRIO_DEF_H__
+#define TRIO_CFG_REGION_ADDR__REG_SHIFT 0
+#define TRIO_CFG_REGION_ADDR__INTFC_SHIFT 16
+#define TRIO_CFG_REGION_ADDR__INTFC_VAL_TRIO 0x0
+#define TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_INTERFACE 0x1
+#define TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_STANDARD 0x2
+#define TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_PROTECTED 0x3
+#define TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT 18
+#define TRIO_CFG_REGION_ADDR__PROT_SHIFT 20
+#define TRIO_PIO_REGIONS_ADDR__REGION_SHIFT 32
+#define TRIO_MAP_MEM_REG_INT0 0x1000000000
+#define TRIO_MAP_MEM_REG_INT1 0x1000000008
+#define TRIO_MAP_MEM_REG_INT2 0x1000000010
+#define TRIO_MAP_MEM_REG_INT3 0x1000000018
+#define TRIO_MAP_MEM_REG_INT4 0x1000000020
+#define TRIO_MAP_MEM_REG_INT5 0x1000000028
+#define TRIO_MAP_MEM_REG_INT6 0x1000000030
+#define TRIO_MAP_MEM_REG_INT7 0x1000000038
+#define TRIO_MAP_MEM_LIM__ADDR_SHIFT 12
+#define TRIO_MAP_MEM_SETUP__ORDER_MODE_VAL_UNORDERED 0x0
+#define TRIO_MAP_MEM_SETUP__ORDER_MODE_VAL_STRICT 0x1
+#define TRIO_MAP_MEM_SETUP__ORDER_MODE_VAL_REL_ORD 0x2
+#define TRIO_TILE_PIO_REGION_SETUP_CFG_ADDR__MAC_SHIFT 30
+#endif /* !defined(__ARCH_TRIO_DEF_H__) */
diff --git a/arch/tile/include/arch/trio_pcie_intfc.h b/arch/tile/include/arch/trio_pcie_intfc.h
new file mode 100644
index 0000000..a74b56b
--- /dev/null
+++ b/arch/tile/include/arch/trio_pcie_intfc.h
@@ -0,0 +1,203 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* Machine-generated file; do not edit. */
+
+#ifndef __ARCH_TRIO_PCIE_INTFC_H__
+#define __ARCH_TRIO_PCIE_INTFC_H__
+
+#include <arch/abi.h>
+#include <arch/trio_pcie_intfc_def.h>
+
+#ifndef __ASSEMBLER__
+
+// Port Configuration.
+// Configuration of the PCIe Port
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    // Provides the state of the strapping pins for this port.
+    uint_reg_t strap_state      : 3;
+    // Reserved.
+    uint_reg_t __reserved_0     : 1;
+    // When 1, the device type will be overridden using OVD_DEV_TYPE_VAL.
+    // When 0, the device type is determined based on the STRAP_STATE.
+    uint_reg_t ovd_dev_type     : 1;
+    // Provides the device type when OVD_DEV_TYPE is 1.
+    uint_reg_t ovd_dev_type_val : 4;
+    // Determines how link is trained.
+    uint_reg_t train_mode       : 2;
+    // Reserved.
+    uint_reg_t __reserved_1     : 1;
+    // For PCIe, used to flip physical RX lanes that were not properly wired.
+    //  This is not the same as lane reversal which is handled automatically
+    // during link training.  When 0, RX Lane0 must be wired to the link
+    // partner (either to its Lane0 or it's LaneN).  When RX_LANE_FLIP is 1,
+    // the highest numbered lane for this port becomes Lane0 and Lane0 does
+    // NOT have to be wired to the link partner.
+    uint_reg_t rx_lane_flip     : 1;
+    // For PCIe, used to flip physical TX lanes that were not properly wired.
+    //  This is not the same as lane reversal which is handled automatically
+    // during link training.  When 0, TX Lane0 must be wired to the link
+    // partner (either to its Lane0 or it's LaneN).  When TX_LANE_FLIP is 1,
+    // the highest numbered lane for this port becomes Lane0 and Lane0 does
+    // NOT have to be wired to the link partner.
+    uint_reg_t tx_lane_flip     : 1;
+    // For StreamIO port, configures the width of the port when TRAIN_MODE is
+    // not STRAP.
+    uint_reg_t stream_width     : 2;
+    // For StreamIO port, configures the rate of the port when TRAIN_MODE is
+    // not STRAP.
+    uint_reg_t stream_rate      : 2;
+    // Reserved.
+    uint_reg_t __reserved_2     : 46;
+#else   // __BIG_ENDIAN__
+    uint_reg_t __reserved_2     : 46;
+    uint_reg_t stream_rate      : 2;
+    uint_reg_t stream_width     : 2;
+    uint_reg_t tx_lane_flip     : 1;
+    uint_reg_t rx_lane_flip     : 1;
+    uint_reg_t __reserved_1     : 1;
+    uint_reg_t train_mode       : 2;
+    uint_reg_t ovd_dev_type_val : 4;
+    uint_reg_t ovd_dev_type     : 1;
+    uint_reg_t __reserved_0     : 1;
+    uint_reg_t strap_state      : 3;
+#endif
+  };
+
+  uint_reg_t word;
+} TRIO_PCIE_INTFC_PORT_CONFIG_t;
+
+// Port Status.
+// Status of the PCIe Port.  This register applies to the StreamIO port when
+// StreamIO is enabled.
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    // Indicates the DL state of the port.  When 1, the port is up and ready
+    // to receive traffic.
+    uint_reg_t dl_up        : 1;
+    // Indicates the number of times the link has gone down.  Clears on read.
+    uint_reg_t dl_down_cnt  : 7;
+    // Indicates the SERDES PLL has spun up and is providing a valid clock.
+    uint_reg_t clock_ready  : 1;
+    // Reserved.
+    uint_reg_t __reserved_0 : 7;
+    // Device revision ID.
+    uint_reg_t device_rev   : 8;
+    // Link state (PCIe).
+    uint_reg_t ltssm_state  : 6;
+    // Link power management state (PCIe).
+    uint_reg_t pm_state     : 3;
+    // Reserved.
+    uint_reg_t __reserved_1 : 31;
+#else   // __BIG_ENDIAN__
+    uint_reg_t __reserved_1 : 31;
+    uint_reg_t pm_state     : 3;
+    uint_reg_t ltssm_state  : 6;
+    uint_reg_t device_rev   : 8;
+    uint_reg_t __reserved_0 : 7;
+    uint_reg_t clock_ready  : 1;
+    uint_reg_t dl_down_cnt  : 7;
+    uint_reg_t dl_up        : 1;
+#endif
+  };
+
+  uint_reg_t word;
+} TRIO_PCIE_INTFC_PORT_STATUS_t;
+
+// Transmit FIFO Control.
+// Contains TX FIFO thresholds.  These registers are for diagnostics purposes
+// only.  Changing these values causes undefined behavior.
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    // Almost-Empty level for TX0 data.  Typically set to at least
+    // roundup(38.0*M/N) where N=tclk frequency and M=MAC symbol rate in MHz
+    // for a x4 port (250MHz).
+    uint_reg_t tx0_data_ae_lvl : 7;
+    // Reserved.
+    uint_reg_t __reserved_0    : 1;
+    // Almost-Empty level for TX1 data.
+    uint_reg_t tx1_data_ae_lvl : 7;
+    // Reserved.
+    uint_reg_t __reserved_1    : 1;
+    // Almost-Full level for TX0 data.
+    uint_reg_t tx0_data_af_lvl : 7;
+    // Reserved.
+    uint_reg_t __reserved_2    : 1;
+    // Almost-Full level for TX1 data.
+    uint_reg_t tx1_data_af_lvl : 7;
+    // Reserved.
+    uint_reg_t __reserved_3    : 1;
+    // Almost-Full level for TX0 info.
+    uint_reg_t tx0_info_af_lvl : 5;
+    // Reserved.
+    uint_reg_t __reserved_4    : 3;
+    // Almost-Full level for TX1 info.
+    uint_reg_t tx1_info_af_lvl : 5;
+    // Reserved.
+    uint_reg_t __reserved_5    : 3;
+    // This register provides performance adjustment for high bandwidth
+    // flows.  The MAC will assert almost-full to TRIO if non-posted credits
+    // fall below this level.  Note that setting this larger than the initial
+    // PORT_CREDIT.NPH value will cause READS to never be sent.  If the
+    // initial credit value from the link partner is smaller than this value
+    // when the link comes up, the value will be reset to the initial credit
+    // value to prevent lockup.
+    uint_reg_t min_np_credits  : 8;
+    // This register provides performance adjustment for high bandwidth
+    // flows.  The MAC will assert almost-full to TRIO if posted credits fall
+    // below this level.  Note that setting this larger than the initial
+    // PORT_CREDIT.PH value will cause WRITES to never be sent.  If the
+    // initial credit value from the link partner is smaller than this value
+    // when the link comes up, the value will be reset to the initial credit
+    // value to prevent lockup.
+    uint_reg_t min_p_credits   : 8;
+#else   // __BIG_ENDIAN__
+    uint_reg_t min_p_credits   : 8;
+    uint_reg_t min_np_credits  : 8;
+    uint_reg_t __reserved_5    : 3;
+    uint_reg_t tx1_info_af_lvl : 5;
+    uint_reg_t __reserved_4    : 3;
+    uint_reg_t tx0_info_af_lvl : 5;
+    uint_reg_t __reserved_3    : 1;
+    uint_reg_t tx1_data_af_lvl : 7;
+    uint_reg_t __reserved_2    : 1;
+    uint_reg_t tx0_data_af_lvl : 7;
+    uint_reg_t __reserved_1    : 1;
+    uint_reg_t tx1_data_ae_lvl : 7;
+    uint_reg_t __reserved_0    : 1;
+    uint_reg_t tx0_data_ae_lvl : 7;
+#endif
+  };
+
+  uint_reg_t word;
+} TRIO_PCIE_INTFC_TX_FIFO_CTL_t;
+#endif /* !defined(__ASSEMBLER__) */
+
+#endif /* !defined(__ARCH_TRIO_PCIE_INTFC_H__) */
diff --git a/arch/tile/include/arch/trio_pcie_intfc_def.h b/arch/tile/include/arch/trio_pcie_intfc_def.h
new file mode 100644
index 0000000..d3fd678
--- /dev/null
+++ b/arch/tile/include/arch/trio_pcie_intfc_def.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* Machine-generated file; do not edit. */
+
+#ifndef __ARCH_TRIO_PCIE_INTFC_DEF_H__
+#define __ARCH_TRIO_PCIE_INTFC_DEF_H__
+#define TRIO_PCIE_INTFC_MAC_INT_STS 0x0000
+#define TRIO_PCIE_INTFC_MAC_INT_STS__INT_LEVEL_MASK  0xf000
+#define TRIO_PCIE_INTFC_PORT_CONFIG 0x0018
+#define TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_DISABLED 0x0
+#define TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_ENDPOINT 0x1
+#define TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_RC 0x2
+#define TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_ENDPOINT_G1 0x3
+#define TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_RC_G1 0x4
+#define TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_XLINK 0x5
+#define TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_STREAM_X1 0x6
+#define TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_STREAM_X4 0x7
+#define TRIO_PCIE_INTFC_PORT_STATUS 0x0020
+#define TRIO_PCIE_INTFC_TX_FIFO_CTL 0x0050
+#endif /* !defined(__ARCH_TRIO_PCIE_INTFC_DEF_H__) */
diff --git a/arch/tile/include/arch/trio_pcie_rc.h b/arch/tile/include/arch/trio_pcie_rc.h
new file mode 100644
index 0000000..4986628
--- /dev/null
+++ b/arch/tile/include/arch/trio_pcie_rc.h
@@ -0,0 +1,144 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* Machine-generated file; do not edit. */
+
+#ifndef __ARCH_TRIO_PCIE_RC_H__
+#define __ARCH_TRIO_PCIE_RC_H__
+
+#include <arch/abi.h>
+#include <arch/trio_pcie_rc_def.h>
+
+#ifndef __ASSEMBLER__
+
+// Device Capabilities Register.
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    // Max_Payload_Size Supported, writablethrough the MAC_STANDARD interface
+    uint_reg_t mps_sup                    : 3;
+    // This field is writable through the MAC_STANDARD interface.  However,
+    // Phantom Function is not  supported. Therefore, the application must
+    // not write any value other than 0x0 to this  field.
+    uint_reg_t phantom_function_supported : 2;
+    // This bit is writable through the MAC_STANDARD interface.
+    uint_reg_t ext_tag_field_supported    : 1;
+    // Reserved.
+    uint_reg_t __reserved_0               : 3;
+    // Endpoint L1 Acceptable Latency Must be 0x0 for non-Endpoint devices.
+    uint_reg_t l1_lat                     : 3;
+    // Undefined since PCI Express 1.1 (Was Attention Button Present for PCI
+    // Express 1.0a)
+    uint_reg_t r1                         : 1;
+    // Undefined since PCI Express 1.1 (Was Attention Indicator Present for
+    // PCI  Express 1.0a)
+    uint_reg_t r2                         : 1;
+    // Undefined since PCI Express 1.1 (Was Power Indicator Present for PCI
+    // Express 1.0a)
+    uint_reg_t r3                         : 1;
+    // Role-Based Error Reporting, writable through the MAC_STANDARD
+    // interface.  Required to be set for device compliant to 1.1  spec and
+    // later.
+    uint_reg_t rer                        : 1;
+    // Reserved.
+    uint_reg_t __reserved_1               : 2;
+    // Captured Slot Power Limit Value Upstream port only.
+    uint_reg_t slot_pwr_lim               : 8;
+    // Captured Slot Power Limit Scale Upstream port only.
+    uint_reg_t slot_pwr_scale             : 2;
+    // Reserved.
+    uint_reg_t __reserved_2               : 4;
+    // Endpoint L0s Acceptable LatencyMust be 0x0 for non-Endpoint devices.
+    uint_reg_t l0s_lat                    : 1;
+    // Reserved.
+    uint_reg_t __reserved_3               : 31;
+#else   // __BIG_ENDIAN__
+    uint_reg_t __reserved_3               : 31;
+    uint_reg_t l0s_lat                    : 1;
+    uint_reg_t __reserved_2               : 4;
+    uint_reg_t slot_pwr_scale             : 2;
+    uint_reg_t slot_pwr_lim               : 8;
+    uint_reg_t __reserved_1               : 2;
+    uint_reg_t rer                        : 1;
+    uint_reg_t r3                         : 1;
+    uint_reg_t r2                         : 1;
+    uint_reg_t r1                         : 1;
+    uint_reg_t l1_lat                     : 3;
+    uint_reg_t __reserved_0               : 3;
+    uint_reg_t ext_tag_field_supported    : 1;
+    uint_reg_t phantom_function_supported : 2;
+    uint_reg_t mps_sup                    : 3;
+#endif
+  };
+
+  uint_reg_t word;
+} TRIO_PCIE_RC_DEVICE_CAP_t;
+
+// Device Control Register.
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    // Correctable Error Reporting Enable
+    uint_reg_t cor_err_ena      : 1;
+    // Non-Fatal Error Reporting Enable
+    uint_reg_t nf_err_ena       : 1;
+    // Fatal Error Reporting Enable
+    uint_reg_t fatal_err_ena    : 1;
+    // Unsupported Request Reporting Enable
+    uint_reg_t ur_ena           : 1;
+    // Relaxed orderring enable
+    uint_reg_t ro_ena           : 1;
+    // Max Payload Size
+    uint_reg_t max_payload_size : 3;
+    // Extended Tag Field Enable
+    uint_reg_t ext_tag          : 1;
+    // Phantom Function Enable
+    uint_reg_t ph_fn_ena        : 1;
+    // AUX Power PM Enable
+    uint_reg_t aux_pm_ena       : 1;
+    // Enable NoSnoop
+    uint_reg_t no_snoop         : 1;
+    // Max read request size
+    uint_reg_t max_read_req_sz  : 3;
+    // Reserved.
+    uint_reg_t __reserved       : 49;
+#else   // __BIG_ENDIAN__
+    uint_reg_t __reserved       : 49;
+    uint_reg_t max_read_req_sz  : 3;
+    uint_reg_t no_snoop         : 1;
+    uint_reg_t aux_pm_ena       : 1;
+    uint_reg_t ph_fn_ena        : 1;
+    uint_reg_t ext_tag          : 1;
+    uint_reg_t max_payload_size : 3;
+    uint_reg_t ro_ena           : 1;
+    uint_reg_t ur_ena           : 1;
+    uint_reg_t fatal_err_ena    : 1;
+    uint_reg_t nf_err_ena       : 1;
+    uint_reg_t cor_err_ena      : 1;
+#endif
+  };
+
+  uint_reg_t word;
+} TRIO_PCIE_RC_DEVICE_CONTROL_t;
+#endif /* !defined(__ASSEMBLER__) */
+
+#endif /* !defined(__ARCH_TRIO_PCIE_RC_H__) */
diff --git a/arch/tile/include/arch/trio_pcie_rc_def.h b/arch/tile/include/arch/trio_pcie_rc_def.h
new file mode 100644
index 0000000..74081a6
--- /dev/null
+++ b/arch/tile/include/arch/trio_pcie_rc_def.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* Machine-generated file; do not edit. */
+
+#ifndef __ARCH_TRIO_PCIE_RC_DEF_H__
+#define __ARCH_TRIO_PCIE_RC_DEF_H__
+#define TRIO_PCIE_RC_DEVICE_CAP 0x0074
+#define TRIO_PCIE_RC_DEVICE_CONTROL 0x0078
+#define TRIO_PCIE_RC_DEVICE_ID_VEN_ID 0x0000
+#define TRIO_PCIE_RC_DEVICE_ID_VEN_ID__DEV_ID_SHIFT 16
+#define TRIO_PCIE_RC_REVISION_ID 0x0008
+#endif /* !defined(__ARCH_TRIO_PCIE_RC_DEF_H__) */
diff --git a/arch/tile/include/arch/trio_shm.h b/arch/tile/include/arch/trio_shm.h
new file mode 100644
index 0000000..652bbb7
--- /dev/null
+++ b/arch/tile/include/arch/trio_shm.h
@@ -0,0 +1,111 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* Machine-generated file; do not edit. */
+
+
+#ifndef __ARCH_TRIO_SHM_H__
+#define __ARCH_TRIO_SHM_H__
+
+#include <arch/abi.h>
+#include <arch/trio_shm_def.h>
+
+#ifndef __ASSEMBLER__
+//! TRIO DMA Descriptor.
+//! The TRIO DMA descriptor is written by software and consumed by hardware.
+//! It is used to specify the location of transaction data in the IO and Tile
+//! domains.
+
+__extension__
+typedef union
+{
+  struct
+  {
+    // Word 0
+
+#ifndef __BIG_ENDIAN__
+    //! Tile side virtual address.
+    int_reg_t va           : 42;
+    //! Encoded size of buffer used on push DMA when C=1:
+    //! 0 = 128 bytes
+    //! 1 = 256 bytes
+    //! 2 = 512 bytes
+    //! 3 = 1024 bytes
+    //! 4 = 1664 bytes
+    //! 5 = 4096 bytes
+    //! 6 = 10368 bytes
+    //! 7 = 16384 bytes
+    uint_reg_t bsz          : 3;
+    //! Chaining designation.  Always zero for pull DMA
+    //! 0 : Unchained buffer pointer
+    //! 1 : Chained buffer pointer.  Next buffer descriptor (e.g. VA) stored
+    //! in 1st 8-bytes in buffer.  For chained buffers, first 8-bytes of each
+    //! buffer contain the next buffer descriptor formatted exactly like a PDE
+    //! buffer descriptor.  This allows a chained PDE buffer to be sent using
+    //! push DMA.
+    uint_reg_t c            : 1;
+    //! Notification interrupt will be delivered when the transaction has
+    //! completed (all data has been read from or written to the Tile-side
+    //! buffer).
+    uint_reg_t notif        : 1;
+    //! When 0, the XSIZE field specifies the total byte count for the
+    //! transaction.  When 1, the XSIZE field is encoded as 2^(N+14) for N in
+    //! {0..6}:
+    //! 0 = 16KB
+    //! 1 = 32KB
+    //! 2 = 64KB
+    //! 3 = 128KB
+    //! 4 = 256KB
+    //! 5 = 512KB
+    //! 6 = 1MB
+    //! All other encodings of the XSIZE field are reserved when SMOD=1
+    uint_reg_t smod         : 1;
+    //! Total number of bytes to move for this transaction.   When SMOD=1,
+    //! this field is encoded - see SMOD description.
+    uint_reg_t xsize        : 14;
+    //! Reserved.
+    uint_reg_t __reserved_0 : 1;
+    //! Generation number.  Used to indicate a valid descriptor in ring.  When
+    //! a new descriptor is written into the ring, software must toggle this
+    //! bit.  The net effect is that the GEN bit being written into new
+    //! descriptors toggles each time the ring tail pointer wraps.
+    uint_reg_t gen          : 1;
+#else   // __BIG_ENDIAN__
+    uint_reg_t gen          : 1;
+    uint_reg_t __reserved_0 : 1;
+    uint_reg_t xsize        : 14;
+    uint_reg_t smod         : 1;
+    uint_reg_t notif        : 1;
+    uint_reg_t c            : 1;
+    uint_reg_t bsz          : 3;
+    int_reg_t va           : 42;
+#endif
+
+    // Word 1
+
+#ifndef __BIG_ENDIAN__
+    //! IO-side address
+    uint_reg_t io_address : 64;
+#else   // __BIG_ENDIAN__
+    uint_reg_t io_address : 64;
+#endif
+
+  };
+
+  //! Word access
+  uint_reg_t words[2];
+} TRIO_DMA_DESC_t;
+#endif /* !defined(__ASSEMBLER__) */
+
+#endif /* !defined(__ARCH_TRIO_SHM_H__) */
diff --git a/arch/tile/include/arch/trio_shm_def.h b/arch/tile/include/arch/trio_shm_def.h
new file mode 100644
index 0000000..72a59c8
--- /dev/null
+++ b/arch/tile/include/arch/trio_shm_def.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* Machine-generated file; do not edit. */
+
+#ifndef __ARCH_TRIO_SHM_DEF_H__
+#define __ARCH_TRIO_SHM_DEF_H__
+#endif /* !defined(__ARCH_TRIO_SHM_DEF_H__) */
diff --git a/arch/tile/include/gxio/iorpc_trio.h b/arch/tile/include/gxio/iorpc_trio.h
new file mode 100644
index 0000000..3ef5642
--- /dev/null
+++ b/arch/tile/include/gxio/iorpc_trio.h
@@ -0,0 +1,198 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* This file is machine-generated; DO NOT EDIT! */
+#ifndef __GXIO_TRIO_LINUX_RPC_H__
+#define __GXIO_TRIO_LINUX_RPC_H__
+
+#include <hv/iorpc.h>
+
+#include <hv/drv_trio_intf.h>
+#include <gxio/trio.h>
+#include <gxio/kiorpc.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <asm/pgtable.h>
+
+#define GXIO_TRIO_OP_ALLOC_ASIDS       IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1400)
+#define GXIO_TRIO_OP_REGISTER_PAGE_AUX IORPC_OPCODE(IORPC_FORMAT_KERNEL_MEM, 0x1401)
+#define GXIO_TRIO_OP_ALLOC_MEMORY_MAPS IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1402)
+#define GXIO_TRIO_OP_INIT_MEMORY_MAP_AUX IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1403)
+#define GXIO_TRIO_OP_READ_ISR_STATUS_AUX IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1404)
+#define GXIO_TRIO_OP_WRITE_ISR_STATUS_AUX IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1405)
+#define GXIO_TRIO_OP_ENABLE_MMI        IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x1406)
+#define GXIO_TRIO_OP_MASK_MMI_AUX      IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1407)
+#define GXIO_TRIO_OP_UNMASK_MMI_AUX    IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1408)
+#define GXIO_TRIO_OP_READ_MMI_BITS_AUX IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1409)
+#define GXIO_TRIO_OP_WRITE_MMI_BITS_AUX IORPC_OPCODE(IORPC_FORMAT_NONE, 0x140a)
+#define GXIO_TRIO_OP_ALLOC_SCATTER_QUEUES IORPC_OPCODE(IORPC_FORMAT_NONE, 0x140b)
+#define GXIO_TRIO_OP_INIT_SCATTER_QUEUE_AUX IORPC_OPCODE(IORPC_FORMAT_NONE, 0x140c)
+#define GXIO_TRIO_OP_ENABLE_SQI        IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x140d)
+#define GXIO_TRIO_OP_ALLOC_PIO_REGIONS IORPC_OPCODE(IORPC_FORMAT_NONE, 0x140e)
+#define GXIO_TRIO_OP_INIT_PIO_REGION_AUX IORPC_OPCODE(IORPC_FORMAT_NONE, 0x140f)
+#define GXIO_TRIO_OP_ALLOC_PUSH_DMA_RING IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1410)
+#define GXIO_TRIO_OP_ALLOC_PULL_DMA_RING IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1411)
+#define GXIO_TRIO_OP_INIT_PUSH_DMA_RING_AUX IORPC_OPCODE(IORPC_FORMAT_KERNEL_MEM, 0x1412)
+#define GXIO_TRIO_OP_ENABLE_PUSH_DMA_ISR IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x1413)
+#define GXIO_TRIO_OP_INIT_PULL_DMA_RING_AUX IORPC_OPCODE(IORPC_FORMAT_KERNEL_MEM, 0x1414)
+#define GXIO_TRIO_OP_ENABLE_PULL_DMA_ISR IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x1415)
+#define GXIO_TRIO_OP_TRIGGER_HOST_INTERRUPT_AUX IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1416)
+#define GXIO_TRIO_OP_REGISTER_CLIENT_MEMORY IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x1417)
+#define GXIO_TRIO_OP_INIT_MEMORY_MAP_MMU_AUX IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x1418)
+#define GXIO_TRIO_OP_GET_PORT_PROPERTY IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x1419)
+#define GXIO_TRIO_OP_CONFIG_LEGACY_INTR IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x141a)
+#define GXIO_TRIO_OP_CONFIG_MSI_INTR   IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x141b)
+#define GXIO_TRIO_OP_CONFIG_CHAR_INTR  IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x141c)
+#define GXIO_TRIO_OP_SET_MPS_MRS       IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x141d)
+#define GXIO_TRIO_OP_FORCE_LINK_UP     IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x141e)
+#define GXIO_TRIO_OP_GET_MMIO_BASE     IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x8000)
+#define GXIO_TRIO_OP_CHECK_MMIO_OFFSET IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x8001)
+
+int gxio_trio_alloc_asids(gxio_trio_context_t * context, unsigned int count,
+			  unsigned int first, unsigned int flags);
+
+int gxio_trio_register_page_aux(gxio_trio_context_t * context, void *page_va,
+				size_t page_size, unsigned int page_flags,
+				unsigned int stack, uint64_t vpn);
+
+int gxio_trio_alloc_memory_maps(gxio_trio_context_t * context,
+				unsigned int count, unsigned int first,
+				unsigned int flags);
+
+int gxio_trio_init_memory_map_aux(gxio_trio_context_t * context,
+				  unsigned int map, uint64_t vpn, uint64_t size,
+				  unsigned int asid, unsigned int mac,
+				  uint64_t bus_address,
+				  unsigned int order_mode);
+
+int gxio_trio_read_isr_status_aux(gxio_trio_context_t * context,
+				  unsigned int vec_num);
+
+int gxio_trio_write_isr_status_aux(gxio_trio_context_t * context,
+				   unsigned int vec_num,
+				   uint32_t bits_to_clear);
+
+int gxio_trio_enable_mmi(gxio_trio_context_t * context, int bind_x, int bind_y,
+			 int bind_ipi, int bind_event, unsigned int map,
+			 unsigned int mode);
+
+int gxio_trio_mask_mmi_aux(gxio_trio_context_t * context, unsigned int map,
+			   unsigned int mask);
+
+int gxio_trio_unmask_mmi_aux(gxio_trio_context_t * context, unsigned int map,
+			     unsigned int mask);
+
+int gxio_trio_read_mmi_bits_aux(gxio_trio_context_t * context,
+				unsigned int map);
+
+int gxio_trio_write_mmi_bits_aux(gxio_trio_context_t * context,
+				 unsigned int map, unsigned int bits,
+				 unsigned int mode);
+
+int gxio_trio_alloc_scatter_queues(gxio_trio_context_t * context,
+				   unsigned int count, unsigned int first,
+				   unsigned int flags);
+
+int gxio_trio_init_scatter_queue_aux(gxio_trio_context_t * context,
+				     unsigned int queue, uint64_t size,
+				     unsigned int asid, unsigned int mac,
+				     uint64_t bus_address,
+				     unsigned int order_mode);
+
+int gxio_trio_enable_sqi(gxio_trio_context_t * context, int bind_x, int bind_y,
+			 int bind_ipi, int bind_event, unsigned int queue);
+
+int gxio_trio_alloc_pio_regions(gxio_trio_context_t * context,
+				unsigned int count, unsigned int first,
+				unsigned int flags);
+
+int gxio_trio_init_pio_region_aux(gxio_trio_context_t * context,
+				  unsigned int pio_region, unsigned int mac,
+				  uint32_t bus_address_hi, unsigned int flags);
+
+int gxio_trio_alloc_push_dma_ring(gxio_trio_context_t * context,
+				  unsigned int count, unsigned int first,
+				  unsigned int flags);
+
+int gxio_trio_alloc_pull_dma_ring(gxio_trio_context_t * context,
+				  unsigned int count, unsigned int first,
+				  unsigned int flags);
+
+int gxio_trio_init_push_dma_ring_aux(gxio_trio_context_t * context,
+				     void *mem_va, size_t mem_size,
+				     unsigned int mem_flags, unsigned int ring,
+				     unsigned int mac, unsigned int asid,
+				     unsigned int flags);
+
+int gxio_trio_enable_push_dma_isr(gxio_trio_context_t * context, int bind_x,
+				  int bind_y, int bind_ipi, int bind_event,
+				  unsigned int ring);
+
+int gxio_trio_init_pull_dma_ring_aux(gxio_trio_context_t * context,
+				     void *mem_va, size_t mem_size,
+				     unsigned int mem_flags, unsigned int ring,
+				     unsigned int mac, unsigned int asid,
+				     unsigned int flags);
+
+int gxio_trio_enable_pull_dma_isr(gxio_trio_context_t * context, int bind_x,
+				  int bind_y, int bind_ipi, int bind_event,
+				  unsigned int ring);
+
+int gxio_trio_trigger_host_interrupt_aux(gxio_trio_context_t * context,
+					 unsigned int mac,
+					 unsigned long msix_addr,
+					 unsigned int msix_data);
+
+int gxio_trio_register_client_memory(gxio_trio_context_t * context,
+				     unsigned int iotlb, HV_PTE pte,
+				     unsigned int flags);
+
+int gxio_trio_init_memory_map_mmu_aux(gxio_trio_context_t * context,
+				      unsigned int map, unsigned long va,
+				      uint64_t size, unsigned int asid,
+				      unsigned int mac, uint64_t bus_address,
+				      unsigned int node,
+				      unsigned int order_mode);
+
+int gxio_trio_get_port_property(gxio_trio_context_t * context,
+				struct pcie_trio_ports_property *trio_ports);
+
+int gxio_trio_config_legacy_intr(gxio_trio_context_t * context, int inter_x,
+				 int inter_y, int inter_ipi, int inter_event,
+				 unsigned int mac, unsigned int intx);
+
+int gxio_trio_config_msi_intr(gxio_trio_context_t * context, int inter_x,
+			      int inter_y, int inter_ipi, int inter_event,
+			      unsigned int mac, unsigned int mem_map,
+			      uint64_t mem_map_base, uint64_t mem_map_limit,
+			      unsigned int asid);
+
+int gxio_trio_config_char_intr(gxio_trio_context_t * context, int inter_x,
+			       int inter_y, int inter_ipi, int inter_event,
+			       unsigned int mac, unsigned int mem_map,
+			       unsigned int push_dma_ring,
+			       unsigned int pull_dma_ring,
+			       pcie_stream_intr_config_sel_t conf);
+
+int gxio_trio_set_mps_mrs(gxio_trio_context_t * context, uint16_t mps,
+			  uint16_t mrs, unsigned int mac);
+
+int gxio_trio_force_link_up(gxio_trio_context_t * context, unsigned int mac);
+
+int gxio_trio_get_mmio_base(gxio_trio_context_t * context, HV_PTE *base);
+
+int gxio_trio_check_mmio_offset(gxio_trio_context_t * context,
+				unsigned long offset, unsigned long size);
+
+#endif /* !__GXIO_TRIO_LINUX_RPC_H__ */
diff --git a/arch/tile/include/gxio/trio.h b/arch/tile/include/gxio/trio.h
new file mode 100644
index 0000000..5e55fcc
--- /dev/null
+++ b/arch/tile/include/gxio/trio.h
@@ -0,0 +1,303 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/*
+ *
+ * An API for allocating, configuring, and manipulating TRIO hardware
+ * resources
+ */
+
+/*
+ *
+ * The TILE-Gx TRIO shim provides connections to external devices via
+ * PCIe or other transaction IO standards.  The gxio_trio_ API,
+ * declared in <gxio/trio.h>, allows applications to allocate and
+ * configure TRIO IO resources like DMA command rings, memory map
+ * windows, and device interrupts.  The following sections introduce
+ * the various components of the API.  We strongly recommend reading
+ * the TRIO section of the IO Device Guide (UG404) before working with
+ * this API.
+ *
+ * @section trio__ingress TRIO Ingress Hardware Resources
+ *
+ * The TRIO ingress hardware is responsible for examining incoming
+ * PCIe or StreamIO packets and choosing a processing mechanism based
+ * on the packets' bus address.  The gxio_trio_ API can be used to
+ * configure different handlers for different ranges of bus address
+ * space.  The user can configure "mapped memory" and "scatter queue"
+ * regions to match incoming packets within 4kB-aligned ranges of bus
+ * addresses.  Each range specifies a different set of mapping
+ * parameters to be applied when handling the ingress packet.  The
+ * following sections describe how to work with MapMem and scatter
+ * queue regions.
+ *
+ * @subsection trio__mapmem TRIO MapMem Regions
+ *
+ * TRIO mapped memory (or MapMem) regions allow the user to map
+ * incoming read and write requests directly to the application's
+ * memory space.  MapMem regions are allocated via
+ * gxio_trio_alloc_memory_maps().  Given an integer MapMem number,
+ * applications can use gxio_trio_init_memory_map() to specify the
+ * range of bus addresses that will match the region and the range of
+ * virtual addresses to which those packets will be applied.
+ *
+ * As with many other gxio APIs, the programmer must be sure to
+ * register memory pages that will be used with MapMem regions.  Pages
+ * can be registered with TRIO by allocating an ASID (address space
+ * identifier) and then using gxio_trio_register_page() to register up to
+ * 16 pages with the hardware.  The initialization functions for
+ * resources that require registered memory (MapMem, scatter queues,
+ * push DMA, and pull DMA) then take an 'asid' parameter in order to
+ * configure which set of registered pages is used by each resource.
+ *
+ * @subsection trio__scatter_queue TRIO Scatter Queues
+ *
+ * The TRIO shim's scatter queue regions allow users to dynamically
+ * map buffers from a large address space into a small range of bus
+ * addresses.  This is particularly helpful for PCIe endpoint devices,
+ * where the host generally limits the size of BARs to tens of
+ * megabytes.
+ *
+ * Each scatter queue consists of a memory map region, a queue of
+ * tile-side buffer VAs to be mapped to that region, and a bus-mapped
+ * "doorbell" register that the remote endpoint can write to trigger a
+ * dequeue of the current buffer VA, thus swapping in a new buffer.
+ * The VAs pushed onto a scatter queue must be 4kB aligned, so
+ * applications may need to use higher-level protocols to inform
+ * remote entities that they should apply some additional, sub-4kB
+ * offset when reading or writing the scatter queue region.  For more
+ * information, see the IO Device Guide (UG404).
+ *
+ * @section trio__egress TRIO Egress Hardware Resources
+ *
+ * The TRIO shim supports two mechanisms for egress packet generation:
+ * programmed IO (PIO) and push/pull DMA.  PIO allows applications to
+ * create MMIO mappings for PCIe or StreamIO address space, such that
+ * the application can generate word-sized read or write transactions
+ * by issuing load or store instructions.  Push and pull DMA are tuned
+ * for larger transactions; they use specialized hardware engines to
+ * transfer large blocks of data at line rate.
+ *
+ * @subsection trio__pio TRIO Programmed IO
+ *
+ * Programmed IO allows applications to create MMIO mappings for PCIe
+ * or StreamIO address space.  The hardware PIO regions support access
+ * to PCIe configuration, IO, and memory space, but the gxio_trio API
+ * only supports memory space accesses.  PIO regions are allocated
+ * with gxio_trio_alloc_pio_regions() and initialized via
+ * gxio_trio_init_pio_region().  Once a region is bound to a range of
+ * bus address via the initialization function, the application can
+ * use gxio_trio_map_pio_region() to create MMIO mappings from its VA
+ * space onto the range of bus addresses supported by the PIO region.
+ *
+ * @subsection trio_dma TRIO Push and Pull DMA
+ *
+ * The TRIO push and pull DMA engines allow users to copy blocks of
+ * data between application memory and the bus.  Push DMA generates
+ * write packets that copy from application memory to the bus and pull
+ * DMA generates read packets that copy from the bus into application
+ * memory.  The DMA engines are managed via an API that is very
+ * similar to the mPIPE eDMA interface.  For a detailed explanation of
+ * the eDMA queue API, see @ref gxio_mpipe_wrappers.
+ *
+ * Push and pull DMA queues are allocated via
+ * gxio_trio_alloc_push_dma_ring() / gxio_trio_alloc_pull_dma_ring().
+ * Once allocated, users generally use a ::gxio_trio_dma_queue_t
+ * object to manage the queue, providing easy wrappers for reserving
+ * command slots in the DMA command ring, filling those slots, and
+ * waiting for commands to complete.  DMA queues can be initialized
+ * via gxio_trio_init_push_dma_queue() or
+ * gxio_trio_init_pull_dma_queue().
+ *
+ * See @ref trio/push_dma/app.c for an example of how to use push DMA.
+ *
+ * @section trio_shortcomings Plans for Future API Revisions
+ *
+ * The API and simulation framework is incomplete.  Future features
+ * include:
+ *
+ * - Support for larger page sizes.  Each hardware IOTLB can only map
+ * 16 pages at a time, so applications are currently limited to 16 *
+ * 16MB = 256MB of packet memory.  Larger page sizes will allow
+ * applications to map arbitrary amounts of packet memory.
+ *
+ * - Support for reset and deallocation of resources.
+ *
+ * - Support for pull DMA.
+ *
+ * - Support for interrupt regions and user-space interrupt delivery.
+ *
+ * - Support for getting BAR mappings and reserving regions of BAR
+ *   address space.
+ */
+#ifndef _GXIO_TRIO_H_
+#define _GXIO_TRIO_H_
+
+#include "common.h"
+#include "dma_queue.h"
+
+#include <arch/trio_constants.h>
+#include <arch/trio.h>
+#include <arch/trio_pcie_intfc.h>
+#include <arch/trio_pcie_rc.h>
+#include <arch/trio_shm.h>
+#include <hv/drv_trio_intf.h>
+#include <hv/iorpc.h>
+
+/* A context object used to manage TRIO hardware resources. */
+typedef struct {
+
+  /* File descriptor for calling up to Linux (and thus the HV). */
+	int fd;
+
+  /* The VA at which the MAC MMIO registers are mapped. */
+	char *mmio_base_mac;
+
+  /* The VA at which the PIO config space are mapped for each PCIe MAC.
+      Gx36 has max 3 PCIe MACs per TRIO shim. */
+	char *mmio_base_pio_cfg[TILEGX_TRIO_PCIES];
+
+#ifdef USE_SHARED_PCIE_CONFIG_REGION
+  /* Index of the shared PIO region for PCI config access. */
+	int pio_cfg_index;
+#else
+  /* Index of the PIO region for PCI config access per MAC. */
+	int pio_cfg_index[TILEGX_TRIO_PCIES];
+#endif
+
+  /*  The VA at which the push DMA MMIO registers are mapped. */
+	char *mmio_push_dma[TRIO_NUM_PUSH_DMA_RINGS];
+
+  /*  The VA at which the pull DMA MMIO registers are mapped. */
+	char *mmio_pull_dma[TRIO_NUM_PUSH_DMA_RINGS];
+
+  /* Application space ID. */
+	unsigned int asid;
+
+} gxio_trio_context_t;
+
+/* Command descriptor for push or pull DMA. */
+typedef TRIO_DMA_DESC_t gxio_trio_dma_desc_t;
+
+/* A convenient, thread-safe interface to an eDMA ring. */
+typedef struct {
+
+  /* State object for tracking head and tail pointers. */
+	__gxio_dma_queue_t dma_queue;
+
+  /* The ring entries. */
+	gxio_trio_dma_desc_t *dma_descs;
+
+  /* The number of entries minus one. */
+	unsigned long mask_num_entries;
+
+  /* The log2() of the number of entries. */
+	unsigned int log2_num_entries;
+
+} gxio_trio_dma_queue_t;
+
+/* Initialize a TRIO context.
+ *
+ * This function allocates a TRIO "service domain" and maps the MMIO
+ * registers into the the caller's VA space.
+ *
+ * @param trio_index Which TRIO shim; Gx36 must pass 0.
+ * @param context Context object to be initialized.
+ */
+extern int
+gxio_trio_init(gxio_trio_context_t * context, unsigned int trio_index);
+
+/* This indicates that an ASID hasn't been allocated. */
+#define GXIO_ASID_NULL -1
+
+/* Ordering modes for map memory regions and scatter queue regions. */
+typedef enum gxio_trio_order_mode_e {
+  /* Writes are not ordered.  Reads always wait for previous writes. */
+	GXIO_TRIO_ORDER_MODE_UNORDERED =
+	    TRIO_MAP_MEM_SETUP__ORDER_MODE_VAL_UNORDERED,
+  /* Both writes and reads wait for previous transactions to complete. */
+	GXIO_TRIO_ORDER_MODE_STRICT = TRIO_MAP_MEM_SETUP__ORDER_MODE_VAL_STRICT,
+  /* Writes are ordered unless the incoming packet has the
+      relaxed-ordering attributes set. */
+	GXIO_TRIO_ORDER_MODE_OBEY_PACKET =
+	    TRIO_MAP_MEM_SETUP__ORDER_MODE_VAL_REL_ORD
+} gxio_trio_order_mode_t;
+
+/* Initialize a memory mapping region.
+ *
+ * @param context An initialized TRIO context.
+ * @param map A Memory map region allocated by gxio_trio_alloc_memory_map().
+ * @param target_mem VA of backing memory, should be registered via
+ *   gxio_trio_register_page() and aligned to 4kB.
+ * @param target_size Length of the memory mapping, must be a multiple
+ * of 4kB.
+ * @param asid ASID to be used for Tile-side address translation.
+ * @param mac MAC number.
+ * @param bus_address Bus address at which the mapping starts.
+ * @param order_mode Memory ordering mode for this mapping.
+ * @return Zero on success, else ::GXIO_TRIO_ERR_BAD_MEMORY_MAP,
+ * GXIO_TRIO_ERR_BAD_ASID, or ::GXIO_TRIO_ERR_BAD_BUS_RANGE.
+ */
+extern int
+gxio_trio_init_memory_map(gxio_trio_context_t * context, unsigned int map,
+			  void *target_mem, size_t target_size,
+			  unsigned int asid,
+			  unsigned int mac,
+			  uint64_t bus_address,
+			  gxio_trio_order_mode_t order_mode);
+
+/* Flags that can be passed to resource allocation functions. */
+enum gxio_trio_alloc_flags_e {
+	GXIO_TRIO_ALLOC_FIXED = HV_TRIO_ALLOC_FIXED,
+};
+
+/* Flags that can be passed to memory registration functions. */
+enum gxio_trio_mem_flags_e {
+  /* Do not fill L3 when writing, and invalidate lines upon egress. */
+	GXIO_TRIO_MEM_FLAG_NT_HINT = IORPC_MEM_BUFFER_FLAG_NT_HINT,
+
+  /* L3 cache fills should only populate IO cache ways. */
+	GXIO_TRIO_MEM_FLAG_IO_PIN = IORPC_MEM_BUFFER_FLAG_IO_PIN,
+};
+
+/* Flag indicating a request generator uses a special traffic
+    class. */
+#define GXIO_TRIO_FLAG_TRAFFIC_CLASS(N) HV_TRIO_FLAG_TC(N)
+
+/* Flag indicating a request generator uses a virtual function
+    number. */
+#define GXIO_TRIO_FLAG_VFUNC(N) HV_TRIO_FLAG_VFUNC(N)
+
+/*****************************************************************
+ *                       Memory Registration                      *
+ ******************************************************************/
+
+/* Allocate Application Space Identifiers (ASIDs).  Each ASID can
+ * register up to 16 page translations.  ASIDs are used by memory map
+ * regions, scatter queues, and DMA queues to translate application
+ * VAs into memory system PAs.
+ *
+ * @param context An initialized TRIO context.
+ * @param count Number of ASIDs required.
+ * @param first Index of first ASID if ::GXIO_TRIO_ALLOC_FIXED flag
+ *   is set, otherwise ignored.
+ * @param flags Flag bits, including bits from ::gxio_trio_alloc_flags_e.
+ * @return Index of first ASID, or ::GXIO_TRIO_ERR_NO_ASID if allocation
+ *   failed.
+ */
+extern int
+gxio_trio_alloc_asids(gxio_trio_context_t * context, unsigned int count,
+		      unsigned int first, unsigned int flags);
+
+#endif /* ! _GXIO_TRIO_H_ */
diff --git a/arch/tile/include/hv/drv_trio_intf.h b/arch/tile/include/hv/drv_trio_intf.h
new file mode 100644
index 0000000..18e8704
--- /dev/null
+++ b/arch/tile/include/hv/drv_trio_intf.h
@@ -0,0 +1,196 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/**
+ * Interface definitions for the trio driver.
+ */
+
+#ifndef _SYS_HV_DRV_TRIO_INTF_H
+#define _SYS_HV_DRV_TRIO_INTF_H
+
+#include <arch/trio.h>
+
+/** The vendor ID for all Tilera processors. */
+#define TILERA_VENDOR_ID 0x1a41
+
+/** The device ID for the Gx36 processor. */
+#define TILERA_GX36_DEV_ID 0x0200
+
+/** Device ID for our internal bridge when running as RC. */
+#define TILERA_GX36_RC_DEV_ID 0x2000
+
+/** Maximum number of TRIO interfaces. */
+#define TILEGX_NUM_TRIO         2
+
+/** Gx36 has max 3 PCIe MACs per TRIO interface. */
+#define TILEGX_TRIO_PCIES       3
+
+/** Specify port properties for a PCIe MAC. */
+struct pcie_port_property
+{
+  /** If true, the link can be configured in PCIe root complex mode. */
+  uint8_t allow_rc: 1;
+
+  /** If true, the link can be configured in PCIe endpoint mode. */
+  uint8_t allow_ep: 1;
+
+  /** If true, the link can be configured in StreamIO mode. */
+  uint8_t allow_sio: 1;
+
+  /** If true, the link is allowed to support 1-lane operation. Software
+   *  will not consider it an error if the link comes up as a x1 link. */
+  uint8_t allow_x1: 1;
+
+  /** If true, the link is allowed to support 2-lane operation. Software
+   *  will not consider it an error if the link comes up as a x2 link. */
+  uint8_t allow_x2: 1;
+
+  /** If true, the link is allowed to support 4-lane operation. Software
+   *  will not consider it an error if the link comes up as a x4 link. */
+  uint8_t allow_x4: 1;
+
+  /** If true, the link is allowed to support 8-lane operation. Software
+   *  will not consider it an error if the link comes up as a x8 link. */
+  uint8_t allow_x8: 1;
+
+  /** Reserved. */
+  uint8_t reserved: 1;
+
+};
+
+/** Configurations can be issued to configure a char stream interrupt. */
+typedef enum pcie_stream_intr_config_sel_e
+{
+  /** Interrupt configuration for memory map regions. */
+  MEM_MAP_SEL,
+
+  /** Interrupt configuration for push DMAs. */
+  PUSH_DMA_SEL,
+
+  /** Interrupt configuration for pull DMAs. */
+  PULL_DMA_SEL,
+}
+pcie_stream_intr_config_sel_t;
+
+
+/** The mmap file offset (PA) of the TRIO config region. */
+#define HV_TRIO_CONFIG_OFFSET                                        \
+  ((unsigned long long)TRIO_MMIO_ADDRESS_SPACE__REGION_VAL_CFG <<   \
+    TRIO_MMIO_ADDRESS_SPACE__REGION_SHIFT)
+
+/** The maximum size of the TRIO config region. */
+#define HV_TRIO_CONFIG_SIZE                                 \
+  (1ULL << TRIO_CFG_REGION_ADDR__REGION_SHIFT)
+
+/** Size of the config region mapped into client. We can't use
+ *  TRIO_MMIO_ADDRESS_SPACE__OFFSET_WIDTH because it
+ *  will require the kernel to allocate 4GB VA space
+ *  from the VMALLOC region which has a total range
+ *  of 4GB.
+ */
+#define HV_TRIO_CONFIG_IOREMAP_SIZE                            \
+  ((uint64_t) 1 << TRIO_CFG_REGION_ADDR__PROT_SHIFT)
+
+/** The mmap file offset (PA) of a scatter queue region. */
+#define HV_TRIO_SQ_OFFSET(queue)                                        \
+  (((unsigned long long)TRIO_MMIO_ADDRESS_SPACE__REGION_VAL_MAP_SQ <<   \
+    TRIO_MMIO_ADDRESS_SPACE__REGION_SHIFT) |                            \
+   ((queue) << TRIO_MAP_SQ_REGION_ADDR__SQ_SEL_SHIFT))
+
+/** The maximum size of a scatter queue region. */
+#define HV_TRIO_SQ_SIZE                                 \
+  (1ULL << TRIO_MAP_SQ_REGION_ADDR__SQ_SEL_SHIFT)
+
+
+/** The "hardware MMIO region" of the first PIO region. */
+#define HV_TRIO_FIRST_PIO_REGION 8
+
+/** The mmap file offset (PA) of a PIO region. */
+#define HV_TRIO_PIO_OFFSET(region)                           \
+  (((unsigned long long)(region) + HV_TRIO_FIRST_PIO_REGION) \
+   << TRIO_PIO_REGIONS_ADDR__REGION_SHIFT)
+
+/** The maximum size of a PIO region. */
+#define HV_TRIO_PIO_SIZE (1ULL << TRIO_PIO_REGIONS_ADDR__ADDR_WIDTH)
+
+
+/** The mmap file offset (PA) of a push DMA region. */
+#define HV_TRIO_PUSH_DMA_OFFSET(ring)                                   \
+  (((unsigned long long)TRIO_MMIO_ADDRESS_SPACE__REGION_VAL_PUSH_DMA << \
+    TRIO_MMIO_ADDRESS_SPACE__REGION_SHIFT) |                            \
+   ((ring) << TRIO_PUSH_DMA_REGION_ADDR__RING_SEL_SHIFT))
+
+/** The mmap file offset (PA) of a pull DMA region. */
+#define HV_TRIO_PULL_DMA_OFFSET(ring)                                   \
+  (((unsigned long long)TRIO_MMIO_ADDRESS_SPACE__REGION_VAL_PULL_DMA << \
+    TRIO_MMIO_ADDRESS_SPACE__REGION_SHIFT) |                            \
+   ((ring) << TRIO_PULL_DMA_REGION_ADDR__RING_SEL_SHIFT))
+
+/** The maximum size of a DMA region. */
+#define HV_TRIO_DMA_REGION_SIZE                         \
+  (1ULL << TRIO_PUSH_DMA_REGION_ADDR__RING_SEL_SHIFT)
+
+
+/** The mmap file offset (PA) of a Mem-Map interrupt region. */
+#define HV_TRIO_MEM_MAP_INTR_OFFSET(map)                                 \
+  (((unsigned long long)TRIO_MMIO_ADDRESS_SPACE__REGION_VAL_MAP_MEM <<   \
+    TRIO_MMIO_ADDRESS_SPACE__REGION_SHIFT) |                            \
+   ((map) << TRIO_MAP_MEM_REGION_ADDR__MAP_SEL_SHIFT))
+
+/** The maximum size of a Mem-Map interrupt region. */
+#define HV_TRIO_MEM_MAP_INTR_SIZE                                 \
+  (1ULL << TRIO_MAP_MEM_REGION_ADDR__MAP_SEL_SHIFT)
+
+
+/** A flag bit indicating a fixed resource allocation. */
+#define HV_TRIO_ALLOC_FIXED 0x01
+
+/** TRIO requires that all mappings have 4kB aligned start addresses. */
+#define HV_TRIO_PAGE_SHIFT 12
+
+/** TRIO requires that all mappings have 4kB aligned start addresses. */
+#define HV_TRIO_PAGE_SIZE (1ull << HV_TRIO_PAGE_SHIFT)
+
+
+
+/* Specify all PCIe port properties for a TRIO. */
+struct pcie_trio_ports_property
+{
+  struct pcie_port_property ports[TILEGX_TRIO_PCIES];
+};
+
+/* Flags indicating traffic class. */
+#define HV_TRIO_FLAG_TC_SHIFT 4
+#define HV_TRIO_FLAG_TC_RMASK 0xf
+#define HV_TRIO_FLAG_TC(N) \
+  ((((N) & HV_TRIO_FLAG_TC_RMASK) + 1) << HV_TRIO_FLAG_TC_SHIFT)
+
+/* Flags indicating virtual functions. */
+#define HV_TRIO_FLAG_VFUNC_SHIFT 8
+#define HV_TRIO_FLAG_VFUNC_RMASK 0xff
+#define HV_TRIO_FLAG_VFUNC(N) \
+  ((((N) & HV_TRIO_FLAG_VFUNC_RMASK) + 1) << HV_TRIO_FLAG_VFUNC_SHIFT)
+
+
+/* Flag indicating an ordered PIO region. */
+#define HV_TRIO_PIO_FLAG_ORDERED (1 << 16)
+
+/* Flags indicating special types of PIO regions. */
+#define HV_TRIO_PIO_FLAG_SPACE_SHIFT 17
+#define HV_TRIO_PIO_FLAG_SPACE_MASK (0x3 << HV_TRIO_PIO_FLAG_SPACE_SHIFT)
+#define HV_TRIO_PIO_FLAG_CONFIG_SPACE (0x1 << HV_TRIO_PIO_FLAG_SPACE_SHIFT)
+#define HV_TRIO_PIO_FLAG_IO_SPACE (0x2 << HV_TRIO_PIO_FLAG_SPACE_SHIFT)
+
+
+#endif /* _SYS_HV_DRV_TRIO_INTF_H */
-- 
1.6.5.2

