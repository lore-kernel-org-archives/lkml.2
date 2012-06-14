Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2FNX7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:59:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab2FNX72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:28 -0400
Message-Id: <20120614235624.253607282@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Joern Engel <joern@logfs.org>
Subject: [ 04/42] btree: fix tree corruption in btree_get_prev()
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/btree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/btree.c
+++ b/lib/btree.c
@@ -319,8 +319,8 @@ void *btree_get_prev(struct btree_head *
 
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


