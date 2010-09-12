Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab0ILPzb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 11:55:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:64996 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab0ILPzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 11:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,355,1280732400"; 
   d="scan'208";a="606204419"
Message-Id: <20100912155205.108097852@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 12 Sep 2010 23:50:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Li Shaohua <shaohua.li@intel.com>
Subject: [PATCH 16/17] mm: create /vm/dirty_pressure in debugfs
References: <20100912154945.758129106@intel.com>
Content-Disposition: inline; filename=mm-debugfs-dirty-pressure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create /debug/vm/ -- a convenient place for kernel hackers to play with
VM variables.

The first exported is vm_dirty_pressure for avoiding excessive pageout()s.
It ranges from 0 to 1024, the lower value, the lower dirty limit.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/vmstat.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

--- linux-next.orig/mm/vmstat.c	2010-09-12 09:50:57.000000000 +0800
+++ linux-next/mm/vmstat.c	2010-09-12 13:27:44.000000000 +0800
@@ -1045,9 +1045,33 @@ static int __init setup_vmstat(void)
 }
 module_init(setup_vmstat)
 
-#if defined(CONFIG_DEBUG_FS) && defined(CONFIG_COMPACTION)
+#if defined(CONFIG_DEBUG_FS)
 #include <linux/debugfs.h>
+#include <linux/writeback.h>
 
+static struct dentry *vm_debug_root;
+
+static int __init vm_debug_init(void)
+{
+	struct dentry *dentry;
+
+	vm_debug_root = debugfs_create_dir("vm", NULL);
+	if (!vm_debug_root)
+		goto fail;
+
+	dentry = debugfs_create_u32("dirty_pressure", 0644,
+				    vm_debug_root, &vm_dirty_pressure);
+	if (!dentry)
+		goto fail;
+
+	return 0;
+fail:
+	return -ENOMEM;
+}
+
+module_init(vm_debug_init);
+
+#if defined(CONFIG_COMPACTION)
 static struct dentry *extfrag_debug_root;
 
 /*
@@ -1202,4 +1226,5 @@ static int __init extfrag_debug_init(voi
 }
 
 module_init(extfrag_debug_init);
-#endif
+#endif /* CONFIG_COMPACTION */
+#endif /* CONFIG_DEBUG_FS */


