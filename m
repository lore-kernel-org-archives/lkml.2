Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2FERgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:36:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59747 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab2FERgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:36:37 -0400
Subject: [PATCH BUGFIX] radix-tree: fix contiguous iterator
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Date: Tue, 05 Jun 2012 21:36:33 +0400
Message-ID: <20120605173633.27150.64995.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bug in macro radix_tree_for_each_contig().

If radix_tree_next_slot() sees NULL in next slot it returns NULL, but following
radix_tree_next_chunk() switches iterating into next chunk. As result iterating
becomes non-contiguous and breaks vfs "splice" and all its users.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reported-and-bisected-by: Hans de Bruin <jmdebruin@xmsnet.nl>
Reported-and-bisected-by: Ondrej Zary <linux@rainbow-software.org>
Reported-and-bisected-by: Toralf Förster <toralf.foerster@gmx.de>
Link: https://lkml.org/lkml/2012/6/5/64
Cc: stable <stable@vger.kernel.org> # 3.4.x
---
 include/linux/radix-tree.h |    5 ++++-
 lib/radix-tree.c           |    3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 0d04cd6..ffc444c 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -368,8 +368,11 @@ radix_tree_next_slot(void **slot, struct radix_tree_iter *iter, unsigned flags)
 			iter->index++;
 			if (likely(*slot))
 				return slot;
-			if (flags & RADIX_TREE_ITER_CONTIG)
+			if (flags & RADIX_TREE_ITER_CONTIG) {
+				/* forbid switching to the next chunk */
+				iter->next_index = 0;
 				break;
+			}
 		}
 	}
 	return NULL;
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 86516f5..3ac50dc 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -673,6 +673,9 @@ void **radix_tree_next_chunk(struct radix_tree_root *root,
 	 * during iterating; it can be zero only at the beginning.
 	 * And we cannot overflow iter->next_index in a single step,
 	 * because RADIX_TREE_MAP_SHIFT < BITS_PER_LONG.
+	 *
+	 * This condition also used by radix_tree_next_slot() to stop
+	 * contiguous iterating, and forbid swithing to the next chunk.
 	 */
 	index = iter->next_index;
 	if (!index && iter->index)

