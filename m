Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab2F2PPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:15:12 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47845 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149Ab2F2POt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:14:49 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 11/11] UBI: Fastmap: Add a module parameter to enable fastmap
Date: Fri, 29 Jun 2012 17:14:29 +0200
Message-Id: <1340982869-77042-12-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340982869-77042-1-git-send-email-richard@nod.at>
References: <1340982869-77042-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new parameter, ubi.fm_auto is per default 0.
If you attach an old image without a fastmap installed
UBI will not install a fastmap an work like in the old days.
But attaching by fastmap will work too if you attach a new image.
Of course in this case the fastmap will also get updated.

Is ubi.fm_auto set to 1 UBI automatically installs a fastmap
on old images.
This can be used to convert old images to have fastmap support.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c  |    2 +-
 drivers/mtd/ubi/build.c   |    8 +++++++-
 drivers/mtd/ubi/fastmap.c |    2 ++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index c55ad0f..a343a41 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1394,7 +1394,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 	if (!ai)
 		return -ENOMEM;
 
-	if (force_scan || ubi->fm_disabled)
+	if (force_scan)
 		err = scan_all(ubi, ai, 0);
 	else {
 		err = scan_fast(ubi, ai);
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 7b5dc5d..50b7590 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -67,6 +67,8 @@ static int __initdata mtd_devs;
 
 /* MTD devices specification parameters */
 static struct mtd_dev_param __initdata mtd_dev_param[UBI_MAX_DEVICES];
+/* UBI module parameter to enable fastmap automatically on non-fastmap images */
+static bool fm_auto;
 
 /* Root UBI "class" object (corresponds to '/<sysfs>/class/ubi/') */
 struct class *ubi_class;
@@ -899,7 +901,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num, int vid_hdr_offset)
 		ubi->fm_pool.max_size = UBI_FM_MIN_POOL_SIZE;
 
 	ubi->fm_wl_pool.max_size = UBI_FM_WL_POOL_SIZE;
-	ubi->fm_disabled = 1;
+	ubi->fm_disabled = !fm_auto;
 
 	ubi_msg("default fastmap pool size: %d", ubi->fm_pool.max_size);
 	ubi_msg("default fastmap WL pool size: %d", ubi->fm_wl_pool.max_size);
@@ -1392,6 +1394,10 @@ MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: "
 		      "with name \"content\" using VID header offset 1984, and "
 		      "MTD device number 4 with default VID header offset.");
 
+module_param(fm_auto, bool, 000);
+MODULE_PARM_DESC(fm_auto, "Set this parameter to enable fastmap automatically "
+			  "on images without a fastmap.");
+
 MODULE_VERSION(__stringify(UBI_VERSION));
 MODULE_DESCRIPTION("UBI - Unsorted Block Images");
 MODULE_AUTHOR("Artem Bityutskiy");
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 0c9466d..d995105 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1044,8 +1044,10 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	ubi->fm = fm;
 	ubi->fm_pool.max_size = ubi->fm->max_pool_size;
 	ubi->fm_wl_pool.max_size = ubi->fm->max_wl_pool_size;
+	ubi_msg("attached by fastmap");
 	ubi_msg("fastmap pool size: %d", ubi->fm_pool.max_size);
 	ubi_msg("fastmap WL pool size: %d", ubi->fm_wl_pool.max_size);
+	ubi->fm_disabled = 0;
 
 free_hdr:
 	ubi_free_vid_hdr(ubi, vh);
-- 
1.7.6.5

