Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934871Ab0HFFSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:18:42 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41687 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933784Ab0HFFPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:36 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 36/43] memblock: Add debugfs files to dump the arrays content
Date: Fri,  6 Aug 2010 15:15:17 +1000
Message-Id: <1281071724-28740-37-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 9de5fcd..cc15be2 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -16,6 +16,8 @@
 #include <linux/bitops.h>
 #include <linux/poison.h>
 #include <linux/pfn.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 #include <linux/memblock.h>
 
 struct memblock memblock;
@@ -740,3 +742,52 @@ static int __init early_memblock(char *p)
 }
 early_param("memblock", early_memblock);
 
+#ifdef CONFIG_DEBUG_FS
+
+static int memblock_debug_show(struct seq_file *m, void *private)
+{
+	struct memblock_type *type = m->private;
+	struct memblock_region *reg;
+	int i;
+
+	for (i = 0; i < type->cnt; i++) {
+		reg = &type->regions[i];
+		seq_printf(m, "%4d: ", i);
+		if (sizeof(phys_addr_t) == 4)
+			seq_printf(m, "0x%08lx..0x%08lx\n",
+				   (unsigned long)reg->base,
+				   (unsigned long)(reg->base + reg->size - 1));
+		else
+			seq_printf(m, "0x%016llx..0x%016llx\n",
+				   (unsigned long long)reg->base,
+				   (unsigned long long)(reg->base + reg->size - 1));
+
+	}
+	return 0;
+}
+
+static int memblock_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, memblock_debug_show, inode->i_private);
+}
+
+static const struct file_operations memblock_debug_fops = {
+	.open = memblock_debug_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int __init memblock_init_debugfs(void)
+{
+	struct dentry *root = debugfs_create_dir("memblock", NULL);
+	if (!root)
+		return -ENXIO;
+	debugfs_create_file("memory", S_IRUGO, root, &memblock.memory, &memblock_debug_fops);
+	debugfs_create_file("reserved", S_IRUGO, root, &memblock.reserved, &memblock_debug_fops);
+
+	return 0;
+}
+__initcall(memblock_init_debugfs);
+
+#endif /* CONFIG_DEBUG_FS */
-- 
1.7.0.4

