Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0INUXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:23:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53450 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0INUXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:23:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 14/15] vfs: don't use BKL in default_llseek
Date: Tue, 14 Sep 2010 22:22:42 +0200
Message-Id: <1284495763-7506-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284495763-7506-1-git-send-email-arnd@arndb.de>
References: <1284495763-7506-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:yjChOH8GOLJSy5/t2/VXO1kJWUmlYcHi7lckd/wSXhw
 VM3AlMv0QqZQ03rlz3Qf5/Y6H+wpuDRF5qO4VovpfJnNNq8XnW
 ovF21+yEmZMMnynH10LGG5XDJPW6xfODjCaUTxbjUXSX9tx3CP
 IvQkzocgP8v37z22EkATx/t2x/iWSluWQb2B1bdQKHKeuhXLA2
 un6SluNYJ6HFnNii3y1QA==
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
index 74e3658..fd09f61 100644
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

