Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab0KSH2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 02:28:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33684 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab0KSH2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 02:28:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ozN9cOkte3lc6hOL8kKdhOrXMkNd9g+Dupgx2JdMagV52sOenZYS07uvZ5JO71MMen
         5QfoQN+W4GzbfZrB3IAmfEQ4sJR836FMqL3dIWRmb2t6wgQr91FjdXbBdoYzsqPCmojg
         b5+GgK4LkXQykRpxM7nri/OTJdkpqkyAY9/Dc=
From: Namhyung Kim <namhyung@gmail.com>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ext3: Add journal error check into ext3_delete_entry()
Date: Fri, 19 Nov 2010 16:28:35 +0900
Message-Id: <1290151716-4041-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check return value of ext3_journal_get_write_access() and
ext3_journal_dirty_metadata().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/namei.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 03fccc5..672cea1 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1644,8 +1644,13 @@ static int ext3_delete_entry (handle_t *handle,
 		if (!ext3_check_dir_entry("ext3_delete_entry", dir, de, bh, i))
 			return -EIO;
 		if (de == de_del)  {
+			int err;
+
 			BUFFER_TRACE(bh, "get_write_access");
-			ext3_journal_get_write_access(handle, bh);
+			err = ext3_journal_get_write_access(handle, bh);
+			if (err)
+				goto journal_error;
+
 			if (pde)
 				pde->rec_len = ext3_rec_len_to_disk(
 					ext3_rec_len_from_disk(pde->rec_len) +
@@ -1654,7 +1659,12 @@ static int ext3_delete_entry (handle_t *handle,
 				de->inode = 0;
 			dir->i_version++;
 			BUFFER_TRACE(bh, "call ext3_journal_dirty_metadata");
-			ext3_journal_dirty_metadata(handle, bh);
+			err = ext3_journal_dirty_metadata(handle, bh);
+			if (err) {
+journal_error:
+				ext3_std_error(dir->i_sb, err);
+				return err;
+			}
 			return 0;
 		}
 		i += ext3_rec_len_from_disk(de->rec_len);
-- 
1.7.0.4

