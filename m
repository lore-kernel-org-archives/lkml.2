Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1GSWxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:53:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48346 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1GSWxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:53:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=W9XnkuCljK2EWqpAI39/WK1Q+CZmUoUsGLxbAs7fkkpasmg2GHse+4JEByHfalgtS
	jQDiHpbwqjQp2SWeQ34bA==
Date: Tue, 19 Jul 2011 15:52:52 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/3] radix_tree: clean away saw_unset_tag leftovers
In-Reply-To: <alpine.LSU.2.00.1107191549540.1593@sister.anvils>
Message-ID: <alpine.LSU.2.00.1107191551340.1593@sister.anvils>
References: <alpine.LSU.2.00.1107191549540.1593@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

radix_tree_tag_get()'s BUG (when it sees a tag after saw_unset_tag) was
unsafe and removed in 2.6.34, but the pointless saw_unset_tag left behind.

Remove it now, and return 0 as soon as we see unset tag - we already rely
upon the root tag to be correct, returning 0 immediately if it's not set.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 lib/radix-tree.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- mmotm.orig/lib/radix-tree.c	2011-07-08 18:57:14.810702665 -0700
+++ mmotm/lib/radix-tree.c	2011-07-19 11:11:21.285234139 -0700
@@ -576,7 +576,6 @@ int radix_tree_tag_get(struct radix_tree
 {
 	unsigned int height, shift;
 	struct radix_tree_node *node;
-	int saw_unset_tag = 0;
 
 	/* check the root's tag bit */
 	if (!root_tag_get(root, tag))
@@ -603,15 +602,10 @@ int radix_tree_tag_get(struct radix_tree
 			return 0;
 
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-
-		/*
-		 * This is just a debug check.  Later, we can bale as soon as
-		 * we see an unset tag.
-		 */
 		if (!tag_get(node, tag, offset))
-			saw_unset_tag = 1;
+			return 0;
 		if (height == 1)
-			return !!tag_get(node, tag, offset);
+			return 1;
 		node = rcu_dereference_raw(node->slots[offset]);
 		shift -= RADIX_TREE_MAP_SHIFT;
 		height--;
