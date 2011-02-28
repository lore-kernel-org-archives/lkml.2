Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab1B1FJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 00:09:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:4395 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1B1FJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 00:09:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,238,1297065600"; 
   d="scan'208";a="662013706"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com
Subject: RFC: [PATCH 4/5] staging: sep: update sep_main.c for kernel crypto operation
Date: Sun, 27 Feb 2011 21:11:49 -0800
Message-Id: <1298869909-4394-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes include new functions required by the sep_crypto.c
file (to be added in subsequent patch) as well as alterations
in interrupt handler.

The original functionality of the driver as used by the middleware
is unaffected by these changes.

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_main.c |  593 ++++++++++++++++++++++++++++++++++------
 1 files changed, 515 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index d841289..988d7cb 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -1,9 +1,9 @@
 /*
  *
- *  sep_driver.c - Security Processor Driver main group of functions
+ *  sep_main.c - Security Processor Driver main group of functions
  *
- *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
- *  Contributions(c) 2009,2010 Discretix. All rights reserved.
+ *  Copyright(c) 2009,2011 Intel Corporation. All rights reserved.
+ *  Contributions(c) 2009,2011 Discretix. All rights reserved.
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms of the GNU General Public License as published by the Free
@@ -27,6 +27,7 @@
  *
  *  2009.06.26	Initial publish
  *  2010.09.14  Upgrade to Medfield
+ *  2011.02.22  Enable kernel crypto
  *
  */
 #include <linux/init.h>
@@ -54,13 +55,23 @@
 #include <linux/delay.h>
 #include <linux/jiffies.h>
 #include <linux/rar_register.h>
+#include <linux/slab.h>
 
 #include "../memrar/memrar.h"
 
+#include <linux/crypto.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha.h>
+#include <crypto/md5.h>
+#include <crypto/aes.h>
+#include <crypto/des.h>
+#include <crypto/hash.h>
 #include "sep_driver_hw_defs.h"
 #include "sep_driver_config.h"
 #include "sep_driver_api.h"
 #include "sep_dev.h"
+#include "sep_crypto.h"
 
 /*----------------------------------------
 	DEFINES
@@ -72,9 +83,13 @@
 	GLOBAL variables
 --------------------------------------------*/
 
-/* Keep this a single static object for now to keep the conversion easy */
+/**
+ * Currenlty, there is only one SEP device per platform;
+ * In event platforms in the future have more than one SEP
+ * device, this will be a linked list
+ */
 
-static struct sep_device *sep_dev;
+struct sep_device *sep_dev;
 
 /**
  *	sep_load_firmware - copy firmware cache/resident
@@ -165,15 +180,16 @@ MODULE_FIRMWARE("sep/extapp.image.bin");
 
 /**
  *	sep_dump_message - dump the message that is pending
- *	@sep: SEP device
+ *	@sep: SEP device; uses existing kernel debug print
+ *	facilities
  */
-static void sep_dump_message(struct sep_device *sep)
+void sep_dump_message(struct sep_device *sep)
 {
 	int count;
 	u32 *p = sep->shared_addr;
 	for (count = 0; count < 12 * 4; count += 4)
 		dev_dbg(&sep->pdev->dev, "Word %d of the message is %x\n",
-								count, *p++);
+								count/4, *p++);
 }
 
 /**
@@ -438,6 +454,74 @@ static int sep_free_dma_table_data_handler(struct sep_device *sep)
 }
 
 /**
+ *	sep_free_dma_table_kernel_data - free DMA table for kernel data
+ *
+ *	Handles the request to  free DMA table for synchronic actions
+ *	from a kernel caller
+ */
+void sep_free_dma_table_kernel_data(void)
+{
+	int dcb_counter;
+	/* Pointer to the current dma_resource struct */
+	struct sep_dma_resource *dma;
+
+	dev_dbg(&sep_dev->pdev->dev, "sep_free_dma_table_kernel_data start\n");
+
+	for (dcb_counter = 0; dcb_counter < sep_dev->nr_dcb_creat;
+		dcb_counter++) {
+
+		dma = &sep_dev->dma_res_arr[dcb_counter];
+
+		/* Unmap and free input map array */
+		if (dma->in_map_array) {
+			dma_unmap_single(&sep_dev->pdev->dev,
+				dma->in_map_array[0].dma_addr,
+				dma->in_map_array[0].size,
+				DMA_BIDIRECTIONAL);
+
+			kfree(dma->in_map_array);
+		}
+
+		/* Unmap and free input map array */
+		if (dma->out_map_array) {
+			dma_unmap_single(&sep_dev->pdev->dev,
+				dma->out_map_array[0].dma_addr,
+				dma->out_map_array[0].size,
+				DMA_BIDIRECTIONAL);
+
+			kfree(dma->out_map_array);
+		}
+
+		if (dma->src_sg) {
+			dma_unmap_sg(&sep_dev->pdev->dev, dma->src_sg,
+				dma->in_map_num_entries, DMA_TO_DEVICE);
+			dma->src_sg = NULL;
+		}
+
+		if (dma->dst_sg) {
+			dma_unmap_sg(&sep_dev->pdev->dev, dma->dst_sg,
+				dma->in_map_num_entries, DMA_FROM_DEVICE);
+			dma->dst_sg = NULL;
+		}
+
+		/* Reset all the values */
+		dma->in_page_array = NULL;
+		dma->out_page_array = NULL;
+		dma->in_num_pages = 0;
+		dma->out_num_pages = 0;
+		dma->in_map_array = NULL;
+		dma->out_map_array = NULL;
+		dma->in_map_num_entries = 0;
+		dma->out_map_num_entries = 0;
+	}
+
+	sep_dev->nr_dcb_creat = 0;
+	sep_dev->num_lli_tables_created = 0;
+
+	dev_dbg(&sep_dev->pdev->dev, "sep_free_dma_table_kernel_data end\n");
+}
+
+/**
  *	sep_request_daemon_mmap - maps the shared area to user space
  *	@filp: pointer to struct file
  *	@vma: pointer to vm_area_struct
@@ -633,6 +717,26 @@ end_function:
 }
 
 /**
+ *	sep_lock -
+ *	returns@ 0 on success; 1 if bit is already set
+ *	This locks the device to this process
+ */
+int sep_lock(void)
+{
+	return test_and_set_bit(SEP_MMAP_LOCK_BIT, &sep_dev->in_use_flags);
+}
+
+/**
+ *	sep_unlock -
+ *	Clears SEP_MMAP_LOCK_BIT; enabling other processes to use device
+ */
+void sep_unlock(void)
+{
+	clear_bit(SEP_MMAP_LOCK_BIT, &sep_dev->in_use_flags);
+	wake_up(&sep_dev->event);
+}
+
+/**
  *	sep_poll - poll handler
  *	@filp: pointer to struct file
  *	@wait: pointer to poll_table
@@ -721,6 +825,110 @@ end_function:
 }
 
 /**
+ *	sep_driver_poll -
+ *	@returns: 0 on success; error value on failure
+ *	This poll function is used only for kernel call;
+ *	userspace calls (via ioctl) use sep_poll
+ */
+int sep_driver_poll(void)
+{
+	int error;
+
+	u32 retVal2;
+
+	u32 retVal3;
+
+	unsigned long end_time;
+
+	error = 0;
+
+	/* Check if send command or send_reply were activated previously */
+	if (!test_bit(SEP_SEND_MSG_LOCK_BIT, &sep_dev->in_use_flags)) {
+		error = -EIO;
+		goto end_function;
+	}
+
+	/**
+	 * Wait up to 10 seconds for the SEP to finish
+	 * When the send and recieve counts are the same
+	 * the SEP is finished
+	 * This cannot be done with wait because it causes
+	 * a kernel oops when used with the kernel crypto
+	 * module, which runs in atomic state
+	 */
+	end_time = jiffies + (WAIT_TIME * HZ);
+
+	while ((time_before(jiffies, end_time)) &&
+		(sep_dev->send_ct != sep_dev->reply_ct)) {
+		retVal3 = sep_read_reg(sep_dev,
+			HW_HOST_SEP_HOST_GPR3_REG_ADDR);
+	}
+
+	/* Did SEP finish correctly? */
+	if (sep_dev->send_ct != sep_dev->reply_ct) {
+		dev_warn(&sep_dev->pdev->dev,
+			"driver_poll: sep never finished properly\n");
+			error = -EIO;
+			goto end_function;
+	}
+
+	/* Check if error occured during poll */
+	retVal3 = sep_read_reg(sep_dev,
+		HW_HOST_SEP_HOST_GPR3_REG_ADDR);
+	if (retVal3 != 0x0) {
+		dev_warn(&sep_dev->pdev->dev,
+			"SEP Driver: error during poll\n");
+		error = -EIO;
+		goto end_function;
+	}
+
+	retVal2 = sep_read_reg(sep_dev,
+		HW_HOST_SEP_HOST_GPR2_REG_ADDR);
+
+	dev_dbg(&sep_dev->pdev->dev, "retVal2 is %x\n", retVal2);
+
+	/* Check printf request from sep */
+	if ((retVal2 >> 30) & 0x1) {
+
+		dev_dbg(&sep_dev->pdev->dev,
+			"SEP Driver: sep printf request in\n");
+		dev_dbg(&sep_dev->pdev->dev, "%s",
+			(char *)(sep_dev->shared_addr +
+			SEP_DRIVER_PRINTF_OFFSET_IN_BYTES));
+		sep_req_daemon_send_reply_command_handler(sep_dev);
+		error = -EIO;
+		goto end_function;
+	}
+
+	/* Check if the this is sep reply or request */
+	if (retVal2 >> 31) {
+		dev_dbg(&sep_dev->pdev->dev,
+			"SEP Driver: sep request in\n");
+		error = -EIO;
+		goto end_function;
+
+	/* Default is normal request */
+	} else {
+		dev_dbg(&sep_dev->pdev->dev,
+			"SEP Driver: sep reply in\n");
+		clear_bit(SEP_SEND_MSG_LOCK_BIT, &sep_dev->in_use_flags);
+	}
+
+end_function:
+
+	return error;
+}
+
+/**
+ *	sep_map_shared_area -
+ *	returns@ return virtual address of shared area
+ */
+void *sep_map_shared_area(void)
+{
+	return sep_dev->shared_addr;
+}
+
+/**
  *	sep_time_address - address in SEP memory of time
  *	@sep: SEP device we want the address from
  *
@@ -898,6 +1106,16 @@ end_function:
 }
 
 /**
+ *	sep_send_msg_rdy_cmd -
+ *	returns@ 0 on success
+ *	Sends command to SEP
+ */
+int sep_send_msg_rdy_cmd(void)
+{
+	return sep_send_command_handler(sep_dev);
+}
+
+/**
  *	sep_allocate_data_pool_memory_handler -allocate pool memory
  *	@sep: pointer to struct sep_device
  *	@arg: pointer to struct alloc_struct
@@ -931,7 +1149,8 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 	}
 
 	dev_dbg(&sep->pdev->dev,
-		"data pool bytes_allocated: %x\n", (int)sep->data_pool_bytes_allocated);
+		"data pool bytes_allocated: %x\n",
+		(int)sep->data_pool_bytes_allocated);
 	dev_dbg(&sep->pdev->dev,
 		"offset: %x\n", SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES);
 	/* Set the virtual and bus address */
@@ -965,6 +1184,208 @@ end_function:
 }
 
 /**
+ *	sep_allocate_data_pool_memory -allocate pool memory
+ *	@sizeInBytes: size to allocate
+ *	@virtAddr_ptr: place to return the pointer to the memory
+ *
+ *	This function handles the allocate data pool memory request
+ *	This function returns calculates the bus and virtual addresses
+ *	of the region
+ */
+int sep_allocate_data_pool_memory(u32 size_in_bytes, void **virt_addr)
+{
+	int error = 0;
+
+	/* Holds the allocated buffer address in the system memory pool */
+	u32 *token_addr;
+
+	dev_dbg(&sep_dev->pdev->dev,
+		"sep_allocate_data_pool_memory start\n");
+
+	/* Allocate memory */
+	if ((sep_dev->data_pool_bytes_allocated + size_in_bytes) >
+		SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES) {
+		error = -ENOMEM;
+		goto end_function;
+	}
+
+	dev_dbg(&sep_dev->pdev->dev,
+		"bytes_allocated: %x\n",
+		(int)sep_dev->data_pool_bytes_allocated);
+
+	/* Put the virtual address into the pointer slot provided by caller */
+	*virt_addr = sep_dev->shared_addr +
+		SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
+		sep_dev->data_pool_bytes_allocated;
+
+	/* Place in the shared area that is known by the SEP */
+	token_addr = (u32 *)(sep_dev->shared_addr +
+		SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES +
+		(sep_dev->num_of_data_allocations)*2*sizeof(u32));
+
+	dev_dbg(&sep_dev->pdev->dev, "allocation offset: %x\n",
+		SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES);
+	dev_dbg(&sep_dev->pdev->dev, "data pool token addr is %p\n",
+		token_addr);
+
+	token_addr[0] = SEP_DATA_POOL_POINTERS_VAL_TOKEN;
+	token_addr[1] = (u32)sep_dev->shared_bus +
+		SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
+		sep_dev->data_pool_bytes_allocated;
+
+	dev_dbg(&sep_dev->pdev->dev, "data pool token [0] %x\n", token_addr[0]);
+	dev_dbg(&sep_dev->pdev->dev, "data pool token [1] %x\n", token_addr[1]);
+
+	/* Update the allocation */
+	sep_dev->data_pool_bytes_allocated += size_in_bytes;
+	sep_dev->num_of_data_allocations += 1;
+
+	dev_dbg(&sep_dev->pdev->dev, "data_allocations %d\n",
+		sep_dev->num_of_data_allocations);
+	dev_dbg(&sep_dev->pdev->dev, "bytes allocated  %d\n",
+		(int)sep_dev->data_pool_bytes_allocated);
+
+end_function:
+	dev_dbg(&sep_dev->pdev->dev, "sep_allocate_data_pool_memory end\n");
+	return error;
+}
+
+/**
+ *	sep_crypto_dma -
+ *	@sep: pointer to struct sep_device
+ *	@sg: pointer to struct scatterlist
+ *	@direction:
+ *	@dma_maps: pointer to place a pointer to array of dma maps
+ *	 This is filled in; anything previous there will be lost
+ *	 The structure for dma maps is sep_dma_map
+ *	@returns number of dma maps on success; negative on error
+ *
+ *	This creates the LLI table from the scatterlist
+ */
+static int sep_crypto_dma(
+	struct sep_device *sep,
+	struct scatterlist *sg,
+	struct sep_dma_map **dma_maps,
+	enum dma_data_direction direction)
+{
+	struct scatterlist *temp_sg;
+
+	u32 count_segment;
+	u32 count_mapped;
+	struct sep_dma_map *sep_dma;
+	int ct1;
+
+	if (sg->length == 0)
+		return 0;
+
+	/* Count the segments */
+	temp_sg = sg;
+	count_segment = 0;
+	while (temp_sg) {
+		count_segment += 1;
+		temp_sg = scatterwalk_sg_next(temp_sg);
+	}
+	dev_dbg(&sep->pdev->dev,
+		"There are (hex) %x segments in sg\n", count_segment);
+
+	/* DMA map segments */
+	count_mapped = dma_map_sg(&sep->pdev->dev, sg,
+		count_segment, direction);
+
+	dev_dbg(&sep->pdev->dev,
+		"There are (hex) %x maps in sg\n", count_mapped);
+
+	if (count_mapped == 0) {
+		dev_dbg(&sep->pdev->dev, "Cannot dma_map_sg\n");
+		return -ENOMEM;
+	}
+
+	sep_dma = kmalloc(sizeof(struct sep_dma_map) *
+		count_mapped, GFP_ATOMIC);
+
+	if (sep_dma == NULL) {
+		dev_dbg(&sep->pdev->dev, "Cannot allocate dma_maps\n");
+		return -ENOMEM;
+	}
+
+	for_each_sg(sg, temp_sg, count_mapped, ct1) {
+		sep_dma[ct1].dma_addr = sg_dma_address(temp_sg);
+		sep_dma[ct1].size = sg_dma_len(temp_sg);
+		dev_dbg(&sep->pdev->dev, "(all hex) map %x dma %lx len %lx\n",
+			ct1, (unsigned long)sep_dma[ct1].dma_addr,
+			(unsigned long)sep_dma[ct1].size);
+		}
+
+	*dma_maps = sep_dma;
+	return count_mapped;
+
+}
+
+/**
+ *	sep_crypto_lli -
+ *	@sep: pointer to struct sep_device
+ *	@sg: pointer to struct scatterlist
+ *	@data_size: total data size
+ *	@direction:
+ *	@dma_maps: pointer to place a pointer to array of dma maps
+ *	 This is filled in; anything previous there will be lost
+ *	 The structure for dma maps is sep_dma_map
+ *	@lli_maps: pointer to place a pointer to array of lli maps
+ *	 This is filled in; anything previous there will be lost
+ *	 The structure for dma maps is sep_dma_map
+ *	@returns number of dma maps on success; negative on error
+ *
+ *	This creates the LLI table from the scatterlist
+ */
+static int sep_crypto_lli(
+	struct sep_device *sep,
+	struct scatterlist *sg,
+	struct sep_dma_map **maps,
+	struct sep_lli_entry **llis,
+	u32 data_size,
+	enum dma_data_direction direction)
+{
+
+	int ct1;
+	struct sep_lli_entry *sep_lli;
+	struct sep_dma_map *sep_map;
+
+	int nbr_ents;
+
+	nbr_ents = sep_crypto_dma(sep, sg, maps, direction);
+	if (nbr_ents <= 0) {
+		dev_dbg(&sep->pdev->dev, "crypto_dma failed %x\n",
+			nbr_ents);
+		return nbr_ents;
+	}
+
+	sep_map = *maps;
+
+	sep_lli = kmalloc(sizeof(struct sep_lli_entry) * nbr_ents, GFP_ATOMIC);
+
+	if (sep_lli == NULL) {
+		dev_dbg(&sep->pdev->dev, "Cannot allocate lli_maps\n");
+
+		kfree(*maps);
+		*maps = NULL;
+		return -ENOMEM;
+	}
+
+	for (ct1 = 0; ct1 < nbr_ents; ct1 += 1) {
+		sep_lli[ct1].bus_address = (u32)sep_map[ct1].dma_addr;
+
+		/* Maximum for page is total data size */
+		if (sep_map[ct1].size > data_size)
+			sep_map[ct1].size = data_size;
+
+		sep_lli[ct1].block_size = (u32)sep_map[ct1].size;
+	}
+
+	*llis = sep_lli;
+	return nbr_ents;
+}
+
+/**
  *	sep_lock_kernel_pages - map kernel pages for DMA
  *	@sep: pointer to struct sep_device
  *	@kernel_virt_addr: address of data buffer in kernel
@@ -985,66 +1406,58 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 	int in_out_flag)
 
 {
-	int error = 0;
+	u32 num_pages;
+	struct scatterlist *sg;
+
 	/* Array of lli */
 	struct sep_lli_entry *lli_array;
 	/* Map array */
 	struct sep_dma_map *map_array;
 
-	dev_dbg(&sep->pdev->dev, "lock kernel pages kernel_virt_addr is %08lx\n",
-				(unsigned long)kernel_virt_addr);
-	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
+	enum dma_data_direction direction;
 
-	lli_array = kmalloc(sizeof(struct sep_lli_entry), GFP_ATOMIC);
-	if (!lli_array) {
-		error = -ENOMEM;
-		goto end_function;
-	}
-	map_array = kmalloc(sizeof(struct sep_dma_map), GFP_ATOMIC);
-	if (!map_array) {
-		error = -ENOMEM;
-		goto end_function_with_error;
-	}
+	lli_array = NULL;
+	map_array = NULL;
 
-	map_array[0].dma_addr =
-		dma_map_single(&sep->pdev->dev, (void *)kernel_virt_addr,
-		data_size, DMA_BIDIRECTIONAL);
-	map_array[0].size = data_size;
+	if (in_out_flag == SEP_DRIVER_IN_FLAG) {
+		direction = DMA_TO_DEVICE;
+		sg = sep->src_sg;
+	} else {
+		direction = DMA_FROM_DEVICE;
+		sg = sep->dst_sg;
+	}
 
+	num_pages = sep_crypto_lli(sep, sg, &map_array, &lli_array,
+		data_size, direction);
 
-	/*
-	 * Set the start address of the first page - app data may start not at
-	 * the beginning of the page
-	 */
-	lli_array[0].bus_address = (u32)map_array[0].dma_addr;
-	lli_array[0].block_size = map_array[0].size;
+	if (num_pages <= 0) {
+		dev_dbg(&sep->pdev->dev, "sep_crypto_lli returned error %x\n",
+			num_pages);
+		return -ENOMEM;
+	}
 
-	dev_dbg(&sep->pdev->dev,
-	"lli_array[0].bus_address is %08lx, lli_array[0].block_size is %x\n",
-		(unsigned long)lli_array[0].bus_address,
-		lli_array[0].block_size);
+	/* Put mapped kernel sg into kernel resource array */
 
 	/* Set the output parameters */
 	if (in_out_flag == SEP_DRIVER_IN_FLAG) {
 		*lli_array_ptr = lli_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = 1;
+		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = num_pages;
 		sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = NULL;
 		sep->dma_res_arr[sep->nr_dcb_creat].in_map_array = map_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].in_map_num_entries = 1;
+		sep->dma_res_arr[sep->nr_dcb_creat].in_map_num_entries =
+			num_pages;
+		sep->dma_res_arr[sep->nr_dcb_creat].src_sg = sep->src_sg;
 	} else {
 		*lli_array_ptr = lli_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages = 1;
+		sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages = num_pages;
 		sep->dma_res_arr[sep->nr_dcb_creat].out_page_array = NULL;
 		sep->dma_res_arr[sep->nr_dcb_creat].out_map_array = map_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].out_map_num_entries = 1;
+		sep->dma_res_arr[sep->nr_dcb_creat].out_map_num_entries =
+			num_pages;
+		sep->dma_res_arr[sep->nr_dcb_creat].dst_sg = sep->dst_sg;
 	}
-	goto end_function;
-
-end_function_with_error:
-	kfree(lli_array);
 
-end_function:
-	return error;
+	return 0;
 }
 
 /**
@@ -1090,11 +1503,13 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	start_page = app_virt_addr >> PAGE_SHIFT;
 	num_pages = end_page - start_page + 1;
 
-	dev_dbg(&sep->pdev->dev, "lock user pages app_virt_addr is %x\n", app_virt_addr);
-	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
-	dev_dbg(&sep->pdev->dev, "start_page is %x\n", start_page);
-	dev_dbg(&sep->pdev->dev, "end_page is %x\n", end_page);
-	dev_dbg(&sep->pdev->dev, "num_pages is %x\n", num_pages);
+	dev_dbg(&sep->pdev->dev, "lock user pages app_virt_addr is %x\n",
+		app_virt_addr);
+
+	dev_dbg(&sep->pdev->dev, "data_size is (hex) %x\n", data_size);
+	dev_dbg(&sep->pdev->dev, "start_page is (hex) %x\n", start_page);
+	dev_dbg(&sep->pdev->dev, "end_page is (hex) %x\n", end_page);
+	dev_dbg(&sep->pdev->dev, "num_pages is (hex) %x\n", num_pages);
 
 	/* Allocate array of pages structure pointers */
 	page_array = kmalloc(sizeof(struct page *) * num_pages, GFP_ATOMIC);
@@ -1159,7 +1574,9 @@ static int sep_lock_user_pages(struct sep_device *sep,
 		lli_array[count].bus_address = (u32)map_array[count].dma_addr;
 		lli_array[count].block_size = PAGE_SIZE;
 
-		dev_warn(&sep->pdev->dev, "lli_array[%x].bus_address is %08lx, lli_array[%x].block_size is %x\n",
+		dev_dbg(&sep->pdev->dev,
+			"lli_array[%x].bus_address is %08lx, "
+			"lli_array[%x].block_size is (hex) %x\n",
 			count, (unsigned long)lli_array[count].bus_address,
 			count, lli_array[count].block_size);
 	}
@@ -1176,7 +1593,9 @@ static int sep_lock_user_pages(struct sep_device *sep,
 			PAGE_SIZE - (app_virt_addr & (~PAGE_MASK));
 
 	dev_dbg(&sep->pdev->dev,
-		"lli_array[0].bus_address is %08lx, lli_array[0].block_size is %x\n",
+		"After check if page 0 has all data\n"
+		"lli_array[0].bus_address is (hex) %08lx, "
+		"lli_array[0].block_size is (hex) %x\n",
 		(unsigned long)lli_array[count].bus_address,
 		lli_array[count].block_size);
 
@@ -1185,9 +1604,10 @@ static int sep_lock_user_pages(struct sep_device *sep,
 		lli_array[num_pages - 1].block_size =
 			(app_virt_addr + data_size) & (~PAGE_MASK);
 
-		dev_warn(&sep->pdev->dev,
-			"lli_array[%x].bus_address is %08lx, lli_array[%x].block_size is %x\n",
-			num_pages - 1,
+		dev_dbg(&sep->pdev->dev,
+			"After last page size adjustment\n"
+			"lli_array[%x].bus_address is (hex) %08lx, "
+			"lli_array[%x].block_size is (hex) %x\n", num_pages - 1,
 			(unsigned long)lli_array[count].bus_address,
 			num_pages - 1,
 			lli_array[count].block_size);
@@ -1201,6 +1621,7 @@ static int sep_lock_user_pages(struct sep_device *sep,
 		sep->dma_res_arr[sep->nr_dcb_creat].in_map_array = map_array;
 		sep->dma_res_arr[sep->nr_dcb_creat].in_map_num_entries =
 								num_pages;
+		sep->dma_res_arr[sep->nr_dcb_creat].src_sg = NULL;
 	} else {
 		*lli_array_ptr = lli_array;
 		sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages = num_pages;
@@ -1209,6 +1630,7 @@ static int sep_lock_user_pages(struct sep_device *sep,
 		sep->dma_res_arr[sep->nr_dcb_creat].out_map_array = map_array;
 		sep->dma_res_arr[sep->nr_dcb_creat].out_map_num_entries =
 								num_pages;
+		sep->dma_res_arr[sep->nr_dcb_creat].dst_sg = NULL;
 	}
 	goto end_function;
 
@@ -1327,7 +1749,8 @@ static void sep_build_lli_table(struct sep_device *sep,
 	array_counter = 0;
 	*num_table_entries_ptr = 1;
 
-	dev_dbg(&sep->pdev->dev, "build lli table table_data_size is %x\n", table_data_size);
+	dev_dbg(&sep->pdev->dev, "build lli table table_data_size: (hex) %x\n",
+		table_data_size);
 
 	/* Fill the table till table size reaches the needed amount */
 	while (curr_table_data_size < table_data_size) {
@@ -1344,9 +1767,9 @@ static void sep_build_lli_table(struct sep_device *sep,
 
 		dev_dbg(&sep->pdev->dev, "lli_table_ptr is %p\n",
 								lli_table_ptr);
-		dev_dbg(&sep->pdev->dev, "lli_table_ptr->bus_address is %08lx\n",
+		dev_dbg(&sep->pdev->dev, "lli_table_ptr->bus_address: %08lx\n",
 				(unsigned long)lli_table_ptr->bus_address);
-		dev_dbg(&sep->pdev->dev, "lli_table_ptr->block_size is %x\n",
+		dev_dbg(&sep->pdev->dev, "lli_table_ptr->block_size is (hex) %x\n",
 			lli_table_ptr->block_size);
 
 		/* Check for overflow of the table data */
@@ -1373,7 +1796,7 @@ static void sep_build_lli_table(struct sep_device *sep,
 			"lli_table_ptr->bus_address is %08lx\n",
 				(unsigned long)lli_table_ptr->bus_address);
 		dev_dbg(&sep->pdev->dev,
-			"lli_table_ptr->block_size is %x\n",
+			"lli_table_ptr->block_size is (hex) %x\n",
 			lli_table_ptr->block_size);
 
 		/* Move to the next entry in table */
@@ -1487,7 +1910,8 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 		dev_dbg(&sep->pdev->dev,
 			"phys table_data_size is %lu num_table_entries is"
 			" %lu bus_address is%lu\n", table_data_size,
-			num_table_entries, (unsigned long)lli_table_ptr->bus_address);
+			num_table_entries,
+			(unsigned long)lli_table_ptr->bus_address);
 
 		if ((unsigned long)lli_table_ptr->bus_address != 0xffffffff)
 			lli_table_ptr = (struct sep_lli_entry *)
@@ -1560,7 +1984,7 @@ static void sep_prepare_empty_lli_table(struct sep_device *sep,
  *	Note that all bus addresses that are passed to the SEP
  *	are in 32 bit format; the SEP is a 32 bit device
  */
-static int sep_prepare_input_dma_table(struct sep_device *sep,
+int sep_prepare_input_dma_table(struct sep_device *sep,
 	unsigned long app_virt_addr,
 	u32 data_size,
 	u32 block_size,
@@ -1589,7 +2013,9 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 	/* Next table address */
 	void *lli_table_alloc_addr = 0;
 
-	dev_dbg(&sep->pdev->dev, "prepare intput dma table data_size is %x\n", data_size);
+	dev_dbg(&sep->pdev->dev, "prepare intput dma table data_size is %x\n",
+		data_size);
+
 	dev_dbg(&sep->pdev->dev, "block_size is %x\n", block_size);
 
 	/* Initialize the pages pointers */
@@ -1633,7 +2059,7 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 
 	sep_lli_entries = sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages;
 
-	/* Loop till all the entries in in array are not processed */
+	/* Loop till all the entries in in array are processed */
 	while (current_entry < sep_lli_entries) {
 
 		/* Set the new input and output tables */
@@ -1980,7 +2406,7 @@ static int sep_construct_dma_tables_from_lli(
  *	Note that all bus addresses that are passed to the SEP
  *	are in 32 bit format; the SEP is a 32 bit device
  */
-static int sep_prepare_input_output_dma_table(struct sep_device *sep,
+int sep_prepare_input_output_dma_table(struct sep_device *sep,
 	unsigned long app_virt_in_addr,
 	unsigned long app_virt_out_addr,
 	u32 data_size,
@@ -2031,6 +2457,7 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 		if (error) {
 			dev_warn(&sep->pdev->dev,
 				"lock kernel for out failed\n");
+			kfree(lli_in_array);
 			goto end_function;
 		}
 	}
@@ -2117,7 +2544,7 @@ end_function:
  *	Note that all bus addresses that are passed to the SEP
  *	are in 32 bit format; the SEP is a 32 bit device
  */
-static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
+int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	unsigned long  app_in_address,
 	unsigned long  app_out_address,
 	u32  data_in_size,
@@ -2144,7 +2571,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 
 	if (sep->nr_dcb_creat == SEP_MAX_NUM_SYNC_DMA_OPS) {
 		/* No more DCBs to allocate */
-		dev_warn(&sep->pdev->dev, "no more DCBs available\n");
+		dev_dbg(&sep->pdev->dev, "no more DCBs available\n");
 		error = -ENOSPC;
 		goto end_function;
 	}
@@ -2185,7 +2612,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 			/* Set the output user-space address for mem2mem op */
 			if (app_out_address)
 				dcb_table_ptr->out_vr_tail_pt =
-							(aligned_u64)app_out_address;
+					(aligned_u64)app_out_address;
 
 			/*
 			 * Update both data length parameters in order to avoid
@@ -2226,8 +2653,8 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 				 * according to tail data size
 				 */
 				dcb_table_ptr->out_vr_tail_pt =
-					(aligned_u64)app_out_address + data_in_size
-					- tail_size;
+					(aligned_u64)app_out_address +
+					data_in_size - tail_size;
 
 			/* Save the real tail data size */
 			dcb_table_ptr->tail_data_size = tail_size;
@@ -2342,7 +2769,7 @@ end_function:
  *
  *	This function frees the DMA tables and DCB
  */
-static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
+int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 	bool is_kva)
 {
 	int i = 0;
@@ -2478,7 +2905,7 @@ static u32 sep_check_sum_calc(u8 *data, u32 length)
  */
 static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 {
-	u32 message_buff[14];
+	static u32 message_buff[14];
 	u32 counter;
 	int error = 0;
 	u32 reg_val;
@@ -2532,7 +2959,7 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 	error = sep_load_firmware(sep);
 
 	if (error) {
-		dev_warn(&sep->pdev->dev,
+		dev_dbg(&sep->pdev->dev,
 			"init; copy SEP init message failed %x\n", error);
 		goto end_function;
 	}
@@ -2789,8 +3216,8 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	if ((current->pid != sep->pid_doing_transaction) &&
 				(sep->pid_doing_transaction != 0)) {
 		dev_dbg(&sep->pdev->dev, "ioctl pid is not owner\n");
-		error = -EACCES;
-		goto end_function;
+		mutex_unlock(&sep->sep_mutex);
+		return -EACCES;
 	}
 
 	mutex_unlock(&sep->sep_mutex);
@@ -2859,7 +3286,6 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		break;
 	}
 
-end_function:
 	mutex_unlock(&sep->ioctl_mutex);
 	return error;
 }
@@ -2962,6 +3388,8 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
 	/* Read the IRR register to check if this is SEP interrupt */
 	reg_val = sep_read_reg(sep, HW_HOST_IRR_REG_ADDR);
 
+	dev_dbg(&sep->pdev->dev, "sep int: IRR REG val: %x\n", reg_val);
+
 	if (reg_val & (0x1 << 13)) {
 		/* Lock and update the counter of reply messages */
 		spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
@@ -2971,10 +3399,16 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
 		dev_dbg(&sep->pdev->dev, "sep int: send_ct %lx reply_ct %lx\n",
 					sep->send_ct, sep->reply_ct);
 
+		/* Is this a kernel client request */
+		if (sep->in_kernel) {
+			tasklet_schedule(&sep->finish_tasklet);
+			goto finished_interrupt;
+		}
+
 		/* Is this printf or daemon request? */
 		reg_val2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
 		dev_dbg(&sep->pdev->dev,
-			"SEP Interrupt - reg2 is %08x\n", reg_val2);
+			"SEP Interrupt - GPR2 is %08x\n", reg_val2);
 
 		if ((reg_val2 >> 30) & 0x1) {
 			dev_dbg(&sep->pdev->dev, "int: printf request\n");
@@ -2990,6 +3424,8 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
 		dev_dbg(&sep->pdev->dev, "int: not SEP interrupt\n");
 		int_error = IRQ_NONE;
 	}
+
+finished_interrupt:
 	if (int_error == IRQ_HANDLED)
 		sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, reg_val);
 
@@ -3167,6 +3603,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	spin_lock_init(&sep->snd_rply_lck);
 	mutex_init(&sep->sep_mutex);
 	mutex_init(&sep->ioctl_mutex);
+	mutex_init(&sep->tasklet_mutex);
 
 	dev_dbg(&sep->pdev->dev, "sep probe: PCI obtained, device being prepared\n");
 	dev_dbg(&sep->pdev->dev, "revision is %d\n", sep->pdev->revision);
-- 
1.6.3.3

