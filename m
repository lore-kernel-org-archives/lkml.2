Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681Ab0J2KDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 06:03:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58599 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756616Ab0J2KDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 06:03:35 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1/r09lAzRTr4x3dj7e0cdFEZpvd5rUbixdYuSWaL/
	+lHUy3K6SGz3NJ
Date: Fri, 29 Oct 2010 12:02:17 +0200
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Ensure FMODE_NONOTIFY is not set by userspace
Message-ID: <20101029100217.GC26242@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    In fsnotify_open() ensure that FMODE_NONOTIFY is never set by userspace.
    Also always call fsnotify_parent and fsnotify.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
This patch applies against commit 3970d817558a426cc2f53eaa01182eb9452e0cb1
of branch 'origin/for-next' from git.infradead.org/users/eparis/notify.git


diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index ecb43b3..5c185fa 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -235,10 +235,11 @@ static inline void fsnotify_open(struct file *file)
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_ISDIR;
 
-	if (!(file->f_mode & FMODE_NONOTIFY)) {
-		fsnotify_parent(path, NULL, mask);
-		fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
-	}
+	/* FMODE_NONOTIFY must never be set from user */
+	file->f_mode &= ~FMODE_NONOTIFY;
+
+	fsnotify_parent(path, NULL, mask);
+	fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
 }
 
 /*
