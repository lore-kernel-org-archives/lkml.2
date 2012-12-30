Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2L3FxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 00:53:05 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:49084 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2L3FxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 00:53:03 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 3/4] f2fs: fix removing cache entry within proper lock
Date: Sun, 30 Dec 2012 14:52:53 +0900
Message-Id: <1356846773-7712-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Cache entry for free NID, is not getting removed under proper
lock in case of error in add_free_nid. So, free the cache entry
first before releasing the spinlock.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 5066bfd..09139fb 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1227,8 +1227,8 @@ retry:
 
 	spin_lock(&nm_i->free_nid_list_lock);
 	if (__lookup_free_nid_list(nid, &nm_i->free_nid_list)) {
-		spin_unlock(&nm_i->free_nid_list_lock);
 		kmem_cache_free(free_nid_slab, i);
+		spin_unlock(&nm_i->free_nid_list_lock);
 		return 0;
 	}
 	list_add_tail(&i->list, &nm_i->free_nid_list);
-- 
1.7.9.5

