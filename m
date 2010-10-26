Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab0JZAjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:39:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55231 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab0JZAia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:38:30 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <Hiroshi.DOYU@nokia.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 1/8] staging: tidspbridge - remove req_addr from proc_map
Date: Mon, 25 Oct 2010 19:51:39 -0500
Message-Id: <1288054306-4361-2-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1288054306-4361-1-git-send-email-x0095840@ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device address is assigned by tidspbridge no need for that parameter anymore.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 .../tidspbridge/include/dspbridge/dspapi-ioctl.h   |    1 -
 .../staging/tidspbridge/include/dspbridge/proc.h   |    3 --
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    2 +-
 drivers/staging/tidspbridge/rmgr/node.c            |    2 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |   25 +++++++++----------
 5 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspapi-ioctl.h b/drivers/staging/tidspbridge/include/dspbridge/dspapi-ioctl.h
index 8da5bd8..db06468 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspapi-ioctl.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspapi-ioctl.h
@@ -138,7 +138,6 @@ union trapped_args {
 		void *hprocessor;
 		void *pmpu_addr;
 		u32 ul_size;
-		void *req_addr;
 		void *__user *pp_map_addr;
 		u32 ul_map_attr;
 	} args_proc_mapmem;
diff --git a/drivers/staging/tidspbridge/include/dspbridge/proc.h b/drivers/staging/tidspbridge/include/dspbridge/proc.h
index 2d12aab..74344bd 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/proc.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/proc.h
@@ -524,8 +524,6 @@ extern int proc_invalidate_memory(void *hprocessor,
  *      hprocessor      :   The processor handle.
  *      pmpu_addr	:   Starting address of the memory region to map.
  *      ul_size	  :   Size of the memory region to map.
- *      req_addr	:   Requested DSP start address. Offset-adjusted actual
- *			  mapped address is in the last argument.
  *      pp_map_addr       :   Ptr to DSP side mapped u8 address.
  *      ul_map_attr       :   Optional endianness attributes, virt to phys flag.
  *  Returns:
@@ -546,7 +544,6 @@ extern int proc_invalidate_memory(void *hprocessor,
 extern int proc_map(void *hprocessor,
 			   void *pmpu_addr,
 			   u32 ul_size,
-			   void *req_addr,
 			   void **pp_map_addr, u32 ul_map_attr,
 			   struct process_context *pr_ctxt);
 
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 0187c47..d1e1185 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -952,7 +952,7 @@ u32 procwrap_map(union trapped_args *args, void *pr_ctxt)
 	status = proc_map(args->args_proc_mapmem.hprocessor,
 			  args->args_proc_mapmem.pmpu_addr,
 			  args->args_proc_mapmem.ul_size,
-			  args->args_proc_mapmem.req_addr, &map_addr,
+			  &map_addr,
 			  args->args_proc_mapmem.ul_map_attr, pr_ctxt);
 	if (!status) {
 		if (put_user(map_addr, args->args_proc_mapmem.pp_map_addr)) {
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index a660247..3f5abcf 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -430,7 +430,7 @@ int node_allocate(struct proc_object *hprocessor,
 	map_attrs |= DSP_MAPVIRTUALADDR;
 	status = proc_map(hprocessor, (void *)attr_in->pgpp_virt_addr,
 			  pnode->create_args.asa.task_arg_obj.heap_size,
-			  NULL, (void **)&mapped_addr, map_attrs,
+			  (void **)&mapped_addr, map_attrs,
 			  pr_ctxt);
 	if (status)
 		pr_err("%s: Failed to map memory for Heap: 0x%x\n",
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index 7a15a02..5e5eb75 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -1314,10 +1314,10 @@ func_end:
  *      Maps a MPU buffer to DSP address space.
  */
 int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
-		    void *req_addr, void **pp_map_addr, u32 ul_map_attr,
+		    void **pp_map_addr, u32 ul_map_attr,
 		    struct process_context *pr_ctxt)
 {
-	u32 va_align;
+	u32 da;
 	u32 pa_align;
 	u32 size_align;
 	int status = 0;
@@ -1336,7 +1336,6 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 #endif
 
 	/* Calculate the page-aligned PA, VA and size */
-	va_align = PG_ALIGN_LOW((u32) req_addr, PG_SIZE4K);
 	pa_align = PG_ALIGN_LOW((u32) pmpu_addr, PG_SIZE4K);
 	size_align = PG_ALIGN_HIGH(ul_size + (u32) pmpu_addr - pa_align,
 				   PG_SIZE4K);
@@ -1351,26 +1350,26 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 	/* Add mapping to the page tables. */
 	if (!status) {
 		/* mapped memory resource tracking */
-		map_obj = add_mapping_info(pr_ctxt, pa_align, va_align,
+		map_obj = add_mapping_info(pr_ctxt, pa_align, 0,
 						size_align);
 		if (!map_obj) {
 			status = -ENOMEM;
 		} else {
-			va_align = user_to_dsp_map(
+			da = user_to_dsp_map(
 				p_proc_object->hbridge_context->dsp_mmu,
-				pa_align, va_align, size_align,
+				pa_align, 0, size_align,
 				map_obj->pages);
-			if (IS_ERR_VALUE(va_align))
-				status = (int)va_align;
+			if (IS_ERR_VALUE(da))
+				status = (int)da;
 		}
 	}
 	if (!status) {
 		/* Mapped address = MSB of VA | LSB of PA */
-		map_obj->dsp_addr = (va_align |
+		map_obj->dsp_addr = (da |
 					((u32)pmpu_addr & (PG_SIZE4K - 1)));
 		*pp_map_addr = (void *)map_obj->dsp_addr;
 	} else {
-		remove_mapping_information(pr_ctxt, va_align);
+		remove_mapping_information(pr_ctxt, 0);
 	}
 	mutex_unlock(&proc_lock);
 
@@ -1379,10 +1378,10 @@ int proc_map(void *hprocessor, void *pmpu_addr, u32 ul_size,
 
 func_end:
 	dev_dbg(bridge, "%s: hprocessor %p, pmpu_addr %p, ul_size %x, "
-		"req_addr %p, ul_map_attr %x, pp_map_addr %p, va_align %x, "
+		"ul_map_attr %x, pp_map_addr %p, "
 		"pa_align %x, size_align %x status 0x%x\n", __func__,
-		hprocessor, pmpu_addr, ul_size, req_addr, ul_map_attr,
-		pp_map_addr, va_align, pa_align, size_align, status);
+		hprocessor, pmpu_addr, ul_size, ul_map_attr,
+		pp_map_addr, pa_align, size_align, status);
 
 	return status;
 }
-- 
1.6.3.3

