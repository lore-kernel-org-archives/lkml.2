Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1CRAdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 20:33:14 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56482 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab1CRAcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 20:32:52 -0400
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] of/flattree: use of_attach_node to build tree
Date: Thu, 17 Mar 2011 17:32:36 -0700
Message-Id: <1300408356-15253-5-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300408356-15253-1-git-send-email-dilinger@queued.net>
References: <1300408356-15253-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a common function (of_attach_node) to build the device tree.  This
simplifies the flat device tree creation a bit, and as an added bonus allows
us to drop a (now unused) field from the device_node struct.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/of/fdt.c   |   35 ++++++++++++++---------------------
 include/linux/of.h |    1 -
 2 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index c9db49c..2487356 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -142,14 +142,14 @@ static void *unflatten_dt_alloc(unsigned long *mem, unsigned long size,
  * @mem: Memory chunk to use for allocating device nodes and properties
  * @p: pointer to node in flat tree
  * @dad: Parent struct device_node
- * @allnextpp: pointer to ->allnext from last allocated device_node
+ * @rootp: tree's root node pointer
  * @fpsize: Size of the node path up at the current depth.
  */
 static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 				unsigned long mem,
 				unsigned long *p,
 				struct device_node *dad,
-				struct device_node ***allnextpp,
+				struct device_node **rootp,
 				unsigned long fpsize)
 {
 	struct device_node *np;
@@ -196,7 +196,7 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 
 	np = unflatten_dt_alloc(&mem, sizeof(struct device_node) + allocl,
 				__alignof__(struct device_node));
-	if (allnextpp) {
+	if (rootp) {
 		memset(np, 0, sizeof(*np));
 		np->full_name = ((char *)np) + sizeof(struct device_node);
 		if (new_format) {
@@ -218,17 +218,7 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
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
 	/* process properties */
@@ -260,7 +250,7 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 		l = strlen(pname) + 1;
 		pp = unflatten_dt_alloc(&mem, sizeof(struct property),
 					__alignof__(struct property));
-		if (allnextpp) {
+		if (rootp) {
 			/* We accept flattened tree phandles either in
 			 * ePAPR-style "phandle" properties, or the
 			 * legacy "linux,phandle" properties.  If both
@@ -303,7 +293,7 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 		sz = (pa - ps) + 1;
 		pp = unflatten_dt_alloc(&mem, sizeof(struct property) + sz,
 					__alignof__(struct property));
-		if (allnextpp) {
+		if (rootp) {
 			pp->name = "name";
 			pp->length = sz;
 			pp->value = pp + 1;
@@ -315,7 +305,7 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 				(char *)pp->value);
 		}
 	}
-	if (allnextpp) {
+	if (rootp) {
 		*prev_pp = NULL;
 		np->name = of_get_property(np, "name", NULL);
 		np->type = of_get_property(np, "device_type", NULL);
@@ -324,12 +314,17 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 			np->name = "<NULL>";
 		if (!np->type)
 			np->type = "<NULL>";
+		of_attach_node(np);
+
+		/* if no parent, then we're looking at the root node */
+		if (!np->parent)
+			*rootp = np;
 	}
 	while (tag == OF_DT_BEGIN_NODE || tag == OF_DT_NOP) {
 		if (tag == OF_DT_NOP)
 			*p += 4;
 		else
-			mem = unflatten_dt_node(blob, mem, p, np, allnextpp,
+			mem = unflatten_dt_node(blob, mem, p, np, rootp,
 						fpsize);
 		tag = be32_to_cpup((__be32 *)(*p));
 	}
@@ -358,7 +353,6 @@ static void __unflatten_device_tree(struct boot_param_header *blob,
 			     void * (*dt_alloc)(u64 size, u64 align))
 {
 	unsigned long start, mem, size;
-	struct device_node **allnextp = mynodes;
 
 	pr_debug(" -> unflatten_device_tree()\n");
 
@@ -396,13 +390,12 @@ static void __unflatten_device_tree(struct boot_param_header *blob,
 	/* Second pass, do actual unflattening */
 	start = ((unsigned long)blob) +
 		be32_to_cpu(blob->off_dt_struct);
-	unflatten_dt_node(blob, mem, &start, NULL, &allnextp, 0);
+	unflatten_dt_node(blob, mem, &start, NULL, mynodes, 0);
 	if (be32_to_cpup((__be32 *)start) != OF_DT_END)
 		pr_warning("Weird tag at end of tree: %08x\n", *((u32 *)start));
 	if (be32_to_cpu(((__be32 *)mem)[size / 4]) != 0xdeadbeef)
 		pr_warning("End of tree marker overwritten: %08x\n",
 			   be32_to_cpu(((__be32 *)mem)[size / 4]));
-	*allnextp = NULL;
 
 	pr_debug(" <- unflatten_device_tree()\n");
 }
diff --git a/include/linux/of.h b/include/linux/of.h
index f398ecd..58ef067 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -51,7 +51,6 @@ struct device_node {
 	struct	device_node *child;
 	struct	device_node *last_child; /* last to be added to a tree level*/
 	struct	device_node *sibling;
-	struct	device_node *next;	/* next device of same type */
 	struct	device_node *allnext;	/* next in list of all nodes */
 	struct	proc_dir_entry *pde;	/* this node's proc directory */
 	struct	kref kref;
-- 
1.7.2.3

