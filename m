Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab2JWNnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:43:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:38218 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976Ab2JWNnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:43:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="237191014"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 05/26] block: add panic write
Date: Tue, 23 Oct 2012 16:48:03 +0300
Message-Id: <1351000104-13015-6-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
References: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
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
index 332ba52..f58853c 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -553,4 +553,7 @@ config BLK_DEV_OOPS
 
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

