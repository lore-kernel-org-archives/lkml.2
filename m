Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1HOUzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:55:44 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41973 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1HOUzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:55:43 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: mcgrathr@google.com, Will Drewry <wad@chromium.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Hugh Dickins <hughd@google.com>, Shaohua Li <shaohua.li@intel.com>,
        linux-mm@kvack.org
Subject: [PATCH] mmap: add sysctl for controlling ~VM_MAYEXEC taint
Date: Mon, 15 Aug 2011 15:57:35 -0500
Message-Id: <1313441856-1419-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes a sysctl knob that allows a privileged user to
disable ~VM_MAYEXEC tainting when mapping in a vma from a MNT_NOEXEC
mountpoint.  It does not alter the normal behavior resulting from
attempting to directly mmap(PROT_EXEC) a vma (-EPERM) nor the behavior
of any other subsystems checking MNT_NOEXEC.

It is motivated by a common /dev/shm, /tmp usecase. There are few
facilities for creating a shared memory segment that can be remapped in
the same process address space with different permissions.  Often, a
file in /tmp provides this functionality.  However, on distributions
that are more restrictive/paranoid, world-writeable directories are
often mounted "noexec".  The only workaround to support software that
needs this behavior is to either not use that software or remount /tmp
exec.  (E.g., https://bugs.gentoo.org/350336?id=350336)  Given that
the only recourse is using SysV IPC, the application programmer loses
many of the useful ABI features that they get using a mmap'd file (and
as such are often hesitant to explore that more painful path).

With this patch, it would be possible to change the sysctl variable
such that mprotect(PROT_EXEC) would succeed.  In cases like the example
above, an additional userspace mmap-wrapper would be needed, but in
other cases, like how code.google.com/p/nativeclient mmap()s then
mprotect()s, the behavior would be unaffected.

The tradeoff is a loss of defense in depth, but it seems reasonable when
the alternative is to disable the defense entirely.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 kernel/sysctl.c |   12 ++++++++++++
 mm/Kconfig      |   17 +++++++++++++++++
 mm/mmap.c       |    4 +++-
 3 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 11d65b5..aa8bcc0 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -89,6 +89,9 @@
 /* External variables not in a header file. */
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
+#ifdef CONFIG_MMU
+extern int sysctl_mmap_noexec_taint;
+#endif
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
@@ -1293,6 +1296,15 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= mmap_min_addr_handler,
 	},
+	{
+		.procname	= "mmap_noexec_taint",
+		.data		= &sysctl_mmap_noexec_taint,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 #endif
 #ifdef CONFIG_NUMA
 	{
diff --git a/mm/Kconfig b/mm/Kconfig
index f2f1ca1..539dc12 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -256,6 +256,23 @@ config DEFAULT_MMAP_MIN_ADDR
 	  This value can be changed after boot using the
 	  /proc/sys/vm/mmap_min_addr tunable.
 
+config MMAP_NOEXEC_TAINT
+	int "Turns on tainting of mmap()d files from noexec mountpoints"
+	depends on MMU
+	default 1
+	help
+	  By default, the ability to change the protections of a virtual
+	  memory area to allow execution depend on if the vma has the
+	  VM_MAYEXEC flag.  When mapping regions from files, VM_MAYEXEC
+	  will be unset if the containing mountpoint is mounted MNT_NOEXEC.
+	  By setting the value to 0, any mmap()d region may be later
+	  mprotect()d with PROT_EXEC.
+
+	  If unsure, keep the value set to 1.
+
+	  This value can be changed after boot using the
+	  /proc/sys/vm/mmap_noexec_taint tunable.
+
 config ARCH_SUPPORTS_MEMORY_FAILURE
 	bool
 
diff --git a/mm/mmap.c b/mm/mmap.c
index a65efd4..7aceddd 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -87,6 +87,7 @@ EXPORT_SYMBOL(vm_get_page_prot);
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;  /* heuristic overcommit */
 int sysctl_overcommit_ratio __read_mostly = 50;	/* default is 50% */
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
+int sysctl_mmap_noexec_taint __read_mostly = CONFIG_DEFAULT_MMAP_NOEXEC_TAINT;
 /*
  * Make sure vm_committed_as in one cacheline and not cacheline shared with
  * other variables. It can be updated by several CPUs frequently.
@@ -1039,7 +1040,8 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 			if (file->f_path.mnt->mnt_flags & MNT_NOEXEC) {
 				if (vm_flags & VM_EXEC)
 					return -EPERM;
-				vm_flags &= ~VM_MAYEXEC;
+				if (sysctl_mmap_noexec_taint)
+					vm_flags &= ~VM_MAYEXEC;
 			}
 
 			if (!file->f_op || !file->f_op->mmap)
-- 
1.7.0.4

