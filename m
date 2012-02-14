Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761123Ab2BNUzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:55:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:51570 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760766Ab2BNUy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:54:59 -0500
From: Richard Weinberger <rw@linutronix.de>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, tim.bird@am.sony.com,
        dedekind1@gmail.com, Richard Weinberger <rw@linutronix.de>
Subject: [RFC][PATCH 2/7] MTD: UBI: Add checkpoint struct to ubi_device
Date: Tue, 14 Feb 2012 21:06:41 +0100
Message-Id: <1329250006-22944-3-git-send-email-rw@linutronix.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1329250006-22944-1-git-send-email-rw@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
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

Signed-off-by: Richard Weinberger <rw@linutronix.de>
---
 drivers/mtd/ubi/ubi.h |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index d51d75d..4fe3638 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -196,6 +196,22 @@ struct ubi_rename_entry {
 
 struct ubi_volume_desc;
 
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+struct ubi_checkpoint {
+	int peb[UBI_CP_MAX_BLOCKS];
+	unsigned int ec[UBI_CP_MAX_BLOCKS];
+	size_t size;
+	int used_blocks;
+};
+
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
@@ -425,7 +441,12 @@ struct ubi_device {
 	spinlock_t ltree_lock;
 	struct rb_root ltree;
 	struct mutex alc_mutex;
-
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+	struct ubi_checkpoint *cp;
+	struct ubi_cp_pool long_pool;
+	struct ubi_cp_pool short_pool;
+	struct ubi_cp_pool unk_pool;
+#endif
 	/* Wear-leveling sub-system's stuff */
 	struct rb_root used;
 	struct rb_root erroneous;
-- 
1.7.7

