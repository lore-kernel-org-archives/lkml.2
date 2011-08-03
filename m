Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1HCNdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:33:10 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:59062 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208Ab1HCNcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:32:22 -0400
X-AuditID: 12074423-b7b31ae000000a3c-e6-4e394de9663a
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jeremy@goop.org,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 6/6] x86-64: Add vsyscall:emulate_vsyscall trace event
Date: Wed,  3 Aug 2011 09:31:54 -0400
Message-Id: <cdaad7da946a80b200df16647c1700db3e1171e9.1312378163.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312378163.git.luto@mit.edu>
References: <cover.1312378163.git.luto@mit.edu>
In-Reply-To: <cover.1312378163.git.luto@mit.edu>
References: <cover.1312378163.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsUixCmqrPvS19LPYMp7DYu+K0fZLR7Ne8Rq
	MXXZXFaLZYufMlpc3jWHzWL52XlsFj82PGa1uDflPbsDh8fOWXfZPTZfXM3ksWlVJ5vH5BvL
	GT229+1i9/j49BaLx+dNcgHsUVw2Kak5mWWpRfp2CVwZm48sZCuYyl/x4OlBpgbGszxdjJwc
	EgImEm1fz7BC2GISF+6tZ+ti5OIQEtjHKHGu4xAThLOeUWLujMUsEM5TJollLQcZQVrYBFQk
	OpY+YAKxRQScJFonfATrYBZ4xiix6egZZpCEsICnxPPdy8FsFgFViZO/n4LZvAJBEsufPGCE
	2C0nceTyc7BBnAIGEqsWPAfaxgG0TV/iwZp8HMITGAUWMDKsYpRNya3SzU3MzClOTdYtTk7M
	y0st0jXTy80s0UtNKd3ECApmdhflHYx/DiodYhTgYFTi4WWUt/ATYk0sK67MPcQoycGkJMq7
	3MvST4gvKT+lMiOxOCO+qDQntfgQowQHs5IIbzsvUI43JbGyKrUoHyYlzcGiJM6b6/3fV0gg
	PbEkNTs1tSC1CCYrw8GhJMHLD4xaIcGi1PTUirTMnBKENBMHJ8hwHqDhNiA1vMUFibnFmekQ
	+VOMilLivIYgCQGQREZpHlwvLNm8YhQHekWYlwGkigeYqOC6XwENZgIa/P+9BcjgkkSElFQD
	42pxieKf3SHXmX4lrdlt86zvsH5xYMmKWXsjdqx3OvRknVeoFjfr253dfbzxwgmyH3MS3+tx
	GWgIC/jOiT3yazNX49+XG0vKvZs6fZYFXp3xUoZhRoVXemv1ZKG8/xx6j0+veLdm4i53jU/f
	efN2F5vvsfHIaGV/2uX+sc+4TEqzWHXDr32NSizFGYmGWsxFxYkAU5g3+hEDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vsyscall emulation is slow, so make it easy to track down.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/vsyscall_64.c    |    6 ++++++
 arch/x86/kernel/vsyscall_trace.h |   29 +++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/vsyscall_trace.h

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
-- 
1.7.6

