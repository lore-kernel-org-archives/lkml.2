Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab2EECuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 22:50:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36398 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab2EECui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 22:50:38 -0400
From: Pierre Carrier <pierre@spotify.com>
To: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Pierre Carrier <pierre@spotify.com>
Subject: [PATCH 1/1] procfs: expose umask in stat and status
Date: Sat,  5 May 2012 04:50:27 +0200
Message-Id: <1336186227-1941-1-git-send-email-pierre@spotify.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new stat field uses decimal, contains umask or -ENOENT if !task->fs.
A new status line is displayed if task->fs, and uses octal.

Signed-off-by: Pierre Carrier <pierre@spotify.com>
---
Tested shortly.

$ awk '{print $NF}' /proc/1/stat
18
$ grep Umask /proc/1/status
Umask:  022
$ umask 077
$ grep Umask /proc/$$/status
Umask:  077
$ umask 0
$ grep Umask /proc/$$/status
Umask:  00

 Documentation/filesystems/proc.txt |    2 ++
 fs/proc/array.c                    |   24 +++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index b7413cb..aa33543 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -212,6 +212,7 @@ Table 1-2: Contents of the status files (as of 2.6.30-rc7)
  TracerPid                   PID of process tracing this process (0 if not)
  Uid                         Real, effective, saved set, and  file system UIDs
  Gid                         Real, effective, saved set, and  file system GIDs
+ Umask                       file mode creation mask
  FDSize                      number of file descriptor slots currently allocated
  Groups                      supplementary group list
  VmPeak                      peak virtual memory size
@@ -310,6 +311,7 @@ Table 1-4: Contents of the stat files (as of 2.6.30-rc7)
   start_data    address above which program data+bss is placed
   end_data      address below which program data+bss is placed
   start_brk     address above which program heap can be expanded with brk()
+  umask         file creation mode mask
 ..............................................................................
 
 The /proc/PID/maps file containing the currently mapped memory regions and
diff --git a/fs/proc/array.c b/fs/proc/array.c
index f9bd395..5e7d5df 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -81,6 +81,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
+#include <linux/fs_struct.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -158,11 +159,24 @@ static inline const char *get_task_state(struct task_struct *tsk)
 	return *p;
 }
 
+static inline int get_task_umask(struct task_struct *tsk)
+{
+	struct fs_struct *fs;
+	int umask = -ENOENT;
+
+	task_lock(tsk);
+	fs = tsk->fs;
+	if (fs)
+		umask = fs->umask;
+	task_unlock(tsk);
+	return umask;
+}
+
 static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *p)
 {
 	struct group_info *group_info;
-	int g;
+	int g, umask;
 	struct fdtable *fdt = NULL;
 	const struct cred *cred;
 	pid_t ppid, tpid;
@@ -192,6 +206,10 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		cred->uid, cred->euid, cred->suid, cred->fsuid,
 		cred->gid, cred->egid, cred->sgid, cred->fsgid);
 
+	umask = get_task_umask(p);
+	if (umask >= 0)
+		seq_printf(m, "Umask:\t0%o\n", umask);
+
 	task_lock(p);
 	if (p->files)
 		fdt = files_fdtable(p->files);
@@ -368,6 +386,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	pid_t ppid = 0, pgid = -1, sid = -1;
 	int num_threads = 0;
 	int permitted;
+	int umask;
 	struct mm_struct *mm;
 	unsigned long long start_time;
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
@@ -462,6 +481,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(start_time);
 
+	umask = get_task_umask(task);
+
 	seq_printf(m, "%d (%s) %c", pid_nr_ns(pid, ns), tcomm, state);
 	seq_put_decimal_ll(m, ' ', ppid);
 	seq_put_decimal_ll(m, ' ', pgid);
@@ -511,6 +532,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->start_data : 0);
 	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->end_data : 0);
 	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->start_brk : 0);
+	seq_put_decimal_ll(m, ' ', umask);
 	seq_putc(m, '\n');
 	if (mm)
 		mmput(mm);
-- 
1.7.10.1

