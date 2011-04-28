Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab1D1PnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:43:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58611 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382Ab1D1PnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:43:15 -0400
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <x0095840@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Nishanth Menon <nm@ti.com>,
        lkml <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>
Subject: [PATCH v4 1/6] staging: tidspbridge: introduce mapping search based on device address
Date: Thu, 28 Apr 2011 10:31:47 -0500
Message-Id: <1304004712-8487-2-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
References: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create function find_containing_mapping_da to search mapping objects
given the dsp va instead of the mpu va, in preparation to delete dmm
functions altogether.

Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/rmgr/proc.c |   41 +++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index 242dd13..214dff8 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -231,6 +231,37 @@ out:
 	return map_obj;
 }
 
+static struct dmm_map_object *find_containing_mapping_da(
+				struct process_context *pr_ctxt,
+				u32 dsp_addr)
+{
+	struct dmm_map_object *map_obj;
+
+	pr_debug("%s: looking for virt 0x%x\n", __func__, dsp_addr);
+
+	spin_lock(&pr_ctxt->dmm_map_lock);
+	list_for_each_entry(map_obj, &pr_ctxt->dmm_map_list, link) {
+		pr_debug("%s: candidate: mpu_addr 0x%x virt 0x%x size 0x%x\n",
+							__func__,
+							map_obj->mpu_addr,
+							map_obj->dsp_addr,
+							map_obj->size);
+
+		if (map_obj->dsp_addr == dsp_addr) {
+			pr_debug("%s: match!\n", __func__);
+			goto out;
+		}
+		pr_debug("%s: candidate didn't match\n", __func__);
+	}
+
+	map_obj = NULL;
+
+	pr_err("%s: failed to find given map info\n", __func__);
+out:
+	spin_unlock(&pr_ctxt->dmm_map_lock);
+	return map_obj;
+}
+
 static int find_first_page_in_cache(struct dmm_map_object *map_obj,
 					unsigned long mpu_addr)
 {
@@ -1703,6 +1734,7 @@ int proc_un_map(void *hprocessor, void *map_addr,
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
 	struct dmm_object *dmm_mgr;
+	struct dmm_map_object *dmo;
 	u32 va_align;
 	u32 size_align;
 
@@ -1725,10 +1757,15 @@ int proc_un_map(void *hprocessor, void *map_addr,
 	 * This function returns error if the VA is not mapped
 	 */
 	status = dmm_un_map_memory(dmm_mgr, (u32) va_align, &size_align);
+
+	dmo = find_containing_mapping_da(pr_ctxt, (u32)map_addr);
+	if (!dmo)
+		goto unmap_failed;
+
 	/* Remove mapping from the page tables. */
 	if (!status) {
 		status = (*p_proc_object->intf_fxns->brd_mem_un_map)
-		    (p_proc_object->bridge_context, va_align, size_align);
+		    (p_proc_object->bridge_context, va_align, dmo->size);
 	}
 
 	if (status)
@@ -1739,7 +1776,7 @@ int proc_un_map(void *hprocessor, void *map_addr,
 	 * from dmm_map_list, so that mapped memory resource tracking
 	 * remains uptodate
 	 */
-	remove_mapping_information(pr_ctxt, (u32) map_addr, size_align);
+	remove_mapping_information(pr_ctxt, (u32) map_addr, dmo->size);
 
 unmap_failed:
 	mutex_unlock(&proc_lock);
-- 
1.7.1

