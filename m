Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2AUJQK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 04:16:10 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46056 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab2AUJQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 04:16:06 -0500
Date: Sat, 21 Jan 2012 01:06:44 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Vasiliy Kulikov <segoon@openwall.com>,
        Dan Ballard <dan@mindstab.net>, Jiri Kosina <jkosina@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org
Subject: [PATCH v2] sysctl: control functionality of /proc/pid/mem
Message-ID: <20120121090644.GA31670@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the "proc_pid_mem" sysctl to control whether or not /proc/pid/mem is
allowed to work: 0: disabled, 1: read only, 2: read/write.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/sysctl/kernel.txt |   14 ++++++++++++++
 fs/proc/base.c                  |   14 +++++++++++++-
 kernel/sysctl.c                 |   14 ++++++++++++++
 3 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 8c20fbd..6d52dba 100644
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
@@ -477,6 +478,19 @@ send before ratelimiting kicks in.
 
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
+2 - Allow potential ptracers read and write access to process memory.
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
index f487f25..dda911f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -109,6 +109,9 @@ extern int sysctl_nr_trim_pages;
 #ifdef CONFIG_BLOCK
 extern int blk_iopoll_enabled;
 #endif
+#ifdef CONFIG_PROC_FS
+extern int sysctl_proc_pid_mem;
+#endif
 
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_LOCKUP_DETECTOR
@@ -1004,6 +1007,17 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_PROC_FS
+	{
+		.procname	= "proc_pid_mem",
+		.data		= &sysctl_proc_pid_mem,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &two,
+	},
+#endif
 	{ }
 };
 
-- 
1.7.0.4

