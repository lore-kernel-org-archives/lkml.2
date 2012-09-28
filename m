Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab2I1PGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:06:53 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:22688 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758358Ab2I1PGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:06:51 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Glauber Costa <glommer@parallels.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v2 2/3] move print_slabinfo_header to slab_common.c
Date: Fri, 28 Sep 2012 19:03:27 +0400
Message-Id: <1348844608-12568-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348844608-12568-1-git-send-email-glommer@parallels.com>
References: <1348844608-12568-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header format is highly similar between slab and slub. The main
difference lays in the fact that slab may optionally have statistics
added here in case of CONFIG_SLAB_DEBUG, while the slub will stick them
somewhere else.

By making sure that information conditionally lives inside a
globally-visible CONFIG_DEBUG_SLAB switch, we can move the header
printing to a common location.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>
CC: David Rientjes <rientjes@google.com>
---
 mm/slab.c        | 24 ------------------------
 mm/slab.h        |  2 --
 mm/slab_common.c | 23 +++++++++++++++++++++++
 mm/slub.c        | 10 ----------
 4 files changed, 23 insertions(+), 36 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 9502dfc..a3de3e5 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4283,30 +4283,6 @@ out:
 }
 
 #ifdef CONFIG_SLABINFO
-
-void print_slabinfo_header(struct seq_file *m)
-{
-	/*
-	 * Output format version, so at least we can change it
-	 * without _too_ many complaints.
-	 */
-#if STATS
-	seq_puts(m, "slabinfo - version: 2.1 (statistics)\n");
-#else
-	seq_puts(m, "slabinfo - version: 2.1\n");
-#endif
-	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> "
-		 "<objperslab> <pagesperslab>");
-	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
-	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
-#if STATS
-	seq_puts(m, " : globalstat <listallocs> <maxobjs> <grown> <reaped> "
-		 "<error> <maxfreeable> <nodeallocs> <remotefrees> <alienoverflow>");
-	seq_puts(m, " : cpustat <allochit> <allocmiss> <freehit> <freemiss>");
-#endif
-	seq_putc(m, '\n');
-}
-
 int slabinfo_show(struct seq_file *m, void *p)
 {
 	struct kmem_cache *cachep = list_entry(p, struct kmem_cache, list);
diff --git a/mm/slab.h b/mm/slab.h
index dc78101..3442eb8 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -49,8 +49,6 @@ int __kmem_cache_shutdown(struct kmem_cache *);
 
 struct seq_file;
 struct file;
-void print_slabinfo_header(struct seq_file *m);
-
 int slabinfo_show(struct seq_file *m, void *p);
 
 ssize_t slabinfo_write(struct file *file, const char __user *buffer,
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 2e0061a..fc12d7d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -193,6 +193,29 @@ int slab_is_available(void)
 }
 
 #ifdef CONFIG_SLABINFO
+static void print_slabinfo_header(struct seq_file *m)
+{
+	/*
+	 * Output format version, so at least we can change it
+	 * without _too_ many complaints.
+	 */
+#ifdef CONFIG_DEBUG_SLAB
+	seq_puts(m, "slabinfo - version: 2.1 (statistics)\n");
+#else
+	seq_puts(m, "slabinfo - version: 2.1\n");
+#endif
+	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> "
+		 "<objperslab> <pagesperslab>");
+	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
+	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
+#ifdef CONFIG_DEBUG_SLAB
+	seq_puts(m, " : globalstat <listallocs> <maxobjs> <grown> <reaped> "
+		 "<error> <maxfreeable> <nodeallocs> <remotefrees> <alienoverflow>");
+	seq_puts(m, " : cpustat <allochit> <allocmiss> <freehit> <freemiss>");
+#endif
+	seq_putc(m, '\n');
+}
+
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
 	loff_t n = *pos;
diff --git a/mm/slub.c b/mm/slub.c
index 6383622..4c2c092 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5392,16 +5392,6 @@ __initcall(slab_sysfs_init);
  * The /proc/slabinfo ABI
  */
 #ifdef CONFIG_SLABINFO
-void print_slabinfo_header(struct seq_file *m)
-{
-	seq_puts(m, "slabinfo - version: 2.1\n");
-	seq_puts(m, "# name            <active_objs> <num_objs> <object_size> "
-		 "<objperslab> <pagesperslab>");
-	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
-	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
-	seq_putc(m, '\n');
-}
-
 int slabinfo_show(struct seq_file *m, void *p)
 {
 	unsigned long nr_partials = 0;
-- 
1.7.11.4

