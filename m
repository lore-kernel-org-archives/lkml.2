Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab0DAMn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:43:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54876 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab0DAMnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:43:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Date: Thu, 1 Apr 2010 14:42:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <201003312221.23953.arnd@arndb.de> <20100331214058.GE5163@nowhere>
In-Reply-To: <20100331214058.GE5163@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011442.38536.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19GMFItWTkmF+AVXWsDZq35nAu5LNxu1uiw34H
 vdNkLunOczvg462AW2Q6K0CDMHT1BOAExy6fUmWv8a9NlGmSaK
 Bj56ZXGVZtnlHzSK0TcrQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 March 2010, Frederic Weisbecker wrote:
> On Wed, Mar 31, 2010 at 10:21:23PM +0200, Arnd Bergmann wrote:
> 
> > In the meantime, we can move the declaration of the .locked_ioctl callback
> > into an #ifdef CONFIG_BKL, to make sure nobody builds a driver with an
> > ioctl function that does not get called.
> 
> 
> Ok, now how to get this all merged? A single monolithic patch is probably
> not appropriate.
> 
> The simplest is to have a single branch with the default_ioctl implemented,
> and then attributed to drivers in a set cut by subsystems/drivers. And
> push the whole for the next -rc1.
> 
> The other solution is to push default_ioctl for this release and get
> the driver changes to each concerned tree. That said, I suspect a good
> part of them are unmaintained, hence the other solution looks better
> to me.

I don't care much about the unmaintained parts, we can always have a
tree collecting all the patches for those drivers and merge it in -rc1.

I'd say the nicest way would be to get Linus to merge the patch
below now, so we can start queuing stuff in maintainer trees on top
of it, and check against linux-next what is still missing and push
all of them from our branch.

	Arnd

---
Subject: [PATCH] introduce CONFIG_BKL and default_ioctl

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
	.unlocked_ioctl = default_ioctl,

As soon as no driver remains using the old ioctl callback, it can
get removed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ioctl.c               |   22 ++++++++++++++++++++++
 include/linux/fs.h       |    3 +++
 include/linux/smp_lock.h |    4 ++++
 lib/Kconfig.debug        |   10 ++++++++++
 4 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 6c75110..52c2698 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -58,6 +58,28 @@ static long vfs_ioctl(struct file *filp, unsigned int cmd,
 	return error;
 }
 
+#ifdef CONFIG_BKL
+/*
+ * default_ioctl - call unlocked_ioctl with BKL held
+ *
+ * Setting only the the ioctl operation but not unlocked_ioctl will become
+ * invalid in the future, all drivers that are not converted to unlocked_ioctl
+ * should set .unlocked_ioctl = default_ioctl now.
+ */
+long default_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
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
index 10b8ded..93afdb4 100644
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
index 2ea1dd1..9cec605 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -62,4 +62,8 @@ static inline void cycle_kernel_lock(void)
 #define kernel_locked()				1
 
 #endif /* CONFIG_LOCK_KERNEL */
+
+loff_t default_llseek(struct file *file, loff_t offset, int origin);
+long default_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+
 #endif /* __LINUX_SMPLOCK_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1fafb4b..a4852d6 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -444,6 +444,16 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.
 
+config BKL
+	def_bool y
+	help
+	  This is the traditional lock that is used in old code instead
+	  of proper locking. All drivers that use the BKL should depend
+	  on this symbol.
+	  This configuration option will become user-selectable in the
+	  future, as soon as it is possible to build a kernel without
+	  it.
+
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
