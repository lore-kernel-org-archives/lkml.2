Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab0LFDv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 22:51:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab0LFDv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 22:51:57 -0500
From: Ian Kent <raven@themaw.net>
Subject: [PATCH] autofs4 - remove ioctl mutex
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        autofs mailing list <autofs@linux.kernel.org>
Date: Mon, 06 Dec 2010 11:51:23 +0800
Message-ID: <20101206035123.28966.79954.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent changes to remove the BKL a mutex was added to the
ioctl entry point for calls to the old ioctl interface. This mutex
needs to be removed because of the need for the expire ioctl to call
back to the daemon to perform a umount and receive a completion
status (via another ioctl).

This should be fine as the new ioctl interface uses much of the same
code and it has been used without a mutex for around a year without
issue, as was the original intention.
---

 fs/autofs4/root.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index d5c1401..d34896c 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -980,19 +980,11 @@ static int autofs4_root_ioctl_unlocked(struct inode *inode, struct file *filp,
 	}
 }
 
-static DEFINE_MUTEX(autofs4_ioctl_mutex);
-
 static long autofs4_root_ioctl(struct file *filp,
 			       unsigned int cmd, unsigned long arg)
 {
-	long ret;
 	struct inode *inode = filp->f_dentry->d_inode;
-
-	mutex_lock(&autofs4_ioctl_mutex);
-	ret = autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
-	mutex_unlock(&autofs4_ioctl_mutex);
-
-	return ret;
+	return autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
 }
 
 #ifdef CONFIG_COMPAT
@@ -1002,13 +994,11 @@ static long autofs4_root_compat_ioctl(struct file *filp,
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	int ret;
 
-	mutex_lock(&autofs4_ioctl_mutex);
 	if (cmd == AUTOFS_IOC_READY || cmd == AUTOFS_IOC_FAIL)
 		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd, arg);
 	else
 		ret = autofs4_root_ioctl_unlocked(inode, filp, cmd,
 			(unsigned long)compat_ptr(arg));
-	mutex_unlock(&autofs4_ioctl_mutex);
 
 	return ret;
 }

