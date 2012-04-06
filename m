Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab2DFVCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:02:14 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:53688 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116Ab2DFVCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:02:08 -0400
Message-Id: <201204062101.q36L1uIJ011405@farm-0027.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 6 Apr 2012 16:38:03 -0400
Subject: [PATCH 5/6] arch/tile: provide kernel support for the tilegx mPIPE shim
To: linux-kernel@vger.kernel.org
In-Reply-To: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com>
References: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com>
X-OriginalArrivalTime: 06 Apr 2012 21:01:56.0401 (UTC) FILETIME=[80216A10:01CD1438]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TILE-Gx chip includes a packet-processing network engine called
mPIPE ("Multicore Programmable Intelligent Packet Engine").  This
change adds support for using the mPIPE engine from within the
kernel.  The engine has more functionality than is exposed here,
but to keep the kernel code and binary simpler, this is a subset
of the full API designed to enable standard Linux networking only.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/gxio/Kconfig                    |    9 +
 arch/tile/gxio/Makefile                   |    1 +
 arch/tile/gxio/iorpc_mpipe.c              |  571 +++++++++
 arch/tile/gxio/iorpc_mpipe_info.c         |   95 ++
 arch/tile/gxio/mpipe.c                    |  631 +++++++++
 arch/tile/include/arch/mpipe.h            |  321 +++++
 arch/tile/include/arch/mpipe_constants.h  |   43 +
 arch/tile/include/arch/mpipe_def.h        |   39 +
 arch/tile/include/arch/mpipe_shm.h        |  421 ++++++
 arch/tile/include/arch/mpipe_shm_def.h    |   23 +
 arch/tile/include/gxio/iorpc_mpipe.h      |  124 ++
 arch/tile/include/gxio/iorpc_mpipe_info.h |   46 +
 arch/tile/include/gxio/mpipe.h            | 1986 +++++++++++++++++++++++++++++
 arch/tile/include/hv/drv_mpipe_intf.h     |  602 +++++++++
 14 files changed, 4912 insertions(+), 0 deletions(-)
 create mode 100644 arch/tile/gxio/iorpc_mpipe.c
 create mode 100644 arch/tile/gxio/iorpc_mpipe_info.c
 create mode 100644 arch/tile/gxio/mpipe.c
 create mode 100644 arch/tile/include/arch/mpipe.h
 create mode 100644 arch/tile/include/arch/mpipe_constants.h
 create mode 100644 arch/tile/include/arch/mpipe_def.h
 create mode 100644 arch/tile/include/arch/mpipe_shm.h
 create mode 100644 arch/tile/include/arch/mpipe_shm_def.h
 create mode 100644 arch/tile/include/gxio/iorpc_mpipe.h
 create mode 100644 arch/tile/include/gxio/iorpc_mpipe_info.h
 create mode 100644 arch/tile/include/gxio/mpipe.h
 create mode 100644 arch/tile/include/hv/drv_mpipe_intf.h

diff --git a/arch/tile/gxio/Kconfig b/arch/tile/gxio/Kconfig
index b5cd898..ec20e8c 100644
--- a/arch/tile/gxio/Kconfig
+++ b/arch/tile/gxio/Kconfig
@@ -14,3 +14,12 @@ config TILE_GXIO_DMA
 	  within the TILE-Gx mPIPE and Trio hardware.  It is not required
 	  in order to use the gxio library to access mPIPE or Trio from
 	  user space.
+
+config TILE_GXIO_MPIPE
+	bool "Tilera Gx mPIPE I/O support"
+	select TILE_GXIO
+	select TILE_GXIO_DMA
+	---help---
+	  This option supports direct access to the TILE-Gx mPIPE hardware
+	  from kernel space.  It is not required in order to use the gxio
+	  library to access mPIPE from user space.
diff --git a/arch/tile/gxio/Makefile b/arch/tile/gxio/Makefile
index 97ab468..130eec4 100644
--- a/arch/tile/gxio/Makefile
+++ b/arch/tile/gxio/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_TILE_GXIO) += iorpc_globals.o kiorpc.o
 obj-$(CONFIG_TILE_GXIO_DMA) += dma_queue.o
+obj-$(CONFIG_TILE_GXIO_MPIPE) += mpipe.o iorpc_mpipe.o iorpc_mpipe_info.o
diff --git a/arch/tile/gxio/iorpc_mpipe.c b/arch/tile/gxio/iorpc_mpipe.c
new file mode 100644
index 0000000..da43e62
--- /dev/null
+++ b/arch/tile/gxio/iorpc_mpipe.c
@@ -0,0 +1,571 @@
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
+#include "gxio/iorpc_mpipe.h"
+
+typedef struct {
+	unsigned int count;
+	unsigned int first;
+	unsigned int flags;
+} alloc_buffer_stacks_param_t;
+
+int gxio_mpipe_alloc_buffer_stacks(gxio_mpipe_context_t * context,
+				   unsigned int count, unsigned int first,
+				   unsigned int flags)
+{
+	uint64_t __offset;
+	int __result;
+	alloc_buffer_stacks_param_t temp;
+	alloc_buffer_stacks_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->count = count;
+	params->first = first;
+	params->flags = flags;
+
+	__offset = GXIO_MPIPE_OP_ALLOC_BUFFER_STACKS;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_alloc_buffer_stacks);
+
+typedef struct {
+	iorpc_mem_buffer_t buffer;
+	unsigned int stack;
+	unsigned int buffer_size_enum;
+} init_buffer_stack_aux_param_t;
+
+int gxio_mpipe_init_buffer_stack_aux(gxio_mpipe_context_t * context,
+				     void *mem_va, size_t mem_size,
+				     unsigned int mem_flags, unsigned int stack,
+				     unsigned int buffer_size_enum)
+{
+	uint64_t __offset;
+	int __result;
+	unsigned long long __cpa;
+	pte_t __pte;
+	init_buffer_stack_aux_param_t temp;
+	init_buffer_stack_aux_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	__result = va_to_cpa_and_pte(mem_va, &__cpa, &__pte);
+	if (__result != 0)
+		return __result;
+	params->buffer.kernel.cpa = __cpa;
+	params->buffer.kernel.size = mem_size;
+	params->buffer.kernel.pte = __pte;
+	params->buffer.kernel.flags = mem_flags;
+	params->stack = stack;
+	params->buffer_size_enum = buffer_size_enum;
+
+	__offset = GXIO_MPIPE_OP_INIT_BUFFER_STACK_AUX;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_init_buffer_stack_aux);
+
+
+typedef struct {
+	unsigned int count;
+	unsigned int first;
+	unsigned int flags;
+} alloc_notif_rings_param_t;
+
+int gxio_mpipe_alloc_notif_rings(gxio_mpipe_context_t * context,
+				 unsigned int count, unsigned int first,
+				 unsigned int flags)
+{
+	uint64_t __offset;
+	int __result;
+	alloc_notif_rings_param_t temp;
+	alloc_notif_rings_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->count = count;
+	params->first = first;
+	params->flags = flags;
+
+	__offset = GXIO_MPIPE_OP_ALLOC_NOTIF_RINGS;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_alloc_notif_rings);
+
+typedef struct {
+	iorpc_mem_buffer_t buffer;
+	unsigned int ring;
+} init_notif_ring_aux_param_t;
+
+int gxio_mpipe_init_notif_ring_aux(gxio_mpipe_context_t * context, void *mem_va,
+				   size_t mem_size, unsigned int mem_flags,
+				   unsigned int ring)
+{
+	uint64_t __offset;
+	int __result;
+	unsigned long long __cpa;
+	pte_t __pte;
+	init_notif_ring_aux_param_t temp;
+	init_notif_ring_aux_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	__result = va_to_cpa_and_pte(mem_va, &__cpa, &__pte);
+	if (__result != 0)
+		return __result;
+	params->buffer.kernel.cpa = __cpa;
+	params->buffer.kernel.size = mem_size;
+	params->buffer.kernel.pte = __pte;
+	params->buffer.kernel.flags = mem_flags;
+	params->ring = ring;
+
+	__offset = GXIO_MPIPE_OP_INIT_NOTIF_RING_AUX;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_init_notif_ring_aux);
+
+typedef struct {
+	iorpc_interrupt_t interrupt;
+	unsigned int ring;
+} request_notif_ring_interrupt_param_t;
+
+int gxio_mpipe_request_notif_ring_interrupt(gxio_mpipe_context_t * context,
+					    int inter_x, int inter_y,
+					    int inter_ipi, int inter_event,
+					    unsigned int ring)
+{
+	uint64_t __offset;
+	int __result;
+	request_notif_ring_interrupt_param_t temp;
+	request_notif_ring_interrupt_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->interrupt.kernel.x = inter_x;
+	params->interrupt.kernel.y = inter_y;
+	params->interrupt.kernel.ipi = inter_ipi;
+	params->interrupt.kernel.event = inter_event;
+	params->ring = ring;
+
+	__offset = GXIO_MPIPE_OP_REQUEST_NOTIF_RING_INTERRUPT;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_request_notif_ring_interrupt);
+
+typedef struct {
+	unsigned int ring;
+} enable_notif_ring_interrupt_param_t;
+
+int gxio_mpipe_enable_notif_ring_interrupt(gxio_mpipe_context_t * context,
+					   unsigned int ring)
+{
+	uint64_t __offset;
+	int __result;
+	enable_notif_ring_interrupt_param_t temp;
+	enable_notif_ring_interrupt_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->ring = ring;
+
+	__offset = GXIO_MPIPE_OP_ENABLE_NOTIF_RING_INTERRUPT;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_enable_notif_ring_interrupt);
+
+typedef struct {
+	unsigned int count;
+	unsigned int first;
+	unsigned int flags;
+} alloc_notif_groups_param_t;
+
+int gxio_mpipe_alloc_notif_groups(gxio_mpipe_context_t * context,
+				  unsigned int count, unsigned int first,
+				  unsigned int flags)
+{
+	uint64_t __offset;
+	int __result;
+	alloc_notif_groups_param_t temp;
+	alloc_notif_groups_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->count = count;
+	params->first = first;
+	params->flags = flags;
+
+	__offset = GXIO_MPIPE_OP_ALLOC_NOTIF_GROUPS;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_alloc_notif_groups);
+
+typedef struct {
+	unsigned int group;
+	gxio_mpipe_notif_group_bits_t bits;
+} init_notif_group_param_t;
+
+int gxio_mpipe_init_notif_group(gxio_mpipe_context_t * context,
+				unsigned int group,
+				gxio_mpipe_notif_group_bits_t bits)
+{
+	uint64_t __offset;
+	int __result;
+	init_notif_group_param_t temp;
+	init_notif_group_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->group = group;
+	params->bits = bits;
+
+	__offset = GXIO_MPIPE_OP_INIT_NOTIF_GROUP;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_init_notif_group);
+
+typedef struct {
+	unsigned int count;
+	unsigned int first;
+	unsigned int flags;
+} alloc_buckets_param_t;
+
+int gxio_mpipe_alloc_buckets(gxio_mpipe_context_t * context, unsigned int count,
+			     unsigned int first, unsigned int flags)
+{
+	uint64_t __offset;
+	int __result;
+	alloc_buckets_param_t temp;
+	alloc_buckets_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->count = count;
+	params->first = first;
+	params->flags = flags;
+
+	__offset = GXIO_MPIPE_OP_ALLOC_BUCKETS;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_alloc_buckets);
+
+typedef struct {
+	unsigned int bucket;
+	MPIPE_LBL_INIT_DAT_BSTS_TBL_t bucket_info;
+} init_bucket_param_t;
+
+int gxio_mpipe_init_bucket(gxio_mpipe_context_t * context, unsigned int bucket,
+			   MPIPE_LBL_INIT_DAT_BSTS_TBL_t bucket_info)
+{
+	uint64_t __offset;
+	int __result;
+	init_bucket_param_t temp;
+	init_bucket_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->bucket = bucket;
+	params->bucket_info = bucket_info;
+
+	__offset = GXIO_MPIPE_OP_INIT_BUCKET;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_init_bucket);
+
+typedef struct {
+	unsigned int count;
+	unsigned int first;
+	unsigned int flags;
+} alloc_edma_rings_param_t;
+
+int gxio_mpipe_alloc_edma_rings(gxio_mpipe_context_t * context,
+				unsigned int count, unsigned int first,
+				unsigned int flags)
+{
+	uint64_t __offset;
+	int __result;
+	alloc_edma_rings_param_t temp;
+	alloc_edma_rings_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->count = count;
+	params->first = first;
+	params->flags = flags;
+
+	__offset = GXIO_MPIPE_OP_ALLOC_EDMA_RINGS;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_alloc_edma_rings);
+
+typedef struct {
+	iorpc_mem_buffer_t buffer;
+	unsigned int ring;
+	unsigned int channel;
+} init_edma_ring_aux_param_t;
+
+int gxio_mpipe_init_edma_ring_aux(gxio_mpipe_context_t * context, void *mem_va,
+				  size_t mem_size, unsigned int mem_flags,
+				  unsigned int ring, unsigned int channel)
+{
+	uint64_t __offset;
+	int __result;
+	unsigned long long __cpa;
+	pte_t __pte;
+	init_edma_ring_aux_param_t temp;
+	init_edma_ring_aux_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	__result = va_to_cpa_and_pte(mem_va, &__cpa, &__pte);
+	if (__result != 0)
+		return __result;
+	params->buffer.kernel.cpa = __cpa;
+	params->buffer.kernel.size = mem_size;
+	params->buffer.kernel.pte = __pte;
+	params->buffer.kernel.flags = mem_flags;
+	params->ring = ring;
+	params->channel = channel;
+
+	__offset = GXIO_MPIPE_OP_INIT_EDMA_RING_AUX;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_init_edma_ring_aux);
+
+
+int gxio_mpipe_commit_rules(gxio_mpipe_context_t * context, const void *blob,
+			    size_t blob_size)
+{
+	uint64_t __offset;
+	int __result;
+	size_t __size = blob_size;
+	const void *params = blob;
+
+	__offset = GXIO_MPIPE_OP_COMMIT_RULES;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_commit_rules);
+
+typedef struct {
+	unsigned int iotlb;
+	HV_PTE pte;
+	unsigned int flags;
+} register_client_memory_param_t;
+
+int gxio_mpipe_register_client_memory(gxio_mpipe_context_t * context,
+				      unsigned int iotlb, HV_PTE pte,
+				      unsigned int flags)
+{
+	uint64_t __offset;
+	int __result;
+	register_client_memory_param_t temp;
+	register_client_memory_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->iotlb = iotlb;
+	params->pte = pte;
+	params->flags = flags;
+
+	__offset = GXIO_MPIPE_OP_REGISTER_CLIENT_MEMORY;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_register_client_memory);
+
+typedef struct {
+	_gxio_mpipe_link_name_t name;
+	unsigned int flags;
+} link_open_aux_param_t;
+
+int gxio_mpipe_link_open_aux(gxio_mpipe_context_t * context,
+			     _gxio_mpipe_link_name_t name, unsigned int flags)
+{
+	uint64_t __offset;
+	int __result;
+	link_open_aux_param_t temp;
+	link_open_aux_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->name = name;
+	params->flags = flags;
+
+	__offset = GXIO_MPIPE_OP_LINK_OPEN_AUX;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_link_open_aux);
+
+typedef struct {
+	int mac;
+} link_close_aux_param_t;
+
+int gxio_mpipe_link_close_aux(gxio_mpipe_context_t * context, int mac)
+{
+	uint64_t __offset;
+	int __result;
+	link_close_aux_param_t temp;
+	link_close_aux_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->mac = mac;
+
+	__offset = GXIO_MPIPE_OP_LINK_CLOSE_AUX;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_link_close_aux);
+
+
+typedef struct {
+	iorpc_pollfd_t pollfd;
+} arm_pollfd_param_t;
+
+int gxio_mpipe_arm_pollfd(gxio_mpipe_context_t * context, int pollfd_cookie)
+{
+	uint64_t __offset;
+	int __result;
+	arm_pollfd_param_t temp;
+	arm_pollfd_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->pollfd.kernel.cookie = pollfd_cookie;
+
+	__offset = GXIO_MPIPE_OP_ARM_POLLFD;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_arm_pollfd);
+
+typedef struct {
+	iorpc_pollfd_t pollfd;
+} close_pollfd_param_t;
+
+int gxio_mpipe_close_pollfd(gxio_mpipe_context_t * context, int pollfd_cookie)
+{
+	uint64_t __offset;
+	int __result;
+	close_pollfd_param_t temp;
+	close_pollfd_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	params->pollfd.kernel.cookie = pollfd_cookie;
+
+	__offset = GXIO_MPIPE_OP_CLOSE_POLLFD;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_close_pollfd);
+
+typedef struct {
+	HV_PTE base;
+} get_mmio_base_param_t;
+
+int gxio_mpipe_get_mmio_base(gxio_mpipe_context_t * context, HV_PTE *base)
+{
+	uint64_t __offset;
+	int __result;
+	get_mmio_base_param_t temp;
+	get_mmio_base_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	__offset = GXIO_MPIPE_OP_GET_MMIO_BASE;
+	__result =
+	    hv_dev_pread(context->fd, 0, (HV_VirtAddr) params, __size,
+			 __offset);
+	*base = params->base;
+
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_get_mmio_base);
+
+typedef struct {
+	unsigned long offset;
+	unsigned long size;
+} check_mmio_offset_param_t;
+
+int gxio_mpipe_check_mmio_offset(gxio_mpipe_context_t * context,
+				 unsigned long offset, unsigned long size)
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
+	__offset = GXIO_MPIPE_OP_CHECK_MMIO_OFFSET;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_check_mmio_offset);
diff --git a/arch/tile/gxio/iorpc_mpipe_info.c b/arch/tile/gxio/iorpc_mpipe_info.c
new file mode 100644
index 0000000..d3fe0c8
--- /dev/null
+++ b/arch/tile/gxio/iorpc_mpipe_info.c
@@ -0,0 +1,95 @@
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
+#include "gxio/iorpc_mpipe_info.h"
+
+
+typedef struct {
+	_gxio_mpipe_link_name_t name;
+	_gxio_mpipe_link_mac_t mac;
+} enumerate_aux_param_t;
+
+int gxio_mpipe_info_enumerate_aux(gxio_mpipe_info_context_t * context,
+				  unsigned int idx,
+				  _gxio_mpipe_link_name_t * name,
+				  _gxio_mpipe_link_mac_t * mac)
+{
+	uint64_t __offset;
+	int __result;
+	enumerate_aux_param_t temp;
+	enumerate_aux_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	__offset = (((uint64_t) idx << 32) | GXIO_MPIPE_INFO_OP_ENUMERATE_AUX);
+	__result =
+	    hv_dev_pread(context->fd, 0, (HV_VirtAddr) params, __size,
+			 __offset);
+	*name = params->name;
+	*mac = params->mac;
+
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_info_enumerate_aux);
+
+typedef struct {
+	HV_PTE base;
+} get_mmio_base_param_t;
+
+int gxio_mpipe_info_get_mmio_base(gxio_mpipe_info_context_t * context,
+				  HV_PTE *base)
+{
+	uint64_t __offset;
+	int __result;
+	get_mmio_base_param_t temp;
+	get_mmio_base_param_t *params = &temp;
+	size_t __size = sizeof(*params);
+
+	__offset = GXIO_MPIPE_INFO_OP_GET_MMIO_BASE;
+	__result =
+	    hv_dev_pread(context->fd, 0, (HV_VirtAddr) params, __size,
+			 __offset);
+	*base = params->base;
+
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_info_get_mmio_base);
+
+typedef struct {
+	unsigned long offset;
+	unsigned long size;
+} check_mmio_offset_param_t;
+
+int gxio_mpipe_info_check_mmio_offset(gxio_mpipe_info_context_t * context,
+				      unsigned long offset, unsigned long size)
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
+	__offset = GXIO_MPIPE_INFO_OP_CHECK_MMIO_OFFSET;
+	__result =
+	    hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params, __size,
+			  __offset);
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_mpipe_info_check_mmio_offset);
diff --git a/arch/tile/gxio/mpipe.c b/arch/tile/gxio/mpipe.c
new file mode 100644
index 0000000..524bfd1
--- /dev/null
+++ b/arch/tile/gxio/mpipe.c
@@ -0,0 +1,631 @@
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
+/*
+ * Implementation of mpipe gxio calls.
+ */
+
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/module.h>
+
+#include <gxio/iorpc_globals.h>
+#include <gxio/iorpc_mpipe.h>
+#include <gxio/iorpc_mpipe_info.h>
+#include <gxio/kiorpc.h>
+#include <gxio/mpipe.h>
+
+/* HACK: Avoid pointless "shadow" warnings. */
+#define link link_shadow
+
+int gxio_mpipe_init(gxio_mpipe_context_t * context, unsigned int mpipe_index)
+{
+	char file[32];
+
+	int fd;
+	int i;
+
+	snprintf(file, sizeof(file), "mpipe/%d/iorpc", mpipe_index);
+	fd = hv_dev_open((HV_VirtAddr) file, 0);
+	if (fd < 0) {
+		if (fd >= GXIO_ERR_MIN && fd <= GXIO_ERR_MAX)
+			return fd;
+		else
+			return -ENODEV;
+	}
+
+	context->fd = fd;
+
+	/* Map in the MMIO space. */
+	context->mmio_cfg_base = (void __force *)
+	    iorpc_ioremap(fd, HV_MPIPE_CONFIG_MMIO_OFFSET,
+			  HV_MPIPE_CONFIG_MMIO_SIZE);
+	if (context->mmio_cfg_base == NULL)
+		goto cfg_failed;
+
+	context->mmio_fast_base = (void __force *)
+	    iorpc_ioremap(fd, HV_MPIPE_FAST_MMIO_OFFSET,
+			  HV_MPIPE_FAST_MMIO_SIZE);
+	if (context->mmio_fast_base == NULL)
+		goto fast_failed;
+
+	/* Initialize the stacks. */
+	for (i = 0; i < 8; i++)
+		context->__stacks.stacks[i] = 255;
+
+	return 0;
+
+      fast_failed:
+	iounmap((void __force __iomem *)(context->mmio_cfg_base));
+      cfg_failed:
+	hv_dev_close(context->fd);
+	return -ENODEV;
+}
+
+static int16_t gxio_mpipe_buffer_sizes[8] =
+    { 128, 256, 512, 1024, 1664, 4096, 10368, 16384 };
+
+gxio_mpipe_buffer_size_enum_t
+gxio_mpipe_buffer_size_to_buffer_size_enum(size_t size)
+{
+	int i;
+	for (i = 0; i < 7; i++)
+		if (size <= gxio_mpipe_buffer_sizes[i])
+			break;
+	return i;
+}
+
+size_t
+gxio_mpipe_buffer_size_enum_to_buffer_size(gxio_mpipe_buffer_size_enum_t
+					   buffer_size_enum)
+{
+	if (buffer_size_enum > 7)
+		buffer_size_enum = 7;
+
+	return gxio_mpipe_buffer_sizes[buffer_size_enum];
+}
+
+size_t gxio_mpipe_calc_buffer_stack_bytes(unsigned long buffers)
+{
+	const int BUFFERS_PER_LINE = 12;
+
+	/* Count the number of cachlines. */
+	unsigned long lines =
+	    (buffers + BUFFERS_PER_LINE - 1) / BUFFERS_PER_LINE;
+
+	/* Convert to bytes. */
+	return lines * CHIP_L2_LINE_SIZE();
+}
+
+int
+gxio_mpipe_init_buffer_stack(gxio_mpipe_context_t * context,
+			     unsigned int stack,
+			     gxio_mpipe_buffer_size_enum_t buffer_size_enum,
+			     void *mem, size_t mem_size, unsigned int mem_flags)
+{
+	int result;
+
+	memset(mem, 0, mem_size);
+
+	result =
+	    gxio_mpipe_init_buffer_stack_aux(context, mem, mem_size, mem_flags,
+					     stack, buffer_size_enum);
+	if (result < 0)
+		return result;
+
+	/* Save the stack. */
+	context->__stacks.stacks[buffer_size_enum] = stack;
+
+	return 0;
+}
+
+int
+gxio_mpipe_init_notif_ring(gxio_mpipe_context_t * context,
+			   unsigned int ring,
+			   void *mem, size_t mem_size, unsigned int mem_flags)
+{
+	return gxio_mpipe_init_notif_ring_aux(context, mem, mem_size, mem_flags,
+					      ring);
+}
+
+int
+gxio_mpipe_init_notif_group_and_buckets(gxio_mpipe_context_t * context,
+					unsigned int group,
+					unsigned int ring,
+					unsigned int num_rings,
+					unsigned int bucket,
+					unsigned int num_buckets,
+					gxio_mpipe_bucket_mode_t mode)
+{
+	int i;
+	int result;
+
+	/* ISSUE: Use "gxio_mpipe_bucket_info_t"? */
+	MPIPE_LBL_INIT_DAT_BSTS_TBL_t bucket_info = { {
+						       .group = group,
+						       .mode = mode,
+						       }
+	};
+
+	gxio_mpipe_notif_group_bits_t bits = { {0} };
+
+	for (i = 0; i < num_rings; i++)
+		gxio_mpipe_notif_group_add_ring(&bits, ring + i);
+
+	result = gxio_mpipe_init_notif_group(context, group, bits);
+	if (result != 0)
+		return result;
+
+	for (i = 0; i < num_buckets; i++) {
+		bucket_info.notifring = ring + (i % num_rings);
+
+		result =
+		    gxio_mpipe_init_bucket(context, bucket + i, bucket_info);
+		if (result != 0)
+			return result;
+	}
+
+	return 0;
+}
+
+int
+gxio_mpipe_init_edma_ring(gxio_mpipe_context_t * context,
+			  unsigned int ring, unsigned int channel,
+			  void *mem, size_t mem_size, unsigned int mem_flags)
+{
+	memset(mem, 0, mem_size);
+
+	return gxio_mpipe_init_edma_ring_aux(context, mem, mem_size, mem_flags,
+					     ring, channel);
+}
+
+void
+gxio_mpipe_rules_init(gxio_mpipe_rules_t * rules,
+		      gxio_mpipe_context_t * context)
+{
+	rules->context = context;
+	memset(&rules->list, 0, sizeof(rules->list));
+}
+
+int
+gxio_mpipe_rules_begin(gxio_mpipe_rules_t * rules,
+		       unsigned int bucket, unsigned int num_buckets,
+		       gxio_mpipe_rules_stacks_t * stacks)
+{
+	int i;
+	int stack = 255;
+
+	gxio_mpipe_rules_list_t *list = &rules->list;
+
+	/* Current rule. */
+	gxio_mpipe_rules_rule_t *rule =
+	    (gxio_mpipe_rules_rule_t *) (list->rules + list->head);
+
+	unsigned int head = list->tail;
+
+	/*
+	 * Align next rule properly.
+	 *Note that "dmacs_and_vlans" will also be aligned.
+	 */
+	unsigned int pad = 0;
+	while (((head + pad) % __alignof__(gxio_mpipe_rules_rule_t)) != 0)
+		pad++;
+
+	/*
+	 * Verify room.
+	 * ISSUE: Mark rules as broken on error?
+	 */
+	if (head + pad + sizeof(*rule) >= sizeof(list->rules))
+		return GXIO_MPIPE_ERR_RULES_FULL;
+
+	/* Verify num_buckets is a power of 2. */
+	if (__builtin_popcount(num_buckets) != 1)
+		return GXIO_MPIPE_ERR_RULES_INVALID;
+
+	/* Add padding to previous rule. */
+	rule->size += pad;
+
+	/* Start a new rule. */
+	list->head = head + pad;
+
+	rule = (gxio_mpipe_rules_rule_t *) (list->rules + list->head);
+
+	/* Default some values. */
+	rule->headroom = 2;
+	rule->tailroom = 0;
+	rule->capacity = 16384;
+
+	/* Save the bucket info. */
+	rule->bucket_mask = num_buckets - 1;
+	rule->bucket_first = bucket;
+
+	for (i = 8 - 1; i >= 0; i--) {
+		int maybe =
+		    stacks ? stacks->stacks[i] : rules->context->__stacks.
+		    stacks[i];
+		if (maybe != 255)
+			stack = maybe;
+		rule->stacks.stacks[i] = stack;
+	}
+
+	if (stack == 255)
+		return GXIO_MPIPE_ERR_RULES_INVALID;
+
+	/* NOTE: Only entries at the end of the array can be 255. */
+	for (i = 8 - 1; i > 0; i--) {
+		if (rule->stacks.stacks[i] == 255) {
+			rule->stacks.stacks[i] = stack;
+			rule->capacity =
+			    gxio_mpipe_buffer_size_enum_to_buffer_size(i - 1);
+		}
+	}
+
+	rule->size = sizeof(*rule);
+	list->tail = list->head + rule->size;
+
+	return 0;
+}
+
+int
+gxio_mpipe_rules_add_channel(gxio_mpipe_rules_t * rules, unsigned int channel)
+{
+	gxio_mpipe_rules_list_t *list = &rules->list;
+
+	gxio_mpipe_rules_rule_t *rule =
+	    (gxio_mpipe_rules_rule_t *) (list->rules + list->head);
+
+	/* Verify channel. */
+	if (channel >= 32)
+		return GXIO_MPIPE_ERR_RULES_INVALID;
+
+	/* Verify begun. */
+	if (list->tail == 0)
+		return GXIO_MPIPE_ERR_RULES_EMPTY;
+
+	rule->channel_bits |= (1UL << channel);
+
+	return 0;
+}
+
+int gxio_mpipe_rules_set_priority(gxio_mpipe_rules_t * rules, int priority)
+{
+	gxio_mpipe_rules_list_t *list = &rules->list;
+
+	gxio_mpipe_rules_rule_t *rule =
+	    (gxio_mpipe_rules_rule_t *) (list->rules + list->head);
+
+	/* Verify begun. */
+	if (list->tail == 0)
+		return GXIO_MPIPE_ERR_RULES_EMPTY;
+
+	rule->priority = priority;
+
+	return 0;
+}
+
+int gxio_mpipe_rules_set_headroom(gxio_mpipe_rules_t * rules, uint8_t headroom)
+{
+	gxio_mpipe_rules_list_t *list = &rules->list;
+
+	gxio_mpipe_rules_rule_t *rule =
+	    (gxio_mpipe_rules_rule_t *) (list->rules + list->head);
+
+	/* Verify begun. */
+	if (list->tail == 0)
+		return GXIO_MPIPE_ERR_RULES_EMPTY;
+
+	rule->headroom = headroom;
+
+	return 0;
+}
+
+int gxio_mpipe_rules_set_tailroom(gxio_mpipe_rules_t * rules, uint8_t tailroom)
+{
+	gxio_mpipe_rules_list_t *list = &rules->list;
+
+	gxio_mpipe_rules_rule_t *rule =
+	    (gxio_mpipe_rules_rule_t *) (list->rules + list->head);
+
+	/* Verify begun. */
+	if (list->tail == 0)
+		return GXIO_MPIPE_ERR_RULES_EMPTY;
+
+	rule->tailroom = tailroom;
+
+	return 0;
+}
+
+int gxio_mpipe_rules_set_capacity(gxio_mpipe_rules_t * rules, uint16_t capacity)
+{
+	gxio_mpipe_rules_list_t *list = &rules->list;
+
+	gxio_mpipe_rules_rule_t *rule =
+	    (gxio_mpipe_rules_rule_t *) (list->rules + list->head);
+
+	/* Verify begun. */
+	if (list->tail == 0)
+		return GXIO_MPIPE_ERR_RULES_EMPTY;
+
+	rule->capacity = capacity;
+
+	return 0;
+}
+
+int
+gxio_mpipe_rules_add_dmac(gxio_mpipe_rules_t * rules,
+			  gxio_mpipe_rules_dmac_t dmac)
+{
+	int i;
+	uint8_t *base;
+	uint8_t *ptr;
+
+	gxio_mpipe_rules_list_t *list = &rules->list;
+
+	gxio_mpipe_rules_rule_t *rule =
+	    (gxio_mpipe_rules_rule_t *) (list->rules + list->head);
+
+	/* Verify begun. */
+	if (list->tail == 0)
+		return GXIO_MPIPE_ERR_RULES_EMPTY;
+
+	base = rule->dmacs_and_vlans;
+
+	/* Collapse duplicates. */
+	for (i = 0; i < rule->num_dmacs; i++) {
+		uint8_t *old = base + i * sizeof(dmac);
+		if (memcmp(old, &dmac, sizeof(dmac)) == 0)
+			return 0;
+	}
+
+	/*
+	 * Verify room.
+	 * ISSUE: Mark rules as broken on error?
+	 */
+	if (list->tail + sizeof(dmac) >= sizeof(list->rules))
+		return GXIO_MPIPE_ERR_RULES_FULL;
+
+	ptr = base + rule->num_dmacs * sizeof(dmac);
+
+	/* Slide down any vlans. */
+	if (rule->num_vlans != 0)
+		memmove(ptr + sizeof(dmac), ptr, rule->num_vlans * 2);
+
+	*(gxio_mpipe_rules_dmac_t *) ptr = dmac;
+
+	list->tail += sizeof(dmac);
+	rule->size += sizeof(dmac);
+	rule->num_dmacs++;
+
+	return 0;
+}
+
+int
+gxio_mpipe_rules_add_vlan(gxio_mpipe_rules_t * rules,
+			  gxio_mpipe_rules_vlan_t vlan)
+{
+	gxio_mpipe_rules_list_t *list = &rules->list;
+
+	gxio_mpipe_rules_rule_t *rule =
+	    (gxio_mpipe_rules_rule_t *) (list->rules + list->head);
+
+	uint8_t *base;
+	int i;
+	uint8_t *ptr;
+
+	/* Verify begun. */
+	if (list->tail == 0)
+		return GXIO_MPIPE_ERR_RULES_EMPTY;
+
+	base = rule->dmacs_and_vlans + rule->num_dmacs * 6;
+
+	/* Collapse duplicates. */
+	for (i = 0; i < rule->num_vlans; i++) {
+		uint8_t *old = base + i * sizeof(vlan);
+		if (*(gxio_mpipe_rules_vlan_t *) old == vlan)
+			return 0;
+	}
+
+	/*
+	 * Verify room.
+	 * ISSUE: Mark rules as broken on error?
+	 */
+	if (list->tail + sizeof(vlan) >= sizeof(list->rules))
+		return GXIO_MPIPE_ERR_RULES_FULL;
+
+	ptr = base + rule->num_vlans * sizeof(vlan);
+
+	*(gxio_mpipe_rules_vlan_t *) ptr = vlan;
+
+	list->tail += sizeof(vlan);
+	rule->size += sizeof(vlan);
+	rule->num_vlans++;
+
+	return 0;
+}
+
+int gxio_mpipe_rules_commit(gxio_mpipe_rules_t * rules)
+{
+	gxio_mpipe_rules_list_t *list = &rules->list;
+	unsigned int size =
+	    offsetof(gxio_mpipe_rules_list_t, rules) + list->tail;
+	return gxio_mpipe_commit_rules(rules->context, list, size);
+}
+
+int
+gxio_mpipe_iqueue_init(gxio_mpipe_iqueue_t * iqueue,
+		       gxio_mpipe_context_t * context,
+		       unsigned int ring,
+		       void *mem, size_t mem_size, unsigned int mem_flags)
+{
+	/* The init call below will verify that "mem_size" is legal. */
+	unsigned int num_entries = mem_size / sizeof(gxio_mpipe_idesc_t);
+
+	iqueue->context = context;
+	iqueue->idescs = (gxio_mpipe_idesc_t *) mem;
+	iqueue->ring = ring;
+	iqueue->num_entries = num_entries;
+	iqueue->mask_num_entries = num_entries - 1;
+	iqueue->log2_num_entries = __builtin_ctz(num_entries);
+	iqueue->head = 1;
+#ifdef __BIG_ENDIAN__
+	iqueue->swapped = 0;
+#endif
+
+	/* Initialize the "tail". */
+	__gxio_mmio_write(mem, iqueue->head);
+
+	return gxio_mpipe_init_notif_ring(context, ring, mem, mem_size,
+					  mem_flags);
+}
+
+int
+gxio_mpipe_equeue_init(gxio_mpipe_equeue_t * equeue,
+		       gxio_mpipe_context_t * context,
+		       unsigned int edma_ring_id,
+		       unsigned int channel,
+		       void *mem, unsigned int mem_size, unsigned int mem_flags)
+{
+	/* The init call below will verify that "mem_size" is legal. */
+	unsigned int num_entries = mem_size / sizeof(gxio_mpipe_edesc_t);
+
+	/* Offset used to read number of completed commands. */
+	MPIPE_EDMA_POST_REGION_ADDR_t offset;
+
+	int result = gxio_mpipe_init_edma_ring(context, edma_ring_id, channel,
+					       mem, mem_size, mem_flags);
+	if (result < 0)
+		return result;
+
+	memset(equeue, 0, sizeof(*equeue));
+
+	offset.word = 0;
+	offset.region =
+	    MPIPE_MMIO_ADDR__REGION_VAL_EDMA - MPIPE_MMIO_ADDR__REGION_VAL_IDMA;
+	offset.ring = edma_ring_id;
+
+	__gxio_dma_queue_init(&equeue->dma_queue,
+			      context->mmio_fast_base + offset.word,
+			      num_entries);
+	equeue->edescs = mem;
+	equeue->mask_num_entries = num_entries - 1;
+	equeue->log2_num_entries = __builtin_ctz(num_entries);
+
+	return 0;
+}
+
+/* Get our internal context used for link name access.  This context is
+ *  special in that it is not associated with an mPIPE service domain.
+ */
+static gxio_mpipe_context_t *_gxio_get_link_context(void)
+{
+	static gxio_mpipe_context_t context;
+	static gxio_mpipe_context_t *contextp;
+	static int tried_open = 0;
+	static DEFINE_MUTEX(mutex);
+
+	mutex_lock(&mutex);
+
+	if (!tried_open) {
+		int i = 0;
+		tried_open = 1;
+
+		/*
+		 * "4" here is the maximum possible number of mPIPE shims; it's
+		 * an exaggeration but we shouldn't ever go beyond 2 anyway.
+		 */
+		for (i = 0; i < 4; i++) {
+			char file[80];
+
+			snprintf(file, sizeof(file), "mpipe/%d/iorpc_info", i);
+			context.fd = hv_dev_open((HV_VirtAddr) file, 0);
+			if (context.fd < 0)
+				continue;
+
+			contextp = &context;
+			break;
+		}
+	}
+
+	mutex_unlock(&mutex);
+
+	return contextp;
+}
+
+int gxio_mpipe_link_enumerate_mac(int idx, char *link_name, uint8_t * link_mac)
+{
+	int rv;
+	_gxio_mpipe_link_name_t name;
+	_gxio_mpipe_link_mac_t mac;
+
+	gxio_mpipe_context_t *context = _gxio_get_link_context();
+	if (!context)
+		return GXIO_ERR_NO_DEVICE;
+
+	rv = gxio_mpipe_info_enumerate_aux(context, idx, &name, &mac);
+	if (rv >= 0) {
+		strncpy(link_name, name.name, sizeof(name.name));
+		memcpy(link_mac, mac.mac, sizeof(mac.mac));
+	}
+
+	return rv;
+}
+
+int
+gxio_mpipe_link_open(gxio_mpipe_link_t * link, gxio_mpipe_context_t * context,
+		     const char *link_name, unsigned int flags)
+{
+	_gxio_mpipe_link_name_t name;
+	int rv;
+
+	strncpy(name.name, link_name, sizeof(name.name));
+	name.name[GXIO_MPIPE_LINK_NAME_LEN - 1] = '\0';
+
+	rv = gxio_mpipe_link_open_aux(context, name, flags);
+	if (rv < 0)
+		return rv;
+
+	link->context = context;
+	link->channel = rv >> 8;
+	link->mac = rv & 0xFF;
+
+	return 0;
+}
+
+int gxio_mpipe_link_close(gxio_mpipe_link_t * link)
+{
+	return gxio_mpipe_link_close_aux(link->context, link->mac);
+}
+
+EXPORT_SYMBOL(gxio_mpipe_init);
+EXPORT_SYMBOL(gxio_mpipe_buffer_size_to_buffer_size_enum);
+EXPORT_SYMBOL(gxio_mpipe_buffer_size_enum_to_buffer_size);
+EXPORT_SYMBOL(gxio_mpipe_calc_buffer_stack_bytes);
+EXPORT_SYMBOL(gxio_mpipe_init_buffer_stack);
+EXPORT_SYMBOL(gxio_mpipe_init_notif_ring);
+EXPORT_SYMBOL(gxio_mpipe_init_notif_group_and_buckets);
+EXPORT_SYMBOL(gxio_mpipe_rules_init);
+EXPORT_SYMBOL(gxio_mpipe_rules_begin);
+EXPORT_SYMBOL(gxio_mpipe_rules_add_channel);
+EXPORT_SYMBOL(gxio_mpipe_rules_set_priority);
+EXPORT_SYMBOL(gxio_mpipe_rules_set_headroom);
+EXPORT_SYMBOL(gxio_mpipe_rules_set_tailroom);
+EXPORT_SYMBOL(gxio_mpipe_rules_set_capacity);
+EXPORT_SYMBOL(gxio_mpipe_rules_add_dmac);
+EXPORT_SYMBOL(gxio_mpipe_rules_add_vlan);
+EXPORT_SYMBOL(gxio_mpipe_rules_commit);
+EXPORT_SYMBOL(gxio_mpipe_iqueue_init);
+EXPORT_SYMBOL(gxio_mpipe_equeue_init);
+EXPORT_SYMBOL(gxio_mpipe_link_enumerate_mac);
+EXPORT_SYMBOL(gxio_mpipe_link_open);
+EXPORT_SYMBOL(gxio_mpipe_link_close);
diff --git a/arch/tile/include/arch/mpipe.h b/arch/tile/include/arch/mpipe.h
new file mode 100644
index 0000000..5199534
--- /dev/null
+++ b/arch/tile/include/arch/mpipe.h
@@ -0,0 +1,321 @@
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
+/* Machine-generated file; do not edit. */
+
+#ifndef __ARCH_MPIPE_H__
+#define __ARCH_MPIPE_H__
+
+#include <arch/abi.h>
+#include <arch/mpipe_def.h>
+
+#ifndef __ASSEMBLER__
+
+// MMIO Ingress DMA Release Region Address.
+// This is a description of the physical addresses used to manipulate ingress
+// credit counters.  Accesses to this address space should use an address of
+// this form and a value like that specified in IDMA_RELEASE_REGION_VAL.
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    // Reserved.
+    uint_reg_t __reserved_0  : 3;
+    // NotifRing to be released
+    uint_reg_t ring          : 8;
+    // Bucket to be released
+    uint_reg_t bucket        : 13;
+    // Enable NotifRing release
+    uint_reg_t ring_enable   : 1;
+    // Enable Bucket release
+    uint_reg_t bucket_enable : 1;
+    // This field of the address selects the region (address space) to be
+    // accessed.  For the iDMA release region, this field must be 4.
+    uint_reg_t region        : 3;
+    // Reserved.
+    uint_reg_t __reserved_1  : 6;
+    // This field of the address indexes the 32 entry service domain table.
+    uint_reg_t svc_dom       : 5;
+    // Reserved.
+    uint_reg_t __reserved_2  : 24;
+#else   // __BIG_ENDIAN__
+    uint_reg_t __reserved_2  : 24;
+    uint_reg_t svc_dom       : 5;
+    uint_reg_t __reserved_1  : 6;
+    uint_reg_t region        : 3;
+    uint_reg_t bucket_enable : 1;
+    uint_reg_t ring_enable   : 1;
+    uint_reg_t bucket        : 13;
+    uint_reg_t ring          : 8;
+    uint_reg_t __reserved_0  : 3;
+#endif
+  };
+
+  uint_reg_t word;
+} MPIPE_IDMA_RELEASE_REGION_ADDR_t;
+
+// MMIO Ingress DMA Release Region Value - Release NotifRing and/or Bucket.
+// Provides release of the associated NotifRing.  The address of the MMIO
+// operation is described in IDMA_RELEASE_REGION_ADDR.
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    // Number of packets being released.  The load balancer's count of
+    // inflight packets will be decremented by this amount for the associated
+    // Bucket and/or NotifRing
+    uint_reg_t count      : 16;
+    // Reserved.
+    uint_reg_t __reserved : 48;
+#else   // __BIG_ENDIAN__
+    uint_reg_t __reserved : 48;
+    uint_reg_t count      : 16;
+#endif
+  };
+
+  uint_reg_t word;
+} MPIPE_IDMA_RELEASE_REGION_VAL_t;
+
+// MMIO Buffer Stack Manager Region Address.
+// This MMIO region is used for posting or fetching buffers to/from the
+// buffer stack manager.  On an MMIO load, this pops a buffer descriptor from
+// the top of stack if one is available.  On an MMIO store, this pushes a
+// buffer to the stack.  The value read or written is described in
+// BSM_REGION_VAL.
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    // Reserved.
+    uint_reg_t __reserved_0 : 3;
+    // BufferStack being accessed.
+    uint_reg_t stack        : 5;
+    // Reserved.
+    uint_reg_t __reserved_1 : 18;
+    // This field of the address selects the region (address space) to be
+    // accessed.  For the buffer stack manager region, this field must be 6.
+    uint_reg_t region       : 3;
+    // Reserved.
+    uint_reg_t __reserved_2 : 6;
+    // This field of the address indexes the 32 entry service domain table.
+    uint_reg_t svc_dom      : 5;
+    // Reserved.
+    uint_reg_t __reserved_3 : 24;
+#else   // __BIG_ENDIAN__
+    uint_reg_t __reserved_3 : 24;
+    uint_reg_t svc_dom      : 5;
+    uint_reg_t __reserved_2 : 6;
+    uint_reg_t region       : 3;
+    uint_reg_t __reserved_1 : 18;
+    uint_reg_t stack        : 5;
+    uint_reg_t __reserved_0 : 3;
+#endif
+  };
+
+  uint_reg_t word;
+} MPIPE_BSM_REGION_ADDR_t;
+
+// MMIO Buffer Stack Manager Region Value.
+// This MMIO region is used for posting or fetching buffers to/from the
+// buffer stack manager.  On an MMIO load, this pops a buffer descriptor from
+// the top of stack if one is available. On an MMIO store, this pushes a
+// buffer to the stack.  The address of the MMIO operation is described in
+// BSM_REGION_ADDR.
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    // Reserved.
+    uint_reg_t __reserved_0 : 7;
+    // Base virtual address of the buffer.  Must be sign extended by consumer.
+    int_reg_t va           : 35;
+    // Reserved.
+    uint_reg_t __reserved_1 : 6;
+    // Index of the buffer stack to which this buffer belongs.  Ignored on
+    // writes since the offset bits specify the stack being accessed.
+    uint_reg_t stack_idx    : 5;
+    // Reserved.
+    uint_reg_t __reserved_2 : 5;
+    // Reads as one to indicate that this is a hardware managed buffer.
+    // Ignored on writes since all buffers on a given stack are the same size.
+    uint_reg_t hwb          : 1;
+    // Encoded size of buffer (ignored on writes):
+    // 0 = 128 bytes
+    // 1 = 256 bytes
+    // 2 = 512 bytes
+    // 3 = 1024 bytes
+    // 4 = 1664 bytes
+    // 5 = 4096 bytes
+    // 6 = 10368 bytes
+    // 7 = 16384 bytes
+    uint_reg_t size         : 3;
+    // Valid indication for the buffer.  Ignored on writes.
+    // 0 : Valid buffer descriptor popped from stack.
+    // 3 : Could not pop a buffer from the stack.  Either the stack is empty,
+    // or the hardware's prefetch buffer is empty for this stack.
+    uint_reg_t c            : 2;
+#else   // __BIG_ENDIAN__
+    uint_reg_t c            : 2;
+    uint_reg_t size         : 3;
+    uint_reg_t hwb          : 1;
+    uint_reg_t __reserved_2 : 5;
+    uint_reg_t stack_idx    : 5;
+    uint_reg_t __reserved_1 : 6;
+    int_reg_t va           : 35;
+    uint_reg_t __reserved_0 : 7;
+#endif
+  };
+
+  uint_reg_t word;
+} MPIPE_BSM_REGION_VAL_t;
+
+// MMIO Egress DMA Post Region Address.
+// Used to post descriptor locations to the eDMA descriptor engine.  The
+// value to be written is described in EDMA_POST_REGION_VAL
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    // Reserved.
+    uint_reg_t __reserved_0 : 3;
+    // eDMA ring being accessed
+    uint_reg_t ring         : 5;
+    // Reserved.
+    uint_reg_t __reserved_1 : 18;
+    // This field of the address selects the region (address space) to be
+    // accessed.  For the egress DMA post region, this field must be 5.
+    uint_reg_t region       : 3;
+    // Reserved.
+    uint_reg_t __reserved_2 : 6;
+    // This field of the address indexes the 32 entry service domain table.
+    uint_reg_t svc_dom      : 5;
+    // Reserved.
+    uint_reg_t __reserved_3 : 24;
+#else   // __BIG_ENDIAN__
+    uint_reg_t __reserved_3 : 24;
+    uint_reg_t svc_dom      : 5;
+    uint_reg_t __reserved_2 : 6;
+    uint_reg_t region       : 3;
+    uint_reg_t __reserved_1 : 18;
+    uint_reg_t ring         : 5;
+    uint_reg_t __reserved_0 : 3;
+#endif
+  };
+
+  uint_reg_t word;
+} MPIPE_EDMA_POST_REGION_ADDR_t;
+
+// MMIO Egress DMA Post Region Value.
+// Used to post descriptor locations to the eDMA descriptor engine.  The
+// address is described in EDMA_POST_REGION_ADDR.
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    // For writes, this specifies the current ring tail pointer prior to any
+    // post.  For example, to post 1 or more descriptors starting at location
+    // 23, this would contain 23 (not 24).  On writes, this index must be
+    // masked based on the ring size.  The new tail pointer after this post
+    // is COUNT+RING_IDX (masked by the ring size).
+    //
+    // For reads, this provides the hardware descriptor fetcher's head
+    // pointer.  The descriptors prior to the head pointer, however, may not
+    // yet have been processed so this indicator is only used to determine
+    // how full the ring is and if software may post more descriptors.
+    uint_reg_t ring_idx   : 16;
+    // For writes, this specifies number of contiguous descriptors that are
+    // being posted.  Software may post up to RingSize descriptors with a
+    // single MMIO store.  A zero in this field on a write will "wake up" an
+    // eDMA ring and cause it fetch descriptors regardless of the hardware's
+    // current view of the state of the tail pointer.
+    //
+    // For reads, this field provides a rolling count of the number of
+    // descriptors that have been completely processed.  This may be used by
+    // software to determine when buffers associated with a descriptor may be
+    // returned or reused.  When the ring's flush bit is cleared by software
+    // (after having been set by HW or SW), the COUNT will be cleared.
+    uint_reg_t count      : 16;
+    // For writes, this specifies the generation number of the tail being
+    // posted. Note that if tail+cnt wraps to the beginning of the ring, the
+    // eDMA hardware assumes that the descriptors posted at the beginning of
+    // the ring are also valid so it is okay to post around the wrap point.
+    //
+    // For reads, this is the current generation number.  Valid descriptors
+    // will have the inverse of this generation number.
+    uint_reg_t gen        : 1;
+    // Reserved.
+    uint_reg_t __reserved : 31;
+#else   // __BIG_ENDIAN__
+    uint_reg_t __reserved : 31;
+    uint_reg_t gen        : 1;
+    uint_reg_t count      : 16;
+    uint_reg_t ring_idx   : 16;
+#endif
+  };
+
+  uint_reg_t word;
+} MPIPE_EDMA_POST_REGION_VAL_t;
+
+// Load Balancer Bucket Status Data.
+// Read/Write data for load balancer Bucket-Status Table. 4160 entries
+// indexed by LBL_INIT_CTL.IDX when LBL_INIT_CTL.STRUCT_SEL is BSTS_TBL
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    // NotifRing currently assigned to this bucket.
+    uint_reg_t notifring  : 8;
+    // Current reference count.
+    uint_reg_t count      : 16;
+    // Group associated with this bucket.
+    uint_reg_t group      : 5;
+    // Mode select for this bucket.
+    uint_reg_t mode       : 3;
+    // Reserved.
+    uint_reg_t __reserved : 32;
+#else   // __BIG_ENDIAN__
+    uint_reg_t __reserved : 32;
+    uint_reg_t mode       : 3;
+    uint_reg_t group      : 5;
+    uint_reg_t count      : 16;
+    uint_reg_t notifring  : 8;
+#endif
+  };
+
+  uint_reg_t word;
+} MPIPE_LBL_INIT_DAT_BSTS_TBL_t;
+#endif /* !defined(__ASSEMBLER__) */
+
+#endif /* !defined(__ARCH_MPIPE_H__) */
diff --git a/arch/tile/include/arch/mpipe_constants.h b/arch/tile/include/arch/mpipe_constants.h
new file mode 100644
index 0000000..315d80f
--- /dev/null
+++ b/arch/tile/include/arch/mpipe_constants.h
@@ -0,0 +1,43 @@
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
+
+
+#ifndef __ARCH_MPIPE_CONSTANTS_H__
+#define __ARCH_MPIPE_CONSTANTS_H__
+
+#define MPIPE_NUM_CLASSIFIERS 10
+#define MPIPE_CLS_MHZ 1200
+
+#define MPIPE_NUM_EDMA_RINGS 32
+
+#define MPIPE_NUM_SGMII_MACS 16
+#define MPIPE_NUM_XAUI_MACS 4
+#define MPIPE_NUM_LOOPBACK_CHANNELS 4
+#define MPIPE_NUM_NON_LB_CHANNELS 28
+
+#define MPIPE_NUM_IPKT_BLOCKS 1536
+
+#define MPIPE_NUM_BUCKETS 4160
+
+#define MPIPE_NUM_NOTIF_RINGS 256
+
+#define MPIPE_NUM_NOTIF_GROUPS 32
+
+#define MPIPE_NUM_TLBS_PER_ASID 16
+#define MPIPE_TLB_IDX_WIDTH 4
+
+#define MPIPE_MMIO_NUM_SVC_DOM 32
+
+#endif /* __ARCH_MPIPE_CONSTANTS_H__ */
diff --git a/arch/tile/include/arch/mpipe_def.h b/arch/tile/include/arch/mpipe_def.h
new file mode 100644
index 0000000..4998850
--- /dev/null
+++ b/arch/tile/include/arch/mpipe_def.h
@@ -0,0 +1,39 @@
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
+/* Machine-generated file; do not edit. */
+
+#ifndef __ARCH_MPIPE_DEF_H__
+#define __ARCH_MPIPE_DEF_H__
+#define MPIPE_MMIO_ADDR__REGION_SHIFT 26
+#define MPIPE_MMIO_ADDR__REGION_VAL_CFG 0x0
+#define MPIPE_MMIO_ADDR__REGION_VAL_IDMA 0x4
+#define MPIPE_MMIO_ADDR__REGION_VAL_EDMA 0x5
+#define MPIPE_MMIO_ADDR__REGION_VAL_BSM 0x6
+#define MPIPE_BSM_REGION_VAL__VA_SHIFT 7
+#define MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_128 0x0
+#define MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_256 0x1
+#define MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_512 0x2
+#define MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_1024 0x3
+#define MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_1664 0x4
+#define MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_4096 0x5
+#define MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_10368 0x6
+#define MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_16384 0x7
+#define MPIPE_LBL_INIT_DAT_BSTS_TBL__MODE_VAL_DFA 0x0
+#define MPIPE_LBL_INIT_DAT_BSTS_TBL__MODE_VAL_FIXED 0x1
+#define MPIPE_LBL_INIT_DAT_BSTS_TBL__MODE_VAL_ALWAYS_PICK 0x2
+#define MPIPE_LBL_INIT_DAT_BSTS_TBL__MODE_VAL_STICKY 0x3
+#define MPIPE_LBL_INIT_DAT_BSTS_TBL__MODE_VAL_STICKY_RAND 0x7
+#define MPIPE_LBL_NR_STATE__FIRST_WORD 0x2138
+#endif /* !defined(__ARCH_MPIPE_DEF_H__) */
diff --git a/arch/tile/include/arch/mpipe_shm.h b/arch/tile/include/arch/mpipe_shm.h
new file mode 100644
index 0000000..deeda1d
--- /dev/null
+++ b/arch/tile/include/arch/mpipe_shm.h
@@ -0,0 +1,421 @@
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
+/* Machine-generated file; do not edit. */
+
+
+#ifndef __ARCH_MPIPE_SHM_H__
+#define __ARCH_MPIPE_SHM_H__
+
+#include <arch/abi.h>
+#include <arch/mpipe_shm_def.h>
+
+#ifndef __ASSEMBLER__
+//! MPIPE eDMA Descriptor.
+//! The eDMA descriptor is written by software and consumed by hardware.  It
+//! is used to specify the location of egress packet data to be sent out of
+//! the chip via one of the packet interfaces.
+
+__extension__
+typedef union
+{
+  struct
+  {
+    // Word 0
+
+#ifndef __BIG_ENDIAN__
+    //! Generation number.  Used to indicate a valid descriptor in ring.  When
+    //! a new descriptor is written into the ring, software must toggle this
+    //! bit.  The net effect is that the GEN bit being written into new
+    //! descriptors toggles each time the ring tail pointer wraps.
+    uint_reg_t gen        : 1;
+    //! Reserved.  Must be zero.
+    uint_reg_t r0         : 7;
+    //! Checksum generation enabled for this transfer.
+    uint_reg_t csum       : 1;
+    //! Nothing to be sent.  Used, for example, when software has dropped a
+    //! packet but still wishes to return all of the associated buffers.
+    uint_reg_t ns         : 1;
+    //! Notification interrupt will be delivered when packet has been egressed.
+    uint_reg_t notif      : 1;
+    //! Boundary indicator.  When 1, this transfer includes the EOP for this
+    //! command.  Must be clear on all but the last descriptor for an egress
+    //! packet.
+    uint_reg_t bound      : 1;
+    //! Reserved.  Must be zero.
+    uint_reg_t r1         : 4;
+    //! Number of bytes to be sent for this descriptor.  When zero, no data
+    //! will be moved and the buffer descriptor will be ignored.  If the
+    //! buffer descriptor indicates that it is chained, the low 7 bits of the
+    //! VA indicate the offset within the first buffer (e.g. 127 bytes is the
+    //! maximum offset into the first buffer).  If the size exceeds a single
+    //! buffer, subsequent buffer descriptors will be fetched prior to
+    //! processing the next eDMA descriptor in the ring.
+    uint_reg_t xfer_size  : 14;
+    //! Reserved.  Must be zero.
+    uint_reg_t r2         : 2;
+    //! Destination of checksum relative to CSUM_START relative to the first
+    //! byte moved by this descriptor.  Must be zero if CSUM=0 in this
+    //! descriptor.  Must be less than XFER_SIZE (e.g. the first byte of the
+    //! CSUM_DEST must be within the span of this descriptor).
+    uint_reg_t csum_dest  : 8;
+    //! Start byte of checksum relative to the first byte moved by this
+    //! descriptor.  If this is not the first descriptor for the egress
+    //! packet, CSUM_START is still relative to the first byte in this
+    //! descriptor.  Must be zero if CSUM=0 in this descriptor.
+    uint_reg_t csum_start : 8;
+    //! Initial value for 16-bit 1's compliment checksum if enabled via CSUM.
+    //! Specified in network order.  That is, bits[7:0] will be added to the
+    //! byte pointed to by CSUM_START and bits[15:8] will be added to the byte
+    //! pointed to by CSUM_START+1 (with appropriate 1's compliment carries).
+    //! Must be zero if CSUM=0 in this descriptor.
+    uint_reg_t csum_seed  : 16;
+#else   // __BIG_ENDIAN__
+    uint_reg_t csum_seed  : 16;
+    uint_reg_t csum_start : 8;
+    uint_reg_t csum_dest  : 8;
+    uint_reg_t r2         : 2;
+    uint_reg_t xfer_size  : 14;
+    uint_reg_t r1         : 4;
+    uint_reg_t bound      : 1;
+    uint_reg_t notif      : 1;
+    uint_reg_t ns         : 1;
+    uint_reg_t csum       : 1;
+    uint_reg_t r0         : 7;
+    uint_reg_t gen        : 1;
+#endif
+
+    // Word 1
+
+#ifndef __BIG_ENDIAN__
+    //! Virtual address.  Must be sign extended by consumer.
+    int_reg_t va           : 42;
+    //! Reserved.
+    uint_reg_t __reserved_0 : 6;
+    //! Index of the buffer stack to which this buffer belongs.
+    uint_reg_t stack_idx    : 5;
+    //! Reserved.
+    uint_reg_t __reserved_1 : 3;
+    //! Instance ID.  For devices that support more than one mPIPE instance,
+    //! this field indicates the buffer owner.  If the INST field does not
+    //! match the mPIPE's instance number when a packet is egressed, buffers
+    //! with HWB set will be returned to the other mPIPE instance.
+    uint_reg_t inst         : 1;
+    //! Reserved.
+    uint_reg_t __reserved_2 : 1;
+    //! Always set to one by hardware in iDMA packet descriptors.  For eDMA,
+    //! indicates whether the buffer will be released to the buffer stack
+    //! manager.  When 0, software is responsible for releasing the buffer.
+    uint_reg_t hwb          : 1;
+    //! Encoded size of buffer.  Set by the ingress hardware for iDMA packet
+    //! descriptors.  For eDMA descriptors, indicates the buffer size if .c
+    //! indicates a chained packet.  If an eDMA descriptor is not chained and
+    //! the .hwb bit is not set, this field is ignored and the size is
+    //! specified by the .xfer_size field.
+    //! 0 = 128 bytes
+    //! 1 = 256 bytes
+    //! 2 = 512 bytes
+    //! 3 = 1024 bytes
+    //! 4 = 1664 bytes
+    //! 5 = 4096 bytes
+    //! 6 = 10368 bytes
+    //! 7 = 16384 bytes
+    uint_reg_t size         : 3;
+    //! Chaining configuration for the buffer.  Indicates that an ingress
+    //! packet or egress command is chained across multiple buffers, with each
+    //! buffer's size indicated by the .size field.
+    uint_reg_t c            : 2;
+#else   // __BIG_ENDIAN__
+    uint_reg_t c            : 2;
+    uint_reg_t size         : 3;
+    uint_reg_t hwb          : 1;
+    uint_reg_t __reserved_2 : 1;
+    uint_reg_t inst         : 1;
+    uint_reg_t __reserved_1 : 3;
+    uint_reg_t stack_idx    : 5;
+    uint_reg_t __reserved_0 : 6;
+    int_reg_t va           : 42;
+#endif
+
+  };
+
+  //! Word access
+  uint_reg_t words[2];
+} MPIPE_EDMA_DESC_t;
+
+//! MPIPE Packet Descriptor.
+//! The packet descriptor is filled by the mPIPE's classification,
+//! load-balancing, and buffer management services.  Some fields are consumed
+//! by mPIPE hardware, and others are consumed by Tile software.
+
+__extension__
+typedef union
+{
+  struct
+  {
+    // Word 0
+
+#ifndef __BIG_ENDIAN__
+    //! Notification ring into which this packet descriptor is written.
+    //! Typically written by load balancer, but can be overridden by
+    //! classification program if NR is asserted.
+    uint_reg_t notif_ring   : 8;
+    //! Source channel for this packet.  Written by mPIPE DMA hardware.
+    uint_reg_t channel      : 5;
+    //! Reserved.
+    uint_reg_t __reserved_0 : 1;
+    //! MAC Error.
+    //! Generated by the MAC interface.  Asserted if there was an overrun of
+    //! the MAC's receive FIFO.  This condition generally only occurs if the
+    //! mPIPE clock is running too slowly.
+    uint_reg_t me           : 1;
+    //! Truncation Error.
+    //! Written by the iDMA hardware.  Asserted if packet was truncated due to
+    //! insufficient space in iPkt buffer
+    uint_reg_t tr           : 1;
+    //! Written by the iDMA hardware.  Indicates the number of bytes written
+    //! to Tile memory.  In general, this is the actual size of the packet as
+    //! received from the MAC.  But if the packet is truncated due to running
+    //! out of buffers or due to the iPkt buffer filling up, then the L2_SIZE
+    //! will be reduced to reflect the actual number of valid bytes written to
+    //! Tile memory.
+    uint_reg_t l2_size      : 14;
+    //! CRC Error.
+    //! Generated by the MAC.  Asserted if MAC indicated an L2 CRC error or
+    //! other L2 error (bad length etc.) on the packet.
+    uint_reg_t ce           : 1;
+    //! Cut Through.
+    //! Written by the iDMA hardware.  Asserted if packet was not completely
+    //! received before being sent to classifier.  L2_Size will indicate
+    //! number of bytes received so far.
+    uint_reg_t ct           : 1;
+    //! Written by the classification program.  Used by the load balancer to
+    //! select the ring into which this packet descriptor is written.
+    uint_reg_t bucket_id    : 13;
+    //! Reserved.
+    uint_reg_t __reserved_1 : 3;
+    //! Checksum.
+    //! Written by classification program.  When 1, the checksum engine will
+    //! perform checksum based on the CSUM_SEED, CSUM_START, and CSUM_BYTES
+    //! fields.  The result will be placed in CSUM_VAL.
+    uint_reg_t cs           : 1;
+    //! Notification Ring Select.
+    //! Written by the classification program.  When 1, the NotifRingIDX is
+    //! set by classification program rather than being set by load balancer.
+    uint_reg_t nr           : 1;
+    //! Written by classification program.  Indicates whether packet and
+    //! descriptor should both be dropped, both be delivered, or only the
+    //! descriptor should be delivered.
+    uint_reg_t dest         : 2;
+    //! General Purpose Sequence Number Enable.
+    //! Written by the classification program.  When 1, the GP_SQN_SEL field
+    //! contains the sequence number selector and the GP_SQN field will be
+    //! replaced with the associated sequence number.  When clear, the GP_SQN
+    //! field is left intact and be used as "Custom" bytes.
+    uint_reg_t sq           : 1;
+    //! TimeStamp Enable.
+    //! Enable TimeStamp insertion.  When clear, timestamp field may be filled
+    //! with custom data by classifier.  When set, hardware inserts the
+    //! timestamp when the start of packet is received from the MAC.
+    uint_reg_t ts           : 1;
+    //! Packet Sequence Number Enable.
+    //! Enable PacketSQN insertion.  When clear, PacketSQN field may be filled
+    //! with custom data by classifier.  When set, hardware inserts the packet
+    //! sequence number when the packet descriptor is written to a
+    //! notification ring.
+    uint_reg_t ps           : 1;
+    //! Buffer Error.
+    //! Written by the iDMA hardware.  Asserted if iDMA ran out of buffers
+    //! while writing the packet. Software must still return any buffer
+    //! descriptors whose C field indicates a valid descriptor was consumed.
+    uint_reg_t be           : 1;
+    //! Written by  the classification program.  The associated counter is
+    //! incremented when the packet is sent.
+    uint_reg_t ctr0         : 5;
+    //! Reserved.
+    uint_reg_t __reserved_2 : 3;
+#else   // __BIG_ENDIAN__
+    uint_reg_t __reserved_2 : 3;
+    uint_reg_t ctr0         : 5;
+    uint_reg_t be           : 1;
+    uint_reg_t ps           : 1;
+    uint_reg_t ts           : 1;
+    uint_reg_t sq           : 1;
+    uint_reg_t dest         : 2;
+    uint_reg_t nr           : 1;
+    uint_reg_t cs           : 1;
+    uint_reg_t __reserved_1 : 3;
+    uint_reg_t bucket_id    : 13;
+    uint_reg_t ct           : 1;
+    uint_reg_t ce           : 1;
+    uint_reg_t l2_size      : 14;
+    uint_reg_t tr           : 1;
+    uint_reg_t me           : 1;
+    uint_reg_t __reserved_0 : 1;
+    uint_reg_t channel      : 5;
+    uint_reg_t notif_ring   : 8;
+#endif
+
+    // Word 1
+
+#ifndef __BIG_ENDIAN__
+    //! Written by  the classification program.  The associated counter is
+    //! incremented when the packet is sent.
+    uint_reg_t ctr1          : 5;
+    //! Reserved.
+    uint_reg_t __reserved_3  : 3;
+    //! Written by classification program.  Indicates the start byte for
+    //! checksum.  Relative to 1st byte received from MAC.
+    uint_reg_t csum_start    : 8;
+    //! Checksum seed written by classification program.  Overwritten with
+    //! resultant checksum if CS bit is asserted.  The endianness of the CSUM
+    //! value bits when viewed by Tile software match the packet byte order.
+    //! That is, bits[7:0] of the resulting checksum value correspond to
+    //! earlier (more significant) bytes in the packet.  To avoid classifier
+    //! software from having to byte swap the CSUM_SEED, the iDMA checksum
+    //! engine byte swaps the classifier's result before seeding the checksum
+    //! calculation.  Thus, the CSUM_START byte of packet data is added to
+    //! bits[15:8] of the CSUM_SEED field generated by the classifier.  This
+    //! byte swap will be visible to Tile software if the CS bit is clear.
+    uint_reg_t csum_seed_val : 16;
+    //! Written by  the classification program.  Not interpreted by mPIPE
+    //! hardware.
+    uint_reg_t custom0       : 32;
+#else   // __BIG_ENDIAN__
+    uint_reg_t custom0       : 32;
+    uint_reg_t csum_seed_val : 16;
+    uint_reg_t csum_start    : 8;
+    uint_reg_t __reserved_3  : 3;
+    uint_reg_t ctr1          : 5;
+#endif
+
+    // Word 2
+
+#ifndef __BIG_ENDIAN__
+    //! Written by  the classification program.  Not interpreted by mPIPE
+    //! hardware.
+    uint_reg_t custom1 : 64;
+#else   // __BIG_ENDIAN__
+    uint_reg_t custom1 : 64;
+#endif
+
+    // Word 3
+
+#ifndef __BIG_ENDIAN__
+    //! Written by  the classification program.  Not interpreted by mPIPE
+    //! hardware.
+    uint_reg_t custom2 : 64;
+#else   // __BIG_ENDIAN__
+    uint_reg_t custom2 : 64;
+#endif
+
+    // Word 4
+
+#ifndef __BIG_ENDIAN__
+    //! Written by  the classification program.  Not interpreted by mPIPE
+    //! hardware.
+    uint_reg_t custom3 : 64;
+#else   // __BIG_ENDIAN__
+    uint_reg_t custom3 : 64;
+#endif
+
+    // Word 5
+
+#ifndef __BIG_ENDIAN__
+    //! Sequence number applied when packet is distributed.   Classifier
+    //! selects which sequence number is to be applied by writing the 13-bit
+    //! SQN-selector into this field.
+    uint_reg_t gp_sqn     : 16;
+    //! Written by notification hardware.  The packet sequence number is
+    //! incremented for each packet that wasn't dropped.
+    uint_reg_t packet_sqn : 48;
+#else   // __BIG_ENDIAN__
+    uint_reg_t packet_sqn : 48;
+    uint_reg_t gp_sqn     : 16;
+#endif
+
+    // Word 6
+
+#ifndef __BIG_ENDIAN__
+    //! Written by hardware when the start-of-packet is received by the mPIPE
+    //! from the MAC.  This is the nanoseconds part of the packet timestamp.
+    uint_reg_t time_stamp_ns  : 32;
+    //! Written by hardware when the start-of-packet is received by the mPIPE
+    //! from the MAC.  This is the seconds part of the packet timestamp.
+    uint_reg_t time_stamp_sec : 32;
+#else   // __BIG_ENDIAN__
+    uint_reg_t time_stamp_sec : 32;
+    uint_reg_t time_stamp_ns  : 32;
+#endif
+
+    // Word 7
+
+#ifndef __BIG_ENDIAN__
+    //! Virtual address.  Must be sign extended by consumer.
+    int_reg_t va           : 42;
+    //! Reserved.
+    uint_reg_t __reserved_4 : 6;
+    //! Index of the buffer stack to which this buffer belongs.
+    uint_reg_t stack_idx    : 5;
+    //! Reserved.
+    uint_reg_t __reserved_5 : 3;
+    //! Instance ID.  For devices that support more than one mPIPE instance,
+    //! this field indicates the buffer owner.  If the INST field does not
+    //! match the mPIPE's instance number when a packet is egressed, buffers
+    //! with HWB set will be returned to the other mPIPE instance.
+    uint_reg_t inst         : 1;
+    //! Reserved.
+    uint_reg_t __reserved_6 : 1;
+    //! Always set to one by hardware in iDMA packet descriptors.  For eDMA,
+    //! indicates whether the buffer will be released to the buffer stack
+    //! manager.  When 0, software is responsible for releasing the buffer.
+    uint_reg_t hwb          : 1;
+    //! Encoded size of buffer.  Set by the ingress hardware for iDMA packet
+    //! descriptors.  For eDMA descriptors, indicates the buffer size if .c
+    //! indicates a chained packet.  If an eDMA descriptor is not chained and
+    //! the .hwb bit is not set, this field is ignored and the size is
+    //! specified by the .xfer_size field.
+    //! 0 = 128 bytes
+    //! 1 = 256 bytes
+    //! 2 = 512 bytes
+    //! 3 = 1024 bytes
+    //! 4 = 1664 bytes
+    //! 5 = 4096 bytes
+    //! 6 = 10368 bytes
+    //! 7 = 16384 bytes
+    uint_reg_t size         : 3;
+    //! Chaining configuration for the buffer.  Indicates that an ingress
+    //! packet or egress command is chained across multiple buffers, with each
+    //! buffer's size indicated by the .size field.
+    uint_reg_t c            : 2;
+#else   // __BIG_ENDIAN__
+    uint_reg_t c            : 2;
+    uint_reg_t size         : 3;
+    uint_reg_t hwb          : 1;
+    uint_reg_t __reserved_6 : 1;
+    uint_reg_t inst         : 1;
+    uint_reg_t __reserved_5 : 3;
+    uint_reg_t stack_idx    : 5;
+    uint_reg_t __reserved_4 : 6;
+    int_reg_t va           : 42;
+#endif
+
+  };
+
+  //! Word access
+  uint_reg_t words[8];
+} MPIPE_PDESC_t;
+#endif /* !defined(__ASSEMBLER__) */
+
+#endif /* !defined(__ARCH_MPIPE_SHM_H__) */
diff --git a/arch/tile/include/arch/mpipe_shm_def.h b/arch/tile/include/arch/mpipe_shm_def.h
new file mode 100644
index 0000000..5ede122
--- /dev/null
+++ b/arch/tile/include/arch/mpipe_shm_def.h
@@ -0,0 +1,23 @@
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
+/* Machine-generated file; do not edit. */
+
+#ifndef __ARCH_MPIPE_SHM_DEF_H__
+#define __ARCH_MPIPE_SHM_DEF_H__
+#define MPIPE_EDMA_DESC_WORD1__C_VAL_UNCHAINED 0x0
+#define MPIPE_EDMA_DESC_WORD1__C_VAL_CHAINED 0x1
+#define MPIPE_EDMA_DESC_WORD1__C_VAL_NOT_RDY 0x2
+#define MPIPE_EDMA_DESC_WORD1__C_VAL_INVALID 0x3
+#endif /* !defined(__ARCH_MPIPE_SHM_DEF_H__) */
diff --git a/arch/tile/include/gxio/iorpc_mpipe.h b/arch/tile/include/gxio/iorpc_mpipe.h
new file mode 100644
index 0000000..98d79bc
--- /dev/null
+++ b/arch/tile/include/gxio/iorpc_mpipe.h
@@ -0,0 +1,124 @@
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
+#ifndef __GXIO_MPIPE_LINUX_RPC_H__
+#define __GXIO_MPIPE_LINUX_RPC_H__
+
+#include <hv/iorpc.h>
+
+#include <hv/drv_mpipe_intf.h>
+#include <asm/page.h>
+#include <gxio/kiorpc.h>
+#include <gxio/mpipe.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <asm/pgtable.h>
+
+#define GXIO_MPIPE_OP_ALLOC_BUFFER_STACKS IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1200)
+#define GXIO_MPIPE_OP_INIT_BUFFER_STACK_AUX IORPC_OPCODE(IORPC_FORMAT_KERNEL_MEM, 0x1201)
+
+#define GXIO_MPIPE_OP_ALLOC_NOTIF_RINGS IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1203)
+#define GXIO_MPIPE_OP_INIT_NOTIF_RING_AUX IORPC_OPCODE(IORPC_FORMAT_KERNEL_MEM, 0x1204)
+#define GXIO_MPIPE_OP_REQUEST_NOTIF_RING_INTERRUPT IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x1205)
+#define GXIO_MPIPE_OP_ENABLE_NOTIF_RING_INTERRUPT IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1206)
+#define GXIO_MPIPE_OP_ALLOC_NOTIF_GROUPS IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1207)
+#define GXIO_MPIPE_OP_INIT_NOTIF_GROUP IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1208)
+#define GXIO_MPIPE_OP_ALLOC_BUCKETS    IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1209)
+#define GXIO_MPIPE_OP_INIT_BUCKET      IORPC_OPCODE(IORPC_FORMAT_NONE, 0x120a)
+#define GXIO_MPIPE_OP_ALLOC_EDMA_RINGS IORPC_OPCODE(IORPC_FORMAT_NONE, 0x120b)
+#define GXIO_MPIPE_OP_INIT_EDMA_RING_AUX IORPC_OPCODE(IORPC_FORMAT_KERNEL_MEM, 0x120c)
+
+#define GXIO_MPIPE_OP_COMMIT_RULES     IORPC_OPCODE(IORPC_FORMAT_NONE, 0x120f)
+#define GXIO_MPIPE_OP_REGISTER_CLIENT_MEMORY IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x1210)
+#define GXIO_MPIPE_OP_LINK_OPEN_AUX    IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1211)
+#define GXIO_MPIPE_OP_LINK_CLOSE_AUX   IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1212)
+
+#define GXIO_MPIPE_OP_ARM_POLLFD       IORPC_OPCODE(IORPC_FORMAT_KERNEL_POLLFD, 0x9000)
+#define GXIO_MPIPE_OP_CLOSE_POLLFD     IORPC_OPCODE(IORPC_FORMAT_KERNEL_POLLFD, 0x9001)
+#define GXIO_MPIPE_OP_GET_MMIO_BASE    IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x8000)
+#define GXIO_MPIPE_OP_CHECK_MMIO_OFFSET IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x8001)
+
+int gxio_mpipe_alloc_buffer_stacks(gxio_mpipe_context_t * context,
+				   unsigned int count, unsigned int first,
+				   unsigned int flags);
+
+int gxio_mpipe_init_buffer_stack_aux(gxio_mpipe_context_t * context,
+				     void *mem_va, size_t mem_size,
+				     unsigned int mem_flags, unsigned int stack,
+				     unsigned int buffer_size_enum);
+
+
+int gxio_mpipe_alloc_notif_rings(gxio_mpipe_context_t * context,
+				 unsigned int count, unsigned int first,
+				 unsigned int flags);
+
+int gxio_mpipe_init_notif_ring_aux(gxio_mpipe_context_t * context, void *mem_va,
+				   size_t mem_size, unsigned int mem_flags,
+				   unsigned int ring);
+
+int gxio_mpipe_request_notif_ring_interrupt(gxio_mpipe_context_t * context,
+					    int inter_x, int inter_y,
+					    int inter_ipi, int inter_event,
+					    unsigned int ring);
+
+int gxio_mpipe_enable_notif_ring_interrupt(gxio_mpipe_context_t * context,
+					   unsigned int ring);
+
+int gxio_mpipe_alloc_notif_groups(gxio_mpipe_context_t * context,
+				  unsigned int count, unsigned int first,
+				  unsigned int flags);
+
+int gxio_mpipe_init_notif_group(gxio_mpipe_context_t * context,
+				unsigned int group,
+				gxio_mpipe_notif_group_bits_t bits);
+
+int gxio_mpipe_alloc_buckets(gxio_mpipe_context_t * context, unsigned int count,
+			     unsigned int first, unsigned int flags);
+
+int gxio_mpipe_init_bucket(gxio_mpipe_context_t * context, unsigned int bucket,
+			   MPIPE_LBL_INIT_DAT_BSTS_TBL_t bucket_info);
+
+int gxio_mpipe_alloc_edma_rings(gxio_mpipe_context_t * context,
+				unsigned int count, unsigned int first,
+				unsigned int flags);
+
+int gxio_mpipe_init_edma_ring_aux(gxio_mpipe_context_t * context, void *mem_va,
+				  size_t mem_size, unsigned int mem_flags,
+				  unsigned int ring, unsigned int channel);
+
+
+int gxio_mpipe_commit_rules(gxio_mpipe_context_t * context, const void *blob,
+			    size_t blob_size);
+
+int gxio_mpipe_register_client_memory(gxio_mpipe_context_t * context,
+				      unsigned int iotlb, HV_PTE pte,
+				      unsigned int flags);
+
+int gxio_mpipe_link_open_aux(gxio_mpipe_context_t * context,
+			     _gxio_mpipe_link_name_t name, unsigned int flags);
+
+int gxio_mpipe_link_close_aux(gxio_mpipe_context_t * context, int mac);
+
+
+int gxio_mpipe_arm_pollfd(gxio_mpipe_context_t * context, int pollfd_cookie);
+
+int gxio_mpipe_close_pollfd(gxio_mpipe_context_t * context, int pollfd_cookie);
+
+int gxio_mpipe_get_mmio_base(gxio_mpipe_context_t * context, HV_PTE *base);
+
+int gxio_mpipe_check_mmio_offset(gxio_mpipe_context_t * context,
+				 unsigned long offset, unsigned long size);
+
+#endif /* !__GXIO_MPIPE_LINUX_RPC_H__ */
diff --git a/arch/tile/include/gxio/iorpc_mpipe_info.h b/arch/tile/include/gxio/iorpc_mpipe_info.h
new file mode 100644
index 0000000..965a94d
--- /dev/null
+++ b/arch/tile/include/gxio/iorpc_mpipe_info.h
@@ -0,0 +1,46 @@
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
+#ifndef __GXIO_MPIPE_INFO_LINUX_RPC_H__
+#define __GXIO_MPIPE_INFO_LINUX_RPC_H__
+
+#include <hv/iorpc.h>
+
+#include <hv/drv_mpipe_intf.h>
+#include <asm/page.h>
+#include <gxio/kiorpc.h>
+#include <gxio/mpipe.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <asm/pgtable.h>
+
+
+#define GXIO_MPIPE_INFO_OP_ENUMERATE_AUX IORPC_OPCODE(IORPC_FORMAT_NONE, 0x1251)
+#define GXIO_MPIPE_INFO_OP_GET_MMIO_BASE IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x8000)
+#define GXIO_MPIPE_INFO_OP_CHECK_MMIO_OFFSET IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x8001)
+
+
+int gxio_mpipe_info_enumerate_aux(gxio_mpipe_info_context_t * context,
+				  unsigned int idx,
+				  _gxio_mpipe_link_name_t * name,
+				  _gxio_mpipe_link_mac_t * mac);
+
+int gxio_mpipe_info_get_mmio_base(gxio_mpipe_info_context_t * context,
+				  HV_PTE *base);
+
+int gxio_mpipe_info_check_mmio_offset(gxio_mpipe_info_context_t * context,
+				      unsigned long offset, unsigned long size);
+
+#endif /* !__GXIO_MPIPE_INFO_LINUX_RPC_H__ */
diff --git a/arch/tile/include/gxio/mpipe.h b/arch/tile/include/gxio/mpipe.h
new file mode 100644
index 0000000..7c9df46
--- /dev/null
+++ b/arch/tile/include/gxio/mpipe.h
@@ -0,0 +1,1986 @@
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
+#ifndef _GXIO_MPIPE_H_
+#define _GXIO_MPIPE_H_
+
+/*
+ *
+ * An API for allocating, configuring, and manipulating mPIPE hardware
+ * resources.
+ */
+
+#include "common.h"
+#include "dma_queue.h"
+
+#include <arch/mpipe_def.h>
+#include <arch/mpipe_shm.h>
+
+#include <hv/drv_mpipe_intf.h>
+#include <hv/iorpc.h>
+
+/*
+ *
+ * The TILE-Gx mPIPE&tm; shim provides Ethernet connectivity, packet
+ * classification, and packet load balancing services.  The
+ * gxio_mpipe_ API, declared in <gxio/mpipe.h>, allows applications to
+ * allocate mPIPE IO channels, configure packet distribution
+ * parameters, and send and receive Ethernet packets.  The API is
+ * designed to be a minimal wrapper around the mPIPE hardware, making
+ * system calls only where necessary to preserve inter-process
+ * protection guarantees.
+ *
+ * The APIs described below allow the programmer to allocate and
+ * configure mPIPE resources.  As described below, the mPIPE is a
+ * single shared hardware device that provides partitionable resources
+ * that are shared between all applications in the system.  The
+ * gxio_mpipe_ API allows userspace code to make resource request
+ * calls to the hypervisor, which in turns keeps track of the
+ * resources in use by all applications, maintains protection
+ * guarantees, and resets resources upon application shutdown.
+ *
+ * We strongly recommend reading the mPIPE section of the IO Device
+ * Guide (UG404) before working with this API.  Most functions in the
+ * gxio_mpipe_ API are directly analogous to hardware interfaces and
+ * the documentation assumes that the reader understands those
+ * hardware interfaces.
+ *
+ * @section mpipe__ingress mPIPE Ingress Hardware Resources
+ *
+ * The mPIPE ingress hardware provides extensive hardware offload for
+ * tasks like packet header parsing, load balancing, and memory
+ * management.  This section provides a brief introduction to the
+ * hardware components and the gxio_mpipe_ calls used to manage them;
+ * see the IO Device Guide for a much more detailed description of the
+ * mPIPE's capabilities.
+ *
+ * When a packet arrives at one of the mPIPE's Ethernet MACs, it is
+ * assigned a channel number indicating which MAC received it.  It
+ * then proceeds through the following hardware pipeline:
+ *
+ * @subsection mpipe__classification Classification
+ *
+ * A set of classification processors run header parsing code on each
+ * incoming packet, extracting information including the destination
+ * MAC address, VLAN, Ethernet type, and five-tuple hash.  Some of
+ * this information is then used to choose which buffer stack will be
+ * used to hold the packet, and which bucket will be used by the load
+ * balancer to determine which application will receive the packet.
+ *
+ * The rules by which the buffer stack and bucket are chosen can be
+ * configured via the @ref gxio_mpipe_classifier API.  A given app can
+ * specify multiple rules, each one specifying a bucket range, and a
+ * set of buffer stacks, to be used for packets matching the rule.
+ * Each rule can optionally specify a restricted set of channels,
+ * VLANs, and/or dMACs, in which it is interested.  By default, a
+ * given rule starts out matching all channels associated with the
+ * mPIPE context's set of open links; all VLANs; and all dMACs.
+ * Subsequent restrictions can then be added.
+ *
+ * @subsection mpipe__load_balancing Load Balancing
+ *
+ * The mPIPE load balancer is responsible for choosing the NotifRing
+ * to which the packet will be delivered.  This decision is based on
+ * the bucket number indicated by the classification program.  In
+ * general, the bucket number is based on some number of low bits of
+ * the packet's flow hash (applications that aren't interested in flow
+ * hashing use a single bucket).  Each load balancer bucket keeps a
+ * record of the NotifRing to which packets directed to that bucket
+ * are currently being delivered.  Based on the bucket's load
+ * balancing mode (@ref gxio_mpipe_bucket_mode_t), the load balancer
+ * either forwards the packet to the previously assigned NotifRing or
+ * decides to choose a new NotifRing.  If a new NotifRing is required,
+ * the load balancer chooses the least loaded ring in the NotifGroup
+ * associated with the bucket.
+ *
+ * The load balancer is a shared resource.  Each application needs to
+ * explicitly allocate NotifRings, NotifGroups, and buckets, using
+ * gxio_mpipe_alloc_notif_rings(), gxio_mpipe_alloc_notif_groups(),
+ * and gxio_mpipe_alloc_buckets().  Then the application needs to
+ * configure them using gxio_mpipe_init_notif_ring() and
+ * gxio_mpipe_init_notif_group_and_buckets().
+ *
+ * @subsection mpipe__buffers Buffer Selection and Packet Delivery
+ *
+ * Once the load balancer has chosen the destination NotifRing, the
+ * mPIPE DMA engine pops at least one buffer off of the 'buffer stack'
+ * chosen by the classification program and DMAs the packet data into
+ * that buffer.  Each buffer stack provides a hardware-accelerated
+ * stack of data buffers with the same size.  If the packet data is
+ * larger than the buffers provided by the chosen buffer stack, the
+ * mPIPE hardware pops off multiple buffers and chains the packet data
+ * through a multi-buffer linked list.  Once the packet data is
+ * delivered to the buffer(s), the mPIPE hardware writes the
+ * ::gxio_mpipe_idesc_t metadata object (calculated by the classifier)
+ * into the NotifRing and increments the number of packets delivered
+ * to that ring.
+ *
+ * Applications can push buffers onto a buffer stack by calling
+ * gxio_mpipe_push_buffer() or by egressing a packet with the
+ * ::gxio_mpipe_edesc_t::hwb bit set, indicating that the egressed
+ * buffers should be returned to the stack.
+ *
+ * Applications can allocate and initialize buffer stacks with the
+ * gxio_mpipe_alloc_buffer_stacks() and gxio_mpipe_init_buffer_stack()
+ * APIs.
+ *
+ * The application must also register the memory pages that will hold
+ * packets.  This requires calling gxio_mpipe_register_page() for each
+ * memory page that will hold packets allocated by the application for
+ * a given buffer stack.  Since each buffer stack is limited to 16
+ * registered pages, it may be necessary to use huge pages, or even
+ * extremely huge pages, to hold all the buffers.
+ *
+ * @subsection mpipe__iqueue NotifRings
+ *
+ * Each NotifRing is a region of shared memory, allocated by the
+ * application, to which the mPIPE delivers packet descriptors
+ * (::gxio_mpipe_idesc_t).  The application can allocate them via
+ * gxio_mpipe_alloc_notif_rings().  The application can then either
+ * explicitly initialize them with gxio_mpipe_init_notif_ring() and
+ * then read from them manually, or can make use of the convenience
+ * wrappers provided by @ref gxio_mpipe_wrappers.
+ *
+ * @section mpipe__egress mPIPE Egress Hardware
+ *
+ * Applications use eDMA rings to queue packets for egress.  The
+ * application can allocate them via gxio_mpipe_alloc_edma_rings().
+ * The application can then either explicitly initialize them with
+ * gxio_mpipe_init_edma_ring() and then write to them manually, or
+ * can make use of the convenience wrappers provided by
+ * @ref gxio_mpipe_wrappers.
+ *
+ * @section gxio__shortcomings Plans for Future API Revisions
+ *
+ * The API defined here is only an initial version of the mPIPE API.
+ * Future plans include:
+ *
+ * - Higher level wrapper functions to provide common initialization
+ * patterns.  This should help users start writing mPIPE programs
+ * without having to learn the details of the hardware.
+ *
+ * - Support for reset and deallocation of resources, including
+ * cleanup upon application shutdown.
+ *
+ * - Support for calling these APIs in the BME.
+ *
+ * - Support for IO interrupts.
+ *
+ * - Clearer definitions of thread safety guarantees.
+ *
+ * @section gxio__mpipe_examples Examples
+ *
+ * See the following mPIPE example programs for more information about
+ * allocating mPIPE resources and using them in real applications:
+ *
+ * - @ref mpipe/ingress/app.c : Receiving packets.
+ *
+ * - @ref mpipe/forward/app.c : Forwarding packets.
+ *
+ * Note that there are several more examples.
+ */
+
+/* Flags that can be passed to resource allocation functions. */
+enum gxio_mpipe_alloc_flags_e {
+  /* Require an allocation to start at a specified resource index. */
+	GXIO_MPIPE_ALLOC_FIXED = HV_MPIPE_ALLOC_FIXED,
+};
+
+/* Flags that can be passed to memory registration functions. */
+enum gxio_mpipe_mem_flags_e {
+  /* Do not fill L3 when writing, and invalidate lines upon egress. */
+	GXIO_MPIPE_MEM_FLAG_NT_HINT = IORPC_MEM_BUFFER_FLAG_NT_HINT,
+
+  /* L3 cache fills should only populate IO cache ways. */
+	GXIO_MPIPE_MEM_FLAG_IO_PIN = IORPC_MEM_BUFFER_FLAG_IO_PIN,
+};
+
+/* An ingress packet descriptor.  When a packet arrives, the mPIPE
+ * hardware generates this structure and writes it into a
+ * NotifRing.
+ */
+typedef MPIPE_PDESC_t gxio_mpipe_idesc_t;
+
+/* An egress packet descriptor.  Applications write this structure
+ * into eDMA rings and the hardware performs the indicated egress
+ * command.
+ */
+typedef MPIPE_EDMA_DESC_t gxio_mpipe_edesc_t;
+
+/* Get the "va" field from an "idesc".
+ *
+ * This is the address at which the ingress hardware copied the first
+ * byte of the packet.
+ *
+ * If the classifier detected a custom header, then this will point to
+ * the custom header, and gxio_mpipe_idesc_get_l2_start() will point
+ * to the actual L2 header.
+ *
+ * Note that this value may be misleading if "idesc->be" is set.
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline unsigned char *gxio_mpipe_idesc_get_va(gxio_mpipe_idesc_t * idesc)
+{
+	return (unsigned char *)(long)idesc->va;
+}
+
+/* Get the "xfer_size" from an "idesc".
+ *
+ * This is the actual number of packet bytes transferred into memory
+ * by the hardware.
+ *
+ * Note that this value may be misleading if "idesc->be" is set.
+ *
+ * @param idesc An ingress packet descriptor.
+ *
+ * ISSUE: Is this the best name for this?
+ * FIXME: Add more docs about chaining, clipping, etc.
+ */
+static inline unsigned int
+gxio_mpipe_idesc_get_xfer_size(gxio_mpipe_idesc_t * idesc)
+{
+	return idesc->l2_size;
+}
+
+/* Get the "flow_hash" from an "idesc".
+ *
+ * Extremely customized classifiers might not support this function.
+ *
+ * The default classifier uses a five-tuple hash (src/dest IP addr,
+ * src/dest port, protocol) for IPv4/IPv6 TCP/UDP packets, a two-tuple
+ * hash (src/dest IP addr) for other IPv4/IPv6 packets, and otherwise
+ * a two-tuple hash (dest/src mac addr).
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline uint32_t
+gxio_mpipe_idesc_get_flow_hash(gxio_mpipe_idesc_t * idesc)
+{
+	return idesc->custom0;
+}
+
+/* Get the "vlan" from an "idesc".
+ *
+ * Extremely customized classifiers might not support this function.
+ *
+ * The default classifier uses a vlan of 0xFFFF unless it processed
+ * a known vlan-encapsulating ethertype, in which case this will be
+ * one of the encapsulated vlans.
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline uint16_t gxio_mpipe_idesc_get_vlan(gxio_mpipe_idesc_t * idesc)
+{
+	return (idesc->custom1 >> 0) & 0xFFFF;
+}
+
+/* Get the "ethertype" from an "idesc".
+ *
+ * Extremely customized classifiers might not support this function.
+ *
+ * This is normally the final ethertype detected by the classifier.
+ *
+ * The default classifier only understands a few basic ethertypes.
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline uint16_t
+gxio_mpipe_idesc_get_ethertype(gxio_mpipe_idesc_t * idesc)
+{
+	return (idesc->custom1 >> 16) & 0xFFFF;
+}
+
+/* Get the "l2_offset" from an "idesc".
+ *
+ * Extremely customized classifiers might not support this function.
+ *
+ * This is the number of bytes between the "va" and the L2 header.
+ *
+ * The L2 header consists of a destination mac address, a source mac
+ * address, and an initial ethertype.  Various initial ethertypes
+ * allow encoding extra information in the L2 header, often including
+ * a vlan, and/or a new ethertype.
+ *
+ * Note that the "l2_offset" will be non-zero if (and only if) the
+ * classifier processed a custom header for the packet.
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline uint8_t gxio_mpipe_idesc_get_l2_offset(gxio_mpipe_idesc_t * idesc)
+{
+	return (idesc->custom1 >> 32) & 0xFF;
+}
+
+/* Get the "l2_start" from an "idesc".
+ *
+ * This is simply gxio_mpipe_idesc_get_va() plus
+ * gxio_mpipe_idesc_get_l2_offset().
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline unsigned char *gxio_mpipe_idesc_get_l2_start(gxio_mpipe_idesc_t *
+							   idesc)
+{
+	unsigned char *va = gxio_mpipe_idesc_get_va(idesc);
+	return va + gxio_mpipe_idesc_get_l2_offset(idesc);
+}
+
+/* Get the "l2_length" from an "idesc".
+ *
+ * This is simply gxio_mpipe_idesc_get_xfer_size() minus
+ * gxio_mpipe_idesc_get_l2_offset().
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline unsigned int
+gxio_mpipe_idesc_get_l2_length(gxio_mpipe_idesc_t * idesc)
+{
+	unsigned int xfer_size = idesc->l2_size;
+	return xfer_size - gxio_mpipe_idesc_get_l2_offset(idesc);
+}
+
+/* Get the "l3_offset" from an "idesc".
+ *
+ * Extremely customized classifiers might not support this function.
+ *
+ * This is the number of bytes between the "va" and the L3 header,
+ * or, if the classifier was unable to identify the L3 header, then
+ * the first byte after the last known ethertype.
+ *
+ * The default classifier knows that ethertype 0x0800 indicates an
+ * IPv4 L3 header and ethertype 0x0866 indicates an IPv6 L3 header.
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline uint8_t gxio_mpipe_idesc_get_l3_offset(gxio_mpipe_idesc_t * idesc)
+{
+	return (idesc->custom1 >> 40) & 0xFF;
+}
+
+/* Get the "l3_start" from an "idesc".
+ *
+ * This is simply gxio_mpipe_idesc_get_va() plus
+ * gxio_mpipe_idesc_get_l3_offset().
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline unsigned char *gxio_mpipe_idesc_get_l3_start(gxio_mpipe_idesc_t *
+							   idesc)
+{
+	unsigned char *va = gxio_mpipe_idesc_get_va(idesc);
+	return va + gxio_mpipe_idesc_get_l3_offset(idesc);
+}
+
+/* Get the "l3_length" from an "idesc".
+ *
+ * This is simply gxio_mpipe_idesc_get_xfer_size() minus
+ * gxio_mpipe_idesc_get_l3_offset().
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline unsigned int
+gxio_mpipe_idesc_get_l3_length(gxio_mpipe_idesc_t * idesc)
+{
+	unsigned int xfer_size = idesc->l2_size;
+	return xfer_size - gxio_mpipe_idesc_get_l3_offset(idesc);
+}
+
+/* Get the "l4_offset" from an "idesc".
+ *
+ * Extremely customized classifiers might not support this function.
+ *
+ * This is the number of bytes between the "va" and the first byte of
+ * the L4 header, or, if the classifier was unable to properly parse
+ * the L3 header, then zero.
+ *
+ * The default classifier sets "l4_offset" (only) for IPv4/IPv6 packets.
+ *
+ * For IPv4/IPv6 TCP packets, the "l4_start" points at the TCP header.
+ *
+ * For IPv4/IPv6 UDP packets, the "l4_start" points at the UDP header.
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline uint8_t gxio_mpipe_idesc_get_l4_offset(gxio_mpipe_idesc_t * idesc)
+{
+	return (idesc->custom1 >> 48) & 0xFF;
+}
+
+/* Get the "l4_start" from an "idesc".
+ *
+ * This is simply gxio_mpipe_idesc_get_va() plus
+ * gxio_mpipe_idesc_get_l4_offset().
+ *
+ * Note that if "l4_offset" is zero, then this function is pointless.
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline unsigned char *gxio_mpipe_idesc_get_l4_start(gxio_mpipe_idesc_t *
+							   idesc)
+{
+	unsigned char *va = gxio_mpipe_idesc_get_va(idesc);
+	return va + gxio_mpipe_idesc_get_l4_offset(idesc);
+}
+
+/* Get the "l4_length" from an "idesc".
+ *
+ * This is simply gxio_mpipe_idesc_get_xfer_size() minus
+ * gxio_mpipe_idesc_get_l4_offset().
+ *
+ * Note that if "l4_offset" is zero, then this function is pointless.
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline unsigned int
+gxio_mpipe_idesc_get_l4_length(gxio_mpipe_idesc_t * idesc)
+{
+	unsigned int xfer_size = idesc->l2_size;
+	return xfer_size - gxio_mpipe_idesc_get_l4_offset(idesc);
+}
+
+/* Get the "status" from an "idesc".
+ *
+ * Extremely customized classifiers might not support this function.
+ *
+ * The "status" is a set of bit flags.
+ *
+ * Bit 0x80 indicates that the packet is "bad".
+ *
+ * @param idesc An ingress packet descriptor.
+ */
+static inline uint8_t gxio_mpipe_idesc_get_status(gxio_mpipe_idesc_t * idesc)
+{
+	return (idesc->custom1 >> 56) & 0xFF;
+}
+
+/* Determine if a packet descriptor is "bad".
+ *
+ * This function checks for three "bad" conditions.
+ *
+ * (1) The packet has a bad IPv4 header checksum, as evidenced by
+ * "(gxio_mpipe_idesc_get_status(idesc) & 0x80) != 0".
+ *
+ * (2) The packet has a bad TCP/UDP checksum, as evidenced by
+ * "idesc->cs && idesc->csum_seed_val != 0xFFFF".
+ *
+ * (3) The packet has a buffer error, as evidenced by "idesc->be".
+ *
+ * See also gxio_mpipe_iqueue_drop_if_bad().
+ *
+ * @param idesc An ingress packet descriptor.
+ * @return 1 if packet is "bad", or 0 otherwise.
+ */
+static inline int gxio_mpipe_idesc_is_bad(gxio_mpipe_idesc_t * idesc)
+{
+	return ((gxio_mpipe_idesc_get_status(idesc) & 0x80) ||
+		(idesc->cs && (idesc->csum_seed_val != 0xFFFF)) || idesc->be);
+}
+
+/* Initialize an "edesc" from some fields in an "idesc".
+ *
+ * In particular, this function zeros out the edesc, and then sets
+ * "edesc->bound" to one, and "edesc->xfer_size" to "idesc->l2_size",
+ * and then copies the "va", "stack_idx", "inst", "hwb", "size", and
+ * "c" fields from "idesc", in a fairly efficient manner.
+ *
+ * If "idesc->be" is set, then this function will set "edesc->ns" to
+ * one, and "edesc->xfer_size" to zero.
+ *
+ * @param edesc An egress packet descriptor.
+ * @param idesc An ingress packet descriptor.
+ */
+static inline void
+gxio_mpipe_edesc_copy_idesc(gxio_mpipe_edesc_t * edesc,
+			    gxio_mpipe_idesc_t * idesc)
+{
+	edesc->words[0] = 0;
+	edesc->words[1] = idesc->words[7];
+	edesc->ns = idesc->be;
+	edesc->bound = 1;
+	edesc->xfer_size = idesc->be ? 0 : idesc->l2_size;
+}
+
+/* Set the "va" field in an "edesc".
+ *
+ * @param edesc An egress packet descriptor.
+ * @param va The address of some packet data.
+ */
+static inline void gxio_mpipe_edesc_set_va(gxio_mpipe_edesc_t * edesc, void *va)
+{
+	edesc->va = (unsigned long)va;
+}
+
+/* A context object used to manage mPIPE hardware resources. */
+typedef struct {
+
+  /* File descriptor for calling up to Linux (and thus the HV). */
+	int fd;
+
+  /* The VA at which configuration registers are mapped. */
+	char *mmio_cfg_base;
+
+  /* The VA at which IDMA, EDMA, and buffer manager are mapped. */
+	char *mmio_fast_base;
+
+  /* The "initialized" buffer stacks. */
+	gxio_mpipe_rules_stacks_t __stacks;
+
+} gxio_mpipe_context_t;
+
+/* This is only used internally, but it's most easily made visible here. */
+typedef gxio_mpipe_context_t gxio_mpipe_info_context_t;
+
+/* Initialize an mPIPE context.
+ *
+ * This function allocates an mPIPE "service domain" and maps the MMIO
+ * registers into the caller's VA space.
+ *
+ * @param context Context object to be initialized.
+ * @param mpipe_instance Instance number of mPIPE shim to be controlled via
+ *  context.
+ */
+extern int
+gxio_mpipe_init(gxio_mpipe_context_t * context, unsigned int mpipe_instance);
+
+/*****************************************************************
+ *                         Buffer Stacks                          *
+ ******************************************************************/
+
+/* Allocate a set of buffer stacks.
+ *
+ * The return value is NOT interesting if count is zero.
+ *
+ * @param context An initialized mPIPE context.
+ * @param count Number of stacks required.
+ * @param first Index of first stack if ::GXIO_MPIPE_ALLOC_FIXED flag is set,
+ *   otherwise ignored.
+ * @param flags Flag bits from ::gxio_mpipe_alloc_flags_e.
+ * @return Index of first allocated buffer stack, or
+ * ::GXIO_MPIPE_ERR_NO_BUFFER_STACK if allocation failed.
+ */
+extern int
+gxio_mpipe_alloc_buffer_stacks(gxio_mpipe_context_t * context,
+			       unsigned int count, unsigned int first,
+			       unsigned int flags);
+
+/* Enum codes for buffer sizes supported by mPIPE. */
+typedef enum {
+  /* 128 byte packet data buffer. */
+	GXIO_MPIPE_BUFFER_SIZE_128 = MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_128,
+  /* 256 byte packet data buffer. */
+	GXIO_MPIPE_BUFFER_SIZE_256 = MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_256,
+  /* 512 byte packet data buffer. */
+	GXIO_MPIPE_BUFFER_SIZE_512 = MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_512,
+  /* 1024 byte packet data buffer. */
+	GXIO_MPIPE_BUFFER_SIZE_1024 = MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_1024,
+  /* 1664 byte packet data buffer. */
+	GXIO_MPIPE_BUFFER_SIZE_1664 = MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_1664,
+  /* 4096 byte packet data buffer. */
+	GXIO_MPIPE_BUFFER_SIZE_4096 = MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_4096,
+  /* 10368 byte packet data buffer. */
+	GXIO_MPIPE_BUFFER_SIZE_10368 = MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_10368,
+  /* 16384 byte packet data buffer. */
+	GXIO_MPIPE_BUFFER_SIZE_16384 = MPIPE_BSM_INIT_DAT_1__SIZE_VAL_BSZ_16384
+} gxio_mpipe_buffer_size_enum_t;
+
+/* Convert a buffer size in bytes into a buffer size enum. */
+extern gxio_mpipe_buffer_size_enum_t
+gxio_mpipe_buffer_size_to_buffer_size_enum(size_t size);
+
+/* Convert a buffer size enum into a buffer size in bytes. */
+extern size_t
+gxio_mpipe_buffer_size_enum_to_buffer_size(gxio_mpipe_buffer_size_enum_t
+					   buffer_size_enum);
+
+/* Calculate the number of bytes required to store a given number of
+ * buffers in the memory registered with a buffer stack via
+ * gxio_mpipe_init_buffer_stack().
+ */
+extern size_t gxio_mpipe_calc_buffer_stack_bytes(unsigned long buffers);
+
+/* Initialize a buffer stack.  This function binds a region of memory
+ * to be used by the hardware for storing buffer addresses pushed via
+ * gxio_mpipe_push_buffer() or as the result of sending a buffer out
+ * the egress with the 'push to stack when done' bit set.  Once this
+ * function returns, the memory region's contents may be arbitrarily
+ * modified by the hardware at any time and software should not access
+ * the memory region again.
+ *
+ * @param context An initialized mPIPE context.
+ * @param stack The buffer stack index.
+ * @param buffer_size_enum The size of each buffer in the buffer stack,
+ * as an enum.
+ * @param mem The address of the buffer stack.  This memory must be
+ * physically contiguous and aligned to a 64kB boundary.
+ * @param mem_size The size of the buffer stack, in bytes.
+ * @param mem_flags ::gxio_mpipe_mem_flags_e memory flags.
+ * @return Zero on success, ::GXIO_MPIPE_ERR_INVAL_BUFFER_SIZE if
+ * buffer_size_enum is invalid, ::GXIO_MPIPE_ERR_BAD_BUFFER_STACK if
+ * stack has not been allocated.
+ */
+extern int
+gxio_mpipe_init_buffer_stack(gxio_mpipe_context_t * context,
+			     unsigned int stack,
+			     gxio_mpipe_buffer_size_enum_t buffer_size_enum,
+			     void *mem, size_t mem_size,
+			     unsigned int mem_flags);
+
+/* Push a buffer onto a previously initialized buffer stack.
+ *
+ * The size of the buffer being pushed must match the size that was
+ * registered with gxio_mpipe_init_buffer_stack().  All packet buffer
+ * addresses are 128-byte aligned; the low 7 bits of the specified
+ * buffer address will be ignored.
+ *
+ * @param context An initialized mPIPE context.
+ * @param stack The buffer stack index.
+ * @param buffer The buffer (the low seven bits are ignored).
+ */
+static inline void
+gxio_mpipe_push_buffer(gxio_mpipe_context_t * context,
+		       unsigned int stack, void *buffer)
+{
+	MPIPE_BSM_REGION_ADDR_t offset = { {0} };
+	MPIPE_BSM_REGION_VAL_t val = { {0} };
+
+	/*
+	 * The mmio_fast_base region starts at the IDMA region, so subtract
+	 * off that initial offset.
+	 */
+	offset.region =
+	    MPIPE_MMIO_ADDR__REGION_VAL_BSM - MPIPE_MMIO_ADDR__REGION_VAL_IDMA;
+	offset.stack = stack;
+
+#if __SIZEOF_POINTER__ == 4
+	val.va = ((unsigned long)buffer) >> MPIPE_BSM_REGION_VAL__VA_SHIFT;
+#else
+	val.va = ((long)buffer) >> MPIPE_BSM_REGION_VAL__VA_SHIFT;
+#endif
+
+	__gxio_mmio_write(context->mmio_fast_base + offset.word, val.word);
+}
+
+/* Pop a buffer off of a previously initialized buffer stack.
+ *
+ * @param context An initialized mPIPE context.
+ * @param stack The buffer stack index.
+ * @return The buffer, or NULL is the stack is empty.
+ */
+static inline void *gxio_mpipe_pop_buffer(gxio_mpipe_context_t * context,
+					  unsigned int stack)
+{
+	MPIPE_BSM_REGION_ADDR_t offset = { {0} };
+
+	/*
+	 * The mmio_fast_base region starts at the IDMA region, so subtract
+	 * off that initial offset.
+	 */
+	offset.region =
+	    MPIPE_MMIO_ADDR__REGION_VAL_BSM - MPIPE_MMIO_ADDR__REGION_VAL_IDMA;
+	offset.stack = stack;
+
+	while (1) {
+		/*
+		 * Case 1: val.c == ..._UNCHAINED, va is non-zero.
+		 * Case 2: val.c == ..._INVALID, va is zero.
+		 * Case 3: val.c == ..._NOT_RDY, va is zero.
+		 */
+		MPIPE_BSM_REGION_VAL_t val;
+		val.word =
+		    __gxio_mmio_read(context->mmio_fast_base + offset.word);
+
+		/*
+		 * Handle case 1 and 2 by returning the buffer (or NULL).
+		 * Handle case 3 by waiting for the prefetch buffer to refill.
+		 */
+		if (val.c != MPIPE_EDMA_DESC_WORD1__C_VAL_NOT_RDY)
+			return (void *)((unsigned long)val.
+					va << MPIPE_BSM_REGION_VAL__VA_SHIFT);
+	}
+}
+
+/*****************************************************************
+ *                          NotifRings                            *
+ ******************************************************************/
+
+/* Allocate a set of NotifRings.
+ *
+ * The return value is NOT interesting if count is zero.
+ *
+ * Note that NotifRings are allocated in chunks, so allocating one at
+ * a time is much less efficient than allocating several at once.
+ *
+ * @param context An initialized mPIPE context.
+ * @param count Number of NotifRings required.
+ * @param first Index of first NotifRing if ::GXIO_MPIPE_ALLOC_FIXED flag
+ *   is set, otherwise ignored.
+ * @param flags Flag bits from ::gxio_mpipe_alloc_flags_e.
+ * @return Index of first allocated buffer NotifRing, or
+ * ::GXIO_MPIPE_ERR_NO_NOTIF_RING if allocation failed.
+ */
+extern int
+gxio_mpipe_alloc_notif_rings(gxio_mpipe_context_t * context,
+			     unsigned int count, unsigned int first,
+			     unsigned int flags);
+
+/* Initialize a NotifRing, using the given memory and size.
+ *
+ * @param context An initialized mPIPE context.
+ * @param ring The NotifRing index.
+ * @param mem A physically contiguous region of memory to be filled
+ * with a ring of ::gxio_mpipe_idesc_t structures.
+ * @param mem_size Number of bytes in the ring.  Must be 128, 512,
+ * 2048, or 65536 * sizeof(gxio_mpipe_idesc_t).
+ * @param mem_flags ::gxio_mpipe_mem_flags_e memory flags.
+ *
+ * @return 0 on success, ::GXIO_MPIPE_ERR_BAD_NOTIF_RING or
+ * ::GXIO_ERR_INVAL_MEMORY_SIZE on failure.
+ */
+extern int
+gxio_mpipe_init_notif_ring(gxio_mpipe_context_t * context,
+			   unsigned int ring,
+			   void *mem, size_t mem_size, unsigned int mem_flags);
+
+/* Configure an interrupt to be sent to a tile on incoming NotifRing
+ *  traffic.  Once an interrupt is sent for a particular ring, no more
+ *  will be sent until gxio_mica_enable_notif_ring_interrupt() is called.
+ *
+ * @param context An initialized mPIPE context.
+ * @param x X coordinate of interrupt target tile.
+ * @param y Y coordinate of interrupt target tile.
+ * @param i Index of the IPI register which will receive the interrupt.
+ * @param e Specific event which will be set in the target IPI register when
+ * the interrupt occurs.
+ * @param ring The NotifRing index.
+ * @return Zero on success, GXIO_ERR_INVAL if params are out of range.
+ */
+extern int
+gxio_mpipe_request_notif_ring_interrupt(gxio_mpipe_context_t * context,
+					int x, int y, int i, int e,
+					unsigned int ring);
+
+/* Enable an interrupt on incoming NotifRing traffic.
+ *
+ * @param context An initialized mPIPE context.
+ * @param ring The NotifRing index.
+ * @return Zero on success, GXIO_ERR_INVAL if params are out of range.
+ */
+extern int
+gxio_mpipe_enable_notif_ring_interrupt(gxio_mpipe_context_t * context,
+				       unsigned int ring);
+
+/* Map all of a client's memory via the given IOTLB.
+ * @param context An initialized mPIPE context.
+ * @param iotlb IOTLB index.
+ * @param pte Page table entry.
+ * @param flags Flags.
+ * @return Zero on success, or a negative error code.
+ */
+extern int
+gxio_mpipe_register_client_memory(gxio_mpipe_context_t * context,
+				  unsigned int iotlb, HV_PTE pte,
+				  unsigned int flags);
+
+/*****************************************************************
+ *                        Notif Groups                            *
+ ******************************************************************/
+
+/* Allocate a set of NotifGroups.
+ *
+ * The return value is NOT interesting if count is zero.
+ *
+ * @param context An initialized mPIPE context.
+ * @param count Number of NotifGroups required.
+ * @param first Index of first NotifGroup if ::GXIO_MPIPE_ALLOC_FIXED flag
+ *   is set, otherwise ignored.
+ * @param flags Flag bits from ::gxio_mpipe_alloc_flags_e.
+ * @return Index of first allocated buffer NotifGroup, or
+ * ::GXIO_MPIPE_ERR_NO_NOTIF_GROUP if allocation failed.
+ */
+extern int
+gxio_mpipe_alloc_notif_groups(gxio_mpipe_context_t * context,
+			      unsigned int count, unsigned int first,
+			      unsigned int flags);
+
+/* Add a NotifRing to a NotifGroup.  This only sets a bit in the
+ * application's 'group' object; the hardware NotifGroup can be
+ * initialized by passing 'group' to gxio_mpipe_init_notif_group() or
+ * gxio_mpipe_init_notif_group_and_buckets().
+ */
+static inline void
+gxio_mpipe_notif_group_add_ring(gxio_mpipe_notif_group_bits_t * bits, int ring)
+{
+	bits->ring_mask[ring / 64] |= (1ull << (ring % 64));
+}
+
+/* Set a particular NotifGroup bitmask.  Since the load balancer
+ * makes decisions based on both bucket and NotifGroup state, most
+ * applications should use gxio_mpipe_init_notif_group_and_buckets()
+ * rather than using this function to configure just a NotifGroup.
+ */
+extern int
+gxio_mpipe_init_notif_group(gxio_mpipe_context_t * context, unsigned int group,
+			    gxio_mpipe_notif_group_bits_t bits);
+
+/*****************************************************************
+ *                         Load Balancer                          *
+ ******************************************************************/
+
+/* Allocate a set of load balancer buckets.
+ *
+ * The return value is NOT interesting if count is zero.
+ *
+ * Note that buckets are allocated in chunks, so allocating one at
+ * a time is much less efficient than allocating several at once.
+ *
+ * Note that the buckets are actually divided into two sub-ranges, of
+ * different sizes, and different chunk sizes, and the range you get
+ * by default is determined by the size of the request.  Allocations
+ * cannot span the two sub-ranges.
+ *
+ * @param context An initialized mPIPE context.
+ * @param count Number of buckets required.
+ * @param first Index of first bucket if ::GXIO_MPIPE_ALLOC_FIXED flag is set,
+ *   otherwise ignored.
+ * @param flags Flag bits from ::gxio_mpipe_alloc_flags_e.
+ * @return Index of first allocated buffer bucket, or
+ * ::GXIO_MPIPE_ERR_NO_BUCKET if allocation failed.
+ */
+extern int
+gxio_mpipe_alloc_buckets(gxio_mpipe_context_t * context,
+			 unsigned int count, unsigned int first,
+			 unsigned int flags);
+
+/* The legal modes for gxio_mpipe_bucket_info_t and
+ * gxio_mpipe_init_notif_group_and_buckets().
+ *
+ * All modes except ::GXIO_MPIPE_BUCKET_ROUND_ROBIN expect that the user
+ * will allocate a power-of-two number of buckets and initialize them
+ * to the same mode.  The classifier program then uses the appropriate
+ * number of low bits from the incoming packet's flow hash to choose a
+ * load balancer bucket.  Based on that bucket's load balancing mode,
+ * reference count, and currently active NotifRing, the load balancer
+ * chooses the NotifRing to which the packet will be delivered.
+ */
+typedef enum {
+  /* All packets for a bucket go to the same NotifRing unless the
+   * NotifRing gets full, in which case packets will be dropped.  If
+   * the bucket reference count ever reaches zero, a new NotifRing may
+   * be chosen.
+   */
+	GXIO_MPIPE_BUCKET_DYNAMIC_FLOW_AFFINITY
+	    = MPIPE_LBL_INIT_DAT_BSTS_TBL__MODE_VAL_DFA,
+
+  /* All packets for a bucket always go to the same NotifRing.
+   */
+	GXIO_MPIPE_BUCKET_STATIC_FLOW_AFFINITY
+	    = MPIPE_LBL_INIT_DAT_BSTS_TBL__MODE_VAL_FIXED,
+
+  /* All packets for a bucket go to the least full NotifRing in the
+   * group, providing load balancing round robin behavior.
+   */
+	GXIO_MPIPE_BUCKET_ROUND_ROBIN
+	    = MPIPE_LBL_INIT_DAT_BSTS_TBL__MODE_VAL_ALWAYS_PICK,
+
+  /* All packets for a bucket go to the same NotifRing unless the
+   * NotifRing gets full, at which point the bucket starts using the
+   * least full NotifRing in the group.  If all NotifRings in the
+   * group are full, packets will be dropped.
+   */
+	GXIO_MPIPE_BUCKET_STICKY_FLOW_LOCALITY
+	    = MPIPE_LBL_INIT_DAT_BSTS_TBL__MODE_VAL_STICKY,
+
+  /* All packets for a bucket go to the same NotifRing unless the
+   * NotifRing gets full, or a random timer fires, at which point the
+   * bucket starts using the least full NotifRing in the group.  If
+   * all NotifRings in the group are full, packets will be dropped.
+   * WARNING: This mode is BROKEN on chips with fewer than 64 tiles.
+   */
+	GXIO_MPIPE_BUCKET_PREFER_FLOW_LOCALITY
+	    = MPIPE_LBL_INIT_DAT_BSTS_TBL__MODE_VAL_STICKY_RAND,
+
+} gxio_mpipe_bucket_mode_t;
+
+/* Copy a set of bucket initialization values into the mPIPE
+ * hardware.  Since the load balancer makes decisions based on both
+ * bucket and NotifGroup state, most applications should use
+ * gxio_mpipe_init_notif_group_and_buckets() rather than using this
+ * function to configure a single bucket.
+ *
+ * @param context An initialized mPIPE context.
+ * @param bucket Bucket index to be initialized.
+ * @param bucket_info Initial reference count, NotifRing index, and mode.
+ * @return 0 on success, ::GXIO_MPIPE_ERR_BAD_BUCKET on failure.
+ */
+extern int
+gxio_mpipe_init_bucket(gxio_mpipe_context_t * context, unsigned int bucket,
+		       gxio_mpipe_bucket_info_t bucket_info);
+
+/* Initializes a group and range of buckets and range of rings such
+ * that the load balancer runs a particular load balancing function.
+ *
+ * First, the group is initialized with the given rings.
+ *
+ * Second, each bucket is initialized with the mode and group, and a
+ * ring chosen round-robin from the given rings.
+ *
+ * Normally, the classifier picks a bucket, and then the load balancer
+ * picks a ring, based on the bucket's mode, group, and current ring,
+ * possibly updating the bucket's ring.
+ *
+ * @param context An initialized mPIPE context.
+ * @param group The group.
+ * @param ring The first ring.
+ * @param num_rings The number of rings.
+ * @param bucket The first bucket.
+ * @param num_buckets The number of buckets.
+ * @param mode The load balancing mode.
+ *
+ * @return 0 on success, ::GXIO_MPIPE_ERR_BAD_BUCKET,
+ * ::GXIO_MPIPE_ERR_BAD_NOTIF_GROUP, or
+ * ::GXIO_MPIPE_ERR_BAD_NOTIF_RING on failure.
+ */
+extern int
+gxio_mpipe_init_notif_group_and_buckets(gxio_mpipe_context_t * context,
+					unsigned int group,
+					unsigned int ring,
+					unsigned int num_rings,
+					unsigned int bucket,
+					unsigned int num_buckets,
+					gxio_mpipe_bucket_mode_t mode);
+
+/* Return credits to a NotifRing and/or bucket.
+ *
+ * @param context An initialized mPIPE context.
+ * @param ring The NotifRing index, or -1.
+ * @param bucket The bucket, or -1.
+ * @param count The number of credits to return.
+ */
+static inline void
+gxio_mpipe_credit(gxio_mpipe_context_t * context,
+		  int ring, int bucket, unsigned int count)
+{
+	/* NOTE: Fancy struct initialization would break "C89" header test. */
+
+	MPIPE_IDMA_RELEASE_REGION_ADDR_t offset = { {0} };
+	MPIPE_IDMA_RELEASE_REGION_VAL_t val = { {0} };
+
+	/*
+	 * The mmio_fast_base region starts at the IDMA region, so subtract
+	 * off that initial offset.
+	 */
+	offset.region =
+	    MPIPE_MMIO_ADDR__REGION_VAL_IDMA - MPIPE_MMIO_ADDR__REGION_VAL_IDMA;
+	offset.ring = ring;
+	offset.bucket = bucket;
+	offset.ring_enable = (ring >= 0);
+	offset.bucket_enable = (bucket >= 0);
+	val.count = count;
+
+	__gxio_mmio_write(context->mmio_fast_base + offset.word, val.word);
+}
+
+/*****************************************************************
+ *                         Egress Rings                           *
+ ******************************************************************/
+
+/* Allocate a set of eDMA rings.
+ *
+ * The return value is NOT interesting if count is zero.
+ *
+ * @param context An initialized mPIPE context.
+ * @param count Number of eDMA rings required.
+ * @param first Index of first eDMA ring if ::GXIO_MPIPE_ALLOC_FIXED flag
+ *   is set, otherwise ignored.
+ * @param flags Flag bits from ::gxio_mpipe_alloc_flags_e.
+ * @return Index of first allocated buffer eDMA ring, or
+ * ::GXIO_MPIPE_ERR_NO_EDMA_RING if allocation failed.
+ */
+extern int
+gxio_mpipe_alloc_edma_rings(gxio_mpipe_context_t * context,
+			    unsigned int count, unsigned int first,
+			    unsigned int flags);
+
+/* Initialize an eDMA ring, using the given memory and size.
+ *
+ * @param context An initialized mPIPE context.
+ * @param ring The eDMA ring index.
+ * @param channel The channel to use.  This must be one of the channels
+ * associated with the context's set of open links.
+ * @param mem A physically contiguous region of memory to be filled
+ * with a ring of ::gxio_mpipe_edesc_t structures.
+ * @param mem_size Number of bytes in the ring.  Must be 512, 2048,
+ * 8192 or 65536, times 16 (i.e. sizeof(gxio_mpipe_edesc_t)).
+ * @param mem_flags ::gxio_mpipe_mem_flags_e memory flags.
+ *
+ * @return 0 on success, ::GXIO_MPIPE_ERR_BAD_EDMA_RING or
+ * ::GXIO_ERR_INVAL_MEMORY_SIZE on failure.
+ */
+extern int
+gxio_mpipe_init_edma_ring(gxio_mpipe_context_t * context,
+			  unsigned int ring, unsigned int channel,
+			  void *mem, size_t mem_size, unsigned int mem_flags);
+
+/*****************************************************************
+ *                      Classifier Program                        *
+ ******************************************************************/
+
+/*
+ *
+ * Functions for loading or configuring the mPIPE classifier program.
+ *
+ * The mPIPE classification processors all run a special "classifier"
+ * program which, for each incoming packet, parses the packet headers,
+ * encodes some packet metadata in the "idesc", and either drops the
+ * packet, or picks a notif ring to handle the packet, and a buffer
+ * stack to contain the packet, usually based on the channel, VLAN,
+ * dMAC, flow hash, and packet size, under the guidance of the "rules"
+ * API described below.
+ *
+ * @section gxio_mpipe_classifier_default Default Classifier
+ *
+ * The MDE provides a simple "default" classifier program.  It is
+ * shipped as source in "$TILERA_ROOT/src/sys/mpipe/classifier.c",
+ * which serves as its official documentation.  It is shipped as a
+ * binary program in "$TILERA_ROOT/tile/boot/classifier", which is
+ * automatically included in bootroms created by "tile-monitor", and
+ * is automatically loaded by the hypervisor at boot time.
+ *
+ * The L2 analysis handles LLC packets, SNAP packets, and "VLAN
+ * wrappers" (keeping the outer VLAN).
+ *
+ * The L3 analysis handles IPv4 and IPv6, dropping packets with bad
+ * IPv4 header checksums, requesting computation of a TCP/UDP checksum
+ * if appropriate, and hashing the dest and src IP addresses, plus the
+ * ports for TCP/UDP packets, into the flow hash.  No special analysis
+ * is done for "fragmented" packets or "tunneling" protocols.  Thus,
+ * the first fragment of a fragmented TCP/UDP packet is hashed using
+ * src/dest IP address and ports and all subsequent fragments are only
+ * hashed according to src/dest IP address.
+ *
+ * The L3 analysis handles other packets too, hashing the dMAC
+ * smac into a flow hash.
+ *
+ * The channel, VLAN, and dMAC used to pick a "rule" (see the
+ * "rules" APIs below), which in turn is used to pick a buffer stack
+ * (based on the packet size) and a bucket (based on the flow hash).
+ *
+ * To receive traffic matching a particular (channel/VLAN/dMAC
+ * pattern, an application should allocate its own buffer stacks and
+ * load balancer buckets, and map traffic to those stacks and buckets,
+ * as decribed by the "rules" API below.
+ *
+ * Various packet metadata is encoded in the idesc.  The flow hash is
+ * four bytes at 0x0C.  The VLAN is two bytes at 0x10.  The ethtype is
+ * two bytes at 0x12.  The l3 start is one byte at 0x14.  The l4 start
+ * is one byte at 0x15 for IPv4 and IPv6 packets, and otherwise zero.
+ * The protocol is one byte at 0x16 for IPv4 and IPv6 packets, and
+ * otherwise zero.
+ *
+ * @section gxio_mpipe_classifier_custom Custom Classifiers.
+ *
+ * A custom classifier may be created using "tile-mpipe-cc" with a
+ * customized version of the default classifier sources.
+ *
+ * The custom classifier may be included in bootroms using the
+ * "--classifier" option to "tile-monitor", or loaded dynamically
+ * using gxio_mpipe_classifier_load_from_file().
+ *
+ * Be aware that "extreme" customizations may break the assumptions of
+ * the "rules" APIs described below, but simple customizations, such
+ * as adding new packet metadata, should be fine.
+ */
+
+/* A set of classifier rules, plus a context. */
+typedef struct {
+
+  /* The context. */
+	gxio_mpipe_context_t *context;
+
+  /* The actual rules. */
+	gxio_mpipe_rules_list_t list;
+
+} gxio_mpipe_rules_t;
+
+/* Initialize a classifier program rules list.
+ *
+ * This function can be called on a previously initialized rules list
+ * to discard any previously added rules.
+ *
+ * @param rules Rules list to initialize.
+ * @param context An initialized mPIPE context.
+ */
+extern void
+gxio_mpipe_rules_init(gxio_mpipe_rules_t * rules,
+		      gxio_mpipe_context_t * context);
+
+/* Begin a new rule on the indicated rules list.
+ *
+ * Note that an empty rule matches all packets, but an empty rule list
+ * matches no packets.
+ *
+ * @param rules Rules list to which new rule is appended.
+ * @param bucket First load balancer bucket to which packets will be
+ * delivered.
+ * @param num_buckets Number of buckets (must be a power of two) across
+ * which packets will be distributed based on the "flow hash".
+ * @param stacks Either NULL, to assign each packet to the smallest
+ * initialized buffer stack which does not induce chaining (and to
+ * drop packets which exceed the largest initialized buffer stack
+ * buffer size), or an array, with each entry indicating which buffer
+ * stack should be used for packets up to that size (with 255
+ * indicating that those packets should be dropped).
+ * @return 0 on success, or a negative error code on failure.
+ */
+extern int
+gxio_mpipe_rules_begin(gxio_mpipe_rules_t * rules,
+		       unsigned int bucket, unsigned int num_buckets,
+		       gxio_mpipe_rules_stacks_t * stacks);
+
+/* Set the priority of the current rule.
+ *
+ * The default priority is zero.  A negative priority has "higher"
+ * priority, and a positive priority has "lower" priority.
+ *
+ * @param rules Rules list whose current rule will be modified.
+ * @param priority The priority.
+ * @return 0 on success, or a negative error code on failure.
+ */
+extern int
+gxio_mpipe_rules_set_priority(gxio_mpipe_rules_t * rules, int priority);
+
+/* Set the headroom of the current rule.
+ *
+ * @param rules Rules list whose current rule will be modified.
+ * @param headroom The headroom.
+ * @return 0 on success, or a negative error code on failure.
+ */
+extern int
+gxio_mpipe_rules_set_headroom(gxio_mpipe_rules_t * rules, uint8_t headroom);
+
+/* Set the tailroom of the current rule.
+ *
+ * @param rules Rules list whose current rule will be modified.
+ * @param tailroom The tailroom.
+ * @return 0 on success, or a negative error code on failure.
+ */
+extern int
+gxio_mpipe_rules_set_tailroom(gxio_mpipe_rules_t * rules, uint8_t tailroom);
+
+/* Set the capacity of the current rule.
+ *
+ * If the packet size, plus the headroom and tailroom, exceed the
+ * capacity, then the packet will be dropped.
+ *
+ * @param rules Rules list whose current rule will be modified.
+ * @param capacity The capacity.
+ * @return 0 on success, or a negative error code on failure.
+ */
+extern int
+gxio_mpipe_rules_set_capacity(gxio_mpipe_rules_t * rules, uint16_t capacity);
+
+/* Indicate that packets from a particular channel can be delivered
+ * to the buckets and buffer stacks associated with the current rule.
+ *
+ * Channels added must be associated with links opened by the mPIPE context
+ * used in gxio_mpipe_rules_init().  A rule with no channels is equivalent
+ * to a rule naming all such associated channels.
+ *
+ * @param rules Rules list whose current rule will be modified.
+ * @param channel The channel to add.
+ * @return 0 on success, or a negative error code on failure.
+ */
+extern int
+gxio_mpipe_rules_add_channel(gxio_mpipe_rules_t * rules, unsigned int channel);
+
+/* Indicate that packets targetting a particular destination MAC
+ * address can be delivered to the current rule's buckets and buffer
+ * stacks.
+ *
+ * A rule with NO dMACs is equivalent to a rule with ALL dMACs.
+ *
+ * @param rules Rules list whose current rule will be modified.
+ * @param dmac The destination MAC to add.
+ * @return 0 on success, or a negative error code on failure.
+ */
+extern int
+gxio_mpipe_rules_add_dmac(gxio_mpipe_rules_t * rules,
+			  gxio_mpipe_rules_dmac_t dmac);
+
+/* Indicate that packets with a particular VLAN can be delivered to
+ * the current rule's buckets and buffer stacks.
+ *
+ * A rule with NO VLANs is equivalent to a rule with ALL VLANs.
+ *
+ * @param rules Rules list whose current rule will be modified.
+ * @param vlan The VLAN to add.
+ * @return 0 on success, or a negative error code on failure.
+ */
+extern int
+gxio_mpipe_rules_add_vlan(gxio_mpipe_rules_t * rules,
+			  gxio_mpipe_rules_vlan_t vlan);
+
+/* Commit rules.
+ *
+ * The rules are sent to the hypervisor, where they are combined with
+ * the rules from other apps, and used to program the hardware classifier.
+ *
+ * Note that if this function returns an error, then the rules will NOT
+ * have been committed, even if the error is due to interactions with
+ * rules from another app.
+ *
+ * @param rules Rules list to commit.
+ * @return 0 on success, or a negative error code on failure.
+ */
+extern int gxio_mpipe_rules_commit(gxio_mpipe_rules_t * rules);
+
+/*****************************************************************
+ *                     Ingress Queue Wrapper                      *
+ ******************************************************************/
+
+/*
+ *
+ * Convenience functions for receiving packets from a NotifRing and
+ * sending packets via an eDMA ring.
+ *
+ * The mpipe ingress and egress hardware uses shared memory packet
+ * descriptors to describe packets that have arrived on ingress or
+ * are destined for egress.  These descriptors are stored in shared
+ * memory ring buffers and written or read by hardware as necessary.
+ * The gxio library provides wrapper functions that manage the head and
+ * tail pointers for these rings, allowing the user to easily read or
+ * write packet descriptors.
+ *
+ * The initialization interface for ingress and egress rings is quite
+ * similar.  For example, to create an ingress queue, the user passes
+ * a ::gxio_mpipe_iqueue_t state object, a ring number from
+ * gxio_mpipe_alloc_notif_rings(), and the address of memory to hold a
+ * ring buffer to the gxio_mpipe_iqueue_init() function.  The function
+ * returns success when the state object has been initialized and the
+ * hardware configured to deliver packets to the specified ring
+ * buffer.  Similarly, gxio_mpipe_equeue_init() takes a
+ * ::gxio_mpipe_equeue_t state object, a ring number from
+ * gxio_mpipe_alloc_edma_rings(), and a shared memory buffer.
+ *
+ * @section gxio_mpipe_iqueue Working with Ingress Queues
+ *
+ * Once initialized, the gxio_mpipe_iqueue_t API provides two flows
+ * for getting the ::gxio_mpipe_idesc_t packet descriptor associated
+ * with incoming packets.  The simplest is to call
+ * gxio_mpipe_iqueue_get() or gxio_mpipe_iqueue_try_get().  These
+ * functions copy the oldest packet descriptor out of the NotifRing and
+ * into a descriptor provided by the caller.  They also immediately
+ * inform the hardware that a descriptor has been processed.
+ *
+ * For applications with stringent performance requirements, higher
+ * efficiency can be achieved by avoiding the packet descriptor copy
+ * and processing multiple descriptors at once.  The
+ * gxio_mpipe_iqueue_peek() and gxio_mpipe_iqueue_try_peek() functions
+ * allow such optimizations.  These functions provide a pointer to the
+ * next valid ingress descriptor in the NotifRing's shared memory ring
+ * buffer, and a count of how many contiguous descriptors are ready to
+ * be processed.  The application can then process any number of those
+ * descriptors in place, calling gxio_mpipe_iqueue_consume() to inform
+ * the hardware after each one has been processed.
+ *
+ * @section gxio_mpipe_equeue Working with Egress Queues
+ *
+ * Similarly, the egress queue API provides a high-performance
+ * interface plus a simple wrapper for use in posting
+ * ::gxio_mpipe_edesc_t egress packet descriptors.  The simple
+ * version, gxio_mpipe_equeue_put(), allows the programmer to wait for
+ * an eDMA ring slot to become available and write a single descriptor
+ * into the ring.
+ *
+ * Alternatively, the gxio_mpipe_equeue_reserve() and
+ * gxio_mpipe_equeue_put_at() APIs can be used to reserve multiple
+ * eDMA ring slots and then fill each slot with a
+ * ::gxio_mpipe_edesc_t.  This capability can be used to reduce
+ * per-operation overhead by posting multiple packets with a single
+ * gxio_mpipe_equeue_reserve() call.  It also allows gather operations
+ * to be performed by posting multiple descriptors, one for each
+ * fragment in the final egress packet.
+ *
+ * The 'slot' number returned by gxio_mpipe_reserve() is really a
+ * 63-bit sequence number, the low bits of which indicate the ring
+ * buffer index and the high bits the number of times the application
+ * has gone around the egress ring buffer.  The extra bits allow an
+ * application to check for egress completion by calling
+ * gxio_mpipe_equeue_is_complete() to see whether a particular 'slot'
+ * number has finished.  Given the maximum packet rates of the Gx
+ * processor, the 63-bit slot number will never wrap.
+ *
+ * In practice, most applications use the ::gxio_mpipe_edesc_t::hwb
+ * bit to indicate that the buffers containing egress packet data
+ * should be pushed onto a buffer stack when egress is complete.  In
+ * this case, the programmer generally does not need to know when an
+ * egress operation actually finishes, since there is no need to free
+ * a buffer post-egress.
+ *
+ * @section gxio_mpipe_equeue_ordered Ordered Packet Forwarding
+ *
+ * The gxio_mpipe_equeue_put_at() API call also be used to perform
+ * in-order forwarding.  mPIPE ingress packets can be marked with
+ * sequence numbers stored in ::gxio_mpipe_idesc_t.  If ingress is
+ * configured to provide sequence numbers, an application can use
+ * gxio_mpipe_equeue_put_at() to put packets into the eDMA ring slot
+ * indicated by their ingress sequence number, in effect forcing the
+ * system to perform ordered packets forwarding.  When using this
+ * mechanism, applications should take care to obey the following
+ * rules:
+ *
+ * - Never call gxio_mpipe_equeue_reserve() on an eDMA ring that is
+ * used for ordered forwarding; that function knows nothing about the
+ * descriptors that have been posted given a sequence number.
+ *
+ * - Make sure that the number of ingress buffers is less than the
+ * number of slots in the eDMA ring.  This guarantees that a burst of
+ * ingress packets cannot overflow the slots available in the eDMA
+ * ring buffer.
+ *
+ * - gxio_mpipe_equeue_put_at() must be called once for each ingress
+ * packet.  Skipping a packet will cause the hardware to stall waiting
+ * for the next in-order packet descriptor.
+ *
+ * - If the application chooses to drop a packet rather than forward
+ * it, it can set the ::gxio_mpipe_edesc_t::ns (no send) bit on the
+ * descriptor passed to gxio_mpipe_equeue_put_at() to indicate that no
+ * data should be sent.  If indicated, the buffer will still be pushed
+ * onto the buffer stack when the egress descriptor is processed.
+ */
+
+/* A convenient interface to a NotifRing, for use by a single thread.
+ */
+typedef struct {
+
+  /* The context. */
+	gxio_mpipe_context_t *context;
+
+  /* The actual NotifRing. */
+	gxio_mpipe_idesc_t *idescs;
+
+  /* The number of entries. */
+	unsigned long num_entries;
+
+  /* The number of entries minus one. */
+	unsigned long mask_num_entries;
+
+  /* The log2() of the number of entries. */
+	unsigned long log2_num_entries;
+
+  /* The next entry. */
+	unsigned int head;
+
+  /* The NotifRing id. */
+	unsigned int ring;
+
+#ifdef __BIG_ENDIAN__
+  /* The number of byteswapped entries. */
+	unsigned int swapped;
+#endif
+
+} gxio_mpipe_iqueue_t;
+
+/* Initialize an "iqueue".
+ *
+ * Takes the iqueue plus the same args as gxio_mpipe_init_notif_ring().
+ */
+extern int
+gxio_mpipe_iqueue_init(gxio_mpipe_iqueue_t * iqueue,
+		       gxio_mpipe_context_t * context,
+		       unsigned int ring,
+		       void *mem, size_t mem_size, unsigned int mem_flags);
+
+/* Advance over some old entries in an iqueue.
+ *
+ * Please see the documentation for gxio_mpipe_iqueue_consume().
+ *
+ * @param iqueue An ingress queue initialized via gxio_mpipe_iqueue_init().
+ * @param count The number of entries to advance over.
+ */
+static inline void
+gxio_mpipe_iqueue_advance(gxio_mpipe_iqueue_t * iqueue, int count)
+{
+	/* Advance with proper wrap. */
+	int head = iqueue->head + count;
+	iqueue->head =
+	    (head & iqueue->mask_num_entries) +
+	    (head >> iqueue->log2_num_entries);
+
+#ifdef __BIG_ENDIAN__
+	/* HACK: Track swapped entries. */
+	iqueue->swapped -= count;
+#endif
+}
+
+/* Release the ring and bucket for an old entry in an iqueue.
+ *
+ * Releasing the ring allows more packets to be delivered to the ring.
+ *
+ * Releasing the bucket allows flows using the bucket to be moved to a
+ * new ring when using GXIO_MPIPE_BUCKET_DYNAMIC_FLOW_AFFINITY.
+ *
+ * This function is shorthand for "gxio_mpipe_credit(iqueue->context,
+ * iqueue->ring, idesc->bucket_id, 1)", and it may be more convenient
+ * to make that underlying call, using those values, instead of
+ * tracking the entire "idesc".
+ *
+ * If packet processing is deferred, optimal performance requires that
+ * the releasing be deferred as well.
+ *
+ * Please see the documentation for gxio_mpipe_iqueue_consume().
+ *
+ * @param iqueue An ingress queue initialized via gxio_mpipe_iqueue_init().
+ * @param idesc The descriptor which was processed.
+ */
+static inline void
+gxio_mpipe_iqueue_release(gxio_mpipe_iqueue_t * iqueue,
+			  gxio_mpipe_idesc_t * idesc)
+{
+	gxio_mpipe_credit(iqueue->context, iqueue->ring, idesc->bucket_id, 1);
+}
+
+/* Consume a packet from an "iqueue".
+ *
+ * After processing packets peeked at via gxio_mpipe_iqueue_peek()
+ * or gxio_mpipe_iqueue_try_peek(), you must call this function, or
+ * gxio_mpipe_iqueue_advance() plus gxio_mpipe_iqueue_release(), to
+ * advance over those entries, and release their rings and buckets.
+ *
+ * You may call this function as each packet is processed, or you can
+ * wait until several packets have been processed.
+ *
+ * Note that if you are using a single bucket, and you are handling
+ * batches of N packets, then you can replace several calls to this
+ * function with calls to "gxio_mpipe_iqueue_advance(iqueue, N)" and
+ * "gxio_mpipe_credit(iqueue->context, iqueue->ring, bucket, N)".
+ *
+ * Note that if your classifier sets "idesc->nr", then you should
+ * explicitly call "gxio_mpipe_iqueue_advance(iqueue, idesc)" plus
+ * "gxio_mpipe_credit(iqueue->context, iqueue->ring, -1, 1)", to
+ * avoid incorrectly crediting the (unused) bucket.
+ *
+ * @param iqueue An ingress queue initialized via gxio_mpipe_iqueue_init().
+ * @param idesc The descriptor which was processed.
+ */
+static inline void
+gxio_mpipe_iqueue_consume(gxio_mpipe_iqueue_t * iqueue,
+			  gxio_mpipe_idesc_t * idesc)
+{
+	gxio_mpipe_iqueue_advance(iqueue, 1);
+	gxio_mpipe_iqueue_release(iqueue, idesc);
+}
+
+/* Peek at the next packet(s) in an "iqueue", without waiting.
+ *
+ * If no packets are available, fills idesc_ref with NULL, and then
+ * returns ::GXIO_MPIPE_ERR_IQUEUE_EMPTY.  Otherwise, fills idesc_ref
+ * with the address of the next valid packet descriptor, and returns
+ * the maximum number of valid descriptors which can be processed.
+ * You may process fewer descriptors if desired.
+ *
+ * Call gxio_mpipe_iqueue_consume() on each packet once it has been
+ * processed (or dropped), to allow more packets to be delivered.
+ *
+ * @param iqueue An ingress queue initialized via gxio_mpipe_iqueue_init().
+ * @param idesc_ref A pointer to a packet descriptor pointer.
+ * @return The (positive) number of packets which can be processed,
+ * or ::GXIO_MPIPE_ERR_IQUEUE_EMPTY if no packets are available.
+ */
+static inline int
+gxio_mpipe_iqueue_try_peek(gxio_mpipe_iqueue_t * iqueue,
+			   gxio_mpipe_idesc_t ** idesc_ref)
+{
+	gxio_mpipe_idesc_t *next;
+
+	uint64_t head = iqueue->head;
+	uint64_t tail = __gxio_mmio_read(iqueue->idescs);
+
+	/* Available entries. */
+	uint64_t avail =
+	    (tail >= head) ? (tail - head) : (iqueue->num_entries - head);
+
+	if (avail == 0) {
+		*idesc_ref = NULL;
+		return GXIO_MPIPE_ERR_IQUEUE_EMPTY;
+	}
+
+	next = &iqueue->idescs[head];
+
+	/* ISSUE: Is this helpful? */
+	__insn_prefetch(next);
+
+#ifdef __BIG_ENDIAN__
+	/* HACK: Swap new entries directly in memory. */
+	{
+		int i, j;
+		for (i = iqueue->swapped; i < avail; i++) {
+			for (j = 0; j < 8; j++)
+				next[i].words[j] =
+				    __builtin_bswap64(next[i].words[j]);
+		}
+		iqueue->swapped = avail;
+	}
+#endif
+
+	*idesc_ref = next;
+
+	return avail;
+}
+
+/* Drop a packet by pushing its buffer (if appropriate).
+ *
+ * NOTE: The caller must still call gxio_mpipe_iqueue_consume() if idesc
+ * came from gxio_mpipe_iqueue_try_peek() or gxio_mpipe_iqueue_peek().
+ *
+ * @param iqueue An ingress queue initialized via gxio_mpipe_iqueue_init().
+ * @param idesc A packet descriptor.
+ */
+static inline void
+gxio_mpipe_iqueue_drop(gxio_mpipe_iqueue_t * iqueue, gxio_mpipe_idesc_t * idesc)
+{
+	/* FIXME: Handle "chaining" properly. */
+
+	if (!idesc->be) {
+		unsigned char *va = gxio_mpipe_idesc_get_va(idesc);
+		gxio_mpipe_push_buffer(iqueue->context, idesc->stack_idx, va);
+	}
+}
+
+/* Drop a packet if it is "bad".
+ *
+ * If gxio_mpipe_idesc_is_bad(idesc), then call gxio_mpipe_iqueue_drop()
+ * and return 1, else, return 0.
+ *
+ * NOTE: The caller must still call gxio_mpipe_iqueue_consume() if idesc
+ * came from gxio_mpipe_iqueue_try_peek() or gxio_mpipe_iqueue_peek().
+ *
+ * @param iqueue An ingress queue initialized via gxio_mpipe_iqueue_init().
+ * @param idesc A packet descriptor.
+ * @return 1 if packet was dropped, else 0.
+ */
+static inline int
+gxio_mpipe_iqueue_drop_if_bad(gxio_mpipe_iqueue_t * iqueue,
+			      gxio_mpipe_idesc_t * idesc)
+{
+	if (gxio_mpipe_idesc_is_bad(idesc)) {
+		gxio_mpipe_iqueue_drop(iqueue, idesc);
+		return 1;
+	}
+
+	return 0;
+}
+
+/* Return the iqueue fullness.
+ *
+ * The hardware tracks the fullness of each NotifRing in a 3-bit quantized
+ * value readable via user-space MMIO.  0 is empty, 7 is full.  The values
+ * in between are controlled by the MPIPE_LBL_QUANT_THRESH registers.  They
+ * will typically be configured to be exponential such that each incremental
+ * 3-bit fullness value represents an exponentially larger number of packets
+ * in the queue.
+ *
+ * @param iqueue An ingress queue initialized via gxio_mpipe_iqueue_init().
+ * @return the 3 bit quantized fullness of the iqueue.
+ */
+static inline int gxio_mpipe_iqueue_get_fullness(gxio_mpipe_iqueue_t * iqueue)
+{
+	void *mmio_addr =
+	    (iqueue->context->mmio_cfg_base + MPIPE_LBL_NR_STATE__FIRST_WORD +
+	     ((iqueue->ring >> 4) << 3));
+
+	uint64_t quant_reg = __gxio_mmio_read(mmio_addr);
+
+	return (quant_reg >> (4 * (iqueue->ring & 0xf))) & 0x7;
+}
+
+/*****************************************************************
+ *                      Egress Queue Wrapper                      *
+ ******************************************************************/
+
+/* A convenient, thread-safe interface to an eDMA ring. */
+typedef struct {
+
+  /* State object for tracking head and tail pointers. */
+	__gxio_dma_queue_t dma_queue;
+
+  /* The ring entries. */
+	gxio_mpipe_edesc_t *edescs;
+
+  /* The number of entries minus one. */
+	unsigned long mask_num_entries;
+
+  /* The log2() of the number of entries. */
+	unsigned long log2_num_entries;
+
+} gxio_mpipe_equeue_t;
+
+/* Initialize an "equeue".
+ *
+ * Takes the equeue plus the same args as gxio_mpipe_init_edma_ring().
+ */
+extern int
+gxio_mpipe_equeue_init(gxio_mpipe_equeue_t * equeue,
+		       gxio_mpipe_context_t * context,
+		       unsigned int edma_ring_id,
+		       unsigned int channel,
+		       void *mem, unsigned int mem_size,
+		       unsigned int mem_flags);
+
+/* Reserve slots for eDMA commands.
+ *
+ * Use gxio_mpipe_equeue_put_at() to actually populate the slots.
+ *
+ * @param equeue An egress queue initialized via gxio_mpipe_equeue_init().
+ * @param num Number of slots to reserve.
+ * @return The first reserved slot, or a negative error code.
+ */
+static inline int64_t
+gxio_mpipe_equeue_reserve(gxio_mpipe_equeue_t * equeue, unsigned int num)
+{
+	return __gxio_dma_queue_reserve_aux(&equeue->dma_queue, num, 1);
+}
+
+/* Reserve slots for eDMA commands, if possible.
+ *
+ * Use gxio_mpipe_equeue_put_at() to actually populate the slots.
+ *
+ * @param equeue An egress queue initialized via gxio_mpipe_equeue_init().
+ * @param num Number of slots to reserve.
+ * @return The first reserved slot, or a negative error code.
+ */
+static inline int64_t
+gxio_mpipe_equeue_try_reserve(gxio_mpipe_equeue_t * equeue, unsigned int num)
+{
+	return __gxio_dma_queue_reserve_aux(&equeue->dma_queue, num, 0);
+}
+
+/*
+ * HACK: This helper function tricks gcc 4.6 into avoiding saving
+ * a copy of "edesc->words[0]" on the stack for no obvious reason.
+ */
+
+static inline void
+gxio_mpipe_equeue_put_at_aux(gxio_mpipe_equeue_t * equeue,
+			     uint_reg_t ew[2], unsigned long slot)
+{
+	unsigned long edma_slot = slot & equeue->mask_num_entries;
+	gxio_mpipe_edesc_t *edesc_p = &equeue->edescs[edma_slot];
+
+	/*
+	 * ISSUE: Could set eDMA ring to be on generation 1 at start, which
+	 * would avoid the negation here, perhaps allowing "__insn_bfins()".
+	 */
+	ew[0] |= !((slot >> equeue->log2_num_entries) & 1);
+
+	/*
+	 * NOTE: We use "__gxio_mpipe_write()", plus the fact that the eDMA
+	 * queue alignment restrictions ensure that these two words are on
+	 * the same cacheline, to force proper ordering between the stores.
+	 */
+	__gxio_mmio_write64(&edesc_p->words[1], ew[1]);
+	__gxio_mmio_write64(&edesc_p->words[0], ew[0]);
+}
+
+/* Post an eDMA command to an eDMA queue at a given egress slot.
+ *
+ * This function copies the supplied edesc into entry "slot mod N" in
+ * the underlying ring, setting the "gen" bit to the appropriate value
+ * based on "(slot mod N*2)", where "N" is the size of the ring.  Note
+ * that the higher bits of slot are unused.
+ *
+ * Normally this function is used to fill in slots reserved by, for
+ * example, gxio_mpipe_equeue_reserve().
+ *
+ * This function can also be used without "reserving" slots, if the
+ * application KNOWS that the ring can never overflow, for example,
+ * by pushing fewer buffers into the buffer stacks than there are
+ * total slots in the equeue.
+ *
+ * @param equeue An egress queue initialized via gxio_mpipe_equeue_init().
+ * @param edesc eDMA command to be posted.
+ * @param slot An egress slot (only the low bits are actually used).
+ */
+static inline void
+gxio_mpipe_equeue_put_at(gxio_mpipe_equeue_t * equeue,
+			 gxio_mpipe_edesc_t edesc, unsigned long slot)
+{
+	gxio_mpipe_equeue_put_at_aux(equeue, edesc.words, slot);
+}
+
+/* Post a single eDMA command to an eDMA queue.
+ *
+ * This is a convenience wrapper around gxio_mpipe_equeue_reserve()
+ * and gxio_mpipe_equeue_put_at().
+ *
+ * @param equeue An egress queue initialized via gxio_mpipe_equeue_init().
+ * @param edesc eDMA command to be posted.
+ * @return 0 on success.
+ */
+static inline int
+gxio_mpipe_equeue_put(gxio_mpipe_equeue_t * equeue, gxio_mpipe_edesc_t edesc)
+{
+	int64_t slot = gxio_mpipe_equeue_reserve(equeue, 1);
+	if (slot < 0)
+		return (int)slot;
+
+	gxio_mpipe_equeue_put_at(equeue, edesc, slot);
+
+	return 0;
+}
+
+/* Ask the mPIPE hardware to egress outstanding packets immediately.
+ *
+ * This call is not necessary, but may slightly reduce overall latency.
+ *
+ * Technically, you should flush all gxio_mpipe_equeue_put_at() writes
+ * to memory before calling this function, to ensure the descriptors
+ * are visible in memory before the mPIPE hardware actually looks for
+ * them.  But this should be very rare, and the only side effect would
+ * be increased latency, so it is up to the caller to decide whether
+ * or not to flush memory.
+ *
+ * @param equeue An egress queue initialized via gxio_mpipe_equeue_init().
+ */
+static inline void gxio_mpipe_equeue_flush(gxio_mpipe_equeue_t * equeue)
+{
+	/* Use "ring_idx = 0" and "count = 0" to "wake up" the eDMA ring. */
+	MPIPE_EDMA_POST_REGION_VAL_t val = { {0} };
+	__insn_flushwb();	/* Flush the write buffers. */
+	__gxio_mmio_write(equeue->dma_queue.post_region_addr, val.word);
+}
+
+/* Determine if a given eDMA command has been completed.
+ *
+ * @param equeue An egress queue initialized via gxio_mpipe_equeue_init().
+ * @param slot The slot used by the eDMA command.
+ * @param update If true, and the command does not appear to have completed
+ * yet, then update any software cache of the hardware completion counter,
+ * and check again.  This should normally be true.
+ * @return True iff the given eDMA command has been completed.
+ *
+ * ISSUE: This should return "bool" and should take "bool update".
+ */
+static inline int
+gxio_mpipe_equeue_is_complete(gxio_mpipe_equeue_t * equeue, int64_t slot,
+			      int update)
+{
+	return __gxio_dma_queue_is_complete(&equeue->dma_queue, slot, update);
+}
+
+/*****************************************************************
+ *                        Link Management                         *
+ ******************************************************************/
+
+/*
+ *
+ * Functions for manipulating and sensing the state and configuration
+ * of physical network links.
+ *
+ * @section gxio_mpipe_link_perm Link Permissions
+ *
+ * Opening a link (with gxio_mpipe_link_open()) requests a set of link
+ * permissions, which control what may be done with the link, and potentially
+ * what permissions may be granted to other processes.
+ *
+ * Data permission allows the process to receive packets from the link by
+ * specifying the link's channel number in mPIPE packet distribution rules,
+ * and to send packets to the link by using the link's channel number as
+ * the target for an eDMA ring.
+ *
+ * Stats permission allows the process to retrieve link attributes (such as
+ * the speeds it is capable of running at, or whether it is currently up), and
+ * to read and write certain statistics-related registers in the link's MAC.
+ *
+ * Control permission allows the process to retrieve and modify link attributes
+ * (so that it may, for example, bring the link up and take it down), and
+ * read and write many registers in the link's MAC and PHY.
+ *
+ * Any permission may be requested as shared, which allows other processes
+ * to also request shared permission, or exclusive, which prevents other
+ * processes from requesting it.  In keeping with GXIO's typical usage in
+ * an embedded environment, the defaults for all permissions are shared.
+ *
+ * Permissions are granted on a first-come, first-served basis, so if two
+ * applications request an exclusive permission on the same link, the one
+ * to run first will win.  Note, however, that some system components, like
+ * the kernel Ethernet driver, may get an opportunity to open links before
+ * any applications run.
+ *
+ * @section gxio_mpipe_link_names Link Names
+ *
+ * Link names are of the form gbe<em>number</em> (for Gigabit Ethernet),
+ * xgbe<em>number</em> (for 10 Gigabit Ethernet), loop<em>number</em> (for
+ * internal mPIPE loopback), or ilk<em>number</em>/<em>channel</em>
+ * (for Interlaken links); for instance, gbe0, xgbe1, loop3, and
+ * ilk0/12 are all possible link names.  The correspondence between
+ * the link name and an mPIPE instance number or mPIPE channel number is
+ * system-dependent; all links will not exist on all systems, and the set
+ * of numbers used for a particular link type may not start at zero and may
+ * not be contiguous.  Use gxio_mpipe_link_enumerate() to retrieve the set of
+ * links which exist on a system, and always use gxio_mpipe_link_instance()
+ * to determine which mPIPE controls a particular link.
+ *
+ * Note that in some cases, links may share hardware, such as PHYs, or
+ * internal mPIPE buffers; in these cases, only one of the links may be
+ * opened at a time.  This is especially common with xgbe and gbe ports,
+ * since each xgbe port uses 4 SERDES lanes, each of which may also be
+ * configured as one gbe port.
+ *
+ * @section gxio_mpipe_link_states Link States
+ *
+ * The mPIPE link management model revolves around three different states,
+ * which are maintained for each link:
+ *
+ * 1. The <em>current</em> link state: is the link up now, and if so, at
+ *    what speed?
+ *
+ * 2. The <em>desired</em> link state: what do we want the link state to be?
+ *    The system is always working to make this state the current state;
+ *    thus, if the desired state is up, and the link is down, we'll be
+ *    constantly trying to bring it up, automatically.
+ *
+ * 3. The <em>possible</em> link state: what speeds are valid for this
+ *    particular link?  Or, in other words, what are the capabilities of
+ *    the link hardware?
+ *
+ * These link states are not, strictly speaking, related to application
+ * state; they may be manipulated at any time, whether or not the link
+ * is currently being used for data transfer.  However, for convenience,
+ * gxio_mpipe_link_open() and gxio_mpipe_link_close() (or application exit)
+ * can affect the link state.  These implicit link management operations
+ * may be modified or disabled by the use of link open flags.
+ *
+ * From an application, you can use gxio_mpipe_link_get_attr()
+ * and gxio_mpipe_link_set_attr() to manipulate the link states.
+ * gxio_mpipe_link_get_attr() with ::GXIO_MPIPE_LINK_POSSIBLE_STATE
+ * gets you the possible link state.  gxio_mpipe_link_get_attr() with
+ * ::GXIO_MPIPE_LINK_CURRENT_STATE gets you the current link state.
+ * Finally, gxio_mpipe_link_set_attr() and gxio_mpipe_link_get_attr()
+ * with ::GXIO_MPIPE_LINK_DESIRED_STATE allow you to modify or retrieve
+ * the desired link state.
+ *
+ * If you want to manage a link from a part of your application which isn't
+ * involved in packet processing, you can use the ::GXIO_MPIPE_LINK_NO_DATA
+ * flags on a gxio_mpipe_link_open() call.  This opens the link, but does
+ * not request data permission, so it does not conflict with any exclusive
+ * permissions which may be held by other processes.  You can then can use
+ * gxio_mpipe_link_get_attr() and gxio_mpipe_link_set_attr() on this link
+ * object to bring up or take down the link.
+ *
+ * Some links support link state bits which support various loopback
+ * modes. ::GXIO_MPIPE_LINK_LOOP_MAC tests datapaths within the Tile
+ * Processor itself; ::GXIO_MPIPE_LINK_LOOP_PHY tests the datapath between
+ * the Tile Processor and the external physical layer interface chip; and
+ * ::GXIO_MPIPE_LINK_LOOP_EXT tests the entire network datapath with the
+ * aid of an external loopback connector.  In addition to enabling hardware
+ * testing, such configuration can be useful for software testing, as well.
+ *
+ * When LOOP_MAC or LOOP_PHY is enabled, packets transmitted on a channel
+ * will be received by that channel, instead of being emitted on the
+ * physical link, and packets received on the physical link will be ignored.
+ * Other than that, all standard GXIO operations work as you might expect.
+ * Note that loopback operation requires that the link be brought up using
+ * one or more of the GXIO_MPIPE_LINK_SPEED_xxx link state bits.
+ *
+ * Those familiar with previous versions of the MDE on TILEPro hardware
+ * will notice significant similarities between the NetIO link management
+ * model and the mPIPE link management model.  However, the NetIO model
+ * was developed in stages, and some of its features -- for instance,
+ * the default setting of certain flags -- were shaped by the need to be
+ * compatible with previous versions of NetIO.  Since the features provided
+ * by the mPIPE hardware and the mPIPE GXIO library are significantly
+ * different than those provided by NetIO, in some cases, we have made
+ * different choices in the mPIPE link management API.  Thus, please read
+ * this documentation carefully before assuming that mPIPE link management
+ * operations are exactly equivalent to their NetIO counterparts.
+ */
+
+/* An object used to manage mPIPE link state and resources. */
+typedef struct {
+  /* The overall mPIPE context. */
+	gxio_mpipe_context_t *context;
+
+  /* The channel number used by this link. */
+	uint8_t channel;
+
+  /* The MAC index used by this link. */
+	uint8_t mac;
+} gxio_mpipe_link_t;
+
+/* Retrieve one of this system's legal link names, and its MAC address.
+ *
+ * @param index Link name index.  If a system supports N legal link names,
+ *  then indices between 0 and N - 1, inclusive, each correspond to one of
+ *  those names.  Thus, to retrieve all of a system's legal link names,
+ *  call this function in a loop, starting with an index of zero, and
+ *  incrementing it once per iteration until -1 is returned.
+ * @param link_name Pointer to the buffer which will receive the retrieved
+ *  link name.  The buffer should contain space for at least
+ *  ::GXIO_MPIPE_LINK_NAME_LEN bytes; the returned name, including the
+ *  terminating null byte, will be no longer than that.
+ * @param link_name Pointer to the buffer which will receive the retrieved
+ *  MAC address.  The buffer should contain space for at least 6 bytes.
+ * @return Zero if a link name was successfully retrieved; -1 if one was
+ *  not.
+ */
+extern int
+gxio_mpipe_link_enumerate_mac(int index, char *link_name, uint8_t * mac_addr);
+
+/* Open an mPIPE link.
+ *
+ *  A link must be opened before it may be used to send or receive packets,
+ *  and before its state may be examined or changed.  Depending up on the
+ *  link's intended use, one or more link permissions may be requested via
+ *  the flags parameter; see @ref gxio_mpipe_link_perm.  In addition, flags
+ *  may request that the link's state be modified at open time.  See @ref
+ *  gxio_mpipe_link_states and @ref gxio_mpipe_link_open_flags for more detail.
+ *
+ * @param link A link state object, which will be initialized if this
+ *  function completes successfully.
+ * @param context An initialized mPIPE context.
+ * @param link_name Name of the link.
+ * @param flags Zero or more @ref gxio_mpipe_link_open_flags, ORed together.
+ * @return 0 if the link was successfully opened, or a negative error code.
+ *
+ */
+extern int
+gxio_mpipe_link_open(gxio_mpipe_link_t * link, gxio_mpipe_context_t * context,
+		     const char *link_name, unsigned int flags);
+
+/* Close an mPIPE link.
+ *
+ *  Closing a link makes it available for use by other processes.  Once
+ *  a link has been closed, packets may no longer be sent on or received
+ *  from the link, and its state may not be examined or changed.
+ *
+ * @param link A link state object, which will no longer be initialized
+ *  if this function completes successfully.
+ * @return 0 if the link was successfully closed, or a negative error code.
+ *
+ */
+extern int gxio_mpipe_link_close(gxio_mpipe_link_t * link);
+
+/* Return a link's channel number.
+ *
+ * @param link A properly initialized link state object.
+ * @return The channel number for the link.
+ */
+static inline int gxio_mpipe_link_channel(gxio_mpipe_link_t * link)
+{
+	return link->channel;
+}
+
+#endif /* !_GXIO_MPIPE_H_ */
diff --git a/arch/tile/include/hv/drv_mpipe_intf.h b/arch/tile/include/hv/drv_mpipe_intf.h
new file mode 100644
index 0000000..6cdae3b
--- /dev/null
+++ b/arch/tile/include/hv/drv_mpipe_intf.h
@@ -0,0 +1,602 @@
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
+/**
+ * Interface definitions for the mpipe driver.
+ */
+
+#ifndef _SYS_HV_DRV_MPIPE_INTF_H
+#define _SYS_HV_DRV_MPIPE_INTF_H
+
+#include <arch/mpipe.h>
+#include <arch/mpipe_constants.h>
+
+
+/** Number of buffer stacks (32). */
+#define HV_MPIPE_NUM_BUFFER_STACKS \
+  (MPIPE_MMIO_INIT_DAT_GX36_1__BUFFER_STACK_MASK_WIDTH)
+
+/** Number of NotifRings (256). */
+#define HV_MPIPE_NUM_NOTIF_RINGS (MPIPE_NUM_NOTIF_RINGS)
+
+/** Number of NotifGroups (32). */
+#define HV_MPIPE_NUM_NOTIF_GROUPS (MPIPE_NUM_NOTIF_GROUPS)
+
+/** Number of buckets (4160). */
+#define HV_MPIPE_NUM_BUCKETS (MPIPE_NUM_BUCKETS)
+
+/** Number of "lo" buckets (4096). */
+#define HV_MPIPE_NUM_LO_BUCKETS 4096
+
+/** Number of "hi" buckets (64). */
+#define HV_MPIPE_NUM_HI_BUCKETS \
+  (HV_MPIPE_NUM_BUCKETS - HV_MPIPE_NUM_LO_BUCKETS)
+
+/** Number of edma rings (24). */
+#define HV_MPIPE_NUM_EDMA_RINGS \
+  (MPIPE_MMIO_INIT_DAT_GX36_1__EDMA_POST_MASK_WIDTH)
+
+
+
+
+/** A flag bit indicating a fixed resource allocation. */
+#define HV_MPIPE_ALLOC_FIXED 0x01
+
+/** Offset for the config register MMIO region. */
+#define HV_MPIPE_CONFIG_MMIO_OFFSET \
+  (MPIPE_MMIO_ADDR__REGION_VAL_CFG << MPIPE_MMIO_ADDR__REGION_SHIFT)
+
+/** Size of the config register MMIO region. */
+#define HV_MPIPE_CONFIG_MMIO_SIZE (64 * 1024)
+
+/** Offset for the config register MMIO region. */
+#define HV_MPIPE_FAST_MMIO_OFFSET \
+  (MPIPE_MMIO_ADDR__REGION_VAL_IDMA << MPIPE_MMIO_ADDR__REGION_SHIFT)
+
+/** Size of the fast register MMIO region (IDMA, EDMA, buffer stack). */
+#define HV_MPIPE_FAST_MMIO_SIZE \
+  ((MPIPE_MMIO_ADDR__REGION_VAL_BSM + 1 - MPIPE_MMIO_ADDR__REGION_VAL_IDMA) \
+   << MPIPE_MMIO_ADDR__REGION_SHIFT)
+
+
+/*
+ * Each type of resource allocation comes in quantized chunks, where
+ * XXX_BITS is the number of chunks, and XXX_RES_PER_BIT is the number
+ * of resources in each chunk.
+ */
+
+/** Number of buffer stack chunks available (32). */
+#define HV_MPIPE_ALLOC_BUFFER_STACKS_BITS \
+  MPIPE_MMIO_INIT_DAT_GX36_1__BUFFER_STACK_MASK_WIDTH
+
+/** Granularity of buffer stack allocation (1). */
+#define HV_MPIPE_ALLOC_BUFFER_STACKS_RES_PER_BIT \
+  (HV_MPIPE_NUM_BUFFER_STACKS / HV_MPIPE_ALLOC_BUFFER_STACKS_BITS)
+
+/** Number of NotifRing chunks available (32). */
+#define HV_MPIPE_ALLOC_NOTIF_RINGS_BITS \
+  MPIPE_MMIO_INIT_DAT_GX36_0__NOTIF_RING_MASK_WIDTH
+
+/** Granularity of NotifRing allocation (8). */
+#define HV_MPIPE_ALLOC_NOTIF_RINGS_RES_PER_BIT \
+  (HV_MPIPE_NUM_NOTIF_RINGS / HV_MPIPE_ALLOC_NOTIF_RINGS_BITS)
+
+/** Number of NotifGroup chunks available (32). */
+#define HV_MPIPE_ALLOC_NOTIF_GROUPS_BITS \
+  HV_MPIPE_NUM_NOTIF_GROUPS
+
+/** Granularity of NotifGroup allocation (1). */
+#define HV_MPIPE_ALLOC_NOTIF_GROUPS_RES_PER_BIT \
+  (HV_MPIPE_NUM_NOTIF_GROUPS / HV_MPIPE_ALLOC_NOTIF_GROUPS_BITS)
+
+/** Number of lo bucket chunks available (16). */
+#define HV_MPIPE_ALLOC_LO_BUCKETS_BITS \
+  MPIPE_MMIO_INIT_DAT_GX36_0__BUCKET_RELEASE_MASK_LO_WIDTH
+
+/** Granularity of lo bucket allocation (256). */
+#define HV_MPIPE_ALLOC_LO_BUCKETS_RES_PER_BIT \
+  (HV_MPIPE_NUM_LO_BUCKETS / HV_MPIPE_ALLOC_LO_BUCKETS_BITS)
+
+/** Number of hi bucket chunks available (16). */
+#define HV_MPIPE_ALLOC_HI_BUCKETS_BITS \
+  MPIPE_MMIO_INIT_DAT_GX36_0__BUCKET_RELEASE_MASK_HI_WIDTH
+
+/** Granularity of hi bucket allocation (4). */
+#define HV_MPIPE_ALLOC_HI_BUCKETS_RES_PER_BIT \
+  (HV_MPIPE_NUM_HI_BUCKETS / HV_MPIPE_ALLOC_HI_BUCKETS_BITS)
+
+/** Number of eDMA ring chunks available (24). */
+#define HV_MPIPE_ALLOC_EDMA_RINGS_BITS \
+  MPIPE_MMIO_INIT_DAT_GX36_1__EDMA_POST_MASK_WIDTH
+
+/** Granularity of eDMA ring allocation (1). */
+#define HV_MPIPE_ALLOC_EDMA_RINGS_RES_PER_BIT \
+  (HV_MPIPE_NUM_EDMA_RINGS / HV_MPIPE_ALLOC_EDMA_RINGS_BITS)
+
+
+
+
+/** Bit vector encoding which NotifRings are in a NotifGroup. */
+typedef struct
+{
+  /** The actual bits. */
+  uint64_t ring_mask[4];
+
+} gxio_mpipe_notif_group_bits_t;
+
+
+/** Another name for MPIPE_LBL_INIT_DAT_BSTS_TBL_t. */
+typedef MPIPE_LBL_INIT_DAT_BSTS_TBL_t gxio_mpipe_bucket_info_t;
+
+
+
+/** Eight buffer stack ids. */
+typedef struct
+{
+  /** The stacks. */
+  uint8_t stacks[8];
+
+} gxio_mpipe_rules_stacks_t;
+
+
+/** A destination mac address. */
+typedef struct
+{
+  /** The octets. */
+  uint8_t octets[6];
+
+} gxio_mpipe_rules_dmac_t;
+
+
+/** A vlan. */
+typedef uint16_t gxio_mpipe_rules_vlan_t;
+
+
+
+/** Maximum number of characters in a link name. */
+#define GXIO_MPIPE_LINK_NAME_LEN  32
+
+
+/** Structure holding a link name.  Only needed, and only typedef'ed,
+ *  because the IORPC stub generator only handles types which are single
+ *  words coming before the parameter name. */
+typedef struct
+{
+  /** The name itself. */
+  char name[GXIO_MPIPE_LINK_NAME_LEN];
+}
+_gxio_mpipe_link_name_t;
+
+/** Maximum number of characters in a symbol name. */
+#define GXIO_MPIPE_SYMBOL_NAME_LEN  128
+
+
+/** Structure holding a symbol name.  Only needed, and only typedef'ed,
+ *  because the IORPC stub generator only handles types which are single
+ *  words coming before the parameter name. */
+typedef struct
+{
+  /** The name itself. */
+  char name[GXIO_MPIPE_SYMBOL_NAME_LEN];
+}
+_gxio_mpipe_symbol_name_t;
+
+
+/** Structure holding a MAC address. */
+typedef struct
+{
+  /** The address. */
+  uint8_t mac[6];
+}
+_gxio_mpipe_link_mac_t;
+
+
+
+/** Request shared data permission -- that is, the ability to send and
+ *  receive packets -- on the specified link.  Other processes may also
+ *  request shared data permission on the same link.
+ *
+ *  No more than one of ::GXIO_MPIPE_LINK_DATA, ::GXIO_MPIPE_LINK_NO_DATA,
+ *  or ::GXIO_MPIPE_LINK_EXCL_DATA may be specifed in a gxio_mpipe_link_open()
+ *  call.  If none are specified, ::GXIO_MPIPE_LINK_DATA is assumed.
+ */
+#define GXIO_MPIPE_LINK_DATA               0x00000001UL
+
+/** Do not request data permission on the specified link.
+ *
+ *  No more than one of ::GXIO_MPIPE_LINK_DATA, ::GXIO_MPIPE_LINK_NO_DATA,
+ *  or ::GXIO_MPIPE_LINK_EXCL_DATA may be specifed in a gxio_mpipe_link_open()
+ *  call.  If none are specified, ::GXIO_MPIPE_LINK_DATA is assumed.
+ */
+#define GXIO_MPIPE_LINK_NO_DATA            0x00000002UL
+
+/** Request exclusive data permission -- that is, the ability to send and
+ *  receive packets -- on the specified link.  No other processes may
+ *  request data permission on this link, and if any process already has
+ *  data permission on it, this open will fail.
+ *
+ *  No more than one of ::GXIO_MPIPE_LINK_DATA, ::GXIO_MPIPE_LINK_NO_DATA,
+ *  or ::GXIO_MPIPE_LINK_EXCL_DATA may be specifed in a gxio_mpipe_link_open()
+ *  call.  If none are specified, ::GXIO_MPIPE_LINK_DATA is assumed.
+ */
+#define GXIO_MPIPE_LINK_EXCL_DATA          0x00000004UL
+
+/** Request shared stats permission -- that is, the ability to read and write
+ *  registers which contain link statistics, and to get link attributes --
+ *  on the specified link.  Other processes may also request shared stats
+ *  permission on the same link.
+ *
+ *  No more than one of ::GXIO_MPIPE_LINK_STATS, ::GXIO_MPIPE_LINK_NO_STATS,
+ *  or ::GXIO_MPIPE_LINK_EXCL_STATS may be specifed in a gxio_mpipe_link_open()
+ *  call.  If none are specified, ::GXIO_MPIPE_LINK_STATS is assumed.
+ */
+#define GXIO_MPIPE_LINK_STATS              0x00000008UL
+
+/** Do not request stats permission on the specified link.
+ *
+ *  No more than one of ::GXIO_MPIPE_LINK_STATS, ::GXIO_MPIPE_LINK_NO_STATS,
+ *  or ::GXIO_MPIPE_LINK_EXCL_STATS may be specifed in a gxio_mpipe_link_open()
+ *  call.  If none are specified, ::GXIO_MPIPE_LINK_STATS is assumed.
+ */
+#define GXIO_MPIPE_LINK_NO_STATS           0x00000010UL
+
+/** Request exclusive stats permission -- that is, the ability to read and
+ *  write registers which contain link statistics, and to get link
+ *  attributes -- on the specified link.  No other processes may request
+ *  stats permission on this link, and if any process already
+ *  has stats permission on it, this open will fail.
+ *
+ *  Requesting exclusive stats permission is normally a very bad idea, since
+ *  it prevents programs like mpipe-stat from providing information on this
+ *  link.  Applications should only do this if they use MAC statistics
+ *  registers, and cannot tolerate any of the clear-on-read registers being
+ *  reset by other statistics programs.
+ *
+ *  No more than one of ::GXIO_MPIPE_LINK_STATS, ::GXIO_MPIPE_LINK_NO_STATS,
+ *  or ::GXIO_MPIPE_LINK_EXCL_STATS may be specifed in a gxio_mpipe_link_open()
+ *  call.  If none are specified, ::GXIO_MPIPE_LINK_STATS is assumed.
+ */
+#define GXIO_MPIPE_LINK_EXCL_STATS         0x00000020UL
+
+/** Request shared control permission -- that is, the ability to modify link
+ *  attributes, and read and write MAC and MDIO registers -- on the
+ *  specified link.  Other processes may also request shared control
+ *  permission on the same link.
+ *
+ *  No more than one of ::GXIO_MPIPE_LINK_CTL, ::GXIO_MPIPE_LINK_NO_CTL,
+ *  or ::GXIO_MPIPE_LINK_EXCL_CTL may be specifed in a gxio_mpipe_link_open()
+ *  call.  If none are specified, ::GXIO_MPIPE_LINK_CTL is assumed.
+ */
+#define GXIO_MPIPE_LINK_CTL                0x00000040UL
+
+/** Do not request control permission on the specified link.
+ *
+ *  No more than one of ::GXIO_MPIPE_LINK_CTL, ::GXIO_MPIPE_LINK_NO_CTL,
+ *  or ::GXIO_MPIPE_LINK_EXCL_CTL may be specifed in a gxio_mpipe_link_open()
+ *  call.  If none are specified, ::GXIO_MPIPE_LINK_CTL is assumed.
+ */
+#define GXIO_MPIPE_LINK_NO_CTL             0x00000080UL
+
+/** Request exclusive control permission -- that is, the ability to modify
+ *  link attributes, and read and write MAC and MDIO registers -- on the
+ *  specified link.  No other processes may request control permission on
+ *  this link, and if any process already has control permission on it,
+ *  this open will fail.
+ *
+ *  Requesting exclusive control permission is not always a good idea, since
+ *  it prevents programs like mpipe-link from configuring the link.
+ *
+ *  No more than one of ::GXIO_MPIPE_LINK_CTL, ::GXIO_MPIPE_LINK_NO_CTL,
+ *  or ::GXIO_MPIPE_LINK_EXCL_CTL may be specifed in a gxio_mpipe_link_open()
+ *  call.  If none are specified, ::GXIO_MPIPE_LINK_CTL is assumed.
+ */
+#define GXIO_MPIPE_LINK_EXCL_CTL           0x00000100UL
+
+/** Set the desired state of the link to up, allowing any speeds which are
+ *  supported by the link hardware, as part of this open operation; do not
+ *  change the desired state of the link when it is closed or the process
+ *  exits.  No more than one of ::GXIO_MPIPE_LINK_AUTO_UP,
+ *  ::GXIO_MPIPE_LINK_AUTO_UPDOWN, ::GXIO_MPIPE_LINK_AUTO_DOWN, or
+ *  ::GXIO_MPIPE_LINK_AUTO_NONE may be specifed in a gxio_mpipe_link_open()
+ *  call.  If none are specified, ::GXIO_MPIPE_LINK_AUTO_UPDOWN is assumed.
+ */
+#define GXIO_MPIPE_LINK_AUTO_UP            0x00000200UL
+
+/** Set the desired state of the link to up, allowing any speeds which are
+ *  supported by the link hardware, as part of this open operation; when the
+ *  link is closed or this process exits, if no other process has the link
+ *  open, set the desired state of the link to down.  No more than one of
+ *  ::GXIO_MPIPE_LINK_AUTO_UP, ::GXIO_MPIPE_LINK_AUTO_UPDOWN,
+ *  ::GXIO_MPIPE_LINK_AUTO_DOWN, or ::GXIO_MPIPE_LINK_AUTO_NONE may be
+ *  specifed in a gxio_mpipe_link_open() call.  If none are specified,
+ *  ::GXIO_MPIPE_LINK_AUTO_UPDOWN is assumed.
+ */
+#define GXIO_MPIPE_LINK_AUTO_UPDOWN        0x00000400UL
+
+/** Do not change the desired state of the link as part of the open
+ *  operation; when the link is closed or this process exits, if no other
+ *  process has the link open, set the desired state of the link to down.
+ *  No more than one of ::GXIO_MPIPE_LINK_AUTO_UP,
+ *  ::GXIO_MPIPE_LINK_AUTO_UPDOWN, ::GXIO_MPIPE_LINK_AUTO_DOWN, or
+ *  ::GXIO_MPIPE_LINK_AUTO_NONE may be specifed in a gxio_mpipe_link_open()
+ *  call.  If none are specified, ::GXIO_MPIPE_LINK_AUTO_UPDOWN is assumed.
+ */
+#define GXIO_MPIPE_LINK_AUTO_DOWN          0x00000800UL
+
+/** Do not change the desired state of the link as part of the open
+ *  operation; do not change the desired state of the link when it is
+ *  closed or the process exits.  No more than one of
+ *  ::GXIO_MPIPE_LINK_AUTO_UP, ::GXIO_MPIPE_LINK_AUTO_UPDOWN,
+ *  ::GXIO_MPIPE_LINK_AUTO_DOWN, or ::GXIO_MPIPE_LINK_AUTO_NONE may be
+ *  specifed in a gxio_mpipe_link_open() call.  If none are specified,
+ *  ::GXIO_MPIPE_LINK_AUTO_UPDOWN is assumed.
+ */
+#define GXIO_MPIPE_LINK_AUTO_NONE          0x00001000UL
+
+/** Request that this open call not complete until the network link is up.
+ *  The process will wait as long as necessary for this to happen;
+ *  applications which wish to abandon waiting for the link after a
+ *  specific time period should not specify this flag when opening a link,
+ *  but should instead call gxio_mpipe_link_wait() afterward.  The link
+ *  must be opened with stats permission.  Note that this flag by itself
+ *  does not change the desired link state; if other open flags or previous
+ *  link state changes have not requested a desired state of up, the open
+ *  call will never complete.  This flag is not available to kernel
+ *  clients.
+ */
+#define GXIO_MPIPE_LINK_WAIT               0x00002000UL
+
+
+/*
+ * Note: link attributes must fit in 24 bits, since we use the top 8 bits
+ * of the IORPC offset word for the channel number.
+ */
+
+/** Determine whether jumbo frames may be received.  If this attribute's
+ *  value value is nonzero, the MAC will accept frames of up to 10240 bytes.
+ *  If the value is zero, the MAC will only accept frames of up to 1544
+ *  bytes.  The default value is zero. */
+#define GXIO_MPIPE_LINK_RECEIVE_JUMBO      0x010000
+
+/** Determine whether to send pause frames on this link if the mPIPE packet
+ *  FIFO is nearly full.  If the value is zero, pause frames are not sent.
+ *  If the value is nonzero, it is the delay value which will be sent in any
+ *  pause frames which are output, in units of 512 bit times.
+ *
+ *  Bear in mind that in almost all circumstances, the mPIPE packet FIFO
+ *  will never fill up, since mPIPE will empty it as fast as or faster than
+ *  the incoming data rate, by either delivering or dropping packets.  The
+ *  only situation in which this is not true is if the memory and cache
+ *  subsystem is extremely heavily loaded, and mPIPE cannot perform DMA of
+ *  packet data to memory in a timely fashion.  In particular, pause frames
+ *  will <em>not</em> be sent if packets cannot be delivered because
+ *  NotifRings are full, buckets are full, or buffers are not available in
+ *  a buffer stack. */
+#define GXIO_MPIPE_LINK_SEND_PAUSE         0x020000
+
+/** Determine whether to suspend output on the receipt of pause frames.
+ *  If the value is nonzero, mPIPE shim will suspend output on the link's
+ *  channel when a pause frame is received.  If the value is zero, pause
+ *  frames will be ignored.  The default value is zero. */
+#define GXIO_MPIPE_LINK_RECEIVE_PAUSE      0x030000
+
+/** Interface MAC address.  The value is a 6-byte MAC address, in the least
+ *  significant 48 bits of the value; in other words, an address which would
+ *  be printed as '12:34:56:78:90:AB' in IEEE 802 canonical format would
+ *  be returned as 0x12345678ab.
+ *
+ *  Depending upon the overall system design, a MAC address may or may not
+ *  be available for each interface.  Note that the interface's MAC address
+ *  does not limit the packets received on its channel, although the
+ *  classifier's rules could be configured to do that.  Similarly, the MAC
+ *  address is not used when transmitting packets, although applications
+ *  could certainly decide to use the assigned address as a source MAC
+ *  address when doing so.  This attribute may only be retrieved with
+ *  gxio_mpipe_link_get_attr(); it may not be modified.
+ */
+#define GXIO_MPIPE_LINK_MAC                0x040000
+
+/** Determine whether to discard egress packets on link down. If this value
+ *  is nonzero, packets sent on this link while the link is down will be
+ *  discarded.  If this value is zero, no packets will be sent on this link
+ *  while it is down.  The default value is one. */
+#define GXIO_MPIPE_LINK_DISCARD_IF_DOWN    0x050000
+
+/** Possible link state.  The value is a combination of link state flags,
+ *  ORed together, that indicate link modes which are actually supported by
+ *  the hardware.  This attribute may only be retrieved with
+ *  gxio_mpipe_link_get_attr(); it may not be modified. */
+#define GXIO_MPIPE_LINK_POSSIBLE_STATE     0x060000
+
+/** Current link state.  The value is a combination of link state flags,
+ *  ORed together, that indicate the current state of the hardware.  If the
+ *  link is down, the value ANDed with ::GXIO_MPIPE_LINK_SPEED will be zero;
+ *  if the link is up, the value ANDed with ::GXIO_MPIPE_LINK_SPEED will
+ *  result in exactly one of the speed values, indicating the current speed.
+ *  This attribute may only be retrieved with gxio_mpipe_link_get_attr(); it
+ *  may not be modified. */
+#define GXIO_MPIPE_LINK_CURRENT_STATE      0x070000
+
+/** Desired link state. The value is a conbination of flags, which specify
+ *  the desired state for the link.  With gxio_mpipe_link_set_attr(), this
+ *  will, in the background, attempt to bring up the link using whichever of
+ *  the requested flags are reasonable, or take down the link if the flags
+ *  are zero.  The actual link up or down operation may happen after this
+ *  call completes.  If the link state changes in the future, the system
+ *  will continue to try to get back to the desired link state; for
+ *  instance, if the link is brought up successfully, and then the network
+ *  cable is disconnected, the link will go down.  However, the desired
+ *  state of the link is still up, so if the cable is reconnected, the link
+ *  will be brought up again.
+ *
+ *  With gxio_mpipe_link_set_attr(), this will indicate the desired state
+ *  for the link, as set with a previous gxio_mpipe_link_set_attr() call,
+ *  or implicitly by a gxio_mpipe_link_open() or link close operation.
+ *  This may not reflect the current state of the link; to get that, use
+ *  ::GXIO_MPIPE_LINK_CURRENT_STATE.
+ */
+#define GXIO_MPIPE_LINK_DESIRED_STATE      0x080000
+
+
+
+/** Link can run, should run, or is running at 10 Mbps. */
+#define GXIO_MPIPE_LINK_10M        0x0000000000000001UL
+
+/** Link can run, should run, or is running at 100 Mbps. */
+#define GXIO_MPIPE_LINK_100M       0x0000000000000002UL
+
+/** Link can run, should run, or is running at 1 Gbps. */
+#define GXIO_MPIPE_LINK_1G         0x0000000000000004UL
+
+/** Link can run, should run, or is running at 10 Gbps. */
+#define GXIO_MPIPE_LINK_10G        0x0000000000000008UL
+
+/** Link can run, should run, or is running at 20 Gbps. */
+#define GXIO_MPIPE_LINK_20G        0x0000000000000010UL
+
+/** Link can run, should run, or is running at 25 Gbps. */
+#define GXIO_MPIPE_LINK_25G        0x0000000000000020UL
+
+/** Link can run, should run, or is running at 50 Gbps. */
+#define GXIO_MPIPE_LINK_50G        0x0000000000000040UL
+
+/** Link should run at the highest speed supported by the link and by
+ *  the device connected to the link.  Only usable as a value for
+ *  the link's desired state; never returned as a value for the current
+ *  or possible states. */
+#define GXIO_MPIPE_LINK_ANYSPEED   0x0000000000000800UL
+
+/** All legal link speeds.  This value is provided for use in extracting
+ *  the speed-related subset of the link state flags; it is not intended
+ *  to be set directly as a value for one of the GXIO_MPIPE_LINK_xxx_STATE
+ *  attributes.  A link is up or is requested to be up if its current or
+ *  desired state, respectively, ANDED with this value, is nonzero. */
+#define GXIO_MPIPE_LINK_SPEED_MASK 0x0000000000000FFFUL
+
+/** Link can run, should run, or is running in MAC loopback mode.  This
+ *  loops transmitted packets back to the receiver, inside the Tile
+ *  Processor. */
+#define GXIO_MPIPE_LINK_LOOP_MAC   0x0000000000001000UL
+
+/** Link can run, should run, or is running in PHY loopback mode.  This
+ *  loops transmitted packets back to the receiver, inside the external
+ *  PHY chip. */
+#define GXIO_MPIPE_LINK_LOOP_PHY   0x0000000000002000UL
+
+/** Link can run, should run, or is running in external loopback mode.
+ *  This requires that an external loopback plug be installed on the
+ *  Ethernet port.  Note that only some links require that this be
+ *  configured via the gxio_mpipe_link routines; other links can do
+ *  external loopack with the plug and no special configuration. */
+#define GXIO_MPIPE_LINK_LOOP_EXT   0x0000000000004000UL
+
+/** All legal loopback types. */
+#define GXIO_MPIPE_LINK_LOOP_MASK  0x000000000000F000UL
+
+/** Link can run, should run, or is running in full-duplex mode.
+ *  If neither ::GXIO_MPIPE_LINK_FDX nor ::GXIO_MPIPE_LINK_HDX are
+ *  specified in a set of desired state flags, both are assumed. */
+#define GXIO_MPIPE_LINK_FDX        0x0000000000010000UL
+
+/** Link can run, should run, or is running in half-duplex mode.
+ *  If neither ::GXIO_MPIPE_LINK_FDX nor ::GXIO_MPIPE_LINK_HDX are
+ *  specified in a set of desired state flags, both are assumed. */
+#define GXIO_MPIPE_LINK_HDX        0x0000000000020000UL
+
+
+/** An individual rule. */
+typedef struct
+{
+  /** The total size. */
+  uint16_t size;
+
+  /** The priority. */
+  int16_t priority;
+
+  /** The "headroom" in each buffer. */
+  uint8_t headroom;
+
+  /** The "tailroom" in each buffer. */
+  uint8_t tailroom;
+
+  /** The "capacity" of the largest buffer. */
+  uint16_t capacity;
+
+  /** The mask for converting a flow hash into a bucket. */
+  uint16_t bucket_mask;
+
+  /** The offset for converting a flow hash into a bucket. */
+  uint16_t bucket_first;
+
+  /** The buffer stack ids. */
+  gxio_mpipe_rules_stacks_t stacks;
+
+  /** The actual channels. */
+  uint32_t channel_bits;
+
+  /** The number of dmacs. */
+  uint16_t num_dmacs;
+
+  /** The number of vlans. */
+  uint16_t num_vlans;
+
+  /** The actual dmacs and vlans. */
+  uint8_t dmacs_and_vlans[];
+
+} gxio_mpipe_rules_rule_t;
+
+
+/** A list of classifier rules. */
+typedef struct
+{
+  /** The offset to the end of the current rule. */
+  uint16_t tail;
+
+  /** The offset to the start of the current rule. */
+  uint16_t head;
+
+  /** The actual rules. */
+  uint8_t rules[4096 - 4];
+
+} gxio_mpipe_rules_list_t;
+
+
+
+
+/** mPIPE statistics structure. These counters include all relevant
+ *  events occurring on all links within the mPIPE shim. */
+typedef struct
+{
+  /** Number of ingress packets dropped for any reason. */
+  uint64_t ingress_drops;
+  /** Number of ingress packets dropped because a buffer stack was empty. */
+  uint64_t ingress_drops_no_buf;
+  /** Number of ingress packets dropped or truncated due to lack of space in
+   *  the iPkt buffer. */
+  uint64_t ingress_drops_ipkt;
+  /** Number of ingress packets dropped by the classifier or load balancer */
+  uint64_t ingress_drops_cls_lb;
+  /** Total number of ingress packets. */
+  uint64_t ingress_packets;
+  /** Total number of egress packets. */
+  uint64_t egress_packets;
+  /** Total number of ingress bytes. */
+  uint64_t ingress_bytes;
+  /** Total number of egress bytes. */
+  uint64_t egress_bytes;
+}
+gxio_mpipe_stats_t;
+
+
+#endif /* _SYS_HV_DRV_MPIPE_INTF_H */
-- 
1.6.5.2

