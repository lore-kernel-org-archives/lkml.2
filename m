Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751069Ab1B1FIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 00:08:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:22429 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab1B1FIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 00:08:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,238,1297065600"; 
   d="scan'208";a="607111348"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com
Subject: RFC: [PATCH 2/5] staging: sep: update existing sep headers
Date: Sun, 27 Feb 2011 21:11:09 -0800
Message-Id: <1298869869-4320-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates include new structures and constants necessary
for kernel crypto operation

Some functions in sep_main.c are made available to sep_crypto.c
which will be added in subsequent patch

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_dev.h           |   24 ++++-
 drivers/staging/sep/sep_driver_api.h    |  192 ++++++++++++++++++++++++++++++-
 drivers/staging/sep/sep_driver_config.h |   14 +-
 3 files changed, 215 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/sep/sep_dev.h b/drivers/staging/sep/sep_dev.h
index 0ffe68c..122dc94 100644
--- a/drivers/staging/sep/sep_dev.h
+++ b/drivers/staging/sep/sep_dev.h
@@ -5,8 +5,8 @@
  *
  *  sep_dev.h - Security Processor Device Structures
  *
- *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
- *  Contributions(c) 2009,2010 Discretix. All rights reserved.
+ *  Copyright(c) 2009,2011 Intel Corporation. All rights reserved.
+ *  Contributions(c) 2009,2011 Discretix. All rights reserved.
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms of the GNU General Public License as published by the Free
@@ -28,6 +28,7 @@
  *
  *  CHANGES
  *  2010.09.14  upgrade to Medfield
+ *  2011.02.22  enable kernel crypto
  */
 
 struct sep_device {
@@ -51,6 +52,7 @@ struct sep_device {
 
 	struct mutex sep_mutex;
 	struct mutex ioctl_mutex;
+	struct mutex tasklet_mutex;
 	spinlock_t snd_rply_lck;
 
 	/* flags to indicate use and lock status of sep */
@@ -129,8 +131,26 @@ struct sep_device {
 
 	struct sep_dma_resource dma_res_arr[SEP_MAX_NUM_SYNC_DMA_OPS];
 
+	/* The following are used for kernel crypto client requests */
+	u32 in_kernel; /* Set for kernel client request */
+	struct tasklet_struct	finish_tasklet;
+	struct ahash_request	*current_hash_req;
+	struct ablkcipher_request *current_cypher_req;
+	spinlock_t		busy_lock;
+	enum type_of_request	current_request;
+	enum hash_stage		current_hash_stage;
+	void			*current_msg_ptr;
+	u32			out_msg_size;
+	u32			in_msg_size;
+	struct scatterlist	*src_sg;
+	struct scatterlist	*dst_sg;
+	/* Used only if scatterlist replace due to oddball page sizes */
+	struct scatterlist	*src_sg_hold;
+	struct scatterlist	*dst_sg_hold;
 };
 
+extern struct sep_device *sep_dev;
+
 static inline void sep_write_reg(struct sep_device *dev, int reg, u32 value)
 {
 	void __iomem *addr = dev->reg_addr + reg;
diff --git a/drivers/staging/sep/sep_driver_api.h b/drivers/staging/sep/sep_driver_api.h
index 0f38d61..68e1b4b 100644
--- a/drivers/staging/sep/sep_driver_api.h
+++ b/drivers/staging/sep/sep_driver_api.h
@@ -2,8 +2,8 @@
  *
  *  sep_driver_api.h - Security Processor Driver api definitions
  *
- *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
- *  Contributions(c) 2009,2010 Discretix. All rights reserved.
+ *  Copyright(c) 2009,2011 Intel Corporation. All rights reserved.
+ *  Contributions(c) 2009,2011 Discretix. All rights reserved.
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms of the GNU General Public License as published by the Free
@@ -26,6 +26,7 @@
  *  CHANGES:
  *
  *  2010.09.14  Upgrade to Medfield
+ *  2011.02.22  Enable kernel crypto
  *
  */
 
@@ -37,10 +38,27 @@
 #define SEP_DRIVER_SRC_REQ		2
 #define SEP_DRIVER_SRC_PRINTF		3
 
-
-/*-------------------------------------------
-    TYPEDEFS
-----------------------------------------------*/
+/* Following enums are used only for kernel crypto api */
+enum type_of_request {
+	NO_REQUEST,
+	AES_CBC,
+	AES_ECB,
+	DES_CBC,
+	DES_ECB,
+	DES3_ECB,
+	DES3_CBC,
+	SHA1,
+	MD5,
+	SHA224,
+	SHA256
+	};
+
+enum hash_stage {
+	HASH_INIT,
+	HASH_UPDATE,
+	HASH_FINISH,
+	HASH_DIGEST
+};
 
 /*
  * Note that several members of these structres are only here
@@ -212,6 +230,10 @@ struct sep_dma_resource {
 
 	/* number of entries of the output mapp array */
 	u32 out_map_num_entries;
+
+	/* Scatter list for kernel operations */
+	struct scatterlist *src_sg;
+	struct scatterlist *dst_sg;
 };
 
 
@@ -294,4 +316,162 @@ struct sep_lli_entry {
 #define SEP_IOCFREEDCB					\
 	_IO(SEP_IOC_MAGIC_NUMBER, 36)
 
+
+/* functions */
+
+/**
+ *	sep_map_shared_area -
+ *	returns@ return virtual address of shared area
+ */
+void *sep_map_shared_area(void);
+
+/**
+ *	sep_send_command_handler - kick off a command
+ *	@sep: SEP being signalled
+ *
+ *	This function raises interrupt to SEP that signals that is has a new
+ *	command from the host
+ *
+ *      Note that this function does fall under the ioctl lock
+ */
+int sep_send_msg_rdy_cmd(void);
+
+/**
+ *	sep_lock -
+ *	returns@ 0 on success; -EINTR on error
+ *	This locks the device to this process
+ */
+int sep_lock(void);
+
+/**
+ *	sep_unlock -
+ *	This locks the device to this process
+ */
+void sep_unlock(void);
+
+/**
+ *	sep_driver_poll -
+ *	@returns: 0 on success; error value on failure
+ *	This poll function is used only for kernel call;
+ *	userspace calls (via ioctl) use sep_poll
+ */
+int sep_driver_poll(void);
+
+struct sep_device;
+
+/**
+ *	sep_prepare_input_output_dma_table - prepare DMA I/O table
+ *	@app_virt_in_addr:
+ *	@app_virt_out_addr:
+ *	@data_size:
+ *	@block_size:
+ *	@lli_table_in_ptr:
+ *	@lli_table_out_ptr:
+ *	@in_num_entries_ptr:
+ *	@out_num_entries_ptr:
+ *	@table_data_size_ptr:
+ *	@is_kva: set for kernel data; used only for kernel crypto module
+ *
+ *	This function builds input and output DMA tables for synhronic
+ *	symmetric operations (AES, DES, HASH). It also checks that each table
+ *	is of the modular block size
+ *	Note that all bus addresses that are passed to the SEP
+ *	are in 32 bit format; the SEP is a 32 bit device
+ */
+int sep_prepare_input_output_dma_table(struct sep_device *sep,
+	unsigned long app_virt_in_addr,
+	unsigned long app_virt_out_addr,
+	u32 data_size,
+	u32 block_size,
+	dma_addr_t *lli_table_in_ptr,
+	dma_addr_t *lli_table_out_ptr,
+	u32 *in_num_entries_ptr,
+	u32 *out_num_entries_ptr,
+	u32 *table_data_size_ptr,
+	bool is_kva);
+
+/**
+ *	sep_prepare_input_dma_table - prepare input DMA mappings
+ *	@sep: pointer to struct sep_device
+ *	@data_size:
+ *	@block_size:
+ *	@lli_table_ptr:
+ *	@num_entries_ptr:
+ *	@table_data_size_ptr:
+ *	@is_kva: set for kernel data (kernel cryptio call)
+ *
+ *	This function prepares only input DMA table for synhronic symmetric
+ *	operations (HASH)
+ *	Note that all bus addresses that are passed to the SEP
+ *	are in 32 bit format; the SEP is a 32 bit device
+ */
+int sep_prepare_input_dma_table(struct sep_device *sep,
+	unsigned long app_virt_addr,
+	u32 data_size,
+	u32 block_size,
+	dma_addr_t *lli_table_ptr,
+	u32 *num_entries_ptr,
+	u32 *table_data_size_ptr,
+	bool is_kva);
+
+/**
+ *	sep_prepare_input_output_dma_table_in_dcb - prepare control blocks
+ *	@app_in_address: unsigned long; for data buffer in (user space)
+ *	@app_out_address: unsigned long; for data buffer out (user space)
+ *	@data_in_size: u32; for size of data
+ *	@block_size: u32; for block size
+ *	@tail_block_size: u32; for size of tail block
+ *	@isapplet: bool; to indicate external app
+ *	@is_kva: bool; kernel buffer; only used for kernel crypto module
+ *
+ *	This function prepares the linked DMA tables and puts the
+ *	address for the linked list of tables inta a DCB (data control
+ *	block) the address of which is known by the SEP hardware
+ *	Note that all bus addresses that are passed to the SEP
+ *	are in 32 bit format; the SEP is a 32 bit device
+ */
+int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
+	unsigned long  app_in_address,
+	unsigned long  app_out_address,
+	u32  data_in_size,
+	u32  block_size,
+	u32  tail_block_size,
+	bool isapplet,
+	bool	is_kva);
+
+/**
+ *	sep_allocate_data_pool_memory -allocate pool memory
+ *	@sizeInBytes: size to allocate
+ *	@virtAddr_ptr: place to return the pointer to the memory
+ *
+ *	This function handles the allocate data pool memory request
+ *	This function returns calculates the bus and virtual addresses
+ *	of the region
+ */
+int sep_allocate_data_pool_memory(u32 sizeInBytes, void **virtAddr_ptr);
+
+/**
+ *	sep_free_dma_table_kernel_data - free DMA table for kernel data
+ *
+ *	Handles the request to  free DMA table for synchronic actions
+ *	from a kernel caller
+ */
+void sep_free_dma_table_kernel_data(void);
+
+/**
+ *	sep_free_dma_tables_and_dcb - free DMA tables and DCBs
+ *	@sep: pointer to struct sep_device
+ *	@isapplet: indicates external application (used for kernel access)
+ *	@is_kva: indicates kernel addresses (only used for kernel crypto)
+ *
+ *	This function frees the DMA tables and DCB
+ */
+int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
+	bool is_kva);
+/**
+ *	sep_dump_message - dump the message that is pending
+ *	@sep: SEP device
+ */
+void sep_dump_message(struct sep_device *sep);
+
 #endif
diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/sep_driver_config.h
index d3b9220..12ec690 100644
--- a/drivers/staging/sep/sep_driver_config.h
+++ b/drivers/staging/sep/sep_driver_config.h
@@ -2,8 +2,8 @@
  *
  *  sep_driver_config.h - Security Processor Driver configuration
  *
- *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
- *  Contributions(c) 2009,2010 Discretix. All rights reserved.
+ *  Copyright(c) 2009,2011 Intel Corporation. All rights reserved.
+ *  Contributions(c) 2009,2011 Discretix. All rights reserved.
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms of the GNU General Public License as published by the Free
@@ -26,6 +26,7 @@
  *  CHANGES:
  *
  *  2010.06.26	Upgrade to Medfield
+ *  2011.02.22  Enable kernel crypto
  *
  */
 
@@ -76,10 +77,6 @@ held by the proccess (struct file) */
 #define SEP_REQUEST_DAEMON_MAPPED 1
 #define SEP_REQUEST_DAEMON_UNMAPPED 0
 
-#define SEP_DEV_NAME "sep_sec_driver"
-#define SEP_DEV_SINGLETON "sep_sec_singleton_driver"
-#define SEP_DEV_DAEMON "sep_req_daemon_driver"
-
 /*--------------------------------------------------------
 	SHARED AREA  memory total size is 36K
 	it is divided is following:
@@ -132,6 +129,9 @@ held by the proccess (struct file) */
 /* system data (time, caller id etc') pool */
 #define SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES		(1024 * 3)
 
+/* Offset of the sep printf buffer in the message area */
+#define SEP_DRIVER_PRINTF_OFFSET_IN_BYTES			(5888)
+
 /* the size in bytes of the time memory */
 #define SEP_DRIVER_TIME_MEMORY_SIZE_IN_BYTES			8
 
@@ -180,7 +180,7 @@ held by the proccess (struct file) */
 /* offset of the caller id area */
 #define SEP_CALLER_ID_OFFSET_BYTES \
 	(SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES + \
-    SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES)
+	SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES)
 
 /* offset of the DCB area */
 #define SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES \
-- 
1.6.3.3

