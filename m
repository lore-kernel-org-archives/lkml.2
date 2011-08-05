Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab1HEFjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 01:39:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:45456 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221Ab1HEFjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 01:39:42 -0400
Date: Fri, 5 Aug 2011 05:39:36 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-c149a665ac488e0dac22a42287f45ad1bda06ff1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com, luto@mit.edu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com, luto@mit.edu
In-Reply-To: <cdaad7da946a80b200df16647c1700db3e1171e9.1312378163.git.luto@mit.edu>
References: <cdaad7da946a80b200df16647c1700db3e1171e9.1312378163.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Add vsyscall:emulate_vsyscall trace event
Git-Commit-ID: c149a665ac488e0dac22a42287f45ad1bda06ff1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Aug 2011 05:39:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c149a665ac488e0dac22a42287f45ad1bda06ff1
Gitweb:     http://git.kernel.org/tip/c149a665ac488e0dac22a42287f45ad1bda06ff1
Author:     Andy Lutomirski <luto@MIT.EDU>
AuthorDate: Wed, 3 Aug 2011 09:31:54 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 4 Aug 2011 16:13:53 -0700

x86-64: Add vsyscall:emulate_vsyscall trace event

Vsyscall emulation is slow, so make it easy to track down.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/cdaad7da946a80b200df16647c1700db3e1171e9.1312378163.git.luto@mit.edu
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/vsyscall_64.c    |    6 ++++++
 arch/x86/kernel/vsyscall_trace.h |   29 +++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 1725930..93a0d46 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -50,6 +50,9 @@
 #include <asm/vgtod.h>
 #include <asm/traps.h>
 
+#define CREATE_TRACE_POINTS
+#include "vsyscall_trace.h"
+
 DEFINE_VVAR(int, vgetcpu_mode);
 DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 {
@@ -146,6 +149,9 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 	 * and int 0xcc is two bytes long.
 	 */
 	vsyscall_nr = addr_to_vsyscall_nr(regs->ip - 2);
+
+	trace_emulate_vsyscall(vsyscall_nr);
+
 	if (vsyscall_nr < 0) {
 		warn_bad_vsyscall(KERN_WARNING, regs,
 				  "illegal int 0xcc (exploit attempt?)");
diff --git a/arch/x86/kernel/vsyscall_trace.h b/arch/x86/kernel/vsyscall_trace.h
new file mode 100644
index 0000000..a8b2ede
--- /dev/null
+++ b/arch/x86/kernel/vsyscall_trace.h
@@ -0,0 +1,29 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM vsyscall
+
+#if !defined(__VSYSCALL_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __VSYSCALL_TRACE_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(emulate_vsyscall,
+
+	    TP_PROTO(int nr),
+
+	    TP_ARGS(nr),
+
+	    TP_STRUCT__entry(__field(int, nr)),
+
+	    TP_fast_assign(
+			   __entry->nr = nr;
+			   ),
+
+	    TP_printk("nr = %d", __entry->nr)
+);
+
+#endif
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../arch/x86/kernel
+#define TRACE_INCLUDE_FILE vsyscall_trace
+#include <trace/define_trace.h>
