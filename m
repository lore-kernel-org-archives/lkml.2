Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab0JVTQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:16:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759336Ab0JVTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:13:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Jf/6rIiUGGGxYFVrdkmMEcVgAeEO258GhGjmcv22/6x4ARnuf3VkLTgHASxX4rCSYQ
         o32K1BA4oRAzFWzKJEZB7fGMVh+MMAUyOLV2yfCya7lJwOPjCkpIVGHL+tVUToYkKedG
         6mC+N3p52YDMNmDq8NsXfCzDVY1LEOe3FanoU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC PATCH 01/11] uaccess: New copy_from_user_gup() API
Date: Fri, 22 Oct 2010 21:13:02 +0200
Message-Id: <1287774792-23123-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
References: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings a get_user_page_fast() based copy_from_user() that can
do a best effort copy from any context.

In order to support user stack dump safely in perf samples from
generic code, rename x86 copy_from_user_nmi to copy_from_user_gup
and make it generally available. If the arch doesn't provide an
implementation it will map to copy_from_user_inatomic.

Since perf is the first user for now, let the overriden x86
implementation in the perf source file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---
 arch/x86/include/asm/uaccess.h            |    5 +++++
 arch/x86/kernel/cpu/perf_event.c          |    8 ++++----
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    2 +-
 include/asm-generic/uaccess.h             |    4 ++++
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index abd3e0e..d29f3ab 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -229,6 +229,11 @@ extern void __put_user_2(void);
 extern void __put_user_4(void);
 extern void __put_user_8(void);
 
+extern unsigned long
+__copy_from_user_gup(void *to, const void __user *from, unsigned long n);
+
+#define copy_from_user_gup(to, from, n)	__copy_from_user_gup(to, from, n)
+
 #ifdef CONFIG_X86_WP_WORKS_OK
 
 /**
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index fe73c18..8747570 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -45,8 +45,8 @@ do {								\
 /*
  * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
  */
-static unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+unsigned long
+__copy_from_user_gup(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long offset, addr = (unsigned long)from;
 	int type = in_nmi() ? KM_NMI : KM_IRQ0;
@@ -1688,7 +1688,7 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		frame.next_frame     = 0;
 		frame.return_address = 0;
 
-		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
+		bytes = copy_from_user_gup(&frame, fp, sizeof(frame));
 		if (bytes != sizeof(frame))
 			break;
 
@@ -1731,7 +1731,7 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 		frame.next_frame	     = NULL;
 		frame.return_address = 0;
 
-		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
+		bytes = copy_from_user_gup(&frame, fp, sizeof(frame));
 		if (bytes != sizeof(frame))
 			break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 4977f9c..1642dee 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -426,7 +426,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 		if (!kernel_ip(ip)) {
 			int bytes, size = MAX_INSN_SIZE;
 
-			bytes = copy_from_user_nmi(buf, (void __user *)to, size);
+			bytes = copy_from_user_gup(buf, (void __user *)to, size);
 			if (bytes != size)
 				return 0;
 
diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index b218b85..00bc7d3 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -240,6 +240,10 @@ extern int __get_user_bad(void) __attribute__((noreturn));
 #define __copy_to_user_inatomic __copy_to_user
 #endif
 
+#ifndef copy_from_user_gup
+#define copy_from_user_gup __copy_from_user_inatomic
+#endif
+
 static inline long copy_from_user(void *to,
 		const void __user * from, unsigned long n)
 {
-- 
1.6.2.3

