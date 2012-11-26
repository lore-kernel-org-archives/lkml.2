Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab2KZRAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:00:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47017 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab2KZRAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:00:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tyler Hicks <tyhicks@canonical.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 008/270] eCryptfs: Write out all dirty pages just before releasing the lower file
Date: Mon, 26 Nov 2012 14:54:58 -0200
Message-Id: <1353949160-26803-9-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

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

