Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303Ab2BJNjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:39:15 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42049 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759277Ab2BJNjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:39:00 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/6] sep: Basic infrastructure for SEP DMA access to non CPU
 regions
To: greg@kroah.com, linux-kernel@vger.kernel.org, mark.a.allyn@intel.com
Date: Fri, 10 Feb 2012 13:52:42 +0000
Message-ID: <20120210135238.12442.4050.stgit@bob.linux.org.uk>
In-Reply-To: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
References: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark A. Allyn <mark.a.allyn@intel.com>

[This is picked out of the differences between the upstream driver and
 the staging driver. I'm resolving the differences as a series of updates -AC]

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver_api.h |   15 ++
 drivers/staging/sep/sep_main.c       |  233 ++++++++++++++++++++++++++++++----
 2 files changed, 223 insertions(+), 25 deletions(-)


diff --git a/drivers/staging/sep/sep_driver_api.h b/drivers/staging/sep/sep_driver_api.h
index 78a4b69..8b797d5 100644
--- a/drivers/staging/sep/sep_driver_api.h
+++ b/drivers/staging/sep/sep_driver_api.h
@@ -61,7 +61,9 @@ enum hash_stage {
 	HASH_INIT,
 	HASH_UPDATE,
 	HASH_FINISH,
-	HASH_DIGEST
+	HASH_DIGEST,
+	HASH_FINUP_DATA,
+	HASH_FINUP_FINISH
 };
 
 /*
@@ -205,6 +207,7 @@ struct sep_lli_entry {
  */
 struct sep_fastcall_hdr {
 	u32 magic;
+	u32 secure_dma;
 	u32 msg_len;
 	u32 num_dcbs;
 };
@@ -231,6 +234,8 @@ struct sep_dma_context {
 	u32 dmatables_len;
 	/* size of input data */
 	u32 input_data_len;
+	/* secure dma use (for imr memory restriced area in output */
+	bool secure_dma;
 	struct sep_dma_resource dma_res_arr[SEP_MAX_NUM_SYNC_DMA_OPS];
 	/* Scatter gather for kernel crypto */
 	struct scatterlist *src_sg;
@@ -317,6 +322,7 @@ ssize_t sep_activate_dcb_dmatables_context(struct sep_device *sep,
  * @tail_block_size: u32; for size of tail block
  * @isapplet: bool; to indicate external app
  * @is_kva: bool; kernel buffer; only used for kernel crypto module
+ * @secure_dma; indicates whether this is secure_dma using IMR
  *
  * This function prepares the linked DMA tables and puts the
  * address for the linked list of tables inta a DCB (data control
@@ -332,6 +338,7 @@ int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	u32  tail_block_size,
 	bool isapplet,
 	bool	is_kva,
+	bool    secure_dma,
 	struct sep_dcblock *dcb_region,
 	void **dmatables_region,
 	struct sep_dma_context **dma_ctx,
@@ -386,4 +393,10 @@ int sep_wait_transaction(struct sep_device *sep);
 
 struct sep_device;
 
+#define SEP_IOCPREPAREDCB_SECURE_DMA	\
+	_IOW(SEP_IOC_MAGIC_NUMBER, 38, struct build_dcb_struct)
+
+#define SEP_IOCFREEDCB_SECURE_DMA	\
+	_IO(SEP_IOC_MAGIC_NUMBER, 39)
+
 #endif
diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 421a2b1..7d7cb48 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -485,8 +485,15 @@ int sep_free_dma_table_data_handler(struct sep_device *sep,
 			kfree(dma->in_map_array);
 		}
 
-		/* Unmap output map array, DON'T free it yet */
-		if (dma->out_map_array) {
+		/**
+		 * Output is handled different. If
+		 * this was a secure dma into restricted memory,
+		 * then we skip this step altogether as restricted
+		 * memory is not available to the o/s at all.
+		 */
+		if (((*dma_ctx)->secure_dma == false) &&
+			(dma->out_map_array)) {
+
 			for (count = 0; count < dma->out_num_pages; count++) {
 				dma_unmap_page(&sep->pdev->dev,
 					dma->out_map_array[count].dma_addr,
@@ -505,7 +512,10 @@ int sep_free_dma_table_data_handler(struct sep_device *sep,
 			kfree(dma->in_page_array);
 		}
 
-		if (dma->out_page_array) {
+		/* Again, we do this only for non secure dma */
+		if (((*dma_ctx)->secure_dma == false) &&
+			(dma->out_page_array)) {
+
 			for (count = 0; count < dma->out_num_pages; count++) {
 				if (!PageReserved(dma->out_page_array[count]))
 
@@ -1383,6 +1393,128 @@ end_function:
 }
 
 /**
+ *	sep_lli_table_secure_dma - get lli array for IMR addresses
+ *	@sep: pointer to struct sep_device
+ *	@app_virt_addr: user memory data buffer
+ *	@data_size: size of data buffer
+ *	@lli_array_ptr: lli array
+ *	@in_out_flag: not used
+ *	@dma_ctx: pointer to struct sep_dma_context
+ *
+ *	This function creates lli tables for outputting data to
+ *	IMR memory, which is memory that cannot be accessed by the
+ *	the x86 processor.
+ */
+static int sep_lli_table_secure_dma(struct sep_device *sep,
+	u32 app_virt_addr,
+	u32 data_size,
+	struct sep_lli_entry **lli_array_ptr,
+	int in_out_flag,
+	struct sep_dma_context *dma_ctx)
+
+{
+	int error = 0;
+	u32 count;
+	/* The the page of the end address of the user space buffer */
+	u32 end_page;
+	/* The page of the start address of the user space buffer */
+	u32 start_page;
+	/* The range in pages */
+	u32 num_pages;
+	/* Array of lli */
+	struct sep_lli_entry *lli_array;
+
+	/* Set start and end pages  and num pages */
+	end_page = (app_virt_addr + data_size - 1) >> PAGE_SHIFT;
+	start_page = app_virt_addr >> PAGE_SHIFT;
+	num_pages = end_page - start_page + 1;
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] lock user pages"
+		" app_virt_addr is %x\n", current->pid, app_virt_addr);
+
+	dev_dbg(&sep->pdev->dev, "[PID%d] data_size is (hex) %x\n",
+		current->pid, data_size);
+	dev_dbg(&sep->pdev->dev, "[PID%d] start_page is (hex) %x\n",
+		current->pid, start_page);
+	dev_dbg(&sep->pdev->dev, "[PID%d] end_page is (hex) %x\n",
+		current->pid, end_page);
+	dev_dbg(&sep->pdev->dev, "[PID%d] num_pages is (hex) %x\n",
+		current->pid, num_pages);
+
+	lli_array = kmalloc(sizeof(struct sep_lli_entry) * num_pages,
+		GFP_ATOMIC);
+
+	if (!lli_array) {
+		dev_warn(&sep->pdev->dev,
+			"[PID%d] kmalloc for lli_array failed\n",
+			current->pid);
+		return -ENOMEM;
+	}
+
+	/*
+	 * Fill the lli_array
+	 */
+	start_page = start_page << PAGE_SHIFT;
+	for (count = 0; count < num_pages; count++) {
+		/* Fill the lli array entry */
+		lli_array[count].bus_address = start_page;
+		lli_array[count].block_size = PAGE_SIZE;
+
+		start_page += PAGE_SIZE;
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] lli_array[%x].bus_address is %08lx, "
+			"lli_array[%x].block_size is (hex) %x\n",
+			current->pid,
+			count, (unsigned long)lli_array[count].bus_address,
+			count, lli_array[count].block_size);
+	}
+
+	/* Check the offset for the first page */
+	lli_array[0].bus_address =
+		lli_array[0].bus_address + (app_virt_addr & (~PAGE_MASK));
+
+	/* Check that not all the data is in the first page only */
+	if ((PAGE_SIZE - (app_virt_addr & (~PAGE_MASK))) >= data_size)
+		lli_array[0].block_size = data_size;
+	else
+		lli_array[0].block_size =
+			PAGE_SIZE - (app_virt_addr & (~PAGE_MASK));
+
+	dev_dbg(&sep->pdev->dev,
+		"[PID%d] After check if page 0 has all data\n"
+		"lli_array[0].bus_address is (hex) %08lx, "
+		"lli_array[0].block_size is (hex) %x\n",
+		current->pid,
+		(unsigned long)lli_array[0].bus_address,
+		lli_array[0].block_size);
+
+	/* Check the size of the last page */
+	if (num_pages > 1) {
+		lli_array[num_pages - 1].block_size =
+			(app_virt_addr + data_size) & (~PAGE_MASK);
+		if (lli_array[num_pages - 1].block_size == 0)
+			lli_array[num_pages - 1].block_size = PAGE_SIZE;
+
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] After last page size adjustment\n"
+			"lli_array[%x].bus_address is (hex) %08lx, "
+			"lli_array[%x].block_size is (hex) %x\n",
+			current->pid, num_pages - 1,
+			(unsigned long)lli_array[num_pages - 1].bus_address,
+			num_pages - 1,
+			lli_array[num_pages - 1].block_size);
+	}
+	*lli_array_ptr = lli_array;
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_num_pages = num_pages;
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_page_array = NULL;
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_map_array = NULL;
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_map_num_entries = 0;
+
+	return error;
+}
+
+/**
  * sep_calculate_lli_table_max_size - size the LLI table
  * @sep: pointer to struct sep_device
  * @lli_in_array_ptr
@@ -1613,6 +1745,7 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 	unsigned long num_table_entries,
 	unsigned long table_data_size)
 {
+#ifdef DEBUG
 	unsigned long table_count = 1;
 	unsigned long entries_count = 0;
 
@@ -1686,6 +1819,7 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 	}
 	dev_dbg(&sep->pdev->dev, "[PID%d] sep_debug_print_lli_tables end\n",
 					current->pid);
+#endif
 }
 
 
@@ -1956,8 +2090,10 @@ update_dcb_counter:
 end_function_error:
 	/* Free all the allocated resources */
 	kfree(dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_map_array);
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_map_array = NULL;
 	kfree(lli_array_ptr);
 	kfree(dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_page_array);
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_page_array = NULL;
 
 end_function:
 	return error;
@@ -2360,20 +2496,42 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 			goto end_function;
 		}
 
-		dev_dbg(&sep->pdev->dev, "[PID%d] Locking user output pages\n",
+		if (dma_ctx->secure_dma == true) {
+			/* secure_dma requires use of non accessible memory */
+			dev_dbg(&sep->pdev->dev, "[PID%d] in secure_dma\n",
+				current->pid);
+			error = sep_lli_table_secure_dma(sep,
+				app_virt_out_addr, data_size, &lli_out_array,
+				SEP_DRIVER_OUT_FLAG, dma_ctx);
+			if (error) {
+				dev_warn(&sep->pdev->dev,
+					"[PID%d] secure dma table setup "
+					" for output virtual buffer failed\n",
+					current->pid);
+
+				goto end_function_free_lli_in;
+			}
+		} else {
+			/* For normal, non-secure dma */
+			dev_dbg(&sep->pdev->dev, "[PID%d] not in secure_dma\n",
 				current->pid);
 
-		error = sep_lock_user_pages(sep, app_virt_out_addr,
+			dev_dbg(&sep->pdev->dev,
+				"[PID%d] Locking user output pages\n",
+				current->pid);
+
+			error = sep_lock_user_pages(sep, app_virt_out_addr,
 				data_size, &lli_out_array, SEP_DRIVER_OUT_FLAG,
 				dma_ctx);
 
-		if (error) {
-			dev_warn(&sep->pdev->dev,
+			if (error) {
+				dev_warn(&sep->pdev->dev,
 					"[PID%d] sep_lock_user_pages"
 					" for output virtual buffer failed\n",
 					current->pid);
 
-			goto end_function_free_lli_in;
+				goto end_function_free_lli_in;
+			}
 		}
 	}
 
@@ -2421,13 +2579,17 @@ update_dcb_counter:
 
 end_function_with_error:
 	kfree(dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_map_array);
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_map_array = NULL;
 	kfree(dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_page_array);
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].out_page_array = NULL;
 	kfree(lli_out_array);
 
 
 end_function_free_lli_in:
 	kfree(dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_map_array);
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_map_array = NULL;
 	kfree(dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_page_array);
+	dma_ctx->dma_res_arr[dma_ctx->nr_dcb_creat].in_page_array = NULL;
 	kfree(lli_in_array);
 
 end_function:
@@ -2445,6 +2607,7 @@ end_function:
  * @tail_block_size: u32; for size of tail block
  * @isapplet: bool; to indicate external app
  * @is_kva: bool; kernel buffer; only used for kernel crypto module
+ * @secure_dma; indicates whether this is secure_dma using IMR
  *
  * This function prepares the linked DMA tables and puts the
  * address for the linked list of tables inta a DCB (data control
@@ -2460,6 +2623,7 @@ int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	u32  tail_block_size,
 	bool isapplet,
 	bool	is_kva,
+	bool	secure_dma,
 	struct sep_dcblock *dcb_region,
 	void **dmatables_region,
 	struct sep_dma_context **dma_ctx,
@@ -2534,6 +2698,8 @@ int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 			current->pid, *dma_ctx);
 	}
 
+	(*dma_ctx)->secure_dma = secure_dma;
+
 	/* these are for kernel crypto only */
 	(*dma_ctx)->src_sg = src_sg;
 	(*dma_ctx)->dst_sg = dst_sg;
@@ -2690,6 +2856,7 @@ int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 
 end_function_error:
 	kfree(*dma_ctx);
+	*dma_ctx = NULL;
 
 end_function:
 	return error;
@@ -2719,15 +2886,22 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 	dev_dbg(&sep->pdev->dev, "[PID%d] sep_free_dma_tables_and_dcb\n",
 					current->pid);
 
-	if (isapplet == true) {
+	if (((*dma_ctx)->secure_dma == false) && (isapplet == true)) {
+		dev_dbg(&sep->pdev->dev, "[PID%d] handling applet\n",
+			current->pid);
+
+		/* Tail stuff is only for non secure_dma */
 		/* Set pointer to first DCB table */
 		dcb_table_ptr = (struct sep_dcblock *)
 			(sep->shared_addr +
 			SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES);
 
-		/* Go over each DCB and see if tail pointer must be updated */
-		for (i = 0;
-		     i < (*dma_ctx)->nr_dcb_creat; i++, dcb_table_ptr++) {
+		/**
+		 * Go over each DCB and see if
+		 * tail pointer must be updated
+		 */
+		for (i = 0; dma_ctx && *dma_ctx &&
+			i < (*dma_ctx)->nr_dcb_creat; i++, dcb_table_ptr++) {
 			if (dcb_table_ptr->out_vr_tail_pt) {
 				pt_hold = (unsigned long)dcb_table_ptr->
 					out_vr_tail_pt;
@@ -2749,6 +2923,7 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 			}
 		}
 	}
+
 	/* Free the output pages, if any */
 	sep_free_dma_table_data_handler(sep, dma_ctx);
 
@@ -2762,11 +2937,13 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
  * sep_prepare_dcb_handler - prepare a control block
  * @sep: pointer to struct sep_device
  * @arg: pointer to user parameters
+ * @secure_dma: indicate whether we are using secure_dma on IMR
  *
  * This function will retrieve the RAR buffer physical addresses, type
  * & size corresponding to the RAR handles provided in the buffers vector.
  */
 static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg,
+				   bool secure_dma,
 				   struct sep_dma_context **dma_ctx)
 {
 	int error;
@@ -2812,7 +2989,7 @@ static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg,
 			command_args.data_in_size, command_args.block_size,
 			command_args.tail_block_size,
 			command_args.is_applet, false,
-			NULL, NULL, dma_ctx, NULL, NULL);
+			secure_dma, NULL, NULL, dma_ctx, NULL, NULL);
 
 end_function:
 	return error;
@@ -2829,21 +3006,18 @@ end_function:
 static int sep_free_dcb_handler(struct sep_device *sep,
 				struct sep_dma_context **dma_ctx)
 {
-	int error = 0;
-
 	if (!dma_ctx || !(*dma_ctx)) {
-		dev_dbg(&sep->pdev->dev, "[PID%d] no dma context defined, nothing to free\n",
+		dev_dbg(&sep->pdev->dev,
+			"[PID%d] no dma context defined, nothing to free\n",
 			current->pid);
-		return error;
+		return -EINVAL;
 	}
 
 	dev_dbg(&sep->pdev->dev, "[PID%d] free dcbs num of DCBs %x\n",
 		current->pid,
 		(*dma_ctx)->nr_dcb_creat);
 
-	error = sep_free_dma_tables_and_dcb(sep, false, false, dma_ctx);
-
-	return error;
+	return sep_free_dma_tables_and_dcb(sep, false, false, dma_ctx);
 }
 
 /**
@@ -2931,7 +3105,7 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto end_function;
 		}
 
-		error = sep_prepare_dcb_handler(sep, arg, dma_ctx);
+		error = sep_prepare_dcb_handler(sep, arg, false, dma_ctx);
 		dev_dbg(&sep->pdev->dev, "[PID%d] SEP_IOCPREPAREDCB end\n",
 			current->pid);
 		break;
@@ -3170,13 +3344,14 @@ end_function:
  *	@dma_ctx: DMA context buf to create for current transaction
  *	@user_dcb_args: User arguments for DCB/MLLI creation
  *	@num_dcbs: Number of DCBs to create
+ *	@secure_dma: Indicate use of IMR restricted memory secure dma
  */
 static ssize_t sep_create_dcb_dmatables_context(struct sep_device *sep,
 			struct sep_dcblock **dcb_region,
 			void **dmatables_region,
 			struct sep_dma_context **dma_ctx,
 			const struct build_dcb_struct __user *user_dcb_args,
-			const u32 num_dcbs)
+			const u32 num_dcbs, bool secure_dma)
 {
 	int error = 0;
 	int i = 0;
@@ -3231,7 +3406,7 @@ static ssize_t sep_create_dcb_dmatables_context(struct sep_device *sep,
 				dcb_args[i].block_size,
 				dcb_args[i].tail_block_size,
 				dcb_args[i].is_applet,
-				false,
+				false, secure_dma,
 				*dcb_region, dmatables_region,
 				dma_ctx,
 				NULL,
@@ -3242,6 +3417,9 @@ static ssize_t sep_create_dcb_dmatables_context(struct sep_device *sep,
 				 current->pid);
 			goto end_function;
 		}
+
+		if (dcb_args[i].app_in_address != 0)
+			(*dma_ctx)->input_data_len += dcb_args[i].data_in_size;
 	}
 
 end_function:
@@ -3311,6 +3489,7 @@ int sep_create_dcb_dmatables_context_kernel(struct sep_device *sep,
 				dcb_data->tail_block_size,
 				dcb_data->is_applet,
 				true,
+				false,
 				*dcb_region, dmatables_region,
 				dma_ctx,
 				dcb_data->src_sg,
@@ -3597,6 +3776,7 @@ static ssize_t sep_write(struct file *filp,
 	struct sep_dcblock *dcb_region = NULL;
 	ssize_t error = 0;
 	struct sep_queue_info *my_queue_elem = NULL;
+	bool my_secure_dma; /* are we using secure_dma (IMR)? */
 
 	dev_dbg(&sep->pdev->dev, "[PID%d] sep dev is 0x%p\n",
 		current->pid, sep);
@@ -3609,6 +3789,11 @@ static ssize_t sep_write(struct file *filp,
 
 	buf_user += sizeof(struct sep_fastcall_hdr);
 
+	if (call_hdr.secure_dma == 0)
+		my_secure_dma = false;
+	else
+		my_secure_dma = true;
+
 	/*
 	 * Controlling driver memory usage by limiting amount of
 	 * buffers created. Only SEP_DOUBLEBUF_USERS_LIMIT number
@@ -3636,7 +3821,7 @@ static ssize_t sep_write(struct file *filp,
 				&dma_ctx,
 				(const struct build_dcb_struct __user *)
 					buf_user,
-				call_hdr.num_dcbs);
+				call_hdr.num_dcbs, my_secure_dma);
 		if (error)
 			goto end_function_error_doublebuf;
 

