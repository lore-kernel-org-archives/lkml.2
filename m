Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1CJAQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:16:23 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43649 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab1CJAQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:16:21 -0500
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] of/flattree: use of_attach_node to build tree, and associated cleanups
Date: Wed,  9 Mar 2011 16:16:07 -0800
Message-Id: <1299716167-9656-4-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299716167-9656-1-git-send-email-dilinger@queued.net>
References: <1299716167-9656-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a common function (of_attach_node) to build the device tree.  This
simplifies the flat device tree creation a bit, and as an added bonus allows
us to drop a (now unused) field from the device_node struct.

There are a few minor cleanups snuck in here as well (comment additions, etc).

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/of/fdt.c   |   42 ++++++++++++++++--------------------------
 include/linux/of.h |    1 -
 2 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index af824e7..e70cee8 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -139,16 +139,17 @@ static void *unflatten_dt_alloc(unsigned long *mem, unsigned long size,
 /**
  * unflatten_dt_node - Alloc and populate a device_node from the flat tree
  * @blob: The parent device tree blob
+ * @mem: memory chunk to use for allocating device nodes and properties
  * @p: pointer to node in flat tree
  * @dad: Parent struct device_node
- * @allnextpp: pointer to ->allnext from last allocated device_node
+ * @size_scan: are we figuring out amount of memory to allocate?
  * @fpsize: Size of the node path up at the current depth.
  */
 unsigned long unflatten_dt_node(struct boot_param_header *blob,
 				unsigned long mem,
 				unsigned long *p,
 				struct device_node *dad,
-				struct device_node ***allnextpp,
+				bool size_scan,
 				unsigned long fpsize)
 {
 	struct device_node *np;
@@ -195,7 +196,7 @@ unsigned long unflatten_dt_node(struct boot_param_header *blob,
 
 	np = unflatten_dt_alloc(&mem, sizeof(struct device_node) + allocl,
 				__alignof__(struct device_node));
-	if (allnextpp) {
+	if (!size_scan) {
 		memset(np, 0, sizeof(*np));
 		np->full_name = ((char *)np) + sizeof(struct device_node);
 		if (new_format) {
@@ -217,19 +218,10 @@ unsigned long unflatten_dt_node(struct boot_param_header *blob,
 		} else
 			memcpy(np->full_name, pathp, l);
 		prev_pp = &np->properties;
-		**allnextpp = np;
-		*allnextpp = &np->allnext;
-		if (dad != NULL) {
-			np->parent = dad;
-			/* we temporarily use the next field as `last_child'*/
-			if (dad->next == NULL)
-				dad->child = np;
-			else
-				dad->next->sibling = np;
-			dad->next = np;
-		}
+		np->parent = dad;
 		kref_init(&np->kref);
 	}
+	/* process properties */
 	while (1) {
 		u32 sz, noff;
 		char *pname;
@@ -258,7 +250,7 @@ unsigned long unflatten_dt_node(struct boot_param_header *blob,
 		l = strlen(pname) + 1;
 		pp = unflatten_dt_alloc(&mem, sizeof(struct property),
 					__alignof__(struct property));
-		if (allnextpp) {
+		if (!size_scan) {
 			/* We accept flattened tree phandles either in
 			 * ePAPR-style "phandle" properties, or the
 			 * legacy "linux,phandle" properties.  If both
@@ -301,7 +293,7 @@ unsigned long unflatten_dt_node(struct boot_param_header *blob,
 		sz = (pa - ps) + 1;
 		pp = unflatten_dt_alloc(&mem, sizeof(struct property) + sz,
 					__alignof__(struct property));
-		if (allnextpp) {
+		if (!size_scan) {
 			pp->name = "name";
 			pp->length = sz;
 			pp->value = pp + 1;
@@ -313,7 +305,7 @@ unsigned long unflatten_dt_node(struct boot_param_header *blob,
 				(char *)pp->value);
 		}
 	}
-	if (allnextpp) {
+	if (!size_scan) {
 		*prev_pp = NULL;
 		np->name = of_get_property(np, "name", NULL);
 		np->type = of_get_property(np, "device_type", NULL);
@@ -322,12 +314,14 @@ unsigned long unflatten_dt_node(struct boot_param_header *blob,
 			np->name = "<NULL>";
 		if (!np->type)
 			np->type = "<NULL>";
+
+		of_attach_node(np);
 	}
 	while (tag == OF_DT_BEGIN_NODE || tag == OF_DT_NOP) {
 		if (tag == OF_DT_NOP)
 			*p += 4;
 		else
-			mem = unflatten_dt_node(blob, mem, p, np, allnextpp,
+			mem = unflatten_dt_node(blob, mem, p, np, size_scan,
 						fpsize);
 		tag = be32_to_cpup((__be32 *)(*p));
 	}
@@ -347,16 +341,13 @@ unsigned long unflatten_dt_node(struct boot_param_header *blob,
  * pointers of the nodes so the normal device-tree walking functions
  * can be used.
  * @blob: The blob to expand
- * @mynodes: The device_node tree created by the call
  * @dt_alloc: An allocator that provides a virtual address to memory
  * for the resulting tree
  */
 void __unflatten_device_tree(struct boot_param_header *blob,
-			     struct device_node **mynodes,
 			     void * (*dt_alloc)(u64 size, u64 align))
 {
 	unsigned long start, mem, size;
-	struct device_node **allnextp = mynodes;
 
 	pr_debug(" -> unflatten_device_tree()\n");
 
@@ -378,7 +369,7 @@ void __unflatten_device_tree(struct boot_param_header *blob,
 	/* First pass, scan for size */
 	start = ((unsigned long)blob) +
 		be32_to_cpu(blob->off_dt_struct);
-	size = unflatten_dt_node(blob, 0, &start, NULL, NULL, 0);
+	size = unflatten_dt_node(blob, 0, &start, NULL, true, 0);
 	size = (size | 3) + 1;
 
 	pr_debug("  size is %lx, allocating...\n", size);
@@ -394,13 +385,12 @@ void __unflatten_device_tree(struct boot_param_header *blob,
 	/* Second pass, do actual unflattening */
 	start = ((unsigned long)blob) +
 		be32_to_cpu(blob->off_dt_struct);
-	unflatten_dt_node(blob, mem, &start, NULL, &allnextp, 0);
+	unflatten_dt_node(blob, mem, &start, NULL, false, 0);
 	if (be32_to_cpup((__be32 *)start) != OF_DT_END)
 		pr_warning("Weird tag at end of tree: %08x\n", *((u32 *)start));
 	if (be32_to_cpu(((__be32 *)mem)[size / 4]) != 0xdeadbeef)
 		pr_warning("End of tree marker overwritten: %08x\n",
 			   be32_to_cpu(((__be32 *)mem)[size / 4]));
-	*allnextp = NULL;
 
 	pr_debug(" <- unflatten_device_tree()\n");
 }
@@ -423,7 +413,7 @@ void of_fdt_unflatten_tree(unsigned long *blob,
 {
 	struct boot_param_header *device_tree =
 		(struct boot_param_header *)blob;
-	__unflatten_device_tree(device_tree, mynodes, &kernel_tree_alloc);
+	__unflatten_device_tree(device_tree, &kernel_tree_alloc);
 }
 EXPORT_SYMBOL_GPL(of_fdt_unflatten_tree);
 
@@ -702,7 +692,7 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
  */
 void __init unflatten_device_tree(void)
 {
-	__unflatten_device_tree(initial_boot_params, &allnodes,
+	__unflatten_device_tree(initial_boot_params,
 				early_init_dt_alloc_memory_arch);
 
 	/* Get pointer to OF "/chosen" node for use everywhere */
diff --git a/include/linux/of.h b/include/linux/of.h
index bb36473..95754ca 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -50,7 +50,6 @@ struct device_node {
 	struct	device_node *parent;
 	struct	device_node *child;
 	struct	device_node *sibling;
-	struct	device_node *next;	/* next device of same type */
 	struct	device_node *allnext;	/* next in list of all nodes */
 	struct	proc_dir_entry *pde;	/* this node's proc directory */
 	struct	kref kref;
-- 
1.7.2.3

