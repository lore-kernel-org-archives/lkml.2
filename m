Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab1DMV4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:56:54 -0400
Received: from mail.perches.com ([173.55.12.10]:4687 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933143Ab1DMV4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:56:52 -0400
Subject: Re: Re-send (What else needs to be done to the sep driver
 (staging/sep))
From: Joe Perches <joe@perches.com>
To: "Mark A. Allyn" <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
        jayant.mangalampalli@intel.com, venkat.r.gokulrangan@intel.com
In-Reply-To: <alpine.DEB.2.00.1104131427260.31147@allyn-test>
References: <alpine.DEB.2.00.1104131427260.31147@allyn-test>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 14:56:51 -0700
Message-ID: <1302731811.11415.38.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 14:29 -0700, Mark A. Allyn wrote:
> What else needs to be done to the sep driver in order for it to be moved 
> to the kernel from staging?

Maybe a patch from you to move it?
It seems pretty clean to me.
Are you going to keep all the _dbg statements?

You might add a Kconfig CONFIG_SEP_DEBUG block with a
Makefile entry of:
ccflags-$(CONFIG_SEP_DEBUG) := -DDEBUG
to specifically enable DEBUG without dynamic debug.

Here's a Kconfig typo fix and a suggestion to rename the
uses of dev_dbg and dev_warn to sep_<level> to make the
code a bit shorter and more compact.

Signed-off-by: Joe Perches <joe@perches.com>

---

 drivers/staging/sep/Kconfig      |    2 +-
 drivers/staging/sep/sep_driver.c |  340 +++++++++++++++++---------------------
 2 files changed, 152 insertions(+), 190 deletions(-)

diff --git a/drivers/staging/sep/Kconfig b/drivers/staging/sep/Kconfig
index 92bf166..84c1b2b 100644
--- a/drivers/staging/sep/Kconfig
+++ b/drivers/staging/sep/Kconfig
@@ -3,7 +3,7 @@ config DX_SEP
 	depends on PCI
 	help
 	  Discretix SEP driver; used for the security processor subsystem
-	  on bard the Intel Mobile Internet Device.
+	  on board the Intel Mobile Internet Device.
 
 	  The driver's name is sep_driver.
 
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 890eede..d0537ca 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -66,6 +66,11 @@
 
 #define SEP_RAR_IO_MEM_REGION_SIZE 0x40000
 
+#define sep_dbg(sep, fmt, ...)				\
+	dev_dbg(&sep->pdev->dev, fmt, ##__VA_ARGS__)
+#define sep_warn(sep, fmt, ...)				\
+	dev_warn(&sep->pdev->dev, fmt, ##__VA_ARGS__)
+
 /*--------------------------------------------
 	GLOBAL variables
 --------------------------------------------*/
@@ -83,8 +88,7 @@ static void sep_dump_message(struct sep_device *sep)
 	int count;
 	u32 *p = sep->shared_addr;
 	for (count = 0; count < 12 * 4; count += 4)
-		dev_dbg(&sep->pdev->dev, "Word %d of the message is %x\n",
-								count, *p++);
+		sep_dbg(sep, "Word %d of the message is %x\n", count, *p++);
 }
 
 /**
@@ -99,14 +103,12 @@ static int sep_map_and_alloc_shared_area(struct sep_device *sep)
 		&sep->shared_bus, GFP_KERNEL);
 
 	if (!sep->shared_addr) {
-		dev_warn(&sep->pdev->dev,
-			"shared memory dma_alloc_coherent failed\n");
+		sep_warn(sep, "shared memory dma_alloc_coherent failed\n");
 		return -ENOMEM;
 	}
-	dev_dbg(&sep->pdev->dev,
-		"shared_addr %zx bytes @%p (bus %llx)\n",
-				sep->shared_size, sep->shared_addr,
-				(unsigned long long)sep->shared_bus);
+	sep_dbg(sep, "shared_addr %zx bytes @%p (bus %llx)\n",
+		sep->shared_size, sep->shared_addr,
+		(unsigned long long)sep->shared_bus);
 	return 0;
 }
 
@@ -234,8 +236,7 @@ static int sep_request_daemon_release(struct inode *inode, struct file *filp)
 {
 	struct sep_device *sep = filp->private_data;
 
-	dev_dbg(&sep->pdev->dev, "Request daemon release for pid %d\n",
-		current->pid);
+	sep_dbg(sep, "Request daemon release for pid %d\n", current->pid);
 
 	/* Clear the request_daemon_open flag */
 	clear_bit(0, &sep->request_daemon_open);
@@ -266,8 +267,7 @@ static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
 
 	spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_req_daemon_send_reply send_ct %lx reply_ct %lx\n",
+	sep_dbg(sep, "sep_req_daemon_send_reply send_ct %lx reply_ct %lx\n",
 		sep->send_ct, sep->reply_ct);
 
 	return 0;
@@ -374,7 +374,7 @@ static int sep_request_daemon_mmap(struct file  *filp,
 	if (remap_pfn_range(vma, vma->vm_start, bus_address >> PAGE_SHIFT,
 		vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
 
-		dev_warn(&sep->pdev->dev, "remap_page_range failed\n");
+		sep_warn(sep, "remap_page_range failed\n");
 		error = -EAGAIN;
 		goto end_function;
 	}
@@ -402,8 +402,8 @@ static unsigned int sep_request_daemon_poll(struct file *filp,
 
 	poll_wait(filp, &sep->event_request_daemon, wait);
 
-	dev_dbg(&sep->pdev->dev, "daemon poll: send_ct is %lx reply ct is %lx\n",
-						sep->send_ct, sep->reply_ct);
+	sep_dbg(sep, "daemon poll: send_ct is %lx reply ct is %lx\n",
+		sep->send_ct, sep->reply_ct);
 
 	spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
 	/* Check if the data is ready */
@@ -411,24 +411,22 @@ static unsigned int sep_request_daemon_poll(struct file *filp,
 		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
 
 		retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
-		dev_dbg(&sep->pdev->dev,
-			"daemon poll: data check (GPR2) is %x\n", retval2);
+		sep_dbg(sep, "daemon poll: data check (GPR2) is %x\n", retval2);
 
 		/* Check if PRINT request */
 		if ((retval2 >> 30) & 0x1) {
-			dev_dbg(&sep->pdev->dev, "daemon poll: PRINTF request in\n");
+			sep_dbg(sep, "daemon poll: PRINTF request in\n");
 			mask |= POLLIN;
 			goto end_function;
 		}
 		/* Check if NVS request */
 		if (retval2 >> 31) {
-			dev_dbg(&sep->pdev->dev, "daemon poll: NVS request in\n");
+			sep_dbg(sep, "daemon poll: NVS request in\n");
 			mask |= POLLPRI | POLLWRNORM;
 		}
 	} else {
 		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
-		dev_dbg(&sep->pdev->dev,
-			"daemon poll: no reply received; returning 0\n");
+		sep_dbg(sep, "daemon poll: no reply received; returning 0\n");
 		mask = 0;
 	}
 end_function:
@@ -446,7 +444,7 @@ static int sep_release(struct inode *inode, struct file *filp)
 {
 	struct sep_device *sep = filp->private_data;
 
-	dev_dbg(&sep->pdev->dev, "Release for pid %d\n", current->pid);
+	sep_dbg(sep, "Release for pid %d\n", current->pid);
 
 	mutex_lock(&sep->sep_mutex);
 	/* Is this the process that has a transaction open?
@@ -515,14 +513,14 @@ static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
 		goto end_function_with_error;
 	}
 
-	dev_dbg(&sep->pdev->dev, "shared_addr is %p\n", sep->shared_addr);
+	sep_dbg(sep, "shared_addr is %p\n", sep->shared_addr);
 
 	/* Get bus address */
 	bus_addr = sep->shared_bus;
 
 	if (remap_pfn_range(vma, vma->vm_start, bus_addr >> PAGE_SHIFT,
 		vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
-		dev_warn(&sep->pdev->dev, "remap_page_range failed\n");
+		sep_warn(sep, "remap_page_range failed\n");
 		error = -EAGAIN;
 		goto end_function_with_error;
 	}
@@ -563,7 +561,7 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 	/* Am I the process that owns the transaction? */
 	mutex_lock(&sep->sep_mutex);
 	if (current->pid != sep->pid_doing_transaction) {
-		dev_dbg(&sep->pdev->dev, "poll; wrong pid\n");
+		sep_dbg(sep, "poll; wrong pid\n");
 		mask = POLLERR;
 		mutex_unlock(&sep->sep_mutex);
 		goto end_function;
@@ -577,17 +575,17 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 	}
 
 	/* Add the event to the polling wait table */
-	dev_dbg(&sep->pdev->dev, "poll: calling wait sep_event\n");
+	sep_dbg(sep, "poll: calling wait sep_event\n");
 
 	poll_wait(filp, &sep->event, wait);
 
-	dev_dbg(&sep->pdev->dev, "poll: send_ct is %lx reply ct is %lx\n",
+	sep_dbg(sep, "poll: send_ct is %lx reply ct is %lx\n",
 		sep->send_ct, sep->reply_ct);
 
 	/* Check if error occurred during poll */
 	retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
 	if (retval2 != 0x0) {
-		dev_warn(&sep->pdev->dev, "poll; poll error %x\n", retval2);
+		sep_warn(sep, "poll; poll error %x\n", retval2);
 		mask |= POLLERR;
 		goto end_function;
 	}
@@ -597,33 +595,30 @@ static unsigned int sep_poll(struct file *filp, poll_table *wait)
 	if (sep->send_ct == sep->reply_ct) {
 		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
 		retval = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
-		dev_dbg(&sep->pdev->dev, "poll: data ready check (GPR2)  %x\n",
-			retval);
+		sep_dbg(sep, "poll: data ready check (GPR2)  %x\n", retval);
 
 		/* Check if printf request  */
 		if ((retval >> 30) & 0x1) {
-			dev_dbg(&sep->pdev->dev, "poll: SEP printf request\n");
+			sep_dbg(sep, "poll: SEP printf request\n");
 			wake_up(&sep->event_request_daemon);
 			goto end_function;
 		}
 
 		/* Check if the this is SEP reply or request */
 		if (retval >> 31) {
-			dev_dbg(&sep->pdev->dev, "poll: SEP request\n");
+			sep_dbg(sep, "poll: SEP request\n");
 			wake_up(&sep->event_request_daemon);
 		} else {
-			dev_dbg(&sep->pdev->dev, "poll: normal return\n");
+			sep_dbg(sep, "poll: normal return\n");
 			/* In case it is again by send_reply_comand */
 			clear_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags);
 			sep_dump_message(sep);
-			dev_dbg(&sep->pdev->dev,
-				"poll; SEP reply POLLIN | POLLRDNORM\n");
+			sep_dbg(sep, "poll; SEP reply POLLIN | POLLRDNORM\n");
 			mask |= POLLIN | POLLRDNORM;
 		}
 	} else {
 		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
-		dev_dbg(&sep->pdev->dev,
-			"poll; no reply received; returning mask of 0\n");
+		sep_dbg(sep, "poll; no reply received; returning mask of 0\n");
 		mask = 0;
 	}
 
@@ -664,9 +659,9 @@ static unsigned long sep_set_time(struct sep_device *sep)
 	time_addr[0] = SEP_TIME_VAL_TOKEN;
 	time_addr[1] = time.tv_sec;
 
-	dev_dbg(&sep->pdev->dev, "time.tv_sec is %lu\n", time.tv_sec);
-	dev_dbg(&sep->pdev->dev, "time_addr is %p\n", time_addr);
-	dev_dbg(&sep->pdev->dev, "sep->shared_addr is %p\n", sep->shared_addr);
+	sep_dbg(sep, "time.tv_sec is %lu\n", time.tv_sec);
+	sep_dbg(sep, "time_addr is %p\n", time_addr);
+	sep_dbg(sep, "sep->shared_addr is %p\n", sep->shared_addr);
 
 	return time.tv_sec;
 }
@@ -692,9 +687,9 @@ static int sep_set_caller_id_handler(struct sep_device *sep, unsigned long arg)
 	}
 
 	if (i == SEP_CALLER_ID_TABLE_NUM_ENTRIES) {
-		dev_dbg(&sep->pdev->dev, "no more caller id entries left\n");
-		dev_dbg(&sep->pdev->dev, "maximum number is %d\n",
-					SEP_CALLER_ID_TABLE_NUM_ENTRIES);
+		sep_dbg(sep, "no more caller id entries left\n");
+		sep_dbg(sep, "maximum number is %d\n",
+			SEP_CALLER_ID_TABLE_NUM_ENTRIES);
 		error = -EUSERS;
 		goto end_function;
 	}
@@ -713,8 +708,8 @@ static int sep_set_caller_id_handler(struct sep_device *sep, unsigned long arg)
 		goto end_function;
 	}
 
-	dev_dbg(&sep->pdev->dev, "pid is %x\n", command_args.pid);
-	dev_dbg(&sep->pdev->dev, "callerIdSizeInBytes is %x\n",
+	sep_dbg(sep, "pid is %x\n", command_args.pid);
+	sep_dbg(sep, "callerIdSizeInBytes is %x\n",
 		command_args.callerIdSizeInBytes);
 
 	if (command_args.callerIdSizeInBytes >
@@ -750,7 +745,7 @@ static int sep_set_current_caller_id(struct sep_device *sep)
 
 	for (i = 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
 		if (sep->caller_id_table[i].pid == current->pid) {
-			dev_dbg(&sep->pdev->dev, "Caller Id found\n");
+			sep_dbg(sep, "Caller Id found\n");
 
 			memcpy(sep->shared_addr + SEP_CALLER_ID_OFFSET_BYTES,
 				(void *)(sep->caller_id_table[i].callerIdHash),
@@ -797,9 +792,8 @@ static int sep_send_command_handler(struct sep_device *sep)
 	sep->send_ct++;
 	spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_send_command_handler send_ct %lx reply_ct %lx\n",
-						sep->send_ct, sep->reply_ct);
+	sep_dbg(sep, "sep_send_command_handler send_ct %lx reply_ct %lx\n",
+		sep->send_ct, sep->reply_ct);
 
 	/* Send interrupt to SEP */
 	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x2);
@@ -841,10 +835,9 @@ static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
 		goto end_function;
 	}
 
-	dev_dbg(&sep->pdev->dev,
-		"data pool bytes_allocated: %x\n", (int)sep->data_pool_bytes_allocated);
-	dev_dbg(&sep->pdev->dev,
-		"offset: %x\n", SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES);
+	sep_dbg(sep, "data pool bytes_allocated: %x\n",
+		(int)sep->data_pool_bytes_allocated);
+	sep_dbg(sep, "offset: %x\n", SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES);
 	/* Set the virtual and bus address */
 	command_args.offset = SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
 		sep->data_pool_bytes_allocated;
@@ -902,9 +895,9 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 	/* Map array */
 	struct sep_dma_map *map_array;
 
-	dev_dbg(&sep->pdev->dev, "lock kernel pages kernel_virt_addr is %08lx\n",
-				(unsigned long)kernel_virt_addr);
-	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
+	sep_dbg(sep, "lock kernel pages kernel_virt_addr is %08lx\n",
+		(unsigned long)kernel_virt_addr);
+	sep_dbg(sep, "data_size is %x\n", data_size);
 
 	lli_array = kmalloc(sizeof(struct sep_lli_entry), GFP_ATOMIC);
 	if (!lli_array) {
@@ -930,7 +923,7 @@ static int sep_lock_kernel_pages(struct sep_device *sep,
 	lli_array[0].bus_address = (u32)map_array[0].dma_addr;
 	lli_array[0].block_size = map_array[0].size;
 
-	dev_dbg(&sep->pdev->dev,
+	sep_dbg(sep,
 	"lli_array[0].bus_address is %08lx, lli_array[0].block_size is %x\n",
 		(unsigned long)lli_array[0].bus_address,
 		lli_array[0].block_size);
@@ -1001,11 +994,11 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	start_page = app_virt_addr >> PAGE_SHIFT;
 	num_pages = end_page - start_page + 1;
 
-	dev_dbg(&sep->pdev->dev, "lock user pages app_virt_addr is %x\n", app_virt_addr);
-	dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
-	dev_dbg(&sep->pdev->dev, "start_page is %x\n", start_page);
-	dev_dbg(&sep->pdev->dev, "end_page is %x\n", end_page);
-	dev_dbg(&sep->pdev->dev, "num_pages is %x\n", num_pages);
+	sep_dbg(sep, "lock user pages app_virt_addr is %x\n", app_virt_addr);
+	sep_dbg(sep, "data_size is %x\n", data_size);
+	sep_dbg(sep, "start_page is %x\n", start_page);
+	sep_dbg(sep, "end_page is %x\n", end_page);
+	sep_dbg(sep, "num_pages is %x\n", num_pages);
 
 	/* Allocate array of pages structure pointers */
 	page_array = kmalloc(sizeof(struct page *) * num_pages, GFP_ATOMIC);
@@ -1015,7 +1008,7 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	}
 	map_array = kmalloc(sizeof(struct sep_dma_map) * num_pages, GFP_ATOMIC);
 	if (!map_array) {
-		dev_warn(&sep->pdev->dev, "kmalloc for map_array failed\n");
+		sep_warn(sep, "kmalloc for map_array failed\n");
 		error = -ENOMEM;
 		goto end_function_with_error1;
 	}
@@ -1024,7 +1017,7 @@ static int sep_lock_user_pages(struct sep_device *sep,
 		GFP_ATOMIC);
 
 	if (!lli_array) {
-		dev_warn(&sep->pdev->dev, "kmalloc for lli_array failed\n");
+		sep_warn(sep, "kmalloc for lli_array failed\n");
 		error = -ENOMEM;
 		goto end_function_with_error2;
 	}
@@ -1040,13 +1033,12 @@ static int sep_lock_user_pages(struct sep_device *sep,
 
 	/* Check the number of pages locked - if not all then exit with error */
 	if (result != num_pages) {
-		dev_warn(&sep->pdev->dev,
-			"not all pages locked by get_user_pages\n");
+		sep_warn(sep, "not all pages locked by get_user_pages\n");
 		error = -ENOMEM;
 		goto end_function_with_error3;
 	}
 
-	dev_dbg(&sep->pdev->dev, "get_user_pages succeeded\n");
+	sep_dbg(sep, "get_user_pages succeeded\n");
 
 	/* Set direction */
 	if (in_out_flag == SEP_DRIVER_IN_FLAG)
@@ -1070,9 +1062,9 @@ static int sep_lock_user_pages(struct sep_device *sep,
 		lli_array[count].bus_address = (u32)map_array[count].dma_addr;
 		lli_array[count].block_size = PAGE_SIZE;
 
-		dev_warn(&sep->pdev->dev, "lli_array[%x].bus_address is %08lx, lli_array[%x].block_size is %x\n",
-			count, (unsigned long)lli_array[count].bus_address,
-			count, lli_array[count].block_size);
+		sep_warn(sep, "lli_array[%x].bus_address is %08lx, lli_array[%x].block_size is %x\n",
+			 count, (unsigned long)lli_array[count].bus_address,
+			 count, lli_array[count].block_size);
 	}
 
 	/* Check the offset for the first page */
@@ -1086,8 +1078,8 @@ static int sep_lock_user_pages(struct sep_device *sep,
 		lli_array[0].block_size =
 			PAGE_SIZE - (app_virt_addr & (~PAGE_MASK));
 
-	dev_dbg(&sep->pdev->dev,
-		"lli_array[0].bus_address is %08lx, lli_array[0].block_size is %x\n",
+	sep_dbg(sep,
+	"lli_array[0].bus_address is %08lx, lli_array[0].block_size is %x\n",
 		(unsigned long)lli_array[count].bus_address,
 		lli_array[count].block_size);
 
@@ -1096,12 +1088,12 @@ static int sep_lock_user_pages(struct sep_device *sep,
 		lli_array[num_pages - 1].block_size =
 			(app_virt_addr + data_size) & (~PAGE_MASK);
 
-		dev_warn(&sep->pdev->dev,
+		sep_warn(sep,
 			"lli_array[%x].bus_address is %08lx, lli_array[%x].block_size is %x\n",
-			num_pages - 1,
-			(unsigned long)lli_array[count].bus_address,
-			num_pages - 1,
-			lli_array[count].block_size);
+			 num_pages - 1,
+			 (unsigned long)lli_array[count].bus_address,
+			 num_pages - 1,
+			 lli_array[count].block_size);
 	}
 
 	/* Set output params according to the in_out flag */
@@ -1238,7 +1230,8 @@ static void sep_build_lli_table(struct sep_device *sep,
 	array_counter = 0;
 	*num_table_entries_ptr = 1;
 
-	dev_dbg(&sep->pdev->dev, "build lli table table_data_size is %x\n", table_data_size);
+	sep_dbg(sep, "build lli table table_data_size is %x\n",
+		table_data_size);
 
 	/* Fill the table till table size reaches the needed amount */
 	while (curr_table_data_size < table_data_size) {
@@ -1253,17 +1246,15 @@ static void sep_build_lli_table(struct sep_device *sep,
 
 		curr_table_data_size += lli_array_ptr[array_counter].block_size;
 
-		dev_dbg(&sep->pdev->dev, "lli_table_ptr is %p\n",
-								lli_table_ptr);
-		dev_dbg(&sep->pdev->dev, "lli_table_ptr->bus_address is %08lx\n",
-				(unsigned long)lli_table_ptr->bus_address);
-		dev_dbg(&sep->pdev->dev, "lli_table_ptr->block_size is %x\n",
+		sep_dbg(sep, "lli_table_ptr is %p\n", lli_table_ptr);
+		sep_dbg(sep, "lli_table_ptr->bus_address is %08lx\n",
+			(unsigned long)lli_table_ptr->bus_address);
+		sep_dbg(sep, "lli_table_ptr->block_size is %x\n",
 			lli_table_ptr->block_size);
 
 		/* Check for overflow of the table data */
 		if (curr_table_data_size > table_data_size) {
-			dev_dbg(&sep->pdev->dev,
-				"curr_table_data_size too large\n");
+			sep_dbg(sep, "curr_table_data_size too large\n");
 
 			/* Update the size of block in the table */
 			lli_table_ptr->block_size -=
@@ -1280,11 +1271,9 @@ static void sep_build_lli_table(struct sep_device *sep,
 			/* Advance to the next entry in the lli_array */
 			array_counter++;
 
-		dev_dbg(&sep->pdev->dev,
-			"lli_table_ptr->bus_address is %08lx\n",
-				(unsigned long)lli_table_ptr->bus_address);
-		dev_dbg(&sep->pdev->dev,
-			"lli_table_ptr->block_size is %x\n",
+		sep_dbg(sep, "lli_table_ptr->bus_address is %08lx\n",
+			(unsigned long)lli_table_ptr->bus_address);
+		sep_dbg(sep, "lli_table_ptr->block_size is %x\n",
 			lli_table_ptr->block_size);
 
 		/* Move to the next entry in table */
@@ -1313,8 +1302,8 @@ static void sep_build_lli_table(struct sep_device *sep,
 static dma_addr_t sep_shared_area_virt_to_bus(struct sep_device *sep,
 	void *virt_address)
 {
-	dev_dbg(&sep->pdev->dev, "sh virt to phys v %p\n", virt_address);
-	dev_dbg(&sep->pdev->dev, "sh virt to phys p %08lx\n",
+	sep_dbg(sep, "sh virt to phys v %p\n", virt_address);
+	sep_dbg(sep, "sh virt to phys p %08lx\n",
 		(unsigned long)
 		sep->shared_bus + (virt_address - sep->shared_addr));
 
@@ -1334,7 +1323,7 @@ static dma_addr_t sep_shared_area_virt_to_bus(struct sep_device *sep,
 static void *sep_shared_area_bus_to_virt(struct sep_device *sep,
 	dma_addr_t bus_address)
 {
-	dev_dbg(&sep->pdev->dev, "shared bus to virt b=%lx v=%lx\n",
+	sep_dbg(sep, "shared bus to virt b=%lx v=%lx\n",
 		(unsigned long)bus_address, (unsigned long)(sep->shared_addr +
 			(size_t)(bus_address - sep->shared_bus)));
 
@@ -1358,47 +1347,40 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 	unsigned long table_count = 1;
 	unsigned long entries_count = 0;
 
-	dev_dbg(&sep->pdev->dev, "sep_debug_print_lli_tables start\n");
+	sep_dbg(sep, "sep_debug_print_lli_tables start\n");
 
 	while ((unsigned long) lli_table_ptr->bus_address != 0xffffffff) {
-		dev_dbg(&sep->pdev->dev,
-			"lli table %08lx, table_data_size is %lu\n",
+		sep_dbg(sep, "lli table %08lx, table_data_size is %lu\n",
 			table_count, table_data_size);
-		dev_dbg(&sep->pdev->dev, "num_table_entries is %lu\n",
-							num_table_entries);
+		sep_dbg(sep, "num_table_entries is %lu\n", num_table_entries);
 
 		/* Print entries of the table (without info entry) */
 		for (entries_count = 0; entries_count < num_table_entries;
 			entries_count++, lli_table_ptr++) {
 
-			dev_dbg(&sep->pdev->dev,
-				"lli_table_ptr address is %08lx\n",
+			sep_dbg(sep, "lli_table_ptr address is %08lx\n",
 				(unsigned long) lli_table_ptr);
 
-			dev_dbg(&sep->pdev->dev,
-				"phys address is %08lx block size is %x\n",
+			sep_dbg(sep, "phys address is %08lx block size is %x\n",
 				(unsigned long)lli_table_ptr->bus_address,
 				lli_table_ptr->block_size);
 		}
 		/* Point to the info entry */
 		lli_table_ptr--;
 
-		dev_dbg(&sep->pdev->dev,
-			"phys lli_table_ptr->block_size is %x\n",
+		sep_dbg(sep, "phys lli_table_ptr->block_size is %x\n",
 			lli_table_ptr->block_size);
 
-		dev_dbg(&sep->pdev->dev,
-			"phys lli_table_ptr->physical_address is %08lu\n",
+		sep_dbg(sep, "phys lli_table_ptr->physical_address is %08lu\n",
 			(unsigned long)lli_table_ptr->bus_address);
 
-
 		table_data_size = lli_table_ptr->block_size & 0xffffff;
 		num_table_entries = (lli_table_ptr->block_size >> 24) & 0xff;
 
-		dev_dbg(&sep->pdev->dev,
-			"phys table_data_size is %lu num_table_entries is"
-			" %lu bus_address is%lu\n", table_data_size,
-			num_table_entries, (unsigned long)lli_table_ptr->bus_address);
+		sep_dbg(sep, "phys table_data_size is %lu num_table_entries is %lu bus_address is%lu\n",
+			table_data_size,
+			num_table_entries,
+			(unsigned long)lli_table_ptr->bus_address);
 
 		if ((unsigned long)lli_table_ptr->bus_address != 0xffffffff)
 			lli_table_ptr = (struct sep_lli_entry *)
@@ -1407,7 +1389,7 @@ static void sep_debug_print_lli_tables(struct sep_device *sep,
 
 		table_count++;
 	}
-	dev_dbg(&sep->pdev->dev, "sep_debug_print_lli_tables end\n");
+	sep_dbg(sep, "sep_debug_print_lli_tables end\n");
 }
 
 
@@ -1500,8 +1482,8 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 	/* Next table address */
 	void *lli_table_alloc_addr = 0;
 
-	dev_dbg(&sep->pdev->dev, "prepare intput dma table data_size is %x\n", data_size);
-	dev_dbg(&sep->pdev->dev, "block_size is %x\n", block_size);
+	sep_dbg(sep, "prepare intput dma table data_size is %x\n", data_size);
+	sep_dbg(sep, "block_size is %x\n", block_size);
 
 	/* Initialize the pages pointers */
 	sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = NULL;
@@ -1536,7 +1518,7 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 	if (error)
 		goto end_function;
 
-	dev_dbg(&sep->pdev->dev, "output sep_in_num_pages is %x\n",
+	sep_dbg(sep, "output sep_in_num_pages is %x\n",
 		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages);
 
 	current_entry = 0;
@@ -1581,8 +1563,7 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 			table_data_size =
 				(table_data_size / block_size) * block_size;
 
-		dev_dbg(&sep->pdev->dev, "output table_data_size is %x\n",
-							table_data_size);
+		sep_dbg(sep, "output table_data_size is %x\n", table_data_size);
 
 		/* Construct input lli table */
 		sep_build_lli_table(sep, &lli_array_ptr[current_entry],
@@ -1597,8 +1578,7 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 			*num_entries_ptr = num_entries_in_table;
 			*table_data_size_ptr = table_data_size;
 
-			dev_dbg(&sep->pdev->dev,
-				"output lli_table_in_ptr is %08lx\n",
+			sep_dbg(sep, "output lli_table_in_ptr is %08lx\n",
 				(unsigned long)*lli_table_ptr);
 
 		} else {
@@ -1722,7 +1702,7 @@ static int sep_construct_dma_tables_from_lli(
 			SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
 			SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
 
-			dev_warn(&sep->pdev->dev, "dma table limit overrun\n");
+			sep_warn(sep, "dma table limit overrun\n");
 			return -ENOMEM;
 		}
 
@@ -1746,11 +1726,11 @@ static int sep_construct_dma_tables_from_lli(
 			(sep_out_lli_entries - current_out_entry),
 			&last_table_flag);
 
-		dev_dbg(&sep->pdev->dev,
+		sep_dbg(sep,
 			"construct tables from lli in_table_data_size is %x\n",
 			in_table_data_size);
 
-		dev_dbg(&sep->pdev->dev,
+		sep_dbg(sep,
 			"construct tables from lli out_table_data_size is %x\n",
 			out_table_data_size);
 
@@ -1802,11 +1782,9 @@ static int sep_construct_dma_tables_from_lli(
 			*out_num_entries_ptr = num_entries_out_table;
 			*table_data_size_ptr = table_data_size;
 
-			dev_dbg(&sep->pdev->dev,
-			"output lli_table_in_ptr is %08lx\n",
+			sep_dbg(sep, "output lli_table_in_ptr is %08lx\n",
 				(unsigned long)*lli_table_in_ptr);
-			dev_dbg(&sep->pdev->dev,
-			"output lli_table_out_ptr is %08lx\n",
+			sep_dbg(sep, "output lli_table_out_ptr is %08lx\n",
 				(unsigned long)*lli_table_out_ptr);
 		} else {
 			/* Update the info entry of the previous in table */
@@ -1827,13 +1805,11 @@ static int sep_construct_dma_tables_from_lli(
 				((num_entries_out_table) << 24) |
 				(table_data_size);
 
-			dev_dbg(&sep->pdev->dev,
-				"output lli_table_in_ptr:%08lx %08x\n",
+			sep_dbg(sep, "output lli_table_in_ptr:%08lx %08x\n",
 				(unsigned long)info_in_entry_ptr->bus_address,
 				info_in_entry_ptr->block_size);
 
-			dev_dbg(&sep->pdev->dev,
-				"output lli_table_out_ptr:%08lx  %08x\n",
+			sep_dbg(sep, "output lli_table_out_ptr:%08lx  %08x\n",
 				(unsigned long)info_out_entry_ptr->bus_address,
 				info_out_entry_ptr->block_size);
 		}
@@ -1844,14 +1820,11 @@ static int sep_construct_dma_tables_from_lli(
 		info_out_entry_ptr = out_lli_table_ptr +
 			num_entries_out_table - 1;
 
-		dev_dbg(&sep->pdev->dev,
-			"output num_entries_out_table is %x\n",
+		sep_dbg(sep, "output num_entries_out_table is %x\n",
 			(u32)num_entries_out_table);
-		dev_dbg(&sep->pdev->dev,
-			"output info_in_entry_ptr is %lx\n",
+		sep_dbg(sep, "output info_in_entry_ptr is %lx\n",
 			(unsigned long)info_in_entry_ptr);
-		dev_dbg(&sep->pdev->dev,
-			"output info_out_entry_ptr is %lx\n",
+		sep_dbg(sep, "output info_out_entry_ptr is %lx\n",
 			(unsigned long)info_out_entry_ptr);
 	}
 
@@ -1931,8 +1904,7 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 			data_size, &lli_in_array, SEP_DRIVER_IN_FLAG);
 
 		if (error) {
-			dev_warn(&sep->pdev->dev,
-				"lock kernel for in failed\n");
+			sep_warn(sep, "lock kernel for in failed\n");
 			goto end_function;
 		}
 
@@ -1940,8 +1912,7 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 			data_size, &lli_out_array, SEP_DRIVER_OUT_FLAG);
 
 		if (error) {
-			dev_warn(&sep->pdev->dev,
-				"lock kernel for out failed\n");
+			sep_warn(sep, "lock kernel for out failed\n");
 			goto end_function;
 		}
 	}
@@ -1950,7 +1921,7 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 		error = sep_lock_user_pages(sep, app_virt_in_addr,
 				data_size, &lli_in_array, SEP_DRIVER_IN_FLAG);
 		if (error) {
-			dev_warn(&sep->pdev->dev,
+			sep_warn(sep,
 				"sep_lock_user_pages for input virtual buffer failed\n");
 			goto end_function;
 		}
@@ -1959,17 +1930,17 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 			data_size, &lli_out_array, SEP_DRIVER_OUT_FLAG);
 
 		if (error) {
-			dev_warn(&sep->pdev->dev,
+			sep_warn(sep,
 				"sep_lock_user_pages for output virtual buffer failed\n");
 			goto end_function_free_lli_in;
 		}
 	}
 
-	dev_dbg(&sep->pdev->dev, "prep input output dma table sep_in_num_pages is %x\n",
+	sep_dbg(sep, "prep input output dma table sep_in_num_pages is %x\n",
 		sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages);
-	dev_dbg(&sep->pdev->dev, "sep_out_num_pages is %x\n",
+	sep_dbg(sep, "sep_out_num_pages is %x\n",
 		sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages);
-	dev_dbg(&sep->pdev->dev, "SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP is %x\n",
+	sep_dbg(sep, "SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP is %x\n",
 		SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
 
 	/* Call the function that creates table from the lli arrays */
@@ -1981,8 +1952,7 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 		in_num_entries_ptr, out_num_entries_ptr, table_data_size_ptr);
 
 	if (error) {
-		dev_warn(&sep->pdev->dev,
-			"sep_construct_dma_tables_from_lli failed\n");
+		sep_warn(sep, "sep_construct_dma_tables_from_lli failed\n");
 		goto end_function_with_error;
 	}
 
@@ -2055,7 +2025,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 
 	if (sep->nr_dcb_creat == SEP_MAX_NUM_SYNC_DMA_OPS) {
 		/* No more DCBs to allocate */
-		dev_warn(&sep->pdev->dev, "no more DCBs available\n");
+		sep_warn(sep, "no more DCBs available\n");
 		error = -ENOSPC;
 		goto end_function;
 	}
@@ -2176,7 +2146,7 @@ static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
 	}
 
 	if (error) {
-		dev_warn(&sep->pdev->dev, "prepare DMA table call failed from prepare DCB call\n");
+		sep_warn(sep, "prepare DMA table call failed from prepare DCB call\n");
 		goto end_function;
 	}
 
@@ -2263,7 +2233,7 @@ static int sep_get_static_pool_addr_handler(struct sep_device *sep)
 	static_pool_addr[1] = (u32)sep->shared_bus +
 		SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES;
 
-	dev_dbg(&sep->pdev->dev, "static pool segment: physical %x\n",
+	sep_dbg(sep, "static pool segment: physical %x\n",
 		(u32)static_pool_addr[1]);
 
 	return 0;
@@ -2322,16 +2292,13 @@ static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg)
 		goto end_function;
 	}
 
-	dev_dbg(&sep->pdev->dev, "prep dcb handler app_in_address is %08llx\n",
-						command_args.app_in_address);
-	dev_dbg(&sep->pdev->dev, "app_out_address is %08llx\n",
-						command_args.app_out_address);
-	dev_dbg(&sep->pdev->dev, "data_size is %x\n",
-						command_args.data_in_size);
-	dev_dbg(&sep->pdev->dev, "block_size is %x\n",
-						command_args.block_size);
-	dev_dbg(&sep->pdev->dev, "tail block_size is %x\n",
-						command_args.tail_block_size);
+	sep_dbg(sep, "prep dcb handler app_in_address is %08llx\n",
+		command_args.app_in_address);
+	sep_dbg(sep, "app_out_address is %08llx\n",
+		command_args.app_out_address);
+	sep_dbg(sep, "data_size is %x\n", command_args.data_in_size);
+	sep_dbg(sep, "block_size is %x\n", command_args.block_size);
+	sep_dbg(sep, "tail block_size is %x\n", command_args.tail_block_size);
 
 	error = sep_prepare_input_output_dma_table_in_dcb(sep,
 		(unsigned long)command_args.app_in_address,
@@ -2385,7 +2352,7 @@ static int sep_rar_prepare_output_msg_handler(struct sep_device *sep,
 	/* Call to translation function only if user handle is not NULL */
 	if (command_args.rar_handle)
 		return -EOPNOTSUPP;
-	dev_dbg(&sep->pdev->dev, "rar msg; rar_addr_bus = %x\n", (u32)rar_bus);
+	sep_dbg(sep, "rar msg; rar_addr_bus = %x\n", (u32)rar_bus);
 
 	/* Set value in the SYSTEM MEMORY offset */
 	rar_addr = (u32 *)(sep->shared_addr +
@@ -2416,7 +2383,7 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	mutex_lock(&sep->sep_mutex);
 	if ((current->pid != sep->pid_doing_transaction) &&
 				(sep->pid_doing_transaction != 0)) {
-		dev_dbg(&sep->pdev->dev, "ioctl pid is not owner\n");
+		sep_dbg(sep, "ioctl pid is not owner\n");
 		error = -EACCES;
 		goto end_function;
 	}
@@ -2485,7 +2452,7 @@ static long sep_singleton_ioctl(struct file  *filp, u32 cmd, unsigned long arg)
 	mutex_lock(&sep->sep_mutex);
 	if ((current->pid != sep->pid_doing_transaction) &&
 				(sep->pid_doing_transaction != 0)) {
-		dev_dbg(&sep->pdev->dev, "singleton ioctl pid is not owner\n");
+		sep_dbg(sep, "singleton ioctl pid is not owner\n");
 		mutex_unlock(&sep->sep_mutex);
 		return -EACCES;
 	}
@@ -2568,26 +2535,25 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
 		sep->reply_ct++;
 		spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
 
-		dev_dbg(&sep->pdev->dev, "sep int: send_ct %lx reply_ct %lx\n",
-					sep->send_ct, sep->reply_ct);
+		sep_dbg(sep, "sep int: send_ct %lx reply_ct %lx\n",
+			sep->send_ct, sep->reply_ct);
 
 		/* Is this printf or daemon request? */
 		reg_val2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
-		dev_dbg(&sep->pdev->dev,
-			"SEP Interrupt - reg2 is %08x\n", reg_val2);
+		sep_dbg(sep, "SEP Interrupt - reg2 is %08x\n", reg_val2);
 
 		if ((reg_val2 >> 30) & 0x1) {
-			dev_dbg(&sep->pdev->dev, "int: printf request\n");
+			sep_dbg(sep, "int: printf request\n");
 			wake_up(&sep->event_request_daemon);
 		} else if (reg_val2 >> 31) {
-			dev_dbg(&sep->pdev->dev, "int: daemon request\n");
+			sep_dbg(sep, "int: daemon request\n");
 			wake_up(&sep->event_request_daemon);
 		} else {
-			dev_dbg(&sep->pdev->dev, "int: SEP reply\n");
+			sep_dbg(sep, "int: SEP reply\n");
 			wake_up(&sep->event);
 		}
 	} else {
-		dev_dbg(&sep->pdev->dev, "int: not SEP interrupt\n");
+		sep_dbg(sep, "int: not SEP interrupt\n");
 		int_error = IRQ_NONE;
 	}
 	if (int_error == IRQ_HANDLED)
@@ -2611,8 +2577,8 @@ static int sep_reconfig_shared_area(struct sep_device *sep)
 	unsigned long end_time;
 
 	/* Send the new SHARED MESSAGE AREA to the SEP */
-	dev_dbg(&sep->pdev->dev, "reconfig shared; sending %08llx to sep\n",
-				(unsigned long long)sep->shared_bus);
+	sep_dbg(sep, "reconfig shared; sending %08llx to sep\n",
+		(unsigned long long)sep->shared_bus);
 
 	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR1_REG_ADDR, sep->shared_bus);
 
@@ -2627,13 +2593,13 @@ static int sep_reconfig_shared_area(struct sep_device *sep)
 
 	/* Check the return value (register) */
 	if (ret_val != sep->shared_bus) {
-		dev_warn(&sep->pdev->dev, "could not reconfig shared area\n");
-		dev_warn(&sep->pdev->dev, "result was %x\n", ret_val);
+		sep_warn(sep, "could not reconfig shared area\n");
+		sep_warn(sep, "result was %x\n", ret_val);
 		ret_val = -ENOMEM;
 	} else
 		ret_val = 0;
 
-	dev_dbg(&sep->pdev->dev, "reconfig shared area end\n");
+	sep_dbg(sep, "reconfig shared area end\n");
 	return ret_val;
 }
 
@@ -2691,23 +2657,20 @@ static int sep_register_driver_with_fs(struct sep_device *sep)
 
 	ret_val = misc_register(&sep->miscdev_sep);
 	if (ret_val) {
-		dev_warn(&sep->pdev->dev, "misc reg fails for SEP %x\n",
-			ret_val);
+		sep_warn(sep, "misc reg fails for SEP %x\n", ret_val);
 		return ret_val;
 	}
 
 	ret_val = misc_register(&sep->miscdev_singleton);
 	if (ret_val) {
-		dev_warn(&sep->pdev->dev, "misc reg fails for sing %x\n",
-			ret_val);
+		sep_warn(sep, "misc reg fails for sing %x\n", ret_val);
 		misc_deregister(&sep->miscdev_sep);
 		return ret_val;
 	}
 
 	ret_val = misc_register(&sep->miscdev_daemon);
 	if (ret_val) {
-		dev_warn(&sep->pdev->dev, "misc reg fails for dmn %x\n",
-			ret_val);
+		sep_warn(sep, "misc reg fails for dmn %x\n", ret_val);
 		misc_deregister(&sep->miscdev_sep);
 		misc_deregister(&sep->miscdev_singleton);
 
@@ -2768,20 +2731,20 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	mutex_init(&sep->sep_mutex);
 	mutex_init(&sep->ioctl_mutex);
 
-	dev_dbg(&sep->pdev->dev, "sep probe: PCI obtained, device being prepared\n");
-	dev_dbg(&sep->pdev->dev, "revision is %d\n", sep->pdev->revision);
+	sep_dbg(sep, "sep probe: PCI obtained, device being prepared\n");
+	sep_dbg(sep, "revision is %d\n", sep->pdev->revision);
 
 	/* Set up our register area */
 	sep->reg_physical_addr = pci_resource_start(sep->pdev, 0);
 	if (!sep->reg_physical_addr) {
-		dev_warn(&sep->pdev->dev, "Error getting register start\n");
+		sep_warn(sep, "Error getting register start\n");
 		error = -ENODEV;
 		goto end_function_free_sep_dev;
 	}
 
 	sep->reg_physical_end = pci_resource_end(sep->pdev, 0);
 	if (!sep->reg_physical_end) {
-		dev_warn(&sep->pdev->dev, "Error getting register end\n");
+		sep_warn(sep, "Error getting register end\n");
 		error = -ENODEV;
 		goto end_function_free_sep_dev;
 	}
@@ -2789,13 +2752,12 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	sep->reg_addr = ioremap_nocache(sep->reg_physical_addr,
 		(size_t)(sep->reg_physical_end - sep->reg_physical_addr + 1));
 	if (!sep->reg_addr) {
-		dev_warn(&sep->pdev->dev, "Error getting register virtual\n");
+		sep_warn(sep, "Error getting register virtual\n");
 		error = -ENODEV;
 		goto end_function_free_sep_dev;
 	}
 
-	dev_dbg(&sep->pdev->dev,
-		"Register area start %llx end %llx virtual %p\n",
+	sep_dbg(sep, "Register area start %llx end %llx virtual %p\n",
 		(unsigned long long)sep->reg_physical_addr,
 		(unsigned long long)sep->reg_physical_end,
 		sep->reg_addr);


