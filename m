Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab2EIRjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:39:16 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47836 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337Ab2EIRjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:39:08 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tim.bird@am.sony.com, tglx@linutronix.de, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/7] [RFC] UBI: Add checkpoint struct to ubi_device
Date: Wed,  9 May 2012 19:38:40 +0200
Message-Id: <1336585125-127220-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336585125-127220-1-git-send-email-richard@nod.at>
References: <1336585125-127220-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct ubi_checkpoint describes the currently used checkpoint.
Upon checkpoint recreation all currently used PEBs will be returned
to the wl subsystem.

struct ubi_cp_pool describes a checkpoint pool.
All PEBs within this pool have to be rescanned after reading the checkpoint.
The pools are needed to handle the three types of PEBs which can be obtained
from the wl subsystem.
Longterm, shortterm and unknown.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/ubi.h |   43 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index b162790..83fd308 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -196,6 +196,41 @@ struct ubi_rename_entry {
 
 struct ubi_volume_desc;
 
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+/**
+ * struct ubi_checkpoint - in-memory checkpoint data structure.
+ * @peb: PEBs used by the current checkpoint
+ * @ec: the erase counter of each used PEB
+ * @size: size of the checkpoint in bytes
+ * @used_blocks: number of used PEBs
+ */
+struct ubi_checkpoint {
+	int peb[UBI_CP_MAX_BLOCKS];
+	unsigned int ec[UBI_CP_MAX_BLOCKS];
+	size_t size;
+	int used_blocks;
+};
+
+/**
+ * struct ubi_cp_pool - in-memory checkpoint pool
+ * @pebs: PEBs in this pool
+ * @used: number of used PEBs
+ * @size: total number of PEBs in this pool
+ * @max_size: maximal size of the pool
+ *
+ * A pool gets filled with up to max_size.
+ * If all PEBs within the pool are used a new checkpoint
+ * will be written and the pool gets refilled with empty PEBs.
+ *
+ */
+struct ubi_cp_pool {
+	int pebs[UBI_CP_MAX_POOL_SIZE];
+	int used;
+	int size;
+	int max_size;
+};
+#endif
+
 /**
  * struct ubi_volume - UBI volume description data structure.
  * @dev: device object to make use of the the Linux device model
@@ -424,7 +459,13 @@ struct ubi_device {
 	spinlock_t ltree_lock;
 	struct rb_root ltree;
 	struct mutex alc_mutex;
-
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+	struct ubi_checkpoint *cp;
+	struct ubi_checkpoint *old_cp;
+	struct ubi_cp_pool long_pool;
+	struct ubi_cp_pool short_pool;
+	struct ubi_cp_pool unk_pool;
+#endif
 	/* Wear-leveling sub-system's stuff */
 	struct rb_root used;
 	struct rb_root erroneous;
-- 
1.7.6.5

