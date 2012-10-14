Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab2JNPKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:10:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46222 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754375Ab2JNOmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:13 -0400
Message-Id: <20121014143550.525935256@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@canonical.com>, Artemy Tregubenko <me@arty.name>,
        Colin Ian King <colin.king@canonical.com>
Subject: [ 124/147] eCryptfs: Write out all dirty pages just before releasing the lower
 file
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ecryptfs/main.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 2768138..9b627c1 100644
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


