Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab0JEU3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:29:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44984 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab0JEU3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:29:24 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>, <nm@ti.com>,
        <Hiroshi.DOYU@nokia.com>, <ohad@wizery.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv3 10/11] staging: tidspbridge - deprecate reserve/unreserve_memory funtions
Date: Tue,  5 Oct 2010 15:35:43 -0500
Message-Id: <1286310944-25035-11-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286310944-25035-10-git-send-email-x0095840@ti.com>
References: <1286310944-25035-1-git-send-email-x0095840@ti.com>
 <1286310944-25035-2-git-send-email-x0095840@ti.com>
 <1286310944-25035-3-git-send-email-x0095840@ti.com>
 <1286310944-25035-4-git-send-email-x0095840@ti.com>
 <1286310944-25035-5-git-send-email-x0095840@ti.com>
 <1286310944-25035-6-git-send-email-x0095840@ti.com>
 <1286310944-25035-7-git-send-email-x0095840@ti.com>
 <1286310944-25035-8-git-send-email-x0095840@ti.com>
 <1286310944-25035-9-git-send-email-x0095840@ti.com>
 <1286310944-25035-10-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now what iommu memory usage is kept track by iommu module
the functions reserve/unreserve_memory are not needed anymore.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 .../staging/tidspbridge/include/dspbridge/proc.h   |   46 --------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   34 +-----
 drivers/staging/tidspbridge/rmgr/node.c            |   20 +----
 drivers/staging/tidspbridge/rmgr/proc.c            |  114 ++------------------
 4 files changed, 17 insertions(+), 197 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/proc.h b/drivers/staging/tidspbridge/include/dspbridge/proc.h
index 5e09fd1..2d12aab 100644
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
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index faf8304..0187c47 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -989,27 +989,10 @@ u32 procwrap_register_notify(union trapped_args *args, void *pr_ctxt)
 /*
  * ======== procwrap_reserve_memory ========
  */
-u32 procwrap_reserve_memory(union trapped_args *args, void *pr_ctxt)
+u32 __deprecated procwrap_reserve_memory(union trapped_args *args,
+							void *pr_ctxt)
 {
-	int status;
-	void *prsv_addr;
-	void *hprocessor = ((struct process_context *)pr_ctxt)->hprocessor;
-
-	if ((args->args_proc_rsvmem.ul_size <= 0) ||
-	    (args->args_proc_rsvmem.ul_size & (PG_SIZE4K - 1)) != 0)
-		return -EINVAL;
-
-	status = proc_reserve_memory(hprocessor,
-				     args->args_proc_rsvmem.ul_size, &prsv_addr,
-				     pr_ctxt);
-	if (!status) {
-		if (put_user(prsv_addr, args->args_proc_rsvmem.pp_rsv_addr)) {
-			status = -EINVAL;
-			proc_un_reserve_memory(args->args_proc_rsvmem.
-					       hprocessor, prsv_addr, pr_ctxt);
-		}
-	}
-	return status;
+	return 0;
 }
 
 /*
@@ -1038,15 +1021,10 @@ u32 procwrap_un_map(union trapped_args *args, void *pr_ctxt)
 /*
  * ======== procwrap_un_reserve_memory ========
  */
-u32 procwrap_un_reserve_memory(union trapped_args *args, void *pr_ctxt)
+u32 __deprecated procwrap_un_reserve_memory(union trapped_args *args,
+							void *pr_ctxt)
 {
-	int status;
-	void *hprocessor = ((struct process_context *)pr_ctxt)->hprocessor;
-
-	status = proc_un_reserve_memory(hprocessor,
-					args->args_proc_unrsvmem.prsv_addr,
-					pr_ctxt);
-	return status;
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 1562f3c..ccb1811 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -430,17 +430,6 @@ int node_allocate(struct proc_object *hprocessor,
 	if (status)
 		goto func_cont;
 
-	status = proc_reserve_memory(hprocessor,
-				     pnode->create_args.asa.task_arg_obj.
-				     heap_size + PAGE_SIZE,
-				     (void **)&(pnode->create_args.asa.
-					task_arg_obj.udsp_heap_res_addr),
-				     pr_ctxt);
-	if (status) {
-		pr_err("%s: Failed to reserve memory for heap: 0x%x\n",
-		       __func__, status);
-		goto func_cont;
-	}
 #ifdef DSP_DMM_DEBUG
 	status = dmm_get_handle(p_proc_object, &dmm_mgr);
 	if (!dmm_mgr) {
@@ -456,8 +445,7 @@ int node_allocate(struct proc_object *hprocessor,
 	map_attrs |= DSP_MAPVIRTUALADDR;
 	status = proc_map(hprocessor, (void *)attr_in->pgpp_virt_addr,
 			  pnode->create_args.asa.task_arg_obj.heap_size,
-			  (void *)pnode->create_args.asa.task_arg_obj.
-			  udsp_heap_res_addr, (void **)&mapped_addr, map_attrs,
+			  NULL, (void **)&mapped_addr, map_attrs,
 			  pr_ctxt);
 	if (status)
 		pr_err("%s: Failed to map memory for Heap: 0x%x\n",
@@ -2576,12 +2564,6 @@ static void delete_node(struct node_object *hnode,
 			status = proc_un_map(hnode->hprocessor, (void *)
 					     task_arg_obj.udsp_heap_addr,
 					     pr_ctxt);
-
-			status = proc_un_reserve_memory(hnode->hprocessor,
-							(void *)
-							task_arg_obj.
-							udsp_heap_res_addr,
-							pr_ctxt);
 #ifdef DSP_DMM_DEBUG
 			status = dmm_get_handle(p_proc_object, &dmm_mgr);
 			if (dmm_mgr)
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index e5fec57..429f354 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -152,34 +152,21 @@ static struct dmm_map_object *add_mapping_info(struct process_context *pr_ctxt,
 	return map_obj;
 }
 
-static int match_exact_map_obj(struct dmm_map_object *map_obj,
-					u32 dsp_addr, u32 size)
-{
-	if (map_obj->dsp_addr == dsp_addr && map_obj->size != size)
-		pr_err("%s: addr match (0x%x), size don't (0x%x != 0x%x)\n",
-				__func__, dsp_addr, map_obj->size, size);
-
-	return map_obj->dsp_addr == dsp_addr &&
-		map_obj->size == size;
-}
-
 static void remove_mapping_information(struct process_context *pr_ctxt,
-						u32 dsp_addr, u32 size)
+						u32 dsp_addr)
 {
 	struct dmm_map_object *map_obj;
 
-	pr_debug("%s: looking for virt 0x%x size 0x%x\n", __func__,
-							dsp_addr, size);
+	pr_debug("%s: looking for virt 0x%x\n", __func__, dsp_addr);
 
 	spin_lock(&pr_ctxt->dmm_map_lock);
 	list_for_each_entry(map_obj, &pr_ctxt->dmm_map_list, link) {
-		pr_debug("%s: candidate: mpu_addr 0x%x virt 0x%x size 0x%x\n",
+		pr_debug("%s: candidate: mpu_addr 0x%x virt 0x%x\n",
 							__func__,
 							map_obj->mpu_addr,
-							map_obj->dsp_addr,
-							map_obj->size);
+							map_obj->dsp_addr);
 
-		if (match_exact_map_obj(map_obj, dsp_addr, size)) {
+		if (map_obj->dsp_addr == dsp_addr) {
 			pr_debug("%s: match, deleting map info\n", __func__);
 			list_del(&map_obj->link);
 			kfree(map_obj->dma_info.sg);
@@ -1353,7 +1340,6 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 {
 	u32 va_align;
 	u32 pa_align;
-	struct dmm_object *dmm_mgr;
 	u32 size_align;
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
@@ -1382,11 +1368,6 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 	}
 	/* Critical section */
 	mutex_lock(&proc_lock);
-	dmm_get_handle(p_proc_object, &dmm_mgr);
-	if (dmm_mgr)
-		status = dmm_map_memory(dmm_mgr, va_align, size_align);
-	else
-		status = -EFAULT;
 
 	/* Add mapping to the page tables. */
 	if (!status) {
@@ -1409,9 +1390,9 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 		map_obj->dsp_addr = (va_align |
 					((u32)pmpu_addr & (PG_SIZE4K - 1)));
 		*pp_map_addr = (void *)map_obj->dsp_addr;
+		pr_err("%s: mapped address %x\n", __func__, *pp_map_addr);
 	} else {
-		remove_mapping_information(pr_ctxt, va_align, size_align);
-		dmm_un_map_memory(dmm_mgr, va_align, &size_align);
+		remove_mapping_information(pr_ctxt, va_align);
 	}
 	mutex_unlock(&proc_lock);
 
@@ -1504,38 +1485,6 @@ func_end:
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
-	struct dmm_object *dmm_mgr;
-	int status = 0;
-	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
-
-	if (!p_proc_object) {
-		status = -EFAULT;
-		goto func_end;
-	}
-
-	status = dmm_get_handle(p_proc_object, &dmm_mgr);
-	if (!dmm_mgr) {
-		status = -EFAULT;
-		goto func_end;
-	}
-
-	status = dmm_reserve_memory(dmm_mgr, ul_size, (u32 *) pp_rsv_addr);
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
@@ -1683,7 +1632,6 @@ int proc_un_map(void *hprocessor, void *map_addr,
 {
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
-	struct dmm_object *dmm_mgr;
 	u32 va_align;
 	u32 size_align;
 
@@ -1693,23 +1641,11 @@ int proc_un_map(void *hprocessor, void *map_addr,
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
-	/*
-	 * Update DMM structures. Get the size to unmap.
-	 * This function returns error if the VA is not mapped
-	 */
-	status = dmm_un_map_memory(dmm_mgr, (u32) va_align, &size_align);
 	/* Remove mapping from the page tables. */
-	if (!status)
-		status = user_to_dsp_unmap(
-			p_proc_object->hbridge_context->dsp_mmu, va_align);
+	status = user_to_dsp_unmap(p_proc_object->hbridge_context->dsp_mmu,
+								va_align);
 
 	mutex_unlock(&proc_lock);
 	if (status)
@@ -1720,7 +1656,7 @@ int proc_un_map(void *hprocessor, void *map_addr,
 	 * from dmm_map_list, so that mapped memory resource tracking
 	 * remains uptodate
 	 */
-	remove_mapping_information(pr_ctxt, (u32) map_addr, size_align);
+	remove_mapping_information(pr_ctxt, (u32) map_addr);
 
 func_end:
 	dev_dbg(bridge, "%s: hprocessor: 0x%p map_addr: 0x%p status: 0x%x\n",
@@ -1729,36 +1665,6 @@ func_end:
 }
 
 /*
- *  ======== proc_un_reserve_memory ========
- *  Purpose:
- *      Frees a previously reserved region of DSP address space.
- */
-int proc_un_reserve_memory(void *hprocessor, void *prsv_addr,
-				  struct process_context *pr_ctxt)
-{
-	struct dmm_object *dmm_mgr;
-	int status = 0;
-	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
-
-	if (!p_proc_object) {
-		status = -EFAULT;
-		goto func_end;
-	}
-
-	status = dmm_get_handle(p_proc_object, &dmm_mgr);
-	if (!dmm_mgr) {
-		status = -EFAULT;
-		goto func_end;
-	}
-
-	status = dmm_un_reserve_memory(dmm_mgr, (u32) prsv_addr);
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
1.6.3.3

