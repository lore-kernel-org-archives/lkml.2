Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab2AMDfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 22:35:48 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63185 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab2AMDfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 22:35:00 -0500
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        wad@chromium.org, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk
Subject: [PATCH v4 2/2] Documentation: prctl/seccomp_filter
Date: Thu, 12 Jan 2012 21:34:27 -0600
Message-Id: <1326425667-7410-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326425667-7410-1-git-send-email-wad@chromium.org>
References: <1326425667-7410-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documents how system call filtering using Berkeley Packet
Filter programs works and how it may be used.
Includes an example for x86 (32-bit).

v4: - update for no_new_privs use
    - minor tweaks
v3: - call out BPF <-> Berkeley Packet Filter (rdunlap@xenotime.net)
    - document use of tentative always-unprivileged
    - guard sample compilation for i386 and x86_64
v2: - move code to samples (corbet@lwn.net)

Signed-off-by: Will Drewry <wad@chromium.org>
---
 Documentation/prctl/seccomp_filter.txt |   94 ++++++++++++++++++++++++++++++++
 samples/Makefile                       |    2 +-
 samples/seccomp/Makefile               |   18 ++++++
 samples/seccomp/bpf-example.c          |   74 +++++++++++++++++++++++++
 4 files changed, 187 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/prctl/seccomp_filter.txt
 create mode 100644 samples/seccomp/Makefile
 create mode 100644 samples/seccomp/bpf-example.c

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
new file mode 100644
index 0000000..0cf8120
--- /dev/null
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -0,0 +1,94 @@
+		Seccomp filtering
+		=================
+
+Introduction
+------------
+
+A large number of system calls are exposed to every userland process
+with many of them going unused for the entire lifetime of the process.
+As system calls change and mature, bugs are found and eradicated.  A
+certain subset of userland applications benefit by having a reduced set
+of available system calls.  The resulting set reduces the total kernel
+surface exposed to the application.  System call filtering is meant for
+use with those applications.
+
+Seccomp filtering provides a means for a process to specify a filter
+for incoming system calls.  The filter is expressed as a Berkeley Packet
+Filter (BPF) program, as with socket filters, except that the data
+operated on is the current user_regs_struct.  This allows for expressive
+filtering of system calls using the pre-existing system call ABI and
+using a filter program language with a long history of being exposed to
+userland.  Additionally, BPF makes it impossible for users of seccomp to
+fall prey to time-of-check-time-of-use (TOCTOU) attacks that are common
+in system call interposition frameworks because the evaluated data is
+solely register state just after system call entry.
+
+What it isn't
+-------------
+
+System call filtering isn't a sandbox.  It provides a clearly defined
+mechanism for minimizing the exposed kernel surface.  Beyond that,
+policy for logical behavior and information flow should be managed with
+a combinations of other system hardening techniques and, potentially, a
+LSM of your choosing.  Expressive, dynamic filters provide further options down
+this path (avoiding pathological sizes or selecting which of the multiplexed
+system calls in socketcall() is allowed, for instance) which could be
+construed, incorrectly, as a more complete sandboxing solution.
+
+Usage
+-----
+
+An additional seccomp mode is added, but they are not directly set by the
+consuming process.  The new mode, '2', is only available if
+CONFIG_SECCOMP_FILTER is set and enabled using prctl with the
+PR_ATTACH_SECCOMP_FILTER argument.
+
+Interacting with seccomp filters is done using one prctl(2) call.
+
+PR_ATTACH_SECCOMP_FILTER:
+	Allows the specification of a new filter using a BPF program.
+	The BPF program will be executed over a user_regs_struct data
+	reflecting system call time except with the system call number
+	resident in orig_[register].  To allow a system call, the size
+	of the data must be returned.  At present, all other return values
+	result in the system call being blocked, but it is recommended to
+	return 0 in those cases.  This will allow for future custom return
+	values to be introduced, if ever desired.
+
+	Usage:
+		prctl(PR_ATTACH_SECCOMP_FILTER, prog);
+
+	The 'prog' argument is a pointer to a struct sock_fprog which will
+	contain the filter program.  If the program is invalid, the call
+	will return -1 and set errno to -EINVAL.
+
+	The struct user_regs_struct the @prog will see is based on the
+	personality of the task at the time of this prctl call.  Additionally,
+	is_compat_task is also tracked for the @prog.  This means that once set
+	the calling task will have all of its system calls blocked if it
+	switches its system call ABI (via personality or other means).
+
+	If fork/clone and execve are allowed by @prog, any child processes will
+	be constrained to the same filters and syscal call ABI as the parent.
+
+	When called from an unprivileged process (lacking CAP_SYS_ADMIN), the
+	"no_new_privs" bit is enabled for the process.
+
+	Additionally, if prctl(2) is allowed by the attached filter,
+	additional filters may be layered on which will increase evaluation
+	time, but allow for further decreasing the attack surface during
+	execution of a process.
+
+The above call returns 0 on success and non-zero on error.
+
+Example
+-------
+
+samples/seccomp-bpf-example.c shows an example process that allows read from stdin,
+write to stdout/err, exit and signal returns for 32-bit x86.
+
+Adding architecture support
+-----------------------
+
+Any platform with seccomp support will support seccomp filters
+as long as CONFIG_SECCOMP_FILTER is enabled.
diff --git a/samples/Makefile b/samples/Makefile
index 6280817..f29b19c 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,4 +1,4 @@
 # Makefile for Linux samples code
 
 obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ tracepoints/ trace_events/ \
-			   hw_breakpoint/ kfifo/ kdb/ hidraw/
+			   hw_breakpoint/ kfifo/ kdb/ hidraw/ seccomp/
diff --git a/samples/seccomp/Makefile b/samples/seccomp/Makefile
new file mode 100644
index 0000000..cdf0282
--- /dev/null
+++ b/samples/seccomp/Makefile
@@ -0,0 +1,18 @@
+# This sample is x86-only.
+ifeq ($(filter-out x86_64 i386,$(KBUILD_BUILDHOST)),)
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-y := bpf-example
+bpf-example-objs := bpf-example.o
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_bpf-example.o += -I$(objtree)/usr/include
+ifeq ($(KBUILD_BUILDHOST),x86_64)
+HOSTCFLAGS_bpf-example.o += -m32
+HOSTLOADLIBES_bpf-example += -m32
+endif
+endif  # host arch is x86
diff --git a/samples/seccomp/bpf-example.c b/samples/seccomp/bpf-example.c
new file mode 100644
index 0000000..f98b70a
--- /dev/null
+++ b/samples/seccomp/bpf-example.c
@@ -0,0 +1,74 @@
+/*
+ * Seccomp BPF example
+ *
+ * Copyright (c) 2012 The Chromium OS Authors <chromium-os-dev@chromium.org>
+ * Author: Will Drewry <wad@chromium.org>
+ *
+ * The code may be used by anyone for any purpose,
+ * and can serve as a starting point for developing
+ * applications using prctl(PR_ATTACH_SECCOMP_FILTER).
+ */
+
+#include <asm/unistd.h>
+#include <linux/filter.h>
+#include <stdio.h>
+#include <stddef.h>
+#include <sys/prctl.h>
+#include <sys/user.h>
+#include <unistd.h>
+
+#ifndef PR_ATTACH_SECCOMP_FILTER
+#	define PR_ATTACH_SECCOMP_FILTER 36
+#endif
+
+#define regoffset(_reg) (offsetof(struct user_regs_struct, _reg))
+static int install_filter(void)
+{
+	struct sock_filter filter[] = {
+		/* Grab the system call number */
+		BPF_STMT(BPF_LD+BPF_W+BPF_IND, regoffset(orig_eax)),
+		/* Jump table for the allowed syscalls */
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, __NR_rt_sigreturn, 10, 0),
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, __NR_sigreturn, 9, 0),
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, __NR_exit_group, 8, 0),
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, __NR_exit, 7, 0),
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, __NR_read, 1, 0),
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, __NR_write, 2, 6),
+
+		/* Check that read is only using stdin. */
+		BPF_STMT(BPF_LD+BPF_W+BPF_IND, regoffset(ebx)),
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, STDIN_FILENO, 3, 4),
+
+		/* Check that write is only using stdout/stderr */
+		BPF_STMT(BPF_LD+BPF_W+BPF_IND, regoffset(ebx)),
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, STDOUT_FILENO, 1, 0),
+		BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, STDERR_FILENO, 0, 1),
+
+		/* Put the "accept" value in A */
+		BPF_STMT(BPF_LD+BPF_W+BPF_LEN, 0),
+
+		BPF_STMT(BPF_RET+BPF_A,0),
+	};
+	struct sock_fprog prog = {
+		.len = (unsigned short)(sizeof(filter)/sizeof(filter[0])),
+		.filter = filter,
+	};
+	if (prctl(PR_ATTACH_SECCOMP_FILTER, &prog)) {
+		perror("prctl");
+		return 1;
+	}
+	return 0;
+}
+
+#define payload(_c) _c, sizeof(_c)
+int main(int argc, char **argv) {
+	char buf[4096];
+	ssize_t bytes = 0;
+	if (install_filter())
+		return 1;
+	syscall(__NR_write, STDOUT_FILENO, payload("OHAI! WHAT IS YOUR NAME? "));
+	bytes = syscall(__NR_read, STDIN_FILENO, buf, sizeof(buf));
+	syscall(__NR_write, STDOUT_FILENO, payload("HELLO, "));
+	syscall(__NR_write, STDOUT_FILENO, buf, bytes);
+	return 0;
+}
-- 
1.7.5.4

