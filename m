Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0DVAr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 20:47:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47874 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab0DVAr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 20:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Ouk2y2/rp4dSRzd4c/4EOfEtnBhA2wRCJg/T/BJa3pk5TGmbj7g7XQO3j5NIUM1fmE
         Ru4i/4yCipn1cx3FN0BoBGMFNgEQ/4SjwnMSkCcLJtk50kf/I0IpgmBusRpfsBmakwVP
         GMwhEAByy/k0eYMsdph652DgDnDnpgxPJWkWU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@ZenIV.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Date: Thu, 22 Apr 2010 02:48:02 +0200
Message-Id: <1271897282-11207-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

In this v2, I've removed the declaration of default_llseek
from smp_lock.h, as this export can be made later (we
want to make any use of default_llseek() depend on
CONFIG_BKL as well, but that can wait).

Please pull the bkl/ioctl-v2 branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/ioctl-v2

Thanks,
	Frederic
---

Arnd Bergmann (1):
      vfs: Introduce CONFIG_BKL and deprecated_ioctl


 fs/ioctl.c               |   22 ++++++++++++++++++++++
 include/linux/fs.h       |    3 +++
 include/linux/smp_lock.h |    3 +++
 kernel/Kconfig.locks     |   10 ++++++++++
 4 files changed, 38 insertions(+), 0 deletions(-)

---
commit 333f5fb46d15d057f0d69da0dd8b0a3db89bf34f
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu Apr 1 14:42:38 2010 +0200

    vfs: Introduce CONFIG_BKL and deprecated_ioctl
    
    This is a preparation for the removal of the big kernel lock that
    introduces new interfaces for device drivers still using it.
    
    We can start marking those device drivers as 'depends on CONFIG_BKL'
    now, and make that symbol optional later, when the point has come
    at which we are able to build a kernel without the BKL.
    
    Similarly, device drivers that currently make use of the implicit
    BKL locking around the ioctl function can now get annotated by
    changing
    
    	.ioctl = foo_ioctl,
    
    to
    
    	.locked_ioctl = foo_ioctl,
    	.unlocked_ioctl = deprecated_ioctl,
    
    As soon as no driver remains using the old ioctl callback, it can
    get removed.
    
    [fweisbec: move config bkl from Kconfig.debug to Kconfig.locks,
    rename default_ioctl to deprecated_ioctl]
    
    v2: Remove default_llseek() declaration from smp_lock.h, we
    don't need to prepare it to be modularized right now.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 6c75110..e6d6a75 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -58,6 +58,28 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
 	return error;
 }
 
+#ifdef CONFIG_BKL
+/*
+ * deprecated_ioctl - call locked_ioctl with BKL held
+ *
+ * Setting only the ioctl operation but not unlocked_ioctl will become
+ * invalid in the future, all drivers that are not converted to unlocked_ioctl
+ * should set .unlocked_ioctl = deprecated_ioctl now.
+ */
+long deprecated_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	int error = -ENOTTY;
+	if (filp->f_op->locked_ioctl) {
+		lock_kernel();
+		error = filp->f_op->locked_ioctl(filp->f_path.dentry->d_inode,
+						 filp, cmd, arg);
+		unlock_kernel();
+	}
+	return error;
+}
+EXPORT_SYMBOL_GPL(default_ioctl);
+#endif
+
 static int ioctl_fibmap(struct file *filp, int __user *p)
 {
 	struct address_space *mapping = filp->f_mapping;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 39d57bc..6b65b26 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1492,6 +1492,9 @@ struct file_operations {
 	int (*readdir) (struct file *, void *, filldir_t);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
+#ifdef CONFIG_BKL
+	int (*locked_ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
+#endif
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index 2ea1dd1..3ed34da 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -62,4 +62,7 @@ static inline void cycle_kernel_lock(void)
 #define kernel_locked()				1
 
 #endif /* CONFIG_LOCK_KERNEL */
+
+long deprecated_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+
 #endif /* __LINUX_SMPLOCK_H */
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 88c92fb..9a80413 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -200,3 +200,13 @@ config INLINE_WRITE_UNLOCK_IRQRESTORE
 
 config MUTEX_SPIN_ON_OWNER
 	def_bool SMP && !DEBUG_MUTEXES && !HAVE_DEFAULT_NO_SPIN_MUTEXES
+
+config BKL
+	def_bool y
+	help
+	  This is the traditional lock that is used in old code instead
+	  of proper locking. All drivers that use the BKL should depend
+	  on this symbol.
+	  This configuration option will become user-selectable in the
+	  future, as soon as it is possible to build a kernel without
+	  it.
