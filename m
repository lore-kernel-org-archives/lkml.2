Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697Ab0EDUSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:18:36 -0400
Received: from mga10.intel.com ([192.55.52.92]:45623 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933641Ab0EDUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:18:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,328,1270450800"; 
   d="scan'208";a="564104877"
Date: Tue, 4 May 2010 20:40:12 +0100
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: PATCH: rar and memrar updates
Message-ID: <20100504204012.4156c34e@linux.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 1cb0e4339ecd39c62840c74b53546bd28c1ea1a9
Author: Alan Cox <alan@linux.intel.com>
Date:   Tue May 4 20:38:47 2010 +0100

    rar: perform a clean up pass
    
    - Move to a registration model where each RAR is claimed/unclaimed
    - Use that to fix the client stuff (one client per RAR so no need to queue stuff)
    - Support unregister so drivers can rmmod themselves safely
    - Fix locking hang on calling rar lock from rar callback
    - Clean up
    - Kerneldoc
    
    Folded in the memrar update as Greg asked
    
    - Fix various unload related bugs
    - Use the per RAR allocator/deallocator
    - Add kerneldoc
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>

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
 
 
diff --git a/drivers/staging/rar_register/rar_register.c b/drivers/staging/rar_register/rar_register.c
index bfc0e31..618503f 100644
--- a/drivers/staging/rar_register/rar_register.c
+++ b/drivers/staging/rar_register/rar_register.c
@@ -51,98 +51,159 @@
 #include <linux/kernel.h>
 
 /* === Lincroft Message Bus Interface === */
-/* Message Control Register */
-#define LNC_MCR_OFFSET 0xD0
-
-/* Maximum number of clients (other drivers using this driver) */
-#define MAX_RAR_CLIENTS 10
-
-/* Message Data Register */
-#define LNC_MDR_OFFSET 0xD4
+#define LNC_MCR_OFFSET		0xD0	/* Message Control Register */
+#define LNC_MDR_OFFSET		0xD4	/* Message Data Register */
 
 /* Message Opcodes */
-#define LNC_MESSAGE_READ_OPCODE 0xD0
+#define LNC_MESSAGE_READ_OPCODE	0xD0
 #define LNC_MESSAGE_WRITE_OPCODE 0xE0
 
 /* Message Write Byte Enables */
-#define LNC_MESSAGE_BYTE_WRITE_ENABLES 0xF
+#define LNC_MESSAGE_BYTE_WRITE_ENABLES	0xF
 
 /* B-unit Port */
-#define LNC_BUNIT_PORT 0x3
+#define LNC_BUNIT_PORT	0x3
 
 /* === Lincroft B-Unit Registers - Programmed by IA32 firmware === */
-#define LNC_BRAR0L 0x10
-#define LNC_BRAR0H 0x11
-#define LNC_BRAR1L 0x12
-#define LNC_BRAR1H 0x13
-
+#define LNC_BRAR0L	0x10
+#define LNC_BRAR0H	0x11
+#define LNC_BRAR1L	0x12
+#define LNC_BRAR1H	0x13
 /* Reserved for SeP */
-#define LNC_BRAR2L 0x14
-#define LNC_BRAR2H 0x15
+#define LNC_BRAR2L	0x14
+#define LNC_BRAR2H	0x15
 
 /* Moorestown supports three restricted access regions. */
 #define MRST_NUM_RAR 3
 
-
 /* RAR Bus Address Range */
-struct RAR_address_range {
+struct rar_addr {
 	dma_addr_t low;
 	dma_addr_t high;
 };
 
-/* Structure containing low and high RAR register offsets. */
-struct RAR_offsets {
-	u32 low;  /* Register offset for low  RAR bus address. */
-	u32 high; /* Register offset for high RAR bus address. */
-};
-
+/*
+ *	We create one of these for each RAR
+ */
 struct client {
-	int (*client_callback)(void *client_data);
-	void *customer_data;
-	int client_called;
-	};
+	int (*callback)(unsigned long data);
+	unsigned long driver_priv;
+	bool busy;
+};
 
 static DEFINE_MUTEX(rar_mutex);
 static DEFINE_MUTEX(lnc_reg_mutex);
 
-struct RAR_device {
-	struct RAR_offsets const rar_offsets[MRST_NUM_RAR];
-	struct RAR_address_range rar_addr[MRST_NUM_RAR];
+/*
+ *	One per RAR device (currently only one device)
+ */
+struct rar_device {
+	struct rar_addr rar_addr[MRST_NUM_RAR];
 	struct pci_dev *rar_dev;
 	bool registered;
-	};
-
-/* this platform has only one rar_device for 3 rar regions */
-static struct RAR_device my_rar_device = {
-	.rar_offsets = {
-		[0].low = LNC_BRAR0L,
-		[0].high = LNC_BRAR0H,
-		[1].low = LNC_BRAR1L,
-		[1].high = LNC_BRAR1H,
-		[2].low = LNC_BRAR2L,
-		[2].high = LNC_BRAR2H
-	}
+	bool allocated;
+	struct client client[MRST_NUM_RAR];
 };
 
-/* this data is for handling requests from other drivers which arrive
- * prior to this driver initializing
+/* Current platforms have only one rar_device for 3 rar regions */
+static struct rar_device my_rar_device;
+
+/*
+ *	Abstract out multiple device support. Current platforms only
+ *	have a single RAR device.
  */
 
-static struct client clients[MAX_RAR_CLIENTS];
-static int num_clients;
+/**
+ *	alloc_rar_device	-	return a new RAR structure
+ *
+ *	Return a new (but not yet ready) RAR device object
+ */
+static struct rar_device *alloc_rar_device(void)
+{
+	if (my_rar_device.allocated)
+		return NULL;
+	my_rar_device.allocated = 1;
+	return &my_rar_device;
+}
 
-/*
- * This function is used to retrieved RAR info using the Lincroft
- * message bus interface.
+/**
+ *	free_rar_device		-	free a RAR object
+ *	@rar: the RAR device being freed
+ *
+ *	Release a RAR object and any attached resources
  */
-static int retrieve_rar_addr(struct pci_dev *pdev,
-	int offset,
-	dma_addr_t *addr)
+static void free_rar_device(struct rar_device *rar)
+{
+	pci_dev_put(rar->rar_dev);
+	rar->allocated = 0;
+}
+
+/**
+ *	_rar_to_device		-	return the device handling this RAR
+ *	@rar: RAR number
+ *	@off: returned offset
+ *
+ *	Internal helper for looking up RAR devices. This and alloc are the
+ *	two functions that need touching to go to multiple RAR devices.
+ */
+static struct rar_device *_rar_to_device(int rar, int *off)
+{
+	if (rar >= 0 && rar <= 3) {
+		*off = rar;
+		return &my_rar_device;
+	}
+	return NULL;
+}
+
+
+/**
+ *	rar_to_device		-	return the device handling this RAR
+ *	@rar: RAR number
+ *	@off: returned offset
+ *
+ *	Return the device this RAR maps to if one is present, otherwise
+ *	returns NULL. Reports the offset relative to the base of this
+ *	RAR device in off.
+ */
+static struct rar_device *rar_to_device(int rar, int *off)
+{
+	struct rar_device *rar_dev = _rar_to_device(rar, off);
+	if (rar_dev == NULL || !rar_dev->registered)
+		return NULL;
+	return rar_dev;
+}
+
+/**
+ *	rar_to_client		-	return the client handling this RAR
+ *	@rar: RAR number
+ *
+ *	Return the client this RAR maps to if a mapping is known, otherwise
+ *	returns NULL.
+ */
+static struct client *rar_to_client(int rar)
+{
+	int idx;
+	struct rar_device *r = _rar_to_device(rar, &idx);
+	if (r != NULL)
+		return &r->client[idx];
+	return NULL;
+}
+
+/**
+ *	rar_read_addr		-	retrieve a RAR mapping
+ *	@pdev: PCI device for the RAR
+ *	@offset: offset for message
+ *	@addr: returned address
+ *
+ *	Reads the address of a given RAR register. Returns 0 on success
+ *	or an error code on failure.
+ */
+static int rar_read_addr(struct pci_dev *pdev, int offset, dma_addr_t *addr)
 {
 	/*
 	 * ======== The Lincroft Message Bus Interface ========
-	 * Lincroft registers may be obtained from the PCI
-	 * (the Host Bridge) using the Lincroft Message Bus
+	 * Lincroft registers may be obtained via PCI from
+	 * the host bridge using the Lincroft Message Bus
 	 * Interface.  That message bus interface is generally
 	 * comprised of two registers: a control register (MCR, 0xDO)
 	 * and a data register (MDR, 0xD4).
@@ -182,6 +243,7 @@ static int retrieve_rar_addr(struct pci_dev *pdev,
 	*/
 
 	int result;
+	u32 addr32;
 
 	/* Construct control message */
 	u32 const message =
@@ -192,11 +254,6 @@ static int retrieve_rar_addr(struct pci_dev *pdev,
 
 	dev_dbg(&pdev->dev, "Offset for 'get' LNC MSG is %x\n", offset);
 
-	if (addr == 0) {
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
 	/*
 	* We synchronize access to the Lincroft MCR and MDR registers
 	* until BOTH the command is issued through the MCR register
@@ -209,26 +266,25 @@ static int retrieve_rar_addr(struct pci_dev *pdev,
 
 	/* Send the control message */
 	result = pci_write_config_dword(pdev, LNC_MCR_OFFSET, message);
-
-	dev_dbg(&pdev->dev, "Result from send ctl register is %x\n", result);
-
 	if (!result) {
-		result = pci_read_config_dword(pdev, LNC_MDR_OFFSET,
-			(u32 *)addr);
-		dev_dbg(&pdev->dev,
-			"Result from read data register is %x\n", result);
-
-		dev_dbg(&pdev->dev,
-			"Value read from data register is %lx\n",
-			 (unsigned long)*addr);
+		/* Read back the address as a 32bit value */
+		result = pci_read_config_dword(pdev, LNC_MDR_OFFSET, &addr32);
+		*addr = (dma_addr_t)addr32;
 	}
-
 	mutex_unlock(&lnc_reg_mutex);
-
 	return result;
 }
 
-static int set_rar_address(struct pci_dev *pdev,
+/**
+ *	rar_set_addr		-	Set a RAR mapping
+ *	@pdev: PCI device for the RAR
+ *	@offset: offset for message
+ *	@addr: address to set
+ *
+ *	Sets the address of a given RAR register. Returns 0 on success
+ *	or an error code on failure.
+ */
+static int rar_set_addr(struct pci_dev *pdev,
 	int offset,
 	dma_addr_t addr)
 {
@@ -236,11 +292,11 @@ static int set_rar_address(struct pci_dev *pdev,
 	* Data being written to this register must be written before
 	* writing the appropriate control message to the MCR
 	* register.
-	* @note See rar_get_address() for a description of the
+	* See rar_get_addrs() for a description of the
 	* message bus interface being used here.
 	*/
 
-	int result = 0;
+	int result;
 
 	/* Construct control message */
 	u32 const message = (LNC_MESSAGE_WRITE_OPCODE << 24)
@@ -248,13 +304,6 @@ static int set_rar_address(struct pci_dev *pdev,
 		| (offset << 8)
 		| (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
 
-	if (addr == 0) {
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
-	dev_dbg(&pdev->dev, "Offset for 'set' LNC MSG is %x\n", offset);
-
 	/*
 	* We synchronize access to the Lincroft MCR and MDR registers
 	* until BOTH the command is issued through the MCR register
@@ -267,32 +316,27 @@ static int set_rar_address(struct pci_dev *pdev,
 
 	/* Send the control message */
 	result = pci_write_config_dword(pdev, LNC_MDR_OFFSET, addr);
-
-	dev_dbg(&pdev->dev, "Result from write data register is %x\n", result);
-
-	if (!result) {
-		dev_dbg(&pdev->dev,
-			"Value written to data register is %lx\n",
-			 (unsigned long)addr);
-
+	if (!result)
+		/* And address */
 		result = pci_write_config_dword(pdev, LNC_MCR_OFFSET, message);
 
-		dev_dbg(&pdev->dev, "Result from send ctl register is %x\n",
-			result);
-	}
-
 	mutex_unlock(&lnc_reg_mutex);
-
 	return result;
 }
 
 /*
-* Initialize RAR parameters, such as bus addresses, etc.
-*/
-static int init_rar_params(struct pci_dev *pdev)
+ *	rar_init_params		-	Initialize RAR parameters
+ *	@rar: RAR device to initialise
+ *
+ *	Initialize RAR parameters, such as bus addresses, etc. Returns 0
+ *	on success, or an error code on failure.
+ */
+static int init_rar_params(struct rar_device *rar)
 {
+	struct pci_dev *pdev = rar->rar_dev;
 	unsigned int i;
 	int result = 0;
+	int offset = 0x10;	/* RAR 0 to 2 in order low/high/low/high/... */
 
 	/* Retrieve RAR start and end bus addresses.
 	* Access the RAR registers through the Lincroft Message Bus
@@ -300,15 +344,16 @@ static int init_rar_params(struct pci_dev *pdev)
 	*/
 
 	for (i = 0; i < MRST_NUM_RAR; ++i) {
-		struct RAR_offsets const *offset =
-			&my_rar_device.rar_offsets[i];
-		struct RAR_address_range *addr = &my_rar_device.rar_addr[i];
-
-	if ((retrieve_rar_addr(pdev, offset->low, &addr->low) != 0)
-		|| (retrieve_rar_addr(pdev, offset->high, &addr->high) != 0)) {
-		result = -1;
-		break;
-		}
+		struct rar_addr *addr = &rar->rar_addr[i];
+
+		result = rar_read_addr(pdev, offset++, &addr->low);
+		if (result != 0)
+			return result;
+
+		result = rar_read_addr(pdev, offset++, &addr->high);
+		if (result != 0)
+			return result;
+
 
 		/*
 		* Only the upper 22 bits of the RAR addresses are
@@ -336,201 +381,237 @@ static int init_rar_params(struct pci_dev *pdev)
 	/* Done accessing the device. */
 
 	if (result == 0) {
-		int z;
-		for (z = 0; z != MRST_NUM_RAR; ++z) {
+		for (i = 0; i != MRST_NUM_RAR; ++i) {
 			/*
 			* "BRAR" refers to the RAR registers in the
 			* Lincroft B-unit.
 			*/
 			dev_info(&pdev->dev, "BRAR[%u] bus address range = "
-			  "[%lx, %lx]\n", z,
-			  (unsigned long)my_rar_device.rar_addr[z].low,
-			  (unsigned long)my_rar_device.rar_addr[z].high);
+			  "[%lx, %lx]\n", i,
+			  (unsigned long)rar->rar_addr[i].low,
+			  (unsigned long)rar->rar_addr[i].high);
 		}
 	}
-
 	return result;
 }
 
-/*
- * The rar_get_address function is used by other device drivers
- * to obtain RAR address information on a RAR. It takes three
- * parameters:
+/**
+ *	rar_get_address		-	get the bus address in a RAR
+ *	@start: return value of start address of block
+ *	@end: return value of end address of block
  *
- * int rar_index
- * The rar_index is an index to the rar for which you wish to retrieve
- * the address information.
- * Values can be 0,1, or 2.
+ *	The rar_get_address function is used by other device drivers
+ *	to obtain RAR address information on a RAR. It takes three
+ *	parameters:
  *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
+ *	The function returns a 0 upon success or an error if there is no RAR
+ *	facility on this system.
  */
-int rar_get_address(int rar_index,
-	dma_addr_t *start_address,
-	dma_addr_t *end_address)
+int rar_get_address(int rar_index, dma_addr_t *start, dma_addr_t *end)
 {
-	int result = -ENODEV;
-
-	if (my_rar_device.registered) {
-		if (start_address == 0 || end_address == 0
-			|| rar_index >= MRST_NUM_RAR || rar_index < 0) {
-			result = -EINVAL;
-		} else {
-			*start_address =
-				my_rar_device.rar_addr[rar_index].low;
-			*end_address =
-				my_rar_device.rar_addr[rar_index].high;
-
-			result = 0;
-		}
+	int idx;
+	struct rar_device *rar = rar_to_device(rar_index, &idx);
+
+	if (rar == NULL) {
+		WARN_ON(1);
+		return -ENODEV;
 	}
 
-	return result;
+	*start = rar->rar_addr[idx].low;
+	*end = rar->rar_addr[idx].high;
+	return 0;
 }
 EXPORT_SYMBOL(rar_get_address);
 
-/*
- * The rar_lock function is ued by other device drivers to lock an RAR.
- * once an RAR is locked, it stays locked until the next system reboot.
- * The function takes one parameter:
+/**
+ *	rar_lock	-	lock a RAR register
+ *	@rar_index: RAR to lock (0-2)
  *
- * int rar_index
- * The rar_index is an index to the rar that you want to lock.
- * Values can be 0,1, or 2.
+ *	The rar_lock function is ued by other device drivers to lock an RAR.
+ *	once a RAR is locked, it stays locked until the next system reboot.
  *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
+ *	The function returns a 0 upon success or an error if there is no RAR
+ *	facility on this system, or the locking fails
  */
 int rar_lock(int rar_index)
 {
-	int result = -ENODEV;
-
-	if (rar_index >= MRST_NUM_RAR || rar_index < 0) {
-		result = -EINVAL;
-		return result;
-	}
-
-	dev_dbg(&my_rar_device.rar_dev->dev, "rar_lock mutex locking\n");
-	mutex_lock(&rar_mutex);
+	struct rar_device *rar;
+	int result;
+	int idx;
+	dma_addr_t low, high;
 
-	if (my_rar_device.registered) {
+	rar = rar_to_device(rar_index, &idx);
 
-		dma_addr_t low = my_rar_device.rar_addr[rar_index].low &
-			0xfffffc00u;
+	if (rar == NULL) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
 
-		dma_addr_t high = my_rar_device.rar_addr[rar_index].high &
-			0xfffffc00u;
+	low = rar->rar_addr[idx].low & 0xfffffc00u;
+	high = rar->rar_addr[idx].high & 0xfffffc00u;
 
-		/*
-		* Only allow I/O from the graphics and Langwell;
-		* Not from the x96 processor
-		*/
-		if (rar_index == (int)RAR_TYPE_VIDEO) {
-			low |= 0x00000009;
-			high |= 0x00000015;
-		}
+	/*
+	* Only allow I/O from the graphics and Langwell;
+	* not from the x86 processor
+	*/
 
-		else if (rar_index == (int)RAR_TYPE_AUDIO) {
-			/* Only allow I/O from Langwell; nothing from x86 */
-			low |= 0x00000008;
-			high |= 0x00000018;
-		}
+	if (rar_index == RAR_TYPE_VIDEO) {
+		low |= 0x00000009;
+		high |= 0x00000015;
+	} else if (rar_index == RAR_TYPE_AUDIO) {
+		/* Only allow I/O from Langwell; nothing from x86 */
+		low |= 0x00000008;
+		high |= 0x00000018;
+	} else
+		/* Read-only from all agents */
+		high |= 0x00000018;
 
-		else
-			/* Read-only from all agents */
-			high |= 0x00000018;
+	/*
+	* Now program the register using the Lincroft message
+	* bus interface.
+	*/
+	result = rar_set_addr(rar->rar_dev,
+				2 * idx, low);
 
-		/*
-		* Now program the register using the Lincroft message
-		* bus interface.
-		*/
-		result = set_rar_address(my_rar_device.rar_dev,
-			my_rar_device.rar_offsets[rar_index].low,
-			low);
-
-		if (result == 0)
-			result = set_rar_address(
-			my_rar_device.rar_dev,
-			my_rar_device.rar_offsets[rar_index].high,
-			high);
-	}
+	if (result == 0)
+		result = rar_set_addr(rar->rar_dev,
+				2 * idx + 1, high);
 
-	dev_dbg(&my_rar_device.rar_dev->dev, "rar_lock mutex unlocking\n");
-	mutex_unlock(&rar_mutex);
 	return result;
 }
 EXPORT_SYMBOL(rar_lock);
 
-/* The register_rar function is to used by other device drivers
- * to ensure that this driver is ready. As we cannot be sure of
- * the compile/execute order of dirvers in ther kernel, it is
- * best to give this driver a callback function to call when
- * it is ready to give out addresses. The callback function
- * would have those steps that continue the initialization of
- * a driver that do require a valid RAR address. One of those
- * steps would be to call rar_get_address()
- * This function return 0 on success an -1 on failure.
-*/
-int register_rar(int (*callback)(void *yourparameter), void *yourparameter)
+/**
+ *	register_rar		-	register a RAR handler
+ *	@num: RAR we wish to register for
+ *	@callback: function to call when RAR support is available
+ *	@data: data to pass to this function
+ *
+ *	The register_rar function is to used by other device drivers
+ *	to ensure that this driver is ready. As we cannot be sure of
+ *	the compile/execute order of drivers in ther kernel, it is
+ *	best to give this driver a callback function to call when
+ *	it is ready to give out addresses. The callback function
+ *	would have those steps that continue the initialization of
+ *	a driver that do require a valid RAR address. One of those
+ *	steps would be to call rar_get_address()
+ *
+ *	This function return 0 on success an error code on failure.
+ */
+int register_rar(int num, int (*callback)(unsigned long data),
+							unsigned long data)
 {
-
-	int result = -ENODEV;
-
-	if (callback == NULL)
-		return -EINVAL;
+	/* For now we hardcode a single RAR device */
+	struct rar_device *rar;
+	struct client *c;
+	int idx;
+	int retval = 0;
 
 	mutex_lock(&rar_mutex);
 
-	if (my_rar_device.registered) {
+	/* Do we have a client mapping for this RAR number ? */
+	c = rar_to_client(num);
+	if (c == NULL) {
+		retval = -ERANGE;
+		goto done;
+	}
+	/* Is it claimed ? */
+	if (c->busy) {
+		retval = -EBUSY;
+		goto done;
+	}
+	c->busy = 1;
+
+	/* See if we have a handler for this RAR yet, if we do then fire it */
+	rar = rar_to_device(num, &idx);
 
-		mutex_unlock(&rar_mutex);
+	if (rar) {
 		/*
 		* if the driver already registered, then we can simply
 		* call the callback right now
 		*/
-
-		return (*callback)(yourparameter);
-	}
-
-	if (num_clients < MRST_NUM_RAR) {
-
-		clients[num_clients].client_callback = callback;
-		clients[num_clients].customer_data = yourparameter;
-		num_clients += 1;
-		result = 0;
+		(*callback)(data);
+		goto done;
 	}
 
+	/* Arrange to be called back when the hardware is found */
+	c->callback = callback;
+	c->driver_priv = data;
+done:
 	mutex_unlock(&rar_mutex);
-	return result;
-
+	return retval;
 }
 EXPORT_SYMBOL(register_rar);
 
-/* Suspend - returns -ENOSYS */
-static int rar_suspend(struct pci_dev *dev, pm_message_t state)
+/**
+ *	unregister_rar	-	release a RAR allocation
+ *	@num: RAR number
+ *
+ *	Releases a RAR allocation, or pending allocation. If a callback is
+ *	pending then this function will either complete before the unregister
+ *	returns or not at all.
+ */
+
+void unregister_rar(int num)
 {
-	return -ENOSYS;
+	struct client *c;
+
+	mutex_lock(&rar_mutex);
+	c = rar_to_client(num);
+	if (c == NULL || !c->busy)
+		WARN_ON(1);
+	else
+		c->busy = 0;
+	mutex_unlock(&rar_mutex);
 }
+EXPORT_SYMBOL(unregister_rar);
 
-static int rar_resume(struct pci_dev *dev)
+/**
+ *	rar_callback		-	Process callbacks
+ *	@rar: new RAR device
+ *
+ *	Process the callbacks for a newly found RAR device.
+ */
+
+static void rar_callback(struct rar_device *rar)
 {
-	return -ENOSYS;
+	struct client *c = &rar->client[0];
+	int i;
+
+	mutex_lock(&rar_mutex);
+
+	rar->registered = 1;	/* Ensure no more callbacks queue */
+
+	for (i = 0; i < MRST_NUM_RAR; i++) {
+		if (c->callback && c->busy) {
+			c->callback(c->driver_priv);
+			c->callback = NULL;
+		}
+		c++;
+	}
+	mutex_unlock(&rar_mutex);
 }
 
-/*
- * This function registers the driver with the device subsystem (
- * either PCI, USB, etc).
- * Function that is activaed on the succesful probe of the RAR device
- * (Moorestown host controller).
+/**
+ *	rar_probe		-	PCI probe callback
+ *	@dev: PCI device
+ *	@id: matching entry in the match table
+ *
+ *	A RAR device has been discovered. Initialise it and if successful
+ *	process any pending callbacks that can now be completed.
  */
 static int rar_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	int error;
-	int counter;
+	struct rar_device *rar;
 
 	dev_dbg(&dev->dev, "PCI probe starting\n");
 
-	/* enable the device */
+	rar = alloc_rar_device();
+	if (rar == NULL)
+		return -EBUSY;
+
+	/* Enable the device */
 	error = pci_enable_device(dev);
 	if (error) {
 		dev_err(&dev->dev,
@@ -538,50 +619,30 @@ static int rar_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		goto end_function;
 	}
 
-	/* we have only one device; fill in the rar_device structure */
-	my_rar_device.rar_dev = dev;
+	/* Fill in the rar_device structure */
+	rar->rar_dev = pci_dev_get(dev);
+	pci_set_drvdata(dev, rar);
 
 	/*
-	* Initialize the RAR parameters, which have to be retrieved
-	* via the message bus interface.
-	*/
-	error = init_rar_params(dev);
+	 * Initialize the RAR parameters, which have to be retrieved
+	 * via the message bus interface.
+	 */
+	error = init_rar_params(rar);
 	if (error) {
 		pci_disable_device(dev);
-
-		dev_err(&dev->dev,
-			"Error retrieving RAR addresses\n");
-
+		dev_err(&dev->dev, "Error retrieving RAR addresses\n");
 		goto end_function;
 	}
-
-	dev_dbg(&dev->dev, "PCI probe locking\n");
-	mutex_lock(&rar_mutex);
-	my_rar_device.registered = 1;
-
 	/* now call anyone who has registered (using callbacks) */
-	for (counter = 0; counter < num_clients; counter += 1) {
-		if (clients[counter].client_callback) {
-			error = (*clients[counter].client_callback)(
-				clients[counter].customer_data);
-			/* set callback to NULL to indicate it has been done */
-			clients[counter].client_callback = NULL;
-				dev_dbg(&my_rar_device.rar_dev->dev,
-				"Callback called for %d\n",
-			counter);
-		}
-	}
-
-	dev_dbg(&dev->dev, "PCI probe unlocking\n");
-	mutex_unlock(&rar_mutex);
-
+	rar_callback(rar);
+	return 0;
 end_function:
-
+	free_rar_device(rar);
 	return error;
 }
 
 const struct pci_device_id rar_pci_id_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_RAR_DEVICE_ID) },
+	{ PCI_VDEVICE(INTEL, 0x4110) },
 	{ 0 }
 };
 
@@ -594,8 +655,7 @@ static struct pci_driver rar_pci_driver = {
 	.name = "rar_register_driver",
 	.id_table = rar_pci_id_tbl,
 	.probe = rar_probe,
-	.suspend = rar_suspend,
-	.resume = rar_resume
+	/* Cannot be unplugged - no remove */
 };
 
 static int __init rar_init_handler(void)
diff --git a/drivers/staging/rar_register/rar_register.h b/drivers/staging/rar_register/rar_register.h
index 29ade0f..ffa8057 100644
--- a/drivers/staging/rar_register/rar_register.h
+++ b/drivers/staging/rar_register/rar_register.h
@@ -21,63 +21,23 @@
 #ifndef _RAR_REGISTER_H
 #define _RAR_REGISTER_H
 
-# include <linux/types.h>
+#include <linux/types.h>
 
 /* following are used both in drivers as well as user space apps */
-enum RAR_type {
-	RAR_TYPE_VIDEO = 0,
-	RAR_TYPE_AUDIO,
-	RAR_TYPE_IMAGE,
-	RAR_TYPE_DATA
-};
 
-#ifdef __KERNEL__
+#define	RAR_TYPE_VIDEO	0
+#define	RAR_TYPE_AUDIO	1
+#define	RAR_TYPE_IMAGE	2
+#define	RAR_TYPE_DATA	3
 
-/* PCI device id for controller */
-#define PCI_RAR_DEVICE_ID 0x4110
+#ifdef __KERNEL__
 
-/* The register_rar function is to used by other device drivers
- * to ensure that this driver is ready. As we cannot be sure of
- * the compile/execute order of dirvers in ther kernel, it is
- * best to give this driver a callback function to call when
- * it is ready to give out addresses. The callback function
- * would have those steps that continue the initialization of
- * a driver that do require a valid RAR address. One of those
- * steps would be to call get_rar_address()
- * This function return 0 on success an -1 on failure.
- */
-int register_rar(int (*callback)(void *yourparameter), void *yourparameter);
+struct rar_device;
 
-/* The get_rar_address function is used by other device drivers
- * to obtain RAR address information on a RAR. It takes two
- * parameter:
- *
- * int rar_index
- * The rar_index is an index to the rar for which you wish to retrieve
- * the address information.
- * Values can be 0,1, or 2.
- *
- * struct RAR_address_struct is a pointer to a place to which the function
- * can return the address structure for the RAR.
- *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
- */
-int rar_get_address(int rar_index,
-		dma_addr_t *start_address,
-		dma_addr_t *end_address);
-
-/* The lock_rar function is ued by other device drivers to lock an RAR.
- * once an RAR is locked, it stays locked until the next system reboot.
- * The function takes one parameter:
- *
- * int rar_index
- * The rar_index is an index to the rar that you want to lock.
- * Values can be 0,1, or 2.
- *
- * The function returns a 0 upon success or a -1 if there is no RAR
- * facility on this system.
- */
+int register_rar(int num,
+		int (*callback)(unsigned long data), unsigned long data);
+void unregister_rar(int num);
+int rar_get_address(int rar_index, dma_addr_t *start, dma_addr_t *end);
 int rar_lock(int rar_index);
 
 #endif  /* __KERNEL__ */
