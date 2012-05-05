Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2EENtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 09:49:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54693 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab2EENtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 09:49:21 -0400
From: Pierre Carrier <pierre@spotify.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Pierre Carrier <pierre@spotify.com>
Subject: [PATCH 1/1] procfs: expose umask in stat and status
Date: Sat,  5 May 2012 15:49:08 +0200
Message-Id: <1336225748-18693-1-git-send-email-pierre@spotify.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <20120505230054.66b0ed1461ac961a2fd1e20d@canb.auug.org.au>
References: <20120505230054.66b0ed1461ac961a2fd1e20d@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- A new stat field prints umask (or -errno if unavailable) in decimal.
- A new status line prints umask in octal whenever available.

Background
----------

Sometimes processes conditionally set their umask, making it hard to know
how files will be created, specially when the open(3) depends on external
factors (eg. remote file server).

Another source of difficulties is daemons inheriting their umask.
Without prior knowledge about the spawning process, the umask can be
hard to know without process inspection.

Knowing the umask is often required to predict the mode used in
future file creation. Knowing the umasks can then be needed to detect or
catch certain security issues on a running system.

Current approaches
------------------

As the kernel doesn't expose it to userspace across process boundaries,
the known available generic solutions to inspect it involve side effects
that may not be acceptable and introduce new userspace tooling
dependencies.
- Attaching gdb to a process will cause delays and degrade performance.
  'call' is needed, which could introduce side effects.
- systemtap also requires utrace, currently missing from mainline, and
  debugging information which can be hard to make available.
  Performance would also degrade.

Process-specific solutions can be cumbersome (eg getting credentials for
a network service, accessing a client implementation to trigger a file
creation, then observing the filesystem), or downright too intrusive
(eg triggering a database creation for a db server, or logging an event
that would later be involved in analytics processes, etc.).

Offered solution
----------------

Offering this information through procfs's stat (resp. status) makes it
straightforward for userspace tools (resp. humans) to access it.
Running systems can be troubleshot or audited without any significant
risk of affecting the system.

Signed-off-by: Pierre Carrier <pierre@spotify.com>
---
Changes from first LKML submission to cover Stephen Rothwell's
feedback:
- Use %#o to print octal.
- Provide use cases.

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
index f9bd395..5ee5731 100644
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
+		seq_printf(m, "Umask:\t%#o\n", umask);
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

