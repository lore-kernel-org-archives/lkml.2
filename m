Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab2FPUsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 16:48:05 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:20837 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab2FPUsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 16:48:02 -0400
Message-ID: <201206162048.q5GKm1rt019464@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 9 May 2012 12:25:02 -0400
Subject: [PATCH 1/3] arch/tile: provide kernel support for the tilegx USB shim
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds support for accessing the USB shim from within the
kernel.  Note that this change by itself does not allow the kernel
to act as a host or as a device; it merely exposes the built-in on-chip
hardware to the kernel.

The <arch/usb_host.h> and <arch/usb_host_def.h> headers are empty at
the moment because the kernel does not require any types or definitions
specific to the tilegx USB shim; the generic USB core code is all we need.
The headers are left in as stubs so that we don't need to modify the
hypervisor header (drv_usb_host_intf.h) from upstream.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/gxio/Kconfig                   |    5 ++
 arch/tile/gxio/Makefile                  |    1 +
 arch/tile/gxio/iorpc_usb_host.c          |   99 ++++++++++++++++++++++++++++++
 arch/tile/gxio/usb_host.c                |   91 +++++++++++++++++++++++++++
 arch/tile/include/arch/usb_host.h        |   26 ++++++++
 arch/tile/include/arch/usb_host_def.h    |   19 ++++++
 arch/tile/include/gxio/iorpc_usb_host.h  |   46 ++++++++++++++
 arch/tile/include/gxio/usb_host.h        |   87 ++++++++++++++++++++++++++
 arch/tile/include/hv/drv_usb_host_intf.h |   39 ++++++++++++
 9 files changed, 413 insertions(+)
 create mode 100644 arch/tile/gxio/iorpc_usb_host.c
 create mode 100644 arch/tile/gxio/usb_host.c
 create mode 100644 arch/tile/include/arch/usb_host.h
 create mode 100644 arch/tile/include/arch/usb_host_def.h
 create mode 100644 arch/tile/include/gxio/iorpc_usb_host.h
 create mode 100644 arch/tile/include/gxio/usb_host.h
 create mode 100644 arch/tile/include/hv/drv_usb_host_intf.h

diff --git a/arch/tile/gxio/Kconfig b/arch/tile/gxio/Kconfig
index 68e1cca..d221f8d 100644
--- a/arch/tile/gxio/Kconfig
+++ b/arch/tile/gxio/Kconfig
@@ -21,3 +21,8 @@ config TILE_GXIO_TRIO
 	bool
 	select TILE_GXIO
 	select TILE_GXIO_DMA
+
+# Support direct access to the TILE-Gx USB hardware from kernel space.
+config TILE_GXIO_USB_HOST
+	bool
+	select TILE_GXIO
diff --git a/arch/tile/gxio/Makefile b/arch/tile/gxio/Makefile
index 2389ef3..8684bca 100644
--- a/arch/tile/gxio/Makefile
+++ b/arch/tile/gxio/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_TILE_GXIO) += iorpc_globals.o kiorpc.o
 obj-$(CONFIG_TILE_GXIO_DMA) += dma_queue.o
 obj-$(CONFIG_TILE_GXIO_MPIPE) += mpipe.o iorpc_mpipe.o iorpc_mpipe_info.o
 obj-$(CONFIG_TILE_GXIO_TRIO) += trio.o iorpc_trio.o
+obj-$(CONFIG_TILE_GXIO_USB_HOST) += usb_host.o iorpc_usb_host.o
diff --git a/arch/tile/gxio/iorpc_usb_host.c b/arch/tile/gxio/iorpc_usb_host.c
new file mode 100644
index 0000000..cf3c3cc
--- /dev/null
+++ b/arch/tile/gxio/iorpc_usb_host.c
@@ -0,0 +1,99 @@
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
+/* This file is machine-generated; DO NOT EDIT! */
+#include "gxio/iorpc_usb_host.h"
+
+struct cfg_interrupt_param {
+	union iorpc_interrupt interrupt;
+};
+
+int gxio_usb_host_cfg_interrupt(gxio_usb_host_context_t * context, int inter_x,
+				int inter_y, int inter_ipi, int inter_event)
+{
+	struct cfg_interrupt_param temp;
+	struct cfg_interrupt_param *params = &temp;
+
+	params->interrupt.kernel.x = inter_x;
+	params->interrupt.kernel.y = inter_y;
+	params->interrupt.kernel.ipi = inter_ipi;
+	params->interrupt.kernel.event = inter_event;
+
+	return hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params,
+			     sizeof(*params), GXIO_USB_HOST_OP_CFG_INTERRUPT);
+}
+
+EXPORT_SYMBOL(gxio_usb_host_cfg_interrupt);
+
+struct register_client_memory_param {
+	HV_PTE pte;
+	unsigned int flags;
+};
+
+int gxio_usb_host_register_client_memory(gxio_usb_host_context_t * context,
+					 HV_PTE pte, unsigned int flags)
+{
+	struct register_client_memory_param temp;
+	struct register_client_memory_param *params = &temp;
+
+	params->pte = pte;
+	params->flags = flags;
+
+	return hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params,
+			     sizeof(*params),
+			     GXIO_USB_HOST_OP_REGISTER_CLIENT_MEMORY);
+}
+
+EXPORT_SYMBOL(gxio_usb_host_register_client_memory);
+
+struct get_mmio_base_param {
+	HV_PTE base;
+};
+
+int gxio_usb_host_get_mmio_base(gxio_usb_host_context_t * context, HV_PTE *base)
+{
+	int __result;
+	struct get_mmio_base_param temp;
+	struct get_mmio_base_param *params = &temp;
+
+	__result =
+	    hv_dev_pread(context->fd, 0, (HV_VirtAddr) params, sizeof(*params),
+			 GXIO_USB_HOST_OP_GET_MMIO_BASE);
+	*base = params->base;
+
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_usb_host_get_mmio_base);
+
+struct check_mmio_offset_param {
+	unsigned long offset;
+	unsigned long size;
+};
+
+int gxio_usb_host_check_mmio_offset(gxio_usb_host_context_t * context,
+				    unsigned long offset, unsigned long size)
+{
+	struct check_mmio_offset_param temp;
+	struct check_mmio_offset_param *params = &temp;
+
+	params->offset = offset;
+	params->size = size;
+
+	return hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params,
+			     sizeof(*params),
+			     GXIO_USB_HOST_OP_CHECK_MMIO_OFFSET);
+}
+
+EXPORT_SYMBOL(gxio_usb_host_check_mmio_offset);
diff --git a/arch/tile/gxio/usb_host.c b/arch/tile/gxio/usb_host.c
new file mode 100644
index 0000000..66b002f
--- /dev/null
+++ b/arch/tile/gxio/usb_host.c
@@ -0,0 +1,91 @@
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
+ * Implementation of USB gxio calls.
+ */
+
+#include <linux/io.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+
+#include <gxio/iorpc_globals.h>
+#include <gxio/iorpc_usb_host.h>
+#include <gxio/kiorpc.h>
+#include <gxio/usb_host.h>
+
+int gxio_usb_host_init(gxio_usb_host_context_t * context, int usb_index,
+		       int is_ehci)
+{
+	char file[32];
+	int fd;
+
+	if (is_ehci)
+		snprintf(file, sizeof(file), "usb_host/%d/iorpc/ehci",
+			 usb_index);
+	else
+		snprintf(file, sizeof(file), "usb_host/%d/iorpc/ohci",
+			 usb_index);
+
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
+	// Map in the MMIO space.
+	context->mmio_base =
+		(void __force *)iorpc_ioremap(fd, 0, HV_USB_HOST_MMIO_SIZE);
+
+	if (context->mmio_base == NULL) {
+		hv_dev_close(context->fd);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(gxio_usb_host_init);
+
+int gxio_usb_host_destroy(gxio_usb_host_context_t * context)
+{
+	iounmap((void __force __iomem *)(context->mmio_base));
+	hv_dev_close(context->fd);
+
+	context->mmio_base = NULL;
+	context->fd = -1;
+
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(gxio_usb_host_destroy);
+
+void *gxio_usb_host_get_reg_start(gxio_usb_host_context_t * context)
+{
+	return context->mmio_base;
+}
+
+EXPORT_SYMBOL_GPL(gxio_usb_host_get_reg_start);
+
+size_t gxio_usb_host_get_reg_len(gxio_usb_host_context_t * context)
+{
+	return HV_USB_HOST_MMIO_SIZE;
+}
+
+EXPORT_SYMBOL_GPL(gxio_usb_host_get_reg_len);
diff --git a/arch/tile/include/arch/usb_host.h b/arch/tile/include/arch/usb_host.h
new file mode 100644
index 0000000..d09f326
--- /dev/null
+++ b/arch/tile/include/arch/usb_host.h
@@ -0,0 +1,26 @@
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
+#ifndef __ARCH_USB_HOST_H__
+#define __ARCH_USB_HOST_H__
+
+#include <arch/abi.h>
+#include <arch/usb_host_def.h>
+
+#ifndef __ASSEMBLER__
+#endif /* !defined(__ASSEMBLER__) */
+
+#endif /* !defined(__ARCH_USB_HOST_H__) */
diff --git a/arch/tile/include/arch/usb_host_def.h b/arch/tile/include/arch/usb_host_def.h
new file mode 100644
index 0000000..aeed775
--- /dev/null
+++ b/arch/tile/include/arch/usb_host_def.h
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
+#ifndef __ARCH_USB_HOST_DEF_H__
+#define __ARCH_USB_HOST_DEF_H__
+#endif /* !defined(__ARCH_USB_HOST_DEF_H__) */
diff --git a/arch/tile/include/gxio/iorpc_usb_host.h b/arch/tile/include/gxio/iorpc_usb_host.h
new file mode 100644
index 0000000..8622e7d
--- /dev/null
+++ b/arch/tile/include/gxio/iorpc_usb_host.h
@@ -0,0 +1,46 @@
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
+/* This file is machine-generated; DO NOT EDIT! */
+#ifndef __GXIO_USB_HOST_LINUX_RPC_H__
+#define __GXIO_USB_HOST_LINUX_RPC_H__
+
+#include <hv/iorpc.h>
+
+#include <hv/drv_usb_host_intf.h>
+#include <asm/page.h>
+#include <gxio/kiorpc.h>
+#include <gxio/usb_host.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <asm/pgtable.h>
+
+#define GXIO_USB_HOST_OP_CFG_INTERRUPT IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x1800)
+#define GXIO_USB_HOST_OP_REGISTER_CLIENT_MEMORY IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x1801)
+#define GXIO_USB_HOST_OP_GET_MMIO_BASE IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x8000)
+#define GXIO_USB_HOST_OP_CHECK_MMIO_OFFSET IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x8001)
+
+int gxio_usb_host_cfg_interrupt(gxio_usb_host_context_t * context, int inter_x,
+				int inter_y, int inter_ipi, int inter_event);
+
+int gxio_usb_host_register_client_memory(gxio_usb_host_context_t * context,
+					 HV_PTE pte, unsigned int flags);
+
+int gxio_usb_host_get_mmio_base(gxio_usb_host_context_t * context,
+				HV_PTE *base);
+
+int gxio_usb_host_check_mmio_offset(gxio_usb_host_context_t * context,
+				    unsigned long offset, unsigned long size);
+
+#endif /* !__GXIO_USB_HOST_LINUX_RPC_H__ */
diff --git a/arch/tile/include/gxio/usb_host.h b/arch/tile/include/gxio/usb_host.h
new file mode 100644
index 0000000..a60a126
--- /dev/null
+++ b/arch/tile/include/gxio/usb_host.h
@@ -0,0 +1,87 @@
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
+#ifndef _GXIO_USB_H_
+#define _GXIO_USB_H_
+
+#include "common.h"
+
+#include <hv/drv_usb_host_intf.h>
+#include <hv/iorpc.h>
+
+/*
+ *
+ * An API for manipulating general-purpose I/O pins.
+ */
+
+/*
+ *
+ * The USB shim allows access to the processor's Universal Serial Bus
+ * connections.
+ */
+
+/* A context object used to manage USB hardware resources. */
+typedef struct {
+
+	/* File descriptor for calling up to the hypervisor. */
+	int fd;
+
+	/* The VA at which our MMIO registers are mapped. */
+	char *mmio_base;
+} gxio_usb_host_context_t;
+
+/* Initialize a USB context.
+ *
+ *  A properly initialized context must be obtained before any of the other
+ *  gxio_usb_host routines may be used.
+ *
+ * @param context Pointer to a gxio_usb_host_context_t, which will be
+ *  initialized by this routine, if it succeeds.
+ * @param usb_index Index of the USB shim to use.
+ * @param is_ehci Nonzero to use the EHCI interface; zero to use the OHCI
+ *  intereface.
+ * @return Zero if the context was successfully initialized, else a
+ *  GXIO_ERR_xxx error code.
+ */
+extern int gxio_usb_host_init(gxio_usb_host_context_t * context, int usb_index,
+			      int is_ehci);
+
+/* Destroy a USB context.
+ *
+ *  Once destroyed, a context may not be used with any gxio_usb_host routines
+ *  other than gxio_usb_host_init().  After this routine returns, no further
+ *  interrupts or signals requested on this context will be delivered.  The
+ *  state and configuration of the pins which had been attached to this
+ *  context are unchanged by this operation.
+ *
+ * @param context Pointer to a gxio_usb_host_context_t.
+ * @return Zero if the context was successfully destroyed, else a
+ *  GXIO_ERR_xxx error code.
+ */
+extern int gxio_usb_host_destroy(gxio_usb_host_context_t * context);
+
+/* Retrieve the address of the shim's MMIO registers.
+ *
+ * @param context Pointer to a properly initialized gxio_usb_host_context_t.
+ * @return The address of the shim's MMIO registers.
+ */
+extern void *gxio_usb_host_get_reg_start(gxio_usb_host_context_t * context);
+
+/* Retrieve the length of the shim's MMIO registers.
+ *
+ * @param context Pointer to a properly initialized gxio_usb_host_context_t.
+ * @return The length of the shim's MMIO registers.
+ */
+extern size_t gxio_usb_host_get_reg_len(gxio_usb_host_context_t * context);
+
+#endif /* _GXIO_USB_H_ */
diff --git a/arch/tile/include/hv/drv_usb_host_intf.h b/arch/tile/include/hv/drv_usb_host_intf.h
new file mode 100644
index 0000000..24ce774
--- /dev/null
+++ b/arch/tile/include/hv/drv_usb_host_intf.h
@@ -0,0 +1,39 @@
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
+ * Interface definitions for the USB host driver.
+ */
+
+#ifndef _SYS_HV_DRV_USB_HOST_INTF_H
+#define _SYS_HV_DRV_USB_HOST_INTF_H
+
+#include <arch/usb_host.h>
+
+
+/** Offset for the EHCI register MMIO region. */
+#define HV_USB_HOST_MMIO_OFFSET_EHCI ((uint64_t) USB_HOST_HCCAPBASE_REG)
+
+/** Offset for the OHCI register MMIO region. */
+#define HV_USB_HOST_MMIO_OFFSET_OHCI ((uint64_t) USB_HOST_OHCD_HC_REVISION_REG)
+
+/** Size of the register MMIO region.  This turns out to be the same for
+ *  both EHCI and OHCI. */
+#define HV_USB_HOST_MMIO_SIZE ((uint64_t) 0x1000)
+
+/** The number of service domains supported by the USB host shim. */
+#define HV_USB_HOST_NUM_SVC_DOM 1
+
+
+#endif /* _SYS_HV_DRV_USB_HOST_INTF_H */
-- 
1.7.10.3

