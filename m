Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2BUTMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:12:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab2BUTLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:11:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 65/73] ext2: Add ext2_dirent_in_use() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-ext4@vger.kernel.org
Date: Tue, 21 Feb 2012 18:05:39 +0000
Message-ID: <20120221180538.25235.94932.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

Currently ext2 checks if a directory entry is in-use by checking if the inode
is non-zero.  Fallthrus and whiteouts will have zero inode but be in-use.  Add
a function to abstract out the directory entry in-use test.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-ext4@vger.kernel.org
---

 fs/ext2/dir.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index d37df35..89015f1 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -218,6 +218,11 @@ fail:
 	return ERR_PTR(-EIO);
 }
 
+static inline int ext2_dirent_in_use(struct ext2_dir_entry_2 *de)
+{
+	return de->inode != 0;
+}
+
 /*
  * NOTE! unlike strncmp, ext2_match returns 1 for success, 0 for failure.
  *
@@ -228,7 +233,7 @@ static inline int ext2_match (int len, const char * const name,
 {
 	if (len != de->name_len)
 		return 0;
-	if (!de->inode)
+	if (!ext2_dirent_in_use(de))
 		return 0;
 	return !memcmp(name, de->name, len);
 }
@@ -527,6 +532,7 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 				rec_len = chunk_size;
 				de->rec_len = ext2_rec_len_to_disk(chunk_size);
 				de->inode = 0;
+				de->file_type = 0;
 				goto got_it;
 			}
 			if (de->rec_len == 0) {
@@ -540,7 +546,7 @@ int ext2_add_link (struct dentry *dentry, struct inode *inode)
 				goto out_unlock;
 			name_len = EXT2_DIR_REC_LEN(de->name_len);
 			rec_len = ext2_rec_len_from_disk(de->rec_len);
-			if (!de->inode && rec_len >= reclen)
+			if (!ext2_dirent_in_use(de) && rec_len >= reclen)
 				goto got_it;
 			if (rec_len >= name_len + reclen)
 				goto got_it;
@@ -558,7 +564,7 @@ got_it:
 	err = ext2_prepare_chunk(page, pos, rec_len);
 	if (err)
 		goto out_unlock;
-	if (de->inode) {
+	if (ext2_dirent_in_use(de)) {
 		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
 		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
 		de->rec_len = ext2_rec_len_to_disk(name_len);

