Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750927Ab1BHFA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 00:00:29 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60788 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1BHFA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 00:00:28 -0500
Message-ID: <4D50CDE6.5000903@mvista.com>
Date: Tue, 08 Feb 2011 14:00:22 +0900
From: Tadashi Abe <tabe@mvista.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: x86@kernel.org
CC: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Fix io_bitmap_ptr memory leak on copy_process()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 copy_thread() allocates io_bitmap_ptr area in child's thread_struct
when the parent has TIF_IO_BITMAP flag via ioperm().
And in this case, if copy_process() terminates with errors
after copy_thread() success,
this io_bitmap_ptr area is being left without kfree().

Signed-off-by: Tadashi Abe <tabe@mvista.com>
---
 arch/x86/kernel/process.c |    6 ++++++
 include/linux/sched.h     |    5 +++++
 kernel/fork.c             |    4 +++-
 3 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b3feabc..290e98b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -122,6 +122,12 @@ void flush_thread(void)
 	clear_used_math();
 }
 
+void free_thread_struct(struct task_struct *p)
+{
+	if (p->thread.io_bitmap_ptr)
+		kfree(p->thread.io_bitmap_ptr);
+}
+
 static void hard_disable_TSC(void)
 {
 	write_cr4(read_cr4() | X86_CR4_TSD);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 23e9c27..2345391 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2159,6 +2159,11 @@ extern int copy_thread(unsigned long, unsigned long, unsigned long,
 			struct task_struct *, struct pt_regs *);
 extern void flush_thread(void);
 extern void exit_thread(void);
+#ifdef CONFIG_X86
+extern void free_thread_struct(struct task_struct *p);
+#else
+#define free_thread_struct(p) do { } while (0)
+#endif
 
 extern void exit_files(struct task_struct *);
 extern void __cleanup_sighand(struct sighand_struct *);
diff --git a/kernel/fork.c b/kernel/fork.c
index 25e4291..ffcabf3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1179,7 +1179,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		retval = -ENOMEM;
 		pid = alloc_pid(p->nsproxy->pid_ns);
 		if (!pid)
-			goto bad_fork_cleanup_io;
+			goto bad_fork_free_thread;
 
 		if (clone_flags & CLONE_NEWPID) {
 			retval = pid_ns_prepare_proc(p->nsproxy->pid_ns);
@@ -1315,6 +1315,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 bad_fork_free_pid:
 	if (pid != &init_struct_pid)
 		free_pid(pid);
+bad_fork_free_thread:
+	free_thread_struct(p);
 bad_fork_cleanup_io:
 	if (p->io_context)
 		exit_io_context(p);
-- 
1.7.3.4
