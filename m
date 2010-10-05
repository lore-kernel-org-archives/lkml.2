Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab0JEUbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:31:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56677 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312Ab0JEU3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:29:20 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>, <nm@ti.com>,
        <Hiroshi.DOYU@nokia.com>, <ohad@wizery.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv3 09/11] staging: tidspbridge - remove reserved memory clean up
Date: Tue,  5 Oct 2010 15:35:42 -0500
Message-Id: <1286310944-25035-10-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286310944-25035-9-git-send-email-x0095840@ti.com>
References: <1286310944-25035-1-git-send-email-x0095840@ti.com>
 <1286310944-25035-2-git-send-email-x0095840@ti.com>
 <1286310944-25035-3-git-send-email-x0095840@ti.com>
 <1286310944-25035-4-git-send-email-x0095840@ti.com>
 <1286310944-25035-5-git-send-email-x0095840@ti.com>
 <1286310944-25035-6-git-send-email-x0095840@ti.com>
 <1286310944-25035-7-git-send-email-x0095840@ti.com>
 <1286310944-25035-8-git-send-email-x0095840@ti.com>
 <1286310944-25035-9-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now iommv module keeps track of iommu memory used,
we do not need resource cleanup for reserved
memories anymore.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 .../staging/tidspbridge/include/dspbridge/drv.h    |    4 --
 drivers/staging/tidspbridge/rmgr/drv.c             |   11 ------
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    2 -
 drivers/staging/tidspbridge/rmgr/proc.c            |   36 --------------------
 4 files changed, 0 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/drv.h b/drivers/staging/tidspbridge/include/dspbridge/drv.h
index c1f363e..427f38b 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/drv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/drv.h
@@ -165,10 +165,6 @@ struct process_context {
 	struct list_head dmm_map_list;
 	spinlock_t dmm_map_lock;
 
-	/* DMM reserved memory resources */
-	struct list_head dmm_rsv_list;
-	spinlock_t dmm_rsv_lock;
-
 	/* DSP Heap resources */
 	struct dspheap_res_object *pdspheap_list;
 
diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index 0c857b9..91cc168 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -146,7 +146,6 @@ int drv_remove_all_dmm_res_elements(void *process_ctxt)
 	struct process_context *ctxt = (struct process_context *)process_ctxt;
 	int status = 0;
 	struct dmm_map_object *temp_map, *map_obj;
-	struct dmm_rsv_object *temp_rsv, *rsv_obj;
 
 	/* Free DMM mapped memory resources */
 	list_for_each_entry_safe(map_obj, temp_map, &ctxt->dmm_map_list, link) {
@@ -156,16 +155,6 @@ int drv_remove_all_dmm_res_elements(void *process_ctxt)
 			pr_err("%s: proc_un_map failed!"
 			       " status = 0x%xn", __func__, status);
 	}
-
-	/* Free DMM reserved memory resources */
-	list_for_each_entry_safe(rsv_obj, temp_rsv, &ctxt->dmm_rsv_list, link) {
-		status = proc_un_reserve_memory(ctxt->hprocessor, (void *)
-						rsv_obj->dsp_reserved_addr,
-						ctxt);
-		if (status)
-			pr_err("%s: proc_un_reserve_memory failed!"
-			       " status = 0x%xn", __func__, status);
-	}
 	return status;
 }
 
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 5d0670c..63052b0 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -509,8 +509,6 @@ static int bridge_open(struct inode *ip, struct file *filp)
 		pr_ctxt->res_state = PROC_RES_ALLOCATED;
 		spin_lock_init(&pr_ctxt->dmm_map_lock);
 		INIT_LIST_HEAD(&pr_ctxt->dmm_map_list);
-		spin_lock_init(&pr_ctxt->dmm_rsv_lock);
-		INIT_LIST_HEAD(&pr_ctxt->dmm_rsv_list);
 
 		pr_ctxt->node_id = kzalloc(sizeof(struct idr), GFP_KERNEL);
 		if (pr_ctxt->node_id) {
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index 59c946b..e5fec57 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -1515,7 +1515,6 @@ int proc_reserve_memory(void *hprocessor, u32 ul_size,
 	struct dmm_object *dmm_mgr;
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
-	struct dmm_rsv_object *rsv_obj;
 
 	if (!p_proc_object) {
 		status = -EFAULT;
@@ -1529,22 +1528,6 @@ int proc_reserve_memory(void *hprocessor, u32 ul_size,
 	}
 
 	status = dmm_reserve_memory(dmm_mgr, ul_size, (u32 *) pp_rsv_addr);
-	if (status != 0)
-		goto func_end;
-
-	/*
-	 * A successful reserve should be followed by insertion of rsv_obj
-	 * into dmm_rsv_list, so that reserved memory resource tracking
-	 * remains uptodate
-	 */
-	rsv_obj = kmalloc(sizeof(struct dmm_rsv_object), GFP_KERNEL);
-	if (rsv_obj) {
-		rsv_obj->dsp_reserved_addr = (u32) *pp_rsv_addr;
-		spin_lock(&pr_ctxt->dmm_rsv_lock);
-		list_add(&rsv_obj->link, &pr_ctxt->dmm_rsv_list);
-		spin_unlock(&pr_ctxt->dmm_rsv_lock);
-	}
-
 func_end:
 	dev_dbg(bridge, "%s: hprocessor: 0x%p ul_size: 0x%x pp_rsv_addr: 0x%p "
 		"status 0x%x\n", __func__, hprocessor,
@@ -1756,7 +1739,6 @@ int proc_un_reserve_memory(void *hprocessor, void *prsv_addr,
 	struct dmm_object *dmm_mgr;
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
-	struct dmm_rsv_object *rsv_obj;
 
 	if (!p_proc_object) {
 		status = -EFAULT;
@@ -1770,24 +1752,6 @@ int proc_un_reserve_memory(void *hprocessor, void *prsv_addr,
 	}
 
 	status = dmm_un_reserve_memory(dmm_mgr, (u32) prsv_addr);
-	if (status != 0)
-		goto func_end;
-
-	/*
-	 * A successful unreserve should be followed by removal of rsv_obj
-	 * from dmm_rsv_list, so that reserved memory resource tracking
-	 * remains uptodate
-	 */
-	spin_lock(&pr_ctxt->dmm_rsv_lock);
-	list_for_each_entry(rsv_obj, &pr_ctxt->dmm_rsv_list, link) {
-		if (rsv_obj->dsp_reserved_addr == (u32) prsv_addr) {
-			list_del(&rsv_obj->link);
-			kfree(rsv_obj);
-			break;
-		}
-	}
-	spin_unlock(&pr_ctxt->dmm_rsv_lock);
-
 func_end:
 	dev_dbg(bridge, "%s: hprocessor: 0x%p prsv_addr: 0x%p status: 0x%x\n",
 		__func__, hprocessor, prsv_addr, status);
-- 
1.6.3.3

