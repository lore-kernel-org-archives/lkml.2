Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab1FADMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 23:12:43 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:32782 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657Ab1FADKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 23:10:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OsOvJgq/dSA9podg6CiIq6+KqS4q7+gJz5qEXt76VrVl9Oi52oQ6f2PTIFc0Q4TDmb
         cdaWdRMORncg57Jbkj9dTv7kPwzS63f9uaLX+fZGjEQ02WMbEiAGHLcQGMmyR7OIA5S+
         9HrCc4LXVAYF4wFZFTSRfvIhOFadGTFC0YEGM=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: kees.cook@canonical.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu, rostedt@goodmis.org, jmorris@namei.org,
        Will Drewry <wad@chromium.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH v3 05/13] seccomp_filter: Document what seccomp_filter is and how it works.
Date: Tue, 31 May 2011 22:10:37 -0500
Message-Id: <1306897845-9393-5-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Adds a text file covering what CONFIG_SECCOMP_FILTER is, how it is
 implemented presently, and what it may be used for.  In addition,
 the limitations and caveats of the proposed implementation are
 included.

 v3: a little more cleanup
 v2: moved to prctl/
     updated for the v2 syntax.
     adds a note about compat behavior

 Signed-off-by: Will Drewry <wad@chromium.org>
---
 Documentation/prctl/seccomp_filter.txt |  145 ++++++++++++++++++++++++++++++++
 1 files changed, 145 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/prctl/seccomp_filter.txt

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
new file mode 100644
index 0000000..27ac5af
--- /dev/null
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -0,0 +1,145 @@
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
+a combinations of other system hardening techniques and, potentially, a
+LSM of your choosing.  Expressive, dynamic filters based on the ftrace
+filter engine provide further options down this path (avoiding
+pathological sizes or selecting which of the multiplexed system calls in
+socketcall() is allowed, for instance) which could be construed,
+incorrectly, as a more complete sandboxing solution.
+
+
+Usage
+-----
+
+An additional seccomp mode is exposed through mode '2'.
+This mode depends on CONFIG_SECCOMP_FILTER.  By default, it provides
+only the most trivial of filter support "1" or cleared.  However, if
+CONFIG_FTRACE_SYSCALLS is enabled, the ftrace filter engine may be used
+for more expressive filters.
+
+A collection of filters may be supplied via prctl, and the current set
+of filters is exposed in /proc/<pid>/seccomp_filter.
+
+Interacting with seccomp filters can be done through three new prctl calls
+and one existing one.
+
+PR_SET_SECCOMP:
+	A pre-existing option for enabling strict seccomp mode (1) or
+	filtering seccomp (2).
+
+	Usage:
+		prctl(PR_SET_SECCOMP, 1);  /* strict */
+		prctl(PR_SET_SECCOMP, 2);  /* filters */
+
+PR_SET_SECCOMP_FILTER:
+	Allows the specification of a new filter for a given system
+	call, by number, and filter string. If CONFIG_FTRACE_SYSCALLS is
+	supported, the filter string may be any valid value for the
+	given system call.  If it is not supported, the filter string
+	may only be "1".
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
+PR_CLEAR_SECCOMP_FILTER:
+	Removes all filter entries for a given system call number.  When
+	called prior to entering seccomp filtering mode, it allows for
+	new filters to be applied to the same system call.  After
+	transition, however, it completely drops access to the call.
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
+64-bit and 32-bit system calls. When the first PRCTL_SET_SECCOMP_FILTER
+is called, the in-memory filters state is annotated with whether the
+call has been made via the compat interface.  All subsequent calls will
+be checked for compat call mismatch.  In the long run, it may make sense
+to store compat and non-compat filters separately, but that is not
+supported at present.
-- 
1.7.0.4

