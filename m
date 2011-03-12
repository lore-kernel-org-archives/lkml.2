Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1CLAkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 19:40:36 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48387 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab1CLAke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 19:40:34 -0500
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg KH <greg@kroah.com>, l-m <linux-kernel@vger.kernel.org>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        l-o <linux-omap@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Tuomas Kulve <tuomas@kulve.fi>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: [PATCH] staging: tidspbridge: protect dmm_map properly
Date: Fri, 11 Mar 2011 18:29:06 -0600
Message-Id: <1299889746-16502-1-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please consider to apply this patch in the staging tree, as the
description says it fixes a crash in tidspbridge driver, this bug
was already present but it seems to have surfaced by recent tests
made by Felipe and Tuomas.

It is an urgent fix for 2.6.38.

More on this discussion:
http://www.gossamer-threads.com/lists/linux/kernel/1351446

Thanks,
- omar

From: Felipe Contreras <felipe.contreras@nokia.com>

We need to protect not only the dmm_map list, but the individual
map_obj's, otherwise, we might be building the scatter-gather list with
garbage. So, use the existing proc_lock for that.

I observed race conditions which caused kernel panics while running
stress tests, also, Tuomas Kulve found it happening quite often in
Gumstix Over. This patch fixes those.

Cc: Tuomas Kulve <tuomas@kulve.fi>
Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/rmgr/proc.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index b47d7aa..e2fe165 100644
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
@@ -819,21 +823,24 @@ int proc_end_dma(void *hprocessor, void *pmpu_addr, u32 ul_size,
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
 		pr_err("%s: InValid address parameters %p %x\n",
 		       __func__, pmpu_addr, ul_size);
 		status = -EFAULT;
-		goto err_out;
 	}
 
+no_map:
+	mutex_unlock(&proc_lock);
 err_out:
 	return status;
 }
@@ -1726,9 +1733,8 @@ int proc_un_map(void *hprocessor, void *map_addr,
 		    (p_proc_object->hbridge_context, va_align, size_align);
 	}
 
-	mutex_unlock(&proc_lock);
 	if (status)
-		goto func_end;
+		goto unmap_failed;
 
 	/*
 	 * A successful unmap should be followed by removal of map_obj
@@ -1737,6 +1743,9 @@ int proc_un_map(void *hprocessor, void *map_addr,
 	 */
 	remove_mapping_information(pr_ctxt, (u32) map_addr, size_align);
 
+unmap_failed:
+	mutex_unlock(&proc_lock);
+
 func_end:
 	dev_dbg(bridge, "%s: hprocessor: 0x%p map_addr: 0x%p status: 0x%x\n",
 		__func__, hprocessor, map_addr, status);
-- 
1.7.1

