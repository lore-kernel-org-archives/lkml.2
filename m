Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab0GMPqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:46:30 -0400
Received: from [83.221.146.177] ([83.221.146.177]:43818 "EHLO
	localdomain.local" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756565Ab0GMPq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:46:29 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jul 2010 11:46:29 EDT
To: linux-kernel@vger.kernel.org
Subject: [RESEND][RFC][PATCH] fsnotify: track all events on filesystem
Cc: eparis@redhat.com
Message-Id: <20100713153626.EB8B140434E@localdomain.local>
Date: Tue, 13 Jul 2010 17:36:26 +0200 (CEST)
From: jakob.goldbach@gmail.com (Jakob Goldbach)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending, this time with fsnotify maintainer cc'ed)

This patch allows notification groups to get events on the entire filesystem,
not just on registered inodes.

I want to use it for a notification group that tracks all changes to the 
filesystem in order to do faster backups.

Is this a good or bad idea? 

/Jakob


diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index fcc2f06..aa9e204 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -147,7 +147,9 @@ void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is, const
 	if (!(test_mask & fsnotify_mask))
 		return;
 
-	if (!(test_mask & to_tell->i_fsnotify_mask))
+	if (!
+	    (test_mask &
+	     (to_tell->i_fsnotify_mask | to_tell->i_sb->s_fsnotify_mask)))
 		return;
 	/*
 	 * SRCU!!  the groups list is very very much read only and the path is
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 68ca1b0..102acf5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1382,6 +1382,9 @@ struct super_block {
 	 * generic_show_options()
 	 */
 	char *s_options;
+#ifdef CONFIG_FSNOTIFY
+	__u32			s_fsnotify_mask;
+#endif
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
