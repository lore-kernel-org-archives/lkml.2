Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab0GFWnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 18:43:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31859 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab0GFWnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 18:43:50 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 26/49] memblock: Add debugfs files to dump the arrays content
Date: Tue,  6 Jul 2010 15:39:19 -0700
Message-Id: <1278455982-24621-27-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
References: <1278455982-24621-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C33B171.023B,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 00f62a2..c71b847 100644
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
@@ -705,3 +707,52 @@ static int __init early_memblock(char *p)
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
1.6.4.2

