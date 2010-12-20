Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab0LTRMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:12:41 -0500
Received: from smtp.nokia.com ([147.243.1.48]:33953 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932875Ab0LTRMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:12:39 -0500
From: Felipe Contreras <felipe.contreras@nokia.com>
To: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Nishanth Menon <nm@ti.com>, Ameya Palande <ameya.palande@nokia.com>,
        Felipe Contreras <felipe.contreras@nokia.com>
Subject: [PATCH] staging: tidspbridge: protect dmm_map properly
Date: Mon, 20 Dec 2010 19:12:00 +0200
Message-Id: <1292865120-24020-1-git-send-email-felipe.contreras@nokia.com>
X-Mailer: git-send-email 1.7.3.3
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to protect not only the dmm_map list, but the individual
map_obj's, otherwise, we might be building the scatter-gather list with
garbage. So, use the existing proc_lock for that.

I observed race conditions which caused kernel panics while running
stress tests. This patch fixes those.

Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>
---
 drivers/staging/tidspbridge/rmgr/proc.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index b47d7aa..21052e3 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -781,12 +781,14 @@ int proc_begin_dma(void *hprocessor, void *pmpu_addr, u32 ul_size,
 							(u32)pmpu_addr,
 							ul_size, dir);
 
+	mutex_lock(&proc_lock);
+
 	/* find requested memory are in cached mapping information */
 	map_obj = find_containing_mapping(pr_ctxt, (u32) pmpu_addr, ul_size);
 	if (!map_obj) {
 		pr_err("%s: find_containing_mapping failed\n", __func__);
 		status = -EFAULT;
-		goto err_out;
+		goto no_map;
 	}
 
 	if (memory_give_ownership(map_obj, (u32) pmpu_addr, ul_size, dir)) {
@@ -795,6 +797,8 @@ int proc_begin_dma(void *hprocessor, void *pmpu_addr, u32 ul_size,
 		status = -EFAULT;
 	}
 
+no_map:
+	mutex_unlock(&proc_lock);
 err_out:
 
 	return status;
@@ -819,12 +823,14 @@ int proc_end_dma(void *hprocessor, void *pmpu_addr, u32 ul_size,
 							(u32)pmpu_addr,
 							ul_size, dir);
 
+	mutex_lock(&proc_lock);
+
 	/* find requested memory are in cached mapping information */
 	map_obj = find_containing_mapping(pr_ctxt, (u32) pmpu_addr, ul_size);
 	if (!map_obj) {
 		pr_err("%s: find_containing_mapping failed\n", __func__);
 		status = -EFAULT;
-		goto err_out;
+		goto no_map;
 	}
 
 	if (memory_regain_ownership(map_obj, (u32) pmpu_addr, ul_size, dir)) {
@@ -834,6 +840,8 @@ int proc_end_dma(void *hprocessor, void *pmpu_addr, u32 ul_size,
 		goto err_out;
 	}
 
+no_map:
+	mutex_unlock(&proc_lock);
 err_out:
 	return status;
 }
@@ -1726,9 +1734,8 @@ int proc_un_map(void *hprocessor, void *map_addr,
 		    (p_proc_object->hbridge_context, va_align, size_align);
 	}
 
-	mutex_unlock(&proc_lock);
 	if (status)
-		goto func_end;
+		goto unmap_failed;
 
 	/*
 	 * A successful unmap should be followed by removal of map_obj
@@ -1737,6 +1744,9 @@ int proc_un_map(void *hprocessor, void *map_addr,
 	 */
 	remove_mapping_information(pr_ctxt, (u32) map_addr, size_align);
 
+unmap_failed:
+	mutex_unlock(&proc_lock);
+
 func_end:
 	dev_dbg(bridge, "%s: hprocessor: 0x%p map_addr: 0x%p status: 0x%x\n",
 		__func__, hprocessor, map_addr, status);
-- 
1.7.3.3

