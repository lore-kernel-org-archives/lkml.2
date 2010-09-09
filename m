Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0IIQTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 12:19:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:43774 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144Ab0IIQT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 12:19:29 -0400
Message-ID: <4C890901.4050403@kernel.org>
Date: Thu, 09 Sep 2010 18:19:13 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED 1/2] x86, percpu: Optimize this_cpu_ptr
References: <1283859670-6687-1-git-send-email-brgerst@gmail.com> <1283859670-6687-2-git-send-email-brgerst@gmail.com>
In-Reply-To: <1283859670-6687-2-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 16:19:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow arches to implement __this_cpu_ptr, and provide an x86 version.

Before:
	movq $foo, %rax
	movq %gs:this_cpu_off, %rdx
	addq %rdx, %rax

After:
	movq $foo, %rax
	addq %gs:this_cpu_off, %rax

The benefit is doing it in one less instruction and not clobbering
a temporary register.

tj: beefed up the comment a bit and renamed in-macro temp variable to
    match neighboring macros.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied both patches to the following branch.  I updated the first
patch slightly.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-next

Thank you.

 arch/x86/include/asm/percpu.h |   14 ++++++++++++++
 include/asm-generic/percpu.h  |    9 +++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

Index: percpu/arch/x86/include/asm/percpu.h
===================================================================
--- percpu.orig/arch/x86/include/asm/percpu.h
+++ percpu/arch/x86/include/asm/percpu.h
@@ -47,6 +47,20 @@
 #ifdef CONFIG_SMP
 #define __percpu_arg(x)		"%%"__stringify(__percpu_seg)":%P" #x
 #define __my_cpu_offset		percpu_read(this_cpu_off)
+
+/*
+ * Compared to the generic __my_cpu_offset version, the following
+ * saves one instruction and avoids clobbering a temp register.
+ */
+#define __this_cpu_ptr(ptr)				\
+({							\
+	typeof(ptr) tcp_ptr__ = (ptr);			\
+	__verify_pcpu_ptr(ptr);				\
+	asm volatile("add " __percpu_arg(1) ", %0"	\
+		     : "+r" (tcp_ptr__)			\
+		     : "m" (this_cpu_off));		\
+	tcp_ptr__;					\
+})
 #else
 #define __percpu_arg(x)		"%P" #x
 #endif
Index: percpu/include/asm-generic/percpu.h
===================================================================
--- percpu.orig/include/asm-generic/percpu.h
+++ percpu/include/asm-generic/percpu.h
@@ -60,9 +60,14 @@ extern unsigned long __per_cpu_offset[NR
 #define __raw_get_cpu_var(var) \
 	(*SHIFT_PERCPU_PTR(&(var), __my_cpu_offset))

-#define this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
+#ifndef __this_cpu_ptr
 #define __this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
-
+#endif
+#ifdef CONFIG_DEBUG_PREEMPT
+#define this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
+#else
+#define this_cpu_ptr(ptr) __this_cpu_ptr(ptr)
+#endif

 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void setup_per_cpu_areas(void);
