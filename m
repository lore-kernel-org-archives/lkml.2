Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab1CRAcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 20:32:48 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56465 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab1CRAco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 20:32:44 -0400
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] of: rework of_attach_node, removing CONFIG_OF_DYNAMIC
Date: Thu, 17 Mar 2011 17:32:33 -0700
Message-Id: <1300408356-15253-2-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300408356-15253-1-git-send-email-dilinger@queued.net>
References: <1300408356-15253-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the OF_DYNAMIC config option, which makes of_attach_node/of_detach_node
available without a specific config option.  CONFIG_OF_DYNAMIC wasn't actually
being used by anything, as the drivers which made use of of_attach_node
weren't depending upon or selecting it.

This also reworks of_attach_node to honor node ordering by time, rather than
creating the allnext/sibling list in reverse order.  This has a number of
ramifications worth mentioning:

 - 'last_child' is added to the device_node struct, and used to figure out
   where a node should be added in the tree.  This will take the place of
   the 'next' field.
 - 'allnodes' is no longer used.  It is assumed that the parent node is already
   attached to the tree.  What this really means is a simple assignment of
   "allnodes = root_node;" prior to calling of_attach_node(root_node).
 - The sibling list is guaranteed to retain order by insertion (later
   insertions showing up later in the list).
 - There are no similar guarantees for the allnext list with respect to
   parents, their children, and their siblings.  While siblings are
   guaranteed to be ordered by time, children may come before a sibling,
   or after.  That is, one ordering of the allnext list may be: "/", "/pci",
   "/isa", "/pci/foo", "/pci/bar".  Another perfectly valid ordering (and
   this *will* happen depending upon how insertions are done) is: "/",
   "/pci", "/pci/foo", "/pci/bar", "/isa".  The only thing that is
   guaranteed is that the sibling list will be "/pci", "/isa" (if "/isa"
   is added later), and that "/pci" will come before "/isa" in the allnext
   list.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/of/Kconfig |    4 ----
 drivers/of/base.c  |   47 ++++++++++++++++++++++++++++++++---------------
 include/linux/of.h |    5 ++---
 3 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index d06a637..ba90122 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -26,10 +26,6 @@ config OF_EARLY_FLATTREE
 config OF_PROMTREE
 	bool
 
-config OF_DYNAMIC
-	def_bool y
-	depends on PPC_OF
-
 config OF_ADDRESS
 	def_bool y
 	depends on !SPARC
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 710b53b..9e94267 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -849,27 +849,46 @@ int prom_update_property(struct device_node *np,
 	return 0;
 }
 
-#if defined(CONFIG_OF_DYNAMIC)
-/*
- * Support for dynamic device trees.
- *
- * On some platforms, the device tree can be manipulated at runtime.
- * The routines in this section support adding, removing and changing
- * device tree nodes.
- */
-
 /**
  * of_attach_node - Plug a device node into the tree and global list.
  */
 void of_attach_node(struct device_node *np)
 {
+	struct device_node *parent;
 	unsigned long flags;
 
+	parent = np->parent;
+	if (!parent)
+		return;
+
 	write_lock_irqsave(&devtree_lock, flags);
-	np->sibling = np->parent->child;
-	np->allnext = allnodes;
-	np->parent->child = np;
-	allnodes = np;
+	if (parent->child) {
+		/*
+		 * We have at least 1 sibling, and last_child points to the
+		 * last one that we've inserted.
+		 *
+		 * After insertion, the current node will be the last sibling
+		 * in the sibling list (maintaining tree order), but will come
+		 * before any siblings' children in the allnext list.  That
+		 * holds true so long as the device tree is generated in a
+		 * depth-first fashion.  Children added later may screw with
+		 * the allnext ordering, but siblings are always guaranteed to
+		 * remain in the order in which they were added.
+		 */
+		parent->last_child->sibling = np;
+		np->allnext = parent->last_child->allnext;
+		parent->last_child->allnext = np;
+
+	} else {
+		/*
+		 * This node is an only child.  Allnext descends into the
+		 * child nodes from the parent.
+		 */
+		parent->child = np;
+		np->allnext = parent->allnext;
+		parent->allnext = np;
+	}
+	parent->last_child = np;
 	write_unlock_irqrestore(&devtree_lock, flags);
 }
 
@@ -917,5 +936,3 @@ void of_detach_node(struct device_node *np)
 out_unlock:
 	write_unlock_irqrestore(&devtree_lock, flags);
 }
-#endif /* defined(CONFIG_OF_DYNAMIC) */
-
diff --git a/include/linux/of.h b/include/linux/of.h
index bfc0ed1..f398ecd 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -49,6 +49,7 @@ struct device_node {
 	struct	property *deadprops;	/* removed properties */
 	struct	device_node *parent;
 	struct	device_node *child;
+	struct	device_node *last_child; /* last to be added to a tree level*/
 	struct	device_node *sibling;
 	struct	device_node *next;	/* next device of same type */
 	struct	device_node *allnext;	/* next in list of all nodes */
@@ -221,11 +222,9 @@ extern int prom_update_property(struct device_node *np,
 				struct property *newprop,
 				struct property *oldprop);
 
-#if defined(CONFIG_OF_DYNAMIC)
-/* For updating the device tree at runtime */
+/* For updating the device tree */
 extern void of_attach_node(struct device_node *);
 extern void of_detach_node(struct device_node *);
-#endif
 
 #else
 
-- 
1.7.2.3

