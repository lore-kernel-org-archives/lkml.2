Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2CIAF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:05:27 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:47122 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657Ab2CIAEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjDwEjIxAlAhgOAgI5AxsGARKIDqgakgWBL44RgRYElUWFZYNchleCZA
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086953"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 12/17] staging: tidspbridge: remove dmm_init() and dmm_exit()
Date: Fri,  9 Mar 2012 01:03:47 +0100
Message-Id: <324824cf5bc55899ae948ae4e585f5ed102f379a.1331250369.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <cover.1331250368.git.vjaquez@igalia.com>
References: <cover.1331250368.git.vjaquez@igalia.com>
In-Reply-To: <cover.1331250368.git.vjaquez@igalia.com>
References: <cover.1331250368.git.vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dmm module has a dmm_init() and a dmm_exit() whose only purpose is
to keep a reference counting which is not used at all.

This patch removes these functions and the reference count variable.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 .../staging/tidspbridge/include/dspbridge/dmm.h    |    4 --
 drivers/staging/tidspbridge/pmgr/dev.c             |    6 ----
 drivers/staging/tidspbridge/pmgr/dmm.c             |   32 --------------------
 3 files changed, 0 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/dmm.h b/drivers/staging/tidspbridge/include/dspbridge/dmm.h
index 6c58335..c3487be 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dmm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dmm.h
@@ -61,10 +61,6 @@ extern int dmm_create(struct dmm_object **dmm_manager,
 			     struct dev_object *hdev_obj,
 			     const struct dmm_mgrattrs *mgr_attrts);
 
-extern bool dmm_init(void);
-
-extern void dmm_exit(void);
-
 extern int dmm_create_tables(struct dmm_object *dmm_mgr,
 				    u32 addr, u32 size);
 
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index 734d47e..c5e627c 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -657,9 +657,6 @@ int dev_get_bridge_context(struct dev_object *hdev_obj,
 void dev_exit(void)
 {
 	refs--;
-
-	if (refs == 0)
-		dmm_exit();
 }
 
 /*
@@ -671,9 +668,6 @@ bool dev_init(void)
 {
 	bool ret = true;
 
-	if (refs == 0)
-		dmm_init();
-
 	if (ret)
 		refs++;
 
diff --git a/drivers/staging/tidspbridge/pmgr/dmm.c b/drivers/staging/tidspbridge/pmgr/dmm.c
index 83faff8..7c9f839 100644
--- a/drivers/staging/tidspbridge/pmgr/dmm.c
+++ b/drivers/staging/tidspbridge/pmgr/dmm.c
@@ -51,8 +51,6 @@ struct dmm_object {
 	spinlock_t dmm_lock;	/* Lock to access dmm mgr */
 };
 
-/*  ----------------------------------- Globals */
-static u32 refs;		/* module reference count */
 struct map_page {
 	u32 region_size:15;
 	u32 mapped_size:15;
@@ -172,18 +170,6 @@ int dmm_delete_tables(struct dmm_object *dmm_mgr)
 }
 
 /*
- *  ======== dmm_exit ========
- *  Purpose:
- *      Discontinue usage of module; free resources when reference count
- *      reaches 0.
- */
-void dmm_exit(void)
-{
-
-	refs--;
-}
-
-/*
  *  ======== dmm_get_handle ========
  *  Purpose:
  *      Return the dynamic memory manager object for this device.
@@ -206,24 +192,6 @@ int dmm_get_handle(void *hprocessor, struct dmm_object **dmm_manager)
 }
 
 /*
- *  ======== dmm_init ========
- *  Purpose:
- *      Initializes private state of DMM module.
- */
-bool dmm_init(void)
-{
-	bool ret = true;
-
-	if (ret)
-		refs++;
-
-	virtual_mapping_table = NULL;
-	table_size = 0;
-
-	return ret;
-}
-
-/*
  *  ======== dmm_map_memory ========
  *  Purpose:
  *      Add a mapping block to the reserved chunk. DMM assumes that this block
-- 
1.7.9.1

