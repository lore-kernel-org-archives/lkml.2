Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab0EDKa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 06:30:27 -0400
Received: from mga06.intel.com ([134.134.136.21]:8244 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751259Ab0EDKa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 06:30:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,325,1270450800"; 
   d="scan'208";a="514890092"
Date: Tue, 4 May 2010 10:52:13 +0100
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: PATCH: Fix up memrar to the new RAR API
Message-ID: <20100504105213.629fcb00@linux.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memrar: rework to match the RAR API changes

From: Alan Cox <alan@linux.intel.com>

Fix various unload related bugs
Use the per RAR allocator/deallocator
Add kerneldoc

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/memrar/memrar_handler.c |  469 +++++++++++++++++--------------
 1 files changed, 264 insertions(+), 205 deletions(-)


diff --git a/drivers/staging/memrar/memrar_handler.c b/drivers/staging/memrar/memrar_handler.c
index 4bbf66f..281d8d7 100644
--- a/drivers/staging/memrar/memrar_handler.c
+++ b/drivers/staging/memrar/memrar_handler.c
@@ -114,6 +114,7 @@ struct memrar_rar_info {
 	struct memrar_allocator *allocator;
 	struct memrar_buffer_info buffers;
 	struct mutex lock;
+	int allocated;	/* True if we own this RAR */
 };
 
 /*
@@ -150,11 +151,13 @@ static struct memrar_rar_info *memrar_get_rar_info(u32 vaddr)
 	return NULL;
 }
 
-/*
- * Retrieve bus address from given handle.
+/**
+ *	memrar_get_bus address		-	handle to bus address
+ *
+ *	Retrieve bus address from given handle.
  *
- * Returns address corresponding to given handle.  Zero if handle is
- * invalid.
+ *	Returns address corresponding to given handle.  Zero if handle is
+ *	invalid.
  */
 static dma_addr_t memrar_get_bus_address(
 	struct memrar_rar_info *rar,
@@ -176,11 +179,13 @@ static dma_addr_t memrar_get_bus_address(
 	return rar->base + (vaddr - iobase);
 }
 
-/*
- * Retrieve physical address from given handle.
+/**
+ *	memrar_get_physical_address	-	handle to physical address
+ *
+ *	Retrieve physical address from given handle.
  *
- * Returns address corresponding to given handle.  Zero if handle is
- * invalid.
+ *	Returns address corresponding to given handle.  Zero if handle is
+ *	invalid.
  */
 static dma_addr_t memrar_get_physical_address(
 	struct memrar_rar_info *rar,
@@ -195,11 +200,15 @@ static dma_addr_t memrar_get_physical_address(
 	return memrar_get_bus_address(rar, vaddr);
 }
 
-/*
- * Core block release code.
+/**
+ *	memrar_release_block	-	release a block to the pool
+ *	@kref: kref of block
+ *
+ *	Core block release code. A node has hit zero references so can
+ *	be released and the lists must be updated.
  *
- * Note: This code removes the node from a list.  Make sure any list
- *       iteration is performed using list_for_each_safe().
+ *	Note: This code removes the node from a list.  Make sure any list
+ *	iteration is performed using list_for_each_safe().
  */
 static void memrar_release_block_i(struct kref *ref)
 {
@@ -224,10 +233,15 @@ static void memrar_release_block_i(struct kref *ref)
 	kfree(node);
 }
 
-/*
- * Initialize RAR parameters, such as bus addresses, etc.
+/**
+ *	memrar_init_rar_resources	-	configure a RAR
+ *	@rarnum: rar that has been allocated
+ *	@devname: name of our device
+ *
+ *	Initialize RAR parameters, such as bus addresses, etc and make
+ *	the resource accessible.
  */
-static int memrar_init_rar_resources(char const *devname)
+static int memrar_init_rar_resources(int rarnum, char const *devname)
 {
 	/* ---- Sanity Checks ----
 	 * 1. RAR bus addresses in both Lincroft and Langwell RAR
@@ -258,162 +272,95 @@ static int memrar_init_rar_resources(char const *devname)
 	 */
 	static size_t const RAR_BLOCK_SIZE = PAGE_SIZE;
 
-	int z;
-	int found_rar = 0;
+	dma_addr_t low, high;
+	struct memrar_rar_info * const rar = &memrars[rarnum];
 
 	BUG_ON(MRST_NUM_RAR != ARRAY_SIZE(memrars));
+	BUG_ON(!memrar_is_valid_rar_type(rarnum));
+	BUG_ON(rar->allocated);
 
-	for (z = 0; z != MRST_NUM_RAR; ++z) {
-		dma_addr_t low, high;
-		struct memrar_rar_info * const rar = &memrars[z];
-
-		BUG_ON(!memrar_is_valid_rar_type(z));
-
-		mutex_init(&rar->lock);
-
-		/*
-		 * Initialize the process table before we reach any
-		 * code that exit on failure since the finalization
-		 * code requires an initialized list.
-		 */
-		INIT_LIST_HEAD(&rar->buffers.list);
-
-		if (rar_get_address(z, &low, &high) != 0) {
-			/* No RAR is available. */
-			break;
-		} else if (low == 0 || high == 0) {
-			/*
-			 * We don't immediately break out of the loop
-			 * since the next type of RAR may be enabled.
-			 */
-			rar->base      = 0;
-			rar->length    = 0;
-			rar->iobase    = NULL;
-			rar->allocator = NULL;
-			continue;
-		}
-
-		/*
-		 * @todo Verify that LNC and LNW RAR register contents
-		 *       addresses, security, etc are compatible and
-		 *       consistent).
-		 */
-
-		rar->length = high - low + 1;
-
-		/* Claim RAR memory as our own. */
-		if (request_mem_region(low, rar->length, devname) == NULL) {
-			rar->length = 0;
-
-			pr_err("%s: Unable to claim RAR[%d] memory.\n",
-			       devname,
-			       z);
-			pr_err("%s: RAR[%d] disabled.\n", devname, z);
-
-			/*
-			 * Rather than break out of the loop by
-			 * returning -EBUSY, for example, we may be
-			 * able to claim memory of the next RAR region
-			 * as our own.
-			 */
-			continue;
-		}
-
-		rar->base = low;
-
-		/*
-		 * Now map it into the kernel address space.
-		 *
-		 * Note that the RAR memory may only be accessed by IA
-		 * when debugging.  Otherwise attempts to access the
-		 * RAR memory when it is locked down will result in
-		 * behavior similar to writing to /dev/null and
-		 * reading from /dev/zero.  This behavior is enforced
-		 * by the hardware.  Even if we don't access the
-		 * memory, mapping it into the kernel provides us with
-		 * a convenient RAR handle to bus address mapping.
-		 */
-		rar->iobase = ioremap_nocache(rar->base, rar->length);
-		if (rar->iobase == NULL) {
-			pr_err("%s: Unable to map RAR memory.\n",
-			       devname);
-			return -ENOMEM;
-		}
-
-		/* Initialize corresponding memory allocator. */
-		rar->allocator = memrar_create_allocator(
-			(unsigned long) rar->iobase,
-			rar->length,
-			RAR_BLOCK_SIZE);
-		if (rar->allocator == NULL)
-			return -1;
+	mutex_init(&rar->lock);
 
-		/*
-		 * -------------------------------------------------
-		 * Make sure all RARs handled by us are locked down.
-		 * -------------------------------------------------
-		 */
+	/*
+	 * Initialize the process table before we reach any
+	 * code that exit on failure since the finalization
+	 * code requires an initialized list.
+	 */
+	INIT_LIST_HEAD(&rar->buffers.list);
 
-		/* Enable RAR protection on the Lincroft side. */
-		if (0) {
-			/*
-			 * This is mostly a sanity check since the
-			 * vendor should have locked down RAR in the
-			 * SMIP header RAR configuration.
-			 */
-			rar_lock(z);
-		} else {
-			pr_warning("%s: LNC RAR[%d] no lock sanity check.\n",
-				   devname,
-				   z);
-		}
+	if (rar_get_address(rarnum, &low, &high) != 0)
+		/* No RAR is available. */
+		return -ENODEV;
+	
+	if (low == 0 || high == 0) {
+		rar->base      = 0;
+		rar->length    = 0;
+		rar->iobase    = NULL;
+		rar->allocator = NULL;
+		return -ENOSPC;
+	}
 
-		/* ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ */
-		/* |||||||||||||||||||||||||||||||||||||||||||||||||| */
+	/*
+	 * @todo Verify that LNC and LNW RAR register contents
+	 *       addresses, security, etc are compatible and
+	 *       consistent).
+	 */
 
-		/*
-		 * It would be nice if we could verify that RAR
-		 * protection on the Langwell side is enabled, but
-		 * there is no way to do that from here.  The
-		 * necessary Langwell RAR registers are not accessible
-		 * from the Lincroft (IA) side.
-		 *
-		 * Hopefully the ODM did the right thing and enabled
-		 * Langwell side RAR protection in the integrated
-		 * firmware SMIP header.
-		 */
+	rar->length = high - low + 1;
 
-		pr_info("%s: BRAR[%d] bus address range = "
-			"[0x%lx, 0x%lx]\n",
-			devname,
-			z,
-			(unsigned long) low,
-			(unsigned long) high);
+	/* Claim RAR memory as our own. */
+	if (request_mem_region(low, rar->length, devname) == NULL) {
+		rar->length = 0;
+		pr_err("%s: Unable to claim RAR[%d] memory.\n", devname, rarnum);
+		pr_err("%s: RAR[%d] disabled.\n", devname, rarnum);
+		return -EBUSY;
+	}
 
-		pr_info("%s: BRAR[%d] size = %u KiB\n",
-			devname,
-			z,
-			rar->allocator->capacity / 1024);
+	rar->base = low;
 
-		found_rar = 1;
+	/*
+	 * Now map it into the kernel address space.
+	 *
+	 * Note that the RAR memory may only be accessed by IA
+	 * when debugging.  Otherwise attempts to access the
+	 * RAR memory when it is locked down will result in
+	 * behavior similar to writing to /dev/null and
+	 * reading from /dev/zero.  This behavior is enforced
+	 * by the hardware.  Even if we don't access the
+	 * memory, mapping it into the kernel provides us with
+	 * a convenient RAR handle to bus address mapping.
+	 */
+	rar->iobase = ioremap_nocache(rar->base, rar->length);
+	if (rar->iobase == NULL) {
+		pr_err("%s: Unable to map RAR memory.\n", devname);
+		release_mem_region(low, rar->length);
+		return -ENOMEM;
 	}
 
-	if (!found_rar)	{
-		/*
-		 * No RAR support.  Don't bother continuing.
-		 *
-		 * Note that this is not a failure.
-		 */
-		pr_info("%s: No Moorestown RAR support available.\n",
-			devname);
-		return -ENODEV;
+	/* Initialize corresponding memory allocator. */
+	rar->allocator = memrar_create_allocator((unsigned long) rar->iobase,
+						rar->length, RAR_BLOCK_SIZE);
+	if (rar->allocator == NULL) {
+		iounmap(rar->iobase);
+		release_mem_region(low, rar->length);
+		return -ENOMEM;
 	}
 
+	pr_info("%s: BRAR[%d] bus address range = [0x%lx, 0x%lx]\n",
+			devname, rarnum, (unsigned long) low, (unsigned long) high);
+
+	pr_info("%s: BRAR[%d] size = %u KiB\n",
+			devname, rarnum, rar->allocator->capacity / 1024);
+
+	rar->allocated = 1;
 	return 0;
 }
 
-/*
- * Finalize RAR resources.
+/**
+ *	memrar_fini_rar_resources	-	free up RAR resources
+ *
+ *	Finalize RAR resources. Free up the resource tables, hand the memory
+ *	back to the kernel, unmap the device and release the address space.
  */
 static void memrar_fini_rar_resources(void)
 {
@@ -429,6 +376,9 @@ static void memrar_fini_rar_resources(void)
 	for (z = MRST_NUM_RAR; z-- != 0; ) {
 		struct memrar_rar_info * const rar = &memrars[z];
 
+		if (!rar->allocated)
+			continue;
+
 		/* Clean up remaining resources. */
 
 		list_for_each_entry_safe(pos,
@@ -442,15 +392,25 @@ static void memrar_fini_rar_resources(void)
 		rar->allocator = NULL;
 
 		iounmap(rar->iobase);
-		rar->iobase = NULL;
-
 		release_mem_region(rar->base, rar->length);
-		rar->base = 0;
 
+		rar->iobase = NULL;
+		rar->base = 0;
 		rar->length = 0;
+
+		unregister_rar(z);
 	}
 }
 
+/**
+ *	memrar_reserve_block	-	handle an allocation request
+ *	@request: block being requested
+ *	@filp: owner it is tied to
+ *
+ *	Allocate a block of the requested RAR. If successful return the
+ *	request object filled in and zero, if not report an error code
+ */
+
 static long memrar_reserve_block(struct RAR_buffer *request,
 				 struct file *filp)
 {
@@ -465,6 +425,8 @@ static long memrar_reserve_block(struct RAR_buffer *request,
 		return -EINVAL;
 
 	rar = &memrars[rinfo->type];
+	if (!rar->allocated)
+		return -ENODEV;
 
 	/* Reserve memory in RAR. */
 	handle = memrar_allocator_alloc(rar->allocator, rinfo->size);
@@ -504,6 +466,14 @@ static long memrar_reserve_block(struct RAR_buffer *request,
 	return 0;
 }
 
+/**
+ *	memrar_release_block		-	release a RAR block
+ *	@addr: address in RAR space
+ *
+ *	Release a previously allocated block. Releases act on complete
+ *	blocks, partially freeing a block is not supported
+ */
+
 static long memrar_release_block(u32 addr)
 {
 	struct memrar_buffer_info *pos;
@@ -512,7 +482,7 @@ static long memrar_release_block(u32 addr)
 	long result = -EINVAL;
 
 	if (rar == NULL)
-		return -EFAULT;
+		return -ENOENT;
 
 	mutex_lock(&rar->lock);
 
@@ -550,34 +520,48 @@ static long memrar_release_block(u32 addr)
 	return result;
 }
 
+/**
+ *	memrar_get_stats	-	read statistics for a RAR
+ *	@r: statistics to be filled in
+ *
+ *	Returns the statistics data for the RAR, or an error code if
+ *	the request cannot be completed
+ */
 static long memrar_get_stat(struct RAR_stat *r)
 {
-	long result = -EINVAL;
-
-	if (likely(r != NULL) && memrar_is_valid_rar_type(r->type)) {
-		struct memrar_allocator * const allocator =
-			memrars[r->type].allocator;
-
-		BUG_ON(allocator == NULL);
+	struct memrar_allocator *allocator;
 
-		/*
-		 * Allocator capacity doesn't change over time.  No
-		 * need to synchronize.
-		 */
-		r->capacity = allocator->capacity;
+ 	if (!memrar_is_valid_rar_type(r->type))
+		return -EINVAL;
 
-		mutex_lock(&allocator->lock);
+	if (!memrars[r->type].allocated)
+		return -ENODEV;
 
-		r->largest_block_size = allocator->largest_free_area;
+	allocator = memrars[r->type].allocator;
 
-		mutex_unlock(&allocator->lock);
+	BUG_ON(allocator == NULL);
 
-		result = 0;
-	}
+	/*
+	 * Allocator capacity doesn't change over time.  No
+	 * need to synchronize.
+	 */
+	r->capacity = allocator->capacity;
 
-	return result;
+	mutex_lock(&allocator->lock);
+	r->largest_block_size = allocator->largest_free_area;
+	mutex_unlock(&allocator->lock);
+	return 0;
 }
 
+/**
+ *	memrar_ioctl		-	ioctl callback
+ *	@filp: file issuing the request
+ *	@cmd: command
+ *	@arg: pointer to control information
+ *
+ *	Perform one of the ioctls supported by the memrar device
+ */
+
 static long memrar_ioctl(struct file *filp,
 			 unsigned int cmd,
 			 unsigned long arg)
@@ -640,6 +624,15 @@ static long memrar_ioctl(struct file *filp,
 	return 0;
 }
 
+/**
+ *	memrar_mmap		-	mmap helper for deubgging
+ *	@filp: handle doing the mapping
+ *	@vma: memory area
+ *
+ *	Support the mmap operation on the RAR space for debugging systems
+ *	when the memory is not locked down.
+ */
+
 static int memrar_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	/*
@@ -660,9 +653,12 @@ static int memrar_mmap(struct file *filp, struct vm_area_struct *vma)
 	unsigned long const handle = vma->vm_pgoff << PAGE_SHIFT;
 
 	struct memrar_rar_info * const rar = memrar_get_rar_info(handle);
-
 	unsigned long pfn;
 
+	/* Only allow priviledged apps to go poking around this way */
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
 	/* Invalid RAR handle or size passed to mmap(). */
 	if (rar == NULL
 	    || handle == 0
@@ -698,13 +694,32 @@ static int memrar_mmap(struct file *filp, struct vm_area_struct *vma)
 	return 0;
 }
 
+/**
+ *	memrar_open		-	device open method
+ *	@inode: inode to open
+ *	@filp: file handle
+ *
+ *	As we support multiple arbitary opens there is no work to be done
+ *	really.
+ */
+
 static int memrar_open(struct inode *inode, struct file *filp)
 {
-	/* Nothing to do yet. */
-
+	nonseekable_open(inode, filp);
 	return 0;
 }
 
+/**
+ *	memrar_release		-	close method for miscev
+ *	@inode: inode of device
+ *	@filp: handle that is going away
+ *
+ *	Free up all the regions that belong to this file handle. We use
+ *	the handle as a natural Linux style 'lifetime' indicator and to
+ *	ensure resources are not leaked when their owner explodes in an
+ *	unplanned fashion.
+ */
+
 static int memrar_release(struct inode *inode, struct file *filp)
 {
 	/* Free all regions associated with the given file handle. */
@@ -733,9 +748,15 @@ static int memrar_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-/*
- * This function is part of the kernel space memrar driver API.
+/**
+ *	rar_reserve		-	reserve RAR memory
+ *	@buffers: buffers to reserve
+ *	@count: number wanted
+ *
+ *	Reserve a series of buffers in the RAR space. Returns the number of
+ *	buffers successfully allocated
  */
+
 size_t rar_reserve(struct RAR_buffer *buffers, size_t count)
 {
 	struct RAR_buffer * const end =
@@ -755,9 +776,14 @@ size_t rar_reserve(struct RAR_buffer *buffers, size_t count)
 }
 EXPORT_SYMBOL(rar_reserve);
 
-/*
- * This function is part of the kernel space memrar driver API.
+/**
+ *	rar_release		-	return RAR buffers
+ *	@buffers: buffers to release
+ *	@size: size of released block
+ *
+ *	Return a set of buffers to the RAR pool
  */
+
 size_t rar_release(struct RAR_buffer *buffers, size_t count)
 {
 	struct RAR_buffer * const end =
@@ -786,9 +812,16 @@ size_t rar_release(struct RAR_buffer *buffers, size_t count)
 }
 EXPORT_SYMBOL(rar_release);
 
-/*
- * This function is part of the kernel space driver API.
+/**
+ *	rar_handle_to_bus	-	RAR to bus address
+ *	@buffers: RAR buffer structure
+ *	@count: number of buffers to convert
+ *
+ *	Turn a list of RAR handle mappings into actual bus addresses. Note
+ *	that when the device is locked down the bus addresses in question
+ *	are not CPU accessible.
  */
+
 size_t rar_handle_to_bus(struct RAR_buffer *buffers, size_t count)
 {
 	struct RAR_buffer * const end =
@@ -878,43 +911,70 @@ static char const banner[] __initdata =
 	KERN_INFO
 	"Intel RAR Handler: " MEMRAR_VER " initialized.\n";
 
-static int memrar_registration_callback(void *ctx)
+/**
+ *	memrar_registration_callback	-	RAR obtained
+ *	@rar: RAR number
+ *
+ *	We have been granted ownership of the RAR. Add it to our memory
+ *	management tables
+ */
+
+static int memrar_registration_callback(unsigned long rar)
 {
 	/*
 	 * We initialize the RAR parameters early on so that we can
 	 * discontinue memrar device initialization and registration
 	 * if suitably configured RARs are not available.
 	 */
-	int result = memrar_init_rar_resources(memrar_miscdev.name);
+	return memrar_init_rar_resources(rar, memrar_miscdev.name);
+}
 
-	if (result != 0)
-		return result;
+/**
+ *	memrar_init	-	initialise RAR support
+ *
+ *	Initialise support for RAR handlers. This may get loaded before
+ *	the RAR support is activated, but the callbacks on the registration
+ *	will handle that situation for us anyway.
+ */
 
-	result = misc_register(&memrar_miscdev);
+static int __init memrar_init(void)
+{
+	int err;
 
-	if (result != 0) {
-		pr_err("%s: misc_register() failed.\n",
-			memrar_miscdev.name);
+	printk(banner);
 
-		/* Clean up resources previously reserved. */
-		memrar_fini_rar_resources();
-	}
+	err = misc_register(&memrar_miscdev);
+	if (err)
+		return err;
 
-	return result;
-}
+	/* Now claim the two RARs we want */
+	err = register_rar(0, memrar_registration_callback, 0);
+	if (err)
+		goto fail;
 
-static int __init memrar_init(void)
-{
-	printk(banner);
+	err = register_rar(1, memrar_registration_callback, 1);
+	if (err == 0)
+		return 0;
 
-	return register_rar(&memrar_registration_callback, 0);
+	/* It is possible rar 0 registered and allocated resources then rar 1
+	   failed so do a full resource free */
+	memrar_fini_rar_resources();
+fail:
+	misc_deregister(&memrar_miscdev);
+	return err;
 }
 
+/**
+ *	memrar_exit	-	unregister and unload
+ *
+ *	Unregister the device and then unload any mappings and release
+ *	the RAR resources
+ */
+
 static void __exit memrar_exit(void)
 {
-	memrar_fini_rar_resources();
-
 	misc_deregister(&memrar_miscdev);
+	memrar_fini_rar_resources();
 }
 
 
@@ -925,7 +985,6 @@ module_exit(memrar_exit);
 MODULE_AUTHOR("Ossama Othman <ossama.othman@intel.com>");
 MODULE_DESCRIPTION("Intel Restricted Access Region Handler");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(MISC_DYNAMIC_MINOR);
 MODULE_VERSION(MEMRAR_VER);
 
 
