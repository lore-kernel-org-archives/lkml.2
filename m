Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2CaHZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 03:25:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56052 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2CaHZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 03:25:29 -0400
Message-ID: <4F76B15D.9010801@gmail.com>
Date: Sat, 31 Mar 2012 15:25:17 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs/extent_io.c: return -ENOMEM instead of BUG_ON on allocation
 failure in set_extent_bit if __GFP_WAIT is set in the mask
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If __GFP_WAIT is set in the mask, set_extent_bit should return
-ENOMEM to its caller to decide what to do on allocation failure,
instead of BUG_ON.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/extent_io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b67814c..fd2411e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -720,7 +720,8 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
 		prealloc = alloc_extent_state(mask);
-		BUG_ON(!prealloc);
+		if (!prealloc)
+			return -ENOMEM;
 	}
 
 	spin_lock(&tree->lock);
-- 
1.7.1

