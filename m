Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2A0SBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:01:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58161 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab2A0R7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:59:45 -0500
Message-Id: <20120127175939.862102158@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 27 Jan 2012 21:53:45 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: [RFC c/r 3/4] c/r: procfs: add arg_start/end, env_start/end and exit_code members to /proc/$pid/stat
References: <20120127175342.273260614@openvz.org>
Content-Disposition: inline; filename=fs-proc-extend-state
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would like to have an ability to restore command line
arguments and envirion pointers so the task being restored
would print appropriate values in /proc/pid/cmdline and
/proc/pid/envirion. The exit_code is needed to restore
zombie tasks.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 Documentation/filesystems/proc.txt |    5 +++++
 fs/proc/array.c                    |   23 ++++++++++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -311,6 +311,11 @@ Table 1-4: Contents of the stat files (a
   start_data    address above which program data+bss is placed
   end_data      address below which program data+bss is placed
   start_brk     address above which program heap can be expanded with brk()
+  arg_start     address above which program command line is placed
+  arg_end       address below which program command line is placed
+  env_start     address above which program environment is placed
+  env_end       address below which program environment is placed
+  exit_code     the thread's exit_code in the form reported by the waitpid system call
 ..............................................................................
 
 The /proc/PID/maps file containing the currently mapped memory regions and
Index: linux-2.6.git/fs/proc/array.c
===================================================================
--- linux-2.6.git.orig/fs/proc/array.c
+++ linux-2.6.git/fs/proc/array.c
@@ -464,7 +464,7 @@ static int do_task_stat(struct seq_file
 
 	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
+%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld ",
 		pid_nr_ns(pid, ns),
 		tcomm,
 		state,
@@ -511,10 +511,23 @@ static int do_task_stat(struct seq_file
 		task->policy,
 		(unsigned long long)delayacct_blkio_ticks(task),
 		cputime_to_clock_t(gtime),
-		cputime_to_clock_t(cgtime),
-		(mm && permitted) ? mm->start_data : 0,
-		(mm && permitted) ? mm->end_data : 0,
-		(mm && permitted) ? mm->start_brk : 0);
+		cputime_to_clock_t(cgtime));
+
+		if (mm && permitted) {
+			seq_printf(m, "%lu %lu %lu %lu %lu %lu %lu ",
+				   mm->start_data,
+				   mm->end_data,
+				   mm->start_brk,
+				   mm->arg_start,
+				   mm->arg_end,
+				   mm->env_start,
+				   mm->env_end);
+		} else {
+			seq_printf(m, "0 0 0 0 0 0 0 ");
+		}
+
+		seq_printf(m, "%d\n", task->exit_code);
+
 	if (mm)
 		mmput(mm);
 	return 0;

