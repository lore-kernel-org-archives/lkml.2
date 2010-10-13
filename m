Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0JMFI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:08:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab0JMFHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:07:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=moGPcB6TY6Evj/5AWfNC7qyHKNTFzORD7FXlZqneyZZZsqg/OBT8EO6Oa/k6kfgAux
         GX4XR72SeKK3IdwyN3jaLbX+MJs/0SQfKuqcW72sAY7CN3MxCPRrPYSuW+2KE5scD4B7
         F0ru6Zv9VtYfv7rrd0shkJHHbnDq3L9XfwFw8=
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
        Robert Richter <robert.richter@amd.com>
Subject: [RFC PATCH 1/9] uaccess: Make copy_from_user_nmi() globally available
Date: Wed, 13 Oct 2010 07:06:53 +0200
Message-Id: <1286946421-32202-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support user stack dump safely in perf samples from
generic code, export copy_from_user_nmi() from x86 and make it
generally available. For most archs it will map to
copy_from_user_inatomic, but for x86 we need to take care of
not faulting from NMIs.

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
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/uaccess.h   |    5 +++++
 arch/x86/kernel/cpu/perf_event.c |    4 ++--
 include/asm-generic/uaccess.h    |    4 ++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index abd3e0e..901daf3 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -229,6 +229,11 @@ extern void __put_user_2(void);
 extern void __put_user_4(void);
 extern void __put_user_8(void);
 
+extern unsigned long
+__copy_from_user_nmi(void *to, const void __user *from, unsigned long n);
+
+#define copy_from_user_nmi(to, from, n)	__copy_from_user_nmi(to, from, n)
+
 #ifdef CONFIG_X86_WP_WORKS_OK
 
 /**
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e2513f2..d3278da 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -45,8 +45,8 @@ do {								\
 /*
  * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
  */
-static unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+unsigned long
+__copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
 {
 	unsigned long offset, addr = (unsigned long)from;
 	int type = in_nmi() ? KM_NMI : KM_IRQ0;
diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index b218b85..a8d5525 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -240,6 +240,10 @@ extern int __get_user_bad(void) __attribute__((noreturn));
 #define __copy_to_user_inatomic __copy_to_user
 #endif
 
+#ifndef copy_from_user_nmi
+#define copy_from_user_nmi __copy_from_user_inatomic
+#endif
+
 static inline long copy_from_user(void *to,
 		const void __user * from, unsigned long n)
 {
-- 
1.6.2.3

