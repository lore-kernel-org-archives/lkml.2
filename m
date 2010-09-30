Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab0I3Due (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:50:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56474 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0I3Dud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:50:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZtxQ5AXcAmq8XtQgOxpUzkMcGeTmAnsxjTxSYbrPBwQz/XF3g6LJHEKTwhAKVbws06
         dvo53N00BPgH9cqjFRgAN5Ev2fEfkuLFlqhplkum1JfL8ALEW8nX/WJ06+jL9WJfU2et
         wAYXOgjt6bsmYYeNRqjoconW6hH9RWoguH2UA=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] mm: remove temporary variable on generic_file_direct_write()
Date: Thu, 30 Sep 2010 12:50:10 +0900
Message-Id: <1285818621-29890-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
References: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'end' shadows earlier one and is not necessary at all. Remove it
and use 'pos' instead. This removes following sparse warnings:

 mm/filemap.c:2180:24: warning: symbol 'end' shadows an earlier one
 mm/filemap.c:2132:25: originally declared here

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/filemap.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 3d4df44..4a05bf1 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2177,12 +2177,12 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	}
 
 	if (written > 0) {
-		loff_t end = pos + written;
-		if (end > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
-			i_size_write(inode,  end);
+		pos += written;
+		if (pos > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
+			i_size_write(inode, pos);
 			mark_inode_dirty(inode);
 		}
-		*ppos = end;
+		*ppos = pos;
 	}
 out:
 	return written;
-- 
1.7.2.2

