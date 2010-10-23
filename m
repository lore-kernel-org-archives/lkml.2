Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab0JWPql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:46:41 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:38068 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab0JWPqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:46:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Uh34O+h4IvDY+4P0pKuMUNJPhtHLyudQyQ4DhwXQUMijAPlv8ZfmMe+kqDqFE0u2eA
         nkYBLsvhuSOAmPmoSjRgMXSc3Z/dIzTSlpR8JwK6WeLKODVhjRzyOUuH8c2bDl9pJpUD
         YjLO0lhjo95V+lmZLT5LpohE1GvzvFFCX0o2I=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs/buffer.c: call __block_write_begin() if we have page
Date: Sun, 24 Oct 2010 00:46:26 +0900
Message-Id: <1287848786-13347-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have the appropriate page already, call __block_write_begin()
directly instead of releasing and regrabbing it inside of
block_write_begin().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/buffer.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 7f0b9b0..d4b3ada 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2466,11 +2466,10 @@ int nobh_write_begin(struct address_space *mapping,
 	*fsdata = NULL;
 
 	if (page_has_buffers(page)) {
-		unlock_page(page);
-		page_cache_release(page);
-		*pagep = NULL;
-		return block_write_begin(mapping, pos, len, flags, pagep,
-					 get_block);
+		ret = __block_write_begin(page, pos, len, get_block);
+		if (unlikely(ret))
+			*pagep = NULL;
+		return ret;
 	}
 
 	if (PageMappedToDisk(page))
-- 
1.7.0.4

