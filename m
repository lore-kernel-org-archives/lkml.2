Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab2KLV3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:29:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45231 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab2KLV3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:29:10 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: [ 3.5.yuz extended stable] Patch "eCryptfs: Call lower ->flush() from ecryptfs_flush()" has been added to staging queue
Date: Mon, 12 Nov 2012 19:29:05 -0200
Message-Id: <1352755745-16242-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    eCryptfs: Call lower ->flush() from ecryptfs_flush()

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

>From bfec717b26c32c6055a3b43d40e7bd6bf2287dcb Mon Sep 17 00:00:00 2001
From: Tyler Hicks <tyhicks@canonical.com>
Date: Wed, 12 Sep 2012 18:38:00 -0700
Subject: [PATCH] eCryptfs: Call lower ->flush() from ecryptfs_flush()

commit 64e6651dcc10e9d2cc6230208a8e6c2cfd19ae18 upstream.

Since eCryptfs only calls fput() on the lower file in
ecryptfs_release(), eCryptfs should call the lower filesystem's
->flush() from ecryptfs_flush().

If the lower filesystem implements ->flush(), then eCryptfs should try
to flush out any dirty pages prior to calling the lower ->flush(). If
the lower filesystem does not implement ->flush(), then eCryptfs has no
need to do anything in ecryptfs_flush() since dirty pages are now
written out to the lower filesystem in ecryptfs_release().

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ecryptfs/file.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 44ce5c6..d45ba45 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -275,8 +275,14 @@ out:

 static int ecryptfs_flush(struct file *file, fl_owner_t td)
 {
-	return file->f_mode & FMODE_WRITE
-	       ? filemap_write_and_wait(file->f_mapping) : 0;
+	struct file *lower_file = ecryptfs_file_to_lower(file);
+
+	if (lower_file->f_op && lower_file->f_op->flush) {
+		filemap_write_and_wait(file->f_mapping);
+		return lower_file->f_op->flush(lower_file, td);
+	}
+
+	return 0;
 }

 static int ecryptfs_release(struct inode *inode, struct file *file)
--
1.7.9.5

