Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0LPQ2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:28:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:34974 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0LPQ2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:28:36 -0500
MIME-Version: 1.0
Message-ID: <62b1cf2f-17ec-45c9-a980-308d9b75cdc5@default>
Date: Thu, 16 Dec 2010 08:27:41 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: dan.magenheimer@oracle.com
Subject: [RFC] radix_tree_destroy?
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6539.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am in need of a radix-tree routine that will efficiently
"destroy" an entire radix tree, but make callbacks to free the
slots.  Is it possible to do that (efficiently) with existing
radix-tree code?  If so, I'd appreciate some guidance.

If not, I'm thinking about submitting a patch (as part of a
larger patchset) that would look something like the patch below.
I'm uncertain of the rcu implications however... because
of the mass destruction, perhaps there could just be a
requirement that the caller must lock the entire tree
prior to the call?

Another option would be for me to do this outside of
radix-tree.c, but then I would need to move some defines and
the definition of the struct radix_tree_node from
radix-tree.c to radix-tree.h

Thanks for any advice!
Dan

P.S. I will be offline for an extended period over the holidays,
so apologies in advance if I am unable to respond quickly.

--- radix-tree.c	2010-10-20 14:30:22.000000000 -0600
+++ radix-tree.patch.c	2010-12-16 16:13:32.672039108 -0700
@@ -1318,6 +1318,42 @@ out:
 }
 EXPORT_SYMBOL(radix_tree_delete);
 
+static void
+radix_tree_node_destroy(struct radix_tree_node *node, unsigned int height,
+			void (*slot_free)(void *))
+{
+	int i;
+
+	if (height == 0)
+		return;
+	for (i = 0; i < RADIX_TREE_MAP_SIZE; i++) {
+		if (node->slots[i]) {
+			if (height > 1) {
+				radix_tree_node_destroy(node->slots[i],
+					height-1, slot_free);
+				radix_tree_node_free(node->slots[i]);
+				node->slots[i] = NULL;
+			} else
+				slot_free(node->slots[i]);
+		}
+	}
+}
+
+void radix_tree_destroy(struct radix_tree_root *root, void (*slot_free)(void *))
+{
+	if (root->rnode == NULL)
+		return;
+	if (root->height == 0)
+		slot_free(root->rnode);
+	else {
+		radix_tree_node_destroy(root->rnode, root->height, slot_free);
+		radix_tree_node_free(root->rnode);
+		root->height = 0;
+	}
+	root->rnode = NULL;
+}
+EXPORT_SYMBOL(radix_tree_destroy);
+
 /**
  *	radix_tree_tagged - test whether any items in the tree are tagged
  *	@root:		radix tree root
