Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab2JSDMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:12:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:51701 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486Ab2JSCsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@canonical.com>, Artemy Tregubenko <me@arty.name>,
        Colin Ian King <colin.king@canonical.com>
Subject: [ 53/62] eCryptfs: Write out all dirty pages just before releasing the lower file
Date: Thu, 18 Oct 2012 19:45:21 -0700
Message-Id: <20121019024304.515701789@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -162,6 +162,7 @@ void ecryptfs_put_lower_file(struct inod
 	inode_info = ecryptfs_inode_to_private(inode);
 	if (atomic_dec_and_mutex_lock(&inode_info->lower_file_count,
 				      &inode_info->lower_file_mutex)) {
+		filemap_write_and_wait(inode->i_mapping);
 		fput(inode_info->lower_file);
 		inode_info->lower_file = NULL;
 		mutex_unlock(&inode_info->lower_file_mutex);


