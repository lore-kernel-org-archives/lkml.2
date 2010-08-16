Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab0HPSa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:30:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52252 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab0HPSaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:30:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:in-reply-to:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=D+RaXAJg3JZAUqO/XygJaQNA9wQp9Y2QlK6dro8yNFFwz+cB/gn+QiiOTK5YnSklI
	w07coHUfIoBSko/FdTCig==
Subject: [PATCH] Fixed a mismatch between the users of radix_tree and the
	implementation.
In-Reply-To: <1281957914.1926.1249.camel@laptop>
To: paulmck@us.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
From: Salman Qazi <sqazi@google.com>
Cc: adurbin@google.com
Date: Mon, 16 Aug 2010 11:30:07 -0700
Message-ID: <20100816182834.3541.42317.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done.

---

This matters for the lockless page cache, in particular find_get_pages implementation.

In the following case, we get can get a deadlock:

    0.  The radix tree contains two items, one has the index 0.
    1.  The reader (in this case find_get_pages) takes the rcu_read_lock.
    2.  The reader acquires slot(s) for item(s) including the index 0 item.
    3.  The non-zero index item is deleted, and as a consequence the other item
        is moved to the root of the tree.  The place where it used to be is
        queued for deletion after the readers finish.
    4.  The reader looks at the index 0 slot, and finds that the page has 0 ref count
    5.  The reader looks at it again, hoping that the item will either be freed
        or the ref count will increase.  This never happens, as the slot it
        is looking at will never be updated.  Also, this slot can never be reclaimed
        because the reader is holding rcu_read_lock and is in an infinite loop.

This can be reproduced with reliably by running dbench followed by compilebench under
autotest.  I have not been able to construct a small targeted repro case.

There is also a similar potential issue with insertion.  Storing the first
element in the root and then moving it to a new slot on insertion of a
second element would potentially lead to a similar problem.

Both of these issues have been fixed in this change.  For the delete case,
we no longer shrink the tree back to being just the root containing the
only remaining object.  For the insert case, we no longer store the
first object in the root, rather allocating a node structure for it.  The
reason that this works is that deleting (or inserting) intermediate nodes
does not make a difference to a reader holding a slot.  The problem only
occurs when a leaf node is inserted or deleted.  By making these changes
we avoid insertion and deletion of new leaf nodes for values already
in the tree.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 lib/radix-tree.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index e907858..035d5aa 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -252,11 +252,6 @@ static int radix_tree_extend(struct radix_tree_root *root, unsigned long index)
 	while (index > radix_tree_maxindex(height))
 		height++;
 
-	if (root->rnode == NULL) {
-		root->height = height;
-		goto out;
-	}
-
 	do {
 		unsigned int newheight;
 		if (!(node = radix_tree_node_alloc(root)))
@@ -278,7 +273,7 @@ static int radix_tree_extend(struct radix_tree_root *root, unsigned long index)
 		rcu_assign_pointer(root->rnode, node);
 		root->height = newheight;
 	} while (height > root->height);
-out:
+
 	return 0;
 }
 
@@ -1154,7 +1149,7 @@ EXPORT_SYMBOL(radix_tree_gang_lookup_tag_slot);
 static inline void radix_tree_shrink(struct radix_tree_root *root)
 {
 	/* try to shrink tree height */
-	while (root->height > 0) {
+	while (root->height > 1) {
 		struct radix_tree_node *to_free = root->rnode;
 		void *newptr;
 

