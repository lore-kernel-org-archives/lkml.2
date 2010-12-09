Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab0LIRZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:25:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:59307 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab0LIRZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:25:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="685558350"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, dmitry.kasatkin@nokia.com
Subject: [PATCH 09/11] sep: reduce 64 and 32 bit compile warnings
Date: Thu,  9 Dec 2010 09:32:26 -0800
Message-Id: <1291915946-18620-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c |  101 +++++++++++++++-----------------------
 1 files changed, 40 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 83475eb..903d610 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -91,7 +91,7 @@ static int sep_load_firmware(struct sep_device *sep)
 	char *res_name = "resident.image.bin";
 	char *extapp_name = "extapp.image.bin";
 	int error ;
-	unsigned int work1, work2, work3;
+	unsigned long work1, work2, work3;
 
 	/* Set addresses and load resident */
 	sep->resident_bus = sep->rar_bus;
@@ -115,13 +115,13 @@ static int sep_load_firmware(struct sep_device *sep)
 		sep->resident_size);
 
 	/* Set addresses for dcache (no loading needed) */
-	work1 = (unsigned int)sep->resident_bus;
-	work2 = (unsigned int)sep->resident_size;
+	work1 = (unsigned long)sep->resident_bus;
+	work2 = (unsigned long)sep->resident_size;
 	work3 = (work1 + work2 + (1024 * 4)) & 0xfffff000;
 	sep->dcache_bus = (dma_addr_t)work3;
 
-	work1 = (unsigned int)sep->resident_addr;
-	work2 = (unsigned int)sep->resident_size;
+	work1 = (unsigned long)sep->resident_addr;
+	work2 = (unsigned long)sep->resident_size;
 	work3 = (work1 + work2 + (1024 * 4)) & 0xfffff000;
 	sep->dcache_addr = (void *)work3;
 
@@ -831,7 +831,7 @@ static unsigned long sep_set_time(struct sep_device *sep)
  *	Inserts the data into the caller id table. Note that this function
  *	falls under the ioctl lock
  */
-static int sep_set_caller_id_handler(struct sep_device *sep, u32 arg)
+static int sep_set_caller_id_handler(struct sep_device *sep, unsigned long arg)
 {
 	void __user *hash;
 	int   error = 0;
@@ -1063,7 +1063,7 @@ end_function:
  *	the kernel (when ioctl is not used)
  */
 static int sep_lock_kernel_pages(struct sep_device *sep,
-	u32 kernel_virt_addr,
+	unsigned long kernel_virt_addr,
 	u32 data_size,
 	struct sep_lli_entry **lli_array_ptr,
 	int in_out_flag)
@@ -1076,8 +1076,8 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 	struct sep_dma_map *map_array;
 
 	dev_dbg(&sep->pdev->dev, "sep_lock_kernel_pages start\n");
-	dev_dbg(&sep->pdev->dev, "kernel_virt_addr is %08x\n",
-							kernel_virt_addr);
+	dev_dbg(&sep->pdev->dev, "kernel_virt_addr is %08lx\n",
+				(unsigned long)kernel_virt_addr);
 	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
 
 	lli_array = kmalloc(sizeof(struct sep_lli_entry), GFP_ATOMIC);
@@ -1530,8 +1530,8 @@ static dma_addr_t sep_shared_area_virt_to_bus(struct sep_device *sep,
 static void *sep_shared_area_bus_to_virt(struct sep_device *sep,
 	dma_addr_t bus_address)
 {
-	dev_dbg(&sep->pdev->dev, "shared bus to virt b=%x v=%x\n",
-		(u32)bus_address, (u32)(sep->shared_addr +
+	dev_dbg(&sep->pdev->dev, "shared bus to virt b=%lx v=%lx\n",
+		(unsigned long)bus_address, (unsigned long)(sep->shared_addr +
 			(size_t)(bus_address - sep->shared_bus)));
 
 	return sep->shared_addr	+ (size_t)(bus_address - sep->shared_bus);
@@ -1556,7 +1556,7 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 
 	dev_dbg(&sep->pdev->dev, "sep_debug_print_lli_tables start\n");
 
-	while ((unsigned long) lli_table_ptr != 0xffffffff) {
+	while ((unsigned long) lli_table_ptr->bus_address != 0xffffffff) {
 		dev_dbg(&sep->pdev->dev,
 			"lli table %08lx, table_data_size is %lu\n",
 			table_count, table_data_size);
@@ -1590,18 +1590,16 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 
 		table_data_size = lli_table_ptr->block_size & 0xffffff;
 		num_table_entries = (lli_table_ptr->block_size >> 24) & 0xff;
-		lli_table_ptr = (struct sep_lli_entry *)
-			(lli_table_ptr->bus_address);
 
 		dev_dbg(&sep->pdev->dev,
 			"phys table_data_size is %lu num_table_entries is"
-			" %lu lli_table_ptr is%lu\n", table_data_size,
-			num_table_entries, (unsigned long)lli_table_ptr);
+			" %lu bus_address is%lu\n", table_data_size,
+			num_table_entries, (unsigned long)lli_table_ptr->bus_address);
 
-		if ((unsigned long)lli_table_ptr != 0xffffffff)
+		if ((unsigned long)lli_table_ptr->bus_address != 0xffffffff)
 			lli_table_ptr = (struct sep_lli_entry *)
 				sep_shared_bus_to_virt(sep,
-				(unsigned long)lli_table_ptr);
+				(unsigned long)lli_table_ptr->bus_address);
 
 		table_count++;
 	}
@@ -1701,7 +1699,7 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 	/* Number of entries in lli table */
 	u32 num_entries_in_table = 0;
 	/* Next table address */
-	u32 lli_table_alloc_addr = 0;
+	void *lli_table_alloc_addr = 0;
 
 	dev_dbg(&sep->pdev->dev, "sep_prepare_input_dma_table start\n");
 	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
@@ -1712,7 +1710,7 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 	sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = 0;
 
 	/* Set the kernel address for first table to be allocated */
-	lli_table_alloc_addr = (u32)(sep->shared_addr +
+	lli_table_alloc_addr = (void *)(sep->shared_addr +
 		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
 		sep->num_lli_tables_created * sizeof(struct sep_lli_entry) *
 		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
@@ -1759,7 +1757,7 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
 
 		if (lli_table_alloc_addr >
-			((u32)sep->shared_addr +
+			((void *)sep->shared_addr +
 			SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
 			SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
 
@@ -1874,7 +1872,7 @@ static int sep_construct_dma_tables_from_lli(
 	u32	*table_data_size_ptr)
 {
 	/* Points to the area where next lli table can be allocated */
-	u32 lli_table_alloc_addr = 0;
+	void *lli_table_alloc_addr = 0;
 	/* Input lli table */
 	struct sep_lli_entry *in_lli_table_ptr = NULL;
 	/* Output lli table */
@@ -1903,7 +1901,7 @@ static int sep_construct_dma_tables_from_lli(
 	dev_dbg(&sep->pdev->dev, "sep_construct_dma_tables_from_lli start\n");
 
 	/* Initiate to point after the message area */
-	lli_table_alloc_addr = (u32)(sep->shared_addr +
+	lli_table_alloc_addr = (void *)(sep->shared_addr +
 		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
 		(sep->num_lli_tables_created *
 		(sizeof(struct sep_lli_entry) *
@@ -1925,7 +1923,7 @@ static int sep_construct_dma_tables_from_lli(
 		/* Check if the DMA table area limit was overrun */
 		if ((lli_table_alloc_addr + sizeof(struct sep_lli_entry) *
 			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP) >
-			((u32)sep->shared_addr +
+			((void *)sep->shared_addr +
 			SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
 			SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
 
@@ -2251,13 +2249,13 @@ end_function:
  *	are in 32 bit format; the SEP is a 32 bit device
  */
 static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
-	u32  app_in_address,
-	u32  app_out_address,
-	u32              data_in_size,
-	u32              block_size,
-	u32              tail_block_size,
-	bool            isapplet,
-	bool		is_kva)
+	unsigned long  app_in_address,
+	unsigned long  app_out_address,
+	u32  data_in_size,
+	u32  block_size,
+	u32  tail_block_size,
+	bool isapplet,
+	bool	is_kva)
 {
 	int error = 0;
 	/* Size of tail */
@@ -2366,7 +2364,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 				 * according to tail data size
 				 */
 				dcb_table_ptr->out_vr_tail_pt =
-					app_out_address + data_in_size
+					(u32)app_out_address + data_in_size
 					- tail_size;
 
 			/* Save the real tail data size */
@@ -2467,8 +2465,8 @@ static int sep_create_sync_dma_tables_handler(struct sep_device *sep,
 	}
 
 	error = sep_prepare_input_output_dma_table_in_dcb(sep,
-		command_args.app_in_address,
-		command_args.app_out_address,
+		(unsigned long)command_args.app_in_address,
+		(unsigned long)command_args.app_out_address,
 		command_args.data_in_size,
 		command_args.block_size,
 		0x0,
@@ -2495,6 +2493,8 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 	int error = 0;
 	int error_temp = 0;
 	struct sep_dcblock *dcb_table_ptr;
+	unsigned long pt_hold;
+	void *tail_pt;
 
 	dev_dbg(&sep->pdev->dev, "sep_free_dma_tables_and_dcb start\n");
 
@@ -2507,13 +2507,15 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 		/* Go over each DCB and see if tail pointer must be updated */
 		for (i = 0; i < sep->nr_dcb_creat; i++, dcb_table_ptr++) {
 			if (dcb_table_ptr->out_vr_tail_pt) {
+				pt_hold = (unsigned long)dcb_table_ptr->out_vr_tail_pt;
+				tail_pt = (void *)pt_hold;
 				if (is_kva == true) {
-					memcpy((void *)dcb_table_ptr->out_vr_tail_pt,
+					memcpy(tail_pt,
 						dcb_table_ptr->tail_data,
 						dcb_table_ptr->tail_data_size);
 				} else {
 					error_temp = copy_to_user(
-						(void *)dcb_table_ptr->out_vr_tail_pt,
+						tail_pt,
 						dcb_table_ptr->tail_data,
 						dcb_table_ptr->tail_data_size);
 				}
@@ -2841,7 +2843,8 @@ static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg)
 						command_args.tail_block_size);
 
 	error = sep_prepare_input_output_dma_table_in_dcb(sep,
-		command_args.app_in_address, command_args.app_out_address,
+		(unsigned long)command_args.app_in_address,
+		(unsigned long)command_args.app_out_address,
 		command_args.data_in_size, command_args.block_size,
 		command_args.tail_block_size, true, false);
 
@@ -2971,30 +2974,6 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	dev_dbg(&sep->pdev->dev, "ioctl start\n");
 
 	dev_dbg(&sep->pdev->dev, "cmd is %x\n", cmd);
-	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCSENDSEPCOMMAND is %x\n", SEP_IOCSENDSEPCOMMAND);
-	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCALLOCDATAPOLL is %x\n", SEP_IOCALLOCDATAPOLL);
-	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCCREATESYMDMATABLE is %x\n", SEP_IOCCREATESYMDMATABLE);
-	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCFREEDMATABLEDATA is %x\n", SEP_IOCFREEDMATABLEDATA);
-	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCSEPSTART is %x\n", SEP_IOCSEPSTART);
-	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCSEPINIT is %x\n", SEP_IOCSEPINIT);
-	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCGETSTATICPOOLADDR is %x\n", SEP_IOCGETSTATICPOOLADDR);
-	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCENDTRANSACTION is %x\n", SEP_IOCENDTRANSACTION);
-	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCREALLOCEXTCACHE is %x\n", SEP_IOCREALLOCEXTCACHE);
-	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCRARPREPAREMESSAGE is %x\n", SEP_IOCRARPREPAREMESSAGE);
-	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCPREPAREDCB is %x\n", SEP_IOCPREPAREDCB);
-	dev_dbg(&sep->pdev->dev,
-		"SEP_IOCFREEDCB is %x\n", SEP_IOCFREEDCB);
 
 	/* Make sure we own this device */
 	mutex_lock(&sep->sep_mutex);
-- 
1.6.3.3

