Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2KZSVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:21:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47021 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab2KZRAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:00:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tyler Hicks <tyhicks@canonical.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 009/270] eCryptfs: Call lower ->flush() from ecryptfs_flush()
Date: Mon, 26 Nov 2012 14:54:59 -0200
Message-Id: <1353949160-26803-10-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

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

