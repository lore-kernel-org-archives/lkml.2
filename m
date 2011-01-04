Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab1ADUwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:52:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:24835 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab1ADUwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:52:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,274,1291622400"; 
   d="scan'208";a="643383422"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de, alan@linux.intel.com
Cc: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH 1/1] staging: sep: Remove un-needed debug prints
Date: Tue,  4 Jan 2011 12:57:16 -0800
Message-Id: <1294174636-19290-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c |  223 ++++----------------------------------
 1 files changed, 20 insertions(+), 203 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index ac5d569..a1b0bfe 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -107,12 +107,8 @@ static int sep_load_firmware(struct sep_device *sep)
 	sep->resident_size = fw->size;
 	release_firmware(fw);
 
-	dev_dbg(&sep->pdev->dev, "resident virtual is %p\n",
-		sep->resident_addr);
 	dev_dbg(&sep->pdev->dev, "resident bus is %lx\n",
 		(unsigned long)sep->resident_bus);
-	dev_dbg(&sep->pdev->dev, "resident size is %08zx\n",
-		sep->resident_size);
 
 	/* Set addresses for dcache (no loading needed) */
 	work1 = (unsigned long)sep->resident_bus;
@@ -141,12 +137,8 @@ static int sep_load_firmware(struct sep_device *sep)
 	sep->cache_size = fw->size;
 	release_firmware(fw);
 
-	dev_dbg(&sep->pdev->dev, "cache virtual is %p\n",
-		sep->cache_addr);
 	dev_dbg(&sep->pdev->dev, "cache bus is %08lx\n",
 		(unsigned long)sep->cache_bus);
-	dev_dbg(&sep->pdev->dev, "cache size is %08zx\n",
-		sep->cache_size);
 
 	/* Set addresses and load extapp */
 	sep->extapp_bus = sep->cache_bus + (1024 * 370);
@@ -162,12 +154,8 @@ static int sep_load_firmware(struct sep_device *sep)
 	sep->extapp_size = fw->size;
 	release_firmware(fw);
 
-	dev_dbg(&sep->pdev->dev, "extapp virtual is %p\n",
-		sep->extapp_addr);
 	dev_dbg(&sep->pdev->dev, "extapp bus is %08llx\n",
 		(unsigned long long)sep->extapp_bus);
-	dev_dbg(&sep->pdev->dev, "extapp size is %08zx\n",
-		sep->extapp_size);
 
 	return error;
 }
@@ -218,7 +206,6 @@ static int sep_map_and_alloc_shared_area(struct sep_device *sep)
  */
 static void sep_unmap_and_free_shared_area(struct sep_device *sep)
 {
-	dev_dbg(&sep->pdev->dev, "shared area unmap and free\n");
 	dma_free_coherent(&sep->pdev->dev, sep->shared_size,
 				sep->shared_addr, sep->shared_bus);
 }
@@ -257,15 +244,11 @@ static int sep_singleton_open(struct inode *inode_ptr, struct file *file_ptr)
 
 	file_ptr->private_data = sep;
 
-	dev_dbg(&sep->pdev->dev, "Singleton open for pid %d\n", current->pid);
-
-	dev_dbg(&sep->pdev->dev, "calling test and set for singleton 0\n");
 	if (test_and_set_bit(0, &sep->singleton_access_flag)) {
 		error = -EBUSY;
 		goto end_function;
 	}
 
-	dev_dbg(&sep->pdev->dev, "sep_singleton_open end\n");
 end_function:
 	return error;
 }
@@ -310,8 +293,6 @@ static int sep_singleton_release(struct inode *inode, struct file *filp)
 {
 	struct sep_device *sep = filp->private_data;
 
-	dev_dbg(&sep->pdev->dev, "Singleton release for pid %d\n",
-							current->pid);
 	clear_bit(0, &sep->singleton_access_flag);
 	return 0;
 }
@@ -337,7 +318,6 @@ static int sep_request_daemon_open(struct inode *inode, struct file *filp)
 		current->pid);
 
 	/* There is supposed to be only one request daemon */
-	dev_dbg(&sep->pdev->dev, "calling test and set for req_dmon open 0\n");
 	if (test_and_set_bit(0, &sep->request_daemon_open))
 		error = -EBUSY;
 	return error;
@@ -354,7 +334,7 @@ static int sep_request_daemon_release(struct inode *inode, struct file *filp)
 {
 	struct sep_device *sep = filp->private_data;
 
-	dev_dbg(&sep->pdev->dev, "Reques daemon release for pid %d\n",
+	dev_dbg(&sep->pdev->dev, "Request daemon release for pid %d\n",
 		current->pid);
 
 	/* Clear the request_daemon_open flag */
@@ -373,9 +353,6 @@ static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
 {
 	unsigned long lck_flags;
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_req_daemon_send_reply_command_handler start\n");
-
 	sep_dump_message(sep);
 
 	/* Counters are lockable region */
@@ -393,9 +370,6 @@ static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
 		"sep_req_daemon_send_reply send_ct %lx reply_ct %lx\n",
 		sep->send_ct, sep->reply_ct);
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_req_daemon_send_reply_command_handler end\n");
-
 	return 0;
 }
 
@@ -413,8 +387,6 @@ static int sep_free_dma_table_data_handler(struct sep_device *sep)
 	/* Pointer to the current dma_resource struct */
 	struct sep_dma_resource *dma;
 
-	dev_dbg(&sep->pdev->dev, "sep_free_dma_table_data_handler start\n");
-
 	for (dcb_counter = 0; dcb_counter < sep->nr_dcb_creat; dcb_counter++) {
 		dma = &sep->dma_res_arr[dcb_counter];
 
@@ -473,7 +445,6 @@ static int sep_free_dma_table_data_handler(struct sep_device *sep)
 	sep->nr_dcb_creat = 0;
 	sep->num_lli_tables_created = 0;
 
-	dev_dbg(&sep->pdev->dev, "sep_free_dma_table_data_handler end\n");
 	return 0;
 }
 
@@ -492,8 +463,6 @@ static int sep_request_daemon_mmap(struct file  *filp,
 	dma_addr_t bus_address;
 	int error = 0;
 
-	dev_dbg(&sep->pdev->dev, "daemon mmap start\n");
-
 	if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
 		error = -EINVAL;
 		goto end_function;
@@ -502,9 +471,6 @@ static int sep_request_daemon_mmap(struct file  *filp,
 	/* Get physical address */
 	bus_address = sep->shared_bus;
 
-	dev_dbg(&sep->pdev->dev, "bus_address is %08lx\n",
-					(unsigned long)bus_address);
-
 	if (remap_pfn_range(vma, vma->vm_start, bus_address >> PAGE_SHIFT,
 		vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
 
@@ -514,7 +480,6 @@ static int sep_request_daemon_mmap(struct file  *filp,
 	}
 
 end_function:
-	dev_dbg(&sep->pdev->dev, "daemon mmap end\n");
 	return error;
 }
 
@@ -535,8 +500,6 @@ static unsigned int sep_request_daemon_poll(struct file *filp,
 	unsigned long lck_flags;
 	struct sep_device *sep = filp->private_data;
 
-	dev_dbg(&sep->pdev->dev, "daemon poll: start\n");
-
 	poll_wait(filp, &sep->event_request_daemon, wait);
 
 	dev_dbg(&sep->pdev->dev, "daemon poll: send_ct is %lx reply ct is %lx\n",
@@ -569,7 +532,6 @@ static unsigned int sep_request_daemon_poll(struct file *filp,
 		mask = 0;
 	}
 end_function:
-	dev_dbg(&sep->pdev->dev, "daemon poll: exit\n");
 	return mask;
 }
 
@@ -592,7 +554,6 @@ static int sep_release(struct inode *inode, struct file *filp)
 	 * clear the in use flags, and then wake up sep_event
 	 * so that other processes can do transactions
 	 */
-	dev_dbg(&sep->pdev->dev, "waking up event and mmap_event\n");
 	if (sep->pid_doing_transaction == current->pid) {
 		clear_bit(SEP_MMAP_LOCK_BIT, &sep->in_use_flags);
 		clear_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags);
@@ -618,8 +579,6 @@ static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
 	struct sep_device *sep = filp->private_data;
 	unsigned long error = 0;
 
-	dev_dbg(&sep->pdev->dev, "mmap start\n");
-
 	/* Set the transaction busy (own the device) */
 	wait_event_interruptible(sep->event,
 		test_and_set_bit(SEP_MMAP_LOCK_BIT,
@@ -661,16 +620,12 @@ static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
 	/* Get bus address */
 	bus_addr = sep->shared_bus;
 
-	dev_dbg(&sep->pdev->dev,
-		"bus_address is %lx\n", (unsigned long)bus_addr);
-
 	if (remap_pfn_range(vma, vma->vm_start, bus_addr >> PAGE_SHIFT,
 		vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
 		dev_warn(&sep->pdev->dev, "remap_page_range failed\n");
 		error = -EAGAIN;
 		goto end_function_with_error;
 	}
-	dev_dbg(&sep->pdev->dev, "mmap end\n");
 	goto end_function;
 
 end_function_with_error:
@@ -682,7 +637,6 @@ end_function_with_error:
 
 	/* Raise event for stuck contextes */
 
-	dev_warn(&sep->pdev->dev, "mmap error - waking up event\n");
 	wake_up(&sep->event);
 
 end_function:
@@ -706,8 +660,6 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 
 	struct sep_device *sep = filp->private_data;
 
-	dev_dbg(&sep->pdev->dev, "poll: start\n");
-
 	/* Am I the process that owns the transaction? */
 	mutex_lock(&sep->sep_mutex);
 	if (current->pid != sep->pid_doing_transaction) {
@@ -720,7 +672,6 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 
 	/* Check if send command or send_reply were activated previously */
 	if (!test_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags)) {
-		dev_warn(&sep->pdev->dev, "poll; lock bit set\n");
 		mask = POLLERR;
 		goto end_function;
 	}
@@ -777,7 +728,6 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 	}
 
 end_function:
-	dev_dbg(&sep->pdev->dev, "poll: end\n");
 	return mask;
 }
 
@@ -806,8 +756,6 @@ static unsigned long sep_set_time(struct sep_device *sep)
 	u32 *time_addr;	/* Address of time as seen by the kernel */
 
 
-	dev_dbg(&sep->pdev->dev, "sep_set_time start\n");
-
 	do_gettimeofday(&time);
 
 	/* Set value in the SYSTEM MEMORY offset */
@@ -838,8 +786,6 @@ static int sep_set_caller_id_handler(struct sep_device *sep, unsigned long arg)
 	int   i;
 	struct caller_id_struct command_args;
 
-	dev_dbg(&sep->pdev->dev, "sep_set_caller_id_handler start\n");
-
 	for (i = 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
 		if (sep->caller_id_table[i].pid == 0)
 			break;
@@ -883,7 +829,6 @@ static int sep_set_caller_id_handler(struct sep_device *sep, unsigned long arg)
 		hash, command_args.callerIdSizeInBytes))
 		error = -EFAULT;
 end_function:
-	dev_dbg(&sep->pdev->dev, "sep_set_caller_id_handler end\n");
 	return error;
 }
 
@@ -899,9 +844,6 @@ static int sep_set_current_caller_id(struct sep_device *sep)
 	int i;
 	u32 *hash_buf_ptr;
 
-	dev_dbg(&sep->pdev->dev, "sep_set_current_caller_id start\n");
-	dev_dbg(&sep->pdev->dev, "current process is %d\n", current->pid);
-
 	/* Zero the previous value */
 	memset(sep->shared_addr + SEP_CALLER_ID_OFFSET_BYTES,
 					0, SEP_CALLER_ID_HASH_SIZE_IN_BYTES);
@@ -923,7 +865,6 @@ static int sep_set_current_caller_id(struct sep_device *sep)
 	for (i = 0; i < SEP_CALLER_ID_HASH_SIZE_IN_WORDS; i++)
 		hash_buf_ptr[i] = cpu_to_le32(hash_buf_ptr[i]);
 
-	dev_dbg(&sep->pdev->dev, "sep_set_current_caller_id end\n");
 	return 0;
 }
 
@@ -941,8 +882,6 @@ static int sep_send_command_handler(struct sep_device *sep)
 	unsigned long lck_flags;
 	int error = 0;
 
-	dev_dbg(&sep->pdev->dev, "sep_send_command_handler start\n");
-
 	if (test_and_set_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags)) {
 		error = -EPROTO;
 		goto end_function;
@@ -966,7 +905,6 @@ static int sep_send_command_handler(struct sep_device *sep)
 	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x2);
 
 end_function:
-	dev_dbg(&sep->pdev->dev, "sep_send_command_handler end\n");
 	return error;
 }
 
@@ -990,9 +928,6 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 	/* Holds the allocated buffer address in the system memory pool */
 	u32 *token_addr;
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_allocate_data_pool_memory_handler start\n");
-
 	if (copy_from_user(&command_args, (void __user *)arg,
 					sizeof(struct alloc_struct))) {
 		error = -EFAULT;
@@ -1007,33 +942,23 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 	}
 
 	dev_dbg(&sep->pdev->dev,
-		"bytes_allocated: %x\n", (int)sep->data_pool_bytes_allocated);
+		"data pool bytes_allocated: %x\n", (int)sep->data_pool_bytes_allocated);
 	dev_dbg(&sep->pdev->dev,
 		"offset: %x\n", SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES);
 	/* Set the virtual and bus address */
 	command_args.offset = SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
 		sep->data_pool_bytes_allocated;
 
-	dev_dbg(&sep->pdev->dev,
-		"command_args.offset: %x\n", command_args.offset);
-
 	/* Place in the shared area that is known by the SEP */
 	token_addr = (u32 *)(sep->shared_addr +
 		SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES +
 		(sep->num_of_data_allocations)*2*sizeof(u32));
 
-	dev_dbg(&sep->pdev->dev, "allocation offset: %x\n",
-		SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES);
-	dev_dbg(&sep->pdev->dev, "data pool token addr is %p\n", token_addr);
-
 	token_addr[0] = SEP_DATA_POOL_POINTERS_VAL_TOKEN;
 	token_addr[1] = (u32)sep->shared_bus +
 		SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
 		sep->data_pool_bytes_allocated;
 
-	dev_dbg(&sep->pdev->dev, "data pool token [0] %x\n", token_addr[0]);
-	dev_dbg(&sep->pdev->dev, "data pool token [1] %x\n", token_addr[1]);
-
 	/* Write the memory back to the user space */
 	error = copy_to_user((void *)arg, (void *)&command_args,
 		sizeof(struct alloc_struct));
@@ -1046,11 +971,6 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 	sep->data_pool_bytes_allocated += command_args.num_bytes;
 	sep->num_of_data_allocations += 1;
 
-	dev_dbg(&sep->pdev->dev, "data_allocations %d\n",
-		sep->num_of_data_allocations);
-	dev_dbg(&sep->pdev->dev, "bytes allocated  %d\n",
-		(int)sep->data_pool_bytes_allocated);
-
 end_function:
 	dev_dbg(&sep->pdev->dev, "sep_allocate_data_pool_memory_handler end\n");
 	return error;
@@ -1083,8 +1003,7 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 	/* Map array */
 	struct sep_dma_map *map_array;
 
-	dev_dbg(&sep->pdev->dev, "sep_lock_kernel_pages start\n");
-	dev_dbg(&sep->pdev->dev, "kernel_virt_addr is %08lx\n",
+	dev_dbg(&sep->pdev->dev, "lock kernel pages kernel_virt_addr is %08lx\n",
 				(unsigned long)kernel_virt_addr);
 	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
 
@@ -1137,7 +1056,6 @@ end_function_with_error:
 	kfree(lli_array);
 
 end_function:
-	dev_dbg(&sep->pdev->dev, "sep_lock_kernel_pages end\n");
 	return error;
 }
 
@@ -1179,21 +1097,17 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	/* Direction of the DMA mapping for locked pages */
 	enum dma_data_direction	dir;
 
-	dev_dbg(&sep->pdev->dev, "sep_lock_user_pages start\n");
-
 	/* Set start and end pages  and num pages */
 	end_page = (app_virt_addr + data_size - 1) >> PAGE_SHIFT;
 	start_page = app_virt_addr >> PAGE_SHIFT;
 	num_pages = end_page - start_page + 1;
 
-	dev_dbg(&sep->pdev->dev, "app_virt_addr is %x\n", app_virt_addr);
+	dev_dbg(&sep->pdev->dev, "lock user pages app_virt_addr is %x\n", app_virt_addr);
 	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
 	dev_dbg(&sep->pdev->dev, "start_page is %x\n", start_page);
 	dev_dbg(&sep->pdev->dev, "end_page is %x\n", end_page);
 	dev_dbg(&sep->pdev->dev, "num_pages is %x\n", num_pages);
 
-	dev_dbg(&sep->pdev->dev, "starting page_array malloc\n");
-
 	/* Allocate array of pages structure pointers */
 	page_array = kmalloc(sizeof(struct page *) * num_pages, GFP_ATOMIC);
 	if (!page_array) {
@@ -1216,8 +1130,6 @@ static int sep_lock_user_pages(struct sep_device *sep,
 		goto end_function_with_error2;
 	}
 
-	dev_dbg(&sep->pdev->dev, "starting get_user_pages\n");
-
 	/* Convert the application virtual address into a set of physical */
 	down_read(&current->mm->mmap_sem);
 	result = get_user_pages(current, current->mm, app_virt_addr,
@@ -1324,7 +1236,6 @@ end_function_with_error1:
 	kfree(page_array);
 
 end_function:
-	dev_dbg(&sep->pdev->dev, "sep_lock_user_pages end\n");
 	return error;
 }
 
@@ -1395,8 +1306,6 @@ static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
 		table_data_size -= (SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE -
 			next_table_data_size);
 
-	dev_dbg(&sep->pdev->dev, "table data size is %x\n",
-							table_data_size);
 end_function:
 	return table_data_size;
 }
@@ -1425,14 +1334,12 @@ static void sep_build_lli_table(struct sep_device *sep,
 	/* Counter of lli array entry */
 	u32 array_counter;
 
-	dev_dbg(&sep->pdev->dev, "sep_build_lli_table start\n");
-
 	/* Init currrent table data size and lli array entry counter */
 	curr_table_data_size = 0;
 	array_counter = 0;
 	*num_table_entries_ptr = 1;
 
-	dev_dbg(&sep->pdev->dev, "table_data_size is %x\n", table_data_size);
+	dev_dbg(&sep->pdev->dev, "build lli table table_data_size is %x\n", table_data_size);
 
 	/* Fill the table till table size reaches the needed amount */
 	while (curr_table_data_size < table_data_size) {
@@ -1489,19 +1396,9 @@ static void sep_build_lli_table(struct sep_device *sep,
 	lli_table_ptr->bus_address = 0xffffffff;
 	lli_table_ptr->block_size = 0;
 
-	dev_dbg(&sep->pdev->dev, "lli_table_ptr is %p\n", lli_table_ptr);
-	dev_dbg(&sep->pdev->dev, "lli_table_ptr->bus_address is %08lx\n",
-				(unsigned long)lli_table_ptr->bus_address);
-	dev_dbg(&sep->pdev->dev, "lli_table_ptr->block_size is %x\n",
-						lli_table_ptr->block_size);
-
 	/* Set the output parameter */
 	*num_processed_entries_ptr += array_counter;
 
-	dev_dbg(&sep->pdev->dev, "num_processed_entries_ptr is %x\n",
-		*num_processed_entries_ptr);
-
-	dev_dbg(&sep->pdev->dev, "sep_build_lli_table end\n");
 }
 
 /**
@@ -1631,8 +1528,6 @@ static void sep_prepare_empty_lli_table(struct sep_device *sep,
 {
 	struct sep_lli_entry *lli_table_ptr;
 
-	dev_dbg(&sep->pdev->dev, "sep_prepare_empty_lli_table start\n");
-
 	/* Find the area for new table */
 	lli_table_ptr =
 		(struct sep_lli_entry *)(sep->shared_addr +
@@ -1660,9 +1555,6 @@ static void sep_prepare_empty_lli_table(struct sep_device *sep,
 
 	/* Update the number of created tables */
 	sep->num_lli_tables_created++;
-
-	dev_dbg(&sep->pdev->dev, "sep_prepare_empty_lli_table start\n");
-
 }
 
 /**
@@ -1709,8 +1601,7 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 	/* Next table address */
 	void *lli_table_alloc_addr = 0;
 
-	dev_dbg(&sep->pdev->dev, "sep_prepare_input_dma_table start\n");
-	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
+	dev_dbg(&sep->pdev->dev, "prepare intput dma table data_size is %x\n", data_size);
 	dev_dbg(&sep->pdev->dev, "block_size is %x\n", block_size);
 
 	/* Initialize the pages pointers */
@@ -1842,7 +1733,6 @@ end_function_error:
 	kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_page_array);
 
 end_function:
-	dev_dbg(&sep->pdev->dev, "sep_prepare_input_dma_table end\n");
 	return error;
 
 }
@@ -1906,8 +1796,6 @@ static int sep_construct_dma_tables_from_lli(
 	/* Number of etnries in the output table */
 	u32 num_entries_out_table = 0;
 
-	dev_dbg(&sep->pdev->dev, "sep_construct_dma_tables_from_lli start\n");
-
 	/* Initiate to point after the message area */
 	lli_table_alloc_addr = (void *)(sep->shared_addr +
 		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
@@ -1960,11 +1848,11 @@ static int sep_construct_dma_tables_from_lli(
 			&last_table_flag);
 
 		dev_dbg(&sep->pdev->dev,
-			"in_table_data_size is %x\n",
+			"construct tables from lli in_table_data_size is %x\n",
 			in_table_data_size);
 
 		dev_dbg(&sep->pdev->dev,
-			"out_table_data_size is %x\n",
+			"construct tables from lli out_table_data_size is %x\n",
 			out_table_data_size);
 
 		table_data_size = in_table_data_size;
@@ -1986,9 +1874,6 @@ static int sep_construct_dma_tables_from_lli(
 				block_size;
 		}
 
-		dev_dbg(&sep->pdev->dev, "table_data_size is %x\n",
-							table_data_size);
-
 		/* Construct input lli table */
 		sep_build_lli_table(sep, &lli_in_array[current_in_entry],
 			in_lli_table_ptr,
@@ -2085,7 +1970,6 @@ static int sep_construct_dma_tables_from_lli(
 	*out_num_entries_ptr,
 	*table_data_size_ptr);
 
-	dev_dbg(&sep->pdev->dev, "sep_construct_dma_tables_from_lli end\n");
 	return 0;
 }
 
@@ -2127,8 +2011,6 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 	/* Array of pointers of page */
 	struct sep_lli_entry *lli_out_array;
 
-	dev_dbg(&sep->pdev->dev, "sep_prepare_input_output_dma_table start\n");
-
 	if (data_size == 0) {
 		/* Prepare empty table for input and output */
 		sep_prepare_empty_lli_table(sep, lli_table_in_ptr,
@@ -2184,7 +2066,7 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 		}
 	}
 
-	dev_dbg(&sep->pdev->dev, "sep_in_num_pages is %x\n",
+	dev_dbg(&sep->pdev->dev, "prep input output dma table sep_in_num_pages is %x\n",
 		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages);
 	dev_dbg(&sep->pdev->dev, "sep_out_num_pages is %x\n",
 		sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages);
@@ -2211,13 +2093,6 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 update_dcb_counter:
 	/* Update DCB counter */
 	sep->nr_dcb_creat++;
-	/* Fall through - free the lli entry arrays */
-	dev_dbg(&sep->pdev->dev, "in_num_entries_ptr is %08x\n",
-						*in_num_entries_ptr);
-	dev_dbg(&sep->pdev->dev, "out_num_entries_ptr is %08x\n",
-						*out_num_entries_ptr);
-	dev_dbg(&sep->pdev->dev, "table_data_size_ptr is %08x\n",
-						*table_data_size_ptr);
 
 	goto end_function;
 
@@ -2233,8 +2108,6 @@ end_function_free_lli_in:
 	kfree(lli_in_array);
 
 end_function:
-	dev_dbg(&sep->pdev->dev,
-		"sep_prepare_input_output_dma_table end result = %d\n", error);
 
 	return error;
 
@@ -2281,8 +2154,6 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	/* Data in the first input/output table */
 	u32  first_data_size = 0;
 
-	dev_dbg(&sep->pdev->dev, "prepare_input_output_dma_table_in_dcb start\n");
-
 	if (sep->nr_dcb_creat == SEP_MAX_NUM_SYNC_DMA_OPS) {
 		/* No more DCBs to allocate */
 		dev_warn(&sep->pdev->dev, "no more DCBs available\n");
@@ -2424,8 +2295,6 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	dcb_table_ptr->output_mlli_data_size = first_data_size;
 
 end_function:
-	dev_dbg(&sep->pdev->dev,
-		"sep_prepare_input_output_dma_table_in_dcb end\n");
 	return error;
 
 }
@@ -2448,16 +2317,13 @@ static int sep_create_sync_dma_tables_handler(struct sep_device *sep,
 	/* Command arguments */
 	struct bld_syn_tab_struct command_args;
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_create_sync_dma_tables_handler start\n");
-
 	if (copy_from_user(&command_args, (void __user *)arg,
 					sizeof(struct bld_syn_tab_struct))) {
 		error = -EFAULT;
 		goto end_function;
 	}
 
-	dev_dbg(&sep->pdev->dev, "app_in_address is %08llx\n",
+	dev_dbg(&sep->pdev->dev, "create dma table handler app_in_address is %08llx\n",
 						command_args.app_in_address);
 	dev_dbg(&sep->pdev->dev, "app_out_address is %08llx\n",
 						command_args.app_out_address);
@@ -2482,7 +2348,6 @@ static int sep_create_sync_dma_tables_handler(struct sep_device *sep,
 		false);
 
 end_function:
-	dev_dbg(&sep->pdev->dev, "sep_create_sync_dma_tables_handler end\n");
 	return error;
 }
 
@@ -2504,8 +2369,6 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 	unsigned long pt_hold;
 	void *tail_pt;
 
-	dev_dbg(&sep->pdev->dev, "sep_free_dma_tables_and_dcb start\n");
-
 	if (isapplet == true) {
 		/* Set pointer to first DCB table */
 		dcb_table_ptr = (struct sep_dcblock *)
@@ -2538,7 +2401,6 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 	/* Free the output pages, if any */
 	sep_free_dma_table_data_handler(sep);
 
-	dev_dbg(&sep->pdev->dev, "sep_free_dma_tables_and_dcb end\n");
 	return error;
 }
 
@@ -2552,8 +2414,6 @@ static int sep_get_static_pool_addr_handler(struct sep_device *sep)
 {
 	u32 *static_pool_addr = NULL;
 
-	dev_dbg(&sep->pdev->dev, "sep_get_static_pool_addr_handler start\n");
-
 	static_pool_addr = (u32 *)(sep->shared_addr +
 		SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES);
 
@@ -2561,11 +2421,9 @@ static int sep_get_static_pool_addr_handler(struct sep_device *sep)
 	static_pool_addr[1] = (u32)sep->shared_bus +
 		SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES;
 
-	dev_dbg(&sep->pdev->dev, "static pool: physical %x\n",
+	dev_dbg(&sep->pdev->dev, "static pool segment: physical %x\n",
 		(u32)static_pool_addr[1]);
 
-	dev_dbg(&sep->pdev->dev, "sep_get_static_pool_addr_handler end\n");
-
 	return 0;
 }
 
@@ -2578,8 +2436,6 @@ static int sep_start_handler(struct sep_device *sep)
 	unsigned long reg_val;
 	unsigned long error = 0;
 
-	dev_dbg(&sep->pdev->dev, "sep_start_handler start\n");
-
 	/* Wait in polling for message from SEP */
 	do {
 		reg_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
@@ -2589,7 +2445,6 @@ static int sep_start_handler(struct sep_device *sep)
 	if (reg_val == 0x1)
 		/* Fatal error - read error status from GPRO */
 		error = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR0_REG_ADDR);
-	dev_dbg(&sep->pdev->dev, "sep_start_handler end\n");
 	return error;
 }
 
@@ -2648,8 +2503,6 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 	unsigned long addr_hold;
 	struct init_struct command_args;
 
-	dev_dbg(&sep->pdev->dev, "sep_init_handler start\n");
-
 	/* Make sure that we have not initialized already */
 	reg_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
 
@@ -2746,7 +2599,6 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x1);
 
 	/* Wait for acknowledge */
-	dev_dbg(&sep->pdev->dev, "init; waiting for msg response\n");
 
 	do {
 		reg_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
@@ -2760,20 +2612,16 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 		dev_warn(&sep->pdev->dev, "init; error is %x\n", error);
 		goto end_function;
 	}
-	dev_dbg(&sep->pdev->dev, "init; end CC INIT, reg_val is %x\n", reg_val);
-
 	/* Signal SEP to zero the GPR3 */
 	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x10);
 
 	/* Wait for response */
-	dev_dbg(&sep->pdev->dev, "init; waiting for zero set response\n");
 
 	do {
 		reg_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
 	} while (reg_val != 0);
 
 end_function:
-	dev_dbg(&sep->pdev->dev, "init is done\n");
 	return error;
 }
 
@@ -2785,8 +2633,6 @@ end_function:
  */
 static int sep_end_transaction_handler(struct sep_device *sep)
 {
-	dev_dbg(&sep->pdev->dev, "sep_end_transaction_handler start\n");
-
 	/* Clear the data pool pointers Token */
 	memset((void *)(sep->shared_addr +
 		SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES),
@@ -2808,9 +2654,6 @@ static int sep_end_transaction_handler(struct sep_device *sep)
 	/* Raise event for stuck contextes */
 	wake_up(&sep->event);
 
-	dev_dbg(&sep->pdev->dev, "waking up event\n");
-	dev_dbg(&sep->pdev->dev, "sep_end_transaction_handler end\n");
-
 	return 0;
 }
 
@@ -2828,8 +2671,6 @@ static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg)
 	/* Command arguments */
 	struct build_dcb_struct command_args;
 
-	dev_dbg(&sep->pdev->dev, "sep_prepare_dcb_handler start\n");
-
 	/* Get the command arguments */
 	if (copy_from_user(&command_args, (void __user *)arg,
 					sizeof(struct build_dcb_struct))) {
@@ -2837,7 +2678,7 @@ static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg)
 		goto end_function;
 	}
 
-	dev_dbg(&sep->pdev->dev, "app_in_address is %08llx\n",
+	dev_dbg(&sep->pdev->dev, "prep dcb handler app_in_address is %08llx\n",
 						command_args.app_in_address);
 	dev_dbg(&sep->pdev->dev, "app_out_address is %08llx\n",
 						command_args.app_out_address);
@@ -2855,7 +2696,6 @@ static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg)
 		command_args.tail_block_size, true, false);
 
 end_function:
-	dev_dbg(&sep->pdev->dev, "sep_prepare_dcb_handler end\n");
 	return error;
 
 }
@@ -2871,12 +2711,10 @@ static int sep_free_dcb_handler(struct sep_device *sep)
 {
 	int error ;
 
-	dev_dbg(&sep->pdev->dev, "sep_prepare_dcb_handler start\n");
-	dev_dbg(&sep->pdev->dev, "num of DCBs %x\n", sep->nr_dcb_creat);
+	dev_dbg(&sep->pdev->dev, "free dcbs num of DCBs %x\n", sep->nr_dcb_creat);
 
 	error = sep_free_dma_tables_and_dcb(sep, false, false);
 
-	dev_dbg(&sep->pdev->dev, "sep_free_dcb_handler end\n");
 	return error;
 }
 
@@ -2900,8 +2738,6 @@ static int sep_rar_prepare_output_msg_handler(struct sep_device *sep,
 	/* Holds the RAR address in the system memory offset */
 	u32 *rar_addr;
 
-	dev_dbg(&sep->pdev->dev, "sep_rar_prepare_output_msg_handler start\n");
-
 	/* Copy the data */
 	if (copy_from_user(&command_args, (void __user *)arg,
 						sizeof(command_args))) {
@@ -2915,7 +2751,6 @@ static int sep_rar_prepare_output_msg_handler(struct sep_device *sep,
 		rar_buf.info.handle = (u32)command_args.rar_handle;
 
 		if (rar_handle_to_bus(&rar_buf, 1) != 1) {
-			dev_dbg(&sep->pdev->dev, "rar_handle_to_bus failure\n");
 			error = -EFAULT;
 			goto end_function;
 		}
@@ -2932,7 +2767,6 @@ static int sep_rar_prepare_output_msg_handler(struct sep_device *sep,
 	rar_addr[1] = rar_bus;
 
 end_function:
-	dev_dbg(&sep->pdev->dev, "sep_rar_prepare_output_msg_handler start\n");
 	return error;
 }
 
@@ -2955,11 +2789,7 @@ static int sep_realloc_ext_cache_handler(struct sep_device *sep,
 
 	/* Copy the physical address to the System Area for the SEP */
 	system_addr[0] = SEP_EXT_CACHE_ADDR_VAL_TOKEN;
-	dev_dbg(&sep->pdev->dev, "ext cache init; system addr 0 is %x\n",
-							system_addr[0]);
 	system_addr[1] = sep->extapp_bus;
-	dev_dbg(&sep->pdev->dev, "ext cache init; system addr 1 is %x\n",
-							system_addr[1]);
 
 	return 0;
 }
@@ -2977,15 +2807,13 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	int error = 0;
 	struct sep_device *sep = filp->private_data;
 
-	dev_dbg(&sep->pdev->dev, "ioctl start\n");
-
-	dev_dbg(&sep->pdev->dev, "cmd is %x\n", cmd);
+	dev_dbg(&sep->pdev->dev, "ioctl cmd is %x\n", cmd);
 
 	/* Make sure we own this device */
 	mutex_lock(&sep->sep_mutex);
 	if ((current->pid != sep->pid_doing_transaction) &&
 				(sep->pid_doing_transaction != 0)) {
-		dev_dbg(&sep->pdev->dev, "ioctl pid is not owner\n");
+		dev_warn(&sep->pdev->dev, "ioctl pid is not owner\n");
 		mutex_unlock(&sep->sep_mutex);
 		error = -EACCES;
 		goto end_function;
@@ -3080,8 +2908,7 @@ static long sep_singleton_ioctl(struct file  *filp, u32 cmd, unsigned long arg)
 	long error = 0;
 	struct sep_device *sep = filp->private_data;
 
-	dev_dbg(&sep->pdev->dev, "singleton_ioctl start\n");
-	dev_dbg(&sep->pdev->dev, "cmd is %x\n", cmd);
+	dev_dbg(&sep->pdev->dev, "singleton ioctl cmd is %x\n", cmd);
 
 	/* Check that the command is for the SEP device */
 	if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER) {
@@ -3093,7 +2920,7 @@ static long sep_singleton_ioctl(struct file  *filp, u32 cmd, unsigned long arg)
 	mutex_lock(&sep->sep_mutex);
 	if ((current->pid != sep->pid_doing_transaction) &&
 				(sep->pid_doing_transaction != 0)) {
-		dev_dbg(&sep->pdev->dev, "singleton ioctl pid is not owner\n");
+		dev_warn(&sep->pdev->dev, "singleton ioctl pid is not owner\n");
 		mutex_unlock(&sep->sep_mutex);
 		error = -EACCES;
 		goto end_function;
@@ -3113,7 +2940,6 @@ static long sep_singleton_ioctl(struct file  *filp, u32 cmd, unsigned long arg)
 	}
 
 end_function:
-	dev_dbg(&sep->pdev->dev, "singleton ioctl end\n");
 	return error;
 }
 
@@ -3132,7 +2958,6 @@ static long sep_request_daemon_ioctl(struct file *filp, u32 cmd,
 	long error;
 	struct sep_device *sep = filp->private_data;
 
-	dev_dbg(&sep->pdev->dev, "daemon ioctl: start\n");
 	dev_dbg(&sep->pdev->dev, "daemon ioctl: cmd is %x\n", cmd);
 
 	/* Check that the command is for SEP device */
@@ -3158,13 +2983,12 @@ static long sep_request_daemon_ioctl(struct file *filp, u32 cmd,
 		error = 0;
 		break;
 	default:
-		dev_dbg(&sep->pdev->dev, "daemon ioctl: no such IOCTL\n");
+		dev_warn(&sep->pdev->dev, "daemon ioctl: no such IOCTL\n");
 		error = -ENOTTY;
 	}
 	mutex_unlock(&sep->ioctl_mutex);
 
 end_function:
-	dev_dbg(&sep->pdev->dev, "daemon ioctl: end\n");
 	return error;
 
 }
@@ -3183,7 +3007,6 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
 
 	/* Read the IRR register to check if this is SEP interrupt */
 	reg_val = sep_read_reg(sep, HW_HOST_IRR_REG_ADDR);
-	dev_dbg(&sep->pdev->dev, "SEP Interrupt - reg is %08x\n", reg_val);
 
 	if (reg_val & (0x1 << 13)) {
 		/* Lock and update the counter of reply messages */
@@ -3233,10 +3056,8 @@ static int sep_reconfig_shared_area(struct sep_device *sep)
 	/* use to limit waiting for SEP */
 	unsigned long end_time;
 
-	dev_dbg(&sep->pdev->dev, "reconfig shared area start\n");
-
 	/* Send the new SHARED MESSAGE AREA to the SEP */
-	dev_dbg(&sep->pdev->dev, "sending %08llx to sep\n",
+	dev_dbg(&sep->pdev->dev, "reconfig shared; sending %08llx to sep\n",
 				(unsigned long long)sep->shared_bus);
 
 	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR1_REG_ADDR, sep->shared_bus);
@@ -3356,7 +3177,6 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	int error = 0;
 	struct sep_device *sep;
 
-	pr_debug("SEP pci probe starting\n");
 	if (sep_dev != NULL) {
 		dev_warn(&pdev->dev, "only one SEP supported.\n");
 		return -EBUSY;
@@ -3394,7 +3214,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	mutex_init(&sep->sep_mutex);
 	mutex_init(&sep->ioctl_mutex);
 
-	dev_dbg(&sep->pdev->dev, "PCI obtained, device being prepared\n");
+	dev_dbg(&sep->pdev->dev, "sep probe: PCI obtained, device being prepared\n");
 	dev_dbg(&sep->pdev->dev, "revision is %d\n", sep->pdev->revision);
 
 	/* Set up our register area */
@@ -3453,8 +3273,6 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 		(unsigned long long)sep->rar_bus,
 		sep->rar_size);
 
-	dev_dbg(&sep->pdev->dev, "about to write IMR and ICR REG_ADDR\n");
-
 	/* Clear ICR register */
 	sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, 0xFFFFFFFF);
 
@@ -3466,7 +3284,6 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	sep->reply_ct &= 0x3FFFFFFF;
 	sep->send_ct = sep->reply_ct;
 
-	dev_dbg(&sep->pdev->dev, "about to call request_irq\n");
 	/* Get the interrupt line */
 	error = request_irq(pdev->irq, sep_inthandler, IRQF_SHARED,
 		"sep_driver", sep);
-- 
1.6.3.3

