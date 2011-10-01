Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab1JAUuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:50:13 -0400
Received: from mail.anarazel.de ([217.115.131.40]:57890 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab1JAUuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:50:09 -0400
From: Andres Freund <andres@anarazel.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/2] btrfs: Don't have multiple paths to error out in  btrfs_file_llseek
Date: Sat, 1 Oct 2011 22:50:04 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc8-andres-00005-gb7b65ee; KDE/4.6.5; x86_64; ; )
Cc: robertmhaas@gmail.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <201110012246.13801.andres@anarazel.de>
In-Reply-To: <201110012246.13801.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110012250.04307.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using multiple paths seems to invite overlooking one when adding new
stuff in the future.

Signed-of-by: Andres Freund <andres@anarazel.de>
---
 fs/btrfs/file.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5bc7116..701c633 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1814,14 +1814,14 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
 
 	mutex_lock(&inode->i_mutex);
 	if (offset >= i_size_read(inode)) {
-		mutex_unlock(&inode->i_mutex);
-		return -ENXIO;
+		offset = -ENXIO;
+		goto out;
 	}
 
 	ret = find_desired_extent(inode, &offset, origin);
 	if (ret) {
-		mutex_unlock(&inode->i_mutex);
-		return ret;
+		offset = ret;
+		goto out;
 	}
 
 	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
-- 
1.7.6.409.ge7a85.dirty

