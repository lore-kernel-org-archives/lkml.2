Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab1ELDHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 23:07:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61845 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab1ELDHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 23:07:51 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Paris <eparis@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        kees.cook@canonical.com, agl@chromium.org, jmorris@namei.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Will Drewry <wad@chromium.org>
Subject: [PATCH 5/5] v2 seccomp_filter: Document what seccomp_filter is and how it works.
Date: Wed, 11 May 2011 22:04:46 -0500
Message-Id: <1305169486-2535-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <BANLkTim16KCwq__L=3OEsDkvQe3yojtc5Q@mail.gmail.com>
References: <BANLkTim16KCwq__L=3OEsDkvQe3yojtc5Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a text file covering what CONFIG_SECCOMP_FILTER is, how it is
implemented presently, and what it may be used for.  In addition,
the limitations and caveats of the proposed implementation are
included.

v2: moved to prctl/
    updated for the v2 syntax.
    adds a note about compat behavior

Signed-off-by: Will Drewry <wad@chromium.org>
---
 Documentation/prctl/seccomp_filter.txt |  156 ++++++++++++++++++++++++++++++++
 1 files changed, 156 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/prctl/seccomp_filter.txt

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
new file mode 100644
index 0000000..4c1686a
--- /dev/null
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -0,0 +1,156 @@
+		Seccomp filtering
+		=================
+
+Introduction
+------------
+
+A large number of system calls are exposed to every userland process
+with many of them going unused for the entire lifetime of the process.
+As system calls change and mature, bugs are found and eradicated.  A
+certain subset of userland applications benefit by having a reduce set
+of available system calls.  The reduced set reduces the total kernel
+surface exposed to the application.  System call filtering is meant for
+use with those applications.
+
+The implementation currently leverages both the existing seccomp
+infrastructure and the kernel tracing infrastructure.  By centralizing
+hooks for attack surface reduction in seccomp, it is possible to assure
+attention to security that is less relevant in normal ftrace scenarios,
+such as time-of-check, time-of-use attacks.  However, ftrace provides a
+rich, human-friendly environment for interfacing with system call
+specific arguments.  (As such, this requires FTRACE_SYSCALLS for any
+introspective filtering support.)
+
+
+What it isn't
+-------------
+
+System call filtering isn't a sandbox.  It provides a clearly defined
+mechanism for minimizing the exposed kernel surface.  Beyond that,
+policy for logical behavior and information flow should be managed with
+an LSM of your choosing. Filtering based on the ftrace filter engine
+provides further options down this path (avoiding pathological sizes,
+for instance), but it could be misconstrued for a real sandbox.
+
+
+Usage
+-----
+
+An additional seccomp mode is exposed through mode '2',
+PR_SECCOMP_MODE_FILTER.  This mode depends on CONFIG_SECCOMP_FILTER
+which in turn depends on CONFIG_FTRACE_SYSCALLS.
+
+A collection of filters may be supplied via prctl, and the current set
+of filters is exposed in /proc/<pid>/seccomp_filter.
+
+Interacting with seccomp filters can be done through three new prctl calls
+and one existing one.
+
+PR_SET_SECCOMP: A pre-existing option for enabling strict seccomp
+	mode (1) or filtering seccomp. This option now takes an
+	additional "flags" argument.
+
+	Usage:
+		prctl(PR_SET_SECCOMP, 1);
+		prctl(PR_SET_SECCOMP, PR_SECCOMP_MODE_FILTER, 0);
+	Flags:
+	- 0: Empty set.
+	- PR_SECCOMP_FLAG_FILTER_ON_EXEC: Delays enforcement of seccomp
+	  enforcment only on MODE_FILTER until an exec() call is seen.
+
+PR_SET_SECCOMP_FILTER: Allows the specification of a new filter for
+	a given system call, by number, and filter string. If
+	CONFIG_FTRACE_SYSCALLS is supported, the filter string may be
+	any valid value for the given system call.  If it is not
+	supported, the filter string may only be "1" or "0".
+
+	All calls to PR_SET_SECCOMP_FILTER for a given system
+	call will append the supplied string to any existing filters.
+	Filter construction looks as follows:
+		(Nothing) + "fd == 1 || fd == 2" => fd == 1 || fd == 2
+		... + "fd != 2" => (fd == 1 || fd == 2) && fd != 2
+		... + "size < 100" =>
+			((fd == 1 || fd == 2) && fd != 2) && size < 100
+	If there is no filter and the seccomp mode has already
+	transitioned to filtering, additions cannot be made.  Filters
+	may only be added that reduce the available kernel surface.
+
+	Usage (per the construction example above):
+		prctl(PR_SET_SECCOMP_FILTER, __NR_write, "fd == 1 || fd == 2");
+		prctl(PR_SET_SECCOMP_FILTER, __NR_write, "fd != 2");
+		prctl(PR_SET_SECCOMP_FILTER, __NR_write, "size < 100");
+
+PR_CLEAR_SECCOMP_FILTER: Removes all filter entries for a given system
+	call number.  When called prior to entering seccomp filtering
+	mode, it allows for new filters to be applied to the same system
+	call.  After transition, however, it completely drops access to
+	the call.
+
+	Usage:
+		prctl(PR_CLEAR_SECCOMP_FILTER, __NR_open);
+
+PR_GET_SECCOMP_FILTER: Returns the aggregated filter string for a system
+	call into a user-supplied buffer of a given length.
+
+	Usage:
+		prctl(PR_GET_SECCOMP_FILTER, __NR_write, buf,
+		      sizeof(buf));
+
+All of the above calls return 0 on success and non-zero on error.
+
+
+Example
+-------
+
+Assume a process would like to cleanly read and write to stdin/out/err
+as well as access its filters after seccomp enforcement begins.  This
+may be done as follows:
+
+  prctl(PR_SET_SECCOMP_FILTER, __NR_read, "fd == 0");
+  prctl(PR_SET_SECCOMP_FILTER, __NR_write, "fd == 1 || fd == 2");
+  prctl(PR_SET_SECCOMP_FILTER, __NR_exit, "1");
+  prctl(PR_SET_SECCOMP_FILTER, __NR_prctl, "1");
+
+  prctl(PR_SET_SECCOMP, PR_SECCOMP_MODE_FILTER, 0);
+
+  /* Do stuff with fdset . . .*/
+
+  /* Drop read access and keep only write access to fd 1. */
+  prctl(PR_CLEAR_SECCOMP_FILTER, __NR_read);
+  prctl(PR_SET_SECCOMP_FILTER, __NR_write, "fd != 2");
+
+  /* Perform any final processing . . . */
+  syscall(__NR_exit, 0);
+
+If the initial setup had been handled through a launcher of some sort,
+the call to PR_SET_SECCOMP may have been replaced with:
+  prctl(PR_SET_SECCOMP, PR_SECCOMP_MODE_FILTER, PR_SECCOMP_FLAG_FILTER_ON_EXEC);
+  /* ... */
+  execve(path, args);
+
+This will continue to allow system calls to proceed uninspected until an
+exec*() call is seen.  From that point onward, the calling process will
+have filters enforced.
+
+
+Caveats
+-------
+
+- The filter event subsystem comes from CONFIG_TRACE_EVENTS, and the
+system call events come from CONFIG_FTRACE_SYSCALLS.  However, if
+neither are available, a filter string of "1" will be honored, and it may
+be removed using PR_CLEAR_SECCOMP_FILTER.  With ftrace filtering,
+calling PR_SET_SECCOMP_FILTER with a filter of "0" would have similar
+affect but would not be consistent on a kernel without the support.
+
+- Some platforms support a 32-bit userspace with 64-bit kernels.  In
+these cases (CONFIG_COMPAT), system call numbers may not match across
+64-bit and 32-bit system calls.  This may be especially relevant when
+filters are inherited across execution contexts.  If filters are created
+in a non-compat context then inherited into a compat context, the
+inheriting process will be terminated if seccomp filtering mode is
+enabled.  If it is not yet enabled, the inheriting process may iterate
+over the available system calls clearing any existing values.  Once no
+filters remain, it can begin setting new filters based on its own
+context.  (This behavior is bidirectional: compat->non-compat,
+non-compat->compat.)
-- 
1.7.0.4

