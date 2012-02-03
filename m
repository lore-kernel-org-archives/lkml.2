Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab2BCP1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:27:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60549 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2BCP07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:26:59 -0500
Message-Id: <20120203152650.827624790@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 03 Feb 2012 19:19:31 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: [patch 3/4] c/r: procfs: add arg_start/end, env_start/end and exit_code members to /proc/$pid/stat
References: <20120203151928.474036973@openvz.org>
Content-Disposition: inline; filename=fs-proc-extend-state-2-linux-next
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would like to have an ability to restore command line
arguments and program environment pointers but first we
need to obtain them somehow. Thus we put these values into
/proc/$pid/stat. The exit_code is needed to restore zombie
tasks.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 Documentation/filesystems/proc.txt |    5 +++++
 fs/proc/array.c                    |   20 +++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

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
@@ -508,9 +508,23 @@ static int do_task_stat(struct seq_file
 	seq_put_decimal_ull(m, ' ', delayacct_blkio_ticks(task));
 	seq_put_decimal_ull(m, ' ', cputime_to_clock_t(gtime));
 	seq_put_decimal_ll(m, ' ', cputime_to_clock_t(cgtime));
-	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->start_data : 0);
-	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->end_data : 0);
-	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->start_brk : 0);
+
+	if (mm && permitted) {
+		seq_put_decimal_ull(m, ' ', mm->start_data);
+		seq_put_decimal_ull(m, ' ', mm->end_data);
+		seq_put_decimal_ull(m, ' ', mm->start_brk);
+		seq_put_decimal_ull(m, ' ', mm->arg_start);
+		seq_put_decimal_ull(m, ' ', mm->arg_end);
+		seq_put_decimal_ull(m, ' ', mm->env_start);
+		seq_put_decimal_ull(m, ' ', mm->env_end);
+	} else
+		seq_printf(m, " 0 0 0 0 0 0 0");
+
+	if (permitted)
+		seq_put_decimal_ll(m, ' ', task->exit_code);
+	else
+		seq_put_decimal_ll(m, ' ', 0);
+
 	seq_putc(m, '\n');
 	if (mm)
 		mmput(mm);

