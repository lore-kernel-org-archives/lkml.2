Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2AWVcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:32:51 -0500
Received: from smtp.outflux.net ([198.145.64.163]:41300 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab2AWVct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:32:49 -0500
Date: Mon, 23 Jan 2012 13:21:15 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Borislav Petkov <bp@alien8.de>,
        Vasiliy Kulikov <segoon@openwall.com>, Dan Ballard <dan@mindstab.net>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org
Subject: [PATCH v3] sysctl: control functionality of /proc/pid/mem
Message-ID: <20120123212115.GA29641@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add the "proc_pid_mem" sysctl to control whether or not /proc/pid/mem is
allowed to work: 0: disabled, 1: read only, 2: read/write (default).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v3:
 - document the default, thanks to Randy Dunlap.
 - remove needless CONFIG_PROC_FS checks, thanks to Eric W. Biederman.
v2:
 - fix memory leak in error path, thanks to Ingo Molnar.
---
 Documentation/sysctl/kernel.txt |   15 +++++++++++++++
 fs/proc/base.c                  |   14 +++++++++++++-
 kernel/sysctl.c                 |   10 ++++++++++
 3 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 8c20fbd..9e7bad6 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -56,6 +56,7 @@ show up in /proc/sys/kernel:
 - printk_delay
 - printk_ratelimit
 - printk_ratelimit_burst
+- proc_pid_mem
 - randomize_va_space
 - real-root-dev               ==> Documentation/initrd.txt
 - reboot-cmd                  [ SPARC only ]
@@ -477,6 +478,20 @@ send before ratelimiting kicks in.
 
 ==============================================================
 
+proc_pid_mem:
+
+This option can be used to select the level of access given to potential
+ptracers when using the per-process "mem" file in /proc/pid/mem.
+
+0 - Disable entirely.
+
+1 - Allow potential ptracers read access to process memory, but not writes.
+
+2 - Allow potential ptracers read and write access to process memory. This
+    is the default.
+
+==============================================================
+
 randomize_va_space:
 
 This option can be used to select the type of process address
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9cde9ed..53133c7 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -109,6 +109,8 @@ struct pid_entry {
 	union proc_op op;
 };
 
+int sysctl_proc_pid_mem = 2;
+
 #define NOD(NAME, MODE, IOP, FOP, OP) {			\
 	.name = (NAME),					\
 	.len  = sizeof(NAME) - 1,			\
@@ -699,9 +701,13 @@ static const struct file_operations proc_single_file_operations = {
 
 static int mem_open(struct inode* inode, struct file* file)
 {
-	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	struct task_struct *task;
 	struct mm_struct *mm;
 
+	if (sysctl_proc_pid_mem < 1)
+		return -EACCES;
+
+	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
 
@@ -726,6 +732,9 @@ static ssize_t mem_read(struct file * file, char __user * buf,
 	unsigned long src = *ppos;
 	struct mm_struct *mm = file->private_data;
 
+	if (sysctl_proc_pid_mem < 1)
+		return -EACCES;
+
 	if (!mm)
 		return 0;
 
@@ -770,6 +779,9 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
 	unsigned long dst = *ppos;
 	struct mm_struct *mm = file->private_data;
 
+	if (sysctl_proc_pid_mem < 2)
+		return -EACCES;
+
 	if (!mm)
 		return 0;
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f487f25..6fd4bc0 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -103,6 +103,7 @@ extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
+extern int sysctl_proc_pid_mem;
 #ifndef CONFIG_MMU
 extern int sysctl_nr_trim_pages;
 #endif
@@ -1004,6 +1005,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+	{
+		.procname	= "proc_pid_mem",
+		.data		= &sysctl_proc_pid_mem,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &two,
+	},
 	{ }
 };
 
-- 
1.7.0.4

