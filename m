Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab2FHFPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:15:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43312 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761343Ab2FHFH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:27 -0400
Message-Id: <20120608041851.667612016@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:20:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Joern Engel <joern@logfs.org>
Subject: [ 80/82] btree: fix tree corruption in btree_get_prev()
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit cbf8ae32f66a9ceb8907ad9e16663c2a29e48990 upstream.

The memory the parameter __key points to is used as an iterator in
btree_get_prev(), so if we save off a bkey() pointer in retry_key and
then assign that to __key, we'll end up corrupting the btree internals
when we do eg

	longcpy(__key, bkey(geo, node, i), geo->keylen);

to return the key value.  What we should do instead is use longcpy() to
copy the key value that retry_key points to __key.

This can cause a btree to get corrupted by seemingly read-only
operations such as btree_for_each_safe.

[akpm@linux-foundation.org: avoid the double longcpy()]
Signed-off-by: Roland Dreier <roland@purestorage.com>
Acked-by: Joern Engel <joern@logfs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 lib/btree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/btree.c b/lib/btree.c
index e5ec1e9..5cf9e74 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -319,8 +319,8 @@ void *btree_get_prev(struct btree_head *head, struct btree_geo *geo,
 
 	if (head->height == 0)
 		return NULL;
-retry:
 	longcpy(key, __key, geo->keylen);
+retry:
 	dec_key(geo, key);
 
 	node = head->node;
@@ -351,7 +351,7 @@ retry:
 	}
 miss:
 	if (retry_key) {
-		__key = retry_key;
+		longcpy(key, retry_key, geo->keylen);
 		retry_key = NULL;
 		goto retry;
 	}


