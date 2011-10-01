Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab1JAUtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:49:40 -0400
Received: from mail.anarazel.de ([217.115.131.40]:46737 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab1JAUte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:49:34 -0400
From: Andres Freund <andres@anarazel.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/2] LSEEK: BTRFS: Avoid i_mutex for SEEK_{CUR,SET,END}
Date: Sat, 1 Oct 2011 22:49:27 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc8-andres-00005-gb7b65ee; KDE/4.6.5; x86_64; ; )
Cc: robertmhaas@gmail.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <201110012246.13801.andres@anarazel.de>
In-Reply-To: <201110012246.13801.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110012249.27834.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Don't need the i_mutex for those cases, only for SEEK_HOLE/DATA.

Really-From: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andres Freund <andres@anarazel.de>
---
 fs/btrfs/file.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7a13337..5bc7116 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1809,24 +1809,19 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
 	struct inode *inode = file->f_mapping->host;
 	int ret;
 
+	if (origin != SEEK_DATA && origin != SEEK_HOLE)
+		return generic_file_llseek(file, offset, origin);
+
 	mutex_lock(&inode->i_mutex);
-	switch (origin) {
-	case SEEK_END:
-	case SEEK_CUR:
-		offset = generic_file_llseek(file, offset, origin);
-		goto out;
-	case SEEK_DATA:
-	case SEEK_HOLE:
-		if (offset >= i_size_read(inode)) {
-			mutex_unlock(&inode->i_mutex);
-			return -ENXIO;
-		}
+	if (offset >= i_size_read(inode)) {
+		mutex_unlock(&inode->i_mutex);
+		return -ENXIO;
+	}
 
-		ret = find_desired_extent(inode, &offset, origin);
-		if (ret) {
-			mutex_unlock(&inode->i_mutex);
-			return ret;
-		}
+	ret = find_desired_extent(inode, &offset, origin);
+	if (ret) {
+		mutex_unlock(&inode->i_mutex);
+		return ret;
 	}
 
 	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
-- 
1.7.6.409.ge7a85.dirty

