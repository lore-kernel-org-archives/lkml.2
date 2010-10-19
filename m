Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773Ab0JSD67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 23:58:59 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28444 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933552Ab0JSD4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 23:56:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnEFAJyxvEx5LcB2gWdsb2JhbACUbYx6FgEBFiIiwxaFSQSKSg
Message-Id: <20101019034658.635338577@kernel.dk>
User-Agent: quilt/0.48-1
Date: Tue, 19 Oct 2010 14:42:46 +1100
From: npiggin@kernel.dk
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 30/35] fs: icache lazy LRU avoid LRU locking after IO operation
References: <20101019034216.319085068@kernel.dk>
Content-Disposition: inline; filename=fs-inode-lazy-lru-wb-avoid.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that inode LRU and writeback lists and locking are separated,
it makes sense to avoid LRU manipulation after completing a writeback,
and instead rely on lazy-LRU algorithm to do the work for us.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 fs/fs-writeback.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:19:00.000000000 +1100
+++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:18.000000000 +1100
@@ -410,7 +410,11 @@
 			 * The inode is clean
 			 */
 			list_del_init(&inode->i_io);
-			if (list_empty(&inode->i_lru))
+
+			/*
+			 * Put it on the LRU if it is unused, otherwise lazy.
+			 */
+			if (!inode->i_count && list_empty(&inode->i_lru))
 				__inode_lru_list_add(inode);
 		}
 	}


