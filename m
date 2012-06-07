Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802Ab2FGEVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:21:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933075Ab2FGEVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:21:08 -0400
Message-Id: <20120607040346.201103842@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:43 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: [ 67/82] radix-tree: fix contiguous iterator
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

commit fffaee365fded09f9ebf2db19066065fa54323c3 upstream.

This patch fixes bug in macro radix_tree_for_each_contig().

If radix_tree_next_slot() sees NULL in next slot it returns NULL, but following
radix_tree_next_chunk() switches iterating into next chunk. As result iterating
becomes non-contiguous and breaks vfs "splice" and all its users.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Reported-and-bisected-by: Hans de Bruin <jmdebruin@xmsnet.nl>
Reported-and-bisected-by: Ondrej Zary <linux@rainbow-software.org>
Reported-bisected-and-tested-by: Toralf Förster <toralf.foerster@gmx.de>
Link: https://lkml.org/lkml/2012/6/5/64
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/radix-tree.h |    5 ++++-
 lib/radix-tree.c           |    3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -368,8 +368,11 @@ radix_tree_next_slot(void **slot, struct
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
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -673,6 +673,9 @@ void **radix_tree_next_chunk(struct radi
 	 * during iterating; it can be zero only at the beginning.
 	 * And we cannot overflow iter->next_index in a single step,
 	 * because RADIX_TREE_MAP_SHIFT < BITS_PER_LONG.
+	 *
+	 * This condition also used by radix_tree_next_slot() to stop
+	 * contiguous iterating, and forbid swithing to the next chunk.
 	 */
 	index = iter->next_index;
 	if (!index && iter->index)


