Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab0GBNAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 09:00:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47298 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758535Ab0GBNAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 09:00:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=YATgfOOzhJnjP75AuTBjNUatYoTMkE1f35bBh/apUsOJ3lVH8k1bDV3t26RhvJeICp
         q3bvWnuFjbAi4zJlD9p/N+y5Zl/2vPNX/lFBuWF61Plf3KiOsrKpjPRmcde2x0gdqTPi
         5Sd0XqzgovpsmARY3s2L63uKmW8WeskQ33yOg=
MIME-Version: 1.0
Date: Fri, 2 Jul 2010 15:00:17 +0200
Message-ID: <AANLkTilC2abOtOfvQ-dYaLn57Vhu_PTqGFfI5pzeYnw4@mail.gmail.com>
Subject: [RFC] fsnotify: track events on entire fs
From: Jakob Goldbach <jakob.goldbach@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows notifications groups to get events on entire fs not
just on registered inodes.
I want to use it for a notification group that tracks all changes to
the filesystem in order to do faster backups.

Is this a good idea ?

Thanks,
Jakob

---
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index fcc2f06..58158cf 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -147,7 +147,7 @@ void fsnotify(struct inode *to_tell, __u32 mask,
void *data, int data_is, const
        if (!(test_mask & fsnotify_mask))
                return;

-       if (!(test_mask & to_tell->i_fsnotify_mask))
+       if (!(test_mask & (to_tell->i_fsnotify_mask |
to_tell->i_sb->s_fsnotify_mask)))
                return;
        /*
         * SRCU!!  the groups list is very very much read only and the path is
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 471e1ff..cd65f7a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1382,6 +1382,9 @@ struct super_block {
         * generic_show_options()
         */
        char *s_options;
+#ifdef CONFIG_FSNOTIFY
+        __u32                   s_fsnotify_mask;
+#endif
 };

 extern struct timespec current_fs_time(struct super_block *sb);
