Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab2KLVaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:30:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45228 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab2KLV3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:29:06 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Artemy Tregubenko <me@arty.name>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [ 3.5.yuz extended stable] Patch "eCryptfs: Write out all dirty pages just before releasing" has been added to staging queue
Date: Mon, 12 Nov 2012 19:29:01 -0200
Message-Id: <1352755741-16182-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    eCryptfs: Write out all dirty pages just before releasing

to the linux-3.5.y-queue branch of the 3.5.yuz extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.5.y-queue

If you, or anyone else, feels it should not be added to the 3.5
Linux kernel, or for any feedback related to it, please reply to
this email. For more information on extended stable, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Herton

------

>From 51b8150c74fb1071623215d80ee1560ab56057a4 Mon Sep 17 00:00:00 2001
From: Tyler Hicks <tyhicks@canonical.com>
Date: Wed, 12 Sep 2012 18:02:46 -0700
Subject: [PATCH] eCryptfs: Write out all dirty pages just before releasing
 the lower file

commit 7149f2558d5b5b988726662fe58b1c388337805b upstream.

Fixes a regression caused by:

821f749 eCryptfs: Revert to a writethrough cache model

That patch reverted some code (specifically, 32001d6f) that was
necessary to properly handle open() -> mmap() -> close() -> dirty pages
-> munmap(), because the lower file could be closed before the dirty
pages are written out.

Rather than reapplying 32001d6f, this approach is a better way of
ensuring that the lower file is still open in order to handle writing
out the dirty pages. It is called from ecryptfs_release(), while we have
a lock on the lower file pointer, just before the lower file gets the
final fput() and we overwrite the pointer.

https://launchpad.net/bugs/1047261

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reported-by: Artemy Tregubenko <me@arty.name>
Tested-by: Artemy Tregubenko <me@arty.name>
Tested-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ecryptfs/main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index df217dc..c2a9c39 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -162,6 +162,7 @@ void ecryptfs_put_lower_file(struct inode *inode)
 	inode_info = ecryptfs_inode_to_private(inode);
 	if (atomic_dec_and_mutex_lock(&inode_info->lower_file_count,
 				      &inode_info->lower_file_mutex)) {
+		filemap_write_and_wait(inode->i_mapping);
 		fput(inode_info->lower_file);
 		inode_info->lower_file = NULL;
 		mutex_unlock(&inode_info->lower_file_mutex);
--
1.7.9.5

