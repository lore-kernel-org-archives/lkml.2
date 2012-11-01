Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762167Ab2KASfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 14:35:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57748 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab2KASfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 14:35:43 -0400
Date: Thu, 1 Nov 2012 11:35:16 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Will Drewry <wad@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Kees Cook <keescook@chromium.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-doc@vger.kernel.org
Subject: [PATCH v2] proc: add "Seccomp" to status
Message-ID: <20121101183516.GA18332@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is currently impossible to examine the state of seccomp for
a given process. While attaching with gdb and attempting "call
prctl(PR_GET_SECCOMP,...)" will work with some situations, it is not
reliable. If the process is in seccomp mode 1, this query will kill the
process (prctl not allowed), if the process is in mode 2 with prctl not
allowed, it will similarly be killed, and in weird cases, if prctl is
filtered to return errno 0, it can look like seccomp is disabled.

When reviewing the state of running processes, there should be a way to
externally examine the seccomp mode. ("Did this build of Chrome end up
using seccomp?" "Did my distro ship ssh with seccomp enabled?")

This adds the "Seccomp" line to /proc/$pid/status.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>

---
v2:
 - improve commit message, add documentation, as suggested by akpm.
---
 Documentation/filesystems/proc.txt |    2 ++
 fs/proc/array.c                    |    8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a1793d6..557891d 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -181,6 +181,7 @@ read the file /proc/PID/status:
   CapPrm: 0000000000000000
   CapEff: 0000000000000000
   CapBnd: ffffffffffffffff
+  Seccomp:        0
   voluntary_ctxt_switches:        0
   nonvoluntary_ctxt_switches:     1
 
@@ -237,6 +238,7 @@ Table 1-2: Contents of the status files (as of 2.6.30-rc7)
  CapPrm                      bitmap of permitted capabilities
  CapEff                      bitmap of effective capabilities
  CapBnd                      bitmap of capabilities bounding set
+ Seccomp                     seccomp mode, like prctl(PR_GET_SECCOMP, ...)
  Cpus_allowed                mask of CPUs on which this process may run
  Cpus_allowed_list           Same as previous, but in "list format"
  Mems_allowed                mask of memory nodes allowed to this process
diff --git a/fs/proc/array.c b/fs/proc/array.c
index c1c207c..135d6ac 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -327,6 +327,13 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
 	render_cap_t(m, "CapBnd:\t", &cap_bset);
 }
 
+static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
+{
+#ifdef CONFIG_SECCOMP
+	seq_printf(m, "Seccomp:\t%d\n", p->seccomp.mode);
+#endif
+}
+
 static inline void task_context_switch_counts(struct seq_file *m,
 						struct task_struct *p)
 {
@@ -360,6 +367,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	}
 	task_sig(m, task);
 	task_cap(m, task);
+	task_seccomp(m, task);
 	task_cpus_allowed(m, task);
 	cpuset_task_status_allowed(m, task);
 	task_context_switch_counts(m, task);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
