Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab2GNENE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 00:13:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57142 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2GNEMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 00:12:49 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: qmewlo@gmail.com, eparis@redhat.com, keescook@chromium.org,
        james.l.morris@oracle.com, hpa@zytor.com, cevans@chromium.org,
        luto@mit.edu, rob@landley.net, linux-doc@vger.kernel.org,
        Will Drewry <wad@chromium.org>
Subject: [PATCH v3 2/2] Documentation: add a caveat for seccomp filter and vsyscall emulation
Date: Fri, 13 Jul 2012 23:11:11 -0500
Message-Id: <1342239071-16678-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342239071-16678-1-git-send-email-wad@chromium.org>
References: <1342239071-16678-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of seccomp support to vsyscall emulation:
  http://permalink.gmane.org/gmane.linux.kernel/1327732
with some minor changes in the first patch in this series.

Update the documentation to indicate quirky behaviors when the 'ip' is
in the vsyscall page and vsyscall emulation is in effect.

If v2 of the first patch is preferred, then this patch will need to
be changed to indicate that SECCOMP_RET_TRACE does not allow
system calls to be remapped _or_ skipped.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 Documentation/prctl/seccomp_filter.txt |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
index 597c3c5..67ed88b 100644
--- a/Documentation/prctl/seccomp_filter.txt
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -161,3 +161,25 @@ architecture supports both ptrace_event and seccomp, it will be able to
 support seccomp filter with minor fixup: SIGSYS support and seccomp return
 value checking.  Then it must just add CONFIG_HAVE_ARCH_SECCOMP_FILTER
 to its arch-specific Kconfig.
+
+
+Caveats
+-------
+
+On x86-64 with vsyscall emulation enabled and while servicing a
+vsyscall-emulated system call:
+- A return value of SECCOMP_RET_TRAP will set a si_call_addr pointing to
+  the vsyscall entry for the given call and not the address after the
+  'syscall' instruction.  Any code which wants to restart the call
+  should return to that address and code wishing to return simulating
+  completion may either sigreturn normally or simulate a ret instruction
+  and use the return address from the stack.
+- A return value of SECCOMP_RET_TRACE will signal the tracer as usual,
+  but the syscall may not be changed to another system call using the
+  orig_rax register. It may only be changed to a different value in
+  order to skip the currently emulated call and any change will result
+  in that behavior.  The remainder of the registers may be altered as
+  usual.
+- Detection of this quirky behavior may be done by checking for getcpu,
+  time, or gettimeofday and if the si_call_addr or rip is in the
+  vsyscall page, specifically at the start of the specific entry call.
-- 
1.7.9.5

