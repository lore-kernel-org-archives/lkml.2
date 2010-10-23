Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab0JWQMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 12:12:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37585 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab0JWQMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 12:12:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kFsdjEAOKK75oy3LQ85IrgJ0Mv+TD49lR5KYeioEk4FEqBUN3d4BfTvCLa6gKTYDzm
         L2RDBMzjUqAOUiYsx1ovLXJlXteRvV19RzuIPYG5eLbgrttJhaKf63WAtE4l1es+funy
         8d7lACf2qz8kiyA2x3wbxjceNXu5m67TJo/70=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED] fs/buffer.c: call __block_write_begin() if we have page
Date: Sun, 24 Oct 2010 01:11:54 +0900
Message-Id: <1287850314-13663-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287848786-13347-1-git-send-email-namhyung@gmail.com>
References: <1287848786-13347-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have the appropriate page already, call __block_write_begin()
directly instead of releasing and regrabbing it inside of
block_write_begin().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
Fix error path.

 fs/buffer.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 7f0b9b0..f5755f7 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2466,11 +2466,13 @@ int nobh_write_begin(struct address_space *mapping,
 	*fsdata = NULL;
 
 	if (page_has_buffers(page)) {
-		unlock_page(page);
-		page_cache_release(page);
-		*pagep = NULL;
-		return block_write_begin(mapping, pos, len, flags, pagep,
-					 get_block);
+		ret = __block_write_begin(page, pos, len, get_block);
+		if (unlikely(ret)) {
+			unlock_page(page);
+			page_cache_release(page);
+			*pagep = NULL;
+		}
+		return ret;
 	}
 
 	if (PageMappedToDisk(page))
-- 
1.7.0.4

