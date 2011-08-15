Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab1HOBQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 21:16:41 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64624 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1HOBQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 21:16:40 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        David Miller <davem@davemloft.net>, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] dt: add of_alias_scan and of_alias_get_id
Date: Mon, 15 Aug 2011 09:30:17 +0800
Message-Id: <1313371817-5135-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds function of_alias_scan to populate a global lookup
table with the properties of 'aliases' node and function
of_alias_get_id for drivers to find alias id from the lookup table.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
[grant.likey: add locking and rework parse loop]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
Changes since the last post:
 * Pass alloc function pointer as a parameter to of_alias_scan()
 * Move of_chosen and of_aliases populating into function
   __unflatten_device_tree which is the common path of two
   unflattening sites
 * Change simple_strtoul() to kstrtoint() which is suggestion by
   checkpatch as a warning

 drivers/of/base.c      |  136 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/of/fdt.c       |   12 +++--
 include/linux/of.h     |    8 +++
 include/linux/of_fdt.h |    1 -
 4 files changed, 151 insertions(+), 6 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 3ff22e3..5e6ce02 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -17,14 +17,39 @@
  *      as published by the Free Software Foundation; either version
  *      2 of the License, or (at your option) any later version.
  */
+#include <linux/ctype.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 
+/**
+ * struct alias_prop - Alias property in 'aliases' node
+ * @link:	List node to link the structure in aliases_lookup list
+ * @alias:	Alias property name
+ * @np:		Pointer to device_node that the alias stands for
+ * @id:		Index value from end of alias name
+ * @stem:	Alias string without the index
+ *
+ * The structure represents one alias property of 'aliases' node as
+ * an entry in aliases_lookup list.
+ */
+struct alias_prop {
+	struct list_head link;
+	const char *alias;
+	struct device_node *np;
+	int id;
+	char stem[0];
+};
+
+static LIST_HEAD(aliases_lookup);
+
 struct device_node *allnodes;
 struct device_node *of_chosen;
+struct device_node *of_aliases;
+
+static DEFINE_MUTEX(of_aliases_mutex);
 
 /* use when traversing tree through the allnext, child, sibling,
  * or parent members of struct device_node.
@@ -988,3 +1013,114 @@ out_unlock:
 }
 #endif /* defined(CONFIG_OF_DYNAMIC) */
 
+static void of_alias_add(struct alias_prop *ap, struct device_node *np,
+			 int id, const char *stem, int stem_len)
+{
+	ap->np = np;
+	ap->id = id;
+	strncpy(ap->stem, stem, stem_len);
+	ap->stem[stem_len] = 0;
+	list_add_tail(&ap->link, &aliases_lookup);
+	pr_debug("adding DT alias:%s: stem=%s id=%i node=%s\n",
+		 ap->alias, ap->stem, ap->id, np ? np->full_name : NULL);
+}
+
+/**
+ * of_alias_scan - Scan all properties of 'aliases' node
+ *
+ * The function scans all the properties of 'aliases' node and populate
+ * the the global lookup table with the properties.  It returns the
+ * number of alias_prop found, or error code in error case.
+ *
+ * @dt_alloc:	An allocator that provides a virtual address to memory
+ *		for the resulting tree
+ */
+void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
+{
+	struct property *pp;
+
+	if (!of_aliases)
+		return;
+
+	for_each_property(pp, of_aliases->properties) {
+		const char *start = pp->name;
+		const char *end = start + strlen(start);
+		struct device_node *np;
+		struct alias_prop *ap;
+		int id, len;
+
+		/* Skip those we do not want to proceed */
+		if (!strcmp(pp->name, "name") ||
+		    !strcmp(pp->name, "phandle") ||
+		    !strcmp(pp->name, "linux,phandle"))
+			continue;
+
+		np = of_find_node_by_path(pp->value);
+		if (!np)
+			continue;
+
+		/* walk the alias backwards to extract the id and work out
+		 * the 'stem' string */
+		while (isdigit(*(end-1)) && end > start)
+			end--;
+		len = end - start;
+
+		if (kstrtoint(end, 10, &id) < 0)
+			continue;
+
+		/* Allocate an alias_prop with enough space for the stem */
+		ap = dt_alloc(sizeof(*ap) + len + 1, 4);
+		if (!ap)
+			continue;
+		ap->alias = start;
+		of_alias_add(ap, np, id, start, len);
+	}
+}
+
+/**
+ * of_alias_get_id - Get alias id for the given device_node
+ * @np:		Pointer to the given device_node
+ * @stem:	Alias stem of the given device_node
+ *
+ * The function travels the lookup table to get alias id for the given
+ * device_node and alias stem.  It returns the alias id if find it.
+ * If not, dynamically creates one in the lookup table and returns it,
+ * or returns error code if fail to create.
+ */
+int of_alias_get_id(struct device_node *np, const char *stem)
+{
+	struct alias_prop *app;
+	int id = 0;
+	bool found = false;
+
+	mutex_lock(&of_aliases_mutex);
+	list_for_each_entry(app, &aliases_lookup, link) {
+		if (strcmp(app->stem, stem) != 0)
+			continue;
+
+		if (np == app->np) {
+			found = true;
+			id = app->id;
+			break;
+		}
+
+		if (id <= app->id)
+			id = app->id + 1;
+	}
+
+	/* If an id is not found, then allocate a new one */
+	if (!found) {
+		app = kzalloc(sizeof(*app) + strlen(stem) + 1, 4);
+		if (!app) {
+			id = -ENODEV;
+			goto out;
+		}
+		of_alias_add(app, np, id, stem, strlen(stem));
+	}
+
+ out:
+	mutex_unlock(&of_aliases_mutex);
+
+	return id;
+}
+EXPORT_SYMBOL_GPL(of_alias_get_id);
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 65200af..98b6fb1 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -404,6 +404,13 @@ static void __unflatten_device_tree(struct boot_param_header *blob,
 			   be32_to_cpu(((__be32 *)mem)[size / 4]));
 	*allnextp = NULL;
 
+	/* Get pointer to "/chosen" and "/aliasas" nodes for use everywhere */
+	of_chosen = of_find_node_by_path("/chosen");
+	if (of_chosen == NULL)
+		of_chosen = of_find_node_by_path("/chosen@0");
+	of_aliases = of_find_node_by_path("/aliases");
+	of_alias_scan(dt_alloc);
+
 	pr_debug(" <- unflatten_device_tree()\n");
 }
 
@@ -706,11 +713,6 @@ void __init unflatten_device_tree(void)
 {
 	__unflatten_device_tree(initial_boot_params, &allnodes,
 				early_init_dt_alloc_memory_arch);
-
-	/* Get pointer to OF "/chosen" node for use everywhere */
-	of_chosen = of_find_node_by_path("/chosen");
-	if (of_chosen == NULL)
-		of_chosen = of_find_node_by_path("/chosen@0");
 }
 
 #endif /* CONFIG_OF_EARLY_FLATTREE */
diff --git a/include/linux/of.h b/include/linux/of.h
index 9180dc5..4ea7d81 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -68,6 +68,7 @@ struct device_node {
 /* Pointer for first entry in chain of all nodes. */
 extern struct device_node *allnodes;
 extern struct device_node *of_chosen;
+extern struct device_node *of_aliases;
 extern rwlock_t devtree_lock;
 
 static inline bool of_have_populated_dt(void)
@@ -209,6 +210,9 @@ extern int of_device_is_available(const struct device_node *device);
 extern const void *of_get_property(const struct device_node *node,
 				const char *name,
 				int *lenp);
+#define for_each_property(pp, properties) \
+	for (pp = properties; pp != NULL; pp = pp->next)
+
 extern int of_n_addr_cells(struct device_node *np);
 extern int of_n_size_cells(struct device_node *np);
 extern const struct of_device_id *of_match_node(
@@ -221,6 +225,10 @@ extern int of_parse_phandles_with_args(struct device_node *np,
 	const char *list_name, const char *cells_name, int index,
 	struct device_node **out_node, const void **out_args);
 
+extern void *early_init_dt_alloc_memory_arch(u64 size, u64 align);
+extern void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align));
+extern int of_alias_get_id(struct device_node *np, const char *stem);
+
 extern int of_machine_is_compatible(const char *compat);
 
 extern int prom_add_property(struct device_node* np, struct property* prop);
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index c84d900..b74b74f 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -97,7 +97,6 @@ extern void early_init_dt_check_for_initrd(unsigned long node);
 extern int early_init_dt_scan_memory(unsigned long node, const char *uname,
 				     int depth, void *data);
 extern void early_init_dt_add_memory_arch(u64 base, u64 size);
-extern void * early_init_dt_alloc_memory_arch(u64 size, u64 align);
 extern u64 dt_mem_next_cell(int s, __be32 **cellp);
 
 /*
-- 
1.7.4.1

