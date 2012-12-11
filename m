Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2LKPKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 10:10:39 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64686 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab2LKPKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 10:10:37 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH] f2fs: fix up f2fs_get_parent issue to retrieve correct parent inode number
Date: Wed, 12 Dec 2012 00:10:25 +0900
Message-Id: <1355238625-6581-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Test Case:
[NFS Client]
ls -lR .

[NFS Server]
while [ 1 ]
do
echo 3 > /proc/sys/vm/drop_caches
done

Error on NFS Client: "No such file or directory"

When cache is dropped at the server, it results in lookup failure at the
NFS client due to non-connection with the parent. The default path is it
initiates a lookup by calculating the hash value for the name, even though
the hash values stored on the disk for "." and ".." is maintained as zero,
which results in failure from find_in_block due to not matching HASH values.
Fix up, by using the correct hashing values for these entries and
then initiating lookup request.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/dir.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index b4e24f3..6cf39db 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -184,7 +184,7 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode *dir,
 	int namelen = child->len;
 	unsigned long npages = dir_blocks(dir);
 	struct f2fs_dir_entry *de = NULL;
-	f2fs_hash_t name_hash;
+	f2fs_hash_t name_hash = 0;
 	unsigned int max_depth;
 	unsigned int level;
 
@@ -193,7 +193,8 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode *dir,
 
 	*res_page = NULL;
 
-	name_hash = f2fs_dentry_hash(name, namelen);
+	if (strcmp(name, ".") && (strcmp(name, "..")))
+		name_hash = f2fs_dentry_hash(name, namelen);
 	max_depth = F2FS_I(dir)->i_current_depth;
 
 	for (level = 0; level < max_depth; level++) {
-- 
1.7.9.5

