Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab2KHNDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:03:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:60814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622Ab2KHNDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:03:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244102077"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 05/26] block: add panic write
Date: Thu,  8 Nov 2012 15:06:03 +0200
Message-Id: <1352379984-18381-6-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
References: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a small interface to allow block devices to attempt to write
during an oops or panic.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/block/Kconfig  |    3 ++
 include/linux/blkdev.h |   77 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/genhd.h  |    3 ++
 3 files changed, 83 insertions(+)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index af5b325..922cfd6 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -554,4 +554,7 @@ config BLK_DEV_OOPS
 
 	  See <file:Documentation/blockdev/blkoops.txt> for more information.
 
+config BLK_DEV_PANIC_WRITE
+	bool
+
 endif # BLK_DEV
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1756001..bedfaab 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1461,6 +1461,83 @@ static inline bool blk_integrity_is_initialized(struct gendisk *g)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+#ifdef CONFIG_BLK_DEV_PANIC_WRITE
+
+/**
+ * struct panic_write_operations - operations to support writing during an oops
+ *				   or panic.
+ * @init: allocate resources
+ * @cleanup: release resources
+ * @write: called in an oops or panic context to write data
+ * @flush: called in an oops or panic context to finish write operations
+ *
+ * @write may need resources that cannot be allocated in a panic or oops
+ * context.  @init can be used to allocate those resources in advance.
+ * @cleanup is called if panic writing becomes disabled.
+ */
+struct panic_write_operations {
+	int (*init)(struct block_device *);
+	void (*cleanup)(struct block_device *);
+	int (*write)(struct block_device *, sector_t, void *, unsigned long);
+	int (*flush)(struct block_device *);
+};
+
+static inline int blk_panic_init(struct block_device *bdev)
+{
+	if (!bdev->bd_disk->pwops || !bdev->bd_disk->pwops->write)
+		return -EOPNOTSUPP;
+	if (bdev->bd_disk->pwops && bdev->bd_disk->pwops->init)
+		return bdev->bd_disk->pwops->init(bdev);
+	return 0;
+}
+
+static inline void blk_panic_cleanup(struct block_device *bdev)
+{
+	if (bdev->bd_disk->pwops && bdev->bd_disk->pwops->cleanup)
+		bdev->bd_disk->pwops->cleanup(bdev);
+}
+
+static inline int blk_panic_write(struct block_device *bdev, sector_t sect,
+				  void *addr, unsigned long len)
+{
+	if (!bdev->bd_disk->pwops || !bdev->bd_disk->pwops->write)
+		return -EOPNOTSUPP;
+	if (bdev != bdev->bd_contains)
+		sect += bdev->bd_part->start_sect;
+	return bdev->bd_disk->pwops->write(bdev, sect, addr, len);
+}
+
+static inline int blk_panic_flush(struct block_device *bdev)
+{
+	if (bdev->bd_disk->pwops && bdev->bd_disk->pwops->flush)
+		return bdev->bd_disk->pwops->flush(bdev);
+	return 0;
+}
+
+#else
+
+static inline int blk_panic_init(struct block_device *bdev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void blk_panic_cleanup(struct block_device *bdev)
+{
+}
+
+static inline int blk_panic_write(struct block_device *bdev, sector_t sect,
+				  void *addr, unsigned long len)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int blk_panic_flush(struct block_device *bdev)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* CONFIG_BLK_DEV_PANIC_WRITE */
+
 struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
 	int (*release) (struct gendisk *, fmode_t);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 4f440b3..73470af 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -195,6 +195,9 @@ struct gendisk {
 #ifdef  CONFIG_BLK_DEV_INTEGRITY
 	struct blk_integrity *integrity;
 #endif
+#ifdef CONFIG_BLK_DEV_PANIC_WRITE
+	const struct panic_write_operations *pwops;
+#endif
 	int node_id;
 };
 
-- 
1.7.9.5

