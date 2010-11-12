Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab0KLL2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:28:34 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:58782 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755743Ab0KLL2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:28:33 -0500
Subject: [PATCH/RFC] MM slub: add a sysfs entry to show the calculated
 number of fallback slabs
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 11:28:29 +0000
Message-ID: <1289561309.1972.30.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a slub sysfs entry to show the calculated number of fallback slabs.

Using the information already available it is straightforward to
calculate the number of fallback & full size slabs. We can then track
which slabs are particularly effected by memory fragmentation and how
long they take to recover. 

There is no change to the mainline code, the calculation is only
performed on request, and the value is available without having to
enable CONFIG_SLUB_STATS.  

Note that this could give the wrong value if the user changes the slab
order via the sysfs interface.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---


As we have the information needed to do this calculation is seem useful
to expose it and provide another way to understand what is happening
inside the memory manager.

On my desktop workloads (kernel compile etc) I'm seeing surprisingly
little slab fragmentation. Do you have any suggestions for test cases
that will fragment the memory?

I copied the code to count the total objects from the slabinfo s_show
function, but as I don't need the partial count I didn't extract it into
a helper function.

regards
Richard
 

diff --git a/mm/slub.c b/mm/slub.c
index 8fd5401..8c79eaa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4043,6 +4043,46 @@ static ssize_t destroy_by_rcu_show(struct kmem_cache *s, char *buf)
 }
 SLAB_ATTR_RO(destroy_by_rcu);
 
+/* The number of fallback slabs can be calculated to give an
+ * indication of how fragmented this slab is.
+ * This is a snapshot of the current makeup of this cache.
+ *
+ *  Given
+ *
+ *  total_objects = (nr_fallback_slabs * objects_per_fallback_slab) +
+ *     ( nr_normal_slabs * objects_per_slab)
+ *  and
+ *  nr_slabs = nr_normal_slabs + nr_fallback_slabs
+ *
+ * then we can easily calculate nr_fallback_slabs.
+ *
+ * Note that this can give the wrong answer if the user has changed the
+ * order of this slab via sysfs.
+ */
+
+static ssize_t fallback_show(struct kmem_cache *s, char *buf)
+{
+	unsigned long nr_objects = 0;
+	unsigned long nr_slabs = 0;
+	unsigned long nr_fallback = 0;
+	unsigned long acc;
+	int node;
+
+	if (oo_order(s->oo) != oo_order(s->min)) {
+		for_each_online_node(node) {
+			struct kmem_cache_node *n = get_node(s, node);
+			nr_slabs += atomic_long_read(&n->nr_slabs);
+			nr_objects += atomic_long_read(&n->total_objects);
+		}
+		acc = nr_objects - nr_slabs * oo_objects(s->min);
+		acc /= (oo_objects(s->oo) - oo_objects(s->min));
+		nr_fallback = nr_slabs - acc;
+	}
+	return sprintf(buf, "%lu\n", nr_fallback);
+}
+SLAB_ATTR_RO(fallback);
+
+
 #ifdef CONFIG_SLUB_DEBUG
 static ssize_t slabs_show(struct kmem_cache *s, char *buf)
 {
@@ -4329,6 +4369,7 @@ static struct attribute *slab_attrs[] = {
 	&reclaim_account_attr.attr,
 	&destroy_by_rcu_attr.attr,
 	&shrink_attr.attr,
+	&fallback_attr.attr,
 #ifdef CONFIG_SLUB_DEBUG
 	&total_objects_attr.attr,
 	&slabs_attr.attr,


