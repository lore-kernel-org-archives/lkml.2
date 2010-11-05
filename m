Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab0KEQHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:07:18 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51901 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752874Ab0KEQG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:06:57 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX181bUxdlQY1FTa3MBEFTC8ZHBHltsFdHF1uZ9NvcY
	0PgQOYVqNlkNT2
Date: Fri, 5 Nov 2010 17:05:27 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: [PATCH] fanotify: if set by user unset FMODE_NONOTIFY before
	fsnotify_perm() is called
Message-ID: <20101105160527.GD24381@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsetting FMODE_NONOTIFY in fsnotify_open() is too late, since fsnotify_perm()
is called before. If FMODE_NONOTIFY is set fsnotify_perm() will skip permission
checks, so a user can still disable permission checks by setting this flag
in an open() call.
This patch corrects this by unsetting the flag before fsnotify_perm is called.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
This patch applies against 2.6.37-rc1
It corrects this unsufficient fix
http://lkml.org/lkml/2010/10/29/125
I totally oversaw those fsnotify_perm() calls :(.
Hopefully this one will set things right...


diff -Nurp a/fs/namei.c b/fs/namei.c
--- a/fs/namei.c	2010-11-01 12:54:12.000000000 +0100
+++ b/fs/namei.c	2010-11-05 10:53:57.000000000 +0100
@@ -1748,6 +1748,9 @@ struct file *do_filp_open(int dfd, const
 	if (!(open_flag & O_CREAT))
 		mode = 0;
 
+	/* Must never be set by userspace */
+	open_flag &= ~FMODE_NONOTIFY;
+
 	/*
 	 * O_SYNC is implemented as __O_SYNC|O_DSYNC.  As many places only
 	 * check for O_DSYNC if the need any syncing at all we enforce it's
diff -Nurp a/include/linux/fsnotify.h b/include/linux/fsnotify.h
--- a/include/linux/fsnotify.h	2010-11-01 12:54:12.000000000 +0100
+++ b/include/linux/fsnotify.h	2010-11-05 10:49:51.000000000 +0100
@@ -235,9 +235,6 @@ static inline void fsnotify_open(struct 
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_ISDIR;
 
-	/* FMODE_NONOTIFY must never be set from user */
-	file->f_mode &= ~FMODE_NONOTIFY;
-
 	fsnotify_parent(path, NULL, mask);
 	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
 }
