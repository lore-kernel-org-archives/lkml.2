Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab0LTO0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:26:21 -0500
Received: from smtp.nokia.com ([147.243.128.26]:62299 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757583Ab0LTO0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:26:19 -0500
From: Felipe Contreras <felipe.contreras@nokia.com>
To: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Nishanth Menon <nm@ti.com>, Ameya Palande <ameya.palande@nokia.com>,
        Felipe Contreras <felipe.contreras@nokia.com>
Subject: [PATCH 1/2] staging: tidspbridge: convert dmm_map_lock to sema
Date: Mon, 20 Dec 2010 16:25:33 +0200
Message-Id: <1292855134-14374-2-git-send-email-felipe.contreras@nokia.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1292855134-14374-1-git-send-email-felipe.contreras@nokia.com>
References: <1292855134-14374-1-git-send-email-felipe.contreras@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed because the lock needs to be extended to protect the
mapping info access, which is used to construct a scatter-gather list,
and in the process, we might sleep.

Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>
---
 .../staging/tidspbridge/include/dspbridge/drv.h    |    2 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    2 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |   12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/drv.h b/drivers/staging/tidspbridge/include/dspbridge/drv.h
index c1f363e..217c918 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/drv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/drv.h
@@ -163,7 +163,7 @@ struct process_context {
 
 	/* DMM mapped memory resources */
 	struct list_head dmm_map_list;
-	spinlock_t dmm_map_lock;
+	struct semaphore dmm_map_sema;
 
 	/* DMM reserved memory resources */
 	struct list_head dmm_rsv_list;
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 324fcdf..82c25c6 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -507,7 +507,7 @@ static int bridge_open(struct inode *ip, struct file *filp)
 	pr_ctxt = kzalloc(sizeof(struct process_context), GFP_KERNEL);
 	if (pr_ctxt) {
 		pr_ctxt->res_state = PROC_RES_ALLOCATED;
-		spin_lock_init(&pr_ctxt->dmm_map_lock);
+		sema_init(&pr_ctxt->dmm_map_sema, 1);
 		INIT_LIST_HEAD(&pr_ctxt->dmm_map_list);
 		spin_lock_init(&pr_ctxt->dmm_rsv_lock);
 		INIT_LIST_HEAD(&pr_ctxt->dmm_rsv_list);
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index b47d7aa..77ab5f5 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -144,9 +144,9 @@ static struct dmm_map_object *add_mapping_info(struct process_context *pr_ctxt,
 	map_obj->size = size;
 	map_obj->num_usr_pgs = num_usr_pgs;
 
-	spin_lock(&pr_ctxt->dmm_map_lock);
+	down(&pr_ctxt->dmm_map_sema);
 	list_add(&map_obj->link, &pr_ctxt->dmm_map_list);
-	spin_unlock(&pr_ctxt->dmm_map_lock);
+	up(&pr_ctxt->dmm_map_sema);
 
 	return map_obj;
 }
@@ -170,7 +170,7 @@ static void remove_mapping_information(struct process_context *pr_ctxt,
 	pr_debug("%s: looking for virt 0x%x size 0x%x\n", __func__,
 							dsp_addr, size);
 
-	spin_lock(&pr_ctxt->dmm_map_lock);
+	down(&pr_ctxt->dmm_map_sema);
 	list_for_each_entry(map_obj, &pr_ctxt->dmm_map_list, link) {
 		pr_debug("%s: candidate: mpu_addr 0x%x virt 0x%x size 0x%x\n",
 							__func__,
@@ -191,7 +191,7 @@ static void remove_mapping_information(struct process_context *pr_ctxt,
 
 	pr_err("%s: failed to find given map info\n", __func__);
 out:
-	spin_unlock(&pr_ctxt->dmm_map_lock);
+	up(&pr_ctxt->dmm_map_sema);
 }
 
 static int match_containing_map_obj(struct dmm_map_object *map_obj,
@@ -211,7 +211,7 @@ static struct dmm_map_object *find_containing_mapping(
 	pr_debug("%s: looking for mpu_addr 0x%x size 0x%x\n", __func__,
 						mpu_addr, size);
 
-	spin_lock(&pr_ctxt->dmm_map_lock);
+	down(&pr_ctxt->dmm_map_sema);
 	list_for_each_entry(map_obj, &pr_ctxt->dmm_map_list, link) {
 		pr_debug("%s: candidate: mpu_addr 0x%x virt 0x%x size 0x%x\n",
 						__func__,
@@ -228,7 +228,7 @@ static struct dmm_map_object *find_containing_mapping(
 
 	map_obj = NULL;
 out:
-	spin_unlock(&pr_ctxt->dmm_map_lock);
+	up(&pr_ctxt->dmm_map_sema);
 	return map_obj;
 }
 
-- 
1.7.3.3

