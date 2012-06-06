Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab2FFRRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:17:40 -0400
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:44688 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756906Ab2FFRRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:17:38 -0400
From: Roland Dreier <roland@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] btree: Fix tree corruption in btree_get_prev()
Date: Wed,  6 Jun 2012 10:17:26 -0700
Message-Id: <1339003047-15734-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

The memory the parameter __key points to is used as an iterator in
btree_get_prev(), so if we save off a bkey() pointer in retry_key and
then assign that to __key, we'll end up corrupting the btree internals
when we do eg

	longcpy(__key, bkey(geo, node, i), geo->keylen);

to return the key value.  What we should do instead is use longcpy() to
copy the key value that retry_key points to __key.

This can cause a btree to get corrupted by seemingly read-only
operations such as btree_for_each_safe.

Acked-by: Joern Engel <joern@logfs.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 lib/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/btree.c b/lib/btree.c
index e5ec1e9..b6e889b 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -351,7 +351,7 @@ retry:
 	}
 miss:
 	if (retry_key) {
-		__key = retry_key;
+		longcpy(__key, retry_key, geo->keylen);
 		retry_key = NULL;
 		goto retry;
 	}
-- 
1.7.9.5

