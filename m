Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab0GGVnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:43:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49513 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711Ab0GGVkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:40:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/18] vfs: don't use BKL in default_llseek
Date: Wed,  7 Jul 2010 23:40:19 +0200
Message-Id: <1278538820-1392-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278538820-1392-1-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:t0UsgDeHxj49cq3Aa8iwzIwfw930cHbNR0KszAfr6C4
 fiJGERR8SApVqK2wvB1/wDpRt0dvmeZJIHNQ0pYYr6nCyqcLd1
 FauLt06MK2vJhopHXLrBgRbTh2RDwomZ5BZSKyqUOoPBWxox83
 mjWg6LG9xhcRpe3q6czIlHquIN4zm8QYfbtzkxTQcuttWxO7yd
 M8fCXiZVovzVmcrsV+o1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are currently 191 users of default_llseek.
Nine of these are in device drivers that use the
big kernel lock. None of these ever touch
file->f_pos outside of llseek or file_pos_write.

Consequently, we never rely on the BKL
in the default_llseek function and can
replace that with i_mutex, which is also
used in generic_file_llseek.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/read_write.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 9c04852..31c0be7 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -124,7 +124,7 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
 {
 	loff_t retval;
 
-	lock_kernel();
+	mutex_lock(&file->f_dentry->d_inode->i_mutex);
 	switch (origin) {
 		case SEEK_END:
 			offset += i_size_read(file->f_path.dentry->d_inode);
@@ -145,7 +145,7 @@ loff_t default_llseek(struct file *file, loff_t offset, int origin)
 		retval = offset;
 	}
 out:
-	unlock_kernel();
+	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
 	return retval;
 }
 EXPORT_SYMBOL(default_llseek);
-- 
1.7.1

