Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab1CDAgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 19:36:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:3031 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab1CDAf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 19:35:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,261,1297065600"; 
   d="scan'208";a="715944441"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com
Subject: [PATCH 1/1] staging: sep: remove unused ioctls
Date: Thu,  3 Mar 2011 16:38:28 -0800
Message-Id: <1299199108-25024-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove associated functions, structures, and defines

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/TODO             |    2 -
 drivers/staging/sep/sep_dev.h        |   25 --
 drivers/staging/sep/sep_driver.c     |  411 +---------------------------------
 drivers/staging/sep/sep_driver_api.h |   82 -------
 4 files changed, 1 insertions(+), 519 deletions(-)

diff --git a/drivers/staging/sep/TODO b/drivers/staging/sep/TODO
index a89e7d6..8f3b878 100644
--- a/drivers/staging/sep/TODO
+++ b/drivers/staging/sep/TODO
@@ -1,6 +1,4 @@
 Todo's so far (from Alan Cox)
 - Check whether it can be plugged into any of the kernel crypto API
   interfaces - Crypto API 'glue' is still not ready to submit
-- Clean up unused ioctls - Needs vendor help
-- Clean up unused fields in ioctl structures - Needs vendor help
 - Clean up un-needed debug prints - Started to work on this
diff --git a/drivers/staging/sep/sep_dev.h b/drivers/staging/sep/sep_dev.h
index 0ffe68c..696ab0d 100644
--- a/drivers/staging/sep/sep_dev.h
+++ b/drivers/staging/sep/sep_dev.h
@@ -69,31 +69,6 @@ struct sep_device {
 	size_t shared_size;
 	void *shared_addr;
 
-	/* restricted access region (coherent alloc) */
-	dma_addr_t rar_bus;
-	size_t rar_size;
-	void *rar_addr;
-
-	/* Firmware regions; cache is at rar for Moorestown and
-	   resident is at rar for Medfield */
-	dma_addr_t cache_bus;
-	size_t cache_size;
-	void *cache_addr;
-
-	dma_addr_t resident_bus;
-	size_t resident_size;
-	void *resident_addr;
-
-	/* sep's scratchpad */
-	dma_addr_t dcache_bus;
-	size_t dcache_size;
-	void *dcache_addr;
-
-	/* Only used on Medfield */
-	dma_addr_t extapp_bus;
-	size_t extapp_size;
-	void *extapp_addr;
-
 	/* start address of the access to the SEP registers from driver */
 	dma_addr_t reg_physical_addr;
 	dma_addr_t reg_physical_end;
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index d841289..71a5fbc 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -77,93 +77,6 @@
 static struct sep_device *sep_dev;
 
 /**
- *	sep_load_firmware - copy firmware cache/resident
- *	@sep: pointer to struct sep_device we are loading
- *
- *	This functions copies the cache and resident from their source
- *	location into destination shared memory.
- */
-static int sep_load_firmware(struct sep_device *sep)
-{
-	const struct firmware *fw;
-	char *cache_name = "cache.image.bin";
-	char *res_name = "resident.image.bin";
-	char *extapp_name = "extapp.image.bin";
-	int error ;
-	unsigned long work1, work2, work3;
-
-	/* Set addresses and load resident */
-	sep->resident_bus = sep->rar_bus;
-	sep->resident_addr = sep->rar_addr;
-
-	error = request_firmware(&fw, res_name, &sep->pdev->dev);
-	if (error) {
-		dev_warn(&sep->pdev->dev, "can't request resident fw\n");
-		return error;
-	}
-
-	memcpy(sep->resident_addr, (void *)fw->data, fw->size);
-	sep->resident_size = fw->size;
-	release_firmware(fw);
-
-	dev_dbg(&sep->pdev->dev, "resident bus is %lx\n",
-		(unsigned long)sep->resident_bus);
-
-	/* Set addresses for dcache (no loading needed) */
-	work1 = (unsigned long)sep->resident_bus;
-	work2 = (unsigned long)sep->resident_size;
-	work3 = (work1 + work2 + (1024 * 4)) & 0xfffff000;
-	sep->dcache_bus = (dma_addr_t)work3;
-
-	work1 = (unsigned long)sep->resident_addr;
-	work2 = (unsigned long)sep->resident_size;
-	work3 = (work1 + work2 + (1024 * 4)) & 0xfffff000;
-	sep->dcache_addr = (void *)work3;
-
-	sep->dcache_size = 1024 * 128;
-
-	/* Set addresses and load cache */
-	sep->cache_bus = sep->dcache_bus + sep->dcache_size;
-	sep->cache_addr = sep->dcache_addr + sep->dcache_size;
-
-	error = request_firmware(&fw, cache_name, &sep->pdev->dev);
-	if (error) {
-		dev_warn(&sep->pdev->dev, "Unable to request cache firmware\n");
-		return error;
-	}
-
-	memcpy(sep->cache_addr, (void *)fw->data, fw->size);
-	sep->cache_size = fw->size;
-	release_firmware(fw);
-
-	dev_dbg(&sep->pdev->dev, "cache bus is %08lx\n",
-		(unsigned long)sep->cache_bus);
-
-	/* Set addresses and load extapp */
-	sep->extapp_bus = sep->cache_bus + (1024 * 370);
-	sep->extapp_addr = sep->cache_addr + (1024 * 370);
-
-	error = request_firmware(&fw, extapp_name, &sep->pdev->dev);
-	if (error) {
-		dev_warn(&sep->pdev->dev, "Unable to request extapp firmware\n");
-		return error;
-	}
-
-	memcpy(sep->extapp_addr, (void *)fw->data, fw->size);
-	sep->extapp_size = fw->size;
-	release_firmware(fw);
-
-	dev_dbg(&sep->pdev->dev, "extapp bus is %08llx\n",
-		(unsigned long long)sep->extapp_bus);
-
-	return error;
-}
-
-MODULE_FIRMWARE("sep/cache.image.bin");
-MODULE_FIRMWARE("sep/resident.image.bin");
-MODULE_FIRMWARE("sep/extapp.image.bin");
-
-/**
  *	sep_dump_message - dump the message that is pending
  *	@sep: SEP device
  */
@@ -2282,58 +2195,6 @@ end_function:
 
 }
 
-
-/**
- *	sep_create_sync_dma_tables_handler - create sync DMA tables
- *	@sep: pointer to struct sep_device
- *	@arg: pointer to struct bld_syn_tab_struct
- *
- *	Handle the request for creation of the DMA tables for the synchronic
- *	symmetric operations (AES,DES). Note that all bus addresses that are
- *	passed to the SEP are in 32 bit format; the SEP is a 32 bit device
- */
-static int sep_create_sync_dma_tables_handler(struct sep_device *sep,
-						unsigned long arg)
-{
-	int error = 0;
-
-	/* Command arguments */
-	struct bld_syn_tab_struct command_args;
-
-	if (copy_from_user(&command_args, (void __user *)arg,
-					sizeof(struct bld_syn_tab_struct))) {
-		error = -EFAULT;
-		goto end_function;
-	}
-
-	dev_dbg(&sep->pdev->dev, "create dma table handler app_in_address is %08llx\n",
-						command_args.app_in_address);
-	dev_dbg(&sep->pdev->dev, "app_out_address is %08llx\n",
-						command_args.app_out_address);
-	dev_dbg(&sep->pdev->dev, "data_size is %u\n",
-						command_args.data_in_size);
-	dev_dbg(&sep->pdev->dev, "block_size is %u\n",
-						command_args.block_size);
-
-	/* Validate user parameters */
-	if (!command_args.app_in_address) {
-		error = -EINVAL;
-		goto end_function;
-	}
-
-	error = sep_prepare_input_output_dma_table_in_dcb(sep,
-		(unsigned long)command_args.app_in_address,
-		(unsigned long)command_args.app_out_address,
-		command_args.data_in_size,
-		command_args.block_size,
-		0x0,
-		false,
-		false);
-
-end_function:
-	return error;
-}
-
 /**
  *	sep_free_dma_tables_and_dcb - free DMA tables and DCBs
  *	@sep: pointer to struct sep_device
@@ -2411,204 +2272,6 @@ static int sep_get_static_pool_addr_handler(struct sep_device *sep)
 }
 
 /**
- *	sep_start_handler - start device
- *	@sep: pointer to struct sep_device
- */
-static int sep_start_handler(struct sep_device *sep)
-{
-	unsigned long reg_val;
-	unsigned long error = 0;
-
-	/* Wait in polling for message from SEP */
-	do {
-		reg_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
-	} while (!reg_val);
-
-	/* Check the value */
-	if (reg_val == 0x1)
-		/* Fatal error - read error status from GPRO */
-		error = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR0_REG_ADDR);
-	return error;
-}
-
-/**
- *	ep_check_sum_calc - checksum messages
- *	@data: buffer to checksum
- *	@length: buffer size
- *
- *	This function performs a checksum for messages that are sent
- *	to the SEP.
- */
-static u32 sep_check_sum_calc(u8 *data, u32 length)
-{
-	u32 sum = 0;
-	u16 *Tdata = (u16 *)data;
-
-	while (length > 1) {
-		/*  This is the inner loop */
-		sum += *Tdata++;
-		length -= 2;
-	}
-
-	/*  Add left-over byte, if any */
-	if (length > 0)
-		sum += *(u8 *)Tdata;
-
-	/*  Fold 32-bit sum to 16 bits */
-	while (sum>>16)
-		sum = (sum & 0xffff) + (sum >> 16);
-
-	return ~sum & 0xFFFF;
-}
-
-/**
- *	sep_init_handler -
- *	@sep: pointer to struct sep_device
- *	@arg: parameters from user space application
- *
- *	Handles the request for SEP initialization
- *	Note that this will go away for Medfield once the SCU
- *	SEP initialization is complete
- *	Also note that the message to the SEP has components
- *	from user space as well as components written by the driver
- *	This is becuase the portions of the message that pertain to
- *	physical addresses must be set by the driver after the message
- *	leaves custody of the user space application for security
- *	reasons.
- */
-static int sep_init_handler(struct sep_device *sep, unsigned long arg)
-{
-	u32 message_buff[14];
-	u32 counter;
-	int error = 0;
-	u32 reg_val;
-	dma_addr_t new_base_addr;
-	unsigned long addr_hold;
-	struct init_struct command_args;
-
-	/* Make sure that we have not initialized already */
-	reg_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
-
-	if (reg_val != 0x2) {
-		error = SEP_ALREADY_INITIALIZED_ERR;
-		dev_dbg(&sep->pdev->dev, "init; device already initialized\n");
-		goto end_function;
-	}
-
-	/* Only root can initialize */
-	if (!capable(CAP_SYS_ADMIN)) {
-		error = -EACCES;
-		goto end_function;
-	}
-
-	/* Copy in the parameters */
-	error = copy_from_user(&command_args, (void __user *)arg,
-		sizeof(struct init_struct));
-
-	if (error) {
-		error = -EFAULT;
-		goto end_function;
-	}
-
-	/* Validate parameters */
-	if (!command_args.message_addr || !command_args.sep_sram_addr ||
-		command_args.message_size_in_words > 14) {
-		error = -EINVAL;
-		goto end_function;
-	}
-
-	/* Copy in the SEP init message */
-	addr_hold = (unsigned long)command_args.message_addr;
-	error = copy_from_user(message_buff,
-		(void __user *)addr_hold,
-		command_args.message_size_in_words*sizeof(u32));
-
-	if (error) {
-		error = -EFAULT;
-		goto end_function;
-	}
-
-	/* Load resident, cache, and extapp firmware */
-	error = sep_load_firmware(sep);
-
-	if (error) {
-		dev_warn(&sep->pdev->dev,
-			"init; copy SEP init message failed %x\n", error);
-		goto end_function;
-	}
-
-	/* Compute the base address */
-	new_base_addr = sep->shared_bus;
-
-	if (sep->resident_bus < new_base_addr)
-		new_base_addr = sep->resident_bus;
-
-	if (sep->cache_bus < new_base_addr)
-		new_base_addr = sep->cache_bus;
-
-	if (sep->dcache_bus < new_base_addr)
-		new_base_addr = sep->dcache_bus;
-
-	/* Put physical addresses in SEP message */
-	message_buff[3] = (u32)new_base_addr;
-	message_buff[4] = (u32)sep->shared_bus;
-	message_buff[6] = (u32)sep->resident_bus;
-	message_buff[7] = (u32)sep->cache_bus;
-	message_buff[8] = (u32)sep->dcache_bus;
-
-	message_buff[command_args.message_size_in_words - 1] = 0x0;
-	message_buff[command_args.message_size_in_words - 1] =
-		sep_check_sum_calc((u8 *)message_buff,
-		command_args.message_size_in_words*sizeof(u32));
-
-	/* Debug print of message */
-	for (counter = 0; counter < command_args.message_size_in_words;
-								counter++)
-		dev_dbg(&sep->pdev->dev, "init; SEP message word %d is %x\n",
-			counter, message_buff[counter]);
-
-	/* Tell the SEP the sram address */
-	sep_write_reg(sep, HW_SRAM_ADDR_REG_ADDR, command_args.sep_sram_addr);
-
-	/* Push the message to the SEP */
-	for (counter = 0; counter < command_args.message_size_in_words;
-								counter++) {
-		sep_write_reg(sep, HW_SRAM_DATA_REG_ADDR,
-						message_buff[counter]);
-		sep_wait_sram_write(sep);
-	}
-
-	/* Signal SEP that message is ready and to init */
-	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x1);
-
-	/* Wait for acknowledge */
-
-	do {
-		reg_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
-	} while (!(reg_val & 0xFFFFFFFD));
-
-	if (reg_val == 0x1) {
-		dev_warn(&sep->pdev->dev, "init; device int failed\n");
-		error = sep_read_reg(sep, 0x8060);
-		dev_warn(&sep->pdev->dev, "init; sw monitor is %x\n", error);
-		error = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR0_REG_ADDR);
-		dev_warn(&sep->pdev->dev, "init; error is %x\n", error);
-		goto end_function;
-	}
-	/* Signal SEP to zero the GPR3 */
-	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x10);
-
-	/* Wait for response */
-
-	do {
-		reg_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
-	} while (reg_val != 0);
-
-end_function:
-	return error;
-}
-
-/**
  *	sep_end_transaction_handler - end transaction
  *	@sep: pointer to struct sep_device
  *
@@ -2748,30 +2411,6 @@ end_function:
 }
 
 /**
- *	sep_realloc_ext_cache_handler - report location of extcache
- *	@sep: pointer to struct sep_device
- *	@arg: pointer to user parameters
- *
- *	This function tells the SEP where the extapp is located
- */
-static int sep_realloc_ext_cache_handler(struct sep_device *sep,
-	unsigned long arg)
-{
-	/* Holds the new ext cache address in the system memory offset */
-	u32 *system_addr;
-
-	/* Set value in the SYSTEM MEMORY offset */
-	system_addr = (u32 *)(sep->shared_addr +
-		SEP_DRIVER_SYSTEM_EXT_CACHE_ADDR_OFFSET_IN_BYTES);
-
-	/* Copy the physical address to the System Area for the SEP */
-	system_addr[0] = SEP_EXT_CACHE_ADDR_VAL_TOKEN;
-	system_addr[1] = sep->extapp_bus;
-
-	return 0;
-}
-
-/**
  *	sep_ioctl - ioctl api
  *	@filp: pointer to struct file
  *	@cmd: command
@@ -2810,28 +2449,6 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		/* Allocate data pool */
 		error = sep_allocate_data_pool_memory_handler(sep, arg);
 		break;
-	case SEP_IOCCREATESYMDMATABLE:
-		/* Create DMA table for synhronic operation */
-		error = sep_create_sync_dma_tables_handler(sep, arg);
-		break;
-	case SEP_IOCFREEDMATABLEDATA:
-		/* Free the pages */
-		error = sep_free_dma_table_data_handler(sep);
-		break;
-	case SEP_IOCSEPSTART:
-		/* Start command to SEP */
-		if (sep->pdev->revision == 0) /* Only for old chip */
-			error = sep_start_handler(sep);
-		else
-			error = -EPERM; /* Not permitted on new chip */
-		break;
-	case SEP_IOCSEPINIT:
-		/* Init command to SEP */
-		if (sep->pdev->revision == 0) /* Only for old chip */
-			error = sep_init_handler(sep, arg);
-		else
-			error = -EPERM; /* Not permitted on new chip */
-		break;
 	case SEP_IOCGETSTATICPOOLADDR:
 		/* Inform the SEP the bus address of the static pool */
 		error = sep_get_static_pool_addr_handler(sep);
@@ -2839,12 +2456,6 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case SEP_IOCENDTRANSACTION:
 		error = sep_end_transaction_handler(sep);
 		break;
-	case SEP_IOCREALLOCEXTCACHE:
-		if (sep->pdev->revision == 0) /* Only for old chip */
-			error = sep_realloc_ext_cache_handler(sep, arg);
-		else
-			error = -EPERM; /* Not permitted on new chip */
-		break;
 	case SEP_IOCRARPREPAREMESSAGE:
 		error = sep_rar_prepare_output_msg_handler(sep, arg);
 		break;
@@ -3213,20 +2824,6 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 		goto end_function_error;
 	}
 
-	sep->rar_size = FAKE_RAR_SIZE;
-	sep->rar_addr = dma_alloc_coherent(&sep->pdev->dev,
-		sep->rar_size, &sep->rar_bus, GFP_KERNEL);
-	if (sep->rar_addr == NULL) {
-		dev_warn(&sep->pdev->dev, "can't allocate mfld rar\n");
-		error = -ENOMEM;
-		goto end_function_deallocate_sep_shared_area;
-	}
-
-	dev_dbg(&sep->pdev->dev, "rar start is %p, phy is %llx,"
-		" size is %zx\n", sep->rar_addr,
-		(unsigned long long)sep->rar_bus,
-		sep->rar_size);
-
 	/* Clear ICR register */
 	sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, 0xFFFFFFFF);
 
@@ -3243,7 +2840,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 		"sep_driver", sep);
 
 	if (error)
-		goto end_function_dealloc_rar;
+		goto end_function_deallocate_sep_shared_area;
 
 	/* The new chip requires a shared area reconfigure */
 	if (sep->pdev->revision == 4) { /* Only for new chip */
@@ -3261,12 +2858,6 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 end_function_free_irq:
 	free_irq(pdev->irq, sep);
 
-end_function_dealloc_rar:
-	if (sep->rar_addr)
-		dma_free_coherent(&sep->pdev->dev, sep->rar_size,
-			sep->rar_addr, sep->rar_bus);
-	goto end_function;
-
 end_function_deallocate_sep_shared_area:
 	/* De-allocate shared area */
 	sep_unmap_and_free_shared_area(sep);
diff --git a/drivers/staging/sep/sep_driver_api.h b/drivers/staging/sep/sep_driver_api.h
index 0f38d61..c3aacfc 100644
--- a/drivers/staging/sep/sep_driver_api.h
+++ b/drivers/staging/sep/sep_driver_api.h
@@ -42,48 +42,6 @@
     TYPEDEFS
 ----------------------------------------------*/
 
-/*
- * Note that several members of these structres are only here
- * for campatability with the middleware; they are not used
- * by this driver.
- * All user space buffer addresses are set to aligned u64
- * in order to ensure compatibility with 64 bit systems
- */
-
-/*
-  init command struct; this will go away when SCU does init
-*/
-struct init_struct {
-	/* address that SEP can access for message */
-	aligned_u64   message_addr;
-
-	/* message size */
-	u32   message_size_in_words;
-
-	/* offset of the init message in the sep sram */
-	u32   sep_sram_addr;
-
-	/* -not used- resident size in bytes*/
-	u32   unused_resident_size_in_bytes;
-
-	/* -not used- cache size in bytes*/
-	u32   unused_cache_size_in_bytes;
-
-	/* -not used- ext cache current address */
-	aligned_u64   unused_extcache_addr;
-
-	/* -not used- ext cache size in bytes*/
-	u32   unused_extcache_size_in_bytes;
-};
-
-struct realloc_ext_struct {
-	/* -not used- current external cache address */
-	aligned_u64   unused_ext_cache_addr;
-
-	/* -not used- external cache size in bytes*/
-	u32   unused_ext_cache_size_in_bytes;
-};
-
 struct alloc_struct {
 	/* offset from start of shared pool area */
 	u32  offset;
@@ -91,29 +49,6 @@ struct alloc_struct {
 	u32  num_bytes;
 };
 
-/*
-	Note that all app addresses are cast as u32; the sep
-	middleware sends them as fixed 32 bit words
-*/
-struct bld_syn_tab_struct {
-	/* address value of the data in (user space addr) */
-	aligned_u64 app_in_address;
-
-	/* size of data in */
-	u32 data_in_size;
-
-	/* address of the data out (user space addr) */
-	aligned_u64 app_out_address;
-
-	/* the size of the block of the operation - if needed,
-	   every table will be modulo this parameter */
-	u32 block_size;
-
-	/* -not used- distinct user/kernel layout */
-	bool isKernelVirtualAddress;
-
-};
-
 /* command struct for getting caller id value and address */
 struct caller_id_struct {
 	/* pid of the process */
@@ -253,10 +188,6 @@ struct sep_lli_entry {
 #define SEP_IOCALLOCDATAPOLL	\
 	_IOW(SEP_IOC_MAGIC_NUMBER, 2, struct alloc_struct)
 
-/* create sym dma lli tables */
-#define SEP_IOCCREATESYMDMATABLE	\
-	_IOW(SEP_IOC_MAGIC_NUMBER, 5, struct bld_syn_tab_struct)
-
 /* free dynamic data aalocated during table creation */
 #define SEP_IOCFREEDMATABLEDATA	 \
 	_IO(SEP_IOC_MAGIC_NUMBER, 7)
@@ -265,23 +196,10 @@ struct sep_lli_entry {
 #define SEP_IOCGETSTATICPOOLADDR	\
 	_IO(SEP_IOC_MAGIC_NUMBER, 8)
 
-/* start sep command */
-#define SEP_IOCSEPSTART	 \
-	_IO(SEP_IOC_MAGIC_NUMBER, 12)
-
-/* init sep command */
-#define SEP_IOCSEPINIT	\
-	_IOW(SEP_IOC_MAGIC_NUMBER, 13, struct init_struct)
-
 /* end transaction command */
 #define SEP_IOCENDTRANSACTION	 \
 	_IO(SEP_IOC_MAGIC_NUMBER, 15)
 
-/* reallocate external app; unused structure still needed for
- * compatability with middleware */
-#define SEP_IOCREALLOCEXTCACHE	\
-	_IOW(SEP_IOC_MAGIC_NUMBER, 18, struct realloc_ext_struct)
-
 #define SEP_IOCRARPREPAREMESSAGE	\
 	_IOW(SEP_IOC_MAGIC_NUMBER, 20, struct rar_hndl_to_bus_struct)
 
-- 
1.6.3.3

