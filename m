Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab1BXEmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 23:42:46 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57025 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab1BXEmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 23:42:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6266"; a="76326588"
From: Kenneth Heitke <kheitke@codeaurora.org>
To: davidb@codeaurora.org, amirs@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, Kenneth Heitke <kheitke@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH] msm: sps: Smart Peripheral System (SPS) driver.
Date: Wed, 23 Feb 2011 21:42:27 -0700
Message-Id: <1298522550-7332-1-git-send-email-kheitke@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Samuelov <amirs@codeaurora.org>

The driver controls the SPS hardware DMA to move data in the following
modes:

1. Peripheral-to-Peripheral
2. Peripheral-to-Memory
3. Memory-to-Memory

This driver complies to BAM hardware version#2.

Signed-off-by: Amir Samuelov <amirs@codeaurora.org>
Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
---
This patch is being submitted as RFC to get early feedback from the
community.

 arch/arm/mach-msm/Kconfig                |   23 +
 arch/arm/mach-msm/Makefile               |    1 +
 arch/arm/mach-msm/include/mach/msm_sps.h |   25 +
 arch/arm/mach-msm/include/mach/sps.h     | 1105 ++++++++++++++++++
 arch/arm/mach-msm/sps/Makefile           |    2 +
 arch/arm/mach-msm/sps/bam.c              |  588 ++++++++++
 arch/arm/mach-msm/sps/bam.h              |  375 ++++++
 arch/arm/mach-msm/sps/sps.c              | 1359 ++++++++++++++++++++++
 arch/arm/mach-msm/sps/sps_bam.c          | 1820 ++++++++++++++++++++++++++++++
 arch/arm/mach-msm/sps/sps_bam.h          |  547 +++++++++
 arch/arm/mach-msm/sps/sps_core.h         |  107 ++
 arch/arm/mach-msm/sps/sps_dma.c          |  896 +++++++++++++++
 arch/arm/mach-msm/sps/sps_map.c          |  137 +++
 arch/arm/mach-msm/sps/sps_map.h          |   46 +
 arch/arm/mach-msm/sps/sps_mem.c          |  156 +++
 arch/arm/mach-msm/sps/sps_rm.c           |  806 +++++++++++++
 arch/arm/mach-msm/sps/spsi.h             |  284 +++++
 17 files changed, 8277 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/msm_sps.h
 create mode 100644 arch/arm/mach-msm/include/mach/sps.h
 create mode 100644 arch/arm/mach-msm/sps/Makefile
 create mode 100644 arch/arm/mach-msm/sps/bam.c
 create mode 100644 arch/arm/mach-msm/sps/bam.h
 create mode 100644 arch/arm/mach-msm/sps/sps.c
 create mode 100644 arch/arm/mach-msm/sps/sps_bam.c
 create mode 100644 arch/arm/mach-msm/sps/sps_bam.h
 create mode 100644 arch/arm/mach-msm/sps/sps_core.h
 create mode 100644 arch/arm/mach-msm/sps/sps_dma.c
 create mode 100644 arch/arm/mach-msm/sps/sps_map.c
 create mode 100644 arch/arm/mach-msm/sps/sps_map.h
 create mode 100644 arch/arm/mach-msm/sps/sps_mem.c
 create mode 100644 arch/arm/mach-msm/sps/sps_rm.c
 create mode 100644 arch/arm/mach-msm/sps/spsi.h

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 997c5bd..0ca8720 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -210,4 +210,27 @@ config IOMMU_API
 
 config MSM_SCM
 	bool
+
+config SPS
+	bool "SPS support"
+	depends on (HAS_IOMEM && ARCH_MSM8960)
+	select GENERIC_ALLOCATOR
+	default n
+	help
+	  The SPS (Smart Peripheral Switch) is a DMA engine.
+	  It can move data in the following modes:
+		1. Peripheral-to-Peripheral.
+		2. Peripheral-to-Memory.
+		3. Memory-to-Memory.
+
+config SPS_SUPPORT_BAMDMA
+	bool "SPS support BAM DMA"
+	depends on SPS
+	default n
+	help
+	  The BAM-DMA is used for Memory-to-Memory transfers.
+	  The main use cases is RPC between processors.
+	  The BAM-DMA hardware has 2 registers sets:
+	  1. A BAM HW like all the peripherals.
+	  2. A DMA channel configuration (i.e. channel priority).
 endif
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 2099c97..28553ac 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_MSM_SCM) += scm.o scm-boot.o
 
 obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
 obj-$(CONFIG_SMP) += headsmp.o platsmp.o
+obj-$(CONFIG_SPS) += sps/
 
 obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
 obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o board-trout-panel.o devices-msm7x00.o
diff --git a/arch/arm/mach-msm/include/mach/msm_sps.h b/arch/arm/mach-msm/include/mach/msm_sps.h
new file mode 100644
index 0000000..3af6f71
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/msm_sps.h
@@ -0,0 +1,25 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _MSM_SPS_H_
+#define _MSM_SPS_H_
+
+/**
+ * struct msm_sps_platform_data - SPS Platform specific data.
+ * @bamdma_restricted_pipes - Bitmask of pipes restricted from local use.
+ *
+ */
+struct msm_sps_platform_data {
+	u32 bamdma_restricted_pipes;
+};
+
+#endif /* _MSM_SPS_H_ */
+
diff --git a/arch/arm/mach-msm/include/mach/sps.h b/arch/arm/mach-msm/include/mach/sps.h
new file mode 100644
index 0000000..f4819d9
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/sps.h
@@ -0,0 +1,1105 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* Smart-Peripheral-Switch (SPS) API. */
+
+#ifndef _SPS_H_
+#define _SPS_H_
+
+#include <linux/types.h>	/* u32 */
+
+/* SPS device handle indicating use of system memory */
+#define SPS_DEV_HANDLE_MEM       ((u32)0x7ffffffful)
+
+/* SPS device handle indicating use of BAM-DMA */
+
+/* SPS device handle invalid value */
+#define SPS_DEV_HANDLE_INVALID   ((u32)0)
+
+/* BAM invalid IRQ value */
+#define SPS_IRQ_INVALID          0
+
+/* Invalid address value */
+#define SPS_ADDR_INVALID      0
+
+/* Invalid peripheral device enumeration class */
+#define SPS_CLASS_INVALID     ((u32)-1)
+
+/*
+ * This value specifies different configurations for an SPS connection.
+ * A non-default value instructs the SPS driver to search for the configuration
+ * in the fixed connection mapping table.
+ */
+#define SPS_CONFIG_DEFAULT       0
+
+/*
+ * This value instructs the SPS driver to use the default BAM-DMA channel
+ * threshold
+ */
+#define SPS_DMA_THRESHOLD_DEFAULT   0
+
+/* Flag bits supported by SPS hardware for struct sps_iovec */
+#define SPS_IOVEC_FLAG_INT  0x8000  /* Generate interrupt */
+#define SPS_IOVEC_FLAG_EOT  0x4000  /* Generate end-of-transfer indication */
+#define SPS_IOVEC_FLAG_EOB  0x2000  /* Generate end-of-block indication */
+#define SPS_IOVEC_FLAG_NO_SUBMIT 0x0100  /* Do not submit descriptor to HW */
+#define SPS_IOVEC_FLAG_DEFAULT   0x0001  /* Use driver default */
+
+/* BAM device options flags */
+
+/*
+ * BAM will be configured and enabled at boot.  Otherwise, BAM will be
+ * configured and enabled when first pipe connect occurs.
+ */
+#define SPS_BAM_OPT_ENABLE_AT_BOOT  1UL
+/* BAM IRQ is disabled */
+#define SPS_BAM_OPT_IRQ_DISABLED    (1UL << 1)
+/* BAM peripheral is a BAM-DMA */
+#define SPS_BAM_OPT_BAMDMA          (1UL << 2)
+
+/* BAM device management flags */
+
+/* BAM global device control is managed remotely */
+#define SPS_BAM_MGR_DEVICE_REMOTE   1UL
+/* BAM device supports multiple execution environments */
+#define SPS_BAM_MGR_MULTI_EE        (1UL << 1)
+/* BAM pipes are *not* allocated locally */
+#define SPS_BAM_MGR_PIPE_NO_ALLOC   (1UL << 2)
+/* BAM pipes are *not* configured locally */
+#define SPS_BAM_MGR_PIPE_NO_CONFIG  (1UL << 3)
+/* BAM pipes are *not* controlled locally */
+#define SPS_BAM_MGR_PIPE_NO_CTRL    (1UL << 4)
+/* "Globbed" management properties */
+#define SPS_BAM_MGR_NONE            \
+	(SPS_BAM_MGR_DEVICE_REMOTE | SPS_BAM_MGR_PIPE_NO_ALLOC | \
+	 SPS_BAM_MGR_PIPE_NO_CONFIG | SPS_BAM_MGR_PIPE_NO_CTRL)
+#define SPS_BAM_MGR_LOCAL           0
+#define SPS_BAM_MGR_LOCAL_SHARED    SPS_BAM_MGR_MULTI_EE
+#define SPS_BAM_MGR_REMOTE_SHARED   \
+	(SPS_BAM_MGR_DEVICE_REMOTE | SPS_BAM_MGR_MULTI_EE | \
+	 SPS_BAM_MGR_PIPE_NO_ALLOC)
+#define SPS_BAM_MGR_ACCESS_MASK     SPS_BAM_MGR_NONE
+
+/* This enum specifies the operational mode for an SPS connection */
+enum sps_mode {
+	SPS_MODE_SRC = 0,  /* end point is the source (producer) */
+	SPS_MODE_DEST,	   /* end point is the destination (consumer) */
+};
+
+
+/*
+ * This enum is a set of bit flag options for SPS connection.
+ * The enums should be OR'd together to create the option set
+ * for the SPS connection.
+ */
+enum sps_option {
+	/*
+	 * Options to enable specific SPS hardware interrupts.
+	 * These bit flags are also used to indicate interrupt source
+	 * for the SPS_EVENT_IRQ event.
+	 */
+	SPS_O_DESC_DONE = 0x00000001,  /* Descriptor processed */
+	SPS_O_INACTIVE  = 0x00000002,  /* Inactivity timeout */
+	SPS_O_WAKEUP    = 0x00000004,  /* Peripheral wake up */
+	SPS_O_OUT_OF_DESC = 0x00000008,/* Out of descriptors */
+	SPS_O_ERROR     = 0x00000010,  /* Error */
+	SPS_O_EOT       = 0x00000020,  /* End-of-transfer */
+
+	/* Options to enable hardware features */
+	SPS_O_STREAMING = 0x00010000,  /* Enable streaming mode (no EOT) */
+	/* Use MTI/SETPEND instead of BAM interrupt */
+	SPS_O_IRQ_MTI   = 0x00020000,
+
+	/* Options to enable software features */
+	/* Transfer operation should be polled */
+	SPS_O_POLL      = 0x01000000,
+	/* Disable queuing of transfer events for the connection end point */
+	SPS_O_NO_Q      = 0x02000000,
+	SPS_O_FLOWOFF   = 0x04000000,  /* Graceful halt */
+	/* SPS_O_WAKEUP will be disabled after triggered */
+	SPS_O_WAKEUP_IS_ONESHOT = 0x08000000,
+	/**
+	 * Client must read each descriptor from the FIFO
+	 * using sps_get_iovec()
+	 */
+	SPS_O_ACK_TRANSFERS = 0x10000000,
+	/* Connection is automatically enabled */
+	SPS_O_AUTO_ENABLE = 0x20000000,
+	/* DISABLE endpoint synchronization for config/enable/disable */
+	SPS_O_NO_EP_SYNC = 0x40000000,
+};
+
+/**
+ * This enum specifies BAM DMA channel priority.  Clients should use
+ * SPS_DMA_PRI_DEFAULT unless a specific priority is required.
+ */
+enum sps_dma_priority {
+	SPS_DMA_PRI_DEFAULT = 0,
+	SPS_DMA_PRI_LOW,
+	SPS_DMA_PRI_MED,
+	SPS_DMA_PRI_HIGH,
+};
+
+/*
+ * This enum specifies the ownership of a connection resource.
+ * Remote or shared ownership is only possible/meaningful on the processor
+ * that controls resource.
+ */
+enum sps_owner {
+	SPS_OWNER_LOCAL = 0x1,	/* Resource is owned by local processor */
+	SPS_OWNER_REMOTE = 0x2,	/* Resource is owned by a satellite processor */
+};
+
+/* This enum indicates the event associated with a client event trigger */
+enum sps_event {
+	SPS_EVENT_INVALID = 0,
+
+	SPS_EVENT_EOT,		/* End-of-transfer */
+	SPS_EVENT_DESC_DONE,	/* Descriptor processed */
+	SPS_EVENT_OUT_OF_DESC,	/* Out of descriptors */
+	SPS_EVENT_WAKEUP,	/* Peripheral wake up */
+	SPS_EVENT_FLOWOFF,	/* Graceful halt (idle) */
+	SPS_EVENT_INACTIVE,	/* Inactivity timeout */
+	SPS_EVENT_ERROR,	/* Error */
+	SPS_EVENT_MAX,
+};
+
+/*
+ * This enum specifies the event trigger mode and is an argument for the
+ * sps_register_event() function.
+ */
+enum sps_trigger {
+	/* Trigger with payload for callback */
+	SPS_TRIGGER_CALLBACK = 0,
+	/* Trigger without payload for wait or poll */
+	SPS_TRIGGER_WAIT,
+};
+
+/*
+ * This enum indicates the desired halting mechanism and is an argument for the
+ * sps_flow_off() function
+ */
+enum sps_flow_off {
+	SPS_FLOWOFF_FORCED = 0,	/* Force hardware into halt state */
+	/* Allow hardware to empty pipe before halting */
+	SPS_FLOWOFF_GRACEFUL,
+};
+
+/*
+ * This enum indicates the target memory heap and is an argument for the
+ * sps_mem_alloc() function.
+ */
+enum sps_mem {
+	SPS_MEM_LOCAL = 0,  /* SPS subsystem local (pipe) memory */
+	SPS_MEM_UC,	    /* Microcontroller (ARM7) local memory */
+};
+
+/*
+ * This enum indicates a timer control operation and is an argument for the
+ * sps_timer_ctrl() function.
+ */
+enum sps_timer_op {
+	SPS_TIMER_OP_CONFIG = 0,
+	SPS_TIMER_OP_RESET,
+/*   SPS_TIMER_OP_START,   Not supported by hardware yet */
+/*   SPS_TIMER_OP_STOP,    Not supported by hardware yet */
+	SPS_TIMER_OP_READ,
+};
+
+/*
+ * This enum indicates the inactivity timer operating mode and is an
+ * argument for the sps_timer_ctrl() function.
+ */
+enum sps_timer_mode {
+	SPS_TIMER_MODE_ONESHOT = 0,
+/*   SPS_TIMER_MODE_PERIODIC,    Not supported by hardware yet */
+};
+
+/**
+ * This data type corresponds to the native I/O vector (BAM descriptor)
+ * supported by SPS hardware
+ *
+ * @addr - Buffer physical address.
+ * @size - Buffer size in bytes.
+ * @flags -Flag bitmask (see SPS_IOVEC_FLAG_ #defines).
+ *
+ */
+struct sps_iovec {
+	u32 addr;
+	u32 size:16;
+	u32 flags:16;
+};
+
+/**
+ * This struct defines a BAM device. The client must memset() this struct to
+ * zero before writing device information.  A value of zero for uninitialized
+ * values will instruct the SPS driver to use general defaults or
+ * hardware/BIOS supplied values.
+ *
+ *
+ * @options - See SPS_BAM_OPT_* bit flag.
+ * @phys_addr - BAM base physical address (not peripheral address).
+ * @virt_addr - BAM base virtual address.
+ * @virt_size - For virtual mapping.
+ * @irq - IRQ enum for use in ISR vector install.
+ * @num_pipes - number of pipes. Can be read from hardware.
+ * @summing_threshold - BAM event threshold.
+ *
+ * @periph_class - Peripheral device enumeration class.
+ * @periph_dev_id - Peripheral global device ID.
+ * @periph_phys_addr - Peripheral base physical address, for BAM-DMA only.
+ * @periph_virt_addr - Peripheral base virtual address.
+ * @periph_virt_size - Size for virtual mapping.
+ *
+ * @event_threshold - Pipe event threshold.
+ * @desc_size - Size (bytes) of descriptor FIFO.
+ * @data_size - Size (bytes) of data FIFO.
+ * @desc_mem_id - Heap ID for default descriptor FIFO allocations.
+ * @data_mem_id - Heap ID for default data FIFO allocations.
+ *
+ * @manage - BAM device management flags (see SPS_BAM_MGR_*).
+ * @restricted_pipes - Bitmask of pipes restricted from local use.
+ * @ee - Local execution environment index.
+ *
+ * @irq_gen_addr - MTI interrupt generation address. This configuration only
+ * applies to BAM rev 1 and 2 hardware. MTIs are only supported on BAMs when
+ * global config is controlled by a remote processor.
+ * NOTE: This address must correspond to the MTI associated with the "irq" IRQ
+ * enum specified above.
+ *
+ */
+struct sps_bam_props {
+
+	/* BAM device properties. */
+
+	u32 options;
+	u32 phys_addr;
+	void *virt_addr;
+	u32 virt_size;
+	u32 irq;
+	u32 num_pipes;
+	u32 summing_threshold;
+
+	/* Peripheral device properties */
+
+	u32 periph_class;
+	u32 periph_dev_id;
+	u32 periph_phys_addr;
+	void *periph_virt_addr;
+	u32 periph_virt_size;
+
+	/* Connection pipe parameter defaults. */
+
+	u32 event_threshold;
+	u32 desc_size;
+	u32 data_size;
+	u32 desc_mem_id;
+	u32 data_mem_id;
+
+	/* Security properties */
+
+	u32 manage;
+	u32 restricted_pipes;
+	u32 ee;
+
+	/* BAM MTI interrupt generation */
+
+	u32 irq_gen_addr;
+
+};
+
+/**
+ *  This struct specifies memory buffer properties.
+ *
+ * @base - Buffer virtual address.
+ * @phys_base - Buffer physical address.
+ * @size - Specifies buffer size (or maximum size).
+ * @min_size - If non-zero, specifies buffer minimum size.
+ *
+ */
+struct sps_mem_buffer {
+	void *base;
+	u32 phys_base;
+	u32 size;
+	u32 min_size;
+};
+
+/**
+ * This struct defines a connection's end point and is used as the argument
+ * for the sps_connect(), sps_get_config(), and sps_set_config() functions.
+ * For system mode pipe, use SPS_DEV_HANDLE_MEM for the end point that
+ * corresponds to system memory.
+ *
+ * The client can force SPS to reserve a specific pipe on a BAM.
+ * If the pipe is in use, the sps_connect/set_config() will fail.
+ *
+ * @source - Source BAM.
+ * @src_pipe_index - BAM pipe index, 0 to 30.
+ * @destination - Destination BAM.
+ * @dest_pipe_index - BAM pipe index, 0 to 30.
+ *
+ * @mode - specifies which end (source or destination) of the connection will
+ * be controlled/referenced by the client.
+ *
+ * @config - This value is for future use and should be set to
+ * SPS_CONFIG_DEFAULT or left as default from sps_get_config().
+ *
+ * @options - OR'd connection end point options (see SPS_O defines).
+ *
+ * WARNING: The memory provided should be physically contiguous and non-cached.
+ * The user can use one of the following:
+ * 1. sps_alloc_mem() - allocated from pipe-memory.
+ * 2. dma_alloc_coherent() - allocate coherent DMA memory.
+ * 3. dma_map_single() - for using memory allocated by kmalloc().
+ *
+ * @desc - Descriptor FIFO.
+ * @data - Data FIFO (BAM-to-BAM mode only).
+ *
+ * @event_thresh - Pipe event threshold or derivative.
+ *
+ * @sps_reserved - Reserved word - client must not modify.
+ *
+ */
+struct sps_connect {
+	u32 source;
+	u32 src_pipe_index;
+	u32 destination;
+	u32 dest_pipe_index;
+
+	enum sps_mode mode;
+
+	u32 config;
+
+	enum sps_option options;
+
+	struct sps_mem_buffer desc;
+	struct sps_mem_buffer data;
+
+	u32 event_thresh;
+
+	/* SETPEND/MTI interrupt generation parameters */
+
+	u32 irq_gen_addr;
+	u32 irq_gen_data;
+
+	u32 sps_reserved;
+
+};
+
+/**
+ * This struct defines a satellite connection's end point.  The client of the
+ * SPS driver on the satellite processor must call sps_get_config() to
+ * initialize a struct sps_connect, then copy the values from the struct
+ * sps_satellite to the struct sps_connect before making the sps_connect()
+ * call to the satellite SPS driver.
+ *
+ */
+struct sps_satellite {
+	/**
+	 * These values must be copied to either the source or destination
+	 * corresponding values in the connect struct.
+	 */
+	u32 dev;
+	u32 pipe_index;
+
+	/**
+	 * These values must be copied to the corresponding values in the
+	 * connect struct
+	 */
+	u32 config;
+	enum sps_option options;
+
+};
+
+/**
+ * This struct defines parameters for allocation of a BAM DMA channel. The
+ * client must memset() this struct to zero before writing allocation
+ * information.  A value of zero for uninitialized values will instruct
+ * the SPS driver to use defaults or "don't care".
+ *
+ * @dev - Associated BAM device handle, or SPS_DEV_HANDLE_DMA.
+ *
+ * @src_owner - Source owner processor ID.
+ * @dest_owner - Destination owner processor ID.
+ *
+ */
+struct sps_alloc_dma_chan {
+	u32 dev;
+
+	/* BAM DMA channel configuration parameters */
+
+	u32 threshold;
+	enum sps_dma_priority priority;
+
+	/**
+	 * Owner IDs are global host processor identifiers used by the system
+	 * SROT when establishing execution environments.
+	 */
+	u32 src_owner;
+	u32 dest_owner;
+
+};
+
+/**
+ * This struct defines parameters for an allocated BAM DMA channel.
+ *
+ * @dev - BAM DMA device handle.
+ * @dest_pipe_index - Destination/input/write pipe index.
+ * @src_pipe_index - Source/output/read pipe index.
+ *
+ */
+struct sps_dma_chan {
+	u32 dev;
+	u32 dest_pipe_index;
+	u32 src_pipe_index;
+};
+
+/**
+ * This struct is an argument passed payload when triggering a callback event
+ * object registered for an SPS connection end point.
+ *
+ * @user - Pointer registered with sps_register_event().
+ *
+ * @event_id - Which event.
+ *
+ * @iovec - The associated I/O vector. If the end point is a system-mode
+ * producer, the size will reflect the actual number of bytes written to the
+ * buffer by the pipe. NOTE: If this I/O vector was part of a set submitted to
+ * sps_transfer(), then the vector array itself will be	updated with all of
+ * the actual counts.
+ *
+ * @user - Pointer registered with the transfer.
+ *
+ */
+struct sps_event_notify {
+	void *user;
+
+	enum sps_event event_id;
+
+	/* Data associated with the event */
+
+	union {
+		/* Data for SPS_EVENT_IRQ */
+		struct {
+			u32 mask;
+		} irq;
+
+		/* Data for SPS_EVENT_EOT or SPS_EVENT_DESC_DONE */
+
+		struct {
+			struct sps_iovec iovec;
+			void *user;
+		} transfer;
+
+		/* Data for SPS_EVENT_ERROR */
+
+		struct {
+			u32 status;
+		} err;
+
+	} data;
+};
+
+/**
+ * This struct defines a event registration parameters and is used as the
+ * argument for the sps_register_event() function.
+ *
+ * @options - Event options that will trigger the event object.
+ * @mode - Event trigger mode.
+ *
+ * @xfer_done - a pointer to a completion object. NULL if not in use.
+ *
+ * @callback - a callback to call on completion. NULL if not in use.
+ *
+ * @user - User pointer that will be provided in event callback data.
+ *
+ */
+struct sps_register_event {
+	enum sps_option options;
+	enum sps_trigger mode;
+	struct completion *xfer_done;
+	void (*callback)(struct sps_event_notify *notify);
+	void *user;
+};
+
+/**
+ * This struct defines a system memory transfer's parameters and is used as the
+ * argument for the sps_transfer() function.
+ *
+ * @iovec_phys - Physical address of I/O vectors buffer.
+ * @iovec - Pointer to I/O vectors buffer.
+ * @iovec_count - Number of I/O vectors.
+ * @user - User pointer passed in callback event.
+ *
+ */
+struct sps_transfer {
+	u32 iovec_phys;
+	struct sps_iovec *iovec;
+	u32 iovec_count;
+	void *user;
+};
+
+/**
+ * This struct defines a timer control operation parameters and is used as an
+ * argument for the sps_timer_ctrl() function.
+ *
+ * @op - Timer control operation.
+ * @timeout_msec - Inactivity timeout (msec).
+ *
+ */
+struct sps_timer_ctrl {
+	enum sps_timer_op op;
+
+	/**
+	 * The following configuration parameters must be set when the timer
+	 * control operation is SPS_TIMER_OP_CONFIG.
+	 */
+	enum sps_timer_mode mode;
+	u32 timeout_msec;
+};
+
+/**
+ * This struct defines a timer control operation result and is used as an
+ * argument for the sps_timer_ctrl() function.
+ */
+struct sps_timer_result {
+	u32 current_timer;
+};
+
+
+/*----------------------------------------------------------------------------
+ * Functions specific to sps interface
+ * -------------------------------------------------------------------------*/
+struct sps_pipe;	/* Forward declaration */
+
+/**
+ * Register a BAM device
+ *
+ * This function registers a BAM device with the SPS driver. For each
+ *peripheral that includes a BAM, the peripheral driver must register
+ * the BAM with the SPS driver.
+ *
+ * A requirement is that the peripheral driver must remain attached
+ * to the SPS driver until the BAM is deregistered. Otherwise, the
+ * system may attempt to unload the SPS driver. BAM registrations would
+ * be lost.
+ *
+ * @bam_props - Pointer to struct for BAM device properties.
+ *
+ * @dev_handle - Device handle will be written to this location (output).
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_register_bam_device(const struct sps_bam_props *bam_props,
+			    u32 *dev_handle);
+
+/**
+ * Deregister a BAM device
+ *
+ * This function deregisters a BAM device from the SPS driver. The peripheral
+ * driver should deregister a BAM when the peripheral driver is shut down or
+ * when BAM use should be disabled.
+ *
+ * A BAM cannot be deregistered if any of its pipes is in an active connection.
+ *
+ * When all BAMs have been deregistered, the system is free to unload the
+ * SPS driver.
+ *
+ * @dev_handle - BAM device handle.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_deregister_bam_device(u32 dev_handle);
+
+/**
+ * Allocate client state context
+ *
+ * This function allocate and initializes a client state context struct.
+ *
+ * @return pointer to client state context
+ *
+ */
+struct sps_pipe *sps_alloc_endpoint(void);
+
+/**
+ * Free client state context
+ *
+ * This function de-initializes and free a client state context struct.
+ *
+ * @ctx - client context for SPS connection end point
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_free_endpoint(struct sps_pipe *h);
+
+/**
+ * Get the configuration parameters for an SPS connection end point
+ *
+ * This function retrieves the configuration parameters for an SPS connection
+ * end point.
+ * This function may be called before the end point is connected (before
+ * sps_connect is called). This allows the client to specify parameters before
+ * the connection is established.
+ *
+ * The client must call this function to fill it's struct sps_connect
+ * struct before modifying values and passing the struct to sps_set_config().
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @config - Pointer to buffer for the end point's configuration parameters.
+ * Must not be NULL.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_get_config(struct sps_pipe *h, struct sps_connect *config);
+
+/**
+ * Allocate memory from the SPS Pipe-Memory.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @mem - memory type - N/A.
+ *
+ * @mem_buffer - Pointer to struct for allocated memory properties.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_alloc_mem(struct sps_pipe *h, enum sps_mem mem,
+		  struct sps_mem_buffer *mem_buffer);
+
+/**
+ * Free memory from the SPS Pipe-Memory.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @mem_buffer - Pointer to struct for allocated memory properties.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_free_mem(struct sps_pipe *h, struct sps_mem_buffer *mem_buffer);
+
+/**
+ * Connect an SPS connection end point
+ *
+ * This function creates a connection between two SPS peripherals or between
+ * an SPS peripheral and the local host processor (via system memory, end
+ *point SPS_DEV_HANDLE_MEM). Establishing the connection includes
+ * initialization of the SPS hardware and allocation of any other connection
+ * resources (buffer memory, etc.).
+ *
+ * This function requires the client to specify both the source and
+ * destination end points of the SPS connection. However, the handle
+ * returned applies only to the end point of the connection that the client
+ * controls. The end point under control must be specified by the
+ * enum sps_mode mode argument, either SPS_MODE_SRC, SPS_MODE_DEST, or
+ * SPS_MODE_CTL. Note that SPS_MODE_CTL is only supported for I/O
+ * accelerator connections, and only a limited set of control operations are
+ * allowed (TBD).
+ *
+ * For a connection involving system memory
+ * (SPS_DEV_HANDLE_MEM), the peripheral end point must be
+ * specified. For example, SPS_MODE_SRC must be specified for a
+ * BAM-to-system connection, since the BAM pipe is the data
+ * producer.
+ *
+ * For a specific peripheral-to-peripheral connection, there may be more than
+ * one required configuration. For example, there might be high-performance
+ * and low-power configurations for a connection between the two peripherals.
+ * The config argument allows the client to specify different configurations,
+ * which may require different system resource allocations and hardware
+ * initialization.
+ *
+ * A client is allowed to create one and only one connection for its
+ * struct sps_pipe. The handle is used to identify the connection end point
+ * in subsequent SPS driver calls. A specific connection source or
+ * destination end point can be associated with one and only one
+ * struct sps_pipe.
+ *
+ * The client must establish an open device handle to the SPS. To do so, the
+ * client must attach to the SPS driver and open the SPS device by calling
+ * the following functions.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @connect - Pointer to connection parameters
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_connect(struct sps_pipe *h, struct sps_connect *connect);
+
+/**
+ * Disconnect an SPS connection end point
+ *
+ * This function disconnects an SPS connection end point.
+ * The SPS hardware associated with that end point will be disabled.
+ * For a connection involving system memory (SPS_DEV_HANDLE_MEM), all
+ * connection resources are deallocated. For a peripheral-to-peripheral
+ * connection, the resources associated with the connection will not be
+ * deallocated until both end points are closed.
+ *
+ * The client must call sps_connect() for the handle before calling
+ * this function.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_disconnect(struct sps_pipe *h);
+
+/**
+ * Register an event object for an SPS connection end point
+ *
+ * This function registers a callback event object for an SPS connection end
+ *point. The registered event object will be triggered for the set of
+ * events specified in reg->options that are enabled for the end point.
+ *
+ * There can only be one registered event object for each event. If an event
+ * object is already registered for an event, it will be replaced. If
+ *reg->event handle is NULL, then any registered event object for the
+ * event will be deregistered. Option bits in reg->options not associated
+ * with events are ignored.
+ *
+ * The client must call sps_connect() for the handle before calling
+ * this function.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @reg - Pointer to event registration parameters
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_register_event(struct sps_pipe *h, struct sps_register_event *reg);
+
+/**
+ * Perform a single DMA transfer on an SPS connection end point
+ *
+ * This function submits a DMA transfer request consisting of a single buffer
+ * for an SPS connection end point associated with a peripheral-to/from-memory
+ * connection. The request will be submitted immediately to hardware if the
+ * hardware is idle (data flow off, no other pending transfers). Otherwise, it
+ * will be queued for later handling in the SPS driver work loop.
+ *
+ * The data buffer must be DMA ready. The client is responsible for insuring
+ *physically contiguous memory, cache maintenance, and memory barrier. For
+ * more information, see Appendix A.
+ *
+ * The client must not modify the data buffer until the completion indication is
+ * received.
+ *
+ * This function cannot be used if transfer queuing is disabled (see option
+ * SPS_O_NO_Q). The client must set the SPS_O_EOT option to receive a callback
+ * event trigger when the transfer is complete. The SPS driver will insure the
+ * appropriate flags in the I/O vectors are set to generate the completion
+ * indication.
+ *
+ * The return value from this function may indicate that an error occurred.
+ * Possible causes include invalid arguments.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @addr - Physical address of buffer to transfer.
+ *
+ * WARNING: The memory provided	should be physically contiguous and
+ * non-cached.
+ *
+ * The user can use one of the following:
+ * 1. sps_alloc_mem() - allocated from pipe-memory.
+ * 2. dma_alloc_coherent() - allocate DMA memory.
+ * 3. dma_map_single() for memory allocated by kmalloc().
+ *
+ * @size - Size in bytes of buffer to transfer
+ *
+ * @user - User pointer that will be returned to user as part of
+ *  event payload
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_transfer_one(struct sps_pipe *h, u32 addr, u32 size,
+		     void *user, u32 flags);
+
+/**
+ * Read event queue for an SPS connection end point
+ *
+ * This function reads event queue for an SPS connection end point.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @event - pointer to client's event data buffer
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_get_event(struct sps_pipe *h, struct sps_event_notify *event);
+
+/**
+ * Get processed I/O vector (completed transfers)
+ *
+ * This function fetches the next processed I/O vector.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @iovec - Pointer to I/O vector struct (output).
+ * This struct will be zeroed if there are no more processed I/O vectors.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_get_iovec(struct sps_pipe *h, struct sps_iovec *iovec);
+
+/**
+ * Enable an SPS connection end point
+ *
+ * This function enables an SPS connection end point.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_flow_on(struct sps_pipe *h);
+
+/**
+ * Disable an SPS connection end point
+ *
+ * This function disables an SPS connection end point.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @mode - Desired mode for disabling pipe data flow
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_flow_off(struct sps_pipe *h, enum sps_flow_off mode);
+
+/**
+ * Perform a Multiple DMA transfer on an SPS connection end point
+ *
+ * This function submits a DMA transfer request for an SPS connection end point
+ * associated with a peripheral-to/from-memory connection. The request will be
+ * submitted immediately to hardware if the hardware is idle (data flow off, no
+ * other pending transfers). Otherwise, it will be queued for later handling in
+ * the SPS driver work loop.
+ *
+ * The data buffers referenced by the I/O vectors must be DMA ready.
+ * The client is responsible for insuring physically contiguous memory,
+ * any cache maintenance, and memory barrier. For more information,
+ * see Appendix A.
+ *
+ * The I/O vectors must specify physical addresses for the referenced buffers.
+ *
+ * The client must not modify the data buffers referenced by I/O vectors until
+ * the completion indication is received.
+ *
+ * If transfer queuing is disabled (see option SPS_O_NO_Q), the client is
+ * responsible for setting the appropriate flags in the I/O vectors to generate
+ * the completion indication. Also, the client is responsible for enabling the
+ * appropriate connection callback event options for completion indication (see
+ * sps_connect(), sps_set_config()).
+ *
+ * If transfer queuing is enabled, the client must set the SPS_O_EOT option to
+ * receive a callback event trigger when the transfer is complete. The SPS
+ * driver will insure the appropriate flags in the I/O vectors are set to
+ * generate the completion indication. The client must not set any flags in the
+ * I/O vectors, as this may cause the SPS driver to become out of sync with the
+ * hardware.
+ *
+ * The return value from this function may indicate that an error occurred.
+ * Possible causes include invalid arguments. If transfer queuing is disabled,
+ * an error will occur if the pipe is already processing a transfer.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @transfer - Pointer to transfer parameter struct
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_transfer(struct sps_pipe *h, struct sps_transfer *transfer);
+
+/**
+ * Determine whether an SPS connection end point FIFO is empty
+ *
+ * This function returns the empty state of an SPS connection end point.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @empty - pointer to client's empty status word (boolean)
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_is_pipe_empty(struct sps_pipe *h, u32 *empty);
+
+/**
+ * Reset an SPS BAM device
+ *
+ * This function resets an SPS BAM device.
+ *
+ * @dev - device handle for the BAM
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_device_reset(u32 dev);
+
+/**
+ * Set the configuration parameters for an SPS connection end point
+ *
+ * This function sets the configuration parameters for an SPS connection
+ * end point. This function may be called before the end point is connected
+ * (before sps_connect is called). This allows the client to specify
+ *parameters before the connection is established. The client is allowed
+ * to pre-allocate resources and override driver defaults.
+ *
+ * The client must call sps_get_config() to fill it's struct sps_connect
+ * struct before modifying values and passing the struct to this function.
+ * Only those parameters that differ from the current configuration will
+ * be processed.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @config - Pointer to the end point's new configuration parameters.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_set_config(struct sps_pipe *h, struct sps_connect *config);
+
+/**
+ * Set ownership of an SPS connection end point
+ *
+ * This function sets the ownership of an SPS connection end point to
+ * either local (default) or non-local. This function is used to
+ * retrieve the struct sps_connect data that must be used by a
+ * satellite processor when calling sps_connect().
+ *
+ * Non-local ownership is only possible/meaningful on the processor
+ * that controls resource allocations (apps processor). Setting ownership
+ * to non-local on a satellite processor will fail.
+ *
+ * Setting ownership from non-local to local will succeed only if the
+ * owning satellite processor has properly brought the end point to
+ * an idle condition.
+ *
+ * This function will succeed if the connection end point is already in
+ * the specified ownership state.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @owner - New ownership of the connection end point
+ *
+ * @connect - Pointer to buffer for satellite processor connect data.
+ *  Can be NULL to avoid retrieving the connect data. Will be ignored
+ *  if the end point ownership is set to local.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_set_owner(struct sps_pipe *h, enum sps_owner owner,
+		  struct sps_satellite *connect);
+
+/**
+ * Allocate a BAM DMA channel
+ *
+ * This function allocates a BAM DMA channel. A "BAM DMA" is a special
+ * DMA peripheral with a BAM front end. The DMA peripheral acts as a conduit
+ * for data to flow into a consumer pipe and then out of a producer pipe.
+ * It's primarily purpose is to serve as a path for interprocessor communication
+ * that allows each processor to control and protect it's own memory space.
+ *
+ * @alloc - Pointer to struct for BAM DMA channel allocation properties.
+ *
+ * @chan - Allocated channel information will be written to this
+ *  location (output).
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_alloc_dma_chan(const struct sps_alloc_dma_chan *alloc,
+		       struct sps_dma_chan *chan);
+
+/**
+ * Free a BAM DMA channel
+ *
+ * This function frees a BAM DMA channel.
+ *
+ * @chan - Pointer to information for channel to free
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_free_dma_chan(struct sps_dma_chan *chan);
+
+/**
+ * Get the BAM handle for BAM-DMA.
+ *
+ * The BAM handle should be use as source/destination in the sps_connect().
+ *
+ * @return handle on success, zero on error
+ *
+ */
+u32 sps_dma_get_bam_handle(void);
+
+/**
+ * Free the BAM handle for BAM-DMA.
+ *
+ */
+void sps_dma_free_bam_handle(u32 h);
+
+
+/**
+ * Get number of free transfer entries for an SPS connection end point
+ *
+ * This function returns the number of free transfer entries for an
+ * SPS connection end point.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @count - pointer to count status
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_get_free_count(struct sps_pipe *h, u32 *count);
+
+/**
+ * Perform timer control
+ *
+ * This function performs timer control operations.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @timer_ctrl - Pointer to timer control specification
+ *
+ * @timer_result - Pointer to buffer for timer operation result.
+ *  This argument can be NULL if no result is expected for the operation.
+ *  If non-NULL, the current timer value will always provided.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_timer_ctrl(struct sps_pipe *h,
+		   struct sps_timer_ctrl *timer_ctrl,
+		   struct sps_timer_result *timer_result);
+
+#endif /* _SPS_H_ */
diff --git a/arch/arm/mach-msm/sps/Makefile b/arch/arm/mach-msm/sps/Makefile
new file mode 100644
index 0000000..f19e162
--- /dev/null
+++ b/arch/arm/mach-msm/sps/Makefile
@@ -0,0 +1,2 @@
+obj-y += bam.o sps_bam.o sps.o sps_dma.o sps_map.o sps_mem.o sps_rm.o
+
diff --git a/arch/arm/mach-msm/sps/bam.c b/arch/arm/mach-msm/sps/bam.c
new file mode 100644
index 0000000..be6b038
--- /dev/null
+++ b/arch/arm/mach-msm/sps/bam.c
@@ -0,0 +1,588 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* Bus-Access-Manager (BAM) Hardware manager. */
+
+#include <linux/types.h>	/* u32 */
+#include <linux/kernel.h>	/* pr_info() */
+#include <linux/io.h>		/* ioread32() */
+#include <linux/bitops.h>	/* find_first_bit() */
+#include <linux/errno.h>	/* ENODEV */
+
+#include "bam.h"
+
+/**
+ *  Valid BAM Hardware version.
+ *
+ */
+#define BAM_MIN_VERSION 2
+#define BAM_MAX_VERSION 2
+
+/**
+ *  BAM Hardware registers.
+ *
+ */
+#define CTRL                        (0xf80)
+#define REVISION                    (0xf84)
+#define NUM_PIPES                   (0xfbc)
+#define DESC_CNT_TRSHLD             (0xf88)
+#define IRQ_SRCS                    (0xf8c)
+#define IRQ_SRCS_MSK                (0xf90)
+#define IRQ_SRCS_UNMASKED           (0xfb0)
+#define IRQ_STTS                    (0xf94)
+#define IRQ_CLR                     (0xf98)
+#define IRQ_EN                      (0xf9c)
+#define IRQ_SIC_SEL                 (0xfa0)
+#define AHB_MASTER_ERR_CTRLS        (0xfa4)
+#define AHB_MASTER_ERR_ADDR         (0xfa8)
+#define AHB_MASTER_ERR_DATA         (0xfac)
+#define IRQ_DEST                    (0xfb4)
+#define PERIPH_IRQ_DEST             (0xfb8)
+#define TEST_BUS_REG                (0xff8)
+#define CNFG_BITS                   (0xffc)
+
+#define P_CTRL(n)                  (0x0000 + 128 * (n))
+#define P_RST(n)                   (0x0004 + 128 * (n))
+#define P_HALT(n)                  (0x0008 + 128 * (n))
+#define P_IRQ_STTS(n)              (0x0010 + 128 * (n))
+#define P_IRQ_CLR(n)               (0x0014 + 128 * (n))
+#define P_IRQ_EN(n)                (0x0018 + 128 * (n))
+#define P_TIMER(n)                 (0x001c + 128 * (n))
+#define P_TIMER_CTRL(n)            (0x0020 + 128 * (n))
+#define P_EVNT_DEST_ADDR(n)        (0x102c + 64 * (n))
+#define P_EVNT_REG(n)              (0x1018 + 64 * (n))
+#define P_SW_OFSTS(n)              (0x1000 + 64 * (n))
+#define P_DATA_FIFO_ADDR(n)        (0x1024 + 64 * (n))
+#define P_DESC_FIFO_ADDR(n)        (0x101c + 64 * (n))
+#define P_EVNT_GEN_TRSHLD(n)       (0x1028 + 64 * (n))
+#define P_FIFO_SIZES(n)            (0x1020 + 64 * (n))
+#define P_IRQ_DEST_ADDR(n)         (0x103c + 64 * (n))
+#define P_RETR_CNTXT(n)           (0x1034 + 64 * (n))
+#define P_SI_CNTXT(n)             (0x1038 + 64 * (n))
+#define P_AU_PSM_CNTXT_1(n)       (0x1004 + 64 * (n))
+#define P_PSM_CNTXT_2(n)          (0x1008 + 64 * (n))
+#define P_PSM_CNTXT_3(n)          (0x100c + 64 * (n))
+#define P_PSM_CNTXT_4(n)          (0x1010 + 64 * (n))
+#define P_PSM_CNTXT_5(n)          (0x1014 + 64 * (n))
+
+/**
+ *  BAM Hardware registers bitmask.
+ *  format: <register>_<field>
+ *
+ */
+/* CTRL */
+#define BAM_CACHED_DESC_STORE                   0x8000
+#define BAM_DESC_CACHE_SEL                      0x6000
+#define BAM_PERIPH_IRQ_SIC_SEL                  0x1000
+#define BAM_TESTBUS_SEL                          0xfe0
+#define BAM_EN_ACCUM                              0x10
+#define BAM_EN                                     0x2
+#define BAM_SW_RST                                 0x1
+
+/* IRQ_SRCS */
+#define BAM_IRQ                         0x80000000
+#define P_IRQ                           0x7fffffff
+
+#define IRQ_STTS_BAM_ERROR_IRQ                          0x4
+#define IRQ_STTS_BAM_HRESP_ERR_IRQ                      0x2
+#define IRQ_CLR_BAM_ERROR_CLR                           0x4
+#define IRQ_CLR_BAM_HRESP_ERR_CLR                       0x2
+#define IRQ_EN_BAM_ERROR_EN                             0x4
+#define IRQ_EN_BAM_HRESP_ERR_EN                         0x2
+#define IRQ_SIC_SEL_BAM_IRQ_SIC_SEL              0x80000000
+#define IRQ_SIC_SEL_P_IRQ_SIC_SEL                0x7fffffff
+#define AHB_MASTER_ERR_CTRLS_BAM_ERR_DIRECT_MODE    0x10000
+#define AHB_MASTER_ERR_CTRLS_BAM_ERR_HCID            0xf000
+#define AHB_MASTER_ERR_CTRLS_BAM_ERR_HPROT            0xf00
+#define AHB_MASTER_ERR_CTRLS_BAM_ERR_HBURST            0xe0
+#define AHB_MASTER_ERR_CTRLS_BAM_ERR_HSIZE             0x18
+#define AHB_MASTER_ERR_CTRLS_BAM_ERR_HWRITE             0x4
+#define AHB_MASTER_ERR_CTRLS_BAM_ERR_HTRANS             0x3
+#define CNFG_BITS_BAM_FULL_PIPE                       0x800
+#define CNFG_BITS_BAM_PIPE_CNFG                         0x4
+
+/* P_ctrln */
+#define P_SYS_MODE                             0x20
+#define P_SYS_STRM                             0x10
+#define P_DIRECTION                             0x8
+#define P_EN                                    0x2
+
+#define P_RST_P_SW_RST                                 0x1
+
+#define P_HALT_P_PROD_HALTED                           0x2
+#define P_HALT_P_HALT                                  0x1
+
+#define P_IRQ_STTS_P_TRNSFR_END_IRQ                   0x20
+#define P_IRQ_STTS_P_ERR_IRQ                          0x10
+#define P_IRQ_STTS_P_OUT_OF_DESC_IRQ                   0x8
+#define P_IRQ_STTS_P_WAKE_IRQ                          0x4
+#define P_IRQ_STTS_P_TIMER_IRQ                         0x2
+#define P_IRQ_STTS_P_PRCSD_DESC_IRQ                    0x1
+
+#define P_IRQ_CLR_P_TRNSFR_END_CLR                    0x20
+#define P_IRQ_CLR_P_ERR_CLR                           0x10
+#define P_IRQ_CLR_P_OUT_OF_DESC_CLR                    0x8
+#define P_IRQ_CLR_P_WAKE_CLR                           0x4
+#define P_IRQ_CLR_P_TIMER_CLR                          0x2
+#define P_IRQ_CLR_P_PRCSD_DESC_CLR                     0x1
+
+#define P_IRQ_EN_P_TRNSFR_END_EN                      0x20
+#define P_IRQ_EN_P_ERR_EN                             0x10
+#define P_IRQ_EN_P_OUT_OF_DESC_EN                      0x8
+#define P_IRQ_EN_P_WAKE_EN                             0x4
+#define P_IRQ_EN_P_TIMER_EN                            0x2
+#define P_IRQ_EN_P_PRCSD_DESC_EN                       0x1
+
+#define P_TIMER_P_TIMER                             0xffff
+
+/* P_TIMER_ctrln */
+#define P_TIMER_RST                0x80000000
+#define P_TIMER_RUN                0x40000000
+#define P_TIMER_MODE               0x20000000
+#define P_TIMER_TRSHLD                 0xffff
+
+/* P_EVNT_regn */
+#define P_BYTES_CONSUMED             0xffff0000
+#define P_DESC_FIFO_PEER_OFST            0xffff
+
+/* P_SW_ofstsn */
+#define SW_OFST_IN_DESC              0xffff0000
+#define SW_DESC_OFST                     0xffff
+
+#define P_EVNT_GEN_TRSHLD_P_TRSHLD                  0xffff
+
+/* P_FIFO_sizesn */
+#define P_DATA_FIFO_SIZE           0xffff0000
+#define P_DESC_FIFO_SIZE               0xffff
+
+#define P_RETR_CNTXT_RETR_DESC_OFST            0xffff0000
+#define P_RETR_CNTXT_RETR_OFST_IN_DESC             0xffff
+#define P_SI_CNTXT_SI_DESC_OFST                    0xffff
+#define P_AU_PSM_CNTXT_1_AU_PSM_ACCUMED        0xffff0000
+#define P_AU_PSM_CNTXT_1_AU_ACKED                  0xffff
+#define P_PSM_CNTXT_2_PSM_DESC_VALID           0x80000000
+#define P_PSM_CNTXT_2_PSM_DESC_IRQ             0x40000000
+#define P_PSM_CNTXT_2_PSM_DESC_IRQ_DONE        0x20000000
+#define P_PSM_CNTXT_2_PSM_GENERAL_BITS         0x1e000000
+#define P_PSM_CNTXT_2_PSM_CONS_STATE            0x1c00000
+#define P_PSM_CNTXT_2_PSM_PROD_SYS_STATE         0x380000
+#define P_PSM_CNTXT_2_PSM_PROD_B2B_STATE          0x70000
+#define P_PSM_CNTXT_2_PSM_DESC_SIZE                0xffff
+#define P_PSM_CNTXT_4_PSM_DESC_OFST            0xffff0000
+#define P_PSM_CNTXT_4_PSM_SAVED_ACCUMED_SIZE       0xffff
+#define P_PSM_CNTXT_5_PSM_BLOCK_BYTE_CNT       0xffff0000
+#define P_PSM_CNTXT_5_PSM_OFST_IN_DESC             0xffff
+
+#define BAM_ERROR   (-1)
+
+/**
+ *
+ * Read register with debug info.
+ *
+ * @base - bam base virtual address.
+ * @offset - register offset.
+ *
+ * @return u32
+ */
+static inline u32 bam_read_reg(void *base, u32 offset)
+{
+	u32 val = ioread32(base + offset);
+	pr_debug("bam: read reg 0x%x r_val 0x%x.\n", offset, val);
+	return val;
+}
+
+/**
+ * Read register masked field with debug info.
+ *
+ * @base - bam base virtual address.
+ * @offset - register offset.
+ * @mask - register bitmask.
+ *
+ * @return u32
+ */
+static inline u32 bam_read_reg_field(void *base, u32 offset, const u32 mask)
+{
+	u32 shift = find_first_bit((void *)&mask, 32);
+	u32 val = ioread32(base + offset);
+	val &= mask;		/* clear other bits */
+	val >>= shift;
+	pr_debug("bam: read reg 0x%x mask 0x%x r_val 0x%x.\n",
+		offset, mask, val);
+	return val;
+}
+
+/**
+ *
+ * Write register with debug info.
+ *
+ * @base - bam base virtual address.
+ * @offset - register offset.
+ * @val - value to write.
+ *
+ */
+static inline void bam_write_reg(void *base, u32 offset, u32 val)
+{
+	iowrite32(val, base + offset);
+	pr_debug("bam: write reg 0x%x w_val 0x%x.\n", offset, val);
+}
+
+/**
+ * Write register masked field with debug info.
+ *
+ * @base - bam base virtual address.
+ * @offset - register offset.
+ * @mask - register bitmask.
+ * @val - value to write.
+ *
+ */
+static inline void bam_write_reg_field(void *base, u32 offset,
+				       const u32 mask, u32 val)
+{
+	u32 shift = find_first_bit((void *)&mask, 32);
+	u32 tmp = ioread32(base + offset);
+
+	tmp &= ~mask;		/* clear written bits */
+	val = tmp | (val << shift);
+	iowrite32(val, base + offset);
+	pr_debug("bam: write reg 0x%x w_val 0x%x.\n", offset, val);
+}
+
+/**
+ * Initialize a BAM device
+ *
+ */
+int bam_init(void *base, u32 ee,
+		u16 summing_threshold,
+		u32 irq_mask, u32 *version, u32 *num_pipes)
+{
+	/* disable bit#11 because of HW bug */
+	u32 cfg_bits = 0xffffffff & ~(1 << 11);
+	u32 ver = 0;
+
+	ver = bam_read_reg(base, REVISION);
+
+	if ((ver < BAM_MIN_VERSION) || (ver > BAM_MAX_VERSION)) {
+		pr_err("bam:Invalid BAM version 0x%x.\n", ver);
+		return -ENODEV;
+	}
+
+	if (summing_threshold == 0) {
+		summing_threshold = 4;
+		pr_err("bam:summing_threshold is zero , use default 4.\n");
+	}
+
+	bam_write_reg_field(base, CTRL, BAM_SW_RST, 1);
+	/* No delay needed */
+	bam_write_reg_field(base, CTRL, BAM_SW_RST, 0);
+
+	bam_write_reg_field(base, CTRL, BAM_EN, 1);
+
+	bam_write_reg(base, DESC_CNT_TRSHLD, summing_threshold);
+
+	bam_write_reg(base, CNFG_BITS, cfg_bits);
+
+	/*
+	 *  Enable Global BAM Interrupt - for error reasons ,
+	 *  filter with mask.
+	 *  Note: Pipes interrupts are disabled until BAM_P_IRQ_enn is set
+	 */
+	bam_write_reg_field(base, IRQ_SRCS_MSK, BAM_IRQ, 1);
+
+	bam_write_reg(base, IRQ_EN, irq_mask);
+
+	*num_pipes = bam_read_reg(base, NUM_PIPES);
+	*version = ver;
+
+	return 0;
+}
+
+/**
+ * Verify that a BAM device is enabled and gathers the hardware
+ * configuration.
+ *
+ */
+int bam_check(void *base, u32 *version, u32 *num_pipes)
+{
+	u32 ver = 0;
+
+	if (!bam_read_reg_field(base, CTRL, BAM_EN))
+		return -ENODEV;
+
+	ver = bam_read_reg(base, REVISION);
+
+	/*
+	 *  Discover the hardware version number and the number of pipes
+	 *  supported by this BAM
+	 */
+	*num_pipes = bam_read_reg(base, NUM_PIPES);
+	*version = ver;
+
+	/* Check BAM version */
+	if ((ver < BAM_MIN_VERSION) || (ver > BAM_MAX_VERSION)) {
+		pr_err("bam:Invalid BAM version 0x%x.\n", ver);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/**
+ * Disable a BAM device
+ *
+ */
+void bam_exit(void *base, u32 ee)
+{
+	bam_write_reg_field(base, IRQ_SRCS_MSK, BAM_IRQ, 0);
+
+	bam_write_reg(base, IRQ_EN, 0);
+
+	/* Disable the BAM */
+	bam_write_reg_field(base, CTRL, BAM_EN, 0);
+}
+
+/**
+ * Get and Clear BAM global IRQ status
+ *
+ * note: clear status only for pipes controlled by this
+ * processor
+ */
+u32 bam_get_and_clear_irq_status(void *base, u32 ee, u32 mask)
+{
+	u32 status = bam_read_reg(base, IRQ_SRCS);
+	u32 clr = status &= mask;
+
+	bam_write_reg(base, IRQ_CLR, clr);
+
+	return status;
+}
+
+/**
+ * Initialize a BAM pipe
+ */
+int bam_pipe_init(void *base, u32 pipe,	struct bam_pipe_parameters *param)
+{
+	/* Reset the BAM pipe */
+	bam_write_reg(base, P_RST(pipe), 1);
+	/* No delay needed */
+	bam_write_reg(base, P_RST(pipe), 0);
+
+	/* Enable the Pipe Interrupt at the BAM level */
+	bam_write_reg_field(base, IRQ_SRCS_MSK, (1 << pipe), 1);
+
+	bam_write_reg(base, P_IRQ_EN(pipe), param->pipe_irq_mask);
+
+	bam_write_reg_field(base, P_CTRL(pipe), P_DIRECTION, param->dir);
+	bam_write_reg_field(base, P_CTRL(pipe), P_SYS_MODE, param->mode);
+
+	bam_write_reg(base, P_EVNT_GEN_TRSHLD(pipe), param->event_threshold);
+
+	bam_write_reg(base, P_DESC_FIFO_ADDR(pipe), param->desc_base);
+	bam_write_reg_field(base, P_FIFO_SIZES(pipe), P_DESC_FIFO_SIZE,
+			    param->desc_size);
+
+	bam_write_reg_field(base, P_CTRL(pipe), P_SYS_STRM,
+			    param->stream_mode);
+
+	if (param->mode == BAM_PIPE_MODE_BAM2BAM) {
+		u32 peer_dest_addr = param->peer_phys_addr +
+				      P_EVNT_REG(param->peer_pipe);
+
+		bam_write_reg(base, P_DATA_FIFO_ADDR(pipe),
+			      param->data_base);
+		bam_write_reg_field(base, P_FIFO_SIZES(pipe),
+				    P_DATA_FIFO_SIZE, param->data_size);
+
+		bam_write_reg(base, P_EVNT_DEST_ADDR(pipe), peer_dest_addr);
+
+		pr_debug("bam:Bam=0x%x.Pipe=%d.peer_bam=0x%x.peer_pipe=%d.\n",
+			(u32) base, pipe,
+			(u32) param->peer_phys_addr,
+			param->peer_pipe);
+	}
+
+	/* Pipe Enable - at last */
+	bam_write_reg_field(base, P_CTRL(pipe), P_EN, 1);
+
+	return 0;
+}
+
+/**
+ * Reset the BAM pipe
+ *
+ */
+void bam_pipe_exit(void *base, u32 pipe, u32 ee)
+{
+	bam_write_reg(base, P_IRQ_EN(pipe), 0);
+
+	/* Disable the Pipe Interrupt at the BAM level */
+	bam_write_reg_field(base, IRQ_SRCS_MSK, (1 << pipe), 0);
+
+	/* Pipe Disable */
+	bam_write_reg_field(base, P_CTRL(pipe), P_EN, 0);
+}
+
+/**
+ * Enable a BAM pipe
+ *
+ */
+void bam_pipe_enable(void *base, u32 pipe)
+{
+	bam_write_reg_field(base, P_CTRL(pipe), P_EN, 1);
+}
+
+/**
+ * Diasble a BAM pipe
+ *
+ */
+void bam_pipe_disable(void *base, u32 pipe)
+{
+	bam_write_reg_field(base, P_CTRL(pipe), P_EN, 0);
+}
+
+/**
+ * Check if a BAM pipe is enabled.
+ *
+ */
+int bam_pipe_is_enabled(void *base, u32 pipe)
+{
+	return bam_read_reg_field(base, P_CTRL(pipe), P_EN);
+}
+
+/**
+ * Configure interrupt for a BAM pipe
+ *
+ */
+void bam_pipe_set_irq(void *base, u32 pipe, enum bam_enable irq_en,
+		      u32 src_mask, u32 ee)
+{
+	bam_write_reg(base, P_IRQ_EN(pipe), src_mask);
+	bam_write_reg_field(base, IRQ_SRCS_MSK, (1 << pipe), irq_en);
+}
+
+/**
+ * Configure a BAM pipe for satellite MTI use
+ *
+ */
+void bam_pipe_satellite_mti(void *base, u32 pipe, u32 irq_gen_addr, u32 ee)
+{
+	bam_write_reg(base, P_IRQ_EN(pipe), 0);
+	bam_write_reg(base, P_IRQ_DEST_ADDR(pipe), irq_gen_addr);
+
+	bam_write_reg_field(base, IRQ_SIC_SEL, (1 << pipe), 1);
+	bam_write_reg_field(base, IRQ_SRCS_MSK, (1 << pipe), 1);
+}
+
+/**
+ * Configure MTI for a BAM pipe
+ *
+ */
+void bam_pipe_set_mti(void *base, u32 pipe, enum bam_enable irq_en,
+		      u32 src_mask, u32 irq_gen_addr)
+{
+	/*
+	 * MTI use is only supported on BAMs when global config is controlled
+	 * by a remote processor.
+	 * Consequently, the global configuration register to enable SIC (MTI)
+	 * support cannot be accessed.
+	 * The remote processor must be relied upon to enable the SIC and the
+	 * interrupt. Since the remote processor enable both SIC and interrupt,
+	 * the interrupt enable mask must be set to zero for polling mode.
+	 */
+
+	bam_write_reg(base, P_IRQ_DEST_ADDR(pipe), irq_gen_addr);
+
+	if (!irq_en)
+		src_mask = 0;
+
+	bam_write_reg(base, P_IRQ_EN(pipe), src_mask);
+}
+
+/**
+ * Get and Clear BAM pipe IRQ status
+ *
+ */
+u32 bam_pipe_get_and_clear_irq_status(void *base, u32 pipe)
+{
+	u32 status = 0;
+
+	status = bam_read_reg(base, P_IRQ_STTS(pipe));
+	bam_write_reg(base, P_IRQ_CLR(pipe), status);
+
+	return status;
+}
+
+/**
+ * Set write offset for a BAM pipe
+ *
+ */
+void bam_pipe_set_desc_write_offset(void *base, u32 pipe, u32 next_write)
+{
+	/*
+	 * It is not necessary to perform a read-modify-write masking to write
+	 * the P_DESC_FIFO_PEER_OFST value, since the other field in the
+	 * register (P_BYTES_CONSUMED) is read-only.
+	 */
+	bam_write_reg_field(base, P_EVNT_REG(pipe), P_DESC_FIFO_PEER_OFST,
+			    next_write);
+}
+
+/**
+ * Get write offset for a BAM pipe
+ *
+ */
+u32 bam_pipe_get_desc_write_offset(void *base, u32 pipe)
+{
+	return bam_read_reg_field(base, P_EVNT_REG(pipe),
+				  P_DESC_FIFO_PEER_OFST);
+}
+
+/**
+ * Get read offset for a BAM pipe
+ *
+ */
+u32 bam_pipe_get_desc_read_offset(void *base, u32 pipe)
+{
+	return bam_read_reg_field(base, P_SW_OFSTS(pipe), SW_DESC_OFST);
+}
+
+/**
+ * Configure inactivity timer count for a BAM pipe
+ *
+ */
+void bam_pipe_timer_config(void *base, u32 pipe, enum bam_pipe_timer_mode mode,
+			 u32 timeout_count)
+{
+	bam_write_reg_field(base, P_TIMER_CTRL(pipe), P_TIMER_MODE, mode);
+	bam_write_reg_field(base, P_TIMER_CTRL(pipe), P_TIMER_TRSHLD,
+			    timeout_count);
+}
+
+/**
+ * Reset inactivity timer for a BAM pipe
+ *
+ */
+void bam_pipe_timer_reset(void *base, u32 pipe)
+{
+	/* reset */
+	bam_write_reg_field(base, P_TIMER_CTRL(pipe), P_TIMER_RST, 0);
+	/* active */
+	bam_write_reg_field(base, P_TIMER_CTRL(pipe), P_TIMER_RST, 1);
+}
+
+/**
+ * Get inactivity timer count for a BAM pipe
+ *
+ */
+u32 bam_pipe_timer_get_count(void *base, u32 pipe)
+{
+	return bam_read_reg(base, P_TIMER(pipe));
+}
diff --git a/arch/arm/mach-msm/sps/bam.h b/arch/arm/mach-msm/sps/bam.h
new file mode 100644
index 0000000..5681f96
--- /dev/null
+++ b/arch/arm/mach-msm/sps/bam.h
@@ -0,0 +1,375 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* Bus-Access-Manager (BAM) Hardware manager functions API. */
+
+#ifndef _BAM_H_
+#define _BAM_H_
+
+#include <linux/types.h>	/* u32 */
+#include <linux/io.h>		/* ioread32() */
+#include <linux/bitops.h>	/* find_first_bit() */
+
+/* Pipe mode */
+enum bam_pipe_mode {
+	BAM_PIPE_MODE_BAM2BAM = 0,	/* BAM to BAM */
+	BAM_PIPE_MODE_SYSTEM = 1,	/* BAM to/from System Memory */
+};
+
+/* Pipe direction */
+enum bam_pipe_dir {
+	/* The Pipe Reads data from data-fifo or system-memory */
+	BAM_PIPE_CONSUMER = 0,
+	/* The Pipe Writes data to data-fifo or system-memory */
+	BAM_PIPE_PRODUCER = 1,
+};
+
+/* Stream mode Type */
+enum bam_stream_mode {
+	BAM_STREAM_MODE_DISABLE = 0,
+	BAM_STREAM_MODE_ENABLE = 1,
+};
+
+/* Enable Type */
+enum bam_enable {
+	BAM_DISABLE = 0,
+	BAM_ENABLE = 1,
+};
+
+/* Pipe timer mode */
+enum bam_pipe_timer_mode {
+	BAM_PIPE_TIMER_ONESHOT = 0,
+	BAM_PIPE_TIMER_PERIODIC = 1,
+};
+
+struct transfer_descriptor {
+	u32 addr;	/* Buffer physical address */
+	u32 size:16;	/* Buffer size in bytes */
+	u32 flags:16;	/* Flag bitmask (see SPS_IOVEC_FLAG_ #defines) */
+}  __packed;
+
+/* BAM pipe initialization parameters */
+struct bam_pipe_parameters {
+	u16 event_threshold;
+	u32 pipe_irq_mask;
+	enum bam_pipe_dir dir;
+	enum bam_pipe_mode mode;
+	u32 desc_base;	/* Physical address of descriptor FIFO */
+	u32 desc_size;	/* Size (bytes) of descriptor FIFO */
+	enum bam_stream_mode stream_mode;
+	u32 ee;		/* BAM execution environment index */
+
+	/* The following are only valid if mode is BAM2BAM */
+	u32 peer_phys_addr;
+	u32 peer_pipe;
+	u32 data_base;	/* Physical address of data FIFO */
+	u32 data_size;	/* Size (bytes) of data FIFO */
+};
+
+/**
+ * Initialize a BAM device
+ *
+ * This function initializes a BAM device.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @ee - BAM execution environment index
+ *
+ * @summing_threshold - summing threshold (global for all pipes)
+ *
+ * @irq_mask - error interrupts mask
+ *
+ * @version - return BAM hardware version
+ *
+ * @num_pipes - return number of pipes
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int bam_init(void *base,
+		u32 ee,
+		u16 summing_threshold,
+		u32 irq_mask, u32 *version, u32 *num_pipes);
+
+/**
+ * Check a BAM device
+ *
+ * This function verifies that a BAM device is enabled and gathers
+ *    the hardware configuration.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @version - return BAM hardware version
+ *
+ * @num_pipes - return number of pipes
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int bam_check(void *base, u32 *version, u32 *num_pipes);
+
+/**
+ * Disable a BAM device
+ *
+ * This function disables a BAM device.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @ee - BAM execution environment index
+ *
+ */
+void bam_exit(void *base, u32 ee);
+
+/**
+ * Get and Clear BAM global IRQ status
+ *
+ * This function gets and clears BAM global IRQ status.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @ee - BAM execution environment index
+ *
+ * @mask - active pipes mask.
+ *
+ * @return IRQ status
+ *
+ */
+u32 bam_get_and_clear_irq_status(void *base, u32 ee, u32 mask);
+
+/**
+ * Initialize a BAM pipe
+ *
+ * This function initializes a BAM pipe.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ * @param - bam pipe parameters.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int bam_pipe_init(void *base, u32 pipe, struct bam_pipe_parameters *param);
+
+/**
+ * Reset the BAM pipe
+ *
+ * This function resets the BAM pipe.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ * @ee - BAM execution environment index
+ *
+ */
+void bam_pipe_exit(void *base, u32 pipe, u32 ee);
+
+/**
+ * Enable a BAM pipe
+ *
+ * This function enables a BAM pipe.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ */
+void bam_pipe_enable(void *base, u32 pipe);
+
+/**
+ * Disable a BAM pipe
+ *
+ * This function disables a BAM pipe.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ */
+void bam_pipe_disable(void *base, u32 pipe);
+
+/**
+ * Get a BAM pipe enable state
+ *
+ * This function determines if a BAM pipe is enabled.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ * @return true if enabled, false if disabled
+ *
+ */
+int bam_pipe_is_enabled(void *base, u32 pipe);
+
+/**
+ * Configure interrupt for a BAM pipe
+ *
+ * This function configures the interrupt for a BAM pipe.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ * @irq_en - enable or disable interrupt
+ *
+ * @src_mask - interrupt source mask, set regardless of whether
+ *    interrupt is disabled
+ *
+ * @ee - BAM execution environment index
+ *
+ */
+void bam_pipe_set_irq(void *base, u32 pipe, enum bam_enable irq_en,
+		      u32 src_mask, u32 ee);
+
+/**
+ * Configure a BAM pipe for satellite MTI use
+ *
+ * This function configures a BAM pipe for satellite MTI use.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ * @irq_gen_addr - physical address written to generate MTI
+ *
+ * @ee - BAM execution environment index
+ *
+ */
+void bam_pipe_satellite_mti(void *base, u32 pipe, u32 irq_gen_addr, u32 ee);
+
+/**
+ * Configure MTI for a BAM pipe
+ *
+ * This function configures the interrupt for a BAM pipe.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ * @irq_en - enable or disable interrupt
+ *
+ * @src_mask - interrupt source mask, set regardless of whether
+ *    interrupt is disabled
+ *
+ * @irq_gen_addr - physical address written to generate MTI
+ *
+ */
+void bam_pipe_set_mti(void *base, u32 pipe, enum bam_enable irq_en,
+		      u32 src_mask, u32 irq_gen_addr);
+
+/**
+ * Get and Clear BAM pipe IRQ status
+ *
+ * This function gets and clears BAM pipe IRQ status.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ * @return IRQ status
+ *
+ */
+u32 bam_pipe_get_and_clear_irq_status(void *base, u32 pipe);
+
+/**
+ * Set write offset for a BAM pipe
+ *
+ * This function sets the write offset for a BAM pipe.  This is
+ *    the offset that is maintained by software in system mode.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ * @next_write - descriptor FIFO write offset
+ *
+ */
+void bam_pipe_set_desc_write_offset(void *base, u32 pipe, u32 next_write);
+
+/**
+ * Get write offset for a BAM pipe
+ *
+ * This function gets the write offset for a BAM pipe.  This is
+ *    the offset that is maintained by the pipe's peer pipe or by software.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ * @return descriptor FIFO write offset
+ *
+ */
+u32 bam_pipe_get_desc_write_offset(void *base, u32 pipe);
+
+/**
+ * Get read offset for a BAM pipe
+ *
+ * This function gets the read offset for a BAM pipe.  This is
+ *    the offset that is maintained by the pipe in system mode.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ * @return descriptor FIFO read offset
+ *
+ */
+u32 bam_pipe_get_desc_read_offset(void *base, u32 pipe);
+
+/**
+ * Configure inactivity timer count for a BAM pipe
+ *
+ * This function configures the inactivity timer count for a BAM pipe.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ * @mode - timer operating mode
+ *
+ * @timeout_count - timeout count
+ *
+ */
+void bam_pipe_timer_config(void *base, u32 pipe,
+			   enum bam_pipe_timer_mode mode,
+			   u32 timeout_count);
+
+/**
+ * Reset inactivity timer for a BAM pipe
+ *
+ * This function resets the inactivity timer count for a BAM pipe.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ */
+void bam_pipe_timer_reset(void *base, u32 pipe);
+
+/**
+ * Get inactivity timer count for a BAM pipe
+ *
+ * This function gets the inactivity timer count for a BAM pipe.
+ *
+ * @base - BAM virtual base address.
+ *
+ * @pipe - pipe index
+ *
+ * @return inactivity timer count
+ *
+ */
+u32 bam_pipe_timer_get_count(void *base, u32 pipe);
+
+#endif				/* _BAM_H_ */
diff --git a/arch/arm/mach-msm/sps/sps.c b/arch/arm/mach-msm/sps/sps.c
new file mode 100644
index 0000000..f288958
--- /dev/null
+++ b/arch/arm/mach-msm/sps/sps.c
@@ -0,0 +1,1359 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* Smart-Peripheral-Switch (SPS) Module. */
+
+#include <linux/types.h>	/* u32 */
+#include <linux/kernel.h>	/* pr_info() */
+#include <linux/module.h>	/* module_init() */
+#include <linux/slab.h>		/* kzalloc() */
+#include <linux/mutex.h>	/* mutex */
+#include <linux/device.h>	/* device */
+#include <linux/fs.h>		/* alloc_chrdev_region() */
+#include <linux/list.h>		/* list_head */
+#include <linux/memory.h>	/* memset */
+#include <linux/io.h>		/* ioremap() */
+#include <linux/clk.h>		/* clk_enable() */
+#include <linux/platform_device.h>	/* platform_get_resource_byname() */
+
+#include <mach/msm_sps.h>	/* msm_sps_platform_data */
+
+#include "sps_bam.h"
+#include "spsi.h"
+#include "sps_core.h"
+
+#define DRV_NAME "sps"
+
+/**
+ *  SPS Driver state struct
+ */
+struct sps_drv {
+	struct class *dev_class;
+	dev_t dev_num;
+	struct device *dev;
+	struct clk *pmem_clk;
+	struct clk *bamdma_clk;
+	struct clk *dfab_clk;
+
+	int is_ready;
+
+	/* Platform data */
+	u32 pipemem_phys_base;
+	u32 pipemem_size;
+	u32 bamdma_bam_phys_base;
+	u32 bamdma_bam_size;
+	u32 bamdma_dma_phys_base;
+	u32 bamdma_dma_size;
+	u32 bamdma_irq;
+	u32 bamdma_restricted_pipes;
+
+	/* Driver options bitflags (see SPS_OPT_*) */
+	u32 options;
+
+	/* Mutex to protect BAM and connection queues */
+	struct mutex lock;
+
+	/* BAM devices */
+	struct list_head bams_q;
+
+	char *hal_bam_version;
+
+	/* Connection control state */
+	struct sps_rm connection_ctrl;
+};
+
+
+/**
+ *  SPS driver state
+ */
+static struct sps_drv *sps;
+
+static void sps_device_de_init(void);
+
+/**
+ * Initialize SPS device
+ *
+ * This function initializes the SPS device.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+static int sps_device_init(void)
+{
+	int result;
+	int success;
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+	struct sps_bam_props bamdma_props = {0};
+#endif
+
+	SPS_DBG("sps_device_init");
+
+	success = false;
+
+	result = sps_mem_init(sps->pipemem_phys_base, sps->pipemem_size);
+	if (result) {
+		SPS_ERR("SPS memory init failed");
+		goto exit_err;
+	}
+
+	INIT_LIST_HEAD(&sps->bams_q);
+	mutex_init(&sps->lock);
+
+	if (sps_rm_init(&sps->connection_ctrl, sps->options)) {
+		SPS_ERR("Failed to init SPS resource manager");
+		goto exit_err;
+	}
+
+	result = sps_bam_driver_init(sps->options);
+	if (result) {
+		SPS_ERR("SPS BAM driver init failed");
+		goto exit_err;
+	}
+
+	/* Initialize the BAM DMA device */
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+	bamdma_props.phys_addr = sps->bamdma_bam_phys_base;
+	bamdma_props.virt_addr = ioremap(sps->bamdma_bam_phys_base,
+					 sps->bamdma_bam_size);
+
+	if (!bamdma_props.virt_addr) {
+		SPS_ERR("sps:Failed to IO map BAM-DMA BAM registers.\n");
+		goto exit_err;
+	}
+
+	SPS_DBG("sps:bamdma_bam.phys=0x%x.virt=0x%x.",
+		bamdma_props.phys_addr,
+		(u32) bamdma_props.virt_addr);
+
+	bamdma_props.periph_phys_addr =	sps->bamdma_dma_phys_base;
+	bamdma_props.periph_virt_size = sps->bamdma_dma_size;
+	bamdma_props.periph_virt_addr = ioremap(sps->bamdma_dma_phys_base,
+						sps->bamdma_dma_size);
+
+	if (!bamdma_props.periph_virt_addr) {
+		SPS_ERR("sps:Failed to IO map BAM-DMA peripheral reg.\n");
+		goto exit_err;
+	}
+
+	SPS_DBG("sps:bamdma_dma.phys=0x%x.virt=0x%x.",
+		bamdma_props.periph_phys_addr,
+		(u32) bamdma_props.periph_virt_addr);
+
+	bamdma_props.irq = sps->bamdma_irq;
+
+	bamdma_props.event_threshold = 0x10;	/* Pipe event threshold */
+	bamdma_props.summing_threshold = 0x10;	/* BAM event threshold */
+
+	bamdma_props.options = SPS_BAM_OPT_BAMDMA;
+	bamdma_props.restricted_pipes =	sps->bamdma_restricted_pipes;
+
+	result = sps_dma_init(&bamdma_props);
+	if (result) {
+		SPS_ERR("SPS BAM DMA driver init failed");
+		goto exit_err;
+	}
+#endif /* CONFIG_SPS_SUPPORT_BAMDMA */
+
+	result = sps_map_init(NULL, sps->options);
+	if (result) {
+		SPS_ERR("SPS connection mapping init failed");
+		goto exit_err;
+	}
+
+	success = true;
+exit_err:
+	if (!success) {
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+		sps_device_de_init();
+#endif
+		return SPS_ERROR;
+	}
+
+	return 0;
+}
+
+/**
+ * De-initialize SPS device
+ *
+ * This function de-initializes the SPS device.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+static void sps_device_de_init(void)
+{
+	SPS_DBG("%s.", __func__);
+
+	if (sps != NULL) {
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+		sps_dma_de_init();
+#endif
+		/* Are there any remaining BAM registrations? */
+		if (!list_empty(&sps->bams_q))
+			SPS_ERR("SPS de-init: BAMs are still registered");
+
+		sps_map_de_init();
+
+		kfree(sps);
+	}
+
+	sps_mem_de_init();
+}
+
+/**
+ * Initialize client state context
+ *
+ * This function initializes a client state context struct.
+ *
+ * @client - Pointer to client state context
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+static int sps_client_init(struct sps_pipe *client)
+{
+	if (client == NULL)
+		return -EINVAL;
+
+	/*
+	 * NOTE: Cannot store any state within the SPS driver because
+	 * the driver init function may not have been called yet.
+	 */
+	memset(client, 0, sizeof(*client));
+	sps_rm_config_init(&client->connect);
+
+	client->client_state = SPS_STATE_DISCONNECT;
+	client->bam = NULL;
+
+	return 0;
+}
+
+/**
+ * De-initialize client state context
+ *
+ * This function de-initializes a client state context struct.
+ *
+ * @client - Pointer to client state context
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+static int sps_client_de_init(struct sps_pipe *client)
+{
+	if (client->client_state != SPS_STATE_DISCONNECT) {
+		SPS_ERR("De-init client in connected state: 0x%x",
+				   client->client_state);
+		return SPS_ERROR;
+	}
+
+	client->bam = NULL;
+	client->map = NULL;
+	memset(&client->connect, 0, sizeof(client->connect));
+
+	return 0;
+}
+
+/**
+ * Find the BAM device from the physical address
+ *
+ * This function finds a BAM device in the BAM registration list that
+ * matches the specified physical address.
+ *
+ * @phys_addr - physical address of the BAM
+ *
+ * @return - pointer to the BAM device struct, or NULL on error
+ *
+ */
+static struct sps_bam *phy2bam(u32 phys_addr)
+{
+	struct sps_bam *bam;
+
+	list_for_each_entry(bam, &sps->bams_q, list) {
+		if (bam->props.phys_addr == phys_addr)
+			return bam;
+	}
+
+	return NULL;
+}
+
+/**
+ * Find the BAM device from the handle
+ *
+ * This function finds a BAM device in the BAM registration list that
+ * matches the specified device handle.
+ *
+ * @h - device handle of the BAM
+ *
+ * @return - pointer to the BAM device struct, or NULL on error
+ *
+ */
+struct sps_bam *sps_h2bam(u32 h)
+{
+	struct sps_bam *bam;
+
+	if (h == SPS_DEV_HANDLE_MEM || h == SPS_DEV_HANDLE_INVALID)
+		return NULL;
+
+	list_for_each_entry(bam, &sps->bams_q, list) {
+		if ((u32) bam == (u32) h)
+			return bam;
+	}
+
+	SPS_ERR("Can't find BAM device for handle 0x%x.", h);
+
+	return NULL;
+}
+
+/**
+ * Lock BAM device
+ *
+ * This function obtains the BAM mutex on the client's connection.
+ *
+ * @pipe - pointer to client pipe state
+ *
+ * @return pointer to BAM device struct, or NULL on error
+ *
+ */
+static struct sps_bam *sps_bam_lock(struct sps_pipe *pipe)
+{
+	struct sps_bam *bam;
+	u32 pipe_index;
+
+	bam = pipe->bam;
+	if (bam == NULL) {
+		SPS_ERR("Connection not in connected state");
+		return NULL;
+	}
+
+	mutex_lock(&bam->lock);
+
+	/* Verify client owns this pipe */
+	pipe_index = pipe->pipe_index;
+	if (pipe_index >= bam->props.num_pipes ||
+	    pipe != bam->pipes[pipe_index]) {
+		SPS_ERR("Client not owner of BAM 0x%x pipe: %d (max %d)",
+			bam->props.phys_addr, pipe_index,
+			bam->props.num_pipes);
+		mutex_unlock(&bam->lock);
+		return NULL;
+	}
+
+	return bam;
+}
+
+/**
+ * Unlock BAM device
+ *
+ * This function releases the BAM mutex on the client's connection.
+ *
+ * @bam - pointer to BAM device struct
+ *
+ */
+static inline void sps_bam_unlock(struct sps_bam *bam)
+{
+	mutex_unlock(&bam->lock);
+}
+
+/**
+ * Connect an SPS connection end point
+ *
+ */
+int sps_connect(struct sps_pipe *h, struct sps_connect *connect)
+{
+	struct sps_pipe *pipe = h;
+	u32 dev;
+	struct sps_bam *bam;
+	int result;
+
+	if (sps == NULL)
+		return -ENODEV;
+
+	if (!sps->is_ready) {
+		SPS_ERR("sps_connect.sps driver not ready.\n");
+		return -EAGAIN;
+	}
+
+	SPS_DBG("sps_connect: src 0x%x dest 0x%x mode %s",
+		       connect->source,
+		       connect->destination,
+		       connect->mode == SPS_MODE_SRC ? "SRC" : "DEST");
+
+	mutex_lock(&sps->lock);
+	/*
+	 * Must lock the BAM device at the top level function, so must
+	 * determine which BAM is the target for the connection
+	 */
+	if (connect->mode == SPS_MODE_SRC)
+		dev = connect->source;
+	else
+		dev = connect->destination;
+
+	bam = sps_h2bam(dev);
+	if (bam == NULL) {
+		SPS_ERR("Invalid BAM device handle: 0x%x", dev);
+		result = SPS_ERROR;
+		goto exit_err;
+	}
+
+	/* Allocate resources for the specified connection */
+	pipe->connect = *connect;
+	mutex_lock(&bam->lock);
+	result = sps_rm_state_change(pipe, SPS_STATE_ALLOCATE);
+	mutex_unlock(&bam->lock);
+	if (result)
+		goto exit_err;
+
+	/* Configure the connection */
+	mutex_lock(&bam->lock);
+	result = sps_rm_state_change(pipe, SPS_STATE_CONNECT);
+	mutex_unlock(&bam->lock);
+	if (result) {
+		sps_disconnect(h);
+		goto exit_err;
+	}
+
+exit_err:
+	mutex_unlock(&sps->lock);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_connect);
+
+/**
+ * Disconnect an SPS connection end point
+ *
+ * This function disconnects an SPS connection end point.
+ * The SPS hardware associated with that end point will be disabled.
+ * For a connection involving system memory (SPS_DEV_HANDLE_MEM), all
+ * connection resources are deallocated.  For a peripheral-to-peripheral
+ * connection, the resources associated with the connection will not be
+ * deallocated until both end points are closed.
+ *
+ * The client must call sps_connect() for the handle before calling
+ * this function.
+ *
+ * @h - client context for SPS connection end point
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_disconnect(struct sps_pipe *h)
+{
+	struct sps_pipe *pipe = h;
+	struct sps_pipe *check;
+	struct sps_bam *bam;
+	int result;
+
+	if (pipe == NULL)
+		return SPS_ERROR;
+
+	SPS_DBG("sps_disconnect: src 0x%x dest 0x%x mode %s",
+		       pipe->connect.source,
+		       pipe->connect.destination,
+		       pipe->connect.mode == SPS_MODE_SRC ? "SRC" : "DEST");
+
+	bam = sps_bam_lock(pipe);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	result = SPS_ERROR;
+	/* Cross-check client with map table */
+	if (pipe->connect.mode == SPS_MODE_SRC)
+		check = pipe->map->client_src;
+	else
+		check = pipe->map->client_dest;
+
+	if (check != pipe) {
+		SPS_ERR("Client context is corrupt");
+		goto exit_err;
+	}
+
+	/* Disconnect the BAM pipe */
+	result = sps_rm_state_change(pipe, SPS_STATE_DISCONNECT);
+	if (result)
+		goto exit_err;
+
+	sps_rm_config_init(&pipe->connect);
+	result = 0;
+
+exit_err:
+	sps_bam_unlock(bam);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_disconnect);
+
+/**
+ * Register an event object for an SPS connection end point
+ *
+ */
+int sps_register_event(struct sps_pipe *h, struct sps_register_event *reg)
+{
+	struct sps_pipe *pipe = h;
+	struct sps_bam *bam;
+	int result;
+
+	SPS_DBG("%s.", __func__);
+
+	if (sps == NULL)
+		return -ENODEV;
+
+	if (!sps->is_ready) {
+		SPS_ERR("sps_connect.sps driver not ready.\n");
+		return -EAGAIN;
+	}
+
+	bam = sps_bam_lock(pipe);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	result = sps_bam_pipe_reg_event(bam, pipe->pipe_index, reg);
+	sps_bam_unlock(bam);
+	if (result)
+		SPS_ERR("Failed to register event for BAM 0x%x pipe %d",
+			pipe->bam->props.phys_addr, pipe->pipe_index);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_register_event);
+
+/**
+ * Enable an SPS connection end point
+ *
+ */
+int sps_flow_on(struct sps_pipe *h)
+{
+	struct sps_pipe *pipe = h;
+	struct sps_bam *bam;
+	int result;
+
+	SPS_DBG("%s.", __func__);
+
+	bam = sps_bam_lock(pipe);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	/* Enable the pipe data flow */
+	result = sps_rm_state_change(pipe, SPS_STATE_ENABLE);
+	sps_bam_unlock(bam);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_flow_on);
+
+/**
+ * Disable an SPS connection end point
+ *
+ */
+int sps_flow_off(struct sps_pipe *h, enum sps_flow_off mode)
+{
+	struct sps_pipe *pipe = h;
+	struct sps_bam *bam;
+	int result;
+
+	SPS_DBG("%s.", __func__);
+
+	bam = sps_bam_lock(pipe);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	/* Disable the pipe data flow */
+	result = sps_rm_state_change(pipe, SPS_STATE_DISABLE);
+	sps_bam_unlock(bam);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_flow_off);
+
+/**
+ * Perform a DMA transfer on an SPS connection end point
+ *
+ */
+int sps_transfer(struct sps_pipe *h, struct sps_transfer *transfer)
+{
+	struct sps_pipe *pipe = h;
+	struct sps_bam *bam;
+	int result;
+
+	SPS_DBG("%s.", __func__);
+
+	bam = sps_bam_lock(pipe);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	result = sps_bam_pipe_transfer(bam, pipe->pipe_index, transfer);
+	sps_bam_unlock(bam);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_transfer);
+
+/**
+ * Perform a single DMA transfer on an SPS connection end point
+ *
+ */
+int sps_transfer_one(struct sps_pipe *h, u32 addr, u32 size,
+		     void *user, u32 flags)
+{
+	struct sps_pipe *pipe = h;
+	struct sps_bam *bam;
+	int result;
+
+	SPS_DBG("%s.", __func__);
+
+	bam = sps_bam_lock(pipe);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	result = sps_bam_pipe_transfer_one(bam, pipe->pipe_index,
+					   addr, size, user, flags);
+	sps_bam_unlock(bam);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_transfer_one);
+
+/**
+ * Read event queue for an SPS connection end point
+ *
+ */
+int sps_get_event(struct sps_pipe *h, struct sps_event_notify *notify)
+{
+	struct sps_pipe *pipe = h;
+	struct sps_bam *bam;
+	int result;
+
+	SPS_DBG("%s.", __func__);
+
+	bam = sps_bam_lock(pipe);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	result = sps_bam_pipe_get_event(bam, pipe->pipe_index, notify);
+	sps_bam_unlock(bam);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_get_event);
+
+/**
+ * Determine whether an SPS connection end point FIFO is empty
+ *
+ */
+int sps_is_pipe_empty(struct sps_pipe *h, u32 *empty)
+{
+	struct sps_pipe *pipe = h;
+	struct sps_bam *bam;
+	int result;
+
+	SPS_DBG("%s.", __func__);
+
+	bam = sps_bam_lock(pipe);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	result = sps_bam_pipe_is_empty(bam, pipe->pipe_index, empty);
+	sps_bam_unlock(bam);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_is_pipe_empty);
+
+/**
+ * Get number of free transfer entries for an SPS connection end point
+ *
+ */
+int sps_get_free_count(struct sps_pipe *h, u32 *count)
+{
+	struct sps_pipe *pipe = h;
+	struct sps_bam *bam;
+	int result;
+
+	SPS_DBG("%s.", __func__);
+
+	bam = sps_bam_lock(pipe);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	result = sps_bam_get_free_count(bam, pipe->pipe_index, count);
+	sps_bam_unlock(bam);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_get_free_count);
+
+/**
+ * Reset an SPS BAM device
+ *
+ */
+int sps_device_reset(u32 dev)
+{
+	struct sps_bam *bam;
+	int result;
+
+	SPS_DBG("%s: dev = 0x%x", __func__, dev);
+
+	mutex_lock(&sps->lock);
+	/* Search for the target BAM device */
+	bam = sps_h2bam(dev);
+	if (bam == NULL) {
+		SPS_ERR("Invalid BAM device handle: 0x%x", dev);
+		result = SPS_ERROR;
+		goto exit_err;
+	}
+
+	mutex_lock(&bam->lock);
+	result = sps_bam_reset(bam);
+	mutex_unlock(&bam->lock);
+	if (result) {
+		SPS_ERR("Failed to reset BAM device: 0x%x", dev);
+		goto exit_err;
+	}
+
+exit_err:
+	mutex_unlock(&sps->lock);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_device_reset);
+
+/**
+ * Get the configuration parameters for an SPS connection end point
+ *
+ */
+int sps_get_config(struct sps_pipe *h, struct sps_connect *config)
+{
+	struct sps_pipe *pipe = h;
+
+	if (config == NULL) {
+		SPS_ERR("Config pointer is NULL");
+		return SPS_ERROR;
+	}
+
+	/* Copy current client connection state */
+	*config = pipe->connect;
+
+	return 0;
+}
+EXPORT_SYMBOL(sps_get_config);
+
+/**
+ * Set the configuration parameters for an SPS connection end point
+ *
+ */
+int sps_set_config(struct sps_pipe *h, struct sps_connect *config)
+{
+	struct sps_pipe *pipe = h;
+	struct sps_bam *bam;
+	int result;
+
+	SPS_DBG("%s.", __func__);
+
+	bam = sps_bam_lock(pipe);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	result = sps_bam_pipe_set_params(bam, pipe->pipe_index,
+					 config->options);
+	if (result == 0)
+		pipe->connect.options = config->options;
+	sps_bam_unlock(bam);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_set_config);
+
+/**
+ * Set ownership of an SPS connection end point
+ *
+ */
+int sps_set_owner(struct sps_pipe *h, enum sps_owner owner,
+		  struct sps_satellite *connect)
+{
+	struct sps_pipe *pipe = h;
+	struct sps_bam *bam;
+	int result;
+
+	if (owner != SPS_OWNER_REMOTE) {
+		SPS_ERR("Unsupported ownership state: %d", owner);
+		return SPS_ERROR;
+	}
+
+	bam = sps_bam_lock(pipe);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	result = sps_bam_set_satellite(bam, pipe->pipe_index);
+	if (result)
+		goto exit_err;
+
+	/* Return satellite connect info */
+	if (connect == NULL)
+		goto exit_err;
+
+	if (pipe->connect.mode == SPS_MODE_SRC) {
+		connect->dev = pipe->map->src.bam_phys;
+		connect->pipe_index = pipe->map->src.pipe_index;
+	} else {
+		connect->dev = pipe->map->dest.bam_phys;
+		connect->pipe_index = pipe->map->dest.pipe_index;
+	}
+	connect->config = SPS_CONFIG_SATELLITE;
+	connect->options = (enum sps_option) 0;
+
+exit_err:
+	sps_bam_unlock(bam);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_set_owner);
+
+/**
+ * Allocate memory from the SPS Pipe-Memory.
+ *
+ */
+int sps_alloc_mem(struct sps_pipe *h, enum sps_mem mem,
+		  struct sps_mem_buffer *mem_buffer)
+{
+	if (sps == NULL)
+		return -ENODEV;
+
+	if (!sps->is_ready) {
+		SPS_ERR("sps_alloc_mem.sps driver not ready.\n");
+		return -EAGAIN;
+	}
+
+	if (mem_buffer == NULL || mem_buffer->size == 0)
+		return SPS_ERROR;
+
+	mem_buffer->phys_base = sps_mem_alloc_io(mem_buffer->size);
+	if (mem_buffer->phys_base == SPS_ADDR_INVALID)
+		return SPS_ERROR;
+
+	mem_buffer->base = spsi_get_mem_ptr(mem_buffer->phys_base);
+
+	return 0;
+}
+EXPORT_SYMBOL(sps_alloc_mem);
+
+/**
+ * Free memory from the SPS Pipe-Memory.
+ *
+ */
+int sps_free_mem(struct sps_pipe *h, struct sps_mem_buffer *mem_buffer)
+{
+	if (mem_buffer == NULL || mem_buffer->phys_base == SPS_ADDR_INVALID)
+		return SPS_ERROR;
+
+	sps_mem_free_io(mem_buffer->phys_base, mem_buffer->size);
+
+	return 0;
+}
+EXPORT_SYMBOL(sps_free_mem);
+
+/**
+ * Register a BAM device
+ *
+ */
+int sps_register_bam_device(const struct sps_bam_props *bam_props,
+				u32 *dev_handle)
+{
+	struct sps_bam *bam = NULL;
+	void *virt_addr = NULL;
+	u32 manage;
+	int ok;
+	int result;
+
+	if (sps == NULL)
+		return SPS_ERROR;
+
+	/* BAM-DMA is registered internally during power-up */
+	if ((!sps->is_ready) && !(bam_props->options & SPS_BAM_OPT_BAMDMA)) {
+		SPS_ERR("sps_register_bam_device.sps driver not ready.\n");
+		return -EAGAIN;
+	}
+
+	if (bam_props == NULL || dev_handle == NULL)
+		return SPS_ERROR;
+
+	/* Check BAM parameters */
+	manage = bam_props->manage & SPS_BAM_MGR_ACCESS_MASK;
+	if (manage != SPS_BAM_MGR_NONE) {
+		if (bam_props->virt_addr == NULL && bam_props->virt_size == 0) {
+			SPS_ERR("Invalid properties for BAM: %x",
+					   bam_props->phys_addr);
+			return SPS_ERROR;
+		}
+	}
+	if ((bam_props->manage & SPS_BAM_MGR_DEVICE_REMOTE) == 0) {
+		/* BAM global is configured by local processor */
+		if (bam_props->summing_threshold == 0) {
+			SPS_ERR("Invalid device ctrl properties for BAM: %x",
+			 bam_props->phys_addr);
+			return SPS_ERROR;
+		}
+	}
+	manage = bam_props->manage &
+		  (SPS_BAM_MGR_PIPE_NO_CONFIG | SPS_BAM_MGR_PIPE_NO_CTRL);
+
+	/* In case of error */
+	*dev_handle = SPS_DEV_HANDLE_INVALID;
+	result = SPS_ERROR;
+
+	mutex_lock(&sps->lock);
+	/* Is this BAM already registered? */
+	bam = phy2bam(bam_props->phys_addr);
+	if (bam != NULL) {
+		mutex_unlock(&sps->lock);
+		SPS_ERR("BAM already registered: %x", bam->props.phys_addr);
+		result = -EEXIST;
+		bam = NULL;   /* Avoid error clean-up kfree(bam) */
+		goto exit_err;
+	}
+
+	/* Perform virtual mapping if required */
+	if ((bam_props->manage & SPS_BAM_MGR_ACCESS_MASK) !=
+	    SPS_BAM_MGR_NONE && bam_props->virt_addr == NULL) {
+		/* Map the memory region */
+		virt_addr = ioremap(bam_props->phys_addr, bam_props->virt_size);
+		if (virt_addr == NULL) {
+			SPS_ERR("Unable to map BAM IO memory: %x %x",
+				bam_props->phys_addr, bam_props->virt_size);
+			goto exit_err;
+		}
+	}
+
+	bam = kzalloc(sizeof(*bam), GFP_KERNEL);
+	if (bam == NULL) {
+		SPS_ERR("Unable to allocate BAM device state: size 0x%x",
+			sizeof(*bam));
+		goto exit_err;
+	}
+	memset(bam, 0, sizeof(*bam));
+
+	mutex_init(&bam->lock);
+	mutex_lock(&bam->lock);
+
+	/* Copy configuration to BAM device descriptor */
+	bam->props = *bam_props;
+	if (virt_addr != NULL)
+		bam->props.virt_addr = virt_addr;
+
+	if ((bam_props->manage & SPS_BAM_MGR_DEVICE_REMOTE) != 0 &&
+	    (bam_props->manage & SPS_BAM_MGR_MULTI_EE) != 0 &&
+	    bam_props->ee == 0) {
+		/*
+		 * BAM global is owned by a remote processor, so force EE index
+		 * to a non-zero value to insure EE zero globals are not
+		 * modified.
+		 */
+		SPS_INFO("Setting EE for BAM %x to non-zero",
+				  bam_props->phys_addr);
+		bam->props.ee = 1;
+	}
+
+	ok = sps_bam_device_init(bam);
+	mutex_unlock(&bam->lock);
+	if (ok) {
+		SPS_ERR("Failed to init BAM device: phys 0x%0x",
+			bam->props.phys_addr);
+		goto exit_err;
+	}
+
+	/* Add BAM to the list */
+	list_add_tail(&bam->list, &sps->bams_q);
+	*dev_handle = (u32) bam;
+
+	result = 0;
+exit_err:
+	mutex_unlock(&sps->lock);
+
+	if (result) {
+		if (virt_addr != NULL)
+			iounmap(bam->props.virt_addr);
+
+		if (bam != NULL)
+			kfree(bam);
+
+		return result;
+	}
+
+	/* If this BAM is attached to a BAM-DMA, init the BAM-DMA device */
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+	if ((bam->props.options & SPS_BAM_OPT_BAMDMA)) {
+		if (sps_dma_device_init((u32) bam)) {
+			bam->props.options &= ~SPS_BAM_OPT_BAMDMA;
+			sps_deregister_bam_device((u32) bam);
+			SPS_ERR("Failed to init BAM-DMA device: BAM phys 0x%0x",
+				bam->props.phys_addr);
+			return SPS_ERROR;
+		}
+	}
+#endif /* CONFIG_SPS_SUPPORT_BAMDMA */
+
+	SPS_DBG("SPS registered BAM: phys 0x%x.", bam->props.phys_addr);
+
+	return 0;
+}
+EXPORT_SYMBOL(sps_register_bam_device);
+
+/**
+ * Deregister a BAM device
+ *
+ */
+int sps_deregister_bam_device(u32 dev_handle)
+{
+	struct sps_bam *bam;
+
+	bam = sps_h2bam(dev_handle);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	SPS_DBG("SPS deregister BAM: phys 0x%x.", bam->props.phys_addr);
+
+	/* If this BAM is attached to a BAM-DMA, init the BAM-DMA device */
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+	if ((bam->props.options & SPS_BAM_OPT_BAMDMA)) {
+		mutex_lock(&bam->lock);
+		(void)sps_dma_device_de_init((u32) bam);
+		bam->props.options &= ~SPS_BAM_OPT_BAMDMA;
+		mutex_unlock(&bam->lock);
+	}
+#endif
+
+	/* Remove the BAM from the registration list */
+	mutex_lock(&sps->lock);
+	list_del(&bam->list);
+	mutex_unlock(&sps->lock);
+
+	/* De-init the BAM and free resources */
+	mutex_lock(&bam->lock);
+	sps_bam_device_de_init(bam);
+	mutex_unlock(&bam->lock);
+	if (bam->props.virt_size)
+		(void)iounmap(bam->props.virt_addr);
+
+	kfree(bam);
+
+	return 0;
+}
+EXPORT_SYMBOL(sps_deregister_bam_device);
+
+/**
+ * Get processed I/O vector (completed transfers)
+ *
+ */
+int sps_get_iovec(struct sps_pipe *h, struct sps_iovec *iovec)
+{
+	struct sps_pipe *pipe = h;
+	struct sps_bam *bam;
+	int result;
+
+	if (h == NULL || iovec == NULL)
+		return SPS_ERROR;
+
+	SPS_DBG("%s.", __func__);
+
+	bam = sps_bam_lock(pipe);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	/* Get an iovec from the BAM pipe descriptor FIFO */
+	result = sps_bam_pipe_get_iovec(bam, pipe->pipe_index, iovec);
+	sps_bam_unlock(bam);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_get_iovec);
+
+/**
+ * Perform timer control
+ *
+ */
+int sps_timer_ctrl(struct sps_pipe *h,
+			struct sps_timer_ctrl *timer_ctrl,
+			struct sps_timer_result *timer_result)
+{
+	struct sps_pipe *pipe = h;
+	struct sps_bam *bam;
+	int result;
+
+	SPS_DBG("%s.", __func__);
+
+	if (h == NULL || timer_ctrl == NULL)
+		return SPS_ERROR;
+
+	bam = sps_bam_lock(pipe);
+	if (bam == NULL)
+		return SPS_ERROR;
+
+	/* Perform the BAM pipe timer control operation */
+	result = sps_bam_pipe_timer_ctrl(bam, pipe->pipe_index, timer_ctrl,
+					 timer_result);
+	sps_bam_unlock(bam);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_timer_ctrl);
+
+/**
+ * Allocate client state context
+ *
+ */
+struct sps_pipe *sps_alloc_endpoint(void)
+{
+	struct sps_pipe *ctx = NULL;
+
+	ctx = kzalloc(sizeof(struct sps_pipe), GFP_KERNEL);
+	if (ctx == NULL) {
+		SPS_ERR("Allocate pipe context fail.");
+		return NULL;
+	}
+
+	sps_client_init(ctx);
+
+	return ctx;
+}
+EXPORT_SYMBOL(sps_alloc_endpoint);
+
+/**
+ * Free client state context
+ *
+ */
+int sps_free_endpoint(struct sps_pipe *ctx)
+{
+	int res;
+
+	res = sps_client_de_init(ctx);
+
+	if (res == 0)
+		kfree(ctx);
+
+	return res;
+}
+EXPORT_SYMBOL(sps_free_endpoint);
+
+/**
+ * Platform Driver.
+ */
+static int get_platform_data(struct platform_device *pdev)
+{
+	struct resource *resource;
+	struct msm_sps_platform_data *pdata;
+
+	pdata = pdev->dev.platform_data;
+
+	if (pdata == NULL) {
+		SPS_ERR("sps:inavlid platform data.\n");
+		sps->bamdma_restricted_pipes = 0;
+		return -EINVAL;
+	} else {
+		sps->bamdma_restricted_pipes = pdata->bamdma_restricted_pipes;
+		SPS_DBG("sps:bamdma_restricted_pipes=0x%x.",
+			sps->bamdma_restricted_pipes);
+	}
+
+	resource  = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						 "pipe_mem");
+	if (resource) {
+		sps->pipemem_phys_base = resource->start;
+		sps->pipemem_size = resource_size(resource);
+		SPS_DBG("sps:pipemem.base=0x%x,size=0x%x.",
+			sps->pipemem_phys_base,
+			sps->pipemem_size);
+	}
+
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+	resource  = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						 "bamdma_bam");
+	if (resource) {
+		sps->bamdma_bam_phys_base = resource->start;
+		sps->bamdma_bam_size = resource_size(resource);
+		SPS_DBG("sps:bamdma_bam.base=0x%x,size=0x%x.",
+			sps->bamdma_bam_phys_base,
+			sps->bamdma_bam_size);
+	}
+
+	resource  = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						 "bamdma_dma");
+	if (resource) {
+		sps->bamdma_dma_phys_base = resource->start;
+		sps->bamdma_dma_size = resource_size(resource);
+		SPS_DBG("sps:bamdma_dma.base=0x%x,size=0x%x.",
+			sps->bamdma_dma_phys_base,
+			sps->bamdma_dma_size);
+	}
+
+	resource  = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
+						 "bamdma_irq");
+	if (resource) {
+		sps->bamdma_irq = resource->start;
+		SPS_DBG("sps:bamdma_irq=%d.", sps->bamdma_irq);
+	}
+#endif
+
+	return 0;
+}
+
+static int __devinit msm_sps_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	SPS_DBG("sps:msm_sps_probe.");
+
+	ret = get_platform_data(pdev);
+	if (ret)
+		return -ENODEV;
+
+	/* Create Device */
+	sps->dev_class = class_create(THIS_MODULE, DRV_NAME);
+
+	ret = alloc_chrdev_region(&sps->dev_num, 0, 1, DRV_NAME);
+	if (ret) {
+		SPS_ERR("sps:alloc_chrdev_region err.");
+		goto alloc_chrdev_region_err;
+	}
+
+	sps->dev = device_create(sps->dev_class, NULL, sps->dev_num,	sps,
+				  DRV_NAME);
+	if (IS_ERR(sps->dev)) {
+		SPS_ERR("sps:device_create err.");
+		goto device_create_err;
+	}
+
+	sps->dfab_clk = clk_get(sps->dev, "dfab_clk");
+	if (IS_ERR(sps->dfab_clk)) {
+		SPS_ERR("sps:fail to get dfab_clk.");
+		goto clk_err;
+	} else {
+		ret = clk_enable(sps->dfab_clk);
+		if (ret) {
+			SPS_ERR("sps:failed to enable dfab_clk. ret=%d", ret);
+			goto clk_err;
+		}
+	}
+
+	sps->pmem_clk = clk_get(sps->dev, "pmem_clk");
+	if (IS_ERR(sps->pmem_clk)) {
+		SPS_ERR("sps:fail to get pmem_clk.");
+		goto clk_err;
+	} else {
+		ret = clk_enable(sps->pmem_clk);
+		if (ret) {
+			SPS_ERR("sps:failed to enable pmem_clk. ret=%d", ret);
+			goto clk_err;
+		}
+	}
+
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+	sps->bamdma_clk = clk_get(sps->dev, "dma_bam_pclk");
+	if (IS_ERR(sps->bamdma_clk)) {
+		SPS_ERR("sps:fail to get bamdma_clk.");
+		goto clk_err;
+	} else {
+		ret = clk_enable(sps->bamdma_clk);
+		if (ret) {
+			SPS_ERR("sps:failed to enable bamdma_clk. ret=%d", ret);
+			goto clk_err;
+		}
+	}
+#endif
+
+	ret = sps_device_init();
+	if (ret) {
+		SPS_ERR("sps:sps_device_init err.");
+		goto sps_device_init_err;
+	}
+
+	sps->is_ready = true;
+
+	SPS_INFO("sps is ready.");
+
+	return 0;
+clk_err:
+sps_device_init_err:
+	device_destroy(sps->dev_class, sps->dev_num);
+device_create_err:
+	unregister_chrdev_region(sps->dev_num, 1);
+alloc_chrdev_region_err:
+	class_destroy(sps->dev_class);
+
+	return -ENODEV;
+}
+
+static int __devexit msm_sps_remove(struct platform_device *pdev)
+{
+	SPS_DBG("%s.", __func__);
+
+	device_destroy(sps->dev_class, sps->dev_num);
+	unregister_chrdev_region(sps->dev_num, 1);
+	class_destroy(sps->dev_class);
+	sps_device_de_init();
+
+	clk_put(sps->dfab_clk);
+	clk_put(sps->pmem_clk);
+	clk_put(sps->bamdma_clk);
+
+	return 0;
+}
+
+static struct platform_driver msm_sps_driver = {
+	.probe          = msm_sps_probe,
+	.driver		= {
+		.name	= "msm_sps", /* must match the platform_device name */
+		.owner	= THIS_MODULE,
+	},
+	.remove		= __exit_p(msm_sps_remove),
+};
+
+/**
+ * Module Init.
+ */
+static int __init sps_init(void)
+{
+	int ret;
+
+	SPS_DBG("%s.", __func__);
+
+	/* Allocate the SPS driver state struct */
+	sps = kzalloc(sizeof(*sps), GFP_KERNEL);
+	if (sps == NULL) {
+		SPS_ERR("sps:Unable to allocate driver state context.");
+		return -ENOMEM;
+	}
+
+	ret = platform_driver_register(&msm_sps_driver);
+
+	return ret;
+}
+
+/**
+ * Module Exit.
+ */
+static void __exit sps_exit(void)
+{
+	SPS_DBG("%s.", __func__);
+
+	platform_driver_unregister(&msm_sps_driver);
+
+	if (sps != NULL) {
+		kfree(sps);
+		sps = NULL;
+	}
+}
+
+arch_initcall(sps_init);
+module_exit(sps_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Smart Peripheral Switch (SPS)");
+
diff --git a/arch/arm/mach-msm/sps/sps_bam.c b/arch/arm/mach-msm/sps/sps_bam.c
new file mode 100644
index 0000000..c25b642
--- /dev/null
+++ b/arch/arm/mach-msm/sps/sps_bam.c
@@ -0,0 +1,1820 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/types.h>	/* u32 */
+#include <linux/kernel.h>	/* pr_info() */
+#include <linux/mutex.h>	/* mutex */
+#include <linux/list.h>		/* list_head */
+#include <linux/slab.h>		/* kzalloc() */
+#include <linux/interrupt.h>	/* request_irq() */
+#include <linux/memory.h>	/* memset */
+
+#include "sps_bam.h"
+#include "bam.h"
+#include "spsi.h"
+
+/* All BAM global IRQ sources */
+#define BAM_IRQ_ALL (BAM_DEV_IRQ_HRESP_ERROR | BAM_DEV_IRQ_RDY_TO_SLEEP)
+
+/* BAM device state flags */
+#define BAM_STATE_INIT     (1UL << 1)
+#define BAM_STATE_IRQ      (1UL << 2)
+#define BAM_STATE_ENABLED  (1UL << 3)
+#define BAM_STATE_BAM2BAM  (1UL << 4)
+#define BAM_STATE_MTI      (1UL << 5)
+#define BAM_STATE_REMOTE   (1UL << 6)
+
+/* BAM identifier used in log messages */
+#define BAM_ID(dev)       ((dev)->props.phys_addr)
+
+/* Mask for valid hardware descriptor flags */
+#define BAM_IOVEC_FLAG_MASK   \
+	(SPS_IOVEC_FLAG_INT | SPS_IOVEC_FLAG_EOT | SPS_IOVEC_FLAG_EOB)
+
+/* Mask for invalid BAM-to-BAM pipe options */
+#define BAM2BAM_O_INVALID   \
+	(SPS_O_DESC_DONE | \
+	 SPS_O_EOT | \
+	 SPS_O_POLL | \
+	 SPS_O_NO_Q | \
+	 SPS_O_ACK_TRANSFERS)
+
+/**
+ * Pipe/client pointer value indicating pipe is allocated, but no client has
+ * been assigned
+ */
+#define BAM_PIPE_UNASSIGNED   ((struct sps_pipe *)0x77777777)
+
+/* Check whether pipe has been assigned */
+#define BAM_PIPE_IS_ASSIGNED(p)  \
+	(((p) != NULL) && ((p) != BAM_PIPE_UNASSIGNED))
+
+/* Is MTI use supported for a specific BAM version? */
+#define BAM_VERSION_MTI_SUPPORT(ver)   (ver <= 2)
+
+/* Event option<->event translation table entry */
+struct sps_bam_opt_event_table {
+	enum sps_event event_id;
+	enum sps_option option;
+	enum bam_pipe_irq pipe_irq;
+};
+
+static const struct sps_bam_opt_event_table opt_event_table[] = {
+	{SPS_EVENT_EOT, SPS_O_EOT, BAM_PIPE_IRQ_EOT},
+	{SPS_EVENT_DESC_DONE, SPS_O_DESC_DONE, BAM_PIPE_IRQ_DESC_INT},
+	{SPS_EVENT_WAKEUP, SPS_O_WAKEUP, BAM_PIPE_IRQ_WAKE},
+	{SPS_EVENT_INACTIVE, SPS_O_INACTIVE, BAM_PIPE_IRQ_TIMER},
+	{SPS_EVENT_OUT_OF_DESC, SPS_O_OUT_OF_DESC,
+		BAM_PIPE_IRQ_OUT_OF_DESC},
+	{SPS_EVENT_ERROR, SPS_O_ERROR, BAM_PIPE_IRQ_ERROR}
+};
+
+/* Pipe event source handler */
+static void pipe_handler(struct sps_bam *dev,
+			struct sps_pipe *pipe);
+
+/**
+ * Pipe transfer event (EOT, DESC_DONE) source handler.
+ * This function is called by pipe_handler() and other functions to process the
+ * descriptor FIFO.
+ */
+static void pipe_handler_eot(struct sps_bam *dev,
+			   struct sps_pipe *pipe);
+
+/**
+ * BAM driver initialization
+ */
+int sps_bam_driver_init(u32 options)
+{
+	int n;
+
+	/*
+	 * Check that SPS_O_ and BAM_PIPE_IRQ_ values are identical.
+	 * This is required so that the raw pipe IRQ status can be passed
+	 * to the client in the SPS_EVENT_IRQ.
+	 */
+	for (n = 0; n < ARRAY_SIZE(opt_event_table); n++) {
+		if (opt_event_table[n].option != opt_event_table[n].pipe_irq) {
+			SPS_ERR("SPS_O 0x%x != HAL IRQ 0x%x",
+				opt_event_table[n].option,
+				opt_event_table[n].pipe_irq);
+			return SPS_ERROR;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * BAM interrupt service routine
+ *
+ * This function is the BAM interrupt service routine.
+ *
+ * @ctxt - pointer to ISR's registered argument
+ *
+ * @return void
+ */
+static irqreturn_t bam_isr(int irq, void *ctxt)
+{
+	struct sps_bam *dev = ctxt;
+	struct sps_pipe *pipe;
+	u32 source;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&dev->isr_lock, flags);
+
+	/* Get BAM interrupt source(s) */
+	if ((dev->state & BAM_STATE_MTI) == 0) {
+		u32 mask = dev->pipe_active_mask;
+		source = bam_get_and_clear_irq_status(dev->base,
+							  dev->props.ee,
+							  mask);
+
+		SPS_DBG("sps:bam_isr:source=0x%x.mask=0x%x.", source, mask);
+
+		/* Mask any non-local source */
+		source &= dev->pipe_active_mask;
+	} else {
+		/* If MTIs are used, must poll each active pipe */
+		source = dev->pipe_active_mask;
+	}
+
+	/* Process active pipe sources */
+	pipe = list_first_entry(&dev->pipes_q, struct sps_pipe, list);
+
+	list_for_each_entry(pipe, &dev->pipes_q, list) {
+		/* Check this pipe's bit in the source mask */
+		if ((source & pipe->pipe_index_mask)) {
+			/* This pipe has an interrupt pending */
+			pipe_handler(dev, pipe);
+			source &= ~pipe->pipe_index_mask;
+		}
+		if (source == 0)
+			break;
+	}
+
+	/* Process any inactive pipe sources */
+	if (source) {
+		SPS_ERR("IRQ from BAM 0x%x inactive pipe(s) 0x%x",
+			BAM_ID(dev), source);
+		dev->irq_from_disabled_pipe++;
+	}
+
+	spin_unlock_irqrestore(&dev->isr_lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * BAM device enable
+ */
+int sps_bam_enable(struct sps_bam *dev)
+{
+	u32 num_pipes;
+	u32 irq_mask;
+	int result;
+	int rc;
+
+	/* Is this BAM enabled? */
+	if ((dev->state & BAM_STATE_ENABLED))
+		return 0;	/* Yes, so no work to do */
+
+	/* Is there any access to this BAM? */
+	if ((dev->props.manage & SPS_BAM_MGR_ACCESS_MASK) == SPS_BAM_MGR_NONE) {
+		SPS_ERR("No local access to BAM 0x%x", BAM_ID(dev));
+		return SPS_ERROR;
+	}
+
+	/* Set interrupt handling */
+	if ((dev->props.options & SPS_BAM_OPT_IRQ_DISABLED) != 0 ||
+	    dev->props.irq == SPS_IRQ_INVALID) {
+		/* Disable the BAM interrupt */
+		irq_mask = 0;
+		dev->state &= ~BAM_STATE_IRQ;
+	} else {
+		/* Register BAM ISR */
+		if (dev->props.irq > 0)
+			result = request_irq(dev->props.irq,
+				    (irq_handler_t) bam_isr,
+				    IRQF_TRIGGER_HIGH, "sps", dev);
+
+		if (result) {
+			SPS_ERR("Failed to register BAM 0x%x IRQ %d",
+				BAM_ID(dev), dev->props.irq);
+			return SPS_ERROR;
+		}
+
+		/* Enable the BAM interrupt */
+		irq_mask = BAM_IRQ_ALL;
+		dev->state |= BAM_STATE_IRQ;
+	}
+
+	/* Is global BAM control managed by the local processor? */
+	num_pipes = 0;
+	if ((dev->props.manage & SPS_BAM_MGR_DEVICE_REMOTE) == 0)
+		/* Yes, so initialize the BAM device */
+		rc = bam_init(dev->base,
+				  dev->props.ee,
+				  (u16) dev->props.summing_threshold,
+				  irq_mask,
+				  &dev->version, &num_pipes);
+	else
+		/* No, so just verify that it is enabled */
+		rc = bam_check(dev->base, &dev->version, &num_pipes);
+
+	if (rc) {
+		SPS_ERR("Failed to init BAM 0x%x IRQ %d",
+			BAM_ID(dev), dev->props.irq);
+		return SPS_ERROR;
+	}
+
+	/*
+	 * Enable MTI use (message triggered interrupt)
+	 * if local processor does not control the global BAM config
+	 * and this BAM supports MTIs.
+	 */
+	if ((dev->state & BAM_STATE_IRQ) != 0 &&
+	    (dev->props.manage & SPS_BAM_MGR_DEVICE_REMOTE) != 0 &&
+	    BAM_VERSION_MTI_SUPPORT(dev->version)) {
+		if (dev->props.irq_gen_addr == 0 ||
+		    dev->props.irq_gen_addr == SPS_ADDR_INVALID) {
+			SPS_ERR("MTI destination address not specified "
+				"for BAM 0x%x",	BAM_ID(dev));
+			return SPS_ERROR;
+		}
+		dev->state |= BAM_STATE_MTI;
+	}
+
+	if (num_pipes) {
+		dev->props.num_pipes = num_pipes;
+		SPS_DBG("BAM 0x%x number of pipes reported by hw: %d",
+				 BAM_ID(dev), dev->props.num_pipes);
+	}
+
+	/*
+	 * If local processor controls the BAM global configuration,
+	 * set all restricted pipes to MTI mode
+	 */
+	if ((dev->props.manage & SPS_BAM_MGR_DEVICE_REMOTE) == 0) {
+		u32 pipe_index;
+		u32 pipe_mask;
+		for (pipe_index = 0, pipe_mask = 1;
+		    pipe_index < dev->props.num_pipes;
+		    pipe_index++, pipe_mask <<= 1) {
+			if ((pipe_mask & dev->props.restricted_pipes) == 0)
+				continue;	/* This is a local pipe */
+
+			/*
+			 * Enable MTI with destination address of zero
+			 * (and source mask zero). Pipe is in reset,
+			 * so no interrupt will be generated.
+			 */
+			bam_pipe_satellite_mti(dev->base, pipe_index, 0,
+						       dev->props.ee);
+		}
+	}
+
+	dev->state |= BAM_STATE_ENABLED;
+	SPS_DBG("BAM 0x%x enabled: ver: %d, number of pipes: %d",
+		BAM_ID(dev), dev->version, dev->props.num_pipes);
+	return 0;
+}
+
+/**
+ * BAM device disable
+ *
+ */
+int sps_bam_disable(struct sps_bam *dev)
+{
+	if ((dev->state & BAM_STATE_ENABLED) == 0)
+		return 0;
+
+	/* Is there any access to this BAM? */
+	if ((dev->props.manage & SPS_BAM_MGR_ACCESS_MASK) == SPS_BAM_MGR_NONE) {
+		SPS_ERR("No local access to BAM 0x%x", BAM_ID(dev));
+		return SPS_ERROR;
+	}
+
+	/* Is this BAM controlled by the local processor? */
+	if ((dev->props.manage & SPS_BAM_MGR_DEVICE_REMOTE)) {
+		/* No, so just mark it disabled */
+		dev->state &= ~BAM_STATE_ENABLED;
+		return 0;
+	}
+
+	/* Disable BAM (interrupts) */
+	if ((dev->state & BAM_STATE_IRQ)) {
+		bam_exit(dev->base, dev->props.ee);
+
+		/* Deregister BAM ISR */
+		if ((dev->state & BAM_STATE_IRQ))
+			if (dev->props.irq > 0)
+				free_irq(dev->props.irq, dev);
+		dev->state &= ~BAM_STATE_IRQ;
+	}
+
+	dev->state &= ~BAM_STATE_ENABLED;
+
+	SPS_DBG("BAM 0x%x disabled", BAM_ID(dev));
+
+	return 0;
+}
+
+/**
+ * BAM device initialization
+ */
+int sps_bam_device_init(struct sps_bam *dev)
+{
+	if (dev->props.virt_addr == NULL) {
+		SPS_ERR("NULL BAM virtual address");
+		return SPS_ERROR;
+	}
+	dev->base = (void *) dev->props.virt_addr;
+
+	if (dev->props.num_pipes == 0) {
+		/* Assume max number of pipes until BAM registers can be read */
+		dev->props.num_pipes = BAM_MAX_PIPES;
+		SPS_DBG("BAM 0x%x: assuming max number of pipes: %d",
+			BAM_ID(dev), dev->props.num_pipes);
+	}
+
+	/* Init BAM state data */
+	dev->state = 0;
+	dev->pipe_active_mask = 0;
+	dev->pipe_remote_mask = 0;
+	INIT_LIST_HEAD(&dev->pipes_q);
+
+	spin_lock_init(&dev->isr_lock);
+
+	if ((dev->props.options & SPS_BAM_OPT_ENABLE_AT_BOOT))
+		if (sps_bam_enable(dev))
+			return SPS_ERROR;
+
+	SPS_DBG("BAM device: phys 0x%x IRQ %d", BAM_ID(dev), dev->props.irq);
+
+	return 0;
+}
+
+/**
+ * BAM device de-initialization
+ *
+ */
+int sps_bam_device_de_init(struct sps_bam *dev)
+{
+	int result;
+
+	SPS_DBG("BAM device DEINIT: phys 0x%x IRQ %d",
+		BAM_ID(dev), dev->props.irq);
+
+	result = sps_bam_disable(dev);
+
+	return result;
+}
+
+/**
+ * BAM device reset
+ *
+ */
+int sps_bam_reset(struct sps_bam *dev)
+{
+	struct sps_pipe *pipe;
+	u32 pipe_index;
+	int result;
+
+	SPS_DBG("BAM device RESET: phys 0x%x IRQ %d",
+		BAM_ID(dev), dev->props.irq);
+
+	/* If BAM is enabled, then disable */
+	result = 0;
+	if ((dev->state & BAM_STATE_ENABLED)) {
+		/* Verify that no pipes are currently allocated */
+		for (pipe_index = 0; pipe_index < dev->props.num_pipes;
+		      pipe_index++) {
+			pipe = dev->pipes[pipe_index];
+			if (BAM_PIPE_IS_ASSIGNED(pipe)) {
+				SPS_ERR("BAM device 0x%x RESET failed: "
+					"pipe %d in use",
+					BAM_ID(dev), pipe_index);
+				result = SPS_ERROR;
+				break;
+			}
+		}
+
+		if (result == 0)
+			result = sps_bam_disable(dev);
+	}
+
+	/* BAM will be reset as part of the enable process */
+	if (result == 0)
+		result = sps_bam_enable(dev);
+
+	return result;
+}
+
+/**
+ * Clear the BAM pipe state struct
+ *
+ * This function clears the BAM pipe state struct.
+ *
+ * @pipe - pointer to client pipe struct
+ *
+ */
+static void pipe_clear(struct sps_pipe *pipe)
+{
+	INIT_LIST_HEAD(&pipe->list);
+
+	pipe->state = 0;
+	pipe->pipe_index = SPS_BAM_PIPE_INVALID;
+	pipe->pipe_index_mask = 0;
+	pipe->irq_mask = 0;
+	pipe->mode = -1;
+	pipe->num_descs = 0;
+	pipe->desc_size = 0;
+	memset(&pipe->sys, 0, sizeof(pipe->sys));
+	INIT_LIST_HEAD(&pipe->sys.events_q);
+}
+
+/**
+ * Allocate a BAM pipe
+ *
+ */
+u32 sps_bam_pipe_alloc(struct sps_bam *dev, u32 pipe_index)
+{
+	u32 pipe_mask;
+
+	if (pipe_index == SPS_BAM_PIPE_INVALID) {
+		/* Allocate a pipe from the BAM */
+		if ((dev->props.manage & SPS_BAM_MGR_PIPE_NO_ALLOC)) {
+			SPS_ERR("Restricted from allocating pipes on BAM 0x%x",
+				BAM_ID(dev));
+			return SPS_BAM_PIPE_INVALID;
+		}
+		for (pipe_index = 0, pipe_mask = 1;
+		    pipe_index < dev->props.num_pipes;
+		    pipe_index++, pipe_mask <<= 1) {
+			if ((pipe_mask & dev->props.restricted_pipes))
+				continue;	/* This is a restricted pipe */
+
+			if (dev->pipes[pipe_index] == NULL)
+				break;	/* Found an available pipe */
+		}
+		if (pipe_index >= dev->props.num_pipes) {
+			SPS_ERR("Failed to allocate pipe on BAM 0x%x",
+				BAM_ID(dev));
+			return SPS_BAM_PIPE_INVALID;
+		}
+	} else {
+		/* Check that client-specified pipe is available */
+		if (pipe_index >= dev->props.num_pipes) {
+			SPS_ERR("Invalid pipe %d for allocate on BAM 0x%x",
+				pipe_index, BAM_ID(dev));
+			return SPS_BAM_PIPE_INVALID;
+		}
+		if ((dev->props.restricted_pipes & (1UL << pipe_index))) {
+			SPS_ERR("BAM 0x%x pipe %d is not local",
+				BAM_ID(dev), pipe_index);
+			return SPS_BAM_PIPE_INVALID;
+		}
+		if (dev->pipes[pipe_index] != NULL) {
+			SPS_ERR("Pipe %d already allocated on BAM 0x%x",
+				pipe_index, BAM_ID(dev));
+			return SPS_BAM_PIPE_INVALID;
+		}
+	}
+
+	/* Mark pipe as allocated */
+	dev->pipes[pipe_index] = BAM_PIPE_UNASSIGNED;
+
+	return pipe_index;
+}
+
+/**
+ * Free a BAM pipe
+ *
+ */
+void sps_bam_pipe_free(struct sps_bam *dev, u32 pipe_index)
+{
+	struct sps_pipe *pipe;
+
+	if (pipe_index >= dev->props.num_pipes) {
+		SPS_ERR("Invalid BAM 0x%x pipe: %d", BAM_ID(dev), pipe_index);
+		return;
+	}
+
+	/* Get the client pipe struct and mark the pipe free */
+	pipe = dev->pipes[pipe_index];
+	dev->pipes[pipe_index] = NULL;
+
+	/* Is the pipe currently allocated? */
+	if (pipe == NULL) {
+		SPS_ERR("Attempt to free unallocated pipe %d on BAM 0x%x",
+			pipe_index, BAM_ID(dev));
+		return;
+	}
+
+	if (pipe == BAM_PIPE_UNASSIGNED)
+		return;		/* Never assigned, so no work to do */
+
+	/* Return pending items to appropriate pools */
+	if (!list_empty(&pipe->sys.events_q)) {
+		struct sps_q_event *sps_event;
+
+		SPS_ERR("Disconnect BAM 0x%x pipe %d with events pending",
+			BAM_ID(dev), pipe_index);
+
+		list_for_each_entry(sps_event, &pipe->sys.events_q, list) {
+			list_del(&sps_event->list);
+			kfree(sps_event);
+		}
+	}
+
+	/* Clear the BAM pipe state struct */
+	pipe_clear(pipe);
+}
+
+/**
+ * Establish BAM pipe connection
+ *
+ */
+int sps_bam_pipe_connect(struct sps_pipe *bam_pipe,
+			 const struct sps_bam_connect_param *params)
+{
+	struct bam_pipe_parameters hw_params;
+	struct sps_bam *dev;
+	const struct sps_connection *map = bam_pipe->map;
+	const struct sps_conn_end_pt *map_pipe;
+	const struct sps_conn_end_pt *other_pipe;
+	void *desc_buf = NULL;
+	u32 pipe_index;
+	int result;
+
+	/* Clear the client pipe state and hw init struct */
+	pipe_clear(bam_pipe);
+	memset(&hw_params, 0, sizeof(hw_params));
+
+	/* Initialize the BAM state struct */
+	bam_pipe->mode = params->mode;
+
+	/* Set pipe streaming mode */
+	if ((params->options & SPS_O_STREAMING) == 0)
+		hw_params.stream_mode = BAM_STREAM_MODE_DISABLE;
+	else
+		hw_params.stream_mode = BAM_STREAM_MODE_ENABLE;
+
+	/* Determine which end point to connect */
+	if (bam_pipe->mode == SPS_MODE_SRC) {
+		map_pipe = &map->src;
+		other_pipe = &map->dest;
+		hw_params.dir = BAM_PIPE_PRODUCER;
+	} else {
+		map_pipe = &map->dest;
+		other_pipe = &map->src;
+		hw_params.dir = BAM_PIPE_CONSUMER;
+	}
+
+	/* Process map parameters */
+	dev = map_pipe->bam;
+	pipe_index = map_pipe->pipe_index;
+	if (pipe_index >= dev->props.num_pipes) {
+		SPS_ERR("Invalid BAM 0x%x pipe: %d", BAM_ID(dev), pipe_index);
+		return SPS_ERROR;
+	}
+	hw_params.event_threshold = (u16) map_pipe->event_threshold;
+	hw_params.ee = dev->props.ee;
+
+	/* Verify that control of this pipe is allowed */
+	if ((dev->props.manage & SPS_BAM_MGR_PIPE_NO_CTRL) ||
+	    (dev->props.restricted_pipes & (1UL << pipe_index))) {
+		SPS_ERR("BAM 0x%x pipe %d is not local",
+			BAM_ID(dev), pipe_index);
+		return SPS_ERROR;
+	}
+
+	/* Control without configuration permission is not supported yet */
+	if ((dev->props.manage & SPS_BAM_MGR_PIPE_NO_CONFIG)) {
+		SPS_ERR("BAM 0x%x pipe %d remote config is not supported",
+			BAM_ID(dev), pipe_index);
+		return SPS_ERROR;
+	}
+
+	/* Determine operational mode */
+	if (other_pipe->bam != NULL) {
+		/* BAM-to-BAM mode */
+		bam_pipe->state |= BAM_STATE_BAM2BAM;
+		hw_params.mode = BAM_PIPE_MODE_BAM2BAM;
+		hw_params.peer_phys_addr =
+			((struct sps_bam *) (other_pipe->bam))->props.phys_addr;
+		hw_params.peer_pipe = other_pipe->pipe_index;
+
+		/* Verify FIFO buffers are allocated for BAM-to-BAM pipes */
+		if (map->desc.phys_base == SPS_ADDR_INVALID ||
+		    map->data.phys_base == SPS_ADDR_INVALID ||
+		    map->desc.size == 0 || map->data.size == 0) {
+			SPS_ERR("FIFO buffers are not allocated for BAM 0x%x "
+				"pipe %d", BAM_ID(dev), pipe_index);
+			return SPS_ERROR;
+		}
+		hw_params.data_base = map->data.phys_base;
+		hw_params.data_size = map->data.size;
+
+		/* Clear the data FIFO for debug */
+		if (map->data.base != NULL && bam_pipe->mode == SPS_MODE_SRC)
+			memset(map->data.base, 0, hw_params.data_size);
+	} else {
+		/* System mode */
+		hw_params.mode = BAM_PIPE_MODE_SYSTEM;
+		bam_pipe->sys.desc_buf = map->desc.base;
+		bam_pipe->sys.desc_offset = 0;
+		bam_pipe->sys.acked_offset = 0;
+	}
+
+	/* Initialize the client pipe state */
+	bam_pipe->pipe_index = pipe_index;
+	bam_pipe->pipe_index_mask = 1UL << pipe_index;
+
+	/* Get virtual address for descriptor FIFO */
+	if (map->desc.phys_base != SPS_ADDR_INVALID) {
+		if (map->desc.size < (2 * sizeof(struct sps_iovec))) {
+			SPS_ERR("Invalid descriptor FIFO size "
+				"for BAM 0x%x pipe %d: %d",
+				BAM_ID(dev), pipe_index, map->desc.size);
+			return SPS_ERROR;
+		}
+		desc_buf = map->desc.base;
+
+		/*
+		 * Note that descriptor base and size will be left zero from
+		 * the memset() above if the physical address was invalid.
+		 * This allows a satellite driver to set the FIFO as
+		 * local memory	for system mode.
+		 */
+		hw_params.desc_base = map->desc.phys_base;
+		hw_params.desc_size = map->desc.size;
+	}
+
+	/* Configure the descriptor FIFO for both operational modes */
+	if (desc_buf != NULL)
+		if (bam_pipe->mode == SPS_MODE_SRC ||
+		    hw_params.mode == BAM_PIPE_MODE_SYSTEM)
+			memset(desc_buf, 0, hw_params.desc_size);
+
+	bam_pipe->desc_size = hw_params.desc_size;
+	bam_pipe->num_descs = bam_pipe->desc_size / sizeof(struct sps_iovec);
+
+	result = SPS_ERROR;
+	/* Insure that the BAM is enabled */
+	if ((dev->state & BAM_STATE_ENABLED) == 0)
+		if (sps_bam_enable(dev))
+			goto exit_err;
+
+	/* Check pipe allocation */
+	if (dev->pipes[pipe_index] != BAM_PIPE_UNASSIGNED) {
+		SPS_ERR("Invalid pipe %d on BAM 0x%x for connect",
+			pipe_index, BAM_ID(dev));
+		goto exit_err;
+	}
+
+	if (bam_pipe_is_enabled(dev->base, pipe_index)) {
+		SPS_ERR("BAM 0x%x pipe %d sharing violation",
+			BAM_ID(dev), pipe_index);
+		goto exit_err;
+	}
+
+	if (bam_pipe_init(dev->base, pipe_index, &hw_params)) {
+		SPS_ERR("BAM 0x%x pipe %d init error",
+			BAM_ID(dev), pipe_index);
+		goto exit_err;
+	}
+
+	/* Assign pipe to client */
+	dev->pipes[pipe_index] = bam_pipe;
+
+	/* Process configuration parameters */
+	if (params->options != 0 ||
+	    (bam_pipe->state & BAM_STATE_BAM2BAM) == 0) {
+		/* Process init-time only parameters */
+		u32 irq_gen_addr;
+
+		/* Set interrupt mode */
+		irq_gen_addr = SPS_ADDR_INVALID;
+		if ((params->options & SPS_O_IRQ_MTI))
+			/* Client has directly specified the MTI address */
+			irq_gen_addr = params->irq_gen_addr;
+		else if ((dev->state & BAM_STATE_MTI))
+			/* This BAM has MTI use enabled */
+			irq_gen_addr = dev->props.irq_gen_addr;
+
+		if (irq_gen_addr != SPS_ADDR_INVALID) {
+			/*
+			 * No checks - assume BAM is already setup for
+			 * MTI generation,
+			 * or the pipe will be set to satellite control.
+			 */
+			bam_pipe->state |= BAM_STATE_MTI;
+			bam_pipe->irq_gen_addr = irq_gen_addr;
+		}
+
+		/* Process runtime parameters */
+		if (sps_bam_pipe_set_params(dev, pipe_index,
+					  params->options)) {
+			dev->pipes[pipe_index] = BAM_PIPE_UNASSIGNED;
+			goto exit_err;
+		}
+	}
+
+	/* Indicate initialization is complete */
+	dev->pipes[pipe_index] = bam_pipe;
+	dev->pipe_active_mask |= 1UL << pipe_index;
+	list_add_tail(&bam_pipe->list, &dev->pipes_q);
+
+	bam_pipe->state |= BAM_STATE_INIT;
+	result = 0;
+exit_err:
+	if (result) {
+		bam_pipe_exit(dev->base, pipe_index, dev->props.ee);
+
+		/* Clear the client pipe state */
+		pipe_clear(bam_pipe);
+	}
+
+	return result;
+}
+
+/**
+ * Disconnect a BAM pipe connection
+ *
+ */
+int sps_bam_pipe_disconnect(struct sps_bam *dev, u32 pipe_index)
+{
+	struct sps_pipe *pipe;
+	int result;
+
+	if (pipe_index >= dev->props.num_pipes) {
+		SPS_ERR("Invalid BAM 0x%x pipe: %d", BAM_ID(dev), pipe_index);
+		return SPS_ERROR;
+	}
+
+	/* Deallocate and reset the BAM pipe */
+	pipe = dev->pipes[pipe_index];
+	if (BAM_PIPE_IS_ASSIGNED(pipe)) {
+		if ((dev->pipe_active_mask & (1UL << pipe_index))) {
+			list_del(&pipe->list);
+			dev->pipe_active_mask &= ~(1UL << pipe_index);
+		}
+		dev->pipe_remote_mask &= ~(1UL << pipe_index);
+		bam_pipe_exit(dev->base, pipe_index, dev->props.ee);
+		if (pipe->sys.desc_cache != NULL) {
+			kfree(pipe->sys.desc_cache);
+			pipe->sys.desc_cache = NULL;
+		}
+		dev->pipes[pipe_index] = BAM_PIPE_UNASSIGNED;
+		pipe_clear(pipe);
+		result = 0;
+	} else {
+		result = SPS_ERROR;
+	}
+
+	if (result)
+		SPS_ERR("BAM 0x%x pipe %d already disconnected",
+			BAM_ID(dev), pipe_index);
+
+	return result;
+}
+
+/**
+ * Set BAM pipe interrupt enable state
+ *
+ * This function sets the interrupt enable state for a BAM pipe.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @poll - true if SPS_O_POLL is set, false otherwise
+ *
+ */
+static void pipe_set_irq(struct sps_bam *dev, u32 pipe_index,
+				 u32 poll)
+{
+	struct sps_pipe *pipe = dev->pipes[pipe_index];
+	enum bam_enable irq_enable;
+
+	if (poll == 0 && pipe->irq_mask != 0 &&
+	    (dev->state & BAM_STATE_IRQ)) {
+		if ((pipe->state & BAM_STATE_BAM2BAM) != 0 &&
+		    (pipe->state & BAM_STATE_IRQ) == 0) {
+			/*
+			 * If enabling the interrupt for a BAM-to-BAM pipe,
+			 * clear the existing interrupt status
+			 */
+			(void)bam_pipe_get_and_clear_irq_status(dev->base,
+							   pipe_index);
+		}
+		pipe->state |= BAM_STATE_IRQ;
+		irq_enable = BAM_ENABLE;
+		pipe->polled = false;
+	} else {
+		pipe->state &= ~BAM_STATE_IRQ;
+		irq_enable = BAM_DISABLE;
+		pipe->polled = true;
+		if (poll == 0 && pipe->irq_mask)
+			SPS_INFO("BAM 0x%x pipe %d forced to use polling",
+				 BAM_ID(dev), pipe_index);
+	}
+	if ((pipe->state & BAM_STATE_MTI) == 0)
+		bam_pipe_set_irq(dev->base, pipe_index, irq_enable,
+					 pipe->irq_mask, dev->props.ee);
+	else
+		bam_pipe_set_mti(dev->base, pipe_index, irq_enable,
+					 pipe->irq_mask, pipe->irq_gen_addr);
+
+}
+
+/**
+ * Set BAM pipe parameters
+ *
+ */
+int sps_bam_pipe_set_params(struct sps_bam *dev, u32 pipe_index, u32 options)
+{
+	struct sps_pipe *pipe = dev->pipes[pipe_index];
+	u32 mask;
+	int wake_up_is_one_shot;
+	int no_queue;
+	int ack_xfers;
+	u32 size;
+	int n;
+
+	/* Capture some options */
+	wake_up_is_one_shot = ((options & SPS_O_WAKEUP_IS_ONESHOT));
+	no_queue = ((options & SPS_O_NO_Q));
+	ack_xfers = ((options & SPS_O_ACK_TRANSFERS));
+
+	/* Create interrupt source mask */
+	mask = 0;
+	for (n = 0; n < ARRAY_SIZE(opt_event_table); n++) {
+		/* Is client registering for this event? */
+		if ((options & opt_event_table[n].option) == 0)
+			continue;	/* No */
+
+		mask |= opt_event_table[n].pipe_irq;
+	}
+
+#ifdef SPS_BAM_STATISTICS
+	/* Is an illegal mode change specified? */
+	if (pipe->sys.desc_wr_count > 0 &&
+	    (no_queue != pipe->sys.no_queue
+	     || ack_xfers != pipe->sys.ack_xfers)) {
+		SPS_ERR("Queue/ack mode change after transfer: "
+			"BAM 0x%x pipe %d opt 0x%x",
+			BAM_ID(dev), pipe_index, options);
+		return SPS_ERROR;
+	}
+#endif /* SPS_BAM_STATISTICS */
+
+	/* Is client setting invalid options for a BAM-to-BAM connection? */
+	if ((pipe->state & BAM_STATE_BAM2BAM) &&
+	    (options & BAM2BAM_O_INVALID)) {
+		SPS_ERR("Invalid option for BAM-to-BAM: BAM 0x%x pipe %d "
+			"opt 0x%x", BAM_ID(dev), pipe_index, options);
+		return SPS_ERROR;
+	}
+
+	/* Allocate descriptor FIFO cache if NO_Q option is disabled */
+	if (!no_queue && pipe->sys.desc_cache == NULL && pipe->num_descs > 0
+	    && (pipe->state & BAM_STATE_BAM2BAM) == 0) {
+		/* Allocate both descriptor cache and user pointer array */
+		size = pipe->num_descs * sizeof(void *);
+		pipe->sys.desc_cache =
+		kzalloc(pipe->desc_size + size, GFP_KERNEL);
+		if (pipe->sys.desc_cache == NULL) {
+			/*** MUST BE LAST POINT OF FAILURE (see below) *****/
+			SPS_ERR("Desc cache error: BAM 0x%x pipe %d: %d",
+				BAM_ID(dev), pipe_index,
+				pipe->desc_size + size);
+			return SPS_ERROR;
+		}
+		pipe->sys.user_ptrs = (void **)(pipe->sys.desc_cache +
+						 pipe->desc_size);
+		pipe->sys.cache_offset = pipe->sys.acked_offset;
+	}
+
+	/*
+	 * No failures beyond this point. Note that malloc() is last point of
+	 * failure, so no free() handling is needed.
+	 */
+
+	/* Enable/disable the pipe's interrupt sources */
+	pipe->irq_mask = mask;
+	pipe_set_irq(dev, pipe_index, (options & SPS_O_POLL));
+
+	/* Store software feature enables */
+	pipe->wake_up_is_one_shot = wake_up_is_one_shot;
+	pipe->sys.no_queue = no_queue;
+	pipe->sys.ack_xfers = ack_xfers;
+
+	return 0;
+}
+
+/**
+ * Enable a BAM pipe
+ *
+ */
+int sps_bam_pipe_enable(struct sps_bam *dev, u32 pipe_index)
+{
+	struct sps_pipe *pipe = dev->pipes[pipe_index];
+
+	/* Enable the BAM pipe */
+	bam_pipe_enable(dev->base, pipe_index);
+	pipe->state |= BAM_STATE_ENABLED;
+
+	return 0;
+}
+
+/**
+ * Disable a BAM pipe
+ *
+ */
+int sps_bam_pipe_disable(struct sps_bam *dev, u32 pipe_index)
+{
+	struct sps_pipe *pipe = dev->pipes[pipe_index];
+
+	/* Disable the BAM pipe */
+	bam_pipe_disable(dev->base, pipe_index);
+	pipe->state &= ~BAM_STATE_ENABLED;
+
+	return 0;
+}
+
+/**
+ * Register an event for a BAM pipe
+ *
+ */
+int sps_bam_pipe_reg_event(struct sps_bam *dev,
+			   u32 pipe_index,
+			   struct sps_register_event *reg)
+{
+	struct sps_pipe *pipe = dev->pipes[pipe_index];
+	struct sps_bam_event_reg *event_reg;
+	int n;
+
+	if (pipe->sys.no_queue && reg->xfer_done != NULL &&
+	    reg->mode != SPS_TRIGGER_CALLBACK) {
+		SPS_ERR("Only callback events support for NO_Q: "
+			"BAM 0x%x pipe %d mode %d",
+			BAM_ID(dev), pipe_index, reg->mode);
+		return SPS_ERROR;
+	}
+
+	for (n = 0; n < ARRAY_SIZE(opt_event_table); n++) {
+		int index;
+
+		/* Is client registering for this event? */
+		if ((reg->options & opt_event_table[n].option) == 0)
+			continue;	/* No */
+
+		index = SPS_EVENT_INDEX(opt_event_table[n].event_id);
+		event_reg = &pipe->sys.event_regs[index];
+		event_reg->xfer_done = reg->xfer_done;
+		event_reg->callback = reg->callback;
+		event_reg->mode = reg->mode;
+		event_reg->user = reg->user;
+	}
+
+	return 0;
+}
+
+/**
+ * Submit a transfer of a single buffer to a BAM pipe
+ *
+ */
+int sps_bam_pipe_transfer_one(struct sps_bam *dev,
+				    u32 pipe_index, u32 addr, u32 size,
+				    void *user, u32 flags)
+{
+	struct sps_pipe *pipe = dev->pipes[pipe_index];
+	struct sps_iovec *desc;
+	struct sps_iovec iovec;
+	u32 next_write;
+
+	/* Is this a BAM-to-BAM or satellite connection? */
+	if ((pipe->state & (BAM_STATE_BAM2BAM | BAM_STATE_REMOTE))) {
+		SPS_ERR("Transfer on BAM-to-BAM: BAM 0x%x pipe %d",
+			BAM_ID(dev), pipe_index);
+		return SPS_ERROR;
+	}
+
+	/*
+	 * Client identifier (user pointer) is not supported for
+	 * SPS_O_NO_Q option.
+	 */
+	if (pipe->sys.no_queue && user != NULL) {
+		SPS_ERR("User pointer arg non-NULL: BAM 0x%x pipe %d",
+			BAM_ID(dev), pipe_index);
+		return SPS_ERROR;
+	}
+
+	/* Determine if descriptor can be queued */
+	next_write = pipe->sys.desc_offset + sizeof(struct sps_iovec);
+	if (next_write >= pipe->desc_size)
+		next_write = 0;
+
+	if (next_write == pipe->sys.acked_offset) {
+		/*
+		 * If pipe is polled and client is not ACK'ing descriptors,
+		 * perform polling operation so that any outstanding ACKs
+		 * can occur.
+		 */
+		if (!pipe->sys.ack_xfers && pipe->polled) {
+			pipe_handler_eot(dev, pipe);
+			if (next_write == pipe->sys.acked_offset) {
+				SPS_DBG("Descriptor FIFO is full for "
+					"BAM 0x%x pipe %d",
+					BAM_ID(dev), pipe_index);
+				return SPS_ERROR;
+			}
+		} else {
+			SPS_DBG("Descriptor FIFO is full for "
+				"BAM 0x%x pipe %d", BAM_ID(dev), pipe_index);
+			return SPS_ERROR;
+		}
+	}
+
+	/* Create descriptor */
+	if (!pipe->sys.no_queue)
+		desc = (struct sps_iovec *) (pipe->sys.desc_cache +
+					      pipe->sys.desc_offset);
+	else
+		desc = &iovec;
+
+	desc->addr = addr;
+	desc->size = size;
+	if ((flags & SPS_IOVEC_FLAG_DEFAULT) == 0) {
+		desc->flags = flags & BAM_IOVEC_FLAG_MASK;
+	} else {
+		if (pipe->mode == SPS_MODE_SRC)
+			desc->flags = SPS_IOVEC_FLAG_INT;
+		else
+			desc->flags = SPS_IOVEC_FLAG_INT | SPS_IOVEC_FLAG_EOT;
+	}
+#ifdef SPS_BAM_STATISTICS
+	if ((flags & SPS_IOVEC_FLAG_INT))
+		pipe->sys.int_flags++;
+	if ((flags & SPS_IOVEC_FLAG_EOT))
+		pipe->sys.eot_flags++;
+#endif /* SPS_BAM_STATISTICS */
+
+	/* Update hardware descriptor FIFO - should result in burst */
+	*((struct sps_iovec *) (pipe->sys.desc_buf + pipe->sys.desc_offset))
+	= *desc;
+
+	/* Record user pointer value */
+	if (!pipe->sys.no_queue) {
+		u32 index = pipe->sys.desc_offset / sizeof(struct sps_iovec);
+		pipe->sys.user_ptrs[index] = user;
+#ifdef SPS_BAM_STATISTICS
+		if (user != NULL)
+			pipe->sys.user_ptrs_count++;
+#endif /* SPS_BAM_STATISTICS */
+	}
+
+	/* Update descriptor ACK offset */
+	pipe->sys.desc_offset = next_write;
+
+#ifdef SPS_BAM_STATISTICS
+	/* Update statistics */
+	pipe->sys.desc_wr_count++;
+#endif /* SPS_BAM_STATISTICS */
+
+	/* Notify pipe */
+	if ((flags & SPS_IOVEC_FLAG_NO_SUBMIT) == 0) {
+		wmb(); /* Memory Barrier */
+		bam_pipe_set_desc_write_offset(dev->base, pipe_index,
+					       next_write);
+	}
+
+	return 0;
+}
+
+/**
+ * Submit a transfer to a BAM pipe
+ *
+ */
+int sps_bam_pipe_transfer(struct sps_bam *dev,
+			 u32 pipe_index, struct sps_transfer *transfer)
+{
+	struct sps_iovec *iovec;
+	u32 count;
+	u32 flags;
+	void *user;
+	int n;
+	int result;
+
+	if (transfer->iovec_count == 0) {
+		SPS_ERR("iovec count zero: BAM 0x%x pipe %d",
+			BAM_ID(dev), pipe_index);
+		return SPS_ERROR;
+	}
+
+	sps_bam_get_free_count(dev, pipe_index, &count);
+	if (count < transfer->iovec_count) {
+		SPS_ERR("Insufficient free desc: BAM 0x%x pipe %d: %d",
+			BAM_ID(dev), pipe_index, count);
+		return SPS_ERROR;
+	}
+
+	user = NULL;		/* NULL for all except last descriptor */
+	for (n = (int)transfer->iovec_count - 1, iovec = transfer->iovec;
+	    n >= 0; n--, iovec++) {
+		if (n > 0) {
+			/* This is *not* the last descriptor */
+			flags = iovec->flags | SPS_IOVEC_FLAG_NO_SUBMIT;
+		} else {
+			/* This *is* the last descriptor */
+			flags = iovec->flags;
+			user = transfer->user;
+		}
+		result = sps_bam_pipe_transfer_one(dev, pipe_index,
+						 iovec->addr,
+						 iovec->size, user,
+						 flags);
+		if (result)
+			return SPS_ERROR;
+	}
+
+	return 0;
+}
+
+/**
+ * Allocate an event tracking struct
+ *
+ * This function allocates an event tracking struct.
+ *
+ * @pipe - pointer to pipe state
+ *
+ * @event_reg - pointer to event registration
+ *
+ * @return - pointer to event notification struct, or NULL
+ *
+ */
+static struct sps_q_event *alloc_event(struct sps_pipe *pipe,
+					struct sps_bam_event_reg *event_reg)
+{
+	struct sps_q_event *event;
+
+	/* A callback event object is registered, so trigger with payload */
+	event = &pipe->sys.event;
+	memset(event, 0, sizeof(*event));
+
+	return event;
+}
+
+/**
+ * Trigger an event notification
+ *
+ * This function triggers an event notification.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe - pointer to pipe state
+ *
+ * @event_reg - pointer to event registration
+ *
+ * @sps_event - pointer to event struct
+ *
+ */
+static void trigger_event(struct sps_bam *dev,
+			  struct sps_pipe *pipe,
+			  struct sps_bam_event_reg *event_reg,
+			  struct sps_q_event *sps_event)
+{
+	if (sps_event == NULL) {
+		SPS_DBG("sps:trigger_event.sps_event is NULL.");
+		return;
+	}
+
+	if (event_reg->xfer_done) {
+		complete(event_reg->xfer_done);
+		SPS_DBG("sps:trigger_event.done=%d.",
+			event_reg->xfer_done->done);
+	}
+
+	if (event_reg->callback) {
+		event_reg->callback(&sps_event->notify);
+		SPS_DBG("sps:trigger_event.using callback.");
+	}
+
+}
+
+/**
+ * Handle a BAM pipe's generic interrupt sources
+ *
+ * This function creates the event notification for a BAM pipe's
+ *    generic interrupt sources.  The caller of this function must lock the BAM
+ *    device's mutex.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe - pointer to pipe state
+ *
+ * @event_id - event identifier enum
+ *
+ */
+static void pipe_handler_generic(struct sps_bam *dev,
+			       struct sps_pipe *pipe,
+			       enum sps_event event_id)
+{
+	struct sps_bam_event_reg *event_reg;
+	struct sps_q_event *sps_event;
+	int index;
+
+	index = SPS_EVENT_INDEX(event_id);
+	if (index < 0 || index >= SPS_EVENT_INDEX(SPS_EVENT_MAX))
+		return;
+
+	event_reg = &pipe->sys.event_regs[index];
+	sps_event = alloc_event(pipe, event_reg);
+	if (sps_event != NULL) {
+		sps_event->notify.event_id = event_id;
+		sps_event->notify.user = event_reg->user;
+		trigger_event(dev, pipe, event_reg, sps_event);
+	}
+}
+
+/**
+ * Handle a BAM pipe's WAKEUP interrupt sources
+ *
+ * This function creates the event notification for a BAM pipe's
+ *    WAKEUP interrupt source.  The caller of this function must lock the BAM
+ *    device's mutex.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe - pointer to pipe state
+ *
+ */
+static void pipe_handler_wakeup(struct sps_bam *dev, struct sps_pipe *pipe)
+{
+	struct sps_bam_event_reg *event_reg;
+	struct sps_q_event *event;
+	u32 pipe_index = pipe->pipe_index;
+
+	if (pipe->wake_up_is_one_shot) {
+		/* Disable the pipe WAKEUP interrupt source */
+		pipe->irq_mask &= ~BAM_PIPE_IRQ_WAKE;
+		pipe_set_irq(dev, pipe_index, pipe->polled);
+	}
+
+	event_reg = &pipe->sys.event_regs[SPS_EVENT_INDEX(SPS_EVENT_WAKEUP)];
+	event = alloc_event(pipe, event_reg);
+	if (event != NULL) {
+		event->notify.event_id = SPS_EVENT_WAKEUP;
+		event->notify.user = event_reg->user;
+		trigger_event(dev, pipe, event_reg, event);
+	}
+}
+
+/**
+ * Handle a BAM pipe's EOT/INT interrupt sources
+ *
+ * This function creates the event notification for a BAM pipe's EOT interrupt
+ *    source.  The caller of this function must lock the BAM device's mutex.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe - pointer to pipe state
+ *
+ */
+static void pipe_handler_eot(struct sps_bam *dev, struct sps_pipe *pipe)
+{
+	struct sps_bam_event_reg *event_reg;
+	struct sps_q_event *event;
+	struct sps_iovec *desc;
+	struct sps_iovec *cache;
+	void **user;
+	u32 *update_offset;
+	u32 pipe_index = pipe->pipe_index;
+	u32 offset;
+	u32 end_offset;
+	enum sps_event event_id;
+	u32 flags;
+	u32 enabled;
+	int producer = (pipe->mode == SPS_MODE_SRC);
+
+	if (pipe->sys.handler_eot)
+		/*
+		 * This can happen if the pipe is configured for polling
+		 * (IRQ disabled) and callback event generation.
+		 * The client may perform a get_iovec() inside the callback.
+		 */
+		return;
+
+	pipe->sys.handler_eot = true;
+
+	/* Get offset of last descriptor completed by the pipe */
+	end_offset = bam_pipe_get_desc_read_offset(dev->base, pipe_index);
+
+	/* If no queue, then do not generate any events */
+	if (pipe->sys.no_queue) {
+		if (!pipe->sys.ack_xfers) {
+			/* Client is not ACK'ing transfers, so do it now */
+			pipe->sys.acked_offset = end_offset;
+		}
+		pipe->sys.handler_eot = false;
+		return;
+	}
+
+	/*
+	 * Get offset of last descriptor processed by software,
+	 * and update to the last descriptor completed by the pipe
+	 */
+	if (!pipe->sys.ack_xfers) {
+		update_offset = &pipe->sys.acked_offset;
+		offset = *update_offset;
+	} else {
+		update_offset = &pipe->sys.cache_offset;
+		offset = *update_offset;
+	}
+
+	/* Are there any completed descriptors to process? */
+	if (offset == end_offset) {
+		pipe->sys.handler_eot = false;
+		return;
+	}
+
+	/* Determine enabled events */
+	enabled = 0;
+	if ((pipe->irq_mask & SPS_O_EOT))
+		enabled |= SPS_IOVEC_FLAG_EOT;
+
+	if ((pipe->irq_mask & SPS_O_DESC_DONE))
+		enabled |= SPS_IOVEC_FLAG_INT;
+
+	/*
+	 * For producer pipe, update the cached descriptor byte count and flags.
+	 * For consumer pipe, the BAM does not update the descriptors, so just
+	 * use the cached copies.
+	 */
+	if (producer) {
+		/*
+		 * Do copies in a tight loop to increase chance of
+		 * multi-descriptor burst accesses on the bus
+		 */
+		struct sps_iovec *desc_end;
+
+		/* Set starting point for copy */
+		desc = (struct sps_iovec *) (pipe->sys.desc_buf + offset);
+		cache =	(struct sps_iovec *) (pipe->sys.desc_cache + offset);
+
+		/* Fetch all completed descriptors to end of FIFO (wrap) */
+		if (end_offset < offset) {
+			desc_end = (struct sps_iovec *)
+				   (pipe->sys.desc_buf + pipe->desc_size);
+			while (desc < desc_end)
+				*cache++ = *desc++;
+
+			desc = (void *)pipe->sys.desc_buf;
+			cache = (void *)pipe->sys.desc_cache;
+		}
+
+		/* Fetch all remaining completed descriptors (no wrap) */
+		desc_end = (struct sps_iovec *)	(pipe->sys.desc_buf +
+						 end_offset);
+		while (desc < desc_end)
+			*cache++ = *desc++;
+	}
+
+	/* Process all completed descriptors */
+	cache = (struct sps_iovec *) (pipe->sys.desc_cache + offset);
+	user = &pipe->sys.user_ptrs[offset / sizeof(struct sps_iovec)];
+	for (;;) {
+		/*
+		 * Increment offset to next descriptor and update pipe offset
+		 * so a client callback can fetch the I/O vector.
+		 */
+		offset += sizeof(struct sps_iovec);
+		if (offset >= pipe->desc_size)
+			/* Roll to start of descriptor FIFO */
+			offset = 0;
+
+		*update_offset = offset;
+#ifdef SPS_BAM_STATISTICS
+		pipe->sys.desc_rd_count++;
+#endif /* SPS_BAM_STATISTICS */
+
+		/* Did client request notification for this descriptor? */
+		flags = cache->flags & enabled;
+		if (*user != NULL || flags) {
+			int index;
+
+			if ((flags & SPS_IOVEC_FLAG_EOT))
+				event_id = SPS_EVENT_EOT;
+			else
+				event_id = SPS_EVENT_DESC_DONE;
+
+			index = SPS_EVENT_INDEX(event_id);
+			event_reg = &pipe->sys.event_regs[index];
+			event = alloc_event(pipe, event_reg);
+			if (event != NULL) {
+				/*
+				 * Store the descriptor and user pointer
+				 * in the notification
+				 */
+				event->notify.data.transfer.iovec = *cache;
+				event->notify.data.transfer.user = *user;
+
+				event->notify.event_id = event_id;
+				event->notify.user = event_reg->user;
+				trigger_event(dev, pipe, event_reg, event);
+			}
+#ifdef SPS_BAM_STATISTICS
+			if (*user != NULL)
+				pipe->sys.user_found++;
+#endif /* SPS_BAM_STATISTICS */
+		}
+
+		/* Increment to next descriptor */
+		if (offset == end_offset)
+			break;	/* No more descriptors */
+
+		if (offset) {
+			cache++;
+			user++;
+		} else {
+			cache = (void *)pipe->sys.desc_cache;
+			user = pipe->sys.user_ptrs;
+		}
+	}
+
+	pipe->sys.handler_eot = false;
+}
+
+/**
+ * Handle a BAM pipe's interrupt sources
+ *
+ * This function handles a BAM pipe's interrupt sources.
+ *    The caller of this function must lock the BAM device's mutex.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @return void
+ *
+ */
+static void pipe_handler(struct sps_bam *dev, struct sps_pipe *pipe)
+{
+	u32 pipe_index;
+	u32 status;
+	enum sps_event event_id;
+
+	/* Get interrupt sources and ack all */
+	pipe_index = pipe->pipe_index;
+	status = bam_pipe_get_and_clear_irq_status(dev->base, pipe_index);
+
+	SPS_DBG("sps:pipe_handler.pipe %d.status=0x%x.", pipe_index, status);
+
+	/* Check for enabled interrupt sources */
+	status &= pipe->irq_mask;
+	if (status == 0)
+		/* No enabled interrupt sources are active */
+		return;
+
+	/*
+	 * Process the interrupt sources in order of frequency of occurrance.
+	 * Check for early exit opportunities.
+	 */
+
+	if ((status & (SPS_O_EOT | SPS_O_DESC_DONE)) &&
+	    (pipe->state & BAM_STATE_BAM2BAM) == 0) {
+		pipe_handler_eot(dev, pipe);
+		if (pipe->sys.no_queue) {
+			/*
+			 * EOT handler will not generate any event if there
+			 * is no queue,
+			 * so generate "empty" (no descriptor) event
+			 */
+			if ((status & SPS_O_EOT))
+				event_id = SPS_EVENT_EOT;
+			else
+				event_id = SPS_EVENT_DESC_DONE;
+
+			pipe_handler_generic(dev, pipe, event_id);
+		}
+		status &= ~(SPS_O_EOT | SPS_O_DESC_DONE);
+		if (status == 0)
+			return;
+	}
+
+	if ((status & SPS_O_WAKEUP)) {
+		pipe_handler_wakeup(dev, pipe);
+		status &= ~SPS_O_WAKEUP;
+		if (status == 0)
+			return;
+	}
+
+	if ((status & SPS_O_INACTIVE)) {
+		pipe_handler_generic(dev, pipe, SPS_EVENT_INACTIVE);
+		status &= ~SPS_O_INACTIVE;
+		if (status == 0)
+			return;
+	}
+
+	if ((status & SPS_O_OUT_OF_DESC)) {
+		pipe_handler_generic(dev, pipe,
+					     SPS_EVENT_OUT_OF_DESC);
+		status &= ~SPS_O_OUT_OF_DESC;
+		if (status == 0)
+			return;
+	}
+
+	if ((status & SPS_EVENT_ERROR))
+		pipe_handler_generic(dev, pipe, SPS_EVENT_ERROR);
+}
+
+/**
+ * Get a BAM pipe event
+ *
+ */
+int sps_bam_pipe_get_event(struct sps_bam *dev,
+			   u32 pipe_index, struct sps_event_notify *notify)
+{
+	struct sps_pipe *pipe = dev->pipes[pipe_index];
+	struct sps_q_event *event_queue;
+
+	if (pipe->sys.no_queue) {
+		SPS_ERR("Invalid connection for event: "
+			"BAM 0x%x pipe %d context 0x%x",
+			BAM_ID(dev), pipe_index, (u32) pipe);
+		notify->event_id = SPS_EVENT_INVALID;
+		return SPS_ERROR;
+	}
+
+	/* If pipe is polled, perform polling operation */
+	if (pipe->polled && (pipe->state & BAM_STATE_BAM2BAM) == 0)
+		pipe_handler_eot(dev, pipe);
+
+	/* Pull an event off the synchronous event queue */
+	if (list_empty(&pipe->sys.events_q)) {
+		event_queue = NULL;
+		SPS_DBG("sps:events_q is empty.");
+	} else {
+		SPS_DBG("sps:events_q is not empty.");
+		event_queue =
+		list_first_entry(&pipe->sys.events_q, struct sps_q_event,
+				 list);
+		list_del(&event_queue->list);
+	}
+
+	/* Update client's event buffer */
+	if (event_queue == NULL) {
+		/* No event queued, so set client's event to "invalid" */
+		notify->event_id = SPS_EVENT_INVALID;
+	} else {
+		/*
+		 * Copy event into client's buffer and return the event
+		 * to the pool
+		 */
+		*notify = event_queue->notify;
+		kfree(event_queue);
+#ifdef SPS_BAM_STATISTICS
+		pipe->sys.get_events++;
+#endif /* SPS_BAM_STATISTICS */
+	}
+
+	return 0;
+}
+
+/**
+ * Get processed I/O vector
+ */
+int sps_bam_pipe_get_iovec(struct sps_bam *dev, u32 pipe_index,
+			   struct sps_iovec *iovec)
+{
+	struct sps_pipe *pipe = dev->pipes[pipe_index];
+	struct sps_iovec *desc;
+	u32 read_offset;
+
+	/* Is this a valid pipe configured for get_iovec use? */
+	if (!pipe->sys.ack_xfers ||
+	    (pipe->state & BAM_STATE_BAM2BAM) != 0 ||
+	    (pipe->state & BAM_STATE_REMOTE)) {
+		return SPS_ERROR;
+	}
+
+	/* If pipe is polled and queue is enabled, perform polling operation */
+	if (pipe->polled && !pipe->sys.no_queue)
+		pipe_handler_eot(dev, pipe);
+
+	/* Is there a completed descriptor? */
+	if (pipe->sys.no_queue)
+		read_offset =
+		bam_pipe_get_desc_read_offset(dev->base, pipe_index);
+	else
+		read_offset = pipe->sys.cache_offset;
+
+	if (read_offset == pipe->sys.acked_offset) {
+		/* No, so clear the iovec to indicate FIFO is empty */
+		memset(iovec, 0, sizeof(*iovec));
+		return 0;
+	}
+
+	/* Fetch next descriptor */
+	desc = (struct sps_iovec *) (pipe->sys.desc_buf +
+				     pipe->sys.acked_offset);
+	*iovec = *desc;
+#ifdef SPS_BAM_STATISTICS
+	pipe->sys.get_iovecs++;
+#endif /* SPS_BAM_STATISTICS */
+
+	/* Update read/ACK offset */
+	pipe->sys.acked_offset += sizeof(struct sps_iovec);
+	if (pipe->sys.acked_offset >= pipe->desc_size)
+		pipe->sys.acked_offset = 0;
+
+	return 0;
+}
+
+/**
+ * Determine whether a BAM pipe descriptor FIFO is empty
+ *
+ */
+int sps_bam_pipe_is_empty(struct sps_bam *dev, u32 pipe_index,
+				u32 *empty)
+{
+	struct sps_pipe *pipe = dev->pipes[pipe_index];
+	u32 end_offset;
+	u32 acked_offset;
+
+	/* Is this a satellite connection? */
+	if ((pipe->state & BAM_STATE_REMOTE)) {
+		SPS_ERR("Is empty on remote: BAM 0x%x pipe %d",
+			BAM_ID(dev), pipe_index);
+		return SPS_ERROR;
+	}
+
+	/* Get offset of last descriptor completed by the pipe */
+	end_offset = bam_pipe_get_desc_read_offset(dev->base, pipe_index);
+
+	if ((pipe->state & BAM_STATE_BAM2BAM) == 0)
+		/* System mode */
+		acked_offset = pipe->sys.acked_offset;
+	else
+		/* BAM-to-BAM */
+		acked_offset = bam_pipe_get_desc_write_offset(dev->base,
+							  pipe_index);
+
+
+	/* Determine descriptor FIFO state */
+	if (end_offset == acked_offset)
+		*empty = true;
+	else
+		*empty = false;
+
+	return 0;
+}
+
+/**
+ * Get number of free slots in a BAM pipe descriptor FIFO
+ *
+ */
+int sps_bam_get_free_count(struct sps_bam *dev, u32 pipe_index,
+				 u32 *count)
+{
+	struct sps_pipe *pipe = dev->pipes[pipe_index];
+	u32 next_write;
+	u32 free;
+
+	/* Is this a BAM-to-BAM or satellite connection? */
+	if ((pipe->state & (BAM_STATE_BAM2BAM | BAM_STATE_REMOTE))) {
+		SPS_ERR("Free count on BAM-to-BAM or remote: BAM 0x%x pipe %d",
+			BAM_ID(dev), pipe_index);
+		*count = 0;
+		return SPS_ERROR;
+	}
+
+	/* Determine descriptor FIFO state */
+	next_write = pipe->sys.desc_offset + sizeof(struct sps_iovec);
+	if (next_write >= pipe->desc_size)
+		next_write = 0;
+
+	if (pipe->sys.acked_offset >= next_write)
+		free = pipe->sys.acked_offset - next_write;
+	else
+		free = pipe->desc_size - next_write + pipe->sys.acked_offset;
+
+	free /= sizeof(struct sps_iovec);
+	*count = free;
+
+	return 0;
+}
+
+/**
+ * Set BAM pipe to satellite ownership
+ *
+ */
+int sps_bam_set_satellite(struct sps_bam *dev, u32 pipe_index)
+{
+	struct sps_pipe *pipe = dev->pipes[pipe_index];
+
+	/*
+	 * Switch to satellite control is only supported on processor
+	 * that controls the BAM global config on multi-EE BAMs
+	 */
+	if ((dev->props.manage & SPS_BAM_MGR_MULTI_EE) == 0 ||
+	    (dev->props.manage & SPS_BAM_MGR_DEVICE_REMOTE)) {
+		SPS_ERR("Cannot grant satellite control to BAM 0x%x pipe %d",
+			BAM_ID(dev), pipe_index);
+		return SPS_ERROR;
+	}
+
+	/* Is this pipe locally controlled? */
+	if ((dev->pipe_active_mask & (1UL << pipe_index)) == 0) {
+		SPS_ERR("BAM 0x%x pipe %d not local and active",
+			BAM_ID(dev), pipe_index);
+		return SPS_ERROR;
+	}
+
+	/* Disable local interrupts for this pipe */
+	if (!pipe->polled)
+		bam_pipe_set_irq(dev->base, pipe_index, BAM_DISABLE,
+					 pipe->irq_mask, dev->props.ee);
+
+	if (BAM_VERSION_MTI_SUPPORT(dev->version)) {
+		/*
+		 * Set pipe to MTI interrupt mode.
+		 * Must be performed after IRQ disable,
+		 * because it is necessary to re-enable the IRQ to enable
+		 * MTI generation.
+		 * Set both pipe IRQ mask and MTI dest address to zero.
+		 */
+		if ((pipe->state & BAM_STATE_MTI) == 0 || pipe->polled) {
+			bam_pipe_satellite_mti(dev->base, pipe_index, 0,
+						       dev->props.ee);
+			pipe->state |= BAM_STATE_MTI;
+		}
+	}
+
+	/* Indicate satellite control */
+	list_del(&pipe->list);
+	dev->pipe_active_mask &= ~(1UL << pipe_index);
+	dev->pipe_remote_mask |= pipe->pipe_index_mask;
+	pipe->state |= BAM_STATE_REMOTE;
+
+	return 0;
+}
+
+/**
+ * Perform BAM pipe timer control
+ *
+ */
+int sps_bam_pipe_timer_ctrl(struct sps_bam *dev,
+			    u32 pipe_index,
+			    struct sps_timer_ctrl *timer_ctrl,
+			    struct sps_timer_result *timer_result)
+{
+	enum bam_pipe_timer_mode mode;
+	int result = 0;
+
+	/* Is this pipe locally controlled? */
+	if ((dev->pipe_active_mask & (1UL << pipe_index)) == 0) {
+		SPS_ERR("BAM 0x%x pipe %d not local and active",
+			BAM_ID(dev), pipe_index);
+		return SPS_ERROR;
+	}
+
+	/* Perform the timer operation */
+	switch (timer_ctrl->op) {
+	case SPS_TIMER_OP_CONFIG:
+		mode = (timer_ctrl->mode == SPS_TIMER_MODE_ONESHOT) ?
+			BAM_PIPE_TIMER_ONESHOT :
+			BAM_PIPE_TIMER_PERIODIC;
+		bam_pipe_timer_config(dev->base, pipe_index, mode,
+				    timer_ctrl->timeout_msec * 10);
+		break;
+	case SPS_TIMER_OP_RESET:
+		bam_pipe_timer_reset(dev->base, pipe_index);
+		break;
+	case SPS_TIMER_OP_READ:
+		break;
+	default:
+		result = SPS_ERROR;
+		break;
+	}
+
+	/* Provide the current timer value */
+	if (timer_result != NULL)
+		timer_result->current_timer =
+			bam_pipe_timer_get_count(dev->base, pipe_index);
+
+	return result;
+}
+
diff --git a/arch/arm/mach-msm/sps/sps_bam.h b/arch/arm/mach-msm/sps/sps_bam.h
new file mode 100644
index 0000000..f09948e
--- /dev/null
+++ b/arch/arm/mach-msm/sps/sps_bam.h
@@ -0,0 +1,547 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/*
+ * Function and data structure declarations for SPS BAM handling.
+ */
+
+
+#ifndef _SPSBAM_H_
+#define _SPSBAM_H_
+
+#include <linux/types.h>
+#include <linux/completion.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+
+#include "spsi.h"
+
+#define BAM_MAX_PIPES              31
+#define BAM_HANDLE_INVALID         0
+
+enum bam_irq {
+	BAM_DEV_IRQ_RDY_TO_SLEEP = 0x00000001,
+	BAM_DEV_IRQ_HRESP_ERROR = 0x00000002,
+	BAM_DEV_IRQ_ERROR = 0x00000004,
+};
+
+/* Pipe interrupt mask */
+enum bam_pipe_irq {
+	/* BAM finishes descriptor which has INT bit selected */
+	BAM_PIPE_IRQ_DESC_INT = 0x00000001,
+	/* Inactivity timer Expires */
+	BAM_PIPE_IRQ_TIMER = 0x00000002,
+	/* Wakeup peripheral (i.e. USB) */
+	BAM_PIPE_IRQ_WAKE = 0x00000004,
+	/* Producer - no free space for adding a descriptor */
+	/* Consumer - no descriptors for processing */
+	BAM_PIPE_IRQ_OUT_OF_DESC = 0x00000008,
+	/* Pipe Error interrupt */
+	BAM_PIPE_IRQ_ERROR = 0x00000010,
+	/* End-Of-Transfer */
+	BAM_PIPE_IRQ_EOT = 0x00000020,
+};
+
+/* Halt Type */
+enum bam_halt {
+	BAM_HALT_OFF = 0,
+	BAM_HALT_ON = 1,
+};
+
+/* Threshold values of the DMA channels */
+enum bam_dma_thresh_dma {
+	BAM_DMA_THRESH_512 = 0x3,
+	BAM_DMA_THRESH_256 = 0x2,
+	BAM_DMA_THRESH_128 = 0x1,
+	BAM_DMA_THRESH_64 = 0x0,
+};
+
+/* Weight values of the DMA channels */
+enum bam_dma_weight_dma {
+	BAM_DMA_WEIGHT_HIGH = 7,
+	BAM_DMA_WEIGHT_MED = 3,
+	BAM_DMA_WEIGHT_LOW = 1,
+	BAM_DMA_WEIGHT_DEFAULT = BAM_DMA_WEIGHT_LOW,
+	BAM_DMA_WEIGHT_DISABLE = 0,
+};
+
+
+/* Invalid pipe index value */
+#define SPS_BAM_PIPE_INVALID  ((u32)(-1))
+
+/* Parameters for sps_bam_pipe_connect() */
+struct sps_bam_connect_param {
+	/* which end point must be initialized */
+	enum sps_mode mode;
+
+	/* OR'd connection end point options (see SPS_O defines) */
+	u32 options;
+
+	/* SETPEND/MTI interrupt generation parameters */
+	u32 irq_gen_addr;
+	u32 irq_gen_data;
+
+};
+
+/* Event registration struct */
+struct sps_bam_event_reg {
+	/* Client's event object handle */
+	struct completion *xfer_done;
+	void (*callback)(struct sps_event_notify *notify);
+
+	/* Event trigger mode */
+	enum sps_trigger mode;
+
+	/* User pointer that will be provided in event payload data */
+	void *user;
+
+};
+
+/* Descriptor FIFO cache entry */
+struct sps_bam_desc_cache {
+	struct sps_iovec iovec;
+	void *user; /* User pointer registered with this transfer */
+};
+
+/* Forward declaration */
+struct sps_bam;
+
+/* System mode control */
+struct sps_bam_sys_mode {
+	/* Descriptor FIFO control */
+	u8 *desc_buf; /* Descriptor FIFO for BAM pipe */
+	u32 desc_offset; /* Next new descriptor to be written to hardware */
+	u32 acked_offset; /* Next descriptor to be retired by software */
+
+	/* Descriptor cache control (!no_queue only) */
+	u8 *desc_cache; /* Software cache of descriptor FIFO contents */
+	u32 cache_offset; /* Next descriptor to be cached (ack_xfers only) */
+
+	/* User pointers associated with cached descriptors */
+	void **user_ptrs;
+
+	/* Event handling */
+	struct sps_bam_event_reg event_regs[SPS_EVENT_INDEX(SPS_EVENT_MAX)];
+	struct list_head events_q;
+
+	struct sps_q_event event;	/* Temp storage for event creation */
+	int no_queue;	/* Whether events are queued */
+	int ack_xfers;	/* Whether client must ACK all descriptors */
+	int handler_eot; /* Whether EOT handling is in progress (debug) */
+
+	/* Statistics */
+#ifdef SPS_BAM_STATISTICS
+	u32 desc_wr_count;
+	u32 desc_rd_count;
+	u32 user_ptrs_count;
+	u32 user_found;
+	u32 int_flags;
+	u32 eot_flags;
+	u32 callback_events;
+	u32 wait_events;
+	u32 queued_events;
+	u32 get_events;
+	u32 get_iovecs;
+#endif /* SPS_BAM_STATISTICS */
+};
+
+/* BAM pipe descriptor */
+struct sps_pipe {
+	struct list_head list;
+
+	/* Client state */
+	u32 client_state;
+	struct sps_bam *bam;
+	struct sps_connect connect;
+	const struct sps_connection *map;
+
+	/* Pipe parameters */
+	u32 state;
+	u32 pipe_index;
+	u32 pipe_index_mask;
+	u32 irq_mask;
+	int polled;
+	u32 irq_gen_addr;
+	enum sps_mode mode;
+	u32 num_descs; /* Size (number of elements) of descriptor FIFO */
+	u32 desc_size; /* Size (bytes) of descriptor FIFO */
+	int wake_up_is_one_shot; /* Whether WAKEUP event is a one-shot or not */
+
+	/* System mode control */
+	struct sps_bam_sys_mode sys;
+
+};
+
+/* BAM device descriptor */
+struct sps_bam {
+	struct list_head list;
+
+	/* BAM device properties, including connection defaults */
+	struct sps_bam_props props;
+
+	/* BAM device state */
+	u32 state;
+	struct mutex lock;
+	void *base; /* BAM virtual base address */
+	u32 version;
+	spinlock_t isr_lock;
+
+	/* Pipe state */
+	u32 pipe_active_mask;
+	u32 pipe_remote_mask;
+	struct sps_pipe *pipes[BAM_MAX_PIPES];
+	struct list_head pipes_q;
+
+	/* Statistics */
+	u32 irq_from_disabled_pipe;
+	u32 event_trigger_failures;
+
+};
+
+/**
+ * BAM driver initialization
+ *
+ * This function initializes the BAM driver.
+ *
+ * @options - driver options bitflags (see SPS_OPT_*)
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_driver_init(u32 options);
+
+/**
+ * BAM device initialization
+ *
+ * This function initializes a BAM device.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_device_init(struct sps_bam *dev);
+
+/**
+ * BAM device de-initialization
+ *
+ * This function de-initializes a BAM device.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_device_de_init(struct sps_bam *dev);
+
+/**
+ * BAM device reset
+ *
+ * This Function resets a BAM device.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_reset(struct sps_bam *dev);
+
+/**
+ * BAM device enable
+ *
+ * This function enables a BAM device.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_enable(struct sps_bam *dev);
+
+/**
+ * BAM device disable
+ *
+ * This Function disables a BAM device.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_disable(struct sps_bam *dev);
+
+/**
+ * Allocate a BAM pipe
+ *
+ * This function allocates a BAM pipe.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - client-specified pipe index, or SPS_BAM_PIPE_INVALID if
+ *    any available pipe is acceptable
+ *
+ * @return - allocated pipe index, or SPS_BAM_PIPE_INVALID on error
+ *
+ */
+u32 sps_bam_pipe_alloc(struct sps_bam *dev, u32 pipe_index);
+
+/**
+ * Free a BAM pipe
+ *
+ * This function frees a BAM pipe.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ */
+void sps_bam_pipe_free(struct sps_bam *dev, u32 pipe_index);
+
+/**
+ * Establish BAM pipe connection
+ *
+ * This function establishes a connection for a BAM pipe (end point).
+ *
+ * @client - pointer to client pipe state struct
+ *
+ * @params - connection parameters
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_pipe_connect(struct sps_pipe *client,
+			const struct sps_bam_connect_param *params);
+
+/**
+ * Disconnect a BAM pipe connection
+ *
+ * This function disconnects a connection for a BAM pipe (end point).
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_pipe_disconnect(struct sps_bam *dev, u32 pipe_index);
+
+/**
+ * Set BAM pipe parameters
+ *
+ * This function sets parameters for a BAM pipe.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @options - bitflag options (see SPS_O_*)
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_pipe_set_params(struct sps_bam *dev, u32 pipe_index, u32 options);
+
+/**
+ * Enable a BAM pipe
+ *
+ * This function enables a BAM pipe.  Note that this function
+ *    is separate from the pipe connect function to allow proper
+ *    sequencing of consumer enable followed by producer enable.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_pipe_enable(struct sps_bam *dev, u32 pipe_index);
+
+/**
+ * Disable a BAM pipe
+ *
+ * This function disables a BAM pipe.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_pipe_disable(struct sps_bam *dev, u32 pipe_index);
+
+/**
+ * Register an event for a BAM pipe
+ *
+ * This function registers an event for a BAM pipe.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @reg - pointer to event registration struct
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_pipe_reg_event(struct sps_bam *dev, u32 pipe_index,
+			   struct sps_register_event *reg);
+
+/**
+ * Submit a transfer of a single buffer to a BAM pipe
+ *
+ * This function submits a transfer of a single buffer to a BAM pipe.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @addr - physical address of buffer to transfer
+ *
+ * @size - number of bytes to transfer
+ *
+ * @user - user pointer to register for event
+ *
+ * @flags - descriptor flags (see SPS_IOVEC_FLAG defines)
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_pipe_transfer_one(struct sps_bam *dev, u32 pipe_index, u32 addr,
+			      u32 size, void *user, u32 flags);
+
+/**
+ * Submit a transfer to a BAM pipe
+ *
+ * This function submits a transfer to a BAM pipe.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @transfer - pointer to transfer struct
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_pipe_transfer(struct sps_bam *dev, u32 pipe_index,
+			 struct sps_transfer *transfer);
+
+/**
+ * Get a BAM pipe event
+ *
+ * This function polls for a BAM pipe event.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @notify - pointer to event notification struct
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_pipe_get_event(struct sps_bam *dev, u32 pipe_index,
+			   struct sps_event_notify *notify);
+
+/**
+ * Get processed I/O vector
+ *
+ * This function fetches the next processed I/O vector.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @iovec - Pointer to I/O vector struct (output).
+ *   This struct will be zeroed if there are no more processed I/O vectors.
+ *
+ * @return 0 on success, negative value on error
+ */
+int sps_bam_pipe_get_iovec(struct sps_bam *dev, u32 pipe_index,
+			   struct sps_iovec *iovec);
+
+/**
+ * Determine whether a BAM pipe descriptor FIFO is empty
+ *
+ * This function returns the empty state of a BAM pipe descriptor FIFO.
+ *
+ * The pipe mutex must be locked before calling this function.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @empty - pointer to client's empty status word (boolean)
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_pipe_is_empty(struct sps_bam *dev, u32 pipe_index, u32 *empty);
+
+/**
+ * Get number of free slots in a BAM pipe descriptor FIFO
+ *
+ * This function returns the number of free slots in a BAM pipe descriptor FIFO.
+ *
+ * The pipe mutex must be locked before calling this function.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @count - pointer to count status
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_get_free_count(struct sps_bam *dev, u32 pipe_index, u32 *count);
+
+/**
+ * Set BAM pipe to satellite ownership
+ *
+ * This function sets the BAM pipe to satellite ownership.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_set_satellite(struct sps_bam *dev, u32 pipe_index);
+
+/**
+ * Perform BAM pipe timer control
+ *
+ * This function performs BAM pipe timer control operations.
+ *
+ * @dev - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @timer_ctrl - Pointer to timer control specification
+ *
+ * @timer_result - Pointer to buffer for timer operation result.
+ *    This argument can be NULL if no result is expected for the operation.
+ *    If non-NULL, the current timer value will always provided.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_bam_pipe_timer_ctrl(struct sps_bam *dev, u32 pipe_index,
+			    struct sps_timer_ctrl *timer_ctrl,
+			    struct sps_timer_result *timer_result);
+#endif	/* _SPSBAM_H_ */
diff --git a/arch/arm/mach-msm/sps/sps_core.h b/arch/arm/mach-msm/sps/sps_core.h
new file mode 100644
index 0000000..5bd7c65
--- /dev/null
+++ b/arch/arm/mach-msm/sps/sps_core.h
@@ -0,0 +1,107 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/*
+ * Function and data structure declarations.
+ */
+
+#ifndef _SPS_CORE_H_
+#define _SPS_CORE_H_
+
+#include <linux/types.h>	/* u32 */
+#include <linux/mutex.h>	/* mutex */
+#include <linux/list.h>		/* list_head */
+
+#include "spsi.h"
+#include "sps_bam.h"
+
+/* Connection state definitions */
+#define SPS_STATE_DEF(x)   ('S' | ('P' << 8) | ('S' << 16) | ((x) << 24))
+#define IS_SPS_STATE_OK(x) \
+	(((x)->client_state & 0x00ffffff) == SPS_STATE_DEF(0))
+
+/* Configuration indicating satellite connection */
+#define SPS_CONFIG_SATELLITE  0x11111111
+
+/* Client connection state */
+#define SPS_STATE_DISCONNECT  0
+#define SPS_STATE_ALLOCATE    SPS_STATE_DEF(1)
+#define SPS_STATE_CONNECT     SPS_STATE_DEF(2)
+#define SPS_STATE_ENABLE      SPS_STATE_DEF(3)
+#define SPS_STATE_DISABLE     SPS_STATE_DEF(4)
+
+/* Connection mapping control struct */
+struct sps_rm {
+	struct list_head connections_q;
+	struct mutex lock;
+};
+
+/**
+ * Find the BAM device from the handle
+ *
+ * This function finds a BAM device in the BAM registration list that
+ * matches the specified device handle.
+ *
+ * @h - device handle of the BAM
+ *
+ * @return - pointer to the BAM device struct, or NULL on error
+ *
+ */
+struct sps_bam *sps_h2bam(u32 h);
+
+/**
+ * Initialize resource manager module
+ *
+ * This function initializes the resource manager module.
+ *
+ * @rm - pointer to resource manager struct
+ *
+ * @options - driver options bitflags (see SPS_OPT_*)
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_rm_init(struct sps_rm *rm, u32 options);
+
+/**
+ * De-initialize resource manager module
+ *
+ * This function de-initializes the resource manager module.
+ *
+ */
+void sps_rm_de_init(void);
+
+/**
+ * Initialize client state context
+ *
+ * This function initializes a client state context struct.
+ *
+ * @connect - pointer to client connection state struct
+ *
+ */
+void sps_rm_config_init(struct sps_connect *connect);
+
+/**
+ * Process connection state change
+ *
+ * This function processes a connection state change.
+ *
+ * @pipe - pointer to pipe context
+ *
+ * @state - new state for connection
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_rm_state_change(struct sps_pipe *pipe, u32 state);
+
+#endif				/* _SPS_CORE_H_ */
diff --git a/arch/arm/mach-msm/sps/sps_dma.c b/arch/arm/mach-msm/sps/sps_dma.c
new file mode 100644
index 0000000..9179ed9
--- /dev/null
+++ b/arch/arm/mach-msm/sps/sps_dma.c
@@ -0,0 +1,896 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* BAM-DMA Manager. */
+
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+
+#include <linux/memory.h>	/* memset */
+
+#include "spsi.h"
+#include "bam.h"
+#include "sps_bam.h"		/* bam_dma_thresh_dma */
+#include "sps_core.h"		/* sps_h2bam() */
+
+/**
+ * registers
+ */
+
+#define DMA_ENBL			(0x00000000)
+#define DMA_CHNL_CONFIG(n)		(0x00000004 + 4 * (n))
+#define DMA_CONFIG			(0x00000040)
+
+/**
+ * masks
+ */
+
+/* DMA_CHNL_confign */
+#define DMA_CHNL_HALT_DONE		0x10000
+#define DMA_CHNL_HALT			0x1000
+#define DMA_CHNL_ENABLE                 0x100
+#define DMA_CHNL_ACT_THRESH             0x30
+#define DMA_CHNL_WEIGHT                 0x7
+
+/* DMA_CONFIG */
+#define TESTBUS_SELECT                  0x3
+
+/**
+ *
+ * Write register with debug info.
+ *
+ * @base - bam base virtual address.
+ * @offset - register offset.
+ * @val - value to write.
+ *
+ */
+static inline void dma_write_reg(void *base, u32 offset, u32 val)
+{
+	iowrite32(val, base + offset);
+	SPS_DBG("bamdma: write reg 0x%x w_val 0x%x.", offset, val);
+}
+
+/**
+ * Write register masked field with debug info.
+ *
+ * @base - bam base virtual address.
+ * @offset - register offset.
+ * @mask - register bitmask.
+ * @val - value to write.
+ *
+ */
+static inline void dma_write_reg_field(void *base, u32 offset,
+				       const u32 mask, u32 val)
+{
+	u32 shift = find_first_bit((void *)&mask, 32);
+	u32 tmp = ioread32(base + offset);
+
+	tmp &= ~mask;		/* clear written bits */
+	val = tmp | (val << shift);
+	iowrite32(val, base + offset);
+	SPS_DBG("bamdma: write reg 0x%x w_val 0x%x.", offset, val);
+}
+
+/* Round max number of pipes to nearest multiple of 2 */
+#define DMA_MAX_PIPES         ((BAM_MAX_PIPES / 2) * 2)
+
+/* Maximum number of BAM-DMAs supported */
+#define MAX_BAM_DMA_DEVICES   1
+
+/* Maximum number of BAMs that will be registered */
+#define MAX_BAM_DMA_BAMS      1
+
+/* Pipe enable check values */
+#define DMA_PIPES_STATE_DIFF     0
+#define DMA_PIPES_BOTH_DISABLED  1
+#define DMA_PIPES_BOTH_ENABLED   2
+
+/* Even pipe is tx/dest/input/write, odd pipe is rx/src/output/read */
+#define DMA_PIPE_IS_DEST(p)   (((p) & 1) == 0)
+#define DMA_PIPE_IS_SRC(p)    (((p) & 1) != 0)
+
+/* BAM DMA pipe state */
+enum bamdma_pipe_state {
+	PIPE_INACTIVE = 0,
+	PIPE_ACTIVE
+};
+
+/* BAM DMA channel state */
+enum bamdma_chan_state {
+	DMA_CHAN_STATE_FREE = 0,
+	DMA_CHAN_STATE_ALLOC_EXT,	/* Client allocation */
+	DMA_CHAN_STATE_ALLOC_INT	/* Internal (resource mgr) allocation */
+};
+
+struct bamdma_chan {
+	/* Allocation state */
+	enum bamdma_chan_state state;
+
+	/* BAM DMA channel configuration parameters */
+	u32 threshold;
+	enum sps_dma_priority priority;
+
+	/* HWIO channel configuration parameters */
+	enum bam_dma_thresh_dma thresh;
+	enum bam_dma_weight_dma weight;
+
+};
+
+/* BAM DMA device state */
+struct bamdma_device {
+	/* BAM-DMA device state */
+	int enabled;
+	int local;
+
+	/* BAM device state */
+	struct sps_bam *bam;
+
+	/* BAM handle, for deregistration */
+	u32 h;
+
+	/* BAM DMA device virtual mapping */
+	void *virt_addr;
+	int virtual_mapped;
+	u32 phys_addr;
+	void *hwio;
+
+	/* BAM DMA pipe/channel state */
+	u32 num_pipes;
+	enum bamdma_pipe_state pipes[DMA_MAX_PIPES];
+	struct bamdma_chan chans[DMA_MAX_PIPES / 2];
+
+};
+
+/* BAM-DMA devices */
+static struct bamdma_device bam_dma_dev[MAX_BAM_DMA_DEVICES];
+static struct mutex bam_dma_lock;
+
+/*
+ * The BAM DMA module registers all BAMs in the BSP properties, but only
+ * uses the first BAM-DMA device for allocations.  References to the others
+ * are stored in the following data array.
+ */
+static int num_bams;
+static u32 bam_handles[MAX_BAM_DMA_BAMS];
+
+/**
+ * Find BAM-DMA device
+ *
+ * This function finds the BAM-DMA device associated with the BAM handle.
+ *
+ * @h - BAM handle
+ *
+ * @return - pointer to BAM-DMA device, or NULL on error
+ *
+ */
+static struct bamdma_device *sps_dma_find_device(u32 h)
+{
+	return &bam_dma_dev[0];
+}
+
+/**
+ * BAM DMA device enable
+ *
+ * This function enables a BAM DMA device and the associated BAM.
+ *
+ * @dev - pointer to BAM DMA device context
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+static int sps_dma_device_enable(struct bamdma_device *dev)
+{
+	if (dev->enabled)
+		return 0;
+
+	/*
+	 *  If the BAM-DMA device is locally controlled then enable BAM-DMA
+	 *  device
+	 */
+	if (dev->local)
+		dma_write_reg(dev->virt_addr, DMA_ENBL, 1);
+
+	/* Enable BAM device */
+	if (sps_bam_enable(dev->bam)) {
+		SPS_ERR("Failed to enable BAM DMA's BAM: %x", dev->phys_addr);
+		return SPS_ERROR;
+	}
+
+	dev->enabled = true;
+
+	return 0;
+}
+
+/**
+ * BAM DMA device enable
+ *
+ * This function initializes a BAM DMA device.
+ *
+ * @dev - pointer to BAM DMA device context
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+static int sps_dma_device_disable(struct bamdma_device *dev)
+{
+	u32 pipe_index;
+
+	if (!dev->enabled)
+		return 0;
+
+	/* Do not disable if channels active */
+	for (pipe_index = 0; pipe_index < dev->num_pipes; pipe_index++) {
+		if (dev->pipes[pipe_index] != PIPE_INACTIVE)
+			break;
+	}
+
+	if (pipe_index < dev->num_pipes) {
+		SPS_ERR("Failed to disable BAM-DMA %x: channels are active",
+			dev->phys_addr);
+		return SPS_ERROR;
+	}
+
+	dev->enabled = false;
+
+	/* Disable BAM device */
+	if (sps_bam_disable(dev->bam)) {
+		SPS_ERR("Failed to disable BAM-DMA %x BAM", dev->phys_addr);
+		return SPS_ERROR;
+	}
+
+	/* Is the BAM-DMA device locally controlled? */
+	if (dev->local)
+		/* Disable BAM-DMA device */
+		dma_write_reg(dev->virt_addr, DMA_ENBL, 0);
+
+	return 0;
+}
+
+/**
+ * Initialize BAM DMA device
+ *
+ */
+int sps_dma_device_init(u32 h)
+{
+	struct bamdma_device *dev;
+	struct sps_bam_props *props;
+	u32 chan;
+	int result = SPS_ERROR;
+
+	mutex_lock(&bam_dma_lock);
+
+	/* Find a free BAM-DMA device slot */
+	dev = NULL;
+	if (bam_dma_dev[0].bam != NULL) {
+		SPS_ERR("BAM-DMA BAM device already initialized.");
+		goto exit_err;
+	} else {
+		dev = &bam_dma_dev[0];
+	}
+
+	/* Record BAM */
+	memset(dev, 0, sizeof(*dev));
+	dev->h = h;
+	dev->bam = sps_h2bam(h);
+
+	/* Map the BAM DMA device into virtual space, if necessary */
+	props = &dev->bam->props;
+	dev->phys_addr = props->periph_phys_addr;
+	if (props->periph_virt_addr != NULL) {
+		dev->virt_addr = props->periph_virt_addr;
+		dev->virtual_mapped = false;
+	} else {
+		if (props->periph_virt_size == 0) {
+			SPS_ERR("Unable to map BAM DMA IO memory: %x %x",
+			 dev->phys_addr, props->periph_virt_size);
+			goto exit_err;
+		}
+
+		dev->virt_addr = ioremap(dev->phys_addr,
+					  props->periph_virt_size);
+		if (dev->virt_addr == NULL) {
+			SPS_ERR("Unable to map BAM DMA IO memory: %x %x",
+				dev->phys_addr, props->periph_virt_size);
+			goto exit_err;
+		}
+		dev->virtual_mapped = true;
+	}
+	dev->hwio = (void *) dev->virt_addr;
+
+	/* Is the BAM-DMA device locally controlled? */
+	if ((props->manage & SPS_BAM_MGR_DEVICE_REMOTE) == 0) {
+		SPS_DBG("BAM-DMA is controlled locally: %x",
+			dev->phys_addr);
+		dev->local = true;
+	} else {
+		SPS_DBG("BAM-DMA is controlled remotely: %x",
+			dev->phys_addr);
+		dev->local = false;
+	}
+
+	/*
+	 * Enable the BAM DMA and determine the number of pipes/channels.
+	 * Leave the BAM-DMA enabled, since it is always a shared device.
+	 */
+	if (sps_dma_device_enable(dev))
+		goto exit_err;
+
+	dev->num_pipes = dev->bam->props.num_pipes;
+
+	/* Disable all channels */
+	if (dev->local)
+		for (chan = 0; chan < (dev->num_pipes / 2); chan++) {
+			dma_write_reg_field(dev->virt_addr,
+					    DMA_CHNL_CONFIG(chan),
+					    DMA_CHNL_ENABLE, 0);
+		}
+
+	result = 0;
+exit_err:
+	if (result) {
+		if (dev != NULL) {
+			if (dev->virtual_mapped)
+				iounmap(dev->virt_addr);
+
+			dev->bam = NULL;
+		}
+	}
+
+	mutex_unlock(&bam_dma_lock);
+
+	return result;
+}
+
+/**
+ * De-initialize BAM DMA device
+ *
+ */
+int sps_dma_device_de_init(u32 h)
+{
+	struct bamdma_device *dev;
+	u32 pipe_index;
+	u32 chan;
+	int result = 0;
+
+	mutex_lock(&bam_dma_lock);
+
+	dev = sps_dma_find_device(h);
+	if (dev == NULL) {
+		SPS_ERR("BAM-DMA: not registered: %x", h);
+		result = SPS_ERROR;
+		goto exit_err;
+	}
+
+	/* Check for channel leaks */
+	for (chan = 0; chan < dev->num_pipes / 2; chan++) {
+		if (dev->chans[chan].state != DMA_CHAN_STATE_FREE) {
+			SPS_ERR("BAM-DMA: channel not free: %d", chan);
+			result = SPS_ERROR;
+			dev->chans[chan].state = DMA_CHAN_STATE_FREE;
+		}
+	}
+	for (pipe_index = 0; pipe_index < dev->num_pipes; pipe_index++) {
+		if (dev->pipes[pipe_index] != PIPE_INACTIVE) {
+			SPS_ERR("BAM-DMA: pipe not inactive: %d", pipe_index);
+			result = SPS_ERROR;
+			dev->pipes[pipe_index] = PIPE_INACTIVE;
+		}
+	}
+
+	/* Disable BAM and BAM-DMA */
+	if (sps_dma_device_disable(dev))
+		result = SPS_ERROR;
+
+	dev->h = BAM_HANDLE_INVALID;
+	dev->bam = NULL;
+	if (dev->virtual_mapped)
+		iounmap(dev->virt_addr);
+
+exit_err:
+	mutex_unlock(&bam_dma_lock);
+
+	return result;
+}
+
+/**
+ * Initialize BAM DMA module
+ *
+ */
+int sps_dma_init(const struct sps_bam_props *bam_props)
+{
+	struct sps_bam_props props;
+	const struct sps_bam_props *bam_reg;
+	u32 h;
+
+	/* Init local data */
+	memset(&bam_dma_dev, 0, sizeof(bam_dma_dev));
+	num_bams = 0;
+	memset(bam_handles, 0, sizeof(bam_handles));
+
+	/* Create a mutex to control access to the BAM-DMA devices */
+	mutex_init(&bam_dma_lock);
+
+	/* Are there any BAM DMA devices? */
+	if (bam_props == NULL)
+		return 0;
+
+	/*
+	 * Registers all BAMs in the BSP properties, but only uses the first
+	 * BAM-DMA device for allocations.
+	 */
+	if (bam_props->phys_addr) {
+		/* Force multi-EE option for all BAM-DMAs */
+		bam_reg = bam_props;
+		if ((bam_props->options & SPS_BAM_OPT_BAMDMA) &&
+		    (bam_props->manage & SPS_BAM_MGR_MULTI_EE) == 0) {
+			SPS_DBG("Setting multi-EE options for BAM-DMA: %x",
+				bam_props->phys_addr);
+			props = *bam_props;
+			props.manage |= SPS_BAM_MGR_MULTI_EE;
+			bam_reg = &props;
+		}
+
+		/* Register the BAM */
+		if (sps_register_bam_device(bam_reg, &h)) {
+			SPS_ERR("Failed to register BAM-DMA BAM device: "
+				"phys 0x%0x", bam_props->phys_addr);
+			return SPS_ERROR;
+		}
+
+		/* Record the BAM so that it may be deregistered later */
+		if (num_bams < MAX_BAM_DMA_BAMS) {
+			bam_handles[num_bams] = h;
+			num_bams++;
+		} else {
+			SPS_ERR("BAM-DMA: BAM limit exceeded: %d", num_bams);
+			return SPS_ERROR;
+		}
+	} else {
+		SPS_ERR("BAM-DMA phys_addr is zero.");
+		return SPS_ERROR;
+	}
+
+
+	return 0;
+}
+
+/**
+ * De-initialize BAM DMA module
+ *
+ */
+void sps_dma_de_init(void)
+{
+	int n;
+
+	/* De-initialize the BAM devices */
+	for (n = 0; n < num_bams; n++)
+		sps_deregister_bam_device(bam_handles[n]);
+
+	/* Clear local data */
+	memset(&bam_dma_dev, 0, sizeof(bam_dma_dev));
+	num_bams = 0;
+	memset(bam_handles, 0, sizeof(bam_handles));
+}
+
+/**
+ * Allocate a BAM DMA channel
+ *
+ */
+int sps_alloc_dma_chan(const struct sps_alloc_dma_chan *alloc,
+		       struct sps_dma_chan *chan_info)
+{
+	struct bamdma_device *dev;
+	struct bamdma_chan *chan;
+	u32 pipe_index;
+	enum bam_dma_thresh_dma thresh = (enum bam_dma_thresh_dma) 0;
+	enum bam_dma_weight_dma weight = (enum bam_dma_weight_dma) 0;
+	int result = SPS_ERROR;
+
+	if (alloc == NULL || chan_info == NULL) {
+		SPS_ERR("sps_alloc_dma_chan. invalid parameters");
+		return SPS_ERROR;
+	}
+
+	/* Translate threshold and priority to hwio values */
+	if (alloc->threshold != SPS_DMA_THRESHOLD_DEFAULT) {
+		if (alloc->threshold >= 512)
+			thresh = BAM_DMA_THRESH_512;
+		else if (alloc->threshold >= 256)
+			thresh = BAM_DMA_THRESH_256;
+		else if (alloc->threshold >= 128)
+			thresh = BAM_DMA_THRESH_128;
+		else
+			thresh = BAM_DMA_THRESH_64;
+	}
+
+	weight = alloc->priority;
+
+	if (alloc->priority > BAM_DMA_WEIGHT_HIGH) {
+		SPS_ERR("BAM-DMA: invalid priority: %x", alloc->priority);
+		return SPS_ERROR;
+	}
+
+	mutex_lock(&bam_dma_lock);
+
+	dev = sps_dma_find_device(alloc->dev);
+	if (dev == NULL) {
+		SPS_ERR("BAM-DMA: invalid BAM handle: %x", alloc->dev);
+		goto exit_err;
+	}
+
+	/* Search for a free set of pipes */
+	for (pipe_index = 0, chan = dev->chans;
+	      pipe_index < dev->num_pipes; pipe_index += 2, chan++) {
+		if (chan->state == DMA_CHAN_STATE_FREE) {
+			/* Just check pipes for safety */
+			if (dev->pipes[pipe_index] != PIPE_INACTIVE ||
+			    dev->pipes[pipe_index + 1] != PIPE_INACTIVE) {
+				SPS_ERR("BAM-DMA: channel %d state error:%d %d",
+					pipe_index / 2, dev->pipes[pipe_index],
+				 dev->pipes[pipe_index + 1]);
+				goto exit_err;
+			}
+			break; /* Found free pipe */
+		}
+	}
+
+	if (pipe_index >= dev->num_pipes) {
+		SPS_ERR("BAM-DMA: no free channel. num_pipes = %d",
+			dev->num_pipes);
+		goto exit_err;
+	}
+
+	chan->state = DMA_CHAN_STATE_ALLOC_EXT;
+
+	/* Store config values for use when pipes are activated */
+	chan = &dev->chans[pipe_index / 2];
+	chan->threshold = alloc->threshold;
+	chan->thresh = thresh;
+	chan->priority = alloc->priority;
+	chan->weight = weight;
+
+	SPS_DBG("sps_alloc_dma_chan. pipe %d.\n", pipe_index);
+
+	/* Report allocated pipes to client */
+	chan_info->dev = dev->h;
+	/* Dest/input/write pipex */
+	chan_info->dest_pipe_index = pipe_index;
+	/* Source/output/read pipe */
+	chan_info->src_pipe_index = pipe_index + 1;
+
+	result = 0;
+exit_err:
+	mutex_unlock(&bam_dma_lock);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_alloc_dma_chan);
+
+/**
+ * Free a BAM DMA channel
+ *
+ */
+int sps_free_dma_chan(struct sps_dma_chan *chan)
+{
+	struct bamdma_device *dev;
+	u32 pipe_index;
+	int result = 0;
+
+	if (chan == NULL) {
+		SPS_ERR("sps_free_dma_chan. chan is NULL");
+		return SPS_ERROR;
+	}
+
+	mutex_lock(&bam_dma_lock);
+
+	dev = sps_dma_find_device(chan->dev);
+	if (dev == NULL) {
+		SPS_ERR("BAM-DMA: invalid BAM handle: %x", chan->dev);
+		result = SPS_ERROR;
+		goto exit_err;
+	}
+
+	/* Verify the pipe indices */
+	pipe_index = chan->dest_pipe_index;
+	if (pipe_index >= dev->num_pipes || ((pipe_index & 1)) ||
+	    (pipe_index + 1) != chan->src_pipe_index) {
+		SPS_ERR("sps_free_dma_chan. Invalid pipe indices");
+		SPS_DBG("num_pipes=%d.dest=%d.src=%d.",
+			dev->num_pipes,
+			chan->dest_pipe_index,
+			chan->src_pipe_index);
+		result = SPS_ERROR;
+		goto exit_err;
+	}
+
+	/* Are both pipes inactive? */
+	if (dev->chans[pipe_index / 2].state != DMA_CHAN_STATE_ALLOC_EXT ||
+	    dev->pipes[pipe_index] != PIPE_INACTIVE ||
+	    dev->pipes[pipe_index + 1] != PIPE_INACTIVE) {
+		SPS_ERR("BAM-DMA: attempt to free active chan %d: %d %d",
+			pipe_index / 2, dev->pipes[pipe_index],
+			dev->pipes[pipe_index + 1]);
+		result = SPS_ERROR;
+		goto exit_err;
+	}
+
+	/* Free the channel */
+	dev->chans[pipe_index / 2].state = DMA_CHAN_STATE_FREE;
+
+exit_err:
+	mutex_unlock(&bam_dma_lock);
+
+	return result;
+}
+EXPORT_SYMBOL(sps_free_dma_chan);
+
+/**
+ * Activate a BAM DMA pipe
+ *
+ * This function activates a BAM DMA pipe.
+ *
+ * @dev - pointer to BAM-DMA device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+static u32 sps_dma_check_pipes(struct bamdma_device *dev, u32 pipe_index)
+{
+	u32 pipe_in;
+	u32 pipe_out;
+	int enabled_in;
+	int enabled_out;
+	u32 check;
+
+	pipe_in = pipe_index & ~1;
+	pipe_out = pipe_in + 1;
+	enabled_in = bam_pipe_is_enabled(dev->bam->base, pipe_in);
+	enabled_out = bam_pipe_is_enabled(dev->bam->base, pipe_out);
+
+	if (!enabled_in && !enabled_out)
+		check = DMA_PIPES_BOTH_DISABLED;
+	else if (enabled_in && enabled_out)
+		check = DMA_PIPES_BOTH_ENABLED;
+	else
+		check = DMA_PIPES_STATE_DIFF;
+
+	return check;
+}
+
+/**
+ * Allocate a BAM DMA pipe
+ *
+ */
+int sps_dma_pipe_alloc(void *bam_arg, u32 pipe_index, enum sps_mode dir)
+{
+	struct sps_bam *bam = bam_arg;
+	struct bamdma_device *dev;
+	struct bamdma_chan *chan;
+	u32 channel;
+	int result = SPS_ERROR;
+
+	if (bam == NULL) {
+		SPS_ERR("BAM context is NULL");
+		return SPS_ERROR;
+	}
+
+	/* Check pipe direction */
+	if ((DMA_PIPE_IS_DEST(pipe_index) && dir != SPS_MODE_DEST) ||
+	    (DMA_PIPE_IS_SRC(pipe_index) && dir != SPS_MODE_SRC)) {
+		SPS_ERR("BAM-DMA: wrong direction for BAM %x pipe %d",
+			bam->props.phys_addr, pipe_index);
+		return SPS_ERROR;
+	}
+
+	mutex_lock(&bam_dma_lock);
+
+	dev = sps_dma_find_device((u32) bam);
+	if (dev == NULL) {
+		SPS_ERR("BAM-DMA: invalid BAM: %x",
+			bam->props.phys_addr);
+		goto exit_err;
+	}
+	if (pipe_index >= dev->num_pipes) {
+		SPS_ERR("BAM-DMA: BAM %x invalid pipe: %d",
+			bam->props.phys_addr, pipe_index);
+		goto exit_err;
+	}
+	if (dev->pipes[pipe_index] != PIPE_INACTIVE) {
+		SPS_ERR("BAM-DMA: BAM %x pipe %d already active",
+			bam->props.phys_addr, pipe_index);
+		goto exit_err;
+	}
+
+	/* Mark pipe active */
+	dev->pipes[pipe_index] = PIPE_ACTIVE;
+
+	/* If channel is not allocated, make an internal allocation */
+	channel = pipe_index / 2;
+	chan = &dev->chans[channel];
+	if (chan->state != DMA_CHAN_STATE_ALLOC_EXT &&
+	    chan->state != DMA_CHAN_STATE_ALLOC_INT) {
+		chan->state = DMA_CHAN_STATE_ALLOC_INT;
+	}
+
+	result = 0;
+exit_err:
+	mutex_unlock(&bam_dma_lock);
+
+	return result;
+}
+
+/**
+ * Enable a BAM DMA pipe
+ *
+ */
+int sps_dma_pipe_enable(void *bam_arg, u32 pipe_index)
+{
+	struct sps_bam *bam = bam_arg;
+	struct bamdma_device *dev;
+	struct bamdma_chan *chan;
+	u32 channel;
+	int result = SPS_ERROR;
+
+	SPS_DBG("sps_dma_pipe_enable.pipe %d", pipe_index);
+
+	mutex_lock(&bam_dma_lock);
+
+	dev = sps_dma_find_device((u32) bam);
+	if (dev == NULL) {
+		SPS_ERR("BAM-DMA: invalid BAM");
+		goto exit_err;
+	}
+	if (pipe_index >= dev->num_pipes) {
+		SPS_ERR("BAM-DMA: BAM %x invalid pipe: %d",
+			bam->props.phys_addr, pipe_index);
+		goto exit_err;
+	}
+	if (dev->pipes[pipe_index] != PIPE_ACTIVE) {
+		SPS_ERR("BAM-DMA: BAM %x pipe %d not active",
+			bam->props.phys_addr, pipe_index);
+		goto exit_err;
+	}
+
+      /*
+       * The channel must be enabled when the dest/input/write pipe
+       * is enabled
+       */
+	if (DMA_PIPE_IS_DEST(pipe_index)) {
+		/* Configure and enable the channel */
+		channel = pipe_index / 2;
+		chan = &dev->chans[channel];
+
+		if (chan->threshold != SPS_DMA_THRESHOLD_DEFAULT)
+			dma_write_reg_field(dev->virt_addr,
+					    DMA_CHNL_CONFIG(channel),
+					    DMA_CHNL_ACT_THRESH,
+					    chan->thresh);
+
+		if (chan->priority != SPS_DMA_PRI_DEFAULT)
+			dma_write_reg_field(dev->virt_addr,
+					    DMA_CHNL_CONFIG(channel),
+					    DMA_CHNL_WEIGHT,
+					    chan->weight);
+
+		dma_write_reg_field(dev->virt_addr,
+				    DMA_CHNL_CONFIG(channel),
+				    DMA_CHNL_ENABLE, 1);
+	}
+
+	result = 0;
+exit_err:
+	mutex_unlock(&bam_dma_lock);
+
+	return result;
+}
+
+/**
+ * Deactivate a BAM DMA pipe
+ *
+ * This function deactivates a BAM DMA pipe.
+ *
+ * @dev - pointer to BAM-DMA device descriptor
+ *
+ * @bam - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+static int sps_dma_deactivate_pipe_atomic(struct bamdma_device *dev,
+					  struct sps_bam *bam,
+					  u32 pipe_index)
+{
+	u32 channel;
+
+	if (dev->bam != bam)
+		return SPS_ERROR;
+	if (pipe_index >= dev->num_pipes)
+		return SPS_ERROR;
+	if (dev->pipes[pipe_index] != PIPE_ACTIVE)
+		return SPS_ERROR;	/* Pipe is not active */
+
+	SPS_DBG("BAM-DMA: deactivate pipe %d", pipe_index);
+
+	/* Mark pipe inactive */
+	dev->pipes[pipe_index] = PIPE_INACTIVE;
+
+	/*
+	 * Channel must be reset when either pipe is disabled, so just always
+	 * reset regardless of other pipe's state
+	 */
+	channel = pipe_index / 2;
+	dma_write_reg_field(dev->virt_addr, DMA_CHNL_CONFIG(channel),
+			    DMA_CHNL_ENABLE, 0);
+
+	/* If the peer pipe is also inactive, reset the channel */
+	if (sps_dma_check_pipes(dev, pipe_index) == DMA_PIPES_BOTH_DISABLED) {
+		/* Free channel if allocated internally */
+		if (dev->chans[channel].state == DMA_CHAN_STATE_ALLOC_INT)
+			dev->chans[channel].state = DMA_CHAN_STATE_FREE;
+	}
+
+	return 0;
+}
+
+/**
+ * Free a BAM DMA pipe
+ *
+ */
+int sps_dma_pipe_free(void *bam_arg, u32 pipe_index)
+{
+	struct bamdma_device *dev;
+	struct sps_bam *bam = bam_arg;
+	int result;
+
+	mutex_lock(&bam_dma_lock);
+
+	dev = sps_dma_find_device((u32) bam);
+	if (dev == NULL) {
+		SPS_ERR("BAM-DMA: invalid BAM");
+		result = SPS_ERROR;
+		goto exit_err;
+	}
+
+	result = sps_dma_deactivate_pipe_atomic(dev, bam, pipe_index);
+
+exit_err:
+	mutex_unlock(&bam_dma_lock);
+
+	return result;
+}
+
+/**
+ * Get the BAM handle for BAM-DMA.
+ *
+ * The BAM handle should be use as source/destination in the sps_connect().
+ *
+ * @return bam handle on success, zero on error
+ */
+u32 sps_dma_get_bam_handle(void)
+{
+	return (u32) bam_dma_dev[0].bam;
+}
+EXPORT_SYMBOL(sps_dma_get_bam_handle);
+
+/**
+ * Free the BAM handle for BAM-DMA.
+ *
+ */
+void sps_dma_free_bam_handle(u32 h)
+{
+}
+EXPORT_SYMBOL(sps_dma_free_bam_handle);
+
+#endif /* CONFIG_SPS_SUPPORT_BAMDMA */
diff --git a/arch/arm/mach-msm/sps/sps_map.c b/arch/arm/mach-msm/sps/sps_map.c
new file mode 100644
index 0000000..16d5065
--- /dev/null
+++ b/arch/arm/mach-msm/sps/sps_map.c
@@ -0,0 +1,137 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/**
+ * Connection mapping table managment for SPS device driver.
+ */
+
+#include <linux/types.h>	/* u32 */
+#include <linux/kernel.h>	/* pr_info() */
+#include <linux/memory.h>	/* memset */
+
+#include "spsi.h"
+
+/* Module state */
+struct sps_map_state {
+	const struct sps_map *maps;
+	u32 num_maps;
+	u32 options;
+};
+
+static struct sps_map_state sps_maps;
+
+/**
+ * Initialize connection mapping module
+ *
+ */
+int sps_map_init(const struct sps_map *map_props, u32 options)
+{
+	const struct sps_map *maps;
+
+	/* Are there any connection mappings? */
+	memset(&sps_maps, 0, sizeof(sps_maps));
+	if (map_props == NULL)
+		return 0;
+
+	/* Init the module state */
+	sps_maps.maps = map_props;
+	sps_maps.options = options;
+	for (maps = sps_maps.maps;; maps++, sps_maps.num_maps++)
+		if (maps->src.periph_class == SPS_CLASS_INVALID &&
+		    maps->src.periph_phy_addr == SPS_ADDR_INVALID)
+			break;
+
+	SPS_DBG("SPS driver: %d mappings", sps_maps.num_maps);
+
+	return 0;
+}
+
+/**
+ * De-initialize connection mapping module
+ *
+ */
+void sps_map_de_init(void)
+{
+	memset(&sps_maps, 0, sizeof(sps_maps));
+}
+
+/**
+ * Find matching connection mapping
+ *
+ */
+int sps_map_find(struct sps_connect *connect)
+{
+	const struct sps_map *map;
+	u32 i;
+	void *desc;
+	void *data;
+
+	/* Are there any connection mappings? */
+	if (sps_maps.num_maps == 0)
+		return SPS_ERROR;
+
+	/* Search the mapping table for a match to the specified connection */
+	for (i = sps_maps.num_maps, map = sps_maps.maps;
+	    i > 0; i--, map++)
+		if (map->src.periph_class == (u32) connect->source &&
+		    map->dest.periph_class == (u32) connect->destination
+		    && map->config == (u32) connect->config)
+			break;
+
+	if (i == 0)
+		return SPS_ERROR;
+
+	/*
+	 * Before modifying client parameter struct, perform all
+	 * operations that might fail
+	 */
+	desc = spsi_get_mem_ptr(map->desc_base);
+	if (desc == NULL) {
+		SPS_ERR("Cannot get virt addr for I/O buffer: 0x%x",
+			map->desc_base);
+		return SPS_ERROR;
+	}
+
+	if (map->data_size > 0 && map->data_base != SPS_ADDR_INVALID) {
+		data = spsi_get_mem_ptr(map->data_base);
+		if (data == NULL) {
+			SPS_ERR("Cannot get virt addr for I/O buffer: 0x%x",
+				map->data_base);
+			return SPS_ERROR;
+		}
+	} else {
+		data = NULL;
+	}
+
+	/* Copy mapping values to client parameter struct */
+	if (connect->source != SPS_DEV_HANDLE_MEM)
+		connect->src_pipe_index = map->src.pipe_index;
+
+	if (connect->destination != SPS_DEV_HANDLE_MEM)
+		connect->dest_pipe_index = map->dest.pipe_index;
+
+	if (connect->mode == SPS_MODE_SRC)
+		connect->event_thresh = map->src.event_thresh;
+	else
+		connect->event_thresh = map->dest.event_thresh;
+
+	connect->desc.size = map->desc_size;
+	connect->desc.phys_base = map->desc_base;
+	connect->desc.base = desc;
+	if (map->data_size > 0 && map->data_base != SPS_ADDR_INVALID) {
+		connect->data.size = map->data_size;
+		connect->data.phys_base = map->data_base;
+		connect->data.base = data;
+	}
+
+	return 0;
+}
diff --git a/arch/arm/mach-msm/sps/sps_map.h b/arch/arm/mach-msm/sps/sps_map.h
new file mode 100644
index 0000000..692e47c
--- /dev/null
+++ b/arch/arm/mach-msm/sps/sps_map.h
@@ -0,0 +1,46 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* SPS driver mapping table data declarations. */
+
+
+#ifndef _SPS_MAP_H_
+#define _SPS_MAP_H_
+
+#include <linux/types.h>	/* u32 */
+
+/* End point parameters */
+struct sps_map_end_point {
+	u32 periph_class;	/* Peripheral device enumeration class */
+	u32 periph_phy_addr;	/* Peripheral base address */
+	u32 pipe_index;		/* Pipe index */
+	u32 event_thresh;	/* Pipe event threshold */
+};
+
+/* Mapping connection descriptor */
+struct sps_map {
+	/* Source end point parameters */
+	struct sps_map_end_point src;
+
+	/* Destination end point parameters */
+	struct sps_map_end_point dest;
+
+	/* Resource parameters */
+	u32 config;	 /* Configuration (stream) identifier */
+	u32 desc_base;	 /* Physical address of descriptor FIFO */
+	u32 desc_size;	 /* Size (bytes) of descriptor FIFO */
+	u32 data_base;	 /* Physical address of data FIFO */
+	u32 data_size;	 /* Size (bytes) of data FIFO */
+
+};
+
+#endif /* _SPS_MAP_H_ */
diff --git a/arch/arm/mach-msm/sps/sps_mem.c b/arch/arm/mach-msm/sps/sps_mem.c
new file mode 100644
index 0000000..68ce55a
--- /dev/null
+++ b/arch/arm/mach-msm/sps/sps_mem.c
@@ -0,0 +1,156 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/**
+ * Pipe-Memory allocation/free managment.
+ */
+
+#include <linux/types.h>	/* u32 */
+#include <linux/kernel.h>	/* pr_info() */
+#include <linux/io.h>		/* ioremap() */
+#include <linux/mutex.h>	/* mutex */
+#include <linux/list.h>		/* list_head */
+#include <linux/genalloc.h>	/* gen_pool_alloc() */
+#include <linux/errno.h>	/* ENOMEM */
+
+#include "sps_bam.h"
+#include "spsi.h"
+
+static u32 iomem_phys;
+static void *iomem_virt;
+static u32 iomem_size;
+static u32 iomem_offset;
+static struct gen_pool *pool;
+static u32 nid = 0xaa;
+
+/* Debug */
+static u32 total_alloc;
+static u32 total_free;
+
+/**
+ * Translate physical to virtual address
+ *
+ */
+void *spsi_get_mem_ptr(u32 phys_addr)
+{
+	void *virt = NULL;
+
+	if ((phys_addr >= iomem_phys) &&
+	    (phys_addr < (iomem_phys + iomem_size))) {
+		virt = (u8 *) iomem_virt + (phys_addr - iomem_phys);
+	} else {
+		virt = phys_to_virt(phys_addr);
+		SPS_ERR("sps:spsi_get_mem_ptr.invalid phys addr=0x%x.",
+			phys_addr);
+	}
+	return virt;
+}
+
+/**
+ * Allocate I/O (pipe) memory
+ *
+ */
+u32 sps_mem_alloc_io(u32 bytes)
+{
+	u32 phys_addr = SPS_ADDR_INVALID;
+	u32 virt_addr = 0;
+
+	virt_addr = gen_pool_alloc(pool, bytes);
+	if (virt_addr) {
+		iomem_offset = virt_addr - (u32) iomem_virt;
+		phys_addr = iomem_phys + iomem_offset;
+		total_alloc += bytes;
+	} else {
+		SPS_ERR("sps:gen_pool_alloc %d bytes fail.", bytes);
+		return SPS_ADDR_INVALID;
+	}
+
+	SPS_DBG("sps:sps_mem_alloc_io.phys=0x%x.virt=0x%x.size=0x%x.",
+		phys_addr, virt_addr, bytes);
+
+	return phys_addr;
+}
+
+/**
+ * Free I/O memory
+ *
+ */
+void sps_mem_free_io(u32 phys_addr, u32 bytes)
+{
+	u32 virt_addr = 0;
+
+	iomem_offset = phys_addr - iomem_phys;
+	virt_addr = (u32) iomem_virt + iomem_offset;
+
+	SPS_DBG("sps:sps_mem_free_io.phys=0x%x.virt=0x%x.size=0x%x.",
+		phys_addr, virt_addr, bytes);
+
+	gen_pool_free(pool, virt_addr, bytes);
+	total_free += bytes;
+}
+
+/**
+ * Initialize driver memory module
+ *
+ */
+int sps_mem_init(u32 pipemem_phys_base, u32 pipemem_size)
+{
+	int res;
+	/* 2^8=128. The desc-fifo and data-fifo minimal allocation. */
+	int min_alloc_order = 8;
+
+	iomem_phys = pipemem_phys_base;
+	iomem_size = pipemem_size;
+
+	if (iomem_phys == 0) {
+		SPS_ERR("sps:Invalid Pipe-Mem address");
+		return SPS_ERROR;
+	} else {
+		iomem_virt = ioremap(iomem_phys, iomem_size);
+		if (!iomem_virt) {
+			SPS_ERR("sps:Failed to IO map pipe memory.\n");
+			return -ENOMEM;
+		}
+	}
+
+	iomem_offset = 0;
+	SPS_DBG("sps:sps_mem_init.iomem_phys=0x%x,iomem_virt=0x%x.",
+		iomem_phys, (u32) iomem_virt);
+
+	pool = gen_pool_create(min_alloc_order, nid);
+	res = gen_pool_add(pool, (u32) iomem_virt, iomem_size, nid);
+	if (res)
+		return res;
+
+	return 0;
+}
+
+/**
+ * De-initialize driver memory module
+ *
+ */
+int sps_mem_de_init(void)
+{
+	if (iomem_virt != NULL) {
+		gen_pool_destroy(pool);
+		pool = NULL;
+		iounmap(iomem_virt);
+		iomem_virt = NULL;
+	}
+
+	if (total_alloc == total_free)
+		return 0;
+	else {
+		SPS_ERR("sps:sps_mem_de_init:some memory not free");
+		return SPS_ERROR;
+	}
+}
diff --git a/arch/arm/mach-msm/sps/sps_rm.c b/arch/arm/mach-msm/sps/sps_rm.c
new file mode 100644
index 0000000..ec36b25
--- /dev/null
+++ b/arch/arm/mach-msm/sps/sps_rm.c
@@ -0,0 +1,806 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* Resource management for the SPS device driver. */
+
+#include <linux/types.h>	/* u32 */
+#include <linux/kernel.h>	/* pr_info() */
+#include <linux/mutex.h>	/* mutex */
+#include <linux/list.h>		/* list_head */
+#include <linux/slab.h>		/* kzalloc() */
+#include <linux/memory.h>	/* memset */
+
+#include "spsi.h"
+#include "sps_core.h"
+
+/* "Clear" value for the connection parameter struct */
+#define SPSRM_CLEAR     0xcccccccc
+
+/* Max BAM FIFO sizes */
+#define SPSRM_MAX_DESC_FIFO_SIZE    0xffff
+#define SPSRM_MAX_DATA_FIFO_SIZE    0xffff
+
+/* Connection control struct pointer */
+static struct sps_rm *sps_rm;
+
+/**
+ * Initialize resource manager module
+ */
+int sps_rm_init(struct sps_rm *rm, u32 options)
+{
+	/* Set the resource manager state struct pointer */
+	sps_rm = rm;
+
+	/* Initialize the state struct */
+	INIT_LIST_HEAD(&sps_rm->connections_q);
+	mutex_init(&sps_rm->lock);
+
+	return 0;
+}
+
+/**
+ * Initialize client state context
+ *
+ */
+void sps_rm_config_init(struct sps_connect *connect)
+{
+	memset(connect, SPSRM_CLEAR, sizeof(*connect));
+}
+
+/**
+ * Remove reference to connection mapping
+ *
+ * This function removes a reference from a connection mapping struct.
+ *
+ * @map - pointer to connection mapping struct
+ *
+ */
+static void sps_rm_remove_ref(struct sps_connection *map)
+{
+	/* Free this connection */
+	map->refs--;
+	if (map->refs <= 0) {
+		if (map->client_src != NULL || map->client_dest != NULL)
+			SPS_ERR("Failed to allocate connection struct");
+
+		list_del(&map->list);
+		kfree(map);
+	}
+}
+
+/**
+ * Compare map to connect parameters
+ *
+ * This function compares client connect parameters to an allocated
+ * connection mapping.
+ *
+ * @pipe - client context for SPS connection end point
+ *
+ * @return - true if match, false otherwise
+ *
+ */
+static int sps_rm_map_match(const struct sps_connect *cfg,
+			    const struct sps_connection *map)
+{
+	if (cfg->source != map->src.dev ||
+	    cfg->destination != map->dest.dev)
+		return false;
+
+	if (cfg->src_pipe_index != SPSRM_CLEAR &&
+	    cfg->src_pipe_index != map->src.pipe_index)
+		return false;
+
+	if (cfg->dest_pipe_index != SPSRM_CLEAR &&
+	    cfg->dest_pipe_index != map->dest.pipe_index)
+		return false;
+
+	if (cfg->config != map->config)
+		return false;
+
+	if (cfg->desc.size != SPSRM_CLEAR) {
+		if (cfg->desc.size != map->desc.size)
+			return false;
+
+		if (cfg->desc.phys_base != SPSRM_CLEAR &&
+		    cfg->desc.base != (void *)SPSRM_CLEAR &&
+		    (cfg->desc.phys_base != map->desc.phys_base ||
+		     cfg->desc.base != map->desc.base)) {
+			return false;
+		}
+	}
+
+	if (cfg->data.size != SPSRM_CLEAR) {
+		if (cfg->data.size != map->data.size)
+			return false;
+
+		if (cfg->data.phys_base != SPSRM_CLEAR &&
+		    cfg->data.base != (void *)SPSRM_CLEAR &&
+		    (cfg->data.phys_base != map->data.phys_base ||
+		     cfg->data.base != map->data.base))
+			return false;
+	}
+
+	return true;
+}
+
+/**
+ * Find unconnected mapping
+ *
+ * This function finds an allocated a connection mapping.
+ *
+ * @pipe - client context for SPS connection end point
+ *
+ * @return - pointer to allocated connection mapping, or NULL if not found
+ *
+ */
+static struct sps_connection *find_unconnected(struct sps_pipe *pipe)
+{
+	struct sps_connect *cfg = &pipe->connect;
+	struct sps_connection *map;
+
+	/* Has this connection already been allocated? */
+	list_for_each_entry(map, &sps_rm->connections_q, list) {
+		if (sps_rm_map_match(cfg, map))
+			if ((cfg->mode == SPS_MODE_SRC
+			     && map->client_src == NULL)
+			    || (cfg->mode != SPS_MODE_SRC
+				&& map->client_dest == NULL))
+				return map;	/* Found */
+	}
+
+	return NULL;		/* Not Found */
+}
+
+/**
+ * Assign connection to client
+ *
+ * This function assigns a connection to a client.
+ *
+ * @pipe - client context for SPS connection end point
+ *
+ * @map - connection mapping
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+static int sps_rm_assign(struct sps_pipe *pipe,
+			 struct sps_connection *map)
+{
+	struct sps_connect *cfg = &pipe->connect;
+
+	/* Check ownership and BAM */
+	if ((cfg->mode == SPS_MODE_SRC && map->client_src != NULL) ||
+	    (cfg->mode != SPS_MODE_SRC && map->client_dest != NULL))
+		/* The end point is already connected */
+		return SPS_ERROR;
+
+	/* Check whether this end point is a BAM (not memory) */
+	if ((cfg->mode == SPS_MODE_SRC && map->src.bam == NULL) ||
+	    (cfg->mode != SPS_MODE_SRC && map->dest.bam == NULL))
+		return SPS_ERROR;
+
+	/* Record the connection assignment */
+	if (cfg->mode == SPS_MODE_SRC) {
+		map->client_src = pipe;
+		pipe->bam = map->src.bam;
+		pipe->pipe_index = map->src.pipe_index;
+		if (pipe->connect.event_thresh != SPSRM_CLEAR)
+			map->src.event_threshold = pipe->connect.event_thresh;
+	} else {
+		map->client_dest = pipe;
+		pipe->bam = map->dest.bam;
+		pipe->pipe_index = map->dest.pipe_index;
+		if (pipe->connect.event_thresh != SPSRM_CLEAR)
+			map->dest.event_threshold =
+			pipe->connect.event_thresh;
+	}
+	pipe->map = map;
+
+	SPS_DBG("sps:sps_rm_assign.pipe_index=%d\n", pipe->pipe_index);
+
+	/* Copy parameters to client connect state */
+	pipe->connect.src_pipe_index = map->src.pipe_index;
+	pipe->connect.dest_pipe_index = map->dest.pipe_index;
+	pipe->connect.desc = map->desc;
+	pipe->connect.data = map->data;
+
+	pipe->client_state = SPS_STATE_ALLOCATE;
+
+	return 0;
+}
+
+/**
+ * Free connection mapping resources
+ *
+ * This function frees a connection mapping resources.
+ *
+ * @pipe - client context for SPS connection end point
+ *
+ */
+static void sps_rm_free_map_rsrc(struct sps_connection *map)
+{
+	struct sps_bam *bam;
+
+	if (map->client_src != NULL || map->client_dest != NULL)
+		return;
+
+	if (map->alloc_src_pipe != SPS_BAM_PIPE_INVALID) {
+		bam = map->src.bam;
+		sps_bam_pipe_free(bam, map->src.pipe_index);
+
+		/* Is this a BAM-DMA pipe? */
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+		if ((bam->props.options & SPS_BAM_OPT_BAMDMA))
+			/* Deallocate and free the BAM-DMA channel */
+			sps_dma_pipe_free(bam, map->src.pipe_index);
+#endif
+		map->alloc_src_pipe = SPS_BAM_PIPE_INVALID;
+		map->src.pipe_index = SPS_BAM_PIPE_INVALID;
+	}
+	if (map->alloc_dest_pipe != SPS_BAM_PIPE_INVALID) {
+		bam = map->dest.bam;
+		sps_bam_pipe_free(bam, map->dest.pipe_index);
+
+		/* Is this a BAM-DMA pipe? */
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+		if ((bam->props.options & SPS_BAM_OPT_BAMDMA)) {
+			/* Deallocate the BAM-DMA channel */
+			sps_dma_pipe_free(bam, map->dest.pipe_index);
+		}
+#endif
+		map->alloc_dest_pipe = SPS_BAM_PIPE_INVALID;
+		map->dest.pipe_index = SPS_BAM_PIPE_INVALID;
+	}
+	if (map->alloc_desc_base != SPS_ADDR_INVALID) {
+		sps_mem_free_io(map->alloc_desc_base, map->desc.size);
+
+		map->alloc_desc_base = SPS_ADDR_INVALID;
+		map->desc.phys_base = SPS_ADDR_INVALID;
+	}
+	if (map->alloc_data_base != SPS_ADDR_INVALID) {
+		sps_mem_free_io(map->alloc_data_base, map->data.size);
+
+		map->alloc_data_base = SPS_ADDR_INVALID;
+		map->data.phys_base = SPS_ADDR_INVALID;
+	}
+}
+
+/**
+ * Init connection mapping from client connect
+ *
+ * This function initializes a connection mapping from the client's
+ * connect parameters.
+ *
+ * @map - connection mapping struct
+ *
+ * @cfg - client connect parameters
+ *
+ * @return - pointer to allocated connection mapping, or NULL on error
+ *
+ */
+static void sps_rm_init_map(struct sps_connection *map,
+			    const struct sps_connect *cfg)
+{
+	/* Clear the connection mapping struct */
+	memset(map, 0, sizeof(*map));
+	map->desc.phys_base = SPS_ADDR_INVALID;
+	map->data.phys_base = SPS_ADDR_INVALID;
+	map->alloc_desc_base = SPS_ADDR_INVALID;
+	map->alloc_data_base = SPS_ADDR_INVALID;
+	map->alloc_src_pipe = SPS_BAM_PIPE_INVALID;
+	map->alloc_dest_pipe = SPS_BAM_PIPE_INVALID;
+
+	/* Copy client required parameters */
+	map->src.dev = cfg->source;
+	map->dest.dev = cfg->destination;
+	map->desc.size = cfg->desc.size;
+	map->data.size = cfg->data.size;
+	map->config = cfg->config;
+
+	/* Did client specify descriptor FIFO? */
+	if (map->desc.size != SPSRM_CLEAR &&
+	    cfg->desc.phys_base != SPSRM_CLEAR &&
+	    cfg->desc.base != (void *)SPSRM_CLEAR)
+		map->desc = cfg->desc;
+
+	/* Did client specify data FIFO? */
+	if (map->data.size != SPSRM_CLEAR &&
+	    cfg->data.phys_base != SPSRM_CLEAR &&
+	    cfg->data.base != (void *)SPSRM_CLEAR)
+		map->data = cfg->data;
+
+	/* Did client specify source pipe? */
+	if (cfg->src_pipe_index != SPSRM_CLEAR)
+		map->src.pipe_index = cfg->src_pipe_index;
+	else
+		map->src.pipe_index = SPS_BAM_PIPE_INVALID;
+
+
+	/* Did client specify destination pipe? */
+	if (cfg->dest_pipe_index != SPSRM_CLEAR)
+		map->dest.pipe_index = cfg->dest_pipe_index;
+	else
+		map->dest.pipe_index = SPS_BAM_PIPE_INVALID;
+}
+
+/**
+ * Create a new connection mapping
+ *
+ * This function creates a new connection mapping.
+ *
+ * @pipe - client context for SPS connection end point
+ *
+ * @return - pointer to allocated connection mapping, or NULL on error
+ *
+ */
+static struct sps_connection *sps_rm_create(struct sps_pipe *pipe)
+{
+	struct sps_connection *map;
+	struct sps_bam *bam;
+	u32 desc_size;
+	u32 data_size;
+	enum sps_mode dir;
+	int success = false;
+
+	/* Allocate new connection */
+	map = kzalloc(sizeof(*map), GFP_KERNEL);
+	if (map == NULL) {
+		SPS_ERR("Failed to allocate connection struct");
+		return NULL;
+	}
+
+	/* Initialize connection struct */
+	sps_rm_init_map(map, &pipe->connect);
+	dir = pipe->connect.mode;
+
+	/* Use a do/while() loop to avoid a "goto" */
+	success = false;
+	/* Get BAMs */
+	map->src.bam = sps_h2bam(map->src.dev);
+	if (map->src.bam == NULL) {
+		if (map->src.dev != SPS_DEV_HANDLE_MEM) {
+			SPS_ERR("Invalid BAM handle: 0x%x", map->src.dev);
+			goto exit_err;
+		}
+		map->src.pipe_index = SPS_BAM_PIPE_INVALID;
+	}
+	map->dest.bam = sps_h2bam(map->dest.dev);
+	if (map->dest.bam == NULL) {
+		if (map->dest.dev != SPS_DEV_HANDLE_MEM) {
+			SPS_ERR("Invalid BAM handle: 0x%x", map->dest.dev);
+			goto exit_err;
+		}
+		map->dest.pipe_index = SPS_BAM_PIPE_INVALID;
+	}
+
+	/* Check the BAM device for the pipe */
+	if ((dir == SPS_MODE_SRC && map->src.bam == NULL) ||
+	    (dir != SPS_MODE_SRC && map->dest.bam == NULL)) {
+		SPS_ERR("Invalid BAM endpt: dir %d src 0x%x dest 0x%x",
+			dir, map->src.dev, map->dest.dev);
+		goto exit_err;
+	}
+
+	/* Allocate pipes and copy BAM parameters */
+	if (map->src.bam != NULL) {
+		/* Allocate the pipe */
+		bam = map->src.bam;
+		map->alloc_src_pipe = sps_bam_pipe_alloc(bam,
+							map->src.pipe_index);
+		if (map->alloc_src_pipe == SPS_BAM_PIPE_INVALID)
+			goto exit_err;
+		map->src.pipe_index = map->alloc_src_pipe;
+
+		/* Is this a BAM-DMA pipe? */
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+		if ((bam->props.options & SPS_BAM_OPT_BAMDMA)) {
+			int rc;
+			/* Allocate the BAM-DMA channel */
+			rc = sps_dma_pipe_alloc(bam, map->src.pipe_index,
+						 SPS_MODE_SRC);
+			if (rc) {
+				SPS_ERR("Failed to alloc BAM-DMA pipe: %d",
+					map->src.pipe_index);
+				goto exit_err;
+			}
+		}
+#endif
+		map->src.bam_phys = bam->props.phys_addr;
+		map->src.event_threshold = bam->props.event_threshold;
+	}
+	if (map->dest.bam != NULL) {
+		/* Allocate the pipe */
+		bam = map->dest.bam;
+		map->alloc_dest_pipe = sps_bam_pipe_alloc(bam,
+							 map->dest.pipe_index);
+		if (map->alloc_dest_pipe == SPS_BAM_PIPE_INVALID)
+			goto exit_err;
+
+		map->dest.pipe_index = map->alloc_dest_pipe;
+
+		/* Is this a BAM-DMA pipe? */
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+		if ((bam->props.options & SPS_BAM_OPT_BAMDMA)) {
+			int rc;
+			/* Allocate the BAM-DMA channel */
+			rc = sps_dma_pipe_alloc(bam, map->dest.pipe_index,
+					       SPS_MODE_DEST);
+			if (rc) {
+				SPS_ERR("Failed to alloc BAM-DMA pipe: %d",
+					map->dest.pipe_index);
+				goto exit_err;
+			}
+		}
+#endif
+		map->dest.bam_phys = bam->props.phys_addr;
+		map->dest.event_threshold =
+		bam->props.event_threshold;
+	}
+
+	/* Get default FIFO sizes */
+	desc_size = 0;
+	data_size = 0;
+	if (map->src.bam != NULL) {
+		bam = map->src.bam;
+		desc_size = bam->props.desc_size;
+		data_size = bam->props.data_size;
+	}
+	if (map->dest.bam != NULL) {
+		bam = map->dest.bam;
+		if (bam->props.desc_size > desc_size)
+			desc_size = bam->props.desc_size;
+		if (bam->props.data_size > data_size)
+			data_size = bam->props.data_size;
+	}
+
+	/* Set FIFO sizes */
+	if (map->desc.size == SPSRM_CLEAR)
+		map->desc.size = desc_size;
+	if (map->src.bam != NULL && map->dest.bam != NULL) {
+		/* BAM-to-BAM requires data FIFO */
+		if (map->data.size == SPSRM_CLEAR)
+			map->data.size = data_size;
+	} else {
+		map->data.size = 0;
+	}
+	if (map->desc.size > SPSRM_MAX_DESC_FIFO_SIZE) {
+		SPS_ERR("Invalid desc FIFO size: 0x%x",	map->desc.size);
+		goto exit_err;
+	}
+	if (map->src.bam != NULL && map->dest.bam != NULL &&
+	    map->data.size > SPSRM_MAX_DATA_FIFO_SIZE) {
+		SPS_ERR("Invalid data FIFO size: 0x%x",	map->data.size);
+		goto exit_err;
+	}
+
+	/* Allocate descriptor FIFO if necessary */
+	if (map->desc.size && map->desc.phys_base == SPS_ADDR_INVALID) {
+		map->alloc_desc_base = sps_mem_alloc_io(map->desc.size);
+		if (map->alloc_desc_base == SPS_ADDR_INVALID) {
+			SPS_ERR("I/O memory allocation failure: 0x%x",
+				map->desc.size);
+			goto exit_err;
+		}
+		map->desc.phys_base = map->alloc_desc_base;
+		map->desc.base = spsi_get_mem_ptr(map->desc.phys_base);
+		if (map->desc.base == NULL) {
+			SPS_ERR("Cannot get virt addr for I/O buffer: 0x%x",
+				map->desc.phys_base);
+			goto exit_err;
+		}
+	}
+
+	/* Allocate data FIFO if necessary */
+	if (map->data.size && map->data.phys_base == SPS_ADDR_INVALID) {
+		map->alloc_data_base = sps_mem_alloc_io(map->data.size);
+		if (map->alloc_data_base == SPS_ADDR_INVALID) {
+			SPS_ERR("I/O memory allocation failure: 0x%x",
+				map->data.size);
+			goto exit_err;
+		}
+		map->data.phys_base = map->alloc_data_base;
+		map->data.base = spsi_get_mem_ptr(map->data.phys_base);
+		if (map->data.base == NULL) {
+			SPS_ERR("Cannot get virt addr for I/O buffer: 0x%x",
+				map->data.phys_base);
+			goto exit_err;
+		}
+	}
+
+	/* Attempt to assign this connection to the client */
+	if (sps_rm_assign(pipe, map))
+		goto exit_err;
+
+	/* Initialization was successful */
+	success = true;
+exit_err:
+
+	/* If initialization failed, free resources */
+	if (!success) {
+		sps_rm_free_map_rsrc(map);
+		kfree(map);
+		return NULL;
+	}
+
+	return map;
+}
+
+/**
+ * Free connection mapping
+ *
+ * This function frees a connection mapping.
+ *
+ * @pipe - client context for SPS connection end point
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+static int sps_rm_free(struct sps_pipe *pipe)
+{
+	struct sps_connection *map = (void *)pipe->map;
+	struct sps_connect *cfg = &pipe->connect;
+
+	mutex_lock(&sps_rm->lock);
+
+	/* Free this connection */
+	if (cfg->mode == SPS_MODE_SRC)
+		map->client_src = NULL;
+	else
+		map->client_dest = NULL;
+
+	pipe->map = NULL;
+	pipe->client_state = SPS_STATE_DISCONNECT;
+	sps_rm_free_map_rsrc(map);
+
+	sps_rm_remove_ref(map);
+
+	mutex_unlock(&sps_rm->lock);
+
+	return 0;
+}
+
+/**
+ * Allocate an SPS connection end point
+ *
+ * This function allocates resources and initializes a BAM connection.
+ *
+ * @pipe - client context for SPS connection end point
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+static int sps_rm_alloc(struct sps_pipe *pipe)
+{
+	struct sps_connection *map;
+	int result = SPS_ERROR;
+
+	if (pipe->connect.sps_reserved != SPSRM_CLEAR) {
+		/*
+		 * Client did not call sps_get_config()	to init
+		 * struct sps_connect, so only use legacy members.
+		 */
+		u32 source = pipe->connect.source;
+		u32 destination = pipe->connect.destination;
+		enum sps_mode mode = pipe->connect.mode;
+		u32 config = pipe->connect.config;
+		memset(&pipe->connect, SPSRM_CLEAR,
+			      sizeof(pipe->connect));
+		pipe->connect.source = source;
+		pipe->connect.destination = destination;
+		pipe->connect.mode = mode;
+		pipe->connect.config = config;
+	}
+	if (pipe->connect.config == SPSRM_CLEAR)
+		pipe->connect.config = SPS_CONFIG_DEFAULT;
+
+	/*
+	 *  If configuration is not default, then client is specifying a
+	 * connection mapping.  Find a matching mapping, or fail.
+	 * If a match is found, the client's Connect struct will be updated
+	 * with all the mapping's values.
+	 */
+	if (pipe->connect.config != SPS_CONFIG_DEFAULT) {
+		if (sps_map_find(&pipe->connect)) {
+			SPS_ERR("Failed to find connection mapping");
+			return SPS_ERROR;
+		}
+	}
+
+	mutex_lock(&sps_rm->lock);
+	/* Check client state */
+	if (IS_SPS_STATE_OK(pipe)) {
+		SPS_ERR("Client connection already allocated");
+		goto exit_err;
+	}
+
+	/* Are the connection resources already allocated? */
+	map = find_unconnected(pipe);
+	if (map != NULL) {
+		/* Attempt to assign this connection to the client */
+		if (sps_rm_assign(pipe, map))
+			/* Assignment failed, so must allocate new */
+			map = NULL;
+	}
+
+	/* Allocate a new connection if necessary */
+	if (map == NULL) {
+		map = sps_rm_create(pipe);
+		if (map == NULL) {
+			SPS_ERR("Failed to allocate connection");
+			goto exit_err;
+		}
+		list_add_tail(&map->list, &sps_rm->connections_q);
+	}
+
+	/* Add the connection to the allocated queue */
+	map->refs++;
+
+	/* Initialization was successful */
+	result = 0;
+exit_err:
+	mutex_unlock(&sps_rm->lock);
+
+	if (result)
+		return SPS_ERROR;
+
+	return 0;
+}
+
+/**
+ * Disconnect an SPS connection end point
+ *
+ * This function frees resources and de-initializes a BAM connection.
+ *
+ * @pipe - client context for SPS connection end point
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+static int sps_rm_disconnect(struct sps_pipe *pipe)
+{
+	sps_rm_free(pipe);
+	return 0;
+}
+
+/**
+ * Process connection state change
+ *
+ * This function processes a connection state change.
+ *
+ * @pipe - pointer to client context
+ *
+ * @state - new state for connection
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_rm_state_change(struct sps_pipe *pipe, u32 state)
+{
+	int auto_enable = false;
+	int result;
+
+	/* Allocate the pipe */
+	if (pipe->client_state == SPS_STATE_DISCONNECT &&
+	    state == SPS_STATE_ALLOCATE) {
+		if (sps_rm_alloc(pipe))
+			return SPS_ERROR;
+	}
+
+	/* Configure the pipe */
+	if (pipe->client_state == SPS_STATE_ALLOCATE &&
+	    state == SPS_STATE_CONNECT) {
+		/* Connect the BAM pipe */
+		struct sps_bam_connect_param params;
+		memset(&params, 0, sizeof(params));
+		params.mode = pipe->connect.mode;
+		if (pipe->connect.options != SPSRM_CLEAR) {
+			params.options = pipe->connect.options;
+			params.irq_gen_addr = pipe->connect.irq_gen_addr;
+			params.irq_gen_data = pipe->connect.irq_gen_data;
+		}
+		result = sps_bam_pipe_connect(pipe, &params);
+		if (result) {
+			SPS_ERR("Failed to connect BAM 0x%x pipe %d",
+				(u32) pipe->bam, pipe->pipe_index);
+			return SPS_ERROR;
+		}
+		pipe->client_state = SPS_STATE_CONNECT;
+
+		/* Set auto-enable for system-mode connections */
+		if (pipe->connect.source == SPS_DEV_HANDLE_MEM ||
+		    pipe->connect.destination == SPS_DEV_HANDLE_MEM) {
+			if (pipe->map->desc.size != 0 &&
+			    pipe->map->desc.phys_base != SPS_ADDR_INVALID)
+				auto_enable = true;
+		}
+	}
+
+	/* Enable the pipe data flow */
+	if (pipe->client_state == SPS_STATE_CONNECT &&
+	    !(state == SPS_STATE_DISABLE
+	      || state == SPS_STATE_DISCONNECT)
+	    && (state == SPS_STATE_ENABLE || auto_enable
+		|| (pipe->connect.options & SPS_O_AUTO_ENABLE))) {
+		result = sps_bam_pipe_enable(pipe->bam, pipe->pipe_index);
+		if (result) {
+			SPS_ERR("Failed to set BAM 0x%x pipe %d flow on",
+				pipe->bam->props.phys_addr,
+				pipe->pipe_index);
+			return SPS_ERROR;
+		}
+
+		/* Is this a BAM-DMA pipe? */
+#ifdef CONFIG_SPS_SUPPORT_BAMDMA
+		if ((pipe->bam->props.options & SPS_BAM_OPT_BAMDMA)) {
+			/* Activate the BAM-DMA channel */
+			result = sps_dma_pipe_enable(pipe->bam,
+						     pipe->pipe_index);
+			if (result) {
+				SPS_ERR("Failed to activate BAM-DMA pipe: %d",
+					pipe->pipe_index);
+				return SPS_ERROR;
+			}
+		}
+#endif
+		pipe->client_state = SPS_STATE_ENABLE;
+	}
+
+	/* Disable the pipe data flow */
+	if (pipe->client_state == SPS_STATE_ENABLE &&
+	    (state == SPS_STATE_DISABLE	|| state == SPS_STATE_DISCONNECT)) {
+		result = sps_bam_pipe_disable(pipe->bam, pipe->pipe_index);
+		if (result) {
+			SPS_ERR("Failed to set BAM 0x%x pipe %d flow off",
+				pipe->bam->props.phys_addr,
+				pipe->pipe_index);
+			return SPS_ERROR;
+		}
+		pipe->client_state = SPS_STATE_CONNECT;
+	}
+
+	/* Disconnect the BAM pipe */
+	if (pipe->client_state == SPS_STATE_CONNECT &&
+	    state == SPS_STATE_DISCONNECT) {
+		struct sps_connection *map;
+		u32 pipe_index;
+
+		if (pipe->connect.mode == SPS_MODE_SRC)
+			pipe_index = pipe->map->src.pipe_index;
+		else
+			pipe_index = pipe->map->dest.pipe_index;
+
+
+		result = sps_bam_pipe_disconnect(pipe->bam, pipe_index);
+		if (result) {
+			SPS_ERR("Failed to disconnect BAM 0x%x pipe %d",
+				pipe->bam->props.phys_addr,
+				pipe->pipe_index);
+			return SPS_ERROR;
+		}
+
+		/* Clear map state */
+		map = (void *)pipe->map;
+		if (pipe->connect.mode == SPS_MODE_SRC)
+			map->client_src = NULL;
+		else if (pipe->connect.mode == SPS_MODE_DEST)
+			map->client_dest = NULL;
+
+		sps_rm_disconnect(pipe);
+
+		/* Clear the client state */
+		pipe->map = NULL;
+		pipe->bam = NULL;
+		pipe->client_state = SPS_STATE_DISCONNECT;
+	}
+
+	return 0;
+}
diff --git a/arch/arm/mach-msm/sps/spsi.h b/arch/arm/mach-msm/sps/spsi.h
new file mode 100644
index 0000000..a81cd9a
--- /dev/null
+++ b/arch/arm/mach-msm/sps/spsi.h
@@ -0,0 +1,284 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/**
+ * Smart-Peripheral-Switch (SPS) internal API.
+ */
+
+#ifndef _SPSI_H_
+#define _SPSI_H_
+
+#include <linux/types.h>	/* u32 */
+#include <linux/list.h>		/* list_head */
+#include <linux/kernel.h>	/* pr_info() */
+
+#include <mach/sps.h>
+
+#include "sps_map.h"
+
+/* Adjust for offset of struct sps_q_event */
+#define SPS_EVENT_INDEX(e)    ((e) - 1)
+
+#define	SPS_DBG(x...)		pr_debug(x)
+#define	SPS_INFO(x...)		pr_info(x)
+#define	SPS_ERR(x...)		pr_err(x)
+
+#define SPS_ERROR -1
+
+/* End point parameters */
+struct sps_conn_end_pt {
+	u32 dev;		/* Device handle of BAM */
+	u32 bam_phys;		/* Physical address of BAM. */
+	u32 pipe_index;		/* Pipe index */
+	u32 event_threshold;	/* Pipe event threshold */
+	void *bam;
+};
+
+/* Connection bookkeeping descriptor struct */
+struct sps_connection {
+	struct list_head list;
+
+	/* Source end point parameters */
+	struct sps_conn_end_pt src;
+
+	/* Destination end point parameters */
+	struct sps_conn_end_pt dest;
+
+	/* Resource parameters */
+	struct sps_mem_buffer desc;	/* Descriptor FIFO */
+	struct sps_mem_buffer data;	/* Data FIFO (BAM-to-BAM mode only) */
+	u32 config;		/* Client specified connection configuration */
+
+	/* Connection state */
+	void *client_src;
+	void *client_dest;
+	int refs;		/* Reference counter */
+
+	/* Dynamically allocated resouces, if required */
+	u32 alloc_src_pipe;	/* Source pipe index */
+	u32 alloc_dest_pipe;	/* Destination pipe index */
+	u32 alloc_desc_base;	/* Physical address of descriptor FIFO */
+	u32 alloc_data_base;	/* Physical address of data FIFO */
+};
+
+/* Event bookkeeping descriptor struct */
+struct sps_q_event {
+	struct list_head list;
+	/* Event payload data */
+	struct sps_event_notify notify;
+};
+
+/* Memory heap statistics */
+struct sps_mem_stats {
+	u32 base_addr;
+	u32 size;
+	u32 blocks_used;
+	u32 bytes_used;
+	u32 max_bytes_used;
+};
+
+/**
+ * Translate physical to virtual address
+ *
+ * This Function translates physical to virtual address.
+ *
+ * @phys_addr - physical address to translate
+ *
+ * @return virtual memory pointer
+ *
+ */
+void *spsi_get_mem_ptr(u32 phys_addr);
+
+/**
+ * Allocate I/O (pipe) memory
+ *
+ * This function allocates target I/O (pipe) memory.
+ *
+ * @bytes - number of bytes to allocate
+ *
+ * @return physical address of allocated memory, or SPS_ADDR_INVALID on error
+ */
+u32 sps_mem_alloc_io(u32 bytes);
+
+/**
+ * Free I/O (pipe) memory
+ *
+ * This function frees target I/O (pipe) memory.
+ *
+ * @phys_addr - physical address of memory to free
+ *
+ * @bytes - number of bytes to free.
+ */
+void sps_mem_free_io(u32 phys_addr, u32 bytes);
+
+/**
+ * Find matching connection mapping
+ *
+ * This function searches for a connection mapping that matches the
+ * parameters supplied by the client.  If a match is found, the client's
+ * parameter struct is updated with the values specified in the mapping.
+ *
+ * @connect - pointer to client connection parameters
+ *
+ * @return 0 if match is found, negative value otherwise
+ *
+ */
+int sps_map_find(struct sps_connect *connect);
+
+/**
+ * Allocate a BAM DMA pipe
+ *
+ * This function allocates a BAM DMA pipe, and is intended to be called
+ * internally from the BAM resource manager.  Allocation implies that
+ * the pipe has been referenced by a client Connect() and is in use.
+ *
+ * BAM DMA is permissive with activations, and allows a pipe to be allocated
+ * with or without a client-initiated allocation.  This allows the client to
+ * specify exactly which pipe should be used directly through the Connect() API.
+ * sps_dma_alloc_chan() does not allow the client to specify the pipes/channel.
+ *
+ * @bam - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @dir - pipe direction
+ *
+ * @return 0 on success, negative value on error
+ */
+int sps_dma_pipe_alloc(void *bam, u32 pipe_index, enum sps_mode dir);
+
+/**
+ * Enable a BAM DMA pipe
+ *
+ * This function enables the channel associated with a BAM DMA pipe, and
+ * is intended to be called internally from the BAM resource manager.
+ * Enable must occur *after* the pipe has been enabled so that proper
+ * sequencing between pipe and DMA channel enables can be enforced.
+ *
+ * @bam - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_dma_pipe_enable(void *bam, u32 pipe_index);
+
+/**
+ * Free a BAM DMA pipe
+ *
+ * This function disables and frees a BAM DMA pipe, and is intended to be
+ * called internally from the BAM resource manager.  This must occur *after*
+ * the pipe has been disabled/reset so that proper sequencing between pipe and
+ * DMA channel resets can be enforced.
+ *
+ * @bam_arg - pointer to BAM device descriptor
+ *
+ * @pipe_index - pipe index
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_dma_pipe_free(void *bam, u32 pipe_index);
+
+/**
+ * Initialize driver memory module
+ *
+ * This function initializes the driver memory module.
+ *
+ * @pipemem_phys_base - Pipe-Memory physical base.
+ *
+ * @pipemem_size - Pipe-Memory size.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_mem_init(u32 pipemem_phys_base, u32 pipemem_size);
+
+/**
+ * De-initialize driver memory module
+ *
+ * This function de-initializes the driver memory module.
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_mem_de_init(void);
+
+/**
+ * Initialize BAM DMA module
+ *
+ * This function initializes the BAM DMA module.
+ *
+ * @bam_props - pointer to BAM DMA devices BSP configuration properties
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_dma_init(const struct sps_bam_props *bam_props);
+
+/**
+ * De-initialize BAM DMA module
+ *
+ * This function de-initializes the SPS BAM DMA module.
+ *
+ */
+void sps_dma_de_init(void);
+
+/**
+ * Initialize BAM DMA device
+ *
+ * This function initializes a BAM DMA device.
+ *
+ * @h - BAM handle
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_dma_device_init(u32 h);
+
+/**
+ * De-initialize BAM DMA device
+ *
+ * This function de-initializes a BAM DMA device.
+ *
+ * @h - BAM handle
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+int sps_dma_device_de_init(u32 h);
+
+/**
+ * Initialize connection mapping module
+ *
+ * This function initializes the SPS connection mapping module.
+ *
+ * @map_props - pointer to connection mapping BSP configuration properties
+ *
+ * @options - driver options bitflags (see SPS_OPT_*)
+ *
+ * @return 0 on success, negative value on error
+ *
+ */
+
+int sps_map_init(const struct sps_map *map_props, u32 options);
+
+/**
+ * De-initialize connection mapping module
+ *
+ * This function de-initializes the SPS connection mapping module.
+ *
+ */
+void sps_map_de_init(void);
+
+#endif	/* _SPSI_H_ */
-- 
1.7.3.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum
