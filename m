Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab2JSOWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:22:45 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:27500 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758900Ab2JSOWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:22:31 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-mm@kvack.org>
Cc: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, <devel@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH v5 02/18] move print_slabinfo_header to slab_common.c
Date: Fri, 19 Oct 2012 18:20:26 +0400
Message-Id: <1350656442-1523-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1350656442-1523-1-git-send-email-glommer@parallels.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com>
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
index e35970a..864a9e9 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4262,30 +4262,6 @@ out:
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
index 4156d21..e9ba23f 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -74,8 +74,6 @@ int __kmem_cache_shutdown(struct kmem_cache *);
 
 struct seq_file;
 struct file;
-void print_slabinfo_header(struct seq_file *m);
-
 int slabinfo_show(struct seq_file *m, void *p);
 
 ssize_t slabinfo_write(struct file *file, const char __user *buffer,
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 11ecab4..bb4d751 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -200,6 +200,29 @@ int slab_is_available(void)
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
index 55304ed..91e1f3b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5394,16 +5394,6 @@ __initcall(slab_sysfs_init);
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
1.7.11.7

