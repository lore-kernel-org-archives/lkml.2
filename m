Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab1ELXBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 19:01:21 -0400
Received: from kroah.org ([198.145.64.141]:36050 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756900Ab1ELXBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 19:01:20 -0400
Date: Thu, 12 May 2011 16:01:02 -0700
From: Greg KH <greg@kroah.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] sysfs: remove "last sysfs file:" line from the oops messages
Message-ID: <20110512230102.GA19069@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------------
I'm going to queue this up for the .40 kernel merge window, any
objections?
---------------

From: Greg Kroah-Hartman <gregkh@suse.de>

On some arches (x86, sh, arm, unicore, powerpc) the oops message would
print out the last sysfs file accessed.

This was very useful in finding a number of sysfs and driver core bugs
in the 2.5 and early 2.6 development days, but it has been a number of
years since this file has actually helped in debugging anything that
couldn't also be trivially determined from the stack traceback.

So it's time to delete the line.  This is good as we need all the space
we can get for oops messages at times on consoles.

Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/traps.c       |    1 -
 arch/powerpc/kernel/traps.c   |    1 -
 arch/sh/kernel/traps_32.c     |    1 -
 arch/unicore32/kernel/traps.c |    1 -
 arch/x86/kernel/dumpstack.c   |    1 -
 fs/sysfs/file.c               |   12 ------------
 include/linux/sysfs.h         |    5 -----
 7 files changed, 22 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 3b54ad1..d52eec2 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -234,7 +234,6 @@ static int __die(const char *str, int err, struct thread_info *thread, struct pt
 
 	printk(KERN_EMERG "Internal error: %s: %x [#%d]" S_PREEMPT S_SMP "\n",
 	       str, err, ++die_counter);
-	sysfs_printk_last_file();
 
 	/* trap and error numbers are mostly meaningless on ARM */
 	ret = notify_die(DIE_OOPS, str, regs, err, tsk->thread.trap_no, SIGSEGV);
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 5ddb801..d782cd7 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -143,7 +143,6 @@ int die(const char *str, struct pt_regs *regs, long err)
 #endif
 		printk("%s\n", ppc_md.name ? ppc_md.name : "");
 
-		sysfs_printk_last_file();
 		if (notify_die(DIE_OOPS, str, regs, err, 255,
 			       SIGSEGV) == NOTIFY_STOP)
 			return 1;
diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
index 3484c2f..b51a171 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -87,7 +87,6 @@ void die(const char * str, struct pt_regs * regs, long err)
 	bust_spinlocks(1);
 
 	printk("%s: %04lx [#%d]\n", str, err & 0xffff, ++die_counter);
-	sysfs_printk_last_file();
 	print_modules();
 	show_regs(regs);
 
diff --git a/arch/unicore32/kernel/traps.c b/arch/unicore32/kernel/traps.c
index 254e36f..b9a2646 100644
--- a/arch/unicore32/kernel/traps.c
+++ b/arch/unicore32/kernel/traps.c
@@ -192,7 +192,6 @@ static int __die(const char *str, int err, struct thread_info *thread,
 
 	printk(KERN_EMERG "Internal error: %s: %x [#%d]\n",
 	       str, err, ++die_counter);
-	sysfs_printk_last_file();
 
 	/* trap and error numbers are mostly meaningless on UniCore */
 	ret = notify_die(DIE_OOPS, str, regs, err, tsk->thread.trap_no, \
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index e2a3f06..f72e719 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -279,7 +279,6 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 	printk("DEBUG_PAGEALLOC");
 #endif
 	printk("\n");
-	sysfs_printk_last_file();
 	if (notify_die(DIE_OOPS, str, regs, err,
 			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
 		return 1;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index da3fefe..1ad8c93 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -24,13 +24,6 @@
 
 #include "sysfs.h"
 
-/* used in crash dumps to help with debugging */
-static char last_sysfs_file[PATH_MAX];
-void sysfs_printk_last_file(void)
-{
-	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
-}
-
 /*
  * There's one sysfs_buffer for each open file and one
  * sysfs_open_dirent for each sysfs_dirent with one or more open
@@ -337,11 +330,6 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	struct sysfs_buffer *buffer;
 	const struct sysfs_ops *ops;
 	int error = -EACCES;
-	char *p;
-
-	p = d_path(&file->f_path, last_sysfs_file, sizeof(last_sysfs_file));
-	if (!IS_ERR(p))
-		memmove(last_sysfs_file, p, strlen(p) + 1);
 
 	/* need attr_sd for attr and ops, its parent for kobj */
 	if (!sysfs_get_active(attr_sd))
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 30b8815..c3acda6 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -176,7 +176,6 @@ struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 				      const unsigned char *name);
 struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd);
 void sysfs_put(struct sysfs_dirent *sd);
-void sysfs_printk_last_file(void);
 
 /* Called to clear a ns tag when it is no longer valid */
 void sysfs_exit_ns(enum kobj_ns_type type, const void *tag);
@@ -348,10 +347,6 @@ static inline int __must_check sysfs_init(void)
 	return 0;
 }
 
-static inline void sysfs_printk_last_file(void)
-{
-}
-
 #endif /* CONFIG_SYSFS */
 
 #endif /* _SYSFS_H_ */

