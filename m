Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab0LIWYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:24:15 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13883 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab0LIWYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:24:13 -0500
Date: Thu, 9 Dec 2010 23:17:34 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-ext4@vger.kernel.org
cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: [PATCH] ext4: Take advantage of kmem_cache_zalloc() in
 ext4_init_io_end()
Message-ID: <alpine.LNX.2.00.1012092257290.25880@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Take advantage of kmem_cache_zalloc(). Save a memset() call in 
ext4_init_io_end() and save a few bytes.

Before:
 [jj@dragon linux-2.6]$ size fs/ext4/page-io.o
    text    data     bss     dec     hex filename
    3016       0     624    3640     e38 fs/ext4/page-io.o
After:
 [jj@dragon linux-2.6]$ size fs/ext4/page-io.o
    text    data     bss     dec     hex filename
    3000       0     624    3624     e28 fs/ext4/page-io.o


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 page-io.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index beacce1..0f5dfe0 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -158,11 +158,8 @@ static void ext4_end_io_work(struct work_struct *work)
 
 ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
 {
-	ext4_io_end_t *io = NULL;
-
-	io = kmem_cache_alloc(io_end_cachep, flags);
+	ext4_io_end_t *io = kmem_cache_zalloc(io_end_cachep, flags);
 	if (io) {
-		memset(io, 0, sizeof(*io));
 		atomic_inc(&EXT4_I(inode)->i_ioend_count);
 		io->inode = inode;
 		INIT_WORK(&io->work, ext4_end_io_work);



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

