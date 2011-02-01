Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1BAVYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:24:05 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60269 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab1BAVYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:24:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=iTABN72Hnn9LpX2FMOCkDcFbyN+Sq7vX3Km1PkpxzdyxEWoiGoYOZppuYWnvpvB12L
         yDI9s86nvzVhdtxYM3L7+0o433/Fkm5Xl5G5brRqWbkqxG3IBa+gB5JeIO3lI0DjP8ON
         b+xdaOhYuPgVQQ19tBCczucEfuCE5e1S2N2+Y=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Evgeniy Dushistov <dushistov@mail.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@am.sony.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] ufs: Check if page has buffers before calling page_buffers()
Date: Tue,  1 Feb 2011 22:23:38 +0100
Message-Id: <1296595418-2457-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ufs_change_blocknr() we have called page_buffers() without checking if the
page actually had pages attached to it and this could cause a BUG oops.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 fs/ufs/balloc.c |   62 +++++++++++++++++++++++++++---------------------------
 1 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 46f7a80..8155ccd 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -276,46 +276,46 @@ static void ufs_change_blocknr(struct inode *inode, sector_t beg,
 		} else
 			page = locked_page;
 
-		head = page_buffers(page);
-		bh = head;
-		pos = i & mask;
-		for (j = 0; j < pos; ++j)
-			bh = bh->b_this_page;
-
-
 		if (unlikely(index == last_index))
 			lblock = end & mask;
 		else
 			lblock = blks_per_page;
 
-		do {
-			if (j >= lblock)
-				break;
-			pos = (i - beg) + j;
+		if (page_has_buffers(page)) {
+			bh = head = page_buffers(page);
+			pos = i & mask;
+			for (j = 0; j < pos; ++j)
+				bh = bh->b_this_page;
 
-			if (!buffer_mapped(bh))
-					map_bh(bh, inode->i_sb, oldb + pos);
-			if (!buffer_uptodate(bh)) {
-				ll_rw_block(READ, 1, &bh);
-				wait_on_buffer(bh);
-				if (!buffer_uptodate(bh)) {
-					ufs_error(inode->i_sb, __func__,
-						  "read of block failed\n");
+			do {
+				if (j >= lblock)
 					break;
+				pos = (i - beg) + j;
+
+				if (!buffer_mapped(bh))
+						map_bh(bh, inode->i_sb, oldb + pos);
+				if (!buffer_uptodate(bh)) {
+					ll_rw_block(READ, 1, &bh);
+					wait_on_buffer(bh);
+					if (!buffer_uptodate(bh)) {
+						ufs_error(inode->i_sb, __func__,
+							  "read of block failed\n");
+						break;
+					}
 				}
-			}
 
-			UFSD(" change from %llu to %llu, pos %u\n",
-			     (unsigned long long)(pos + oldb),
-			     (unsigned long long)(pos + newb), pos);
-
-			bh->b_blocknr = newb + pos;
-			unmap_underlying_metadata(bh->b_bdev,
-						  bh->b_blocknr);
-			mark_buffer_dirty(bh);
-			++j;
-			bh = bh->b_this_page;
-		} while (bh != head);
+				UFSD(" change from %llu to %llu, pos %u\n",
+				     (unsigned long long)(pos + oldb),
+					 (unsigned long long)(pos + newb), pos);
+
+				bh->b_blocknr = newb + pos;
+				unmap_underlying_metadata(bh->b_bdev,
+							  bh->b_blocknr);
+				mark_buffer_dirty(bh);
+				++j;
+				bh = bh->b_this_page;
+			} while (bh != head);
+		}
 
 		if (likely(cur_index != index))
 			ufs_put_locked_page(page);
-- 
1.7.0.4

