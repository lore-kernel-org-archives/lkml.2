Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0KXT6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:58:24 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47181 "EHLO deliverator"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753281Ab0KXT6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:58:22 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 07/12] sep: clean up some of the obvious sillies
To: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Nov 2010 19:38:02 +0000
Message-ID: <20101124193503.16425.14521.stgit@bob.linux.org.uk>
In-Reply-To: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
References: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Various assignments are done but not used
dev_dbg formatting is a bit weird and wraps when not needed
Take out some of the blank lines and reformat a bit to reduce view size
Remove some comments that are obvious
Fix else formatting
Remove some user triggerable dev_warns
Fix copy_from_user error return cases (-EFAULT not bytes copied)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver.c |  941 ++++++++++----------------------------
 1 files changed, 249 insertions(+), 692 deletions(-)


diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 4a0bb43..f576285 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -83,15 +83,13 @@ static struct sep_device *sep_dev;
  *	This functions copies the cache and resident from their source
  *	location into destination shared memory.
  */
-
 static int sep_load_firmware(struct sep_device *sep)
 {
 	const struct firmware *fw;
 	char *cache_name = "cache.image.bin";
 	char *res_name = "resident.image.bin";
 	char *extapp_name = "extapp.image.bin";
-
-	int error = 0;
+	int error ;
 	unsigned int work1, work2, work3;
 
 	/* set addresses and load resident */
@@ -110,7 +108,7 @@ static int sep_load_firmware(struct sep_device *sep)
 
 	dev_dbg(&sep->pdev->dev, "resident virtual is %p\n",
 		sep->resident_addr);
-	dev_dbg(&sep->pdev->dev, "residnet bus is %lx\n",
+	dev_dbg(&sep->pdev->dev, "resident bus is %lx\n",
 		(unsigned long)sep->resident_bus);
 	dev_dbg(&sep->pdev->dev, "resident size is %08x\n",
 		sep->resident_size);
@@ -134,7 +132,7 @@ static int sep_load_firmware(struct sep_device *sep)
 
 	error = request_firmware(&fw, cache_name, &sep->pdev->dev);
 	if (error) {
-		dev_warn(&sep->pdev->dev, "cant request cache fw\n");
+		dev_warn(&sep->pdev->dev, "Unable to request cache firmware\n");
 		return error;
 	}
 
@@ -155,7 +153,7 @@ static int sep_load_firmware(struct sep_device *sep)
 
 	error = request_firmware(&fw, extapp_name, &sep->pdev->dev);
 	if (error) {
-		dev_warn(&sep->pdev->dev, "cant request extapp fw\n");
+		dev_warn(&sep->pdev->dev, "Unable to request extapp firmware\n");
 		return error;
 	}
 
@@ -181,15 +179,13 @@ MODULE_FIRMWARE("sep/extapp.image.bin");
  *	sep_dump_message - dump the message that is pending
  *	@sep: sep device
  */
-
 static void sep_dump_message(struct sep_device *sep)
 {
 	int count;
 	u32 *p = sep->shared_addr;
 	for (count = 0; count < 12 * 4; count += 4)
-		dev_dbg(&sep->pdev->dev,
-			"Word %d of the message is %x\n",
-			count, *p++);
+		dev_dbg(&sep->pdev->dev, "Word %d of the message is %x\n",
+								count, *p++);
 }
 
 /**
@@ -197,7 +193,6 @@ static void sep_dump_message(struct sep_device *sep)
  *	@sep: security processor
  *	@size: size of shared area
  */
-
 static int sep_map_and_alloc_shared_area(struct sep_device *sep)
 {
 	sep->shared_addr = dma_alloc_coherent(&sep->pdev->dev,
@@ -211,8 +206,8 @@ static int sep_map_and_alloc_shared_area(struct sep_device *sep)
 	}
 	dev_dbg(&sep->pdev->dev,
 		"sep: shared_addr %x bytes @%p (bus %llx)\n",
-		sep->shared_size, sep->shared_addr,
-			(unsigned long long)sep->shared_bus);
+				sep->shared_size, sep->shared_addr,
+				(unsigned long long)sep->shared_bus);
 	return 0;
 }
 
@@ -235,7 +230,6 @@ static void sep_unmap_and_free_shared_area(struct sep_device *sep)
  *	Returns virtual address inside the shared area according
  *	to the bus address.
  */
-
 static void *sep_shared_bus_to_virt(struct sep_device *sep,
 						dma_addr_t bus_address)
 {
@@ -249,11 +243,9 @@ static void *sep_shared_bus_to_virt(struct sep_device *sep,
  *
  *	Called when the user opens the singleton device interface
  */
-
 static int sep_singleton_open(struct inode *inode_ptr, struct file *file_ptr)
 {
 	int error = 0;
-
 	struct sep_device *sep;
 
 	/*
@@ -290,7 +282,6 @@ end_function:
  *
  *	Returns zero on success otherwise an error code.
  */
-
 static int sep_open(struct inode *inode, struct file *filp)
 {
 	struct sep_device *sep;
@@ -317,16 +308,13 @@ static int sep_open(struct inode *inode, struct file *filp)
  *	multiple simultaenous opens that means this method is called when the
  *	final reference to the open handle is dropped.
  */
-
 static int sep_singleton_release(struct inode *inode, struct file *filp)
 {
 	struct sep_device *sep = filp->private_data;
 
 	dev_dbg(&sep->pdev->dev, "Singleton release for pid %d\n",
-		current->pid);
-
+							current->pid);
 	clear_bit(0, &sep->singleton_access_flag);
-
 	return 0;
 }
 
@@ -340,14 +328,11 @@ static int sep_singleton_release(struct inode *inode, struct file *filp)
  *
  *	Returns zero on success otherwise an error code.
  */
-
 static int sep_request_daemon_open(struct inode *inode, struct file *filp)
 {
-	struct sep_device *sep;
-
+	struct sep_device *sep = sep_dev;
 	int error = 0;
 
-	sep = sep_dev;
 	filp->private_data = sep;
 
 	dev_dbg(&sep->pdev->dev, "Request daemon open for pid %d\n",
@@ -355,13 +340,8 @@ static int sep_request_daemon_open(struct inode *inode, struct file *filp)
 
 	/* There is supposed to be only one request daemon */
 	dev_dbg(&sep->pdev->dev, "calling test and set for req_dmon open 0\n");
-	if (test_and_set_bit(0, &sep->request_daemon_open)) {
+	if (test_and_set_bit(0, &sep->request_daemon_open))
 		error = -EBUSY;
-		goto end_function;
-	}
-
-end_function:
-
 	return error;
 }
 
@@ -372,7 +352,6 @@ end_function:
  *
  *	Called on the final close of a SEP daemon.
  */
-
 static int sep_request_daemon_release(struct inode *inode, struct file *filp)
 {
 	struct sep_device *sep = filp->private_data;
@@ -382,7 +361,6 @@ static int sep_request_daemon_release(struct inode *inode, struct file *filp)
 
 	/* clear the request_daemon_open flag */
 	clear_bit(0, &sep->request_daemon_open);
-
 	return 0;
 }
 
@@ -395,15 +373,11 @@ static int sep_request_daemon_release(struct inode *inode, struct file *filp)
  */
 static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
 {
-	int error = 0;
-
 	unsigned long lck_flags;
 
 	dev_dbg(&sep->pdev->dev,
 		"sep_req_daemon_send_reply_command_handler start\n");
 
-	error = 0;
-
 	sep_dump_message(sep);
 
 	/* counters are lockable region */
@@ -426,7 +400,7 @@ static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
 	dev_dbg(&sep->pdev->dev,
 		"sep_req_daemon_send_reply_command_handler end\n");
 
-	return error;
+	return 0;
 }
 
 
@@ -436,80 +410,56 @@ static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
  *
  *	Handles the request to  free dma table for synchronic actions
  */
-
 static int sep_free_dma_table_data_handler(struct sep_device *sep)
 {
-	/* counter */
-	int count = 0;
-
-	/* dcb counter */
-	int dcb_counter = 0;
-
+	int count;
+	int dcb_counter;
 	/* pointer to the current dma_resource struct */
 	struct sep_dma_resource *dma;
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_free_dma_table_data_handler start\n");
-
-
-	for (dcb_counter = 0; dcb_counter < sep->nr_dcb_creat;
-		dcb_counter++) {
+	dev_dbg(&sep->pdev->dev, "sep_free_dma_table_data_handler start\n");
 
+	for (dcb_counter = 0; dcb_counter < sep->nr_dcb_creat; dcb_counter++) {
 		dma = &sep->dma_res_arr[dcb_counter];
 
 		/* unmap and free input map array */
 		if (dma->in_map_array) {
-
-			for (count = 0; count < dma->in_num_pages;
-				count++) {
-
+			for (count = 0; count < dma->in_num_pages; count++) {
 				dma_unmap_page(&sep->pdev->dev,
 					dma->in_map_array[count].dma_addr,
 					dma->in_map_array[count].size,
 					DMA_TO_DEVICE);
 			}
-
 			kfree(dma->in_map_array);
 		}
 
 		/* unmap output map array, DON'T free it yet */
 		if (dma->out_map_array) {
-			for (count = 0; count < dma->out_num_pages;
-				count++) {
-
+			for (count = 0; count < dma->out_num_pages; count++) {
 				dma_unmap_page(&sep->pdev->dev,
 					dma->out_map_array[count].dma_addr,
 					dma->out_map_array[count].size,
 					DMA_FROM_DEVICE);
 			}
-
 			kfree(dma->out_map_array);
 		}
 
 		/* free page cache for output */
 		if (dma->in_page_array) {
-			for (count = 0; count < dma->in_num_pages;
-				count++) {
-
+			for (count = 0; count < dma->in_num_pages; count++) {
 				flush_dcache_page(dma->in_page_array[count]);
 				page_cache_release(dma->in_page_array[count]);
 			}
-
 			kfree(dma->in_page_array);
-
 		}
 
 		if (dma->out_page_array) {
-			for (count = 0; count < dma->out_num_pages;
-				count++) {
-
+			for (count = 0; count < dma->out_num_pages; count++) {
 				if (!PageReserved(dma->out_page_array[count]))
 					SetPageDirty(dma->out_page_array[count]);
-
 				flush_dcache_page(dma->out_page_array[count]);
 				page_cache_release(dma->out_page_array[count]);
 			}
-
 			kfree(dma->out_page_array);
 		}
 
@@ -522,19 +472,15 @@ static int sep_free_dma_table_data_handler(struct sep_device *sep)
 		dma->out_map_array = 0;
 		dma->in_map_num_entries = 0;
 		dma->out_map_num_entries = 0;
-
 	}
 
 	sep->nr_dcb_creat = 0;
 	sep->num_lli_tables_created = 0;
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_free_dma_table_data_handler end\n");
-
+	dev_dbg(&sep->pdev->dev, "sep_free_dma_table_data_handler end\n");
 	return 0;
 }
 
-
 /**
  *	sep_request_daemon_mmap - maps the shared area to user space
  *	@filp: pointer to struct file
@@ -546,11 +492,8 @@ static int sep_free_dma_table_data_handler(struct sep_device *sep)
 static int sep_request_daemon_mmap(struct file  *filp,
 	struct vm_area_struct  *vma)
 {
-	/* device */
 	struct sep_device *sep = filp->private_data;
-
 	dma_addr_t bus_address;
-
 	int error = 0;
 
 	dev_dbg(&sep->pdev->dev, "daemon mmap start\n");
@@ -563,23 +506,19 @@ static int sep_request_daemon_mmap(struct file  *filp,
 	/* get physical address */
 	bus_address = sep->shared_bus;
 
-	dev_dbg(&sep->pdev->dev,
-		"bus_address is %08lx\n",
-		(unsigned long)bus_address);
+	dev_dbg(&sep->pdev->dev, "bus_address is %08lx\n",
+					(unsigned long)bus_address);
 
 	if (remap_pfn_range(vma, vma->vm_start, bus_address >> PAGE_SHIFT,
 		vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
 
-		dev_warn(&sep->pdev->dev,
-			"remap_page_range failed\n");
+		dev_warn(&sep->pdev->dev, "remap_page_range failed\n");
 		error = -EAGAIN;
 		goto end_function;
 	}
 
 end_function:
-
 	dev_dbg(&sep->pdev->dev, "daemon mmap end\n");
-
 	return error;
 }
 
@@ -595,69 +534,46 @@ static unsigned int sep_request_daemon_poll(struct file *filp,
 	poll_table  *wait)
 {
 	u32	mask = 0;
-
 	/* GPR2 register */
 	u32	retval2;
-
 	unsigned long lck_flags;
-
 	struct sep_device *sep = filp->private_data;
 
-	dev_dbg(&sep->pdev->dev,
-		"daemon poll: start\n");
-
-	dev_dbg(&sep->pdev->dev, "daemon poll: calling poll wait sep_event\n");
+	dev_dbg(&sep->pdev->dev, "daemon poll: start\n");
 
 	poll_wait(filp, &sep->event_request_daemon, wait);
 
-	dev_dbg(&sep->pdev->dev, "daemon poll: exit poll wait sep_event\n");
-
-	dev_dbg(&sep->pdev->dev,
-		"daemon poll: send_ct is %lx reply ct is %lx\n",
-		sep->send_ct, sep->reply_ct);
+	dev_dbg(&sep->pdev->dev, "daemon poll: send_ct is %lx reply ct is %lx\n",
+						sep->send_ct, sep->reply_ct);
 
 	spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
 	/* check if the data is ready */
 	if (sep->send_ct == sep->reply_ct) {
-
 		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
 
 		retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
-
 		dev_dbg(&sep->pdev->dev,
 			"daemon poll: data check (GPR2) is %x\n", retval2);
 
 		/* check if PRINT request */
 		if ((retval2 >> 30) & 0x1) {
-
-			dev_dbg(&sep->pdev->dev,
-				"daemon poll: PRINTF request in\n");
+			dev_dbg(&sep->pdev->dev, "daemon poll: PRINTF request in\n");
 			mask |= POLLIN;
 			goto end_function;
 		}
-
 		/* check if NVS request */
 		if (retval2 >> 31) {
-
-			dev_dbg(&sep->pdev->dev,
-				"daemon poll: NVS request in\n");
+			dev_dbg(&sep->pdev->dev, "daemon poll: NVS request in\n");
 			mask |= POLLPRI | POLLWRNORM;
 		}
-	}
-
-	else {
-
+	} else {
 		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
-
 		dev_dbg(&sep->pdev->dev,
 			"daemon poll: no reply received; returning 0\n");
 		mask = 0;
 	}
-
 end_function:
-
-	dev_dbg(&sep->pdev->dev,
-		"daemon poll: exit\n");
+	dev_dbg(&sep->pdev->dev, "daemon poll: exit\n");
 	return mask;
 }
 
@@ -668,7 +584,6 @@ end_function:
  *
  *	Called on the final close of a SEP device.
  */
-
 static int sep_release(struct inode *inode, struct file *filp)
 {
 	struct sep_device *sep = filp->private_data;
@@ -709,9 +624,6 @@ static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	dev_dbg(&sep->pdev->dev, "mmap start\n");
 
-
-	dev_dbg(&sep->pdev->dev, "calling wait on event_mmap, tsetbit"
-		" SEP_MMAP_LOCK_BIT in_use_flags 0\n");
 	/* Set the transaction busy (own the device) */
 	wait_event_interruptible(sep->event,
 		test_and_set_bit(SEP_MMAP_LOCK_BIT,
@@ -748,8 +660,7 @@ static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
 		goto end_function_with_error;
 	}
 
-	dev_dbg(&sep->pdev->dev,
-		"shared_addr is %p\n", sep->shared_addr);
+	dev_dbg(&sep->pdev->dev, "shared_addr is %p\n", sep->shared_addr);
 
 	/* get bus address */
 	bus_addr = sep->shared_bus;
@@ -759,17 +670,14 @@ static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	if (remap_pfn_range(vma, vma->vm_start, bus_addr >> PAGE_SHIFT,
 		vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
-		dev_warn(&sep->pdev->dev,
-			"remap_page_range failed\n");
+		dev_warn(&sep->pdev->dev, "remap_page_range failed\n");
 		error = -EAGAIN;
 		goto end_function_with_error;
 	}
-
 	dev_dbg(&sep->pdev->dev, "mmap end\n");
 	goto end_function;
 
 end_function_with_error:
-
 	/* clear the bit */
 	clear_bit(SEP_MMAP_LOCK_BIT, &sep->in_use_flags);
 	mutex_lock(&sep->sep_mutex);
@@ -782,7 +690,6 @@ end_function_with_error:
 	wake_up(&sep->event);
 
 end_function:
-
 	return error;
 }
 
@@ -799,7 +706,6 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 	u32 mask = 0;
 	u32 retval = 0;
 	u32 retval2 = 0;
-
 	unsigned long lck_flags;
 
 	struct sep_device *sep = filp->private_data;
@@ -814,7 +720,6 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 		mutex_unlock(&sep->sep_mutex);
 		goto end_function;
 	}
-
 	mutex_unlock(&sep->sep_mutex);
 
 	/* check if send command or send_reply were activated previously */
@@ -829,18 +734,13 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 
 	poll_wait(filp, &sep->event, wait);
 
-	dev_dbg(&sep->pdev->dev, "poll: exit wait sep_event\n");
-
 	dev_dbg(&sep->pdev->dev, "poll: send_ct is %lx reply ct is %lx\n",
 		sep->send_ct, sep->reply_ct);
 
 	/* check if error occured during poll */
 	retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
-
 	if (retval2 != 0x0) {
-
-		dev_warn(&sep->pdev->dev, "poll; poll error %x\n",
-			retval2);
+		dev_warn(&sep->pdev->dev, "poll; poll error %x\n", retval2);
 		mask |= POLLERR;
 		goto end_function;
 	}
@@ -848,7 +748,6 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 	spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
 
 	if (sep->send_ct == sep->reply_ct) {
-
 		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
 		retval = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
 		dev_dbg(&sep->pdev->dev, "poll: data ready check (GPR2)  %x\n",
@@ -856,46 +755,33 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 
 		/* check if printf request  */
 		if ((retval >> 30) & 0x1) {
-
 			dev_dbg(&sep->pdev->dev, "poll: sep printf request\n");
 			wake_up(&sep->event_request_daemon);
 			goto end_function;
-
 		}
 
 		/* check if the this is sep reply or request */
 		if (retval >> 31) {
-
 			dev_dbg(&sep->pdev->dev, "poll: sep request\n");
 			wake_up(&sep->event_request_daemon);
-
 		} else {
-
 			dev_dbg(&sep->pdev->dev, "poll: normal return\n");
-
 			/* in case it is again by send_reply_comand */
-
 			clear_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags);
-
 			sep_dump_message(sep);
-
 			dev_dbg(&sep->pdev->dev,
 				"poll; sep reply POLLIN | POLLRDNORM\n");
 
 			mask |= POLLIN | POLLRDNORM;
 		}
-
 	} else {
-
 		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
-
 		dev_dbg(&sep->pdev->dev,
 			"poll; no reply received; returning mask of 0\n");
 		mask = 0;
 	}
 
 end_function:
-
 	dev_dbg(&sep->pdev->dev, "poll: end\n");
 	return mask;
 }
@@ -907,7 +793,6 @@ end_function:
  *	Return the address of the two dwords in memory used for time
  *	setting.
  */
-
 static u32 *sep_time_address(struct sep_device *sep)
 {
 	return sep->shared_addr + SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES;
@@ -926,8 +811,7 @@ static unsigned long sep_set_time(struct sep_device *sep)
 	u32 *time_addr;	/* address of time as seen by the kernel */
 
 
-	dev_dbg(&sep->pdev->dev,
-		"sep:sep_set_time start\n");
+	dev_dbg(&sep->pdev->dev, "sep:sep_set_time start\n");
 
 	do_gettimeofday(&time);
 
@@ -937,12 +821,9 @@ static unsigned long sep_set_time(struct sep_device *sep)
 	time_addr[0] = SEP_TIME_VAL_TOKEN;
 	time_addr[1] = time.tv_sec;
 
-	dev_dbg(&sep->pdev->dev,
-		"time.tv_sec is %lu\n", time.tv_sec);
-	dev_dbg(&sep->pdev->dev,
-		"time_addr is %p\n", time_addr);
-	dev_dbg(&sep->pdev->dev,
-		"sep->shared_addr is %p\n", sep->shared_addr);
+	dev_dbg(&sep->pdev->dev, "time.tv_sec is %lu\n", time.tv_sec);
+	dev_dbg(&sep->pdev->dev, "time_addr is %p\n", time_addr);
+	dev_dbg(&sep->pdev->dev, "sep->shared_addr is %p\n", sep->shared_addr);
 
 	return time.tv_sec;
 }
@@ -958,14 +839,11 @@ static unsigned long sep_set_time(struct sep_device *sep)
 static int sep_set_caller_id_handler(struct sep_device *sep, u32 arg)
 {
 	void __user *hash;
-	int   error;
+	int   error = 0;
 	int   i;
 	struct caller_id_struct command_args;
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_set_caller_id_handler start\n");
-
-	error = 0;
+	dev_dbg(&sep->pdev->dev, "sep_set_caller_id_handler start\n");
 
 	for (i = 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
 		if (sep->caller_id_table[i].pid == 0)
@@ -973,12 +851,9 @@ static int sep_set_caller_id_handler(struct sep_device *sep, u32 arg)
 	}
 
 	if (i == SEP_CALLER_ID_TABLE_NUM_ENTRIES) {
-		dev_warn(&sep->pdev->dev,
-			"no more caller id entries left\n");
-		dev_warn(&sep->pdev->dev,
-			"maximum number is %d\n",
-			SEP_CALLER_ID_TABLE_NUM_ENTRIES);
-
+		dev_warn(&sep->pdev->dev, "no more caller id entries left\n");
+		dev_warn(&sep->pdev->dev, "maximum number is %d\n",
+					SEP_CALLER_ID_TABLE_NUM_ENTRIES);
 		error = -EUSERS;
 		goto end_function;
 	}
@@ -1002,7 +877,7 @@ static int sep_set_caller_id_handler(struct sep_device *sep, u32 arg)
 		command_args.callerIdSizeInBytes);
 
 	if (command_args.callerIdSizeInBytes >
-				SEP_CALLER_ID_HASH_SIZE_IN_BYTES) {
+					SEP_CALLER_ID_HASH_SIZE_IN_BYTES) {
 		error = -EMSGSIZE;
 		goto end_function;
 	}
@@ -1013,8 +888,7 @@ static int sep_set_caller_id_handler(struct sep_device *sep, u32 arg)
 		hash, command_args.callerIdSizeInBytes))
 		error = -EFAULT;
 end_function:
-	dev_dbg(&sep->pdev->dev,
-		"sep_set_caller_id_handler end\n");
+	dev_dbg(&sep->pdev->dev, "sep_set_caller_id_handler end\n");
 	return error;
 }
 
@@ -1030,29 +904,23 @@ static int sep_set_current_caller_id(struct sep_device *sep)
 	int i;
 
 	dev_dbg(&sep->pdev->dev, "sep_set_current_caller_id start\n");
-
 	dev_dbg(&sep->pdev->dev, "current process is %d\n", current->pid);
 
 	/* zero the previous value */
-	memset((void *)(sep->shared_addr +
-		(SEP_CALLER_ID_OFFSET_BYTES)),
-		0,
-		SEP_CALLER_ID_HASH_SIZE_IN_BYTES);
+	memset(sep->shared_addr + SEP_CALLER_ID_OFFSET_BYTES,
+					0, SEP_CALLER_ID_HASH_SIZE_IN_BYTES);
 
 	for (i = 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
 		if (sep->caller_id_table[i].pid == current->pid) {
 			dev_dbg(&sep->pdev->dev, "Caller Id found\n");
 
-			memcpy((void *)(sep->shared_addr +
-				(SEP_CALLER_ID_OFFSET_BYTES)),
+			memcpy(sep->shared_addr + SEP_CALLER_ID_OFFSET_BYTES,
 				(void *)(sep->caller_id_table[i].callerIdHash),
 				SEP_CALLER_ID_HASH_SIZE_IN_BYTES);
 			break;
 		}
 	}
-
 	dev_dbg(&sep->pdev->dev, "sep_set_current_caller_id end\n");
-
 	return 0;
 }
 
@@ -1065,7 +933,6 @@ static int sep_set_current_caller_id(struct sep_device *sep)
  *
  *      Note that this function does fall under the ioctl lock
  */
-
 static int sep_send_command_handler(struct sep_device *sep)
 {
 	unsigned long lck_flags;
@@ -1073,13 +940,10 @@ static int sep_send_command_handler(struct sep_device *sep)
 
 	dev_dbg(&sep->pdev->dev, "sep_send_command_handler start\n");
 
-	dev_dbg(&sep->pdev->dev, "calling test and set for "
-		" in_use_flags SEP_SEND_MSG_LOCK_BIT 0\n");
 	if (test_and_set_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags)) {
 		error = -EPROTO;
 		goto end_function;
 	}
-
 	sep_set_time(sep);
 
 	/* only Medfield has caller id */
@@ -1093,8 +957,9 @@ static int sep_send_command_handler(struct sep_device *sep)
 	sep->send_ct++;
 	spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
 
-	dev_dbg(&sep->pdev->dev, "sep_send_command_handler"
-		"send_ct %lx reply_ct %lx\n", sep->send_ct, sep->reply_ct);
+	dev_dbg(&sep->pdev->dev,
+		"sep_send_command_handler send_ct %lx reply_ct %lx\n",
+						sep->send_ct, sep->reply_ct);
 
 	/* send interrupt to SEP */
 	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x2);
@@ -1156,8 +1021,7 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 		SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES +
 		(sep->num_of_data_allocations)*2*sizeof(u32));
 
-	dev_dbg(&sep->pdev->dev,
-		"allocation offset: %x\n",
+	dev_dbg(&sep->pdev->dev, "allocation offset: %x\n",
 		SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES);
 	dev_dbg(&sep->pdev->dev, "data pool token addr is %p\n", token_addr);
 
@@ -1173,7 +1037,7 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 	error = copy_to_user((void *)arg, (void *)&command_args,
 		sizeof(struct alloc_struct));
 	if (error) {
-
+		error = -EFAULT;
 		dev_warn(&sep->pdev->dev,
 			"allocate data pool copy to user error\n");
 		goto end_function;
@@ -1189,9 +1053,7 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 		(int)sep->data_pool_bytes_allocated);
 
 end_function:
-
-	dev_dbg(&sep->pdev->dev,
-		"sep_allocate_data_pool_memory_handler end\n");
+	dev_dbg(&sep->pdev->dev, "sep_allocate_data_pool_memory_handler end\n");
 	return error;
 }
 
@@ -1216,12 +1078,9 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 	int in_out_flag)
 
 {
-	/* error */
 	int error = 0;
-
 	/* array of lli */
 	struct sep_lli_entry *lli_array;
-
 	/* map array */
 	struct sep_dma_map *map_array;
 
@@ -1235,11 +1094,9 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 
 	lli_array = kmalloc(sizeof(struct sep_lli_entry), GFP_ATOMIC);
 	if (!lli_array) {
-
 		error = -ENOMEM;
 		goto end_function;
 	}
-
 	map_array = kmalloc(sizeof(struct sep_dma_map), GFP_ATOMIC);
 	if (!map_array) {
 		error = -ENOMEM;
@@ -1260,8 +1117,7 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 	lli_array[0].block_size = map_array[0].size;
 
 	dev_dbg(&sep->pdev->dev,
-		"lli_array[0].bus_address is %08lx,"
-		" lli_array[0].block_size is %x\n",
+	"lli_array[0].bus_address is %08lx, lli_array[0].block_size is %x\n",
 		(unsigned long)lli_array[0].bus_address,
 		lli_array[0].block_size);
 
@@ -1279,18 +1135,13 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 		sep->dma_res_arr[sep->nr_dcb_creat].out_map_array = map_array;
 		sep->dma_res_arr[sep->nr_dcb_creat].out_map_num_entries = 1;
 	}
-
 	goto end_function;
 
 end_function_with_error:
-
 	kfree(lli_array);
 
 end_function:
-
-	dev_dbg(&sep->pdev->dev,
-		"sep_lock_kernel_pages end\n");
-
+	dev_dbg(&sep->pdev->dev, "sep_lock_kernel_pages end\n");
 	return error;
 }
 
@@ -1314,59 +1165,39 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	int in_out_flag)
 
 {
-	/* error */
-	int error;
-
+	int error = 0;
+	u32 count;
+	int result;
 	/* the the page of the end address of the user space buffer */
 	u32 end_page;
-
 	/* the page of the start address of the user space buffer */
 	u32 start_page;
-
 	/* the range in pages */
 	u32 num_pages;
-
-	/* array of pointers ot page */
+	/* array of pointers to page */
 	struct page **page_array;
-
 	/* array of lli */
 	struct sep_lli_entry *lli_array;
-
 	/* map array */
 	struct sep_dma_map *map_array;
-
 	/* direction of the DMA mapping for locked pages */
 	enum dma_data_direction	dir;
 
-	/* count */
-	u32 count;
-
-	/* result */
-	int result;
-
 	dev_dbg(&sep->pdev->dev,
 		"sep_lock_user_pages start\n");
 
-	error = 0;
-
 	/* set start and end pages  and num pages */
 	end_page = (app_virt_addr + data_size - 1) >> PAGE_SHIFT;
 	start_page = app_virt_addr >> PAGE_SHIFT;
 	num_pages = end_page - start_page + 1;
 
-	dev_dbg(&sep->pdev->dev,
-		"app_virt_addr is %x\n", app_virt_addr);
-	dev_dbg(&sep->pdev->dev,
-		"data_size is %x\n", data_size);
-	dev_dbg(&sep->pdev->dev,
-		"start_page is %x\n", start_page);
-	dev_dbg(&sep->pdev->dev,
-		"end_page is %x\n", end_page);
-	dev_dbg(&sep->pdev->dev,
-		"num_pages is %x\n", num_pages);
+	dev_dbg(&sep->pdev->dev, "app_virt_addr is %x\n", app_virt_addr);
+	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
+	dev_dbg(&sep->pdev->dev, "start_page is %x\n", start_page);
+	dev_dbg(&sep->pdev->dev, "end_page is %x\n", end_page);
+	dev_dbg(&sep->pdev->dev, "num_pages is %x\n", num_pages);
 
-	dev_dbg(&sep->pdev->dev,
-		"starting page_array malloc\n");
+	dev_dbg(&sep->pdev->dev, "starting page_array malloc\n");
 
 	/* allocate array of pages structure pointers */
 	page_array = kmalloc(sizeof(struct page *) * num_pages, GFP_ATOMIC);
@@ -1374,11 +1205,9 @@ static int sep_lock_user_pages(struct sep_device *sep,
 		error = -ENOMEM;
 		goto end_function;
 	}
-
 	map_array = kmalloc(sizeof(struct sep_dma_map) * num_pages, GFP_ATOMIC);
 	if (!map_array) {
-		dev_warn(&sep->pdev->dev,
-			"kmalloc for map_array failed\n");
+		dev_warn(&sep->pdev->dev, "kmalloc for map_array failed\n");
 		error = -ENOMEM;
 		goto end_function_with_error1;
 	}
@@ -1387,15 +1216,12 @@ static int sep_lock_user_pages(struct sep_device *sep,
 		GFP_ATOMIC);
 
 	if (!lli_array) {
-
-		dev_warn(&sep->pdev->dev,
-			"kmalloc for lli_array failed\n");
+		dev_warn(&sep->pdev->dev, "kmalloc for lli_array failed\n");
 		error = -ENOMEM;
 		goto end_function_with_error2;
 	}
 
-	dev_dbg(&sep->pdev->dev,
-		"starting get_user_pages\n");
+	dev_dbg(&sep->pdev->dev, "starting get_user_pages\n");
 
 	/* convert the application virtual address into a set of physical */
 	down_read(&current->mm->mmap_sem);
@@ -1408,15 +1234,13 @@ static int sep_lock_user_pages(struct sep_device *sep,
 
 	/* check the number of pages locked - if not all then exit with error */
 	if (result != num_pages) {
-
 		dev_warn(&sep->pdev->dev,
 			"not all pages locked by get_user_pages\n");
 		error = -ENOMEM;
 		goto end_function_with_error3;
 	}
 
-	dev_dbg(&sep->pdev->dev,
-		"get_user_pages succeeded\n");
+	dev_dbg(&sep->pdev->dev, "get_user_pages succeeded\n");
 
 	/* set direction */
 	if (in_out_flag == SEP_DRIVER_IN_FLAG)
@@ -1441,9 +1265,7 @@ static int sep_lock_user_pages(struct sep_device *sep,
 		lli_array[count].bus_address = (u32)map_array[count].dma_addr;
 		lli_array[count].block_size = PAGE_SIZE;
 
-		dev_warn(&sep->pdev->dev,
-			"lli_array[%x].bus_address is %08lx, \
-			lli_array[%x].block_size is %x\n",
+		dev_warn(&sep->pdev->dev, "lli_array[%x].bus_address is %08lx, lli_array[%x].block_size is %x\n",
 			count, (unsigned long)lli_array[count].bus_address,
 			count, lli_array[count].block_size);
 	}
@@ -1460,20 +1282,17 @@ static int sep_lock_user_pages(struct sep_device *sep,
 			PAGE_SIZE - (app_virt_addr & (~PAGE_MASK));
 
 	dev_dbg(&sep->pdev->dev,
-		"lli_array[0].bus_address is %08lx, \
-		lli_array[0].block_size is %x\n",
+		"lli_array[0].bus_address is %08lx, lli_array[0].block_size is %x\n",
 		(unsigned long)lli_array[count].bus_address,
 		lli_array[count].block_size);
 
 	/* check the size of the last page */
 	if (num_pages > 1) {
-
 		lli_array[num_pages - 1].block_size =
 			(app_virt_addr + data_size) & (~PAGE_MASK);
 
 		dev_warn(&sep->pdev->dev,
-			"lli_array[%x].bus_address is %08lx, \
-			lli_array[%x].block_size is %x\n",
+			"lli_array[%x].bus_address is %08lx, lli_array[%x].block_size is %x\n",
 			num_pages - 1,
 			(unsigned long)lli_array[count].bus_address,
 			num_pages - 1,
@@ -1483,47 +1302,35 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	/* set output params acording to the in_out flag */
 	if (in_out_flag == SEP_DRIVER_IN_FLAG) {
 		*lli_array_ptr = lli_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages =
-			num_pages;
-		sep->dma_res_arr[sep->nr_dcb_creat].in_page_array =
-			page_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].in_map_array =
-			map_array;
+		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = num_pages;
+		sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = page_array;
+		sep->dma_res_arr[sep->nr_dcb_creat].in_map_array = map_array;
 		sep->dma_res_arr[sep->nr_dcb_creat].in_map_num_entries =
-			num_pages;
+								num_pages;
 	} else {
 		*lli_array_ptr = lli_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages =
-			num_pages;
+		sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages = num_pages;
 		sep->dma_res_arr[sep->nr_dcb_creat].out_page_array =
-			page_array;
-		sep->dma_res_arr[sep->nr_dcb_creat].out_map_array =
-			map_array;
+								page_array;
+		sep->dma_res_arr[sep->nr_dcb_creat].out_map_array = map_array;
 		sep->dma_res_arr[sep->nr_dcb_creat].out_map_num_entries =
-			num_pages;
+								num_pages;
 	}
-
 	goto end_function;
 
 end_function_with_error3:
-
 	/* free lli array */
 	kfree(lli_array);
 
 end_function_with_error2:
-
 	kfree(map_array);
 
 end_function_with_error1:
-
 	/* free page array */
 	kfree(page_array);
 
 end_function:
-
-	dev_dbg(&sep->pdev->dev,
-		"sep_lock_user_pages end\n");
-
+	dev_dbg(&sep->pdev->dev, "sep_lock_user_pages end\n");
 	return error;
 }
 
@@ -1544,16 +1351,12 @@ static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
 	u32 num_array_entries,
 	u32 *last_table_flag)
 {
+	u32 counter;
 	/* table data size */
-	u32 table_data_size;
-
+	u32 table_data_size = 0;
 	/* data size for the next table */
 	u32 next_table_data_size;
 
-	/* counter */
-	u32 counter;
-
-	table_data_size = 0;
 	*last_table_flag = 0;
 
 	/*
@@ -1562,7 +1365,7 @@ static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
 	 */
 	for (counter = 0;
 		(counter < (SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP - 1)) &&
-		(counter < num_array_entries); counter++)
+			(counter < num_array_entries); counter++)
 		table_data_size += lli_in_array_ptr[counter].block_size;
 
 	/*
@@ -1571,7 +1374,6 @@ static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
 	 * and no need to check the block alignment
 	 */
 	if (counter == num_array_entries) {
-
 		/* set the last table flag */
 		*last_table_flag = 1;
 		goto end_function;
@@ -1584,11 +1386,8 @@ static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
 	 */
 	next_table_data_size = 0;
 	for (; counter < num_array_entries; counter++) {
-
 		next_table_data_size += lli_in_array_ptr[counter].block_size;
-
 		if (next_table_data_size >= SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE)
-
 			break;
 	}
 
@@ -1603,11 +1402,9 @@ static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
 		table_data_size -= (SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE -
 			next_table_data_size);
 
-	dev_dbg(&sep->pdev->dev,
-		"table data size is %x\n", table_data_size);
-
+	dev_dbg(&sep->pdev->dev, "table data size is %x\n",
+							table_data_size);
 end_function:
-
 	return table_data_size;
 }
 
@@ -1632,20 +1429,17 @@ static void sep_build_lli_table(struct sep_device *sep,
 {
 	/* current table data size */
 	u32 curr_table_data_size;
-
 	/* counter of lli array entry */
 	u32 array_counter;
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_build_lli_table start\n");
+	dev_dbg(&sep->pdev->dev, "sep_build_lli_table start\n");
 
 	/* init currrent table data size and lli array entry counter */
 	curr_table_data_size = 0;
 	array_counter = 0;
 	*num_table_entries_ptr = 1;
 
-	dev_dbg(&sep->pdev->dev,
-		"table_data_size is %x\n", table_data_size);
+	dev_dbg(&sep->pdev->dev, "table_data_size is %x\n", table_data_size);
 
 	/* fill the table till table size reaches the needed amount */
 	while (curr_table_data_size < table_data_size) {
@@ -1660,18 +1454,15 @@ static void sep_build_lli_table(struct sep_device *sep,
 
 		curr_table_data_size += lli_array_ptr[array_counter].block_size;
 
-		dev_dbg(&sep->pdev->dev,
-			"lli_table_ptr is %p\n", lli_table_ptr);
-		dev_dbg(&sep->pdev->dev,
-			"lli_table_ptr->bus_address is %08lx\n",
-			(unsigned long)lli_table_ptr->bus_address);
-		dev_dbg(&sep->pdev->dev,
-			"lli_table_ptr->block_size is %x\n",
+		dev_dbg(&sep->pdev->dev, "lli_table_ptr is %p\n",
+								lli_table_ptr);
+		dev_dbg(&sep->pdev->dev, "lli_table_ptr->bus_address is %08lx\n",
+				(unsigned long)lli_table_ptr->bus_address);
+		dev_dbg(&sep->pdev->dev, "lli_table_ptr->block_size is %x\n",
 			lli_table_ptr->block_size);
 
 		/* check for overflow of the table data */
 		if (curr_table_data_size > table_data_size) {
-
 			dev_dbg(&sep->pdev->dev,
 				"curr_table_data_size too large\n");
 
@@ -1686,15 +1477,13 @@ static void sep_build_lli_table(struct sep_device *sep,
 			/* update the block size left in the lli array */
 			lli_array_ptr[array_counter].block_size =
 				(curr_table_data_size - table_data_size);
-
 		} else
-
 			/* advance to the next entry in the lli_array */
 			array_counter++;
 
 		dev_dbg(&sep->pdev->dev,
 			"lli_table_ptr->bus_address is %08lx\n",
-			(unsigned long)lli_table_ptr->bus_address);
+				(unsigned long)lli_table_ptr->bus_address);
 		dev_dbg(&sep->pdev->dev,
 			"lli_table_ptr->block_size is %x\n",
 			lli_table_ptr->block_size);
@@ -1707,26 +1496,19 @@ static void sep_build_lli_table(struct sep_device *sep,
 	lli_table_ptr->bus_address = 0xffffffff;
 	lli_table_ptr->block_size = 0;
 
-	dev_dbg(&sep->pdev->dev,
-		"lli_table_ptr is %p\n", lli_table_ptr);
-	dev_dbg(&sep->pdev->dev,
-		"lli_table_ptr->bus_address is %08lx\n",
-		(unsigned long)lli_table_ptr->bus_address);
-	dev_dbg(&sep->pdev->dev,
-		"lli_table_ptr->block_size is %x\n",
-		lli_table_ptr->block_size);
+	dev_dbg(&sep->pdev->dev, "lli_table_ptr is %p\n", lli_table_ptr);
+	dev_dbg(&sep->pdev->dev, "lli_table_ptr->bus_address is %08lx\n",
+				(unsigned long)lli_table_ptr->bus_address);
+	dev_dbg(&sep->pdev->dev, "lli_table_ptr->block_size is %x\n",
+						lli_table_ptr->block_size);
 
 	/* set the output parameter */
 	*num_processed_entries_ptr += array_counter;
 
-	dev_dbg(&sep->pdev->dev,
-		"num_processed_entries_ptr is %x\n",
+	dev_dbg(&sep->pdev->dev, "num_processed_entries_ptr is %x\n",
 		*num_processed_entries_ptr);
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_build_lli_table end\n");
-
-	return;
+	dev_dbg(&sep->pdev->dev, "sep_build_lli_table end\n");
 }
 
 /**
@@ -1742,16 +1524,12 @@ static void sep_build_lli_table(struct sep_device *sep,
 static dma_addr_t sep_shared_area_virt_to_bus(struct sep_device *sep,
 	void *virt_address)
 {
-	dev_dbg(&sep->pdev->dev,
-		"sh virt to phys v %08lx\n",
-		(unsigned long)virt_address);
-	dev_dbg(&sep->pdev->dev,
-		"sh virt to phys p %08lx\n",
-		(unsigned long)(sep->shared_bus
-		+ (virt_address - sep->shared_addr)));
+	dev_dbg(&sep->pdev->dev, "sh virt to phys v %p\n", virt_address);
+	dev_dbg(&sep->pdev->dev, "sh virt to phys p %08lx\n",
+		(unsigned long)
+		sep->shared_bus + (virt_address - sep->shared_addr));
 
-	return sep->shared_bus
-		+ (size_t)(virt_address - sep->shared_addr);
+	return sep->shared_bus + (size_t)(virt_address - sep->shared_addr);
 }
 
 /**
@@ -1764,18 +1542,14 @@ static dma_addr_t sep_shared_area_virt_to_bus(struct sep_device *sep,
  *	externa RAM device (ioremapped), or on the system RAM
  *	This implementation is for the external RAM
  */
-
 static void *sep_shared_area_bus_to_virt(struct sep_device *sep,
 	dma_addr_t bus_address)
 {
-	dev_dbg(&sep->pdev->dev,
-		"shared bus to virt b=%x v=%x\n",
-		(u32)bus_address,
-		(u32)(sep->shared_addr +
+	dev_dbg(&sep->pdev->dev, "shared bus to virt b=%x v=%x\n",
+		(u32)bus_address, (u32)(sep->shared_addr +
 			(size_t)(bus_address - sep->shared_bus)));
 
-	return sep->shared_addr
-		+ (size_t)(bus_address - sep->shared_bus);
+	return sep->shared_addr	+ (size_t)(bus_address - sep->shared_bus);
 }
 
 /**
@@ -1792,20 +1566,17 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 	unsigned long num_table_entries,
 	unsigned long table_data_size)
 {
-	unsigned long table_count = 0;
+	unsigned long table_count = 1;
 	unsigned long entries_count = 0;
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_debug_print_lli_tables start\n");
+	dev_dbg(&sep->pdev->dev, "sep_debug_print_lli_tables start\n");
 
-	table_count = 1;
 	while ((unsigned long) lli_table_ptr != 0xffffffff) {
 		dev_dbg(&sep->pdev->dev,
 			"lli table %08lx, table_data_size is %lu\n",
 			table_count, table_data_size);
-		dev_dbg(&sep->pdev->dev,
-			"num_table_entries is %lu\n",
-			num_table_entries);
+		dev_dbg(&sep->pdev->dev, "num_table_entries is %lu\n",
+							num_table_entries);
 
 		/* print entries of the table (without info entry) */
 		for (entries_count = 0; entries_count < num_table_entries;
@@ -1820,7 +1591,6 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 				(unsigned long)lli_table_ptr->bus_address,
 				lli_table_ptr->block_size);
 		}
-
 		/* point to the info entry */
 		lli_table_ptr--;
 
@@ -1850,8 +1620,7 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 
 		table_count++;
 	}
-	dev_dbg(&sep->pdev->dev,
-			"sep_debug_print_lli_tables end\n");
+	dev_dbg(&sep->pdev->dev, "sep_debug_print_lli_tables end\n");
 }
 
 
@@ -1863,7 +1632,6 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
  *	@table_data_size_ptr: point to table data size
  *
  *	This function creates empty lli tables when there is no data
-
  */
 static void sep_prepare_empty_lli_table(struct sep_device *sep,
 		dma_addr_t *lli_table_addr_ptr,
@@ -1878,9 +1646,8 @@ static void sep_prepare_empty_lli_table(struct sep_device *sep,
 	lli_table_ptr =
 		(struct sep_lli_entry *)(sep->shared_addr +
 		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
-		sep->num_lli_tables_created *
-		sizeof(struct sep_lli_entry) *
-		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
+		sep->num_lli_tables_created * sizeof(struct sep_lli_entry) *
+			SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
 
 	lli_table_ptr->bus_address = 0;
 	lli_table_ptr->block_size = 0;
@@ -1931,43 +1698,29 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 	u32 *table_data_size_ptr,
 	bool is_kva)
 {
+	int error = 0;
 	/* pointer to the info entry of the table - the last entry */
 	struct sep_lli_entry *info_entry_ptr;
-
-	/* array of pointers ot page */
+	/* array of pointers to page */
 	struct sep_lli_entry *lli_array_ptr;
-
 	/* points to the first entry to be processed in the lli_in_array */
 	u32 current_entry = 0;
-
 	/* num entries in the virtual buffer */
 	u32 sep_lli_entries = 0;
-
 	/* lli table pointer */
 	struct sep_lli_entry *in_lli_table_ptr;
-
 	/* the total data in one table */
 	u32 table_data_size = 0;
-
 	/* flag for last table */
 	u32 last_table_flag = 0;
-
 	/* number of entries in lli table */
 	u32 num_entries_in_table = 0;
-
 	/* next table address */
 	u32 lli_table_alloc_addr = 0;
 
-	/* error */
-	int error = 0;
-
-	dev_dbg(&sep->pdev->dev,
-		"sep_prepare_input_dma_table start\n");
-
-	dev_dbg(&sep->pdev->dev,
-		"data_size is %x\n", data_size);
-	dev_dbg(&sep->pdev->dev,
-		"block_size is %x\n", block_size);
+	dev_dbg(&sep->pdev->dev, "sep_prepare_input_dma_table start\n");
+	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
+	dev_dbg(&sep->pdev->dev, "block_size is %x\n", block_size);
 
 	/* initialize the pages pointers */
 	sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = 0;
@@ -1976,29 +1729,22 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 	/* set the kernel address for first table to be allocated */
 	lli_table_alloc_addr = (u32)(sep->shared_addr +
 		SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
-		sep->num_lli_tables_created *
-		sizeof(struct sep_lli_entry) *
+		sep->num_lli_tables_created * sizeof(struct sep_lli_entry) *
 		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
 
 	if (data_size == 0) {
-
 		/* special case  - create meptu table - 2 entries, zero data */
 		sep_prepare_empty_lli_table(sep, lli_table_ptr,
-			num_entries_ptr,
-			table_data_size_ptr);
-
+				num_entries_ptr, table_data_size_ptr);
 		goto update_dcb_counter;
 	}
 
 	/* check if the pages are in Kernel Virtual Address layout */
 	if (is_kva == true)
-
 		/* lock the pages in the kernel */
 		error = sep_lock_kernel_pages(sep, app_virt_addr,
 			data_size, &lli_array_ptr, SEP_DRIVER_IN_FLAG);
-
 	else
-
 		/*
 		 * lock the pages of the user buffer
 		 * and translate them to pages
@@ -2009,15 +1755,13 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 	if (error)
 		goto end_function;
 
-	dev_dbg(&sep->pdev->dev,
-		"output sep_in_num_pages is %x\n",
+	dev_dbg(&sep->pdev->dev, "output sep_in_num_pages is %x\n",
 		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages);
 
 	current_entry = 0;
 	info_entry_ptr = 0;
 
-	sep_lli_entries =
-		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages;
+	sep_lli_entries = sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages;
 
 	/* loop till all the entries in in array are not processed */
 	while (current_entry < sep_lli_entries) {
@@ -2048,17 +1792,16 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 			(sep_lli_entries - current_entry),
 			&last_table_flag);
 
-		/**
+		/*
 		 * if this is not the last table -
 		 * then allign it to the block size
 		 */
 		if (!last_table_flag)
 			table_data_size =
-			(table_data_size / block_size) * block_size;
+				(table_data_size / block_size) * block_size;
 
-		dev_dbg(&sep->pdev->dev,
-			"output table_data_size is %x\n",
-			table_data_size);
+		dev_dbg(&sep->pdev->dev, "output table_data_size is %x\n",
+							table_data_size);
 
 		/* construct input lli table */
 		sep_build_lli_table(sep, &lli_array_ptr[current_entry],
@@ -2077,52 +1820,38 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 				"output lli_table_in_ptr is %08lx\n",
 				(unsigned long)*lli_table_ptr);
 
-		}
-
-		else {
-
+		} else {
 			/* update the info entry of the previous in table */
 			info_entry_ptr->bus_address =
 				sep_shared_area_virt_to_bus(sep,
-				in_lli_table_ptr);
-				info_entry_ptr->block_size =
+							in_lli_table_ptr);
+			info_entry_ptr->block_size = 
 				((num_entries_in_table) << 24) |
 				(table_data_size);
 		}
-
 		/* save the pointer to the info entry of the current tables */
 		info_entry_ptr = in_lli_table_ptr + num_entries_in_table - 1;
-
 	}
-
 	/* print input tables */
 	sep_debug_print_lli_tables(sep, (struct sep_lli_entry *)
 		sep_shared_area_bus_to_virt(sep, *lli_table_ptr),
-		*num_entries_ptr,
-		*table_data_size_ptr);
-
+		*num_entries_ptr, *table_data_size_ptr);
 	/* the array of the pages */
 	kfree(lli_array_ptr);
 
 update_dcb_counter:
-
 	/* update dcb counter */
 	sep->nr_dcb_creat++;
-
 	goto end_function;
 
 end_function_error:
-
 	/* free all the allocated resources */
 	kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_map_array);
 	kfree(lli_array_ptr);
 	kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_page_array);
 
 end_function:
-
-	dev_dbg(&sep->pdev->dev,
-		"sep_prepare_input_dma_table end\n");
-
+	dev_dbg(&sep->pdev->dev, "sep_prepare_input_dma_table end\n");
 	return error;
 
 }
@@ -2161,45 +1890,32 @@ static int sep_construct_dma_tables_from_lli(
 {
 	/* points to the area where next lli table can be allocated */
 	u32 lli_table_alloc_addr = 0;
-
 	/* input lli table */
 	struct sep_lli_entry *in_lli_table_ptr = 0;
-
 	/* output lli table */
 	struct sep_lli_entry *out_lli_table_ptr = 0;
-
 	/* pointer to the info entry of the table - the last entry */
 	struct sep_lli_entry *info_in_entry_ptr = 0;
-
 	/* pointer to the info entry of the table - the last entry */
 	struct sep_lli_entry *info_out_entry_ptr = 0;
-
 	/* points to the first entry to be processed in the lli_in_array */
 	u32 current_in_entry = 0;
-
 	/* points to the first entry to be processed in the lli_out_array */
 	u32 current_out_entry = 0;
-
 	/* max size of the input table */
 	u32 in_table_data_size = 0;
-
 	/* max size of the output table */
 	u32 out_table_data_size = 0;
-
 	/* flag te signifies if this is the last tables build */
 	u32 last_table_flag = 0;
-
 	/* the data size that should be in table */
 	u32 table_data_size = 0;
-
 	/* number of etnries in the input table */
 	u32 num_entries_in_table = 0;
-
 	/* number of etnries in the output table */
 	u32 num_entries_out_table = 0;
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_construct_dma_tables_from_lli start\n");
+	dev_dbg(&sep->pdev->dev, "sep_construct_dma_tables_from_lli start\n");
 
 	/* initiate to point after the message area */
 	lli_table_alloc_addr = (u32)(sep->shared_addr +
@@ -2210,7 +1926,6 @@ static int sep_construct_dma_tables_from_lli(
 
 	/* loop till all the entries in in array are not processed */
 	while (current_in_entry < sep_in_lli_entries) {
-
 		/* set the new input and output tables */
 		in_lli_table_ptr =
 			(struct sep_lli_entry *)lli_table_alloc_addr;
@@ -2229,8 +1944,7 @@ static int sep_construct_dma_tables_from_lli(
 			SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
 			SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
 
-			dev_warn(&sep->pdev->dev,
-				"dma table limit overrun\n");
+			dev_warn(&sep->pdev->dev, "dma table limit overrun\n");
 			return -ENOMEM;
 		}
 
@@ -2281,8 +1995,8 @@ static int sep_construct_dma_tables_from_lli(
 				block_size;
 		}
 
-		dev_dbg(&sep->pdev->dev,
-			"table_data_size is %x\n", table_data_size);
+		dev_dbg(&sep->pdev->dev, "table_data_size is %x\n",
+							table_data_size);
 
 		/* construct input lli table */
 		sep_build_lli_table(sep, &lli_in_array[current_in_entry],
@@ -2380,9 +2094,7 @@ static int sep_construct_dma_tables_from_lli(
 	*out_num_entries_ptr,
 	*table_data_size_ptr);
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_construct_dma_tables_from_lli end\n");
-
+	dev_dbg(&sep->pdev->dev, "sep_construct_dma_tables_from_lli end\n");
 	return 0;
 }
 
@@ -2418,20 +2130,15 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 	bool is_kva)
 
 {
+	int error = 0;
 	/* array of pointers of page */
 	struct sep_lli_entry *lli_in_array;
-
 	/* array of pointers of page */
 	struct sep_lli_entry *lli_out_array;
 
-	/* error */
-	int error = 0;
-
-	dev_dbg(&sep->pdev->dev,
-		"sep_prepare_input_output_dma_table start\n");
+	dev_dbg(&sep->pdev->dev, "sep_prepare_input_output_dma_table start\n");
 
 	if (data_size == 0) {
-
 		/* prepare empty table for input and output */
 		sep_prepare_empty_lli_table(sep, lli_table_in_ptr,
 			in_num_entries_ptr, table_data_size_ptr);
@@ -2471,8 +2178,8 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 		error = sep_lock_user_pages(sep, app_virt_in_addr,
 				data_size, &lli_in_array, SEP_DRIVER_IN_FLAG);
 		if (error) {
-			dev_warn(&sep->pdev->dev, "sep_lock_user_pages for "
-					"input virtual buffer failed\n");
+			dev_warn(&sep->pdev->dev, 
+				"sep_lock_user_pages for input virtual buffer failed\n");
 			goto end_function;
 		}
 
@@ -2480,20 +2187,17 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 			data_size, &lli_out_array, SEP_DRIVER_OUT_FLAG);
 
 		if (error) {
-			dev_warn(&sep->pdev->dev, "sep_lock_user_pages for "
-					"output virtual buffer failed\n");
+			dev_warn(&sep->pdev->dev,
+				"sep_lock_user_pages for output virtual buffer failed\n");
 			goto end_function_free_lli_in;
 		}
 	}
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_in_num_pages is %x\n",
+	dev_dbg(&sep->pdev->dev, "sep_in_num_pages is %x\n",
 		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages);
-	dev_dbg(&sep->pdev->dev,
-		"sep_out_num_pages is %x\n",
+	dev_dbg(&sep->pdev->dev, "sep_out_num_pages is %x\n",
 		sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages);
-	dev_dbg(&sep->pdev->dev,
-		"SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP is %x\n",
+	dev_dbg(&sep->pdev->dev, "SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP is %x\n",
 		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
 
 	/* call the fucntion that creates table from the lli arrays */
@@ -2514,38 +2218,32 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 	kfree(lli_in_array);
 
 update_dcb_counter:
-
 	/* update dcb counter */
 	sep->nr_dcb_creat++;
-
 	/* fall through - free the lli entry arrays */
-	dev_dbg(&sep->pdev->dev,
-		"in_num_entries_ptr is %08x\n", *in_num_entries_ptr);
-	dev_dbg(&sep->pdev->dev,
-		"out_num_entries_ptr is %08x\n", *out_num_entries_ptr);
-	dev_dbg(&sep->pdev->dev,
-		"table_data_size_ptr is %08x\n", *table_data_size_ptr);
+	dev_dbg(&sep->pdev->dev, "in_num_entries_ptr is %08x\n",
+						*in_num_entries_ptr);
+	dev_dbg(&sep->pdev->dev, "out_num_entries_ptr is %08x\n",
+						*out_num_entries_ptr);
+	dev_dbg(&sep->pdev->dev, "table_data_size_ptr is %08x\n",
+						*table_data_size_ptr);
 
 	goto end_function;
 
 end_function_with_error:
-
 	kfree(sep->dma_res_arr[sep->nr_dcb_creat].out_map_array);
 	kfree(sep->dma_res_arr[sep->nr_dcb_creat].out_page_array);
 	kfree(lli_out_array);
 
 
 end_function_free_lli_in:
-
 	kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_map_array);
 	kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_page_array);
 	kfree(lli_in_array);
 
 end_function:
-
 	dev_dbg(&sep->pdev->dev,
-		"sep_prepare_input_output_dma_table"
-		" end result = %d\n", error);
+		"sep_prepare_input_output_dma_table end result = %d\n", error);
 
 	return error;
 
@@ -2576,35 +2274,26 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	bool            isapplet,
 	bool		is_kva)
 {
-	/* error */
 	int error = 0;
-
 	/* size of tail */
 	u32 tail_size = 0;
-
 	/* address of the created dcb table */
 	struct sep_dcblock *dcb_table_ptr = 0;
-
 	/* the physical address of the first input DMA table */
 	dma_addr_t in_first_mlli_address = 0;
-
 	/* number of entries in the first input DMA table */
 	u32  in_first_num_entries = 0;
-
 	/* the physical address of the first output DMA table */
 	dma_addr_t  out_first_mlli_address = 0;
-
 	/* number of entries in the first output DMA table */
 	u32  out_first_num_entries = 0;
-
 	/* data in the first input/output table */
 	u32  first_data_size = 0;
 
-	dev_dbg(&sep->pdev->dev,
-		"prepare_input_output_dma_table_in_dcb start\n");
+	dev_dbg(&sep->pdev->dev, "prepare_input_output_dma_table_in_dcb start\n");
 
 	if (sep->nr_dcb_creat == SEP_MAX_NUM_SYNC_DMA_OPS) {
-		/*No more DCBS to allocate*/
+		/* No more DCBS to allocate */
 		dev_warn(&sep->pdev->dev, "no more dcb's available\n");
 		error = -ENOSPC;
 		goto end_function;
@@ -2627,17 +2316,12 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 
 	if (isapplet == true) {
 		tail_size = data_in_size % block_size;
-
 		if (tail_size) {
-
 			if (data_in_size < tail_block_size) {
-				dev_warn(&sep->pdev->dev,
-					"data in size smaller than tail"
-					"  block size\n");
+				dev_warn(&sep->pdev->dev, "data in size smaller than tail block size\n");
 				error = -ENOSPC;
 				goto end_function;
 			}
-
 			if (tail_block_size)
 				/*
 				 * case the tail size should be
@@ -2645,7 +2329,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 				 */
 				tail_size = tail_block_size +
 					((data_in_size -
-					tail_block_size) % block_size);
+						tail_block_size) % block_size);
 		}
 
 		/* check if there is enough data for dma operation */
@@ -2653,9 +2337,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 			if (is_kva == true) {
 				memcpy(dcb_table_ptr->tail_data,
 					(void *)app_in_address, data_in_size);
-			}
-
-			else {
+			} else {
 				if (copy_from_user(dcb_table_ptr->tail_data,
 					(void __user *)app_in_address,
 					data_in_size)) {
@@ -2669,7 +2351,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 			/* set the output user-space address for mem2mem op */
 			if (app_out_address)
 				dcb_table_ptr->out_vr_tail_pt =
-					(u32)app_out_address;
+							(u32)app_out_address;
 
 			/*
 			 * Update both data length parameters in order to avoid
@@ -2679,15 +2361,12 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 			tail_size = 0x0;
 			data_in_size = 0x0;
 		}
-
 		if (tail_size) {
 			if (is_kva == true) {
 				memcpy(dcb_table_ptr->tail_data,
 					(void *)(app_in_address + data_in_size -
 					tail_size), tail_size);
-			}
-
-			else {
+			} else {
 				/* we have tail data - copy it to dcb */
 				if (copy_from_user(dcb_table_ptr->tail_data,
 					(void *)(app_in_address +
@@ -2696,17 +2375,16 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 					goto end_function;
 				}
 			}
-
 			if (app_out_address)
 				/*
-				 * Caclulate the output address
+				 * Calculate the output address
 				 * according to tail data size
 				 */
 				dcb_table_ptr->out_vr_tail_pt =
 					app_out_address + data_in_size
 					- tail_size;
 
-			/*save the real tail data size*/
+			/* Save the real tail data size */
 			dcb_table_ptr->tail_data_size = tail_size;
 			/*
 			 * Update the data size without the tail
@@ -2715,7 +2393,6 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 			data_in_size = (data_in_size - tail_size);
 		}
 	}
-
 	/* check if we need to build only input table or input/output */
 	if (app_out_address) {
 		/* prepare input/output tables */
@@ -2730,9 +2407,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 			&out_first_num_entries,
 			&first_data_size,
 			is_kva);
-	}
-
-	else {
+	} else {
 		/* prepare input tables */
 		error = sep_prepare_input_dma_table(sep,
 			app_in_address,
@@ -2745,8 +2420,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	}
 
 	if (error) {
-		dev_warn(&sep->pdev->dev, "prepare dma table call failed"
-			" from prepare dcb call\n");
+		dev_warn(&sep->pdev->dev, "prepare dma table call failed from prepare dcb call\n");
 		goto end_function;
 	}
 
@@ -2759,7 +2433,6 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	dcb_table_ptr->output_mlli_data_size = first_data_size;
 
 end_function:
-
 	dev_dbg(&sep->pdev->dev,
 		"sep_prepare_input_output_dma_table_in_dcb end\n");
 	return error;
@@ -2788,28 +2461,22 @@ static int sep_create_sync_dma_tables_handler(struct sep_device *sep,
 		"sep_create_sync_dma_tables_handler start\n");
 
 	if (copy_from_user(&command_args, (void __user *)arg,
-		sizeof(struct bld_syn_tab_struct))) {
+					sizeof(struct bld_syn_tab_struct))) {
 		error = -EFAULT;
-		dev_warn(&sep->pdev->dev, "create dma tables;"
-			" copy_from_user fails\n");
 		goto end_function;
 	}
 
-	dev_dbg(&sep->pdev->dev,
-		"app_in_address is %08llx\n", command_args.app_in_address);
-	dev_dbg(&sep->pdev->dev,
-		"app_out_address is %08llx\n", command_args.app_out_address);
-	dev_dbg(&sep->pdev->dev,
-		"data_size is %u\n", command_args.data_in_size);
-	dev_dbg(&sep->pdev->dev,
-		"block_size is %u\n", command_args.block_size);
+	dev_dbg(&sep->pdev->dev, "app_in_address is %08llx\n",
+						command_args.app_in_address);
+	dev_dbg(&sep->pdev->dev, "app_out_address is %08llx\n",
+						command_args.app_out_address);
+	dev_dbg(&sep->pdev->dev, "data_size is %u\n",
+						command_args.data_in_size);
+	dev_dbg(&sep->pdev->dev, "block_size is %u\n",
+						command_args.block_size);
 
 	/* validate user parameters */
 	if (!command_args.app_in_address) {
-
-		dev_warn(&sep->pdev->dev,
-			"params validation error\n");
-
 		error = -EINVAL;
 		goto end_function;
 	}
@@ -2824,7 +2491,6 @@ static int sep_create_sync_dma_tables_handler(struct sep_device *sep,
 		false);
 
 end_function:
-
 	dev_dbg(&sep->pdev->dev, "sep_create_sync_dma_tables_handler end\n");
 	return error;
 }
@@ -2840,17 +2506,14 @@ end_function:
 static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 	bool is_kva)
 {
-
 	int i = 0;
 	int error = 0;
 	int error_temp = 0;
-
 	struct sep_dcblock *dcb_table_ptr;
 
 	dev_dbg(&sep->pdev->dev, "sep_free_dma_tables_and_dcb start\n");
 
 	if (isapplet == true) {
-
 		/* set pointer to first dcb table */
 		dcb_table_ptr = (struct sep_dcblock *)
 			(sep->shared_addr +
@@ -2858,30 +2521,25 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 
 		/* go over each dcb and see if tail pointer must be updated */
 		for (i = 0; i < sep->nr_dcb_creat; i++, dcb_table_ptr++) {
-
 			if (dcb_table_ptr->out_vr_tail_pt) {
-
 				if (is_kva == true) {
 					memcpy((void *)dcb_table_ptr->out_vr_tail_pt,
 						dcb_table_ptr->tail_data,
 						dcb_table_ptr->tail_data_size);
-				}
-
-				else {
+				} else {
 					error_temp = copy_to_user(
 						(void *)dcb_table_ptr->out_vr_tail_pt,
 						dcb_table_ptr->tail_data,
 						dcb_table_ptr->tail_data_size);
 				}
-
 				if (error_temp) {
 					/* release the dma resource */
-					error = error_temp;
+					error = -EFAULT;
+					break;
 				}
 			}
 		}
 	}
-
 	/* free the output pages, if any */
 	sep_free_dma_table_data_handler(sep);
 
@@ -2901,9 +2559,7 @@ static int sep_get_static_pool_addr_handler(struct sep_device *sep,
 	unsigned long arg)
 {
 	struct stat_pool_addr_struct command_args;
-
 	u32 *static_pool_addr = 0;
-
 	unsigned long addr_hold;
 
 	dev_dbg(&sep->pdev->dev, "sep_get_static_pool_addr_handler start\n");
@@ -3013,22 +2669,18 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 	struct init_struct command_args;
 
 	dev_dbg(&sep->pdev->dev, "sep_init_handler start\n");
-	error = 0;
 
 	/* make sure that we have not initialized already */
 	reg_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
 
 	if (reg_val != 0x2) {
 		error = SEP_ALREADY_INITIALIZED_ERR;
-		dev_warn(&sep->pdev->dev,
-			"init; device already initialized\n");
+		dev_warn(&sep->pdev->dev, "init; device already initialized\n");
 		goto end_function;
 	}
 
 	/* only root can initialize */
 	if (!capable(CAP_SYS_ADMIN)) {
-		dev_warn(&sep->pdev->dev,
-			"init; only root can init\n");
 		error = -EACCES;
 		goto end_function;
 	}
@@ -3038,17 +2690,13 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 		sizeof(struct init_struct));
 
 	if (error) {
-		dev_warn(&sep->pdev->dev,
-			"init; copy_from_user failed %x\n", error);
+		error = -EFAULT;
 		goto end_function;
 	}
 
 	/* validate parameters */
 	if (!command_args.message_addr || !command_args.sep_sram_addr ||
 		command_args.message_size_in_words > 14) {
-
-		dev_warn(&sep->pdev->dev,
-			"init; parameter error\n");
 		error = -EINVAL;
 		goto end_function;
 	}
@@ -3060,9 +2708,7 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 		command_args.message_size_in_words*sizeof(u32));
 
 	if (error) {
-
-		dev_warn(&sep->pdev->dev,
-			"init; copy sep init message failed %x\n", error);
+		error = -EFAULT;
 		goto end_function;
 	}
 
@@ -3070,7 +2716,6 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 	error = sep_load_firmware(sep);
 
 	if (error) {
-
 		dev_warn(&sep->pdev->dev,
 			"init; copy sep init message failed %x\n", error);
 		goto end_function;
@@ -3102,10 +2747,8 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 
 	/* debug print of message */
 	for (counter = 0; counter < command_args.message_size_in_words;
-		counter++)
-
-		dev_dbg(&sep->pdev->dev,
-			"init; sep message word %d is %x\n",
+								counter++)
+		dev_dbg(&sep->pdev->dev, "init; sep message word %d is %x\n",
 			counter, message_buff[counter]);
 
 	/* tell the sep the sram address */
@@ -3113,11 +2756,9 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 
 	/* push the message to the sep */
 	for (counter = 0; counter < command_args.message_size_in_words;
-		counter++) {
-
+								counter++) {
 		sep_write_reg(sep, HW_SRAM_DATA_REG_ADDR,
-			message_buff[counter]);
-
+						message_buff[counter]);
 		sep_wait_sram_write(sep);
 	}
 
@@ -3132,7 +2773,6 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 	while (!(reg_val & 0xFFFFFFFD));
 
 	if (reg_val == 0x1) {
-
 		dev_warn(&sep->pdev->dev, "init; device int failed\n");
 		error = sep_read_reg(sep, 0x8060);
 		dev_warn(&sep->pdev->dev, "init; sw monitor is %x\n", error);
@@ -3140,9 +2780,7 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 		dev_warn(&sep->pdev->dev, "init; error is %x\n", error);
 		goto end_function;
 	}
-
-	dev_dbg(&sep->pdev->dev, "init; end CC INIT, reg_val is %x\n",
-		reg_val);
+	dev_dbg(&sep->pdev->dev, "init; end CC INIT, reg_val is %x\n", reg_val);
 
 	/* signal sep to zero the GPR3 */
 	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x10);
@@ -3154,7 +2792,6 @@ static int sep_init_handler(struct sep_device *sep, unsigned long arg)
 		reg_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
 	while (reg_val != 0);
 
-
 end_function:
 	dev_dbg(&sep->pdev->dev, "init is done\n");
 	return error;
@@ -3205,34 +2842,32 @@ static int sep_end_transaction_handler(struct sep_device *sep)
  *	This function will retrieve the RAR buffer physical addresses, type
  *	& size corresponding to the RAR handles provided in the buffers vector.
  */
-
 static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg)
 {
 	/* error */
-	int error = 0;
-
+	int error;
 	/* command arguments */
 	struct build_dcb_struct command_args;
 
 	dev_dbg(&sep->pdev->dev, "sep_prepare_dcb_handler start\n");
 
-	/* get the command arguments */
+	/* Get the command arguments */
 	if (copy_from_user(&command_args, (void __user *)arg,
-		sizeof(struct build_dcb_struct))) {
+					sizeof(struct build_dcb_struct))) {
 		error = -EFAULT;
 		goto end_function;
 	}
 
-	dev_dbg(&sep->pdev->dev,
-		"app_in_address is %08llx\n", command_args.app_in_address);
-	dev_dbg(&sep->pdev->dev,
-		"app_out_address is %08llx\n", command_args.app_out_address);
-	dev_dbg(&sep->pdev->dev,
-		"data_size is %x\n", command_args.data_in_size);
-	dev_dbg(&sep->pdev->dev,
-		"block_size is %x\n", command_args.block_size);
-	dev_dbg(&sep->pdev->dev,
-		"tail block_size is %x\n", command_args.tail_block_size);
+	dev_dbg(&sep->pdev->dev, "app_in_address is %08llx\n",
+						command_args.app_in_address);
+	dev_dbg(&sep->pdev->dev, "app_out_address is %08llx\n",
+						command_args.app_out_address);
+	dev_dbg(&sep->pdev->dev, "data_size is %x\n",
+						command_args.data_in_size);
+	dev_dbg(&sep->pdev->dev, "block_size is %x\n",
+						command_args.block_size);
+	dev_dbg(&sep->pdev->dev, "tail block_size is %x\n",
+						command_args.tail_block_size);
 
 	error = sep_prepare_input_output_dma_table_in_dcb(sep,
 		command_args.app_in_address, command_args.app_out_address,
@@ -3240,7 +2875,6 @@ static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg)
 		command_args.tail_block_size, true, false);
 
 end_function:
-
 	dev_dbg(&sep->pdev->dev, "sep_prepare_dcb_handler end\n");
 	return error;
 
@@ -3274,52 +2908,40 @@ static int sep_free_dcb_handler(struct sep_device *sep)
  *	This function will retrieve the RAR buffer physical addresses, type
  *	& size corresponding to the RAR handles provided in the buffers vector.
  */
-
 static int sep_rar_prepare_output_msg_handler(struct sep_device *sep,
 	unsigned long arg)
 {
-	/* error return code */
 	int error = 0;
-
 	/* command args */
 	struct rar_hndl_to_bus_struct command_args;
 	struct RAR_buffer rar_buf;
-
 	/* bus address */
 	dma_addr_t  rar_bus = 0;
-
 	/* holds the RAR address in the system memory offset */
 	u32 *rar_addr;
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_rar_prepare_output_msg_handler start\n");
+	dev_dbg(&sep->pdev->dev, "sep_rar_prepare_output_msg_handler start\n");
 
 	/* copy the data */
-	if (copy_from_user(&command_args,
-		(void __user *)arg,
-		sizeof(command_args))) {
+	if (copy_from_user(&command_args, (void __user *)arg,
+						sizeof(command_args))) {
 		error = -EFAULT;
 		goto end_function;
 	}
 
 	/* call to translation function only if user handle is not NULL */
 	if (command_args.rar_handle) {
-
 		memset(&rar_buf, 0, sizeof(rar_buf));
 		rar_buf.info.handle = (u32)command_args.rar_handle;
 
 		if (rar_handle_to_bus(&rar_buf, 1) != 1) {
-			dev_dbg(&sep->pdev->dev,
-				"rar_handle_to_bus failure\n");
+			dev_dbg(&sep->pdev->dev, "rar_handle_to_bus failure\n");
 			error = -EFAULT;
 			goto end_function;
 		}
-
 		rar_bus = rar_buf.bus_address;
 	}
-
-	dev_dbg(&sep->pdev->dev, "rar msg; rar_addr_bus = %x\n",
-		(u32)rar_bus);
+	dev_dbg(&sep->pdev->dev, "rar msg; rar_addr_bus = %x\n", (u32)rar_bus);
 
 	/* set value in the SYSTEM MEMORY offset */
 	rar_addr = (u32 *)(sep->shared_addr +
@@ -3330,10 +2952,7 @@ static int sep_rar_prepare_output_msg_handler(struct sep_device *sep,
 	rar_addr[1] = rar_bus;
 
 end_function:
-
-	dev_dbg(&sep->pdev->dev,
-		"sep_rar_prepare_output_msg_handler start\n");
-
+	dev_dbg(&sep->pdev->dev, "sep_rar_prepare_output_msg_handler start\n");
 	return error;
 }
 
@@ -3355,13 +2974,12 @@ static int sep_realloc_ext_cache_handler(struct sep_device *sep,
 		SEP_DRIVER_SYSTEM_EXT_CACHE_ADDR_OFFSET_IN_BYTES);
 
 	/* copy the physical address to the System Area for the sep */
-
 	system_addr[0] = SEP_EXT_CACHE_ADDR_VAL_TOKEN;
-	dev_dbg(&sep->pdev->dev,
-		"ext cache init; system addr 0 is %x\n", system_addr[0]);
+	dev_dbg(&sep->pdev->dev, "ext cache init; system addr 0 is %x\n",
+							system_addr[0]);
 	system_addr[1] = sep->extapp_bus;
-	dev_dbg(&sep->pdev->dev,
-		"ext cache init; system addr 1 is %x\n", system_addr[1]);
+	dev_dbg(&sep->pdev->dev, "ext cache init; system addr 1 is %x\n",
+							system_addr[1]);
 
 	return 0;
 }
@@ -3410,8 +3028,7 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	/* make sure we own this device */
 	mutex_lock(&sep->sep_mutex);
 	if ((current->pid != sep->pid_doing_transaction) &&
-		(sep->pid_doing_transaction != 0)) {
-
+				(sep->pid_doing_transaction != 0)) {
 		dev_dbg(&sep->pdev->dev, "ioctl pid is not owner\n");
 		mutex_unlock(&sep->sep_mutex);
 		error = -EACCES;
@@ -3485,15 +3102,13 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		error = sep_free_dcb_handler(sep);
 		break;
 	default:
-		dev_warn(&sep->pdev->dev, "invalid ioctl %x\n", cmd);
+		dev_dbg(&sep->pdev->dev, "invalid ioctl %x\n", cmd);
 		error = -ENOTTY;
 		break;
 	}
-
 	mutex_unlock(&sep->ioctl_mutex);
 
 end_function:
-
 	dev_dbg(&sep->pdev->dev, "ioctl end\n");
 	return error;
 }
@@ -3508,18 +3123,12 @@ end_function:
  */
 static long sep_singleton_ioctl(struct file  *filp, u32 cmd, unsigned long arg)
 {
-
 	/* error */
-	long error;
+	long error = 0;
 	struct sep_device *sep = filp->private_data;
 
-	error = 0;
-
-	dev_dbg(&sep->pdev->dev,
-		"singleton_ioctl start\n");
-
-	dev_dbg(&sep->pdev->dev,
-		"cmd is %x\n", cmd);
+	dev_dbg(&sep->pdev->dev, "singleton_ioctl start\n");
+	dev_dbg(&sep->pdev->dev, "cmd is %x\n", cmd);
 
 	/* check that the command is for sep device */
 	if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER) {
@@ -3530,8 +3139,7 @@ static long sep_singleton_ioctl(struct file  *filp, u32 cmd, unsigned long arg)
 	/* make sure we own this device */
 	mutex_lock(&sep->sep_mutex);
 	if ((current->pid != sep->pid_doing_transaction) &&
-		(sep->pid_doing_transaction != 0)) {
-
+				(sep->pid_doing_transaction != 0)) {
 		dev_dbg(&sep->pdev->dev, "singleton ioctl pid is not owner\n");
 		mutex_unlock(&sep->sep_mutex);
 		error = -EACCES;
@@ -3541,21 +3149,17 @@ static long sep_singleton_ioctl(struct file  *filp, u32 cmd, unsigned long arg)
 	mutex_unlock(&sep->sep_mutex);
 
 	switch (cmd) {
-
 	case SEP_IOCTLSETCALLERID:
 		mutex_lock(&sep->ioctl_mutex);
 		error = sep_set_caller_id_handler(sep, arg);
 		mutex_unlock(&sep->ioctl_mutex);
 		break;
-
 	default:
 		error = sep_ioctl(filp, cmd, arg);
 		break;
-
 	}
 
 end_function:
-
 	dev_dbg(&sep->pdev->dev, "singleton ioctl end\n");
 	return error;
 }
@@ -3568,20 +3172,15 @@ end_function:
  *
  *	Called by the request daemon to perform ioctls on the daemon device
  */
-
 static long sep_request_daemon_ioctl(struct file *filp, u32 cmd,
 	unsigned long arg)
 {
 
 	long error;
-
 	struct sep_device *sep = filp->private_data;
 
-	dev_dbg(&sep->pdev->dev,
-		"daemon ioctl: start\n");
-
-	dev_dbg(&sep->pdev->dev,
-		"daemon ioctl: cmd is %x\n", cmd);
+	dev_dbg(&sep->pdev->dev, "daemon ioctl: start\n");
+	dev_dbg(&sep->pdev->dev, "daemon ioctl: cmd is %x\n", cmd);
 
 	/* check that the command is for sep device */
 	if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER) {
@@ -3594,13 +3193,10 @@ static long sep_request_daemon_ioctl(struct file *filp, u32 cmd,
 
 	switch (cmd) {
 	case SEP_IOCSENDSEPRPLYCOMMAND:
-
 		/* send reply command to SEP */
 		error = sep_req_daemon_send_reply_command_handler(sep);
 		break;
-
 	case SEP_IOCENDTRANSACTION:
-
 		/*
 		 * end req daemon transaction, do nothing
 		 * will be removed upon update in middleware
@@ -3608,19 +3204,14 @@ static long sep_request_daemon_ioctl(struct file *filp, u32 cmd,
 		 */
 		error = 0;
 		break;
-
 	default:
-		dev_dbg(&sep->pdev->dev,
-		"daemon ioctl: no such IOCTL\n");
+		dev_dbg(&sep->pdev->dev, "daemon ioctl: no such IOCTL\n");
 		error = -ENOTTY;
 	}
-
 	mutex_unlock(&sep->ioctl_mutex);
 
 end_function:
-
-	dev_dbg(&sep->pdev->dev,
-		"daemon ioctl: end\n");
+	dev_dbg(&sep->pdev->dev, "daemon ioctl: end\n");
 	return error;
 
 }
@@ -3630,7 +3221,6 @@ end_function:
  *	@irq: interrupt
  *	@dev_id: device id
  */
-
 static irqreturn_t sep_inthandler(int irq, void *dev_id)
 {
 	irqreturn_t int_error = IRQ_HANDLED;
@@ -3640,18 +3230,16 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
 
 	/* read the IRR register to check if this is SEP interrupt */
 	reg_val = sep_read_reg(sep, HW_HOST_IRR_REG_ADDR);
-	dev_dbg(&sep->pdev->dev,
-		"SEP Interrupt - reg is %08x\n", reg_val);
+	dev_dbg(&sep->pdev->dev, "SEP Interrupt - reg is %08x\n", reg_val);
 
 	if (reg_val & (0x1 << 13)) {
-
 		/* lock and update the counter of reply messages */
 		spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
 		sep->reply_ct++;
 		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
 
 		dev_dbg(&sep->pdev->dev, "sep int: send_ct %lx reply_ct %lx\n",
-			sep->send_ct, sep->reply_ct);
+					sep->send_ct, sep->reply_ct);
 
 		/* is this printf or daemon request? */
 		reg_val2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
@@ -3659,27 +3247,19 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
 			"SEP Interrupt - reg2 is %08x\n", reg_val2);
 
 		if ((reg_val2 >> 30) & 0x1) {
-
 			dev_dbg(&sep->pdev->dev, "int: printf request\n");
 			wake_up(&sep->event_request_daemon);
-		}
-
-		else if (reg_val2 >> 31) {
-
+		} else if (reg_val2 >> 31) {
 			dev_dbg(&sep->pdev->dev, "int: daemon request\n");
 			wake_up(&sep->event_request_daemon);
 		} else {
-
 			dev_dbg(&sep->pdev->dev, "int: sep reply\n");
 			wake_up(&sep->event);
 		}
-
 	} else {
-
 		dev_dbg(&sep->pdev->dev, "int: not sep interrupt\n");
 		int_error = IRQ_NONE;
 	}
-
 	if (int_error == IRQ_HANDLED)
 		sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, reg_val);
 
@@ -3695,16 +3275,14 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
  */
 static int sep_callback(unsigned long sep_context_pointer)
 {
-	int error = 0;
-	struct sep_device *sep =
-		(struct sep_device *)sep_context_pointer;
-
-	dma_addr_t rar_end_address = 0;
+	int error;
+	struct sep_device *sep = (struct sep_device *)sep_context_pointer;
+	dma_addr_t rar_end_address;
 
 	dev_dbg(&sep->pdev->dev, "callback start\n");
 
 	error = rar_get_address(RAR_TYPE_IMAGE, &sep->rar_bus,
-		&rar_end_address);
+							&rar_end_address);
 
 	if (error) {
 		dev_warn(&sep->pdev->dev, "mrst cant get rar region\n");
@@ -3714,9 +3292,9 @@ static int sep_callback(unsigned long sep_context_pointer)
 	sep->rar_size = (size_t)(rar_end_address - sep->rar_bus + 1);
 
 	if (!request_mem_region(sep->rar_bus, sep->rar_size,
-		"sep_sec_driver")) {
+							"sep_sec_driver")) {
 		dev_warn(&sep->pdev->dev,
-			"request mem region for mrst failed\n");
+				"request mem region for mrst failed\n");
 		error = -1;
 		goto end_function;
 	}
@@ -3724,18 +3302,15 @@ static int sep_callback(unsigned long sep_context_pointer)
 	sep->rar_addr = ioremap_nocache(sep->rar_bus, sep->rar_size);
 	if (!sep->rar_addr) {
 		dev_warn(&sep->pdev->dev,
-			"ioremap nocache for mrst rar failed\n");
-		error = -1;
+				"ioremap nocache for mrst rar failed\n");
+		error = -ENOMEM;
 		goto end_function;
 	}
-
-	dev_dbg(&sep->pdev->dev, "rar start is %p, phy is %llx,"
-		" size is %x\n",
-		sep->rar_addr, (unsigned long long)sep->rar_bus,
-		sep->rar_size);
+	dev_dbg(&sep->pdev->dev, "rar start is %p, phy is %llx, size is %x\n",
+			sep->rar_addr, (unsigned long long)sep->rar_bus,
+			sep->rar_size);
 
 end_function:
-
 	dev_dbg(&sep->pdev->dev, "callback end\n");
 	return error;
 }
@@ -3769,7 +3344,6 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 
 	/* allocate the sep_device structure for this device */
 	sep_dev = kmalloc(sizeof(struct sep_device), GFP_ATOMIC);
-
 	if (sep_dev == NULL) {
 		dev_warn(&pdev->dev,
 			"can't kmalloc the sep_device structure\n");
@@ -3865,8 +3439,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 			sep->rar_size);
 	}
 
-	dev_dbg(&sep->pdev->dev,
-		"about to write IMR and ICR REG_ADDR\n");
+	dev_dbg(&sep->pdev->dev, "about to write IMR and ICR REG_ADDR\n");
 
 	/* clear ICR register */
 	sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, 0xFFFFFFFF);
@@ -3874,18 +3447,14 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	/* set the IMR register - open only GPR 2 */
 	sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, (~(0x1 << 13)));
 
-	dev_dbg(&sep->pdev->dev,
-		"about to call request_irq\n");
+	dev_dbg(&sep->pdev->dev, "about to call request_irq\n");
 	/* get the interrupt line */
 	error = request_irq(pdev->irq, sep_inthandler, IRQF_SHARED,
 		"sep_driver", sep);
 
-	if (error)
-		goto end_function_free_res;
-
-	goto end_function;
+	if (!error)
+		goto end_function;
 
-end_function_free_res:
 	if (sep->rar_addr)
 		dma_free_coherent(&sep->pdev->dev, sep->rar_size,
 			sep->rar_addr, sep->rar_bus);
@@ -3959,37 +3528,29 @@ static const struct file_operations sep_file_operations = {
  */
 static int sep_reconfig_shared_area(struct sep_device *sep)
 {
-	int ret_val = 0;
+	int ret_val;
 
 	dev_dbg(&sep->pdev->dev, "reconfig shared area start\n");
 
 	/* send the new SHARED MESSAGE AREA to the SEP */
 	dev_dbg(&sep->pdev->dev, "sending %08llx to sep\n",
-		(unsigned long long)sep->shared_bus);
+				(unsigned long long)sep->shared_bus);
 
-	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR1_REG_ADDR,
-		sep->shared_bus);
+	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR1_REG_ADDR, sep->shared_bus);
 
 	/* poll for SEP response */
 	ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
 
-	while (ret_val != 0xffffffff &&
-		ret_val != sep->shared_bus) {
-
-		ret_val = sep_read_reg(sep,
-		  HW_HOST_SEP_HOST_GPR1_REG_ADDR);
-	}
+	while (ret_val != 0xffffffff && ret_val != sep->shared_bus)
+		ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
 
 	/* check the return value (register) */
 	if (ret_val != sep->shared_bus) {
 		dev_warn(&sep->pdev->dev, "could not reconfig shared area\n");
 		dev_warn(&sep->pdev->dev, "result was %x\n", ret_val);
 		ret_val = -ENOMEM;
-	}
-
-	else {
+	} else
 		ret_val = 0;
-	}
 
 	dev_dbg(&sep->pdev->dev, "reconfig shared area end\n");
 	return ret_val;
@@ -4003,7 +3564,7 @@ static int sep_reconfig_shared_area(struct sep_device *sep)
  */
 static int sep_register_driver_to_fs(struct sep_device *sep)
 {
-	int ret_val = 0;
+	int ret_val;
 
 	sep->miscdev_sep.minor = MISC_DYNAMIC_MINOR;
 	sep->miscdev_sep.name = SEP_DEV_NAME;
@@ -4035,8 +3596,7 @@ static int sep_register_driver_to_fs(struct sep_device *sep)
 	if (!sep->mrst) {
 		ret_val = misc_register(&sep->miscdev_daemon);
 		if (ret_val) {
-			dev_warn(&sep->pdev->dev,
-				"misc reg fails for dmn %x\n",
+			dev_warn(&sep->pdev->dev, "misc reg fails for dmn %x\n",
 				ret_val);
 			misc_deregister(&sep->miscdev_sep);
 			misc_deregister(&sep->miscdev_singleton);
@@ -4044,7 +3604,6 @@ static int sep_register_driver_to_fs(struct sep_device *sep)
 			return ret_val;
 		}
 	}
-
 	return ret_val;
 }
 
@@ -4062,8 +3621,8 @@ static int __init sep_init(void)
 
 	ret_val = pci_register_driver(&sep_pci_driver);
 	if (ret_val) {
-		pr_debug("sep_driver:sep_driver_to_device failed,"
-			" ret_val is %d\n", ret_val);
+		pr_debug("sep_driver:sep_driver_to_device failed, ret_val is %d\n",
+								ret_val);
 		goto end_function;
 	}
 
@@ -4085,11 +3644,9 @@ static int __init sep_init(void)
 	/* register driver to fs */
 	ret_val = sep_register_driver_to_fs(sep);
 	if (ret_val) {
-		dev_warn(&sep->pdev->dev,
-			"error registering device to file\n");
+		dev_warn(&sep->pdev->dev, "error registering device to file\n");
 		goto end_function_unregister_pci;
 	}
-
 	goto end_function;
 
 end_function_unregister_pci:

