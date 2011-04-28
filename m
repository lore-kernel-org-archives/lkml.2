Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab1D1PnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:43:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58618 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760186Ab1D1PnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:43:20 -0400
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <x0095840@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Nishanth Menon <nm@ti.com>,
        lkml <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>
Subject: [PATCH v4 5/6] staging: tidspbridge: remove dmm module
Date: Thu, 28 Apr 2011 10:31:51 -0500
Message-Id: <1304004712-8487-6-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
References: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Guzman Lugo <x0095840@ti.com>

With iommu migration in place, there is no need to manage the
dsp va space with dmm module or proc_reserve/unreserve functions.

Deprecate reserve/un_reserve ioctls, given that there is a heavy
usage of these functions, print error message only if dynamic debug
is enabled.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/Makefile               |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |    1 -
 .../staging/tidspbridge/include/dspbridge/dev.h    |   24 -
 .../staging/tidspbridge/include/dspbridge/dmm.h    |   75 ---
 .../staging/tidspbridge/include/dspbridge/drv.h    |   10 -
 .../staging/tidspbridge/include/dspbridge/proc.h   |   46 --
 drivers/staging/tidspbridge/pmgr/dev.c             |   61 +---
 drivers/staging/tidspbridge/pmgr/dmm.c             |  533 --------------------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   36 +-
 drivers/staging/tidspbridge/rmgr/drv.c             |   10 -
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    2 -
 drivers/staging/tidspbridge/rmgr/node.c            |   57 +--
 drivers/staging/tidspbridge/rmgr/proc.c            |   90 ----
 13 files changed, 18 insertions(+), 929 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dmm.h
 delete mode 100644 drivers/staging/tidspbridge/pmgr/dmm.c

diff --git a/drivers/staging/tidspbridge/Makefile b/drivers/staging/tidspbridge/Makefile
index 9c7f974..0bab58b 100644
--- a/drivers/staging/tidspbridge/Makefile
+++ b/drivers/staging/tidspbridge/Makefile
@@ -5,7 +5,7 @@ libcore = core/chnl_sm.o core/msg_sm.o core/io_sm.o core/tiomap3430.o \
 		core/tiomap3430_pwr.o core/tiomap_io.o \
 		core/ue_deh.o core/wdt.o core/dsp-clock.o core/sync.o
 libpmgr = pmgr/chnl.o pmgr/io.o pmgr/msg.o pmgr/cod.o pmgr/dev.o pmgr/dspapi.o \
-		pmgr/dmm.o pmgr/cmm.o pmgr/dbll.o
+		pmgr/cmm.o pmgr/dbll.o
 librmgr = rmgr/dbdcd.o rmgr/disp.o rmgr/drv.o rmgr/mgr.o rmgr/node.o \
 		rmgr/proc.o rmgr/pwr.o rmgr/rmm.o rmgr/strm.o rmgr/dspdrv.o \
 		rmgr/nldr.o rmgr/drv_interface.o
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index e9b2ce0..8b77837 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -47,7 +47,6 @@
 /*  ----------------------------------- Platform Manager */
 #include <dspbridge/dev.h>
 #include <dspbridge/dspapi.h>
-#include <dspbridge/dmm.h>
 #include <dspbridge/wdt.h>
 
 /*  ----------------------------------- Local */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dev.h b/drivers/staging/tidspbridge/include/dspbridge/dev.h
index f92b4be..232bcbc 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dev.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dev.h
@@ -27,7 +27,6 @@
 #include <dspbridge/nodedefs.h>
 #include <dspbridge/disp.h>
 #include <dspbridge/dspdefs.h>
-#include <dspbridge/dmm.h>
 #include <dspbridge/host_os.h>
 
 /*  ----------------------------------- This */
@@ -197,29 +196,6 @@ extern int dev_get_cmm_mgr(struct dev_object *hdev_obj,
 				  struct cmm_object **mgr);
 
 /*
- *  ======== dev_get_dmm_mgr ========
- *  Purpose:
- *      Retrieve the handle to the dynamic memory manager created for this
- *      device.
- *  Parameters:
- *      hdev_obj:     Handle to device object created with
- *                      dev_create_device().
- *      *mgr:           Ptr to location to store handle.
- *  Returns:
- *      0:        Success.
- *      -EFAULT:    Invalid hdev_obj.
- *  Requires:
- *      mgr != NULL.
- *      DEV Initialized.
- *  Ensures:
- *      0:        *mgr contains a handle to a channel manager object,
- *                      or NULL.
- *      else:           *mgr is NULL.
- */
-extern int dev_get_dmm_mgr(struct dev_object *hdev_obj,
-				  struct dmm_object **mgr);
-
-/*
  *  ======== dev_get_cod_mgr ========
  *  Purpose:
  *      Retrieve the COD manager create for this device.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dmm.h b/drivers/staging/tidspbridge/include/dspbridge/dmm.h
deleted file mode 100644
index 6c58335..0000000
--- a/drivers/staging/tidspbridge/include/dspbridge/dmm.h
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * dmm.h
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * The Dynamic Memory Mapping(DMM) module manages the DSP Virtual address
- * space that can be directly mapped to any MPU buffer or memory region.
- *
- * Copyright (C) 2005-2006 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-#ifndef DMM_
-#define DMM_
-
-#include <dspbridge/dbdefs.h>
-
-struct dmm_object;
-
-/* DMM attributes used in dmm_create() */
-struct dmm_mgrattrs {
-	u32 reserved;
-};
-
-#define DMMPOOLSIZE      0x4000000
-
-/*
- *  ======== dmm_get_handle ========
- *  Purpose:
- *      Return the dynamic memory manager object for this device.
- *      This is typically called from the client process.
- */
-
-extern int dmm_get_handle(void *hprocessor,
-				 struct dmm_object **dmm_manager);
-
-extern int dmm_reserve_memory(struct dmm_object *dmm_mgr,
-				     u32 size, u32 *prsv_addr);
-
-extern int dmm_un_reserve_memory(struct dmm_object *dmm_mgr,
-					u32 rsv_addr);
-
-extern int dmm_map_memory(struct dmm_object *dmm_mgr, u32 addr,
-				 u32 size);
-
-extern int dmm_un_map_memory(struct dmm_object *dmm_mgr,
-				    u32 addr, u32 *psize);
-
-extern int dmm_destroy(struct dmm_object *dmm_mgr);
-
-extern int dmm_delete_tables(struct dmm_object *dmm_mgr);
-
-extern int dmm_create(struct dmm_object **dmm_manager,
-			     struct dev_object *hdev_obj,
-			     const struct dmm_mgrattrs *mgr_attrts);
-
-extern bool dmm_init(void);
-
-extern void dmm_exit(void);
-
-extern int dmm_create_tables(struct dmm_object *dmm_mgr,
-				    u32 addr, u32 size);
-
-#ifdef DSP_DMM_DEBUG
-u32 dmm_mem_map_dump(struct dmm_object *dmm_mgr);
-#endif
-
-#endif /* DMM_ */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/drv.h b/drivers/staging/tidspbridge/include/dspbridge/drv.h
index ea74dda..5764073 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/drv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/drv.h
@@ -89,12 +89,6 @@ struct dmm_map_object {
 	struct bridge_dma_map_info dma_info;
 };
 
-/* Used for DMM reserved memory accounting */
-struct dmm_rsv_object {
-	struct list_head link;
-	u32 dsp_reserved_addr;
-};
-
 /* New structure (member of process context) abstracts stream resource info */
 struct strm_res_object {
 	s32 stream_allocated;	/* Stream status */
@@ -135,10 +129,6 @@ struct process_context {
 	struct list_head dmm_map_list;
 	spinlock_t dmm_map_lock;
 
-	/* DMM reserved memory resources */
-	struct list_head dmm_rsv_list;
-	spinlock_t dmm_rsv_lock;
-
 	/* Stream resources */
 	struct idr *stream_id;
 };
diff --git a/drivers/staging/tidspbridge/include/dspbridge/proc.h b/drivers/staging/tidspbridge/include/dspbridge/proc.h
index f00dffd..692b73d 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/proc.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/proc.h
@@ -551,29 +551,6 @@ extern int proc_map(void *hprocessor,
 			   struct process_context *pr_ctxt);
 
 /*
- *  ======== proc_reserve_memory ========
- *  Purpose:
- *      Reserve a virtually contiguous region of DSP address space.
- *  Parameters:
- *      hprocessor      :   The processor handle.
- *      ul_size	  :   Size of the address space to reserve.
- *      pp_rsv_addr       :   Ptr to DSP side reserved u8 address.
- *  Returns:
- *      0	 :   Success.
- *      -EFAULT     :   Invalid processor handle.
- *      -EPERM       :   General failure.
- *      -ENOMEM     :   Cannot reserve chunk of this size.
- *  Requires:
- *      pp_rsv_addr is not NULL
- *      PROC Initialized.
- *  Ensures:
- *  Details:
- */
-extern int proc_reserve_memory(void *hprocessor,
-				      u32 ul_size, void **pp_rsv_addr,
-				      struct process_context *pr_ctxt);
-
-/*
  *  ======== proc_un_map ========
  *  Purpose:
  *      Removes a MPU buffer mapping from the DSP address space.
@@ -595,27 +572,4 @@ extern int proc_reserve_memory(void *hprocessor,
 extern int proc_un_map(void *hprocessor, void *map_addr,
 			      struct process_context *pr_ctxt);
 
-/*
- *  ======== proc_un_reserve_memory ========
- *  Purpose:
- *      Frees a previously reserved region of DSP address space.
- *  Parameters:
- *      hprocessor      :   The processor handle.
- *      prsv_addr	:   Ptr to DSP side reservedBYTE address.
- *  Returns:
- *      0	 :   Success.
- *      -EFAULT     :   Invalid processor handle.
- *      -EPERM       :   General failure.
- *      -ENOENT   :   Cannot find a reserved region starting with this
- *		      :   address.
- *  Requires:
- *      prsv_addr is not NULL
- *      PROC Initialized.
- *  Ensures:
- *  Details:
- */
-extern int proc_un_reserve_memory(void *hprocessor,
-					 void *prsv_addr,
-					 struct process_context *pr_ctxt);
-
 #endif /* PROC_ */
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index 522810b..d8f4079 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -31,7 +31,6 @@
 #include <dspbridge/cod.h>
 #include <dspbridge/drv.h>
 #include <dspbridge/proc.h>
-#include <dspbridge/dmm.h>
 
 /*  ----------------------------------- Resource Manager */
 #include <dspbridge/mgr.h>
@@ -71,7 +70,6 @@ struct dev_object {
 	struct msg_mgr *msg_mgr;	/* Message manager. */
 	struct io_mgr *iomgr;	/* IO manager (CHNL, msg_ctrl) */
 	struct cmm_object *cmm_mgr;	/* SM memory manager. */
-	struct dmm_object *dmm_mgr;	/* Dynamic memory manager. */
 	u32 word_size;		/* DSP word size: quick access. */
 	struct drv_object *drv_obj;	/* Driver Object */
 	/* List of Processors attached to this device */
@@ -243,9 +241,6 @@ int dev_create_device(struct dev_object **device_obj,
 			/* Instantiate the DEH module */
 			status = bridge_deh_create(&dev_obj->deh_mgr, dev_obj);
 		}
-		/* Create DMM mgr . */
-		status = dmm_create(&dev_obj->dmm_mgr,
-				    (struct dev_object *)dev_obj, NULL);
 	}
 	/* Add the new DEV_Object to the global list: */
 	if (!status)
@@ -263,8 +258,6 @@ leave:
 		if (dev_obj) {
 			if (dev_obj->cod_mgr)
 				cod_delete(dev_obj->cod_mgr);
-			if (dev_obj->dmm_mgr)
-				dmm_destroy(dev_obj->dmm_mgr);
 			kfree(dev_obj);
 		}
 
@@ -374,11 +367,6 @@ int dev_destroy_device(struct dev_object *hdev_obj)
 			dev_obj->cmm_mgr = NULL;
 		}
 
-		if (dev_obj->dmm_mgr) {
-			dmm_destroy(dev_obj->dmm_mgr);
-			dev_obj->dmm_mgr = NULL;
-		}
-
 		/* Call the driver's bridge_dev_destroy() function: */
 		/* Require of DevDestroy */
 		if (dev_obj->bridge_context) {
@@ -456,32 +444,6 @@ int dev_get_cmm_mgr(struct dev_object *hdev_obj,
 }
 
 /*
- *  ======== dev_get_dmm_mgr ========
- *  Purpose:
- *      Retrieve the handle to the dynamic memory manager created for this
- *      device.
- */
-int dev_get_dmm_mgr(struct dev_object *hdev_obj,
-			   struct dmm_object **mgr)
-{
-	int status = 0;
-	struct dev_object *dev_obj = hdev_obj;
-
-	DBC_REQUIRE(refs > 0);
-	DBC_REQUIRE(mgr != NULL);
-
-	if (hdev_obj) {
-		*mgr = dev_obj->dmm_mgr;
-	} else {
-		*mgr = NULL;
-		status = -EFAULT;
-	}
-
-	DBC_ENSURE(!status || (mgr != NULL && *mgr == NULL));
-	return status;
-}
-
-/*
  *  ======== dev_get_cod_mgr ========
  *  Purpose:
  *      Retrieve the COD manager create for this device.
@@ -733,10 +695,8 @@ void dev_exit(void)
 
 	refs--;
 
-	if (refs == 0) {
+	if (refs == 0)
 		cmm_exit();
-		dmm_exit();
-	}
 
 	DBC_ENSURE(refs >= 0);
 }
@@ -748,25 +708,12 @@ void dev_exit(void)
  */
 bool dev_init(void)
 {
-	bool cmm_ret, dmm_ret, ret = true;
+	bool ret = true;
 
 	DBC_REQUIRE(refs >= 0);
 
-	if (refs == 0) {
-		cmm_ret = cmm_init();
-		dmm_ret = dmm_init();
-
-		ret = cmm_ret && dmm_ret;
-
-		if (!ret) {
-			if (cmm_ret)
-				cmm_exit();
-
-			if (dmm_ret)
-				dmm_exit();
-
-		}
-	}
+	if (refs == 0)
+		ret = cmm_init();
 
 	if (ret)
 		refs++;
diff --git a/drivers/staging/tidspbridge/pmgr/dmm.c b/drivers/staging/tidspbridge/pmgr/dmm.c
deleted file mode 100644
index 8685233..0000000
--- a/drivers/staging/tidspbridge/pmgr/dmm.c
+++ /dev/null
@@ -1,533 +0,0 @@
-/*
- * dmm.c
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * The Dynamic Memory Manager (DMM) module manages the DSP Virtual address
- * space that can be directly mapped to any MPU buffer or memory region
- *
- * Notes:
- *   Region: Generic memory entitiy having a start address and a size
- *   Chunk:  Reserved region
- *
- * Copyright (C) 2005-2006 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-#include <linux/types.h>
-
-/*  ----------------------------------- Host OS */
-#include <dspbridge/host_os.h>
-
-/*  ----------------------------------- DSP/BIOS Bridge */
-#include <dspbridge/dbdefs.h>
-
-/*  ----------------------------------- Trace & Debug */
-#include <dspbridge/dbc.h>
-
-/*  ----------------------------------- OS Adaptation Layer */
-#include <dspbridge/sync.h>
-
-/*  ----------------------------------- Platform Manager */
-#include <dspbridge/dev.h>
-#include <dspbridge/proc.h>
-
-/*  ----------------------------------- This */
-#include <dspbridge/dmm.h>
-
-/*  ----------------------------------- Defines, Data Structures, Typedefs */
-#define DMM_ADDR_VIRTUAL(a) \
-	(((struct map_page *)(a) - virtual_mapping_table) * PG_SIZE4K +\
-	dyn_mem_map_beg)
-#define DMM_ADDR_TO_INDEX(a) (((a) - dyn_mem_map_beg) / PG_SIZE4K)
-
-/* DMM Mgr */
-struct dmm_object {
-	/* Dmm Lock is used to serialize access mem manager for
-	 * multi-threads. */
-	spinlock_t dmm_lock;	/* Lock to access dmm mgr */
-};
-
-/*  ----------------------------------- Globals */
-static u32 refs;		/* module reference count */
-struct map_page {
-	u32 region_size:15;
-	u32 mapped_size:15;
-	u32 reserved:1;
-	u32 mapped:1;
-};
-
-/*  Create the free list */
-static struct map_page *virtual_mapping_table;
-static u32 free_region;		/* The index of free region */
-static u32 free_size;
-static u32 dyn_mem_map_beg;	/* The Beginning of dynamic memory mapping */
-static u32 table_size;		/* The size of virt and phys pages tables */
-
-/*  ----------------------------------- Function Prototypes */
-static struct map_page *get_region(u32 addr);
-static struct map_page *get_free_region(u32 len);
-static struct map_page *get_mapped_region(u32 addrs);
-
-/*  ======== dmm_create_tables ========
- *  Purpose:
- *      Create table to hold the information of physical address
- *      the buffer pages that is passed by the user, and the table
- *      to hold the information of the virtual memory that is reserved
- *      for DSP.
- */
-int dmm_create_tables(struct dmm_object *dmm_mgr, u32 addr, u32 size)
-{
-	struct dmm_object *dmm_obj = (struct dmm_object *)dmm_mgr;
-	int status = 0;
-
-	status = dmm_delete_tables(dmm_obj);
-	if (!status) {
-		dyn_mem_map_beg = addr;
-		table_size = PG_ALIGN_HIGH(size, PG_SIZE4K) / PG_SIZE4K;
-		/*  Create the free list */
-		virtual_mapping_table = __vmalloc(table_size *
-				sizeof(struct map_page), GFP_KERNEL |
-				__GFP_HIGHMEM | __GFP_ZERO, PAGE_KERNEL);
-		if (virtual_mapping_table == NULL)
-			status = -ENOMEM;
-		else {
-			/* On successful allocation,
-			 * all entries are zero ('free') */
-			free_region = 0;
-			free_size = table_size * PG_SIZE4K;
-			virtual_mapping_table[0].region_size = table_size;
-		}
-	}
-
-	if (status)
-		pr_err("%s: failure, status 0x%x\n", __func__, status);
-
-	return status;
-}
-
-/*
- *  ======== dmm_create ========
- *  Purpose:
- *      Create a dynamic memory manager object.
- */
-int dmm_create(struct dmm_object **dmm_manager,
-		      struct dev_object *hdev_obj,
-		      const struct dmm_mgrattrs *mgr_attrts)
-{
-	struct dmm_object *dmm_obj = NULL;
-	int status = 0;
-	DBC_REQUIRE(refs > 0);
-	DBC_REQUIRE(dmm_manager != NULL);
-
-	*dmm_manager = NULL;
-	/* create, zero, and tag a cmm mgr object */
-	dmm_obj = kzalloc(sizeof(struct dmm_object), GFP_KERNEL);
-	if (dmm_obj != NULL) {
-		spin_lock_init(&dmm_obj->dmm_lock);
-		*dmm_manager = dmm_obj;
-	} else {
-		status = -ENOMEM;
-	}
-
-	return status;
-}
-
-/*
- *  ======== dmm_destroy ========
- *  Purpose:
- *      Release the communication memory manager resources.
- */
-int dmm_destroy(struct dmm_object *dmm_mgr)
-{
-	struct dmm_object *dmm_obj = (struct dmm_object *)dmm_mgr;
-	int status = 0;
-
-	DBC_REQUIRE(refs > 0);
-	if (dmm_mgr) {
-		status = dmm_delete_tables(dmm_obj);
-		if (!status)
-			kfree(dmm_obj);
-	} else
-		status = -EFAULT;
-
-	return status;
-}
-
-/*
- *  ======== dmm_delete_tables ========
- *  Purpose:
- *      Delete DMM Tables.
- */
-int dmm_delete_tables(struct dmm_object *dmm_mgr)
-{
-	int status = 0;
-
-	DBC_REQUIRE(refs > 0);
-	/* Delete all DMM tables */
-	if (dmm_mgr)
-		vfree(virtual_mapping_table);
-	else
-		status = -EFAULT;
-	return status;
-}
-
-/*
- *  ======== dmm_exit ========
- *  Purpose:
- *      Discontinue usage of module; free resources when reference count
- *      reaches 0.
- */
-void dmm_exit(void)
-{
-	DBC_REQUIRE(refs > 0);
-
-	refs--;
-}
-
-/*
- *  ======== dmm_get_handle ========
- *  Purpose:
- *      Return the dynamic memory manager object for this device.
- *      This is typically called from the client process.
- */
-int dmm_get_handle(void *hprocessor, struct dmm_object **dmm_manager)
-{
-	int status = 0;
-	struct dev_object *hdev_obj;
-
-	DBC_REQUIRE(refs > 0);
-	DBC_REQUIRE(dmm_manager != NULL);
-	if (hprocessor != NULL)
-		status = proc_get_dev_object(hprocessor, &hdev_obj);
-	else
-		hdev_obj = dev_get_first();	/* default */
-
-	if (!status)
-		status = dev_get_dmm_mgr(hdev_obj, dmm_manager);
-
-	return status;
-}
-
-/*
- *  ======== dmm_init ========
- *  Purpose:
- *      Initializes private state of DMM module.
- */
-bool dmm_init(void)
-{
-	bool ret = true;
-
-	DBC_REQUIRE(refs >= 0);
-
-	if (ret)
-		refs++;
-
-	DBC_ENSURE((ret && (refs > 0)) || (!ret && (refs >= 0)));
-
-	virtual_mapping_table = NULL;
-	table_size = 0;
-
-	return ret;
-}
-
-/*
- *  ======== dmm_map_memory ========
- *  Purpose:
- *      Add a mapping block to the reserved chunk. DMM assumes that this block
- *  will be mapped in the DSP/IVA's address space. DMM returns an error if a
- *  mapping overlaps another one. This function stores the info that will be
- *  required later while unmapping the block.
- */
-int dmm_map_memory(struct dmm_object *dmm_mgr, u32 addr, u32 size)
-{
-	struct dmm_object *dmm_obj = (struct dmm_object *)dmm_mgr;
-	struct map_page *chunk;
-	int status = 0;
-
-	spin_lock(&dmm_obj->dmm_lock);
-	/* Find the Reserved memory chunk containing the DSP block to
-	 * be mapped */
-	chunk = (struct map_page *)get_region(addr);
-	if (chunk != NULL) {
-		/* Mark the region 'mapped', leave the 'reserved' info as-is */
-		chunk->mapped = true;
-		chunk->mapped_size = (size / PG_SIZE4K);
-	} else
-		status = -ENOENT;
-	spin_unlock(&dmm_obj->dmm_lock);
-
-	dev_dbg(bridge, "%s dmm_mgr %p, addr %x, size %x\n\tstatus %x, "
-		"chunk %p", __func__, dmm_mgr, addr, size, status, chunk);
-
-	return status;
-}
-
-/*
- *  ======== dmm_reserve_memory ========
- *  Purpose:
- *      Reserve a chunk of virtually contiguous DSP/IVA address space.
- */
-int dmm_reserve_memory(struct dmm_object *dmm_mgr, u32 size,
-			      u32 *prsv_addr)
-{
-	int status = 0;
-	struct dmm_object *dmm_obj = (struct dmm_object *)dmm_mgr;
-	struct map_page *node;
-	u32 rsv_addr = 0;
-	u32 rsv_size = 0;
-
-	spin_lock(&dmm_obj->dmm_lock);
-
-	/* Try to get a DSP chunk from the free list */
-	node = get_free_region(size);
-	if (node != NULL) {
-		/*  DSP chunk of given size is available. */
-		rsv_addr = DMM_ADDR_VIRTUAL(node);
-		/* Calculate the number entries to use */
-		rsv_size = size / PG_SIZE4K;
-		if (rsv_size < node->region_size) {
-			/* Mark remainder of free region */
-			node[rsv_size].mapped = false;
-			node[rsv_size].reserved = false;
-			node[rsv_size].region_size =
-			    node->region_size - rsv_size;
-			node[rsv_size].mapped_size = 0;
-		}
-		/*  get_region will return first fit chunk. But we only use what
-		   is requested. */
-		node->mapped = false;
-		node->reserved = true;
-		node->region_size = rsv_size;
-		node->mapped_size = 0;
-		/* Return the chunk's starting address */
-		*prsv_addr = rsv_addr;
-	} else
-		/*dSP chunk of given size is not available */
-		status = -ENOMEM;
-
-	spin_unlock(&dmm_obj->dmm_lock);
-
-	dev_dbg(bridge, "%s dmm_mgr %p, size %x, prsv_addr %p\n\tstatus %x, "
-		"rsv_addr %x, rsv_size %x\n", __func__, dmm_mgr, size,
-		prsv_addr, status, rsv_addr, rsv_size);
-
-	return status;
-}
-
-/*
- *  ======== dmm_un_map_memory ========
- *  Purpose:
- *      Remove the mapped block from the reserved chunk.
- */
-int dmm_un_map_memory(struct dmm_object *dmm_mgr, u32 addr, u32 *psize)
-{
-	struct dmm_object *dmm_obj = (struct dmm_object *)dmm_mgr;
-	struct map_page *chunk;
-	int status = 0;
-
-	spin_lock(&dmm_obj->dmm_lock);
-	chunk = get_mapped_region(addr);
-	if (chunk == NULL)
-		status = -ENOENT;
-
-	if (!status) {
-		/* Unmap the region */
-		*psize = chunk->mapped_size * PG_SIZE4K;
-		chunk->mapped = false;
-		chunk->mapped_size = 0;
-	}
-	spin_unlock(&dmm_obj->dmm_lock);
-
-	dev_dbg(bridge, "%s: dmm_mgr %p, addr %x, psize %p\n\tstatus %x, "
-		"chunk %p\n", __func__, dmm_mgr, addr, psize, status, chunk);
-
-	return status;
-}
-
-/*
- *  ======== dmm_un_reserve_memory ========
- *  Purpose:
- *      Free a chunk of reserved DSP/IVA address space.
- */
-int dmm_un_reserve_memory(struct dmm_object *dmm_mgr, u32 rsv_addr)
-{
-	struct dmm_object *dmm_obj = (struct dmm_object *)dmm_mgr;
-	struct map_page *chunk;
-	u32 i;
-	int status = 0;
-	u32 chunk_size;
-
-	spin_lock(&dmm_obj->dmm_lock);
-
-	/* Find the chunk containing the reserved address */
-	chunk = get_mapped_region(rsv_addr);
-	if (chunk == NULL)
-		status = -ENOENT;
-
-	if (!status) {
-		/* Free all the mapped pages for this reserved region */
-		i = 0;
-		while (i < chunk->region_size) {
-			if (chunk[i].mapped) {
-				/* Remove mapping from the page tables. */
-				chunk_size = chunk[i].mapped_size;
-				/* Clear the mapping flags */
-				chunk[i].mapped = false;
-				chunk[i].mapped_size = 0;
-				i += chunk_size;
-			} else
-				i++;
-		}
-		/* Clear the flags (mark the region 'free') */
-		chunk->reserved = false;
-		/* NOTE: We do NOT coalesce free regions here.
-		 * Free regions are coalesced in get_region(), as it traverses
-		 *the whole mapping table
-		 */
-	}
-	spin_unlock(&dmm_obj->dmm_lock);
-
-	dev_dbg(bridge, "%s: dmm_mgr %p, rsv_addr %x\n\tstatus %x chunk %p",
-		__func__, dmm_mgr, rsv_addr, status, chunk);
-
-	return status;
-}
-
-/*
- *  ======== get_region ========
- *  Purpose:
- *      Returns a region containing the specified memory region
- */
-static struct map_page *get_region(u32 addr)
-{
-	struct map_page *curr_region = NULL;
-	u32 i = 0;
-
-	if (virtual_mapping_table != NULL) {
-		/* find page mapped by this address */
-		i = DMM_ADDR_TO_INDEX(addr);
-		if (i < table_size)
-			curr_region = virtual_mapping_table + i;
-	}
-
-	dev_dbg(bridge, "%s: curr_region %p, free_region %d, free_size %d\n",
-		__func__, curr_region, free_region, free_size);
-	return curr_region;
-}
-
-/*
- *  ======== get_free_region ========
- *  Purpose:
- *  Returns the requested free region
- */
-static struct map_page *get_free_region(u32 len)
-{
-	struct map_page *curr_region = NULL;
-	u32 i = 0;
-	u32 region_size = 0;
-	u32 next_i = 0;
-
-	if (virtual_mapping_table == NULL)
-		return curr_region;
-	if (len > free_size) {
-		/* Find the largest free region
-		 * (coalesce during the traversal) */
-		while (i < table_size) {
-			region_size = virtual_mapping_table[i].region_size;
-			next_i = i + region_size;
-			if (virtual_mapping_table[i].reserved == false) {
-				/* Coalesce, if possible */
-				if (next_i < table_size &&
-				    virtual_mapping_table[next_i].reserved
-				    == false) {
-					virtual_mapping_table[i].region_size +=
-					    virtual_mapping_table
-					    [next_i].region_size;
-					continue;
-				}
-				region_size *= PG_SIZE4K;
-				if (region_size > free_size) {
-					free_region = i;
-					free_size = region_size;
-				}
-			}
-			i = next_i;
-		}
-	}
-	if (len <= free_size) {
-		curr_region = virtual_mapping_table + free_region;
-		free_region += (len / PG_SIZE4K);
-		free_size -= len;
-	}
-	return curr_region;
-}
-
-/*
- *  ======== get_mapped_region ========
- *  Purpose:
- *  Returns the requestedmapped region
- */
-static struct map_page *get_mapped_region(u32 addrs)
-{
-	u32 i = 0;
-	struct map_page *curr_region = NULL;
-
-	if (virtual_mapping_table == NULL)
-		return curr_region;
-
-	i = DMM_ADDR_TO_INDEX(addrs);
-	if (i < table_size && (virtual_mapping_table[i].mapped ||
-			       virtual_mapping_table[i].reserved))
-		curr_region = virtual_mapping_table + i;
-	return curr_region;
-}
-
-#ifdef DSP_DMM_DEBUG
-u32 dmm_mem_map_dump(struct dmm_object *dmm_mgr)
-{
-	struct map_page *curr_node = NULL;
-	u32 i;
-	u32 freemem = 0;
-	u32 bigsize = 0;
-
-	spin_lock(&dmm_mgr->dmm_lock);
-
-	if (virtual_mapping_table != NULL) {
-		for (i = 0; i < table_size; i +=
-		     virtual_mapping_table[i].region_size) {
-			curr_node = virtual_mapping_table + i;
-			if (curr_node->reserved) {
-				/*printk("RESERVED size = 0x%x, "
-				   "Map size = 0x%x\n",
-				   (curr_node->region_size * PG_SIZE4K),
-				   (curr_node->mapped == false) ? 0 :
-				   (curr_node->mapped_size * PG_SIZE4K));
-				 */
-			} else {
-/*				printk("UNRESERVED size = 0x%x\n",
-					(curr_node->region_size * PG_SIZE4K));
- */
-				freemem += (curr_node->region_size * PG_SIZE4K);
-				if (curr_node->region_size > bigsize)
-					bigsize = curr_node->region_size;
-			}
-		}
-	}
-	spin_unlock(&dmm_mgr->dmm_lock);
-	printk(KERN_INFO "Total DSP VA FREE memory = %d Mbytes\n",
-	       freemem / (1024 * 1024));
-	printk(KERN_INFO "Total DSP VA USED memory= %d Mbytes \n",
-	       (((table_size * PG_SIZE4K) - freemem)) / (1024 * 1024));
-	printk(KERN_INFO "DSP VA - Biggest FREE block = %d Mbytes \n\n",
-	       (bigsize * PG_SIZE4K / (1024 * 1024)));
-
-	return 0;
-}
-#endif
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 767ffe2..377c41f 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -993,27 +993,11 @@ u32 procwrap_register_notify(union trapped_args *args, void *pr_ctxt)
 /*
  * ======== procwrap_reserve_memory ========
  */
-u32 procwrap_reserve_memory(union trapped_args *args, void *pr_ctxt)
+u32 __deprecated procwrap_reserve_memory(union trapped_args *args,
+						void *pr_ctxt)
 {
-	int status;
-	void *prsv_addr;
-	void *hprocessor = ((struct process_context *)pr_ctxt)->processor;
-
-	if ((args->args_proc_rsvmem.size <= 0) ||
-	    (args->args_proc_rsvmem.size & (PG_SIZE4K - 1)) != 0)
-		return -EINVAL;
-
-	status = proc_reserve_memory(hprocessor,
-				     args->args_proc_rsvmem.size, &prsv_addr,
-				     pr_ctxt);
-	if (!status) {
-		if (put_user(prsv_addr, args->args_proc_rsvmem.rsv_addr)) {
-			status = -EINVAL;
-			proc_un_reserve_memory(args->args_proc_rsvmem.
-					       processor, prsv_addr, pr_ctxt);
-		}
-	}
-	return status;
+	dev_dbg(bridge, "%s: deprecated dspbridge ioctl\n", __func__);
+	return 0;
 }
 
 /*
@@ -1042,15 +1026,11 @@ u32 procwrap_un_map(union trapped_args *args, void *pr_ctxt)
 /*
  * ======== procwrap_un_reserve_memory ========
  */
-u32 procwrap_un_reserve_memory(union trapped_args *args, void *pr_ctxt)
+u32 __deprecated procwrap_un_reserve_memory(union trapped_args *args,
+						void *pr_ctxt)
 {
-	int status;
-	void *hprocessor = ((struct process_context *)pr_ctxt)->processor;
-
-	status = proc_un_reserve_memory(hprocessor,
-					args->args_proc_unrsvmem.rsv_addr,
-					pr_ctxt);
-	return status;
+	dev_dbg(bridge, "%s: deprecated dspbridge ioctl\n", __func__);
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index a7c93cf..3d031ba 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -144,7 +144,6 @@ int drv_remove_all_dmm_res_elements(void *process_ctxt)
 	struct process_context *ctxt = (struct process_context *)process_ctxt;
 	int status = 0;
 	struct dmm_map_object *temp_map, *map_obj;
-	struct dmm_rsv_object *temp_rsv, *rsv_obj;
 
 	/* Free DMM mapped memory resources */
 	list_for_each_entry_safe(map_obj, temp_map, &ctxt->dmm_map_list, link) {
@@ -155,15 +154,6 @@ int drv_remove_all_dmm_res_elements(void *process_ctxt)
 			       " status = 0x%xn", __func__, status);
 	}
 
-	/* Free DMM reserved memory resources */
-	list_for_each_entry_safe(rsv_obj, temp_rsv, &ctxt->dmm_rsv_list, link) {
-		status = proc_un_reserve_memory(ctxt->processor, (void *)
-						rsv_obj->dsp_reserved_addr,
-						ctxt);
-		if (status)
-			pr_err("%s: proc_un_reserve_memory failed!"
-			       " status = 0x%xn", __func__, status);
-	}
 	return status;
 }
 
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index c43c7e3..1fb5369 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -508,8 +508,6 @@ static int bridge_open(struct inode *ip, struct file *filp)
 		pr_ctxt->res_state = PROC_RES_ALLOCATED;
 		spin_lock_init(&pr_ctxt->dmm_map_lock);
 		INIT_LIST_HEAD(&pr_ctxt->dmm_map_list);
-		spin_lock_init(&pr_ctxt->dmm_rsv_lock);
-		INIT_LIST_HEAD(&pr_ctxt->dmm_rsv_list);
 
 		pr_ctxt->node_id = kzalloc(sizeof(struct idr), GFP_KERNEL);
 		if (pr_ctxt->node_id) {
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 5dadaa4..a6958fe 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -57,7 +57,6 @@
 /*  ----------------------------------- This */
 #include <dspbridge/nodepriv.h>
 #include <dspbridge/node.h>
-#include <dspbridge/dmm.h>
 
 /* Static/Dynamic Loader includes */
 #include <dspbridge/dbll.h>
@@ -319,11 +318,6 @@ int node_allocate(struct proc_object *hprocessor,
 	u32 mapped_addr = 0;
 	u32 map_attrs = 0x0;
 	struct dsp_processorstate proc_state;
-#ifdef DSP_DMM_DEBUG
-	struct dmm_object *dmm_mgr;
-	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
-#endif
-
 	void *node_res;
 
 	DBC_REQUIRE(refs > 0);
@@ -432,35 +426,12 @@ int node_allocate(struct proc_object *hprocessor,
 	if (status)
 		goto func_cont;
 
-	status = proc_reserve_memory(hprocessor,
-				     pnode->create_args.asa.task_arg_obj.
-				     heap_size + PAGE_SIZE,
-				     (void **)&(pnode->create_args.asa.
-					task_arg_obj.dsp_heap_res_addr),
-				     pr_ctxt);
-	if (status) {
-		pr_err("%s: Failed to reserve memory for heap: 0x%x\n",
-		       __func__, status);
-		goto func_cont;
-	}
-#ifdef DSP_DMM_DEBUG
-	status = dmm_get_handle(p_proc_object, &dmm_mgr);
-	if (!dmm_mgr) {
-		status = DSP_EHANDLE;
-		goto func_cont;
-	}
-
-	dmm_mem_map_dump(dmm_mgr);
-#endif
-
 	map_attrs |= DSP_MAPLITTLEENDIAN;
 	map_attrs |= DSP_MAPELEMSIZE32;
 	map_attrs |= DSP_MAPVIRTUALADDR;
 	status = proc_map(hprocessor, (void *)attr_in->pgpp_virt_addr,
 			  pnode->create_args.asa.task_arg_obj.heap_size,
-			  (void *)pnode->create_args.asa.task_arg_obj.
-			  dsp_heap_res_addr, (void **)&mapped_addr, map_attrs,
-			  pr_ctxt);
+			  NULL, (void **)&mapped_addr, map_attrs, pr_ctxt);
 	if (status)
 		pr_err("%s: Failed to map memory for Heap: 0x%x\n",
 		       __func__, status);
@@ -2457,12 +2428,8 @@ static void delete_node(struct node_object *hnode,
 	struct stream_chnl stream;
 	struct node_msgargs node_msg_args;
 	struct node_taskargs task_arg_obj;
-#ifdef DSP_DMM_DEBUG
-	struct dmm_object *dmm_mgr;
-	struct proc_object *p_proc_object =
-	    (struct proc_object *)hnode->processor;
-#endif
 	int status;
+
 	if (!hnode)
 		goto func_end;
 	hnode_mgr = hnode->node_mgr;
@@ -2518,24 +2485,10 @@ static void delete_node(struct node_object *hnode,
 			kfree(task_arg_obj.strm_out_def);
 			task_arg_obj.strm_out_def = NULL;
 		}
-		if (task_arg_obj.dsp_heap_res_addr) {
-			status = proc_un_map(hnode->processor, (void *)
-					     task_arg_obj.dsp_heap_addr,
+		if (task_arg_obj.dsp_heap_addr)
+			status = proc_un_map(hnode->processor,
+					     (void *)task_arg_obj.dsp_heap_addr,
 					     pr_ctxt);
-
-			status = proc_un_reserve_memory(hnode->processor,
-							(void *)
-							task_arg_obj.
-							dsp_heap_res_addr,
-							pr_ctxt);
-#ifdef DSP_DMM_DEBUG
-			status = dmm_get_handle(p_proc_object, &dmm_mgr);
-			if (dmm_mgr)
-				dmm_mem_map_dump(dmm_mgr);
-			else
-				status = DSP_EHANDLE;
-#endif
-		}
 	}
 	if (node_type != NODE_MESSAGE) {
 		kfree(hnode->stream_connect);
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index ce57279..c53e60c 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -38,7 +38,6 @@
 #include <dspbridge/cod.h>
 #include <dspbridge/dev.h>
 #include <dspbridge/procpriv.h>
-#include <dspbridge/dmm.h>
 
 /*  ----------------------------------- Resource Manager */
 #include <dspbridge/mgr.h>
@@ -1126,9 +1125,6 @@ int proc_load(void *hprocessor, const s32 argc_index,
 	s32 cnew_envp;		/* "  " in new_envp[] */
 	s32 nproc_id = 0;	/* Anticipate MP version. */
 	struct dcd_manager *hdcd_handle;
-	struct dmm_object *dmm_mgr;
-	u32 dw_ext_end;
-	u32 proc_id;
 	int brd_state;
 	struct drv_data *drv_datap = dev_get_drvdata(bridge);
 
@@ -1309,35 +1305,6 @@ int proc_load(void *hprocessor, const s32 argc_index,
 						    DSP_PROCESSORSTATECHANGE);
 		}
 	}
-	if (!status) {
-		status = proc_get_processor_id(hprocessor, &proc_id);
-		if (proc_id == DSP_UNIT) {
-			/* Use all available DSP address space after EXTMEM
-			 * for DMM */
-			if (!status)
-				status = cod_get_sym_value(cod_mgr, EXTEND,
-							   &dw_ext_end);
-
-			/* Reset DMM structs and add an initial free chunk */
-			if (!status) {
-				status =
-				    dev_get_dmm_mgr(p_proc_object->dev_obj,
-						    &dmm_mgr);
-				if (dmm_mgr) {
-					/* Set dw_ext_end to DMM START u8
-					 * address */
-					dw_ext_end =
-					    (dw_ext_end + 1) * DSPWORDSIZE;
-					/* DMM memory is from EXT_END */
-					status = dmm_create_tables(dmm_mgr,
-								   dw_ext_end,
-								   DMMPOOLSIZE);
-				} else {
-					status = -EFAULT;
-				}
-			}
-		}
-	}
 	/* Restore the original argv[0] */
 	kfree(new_envp);
 	user_args[0] = pargv0;
@@ -1388,7 +1355,6 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 {
 	u32 va_align;
 	u32 pa_align;
-	struct dmm_object *dmm_mgr;
 	u32 size_align;
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
@@ -1417,9 +1383,6 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 	}
 	/* Critical section */
 	mutex_lock(&proc_lock);
-	dmm_get_handle(p_proc_object, &dmm_mgr);
-	if (!dmm_mgr)
-		status = -EFAULT;
 
 	/* Add mapping to the page tables. */
 	if (!status) {
@@ -1535,30 +1498,6 @@ func_end:
 }
 
 /*
- *  ======== proc_reserve_memory ========
- *  Purpose:
- *      Reserve a virtually contiguous region of DSP address space.
- */
-int proc_reserve_memory(void *hprocessor, u32 ul_size,
-			       void **pp_rsv_addr,
-			       struct process_context *pr_ctxt)
-{
-	int status = 0;
-	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
-
-	if (!p_proc_object) {
-		status = -EFAULT;
-		goto func_end;
-	}
-
-func_end:
-	dev_dbg(bridge, "%s: hprocessor: 0x%p ul_size: 0x%x pp_rsv_addr: 0x%p "
-		"status 0x%x\n", __func__, hprocessor,
-		ul_size, pp_rsv_addr, status);
-	return status;
-}
-
-/*
  *  ======== proc_start ========
  *  Purpose:
  *      Start a processor running.
@@ -1706,7 +1645,6 @@ int proc_un_map(void *hprocessor, void *map_addr,
 {
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
-	struct dmm_object *dmm_mgr;
 	struct dmm_map_object *dmo;
 	u32 va_align;
 
@@ -1716,12 +1654,6 @@ int proc_un_map(void *hprocessor, void *map_addr,
 		goto func_end;
 	}
 
-	status = dmm_get_handle(hprocessor, &dmm_mgr);
-	if (!dmm_mgr) {
-		status = -EFAULT;
-		goto func_end;
-	}
-
 	/* Critical section */
 	mutex_lock(&proc_lock);
 
@@ -1753,28 +1685,6 @@ func_end:
 }
 
 /*
- *  ======== proc_un_reserve_memory ========
- *  Purpose:
- *      Frees a previously reserved region of DSP address space.
- */
-int proc_un_reserve_memory(void *hprocessor, void *prsv_addr,
-				  struct process_context *pr_ctxt)
-{
-	int status = 0;
-	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
-
-	if (!p_proc_object) {
-		status = -EFAULT;
-		goto func_end;
-	}
-
-func_end:
-	dev_dbg(bridge, "%s: hprocessor: 0x%p prsv_addr: 0x%p status: 0x%x\n",
-		__func__, hprocessor, prsv_addr, status);
-	return status;
-}
-
-/*
  *  ======== = proc_monitor ======== ==
  *  Purpose:
  *      Place the Processor in Monitor State. This is an internal
-- 
1.7.1

