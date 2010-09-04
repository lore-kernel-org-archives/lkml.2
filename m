Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0IDRWj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 13:22:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37676 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab0IDRWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 13:22:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZacgW9su2bGYrkDxeCG5dL5afuewBvU5lzZbTOSxahGXotlYKUm0/Sfb1ec1wdkpZD
         DjrrNKc4q/uDtb3WSIwUKIVCj5PJxoYYBCrnoa4R7qWe8j7Bk6osgbRFXJ+KClLBGAcb
         miNDeLHkG+W8loDIjX/Z+juHK+lZ7PoxLtaGU=
From: Brian Gerst <brgerst@gmail.com>
To: tj@kernel.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86, percpu: Optimize this_cpu_ptr
Date: Sat,  4 Sep 2010 13:21:10 -0400
Message-Id: <1283620871-818-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283620871-818-1-git-send-email-brgerst@gmail.com>
References: <1283620871-818-1-git-send-email-brgerst@gmail.com>
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

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/percpu.h |    9 +++++++++
 include/asm-generic/percpu.h  |    9 +++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index cd28f9a..d854438 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -47,6 +47,15 @@
 #ifdef CONFIG_SMP
 #define __percpu_arg(x)		"%%"__stringify(__percpu_seg)":%P" #x
 #define __my_cpu_offset		percpu_read(this_cpu_off)
+#define __this_cpu_ptr(ptr)				\
+({							\
+	typeof(ptr) __ptr = (ptr);			\
+	__verify_pcpu_ptr(ptr);				\
+	asm volatile("add " __percpu_arg(1) ", %0"	\
+		     : "+r" (__ptr)			\
+		     : "m" (this_cpu_off));		\
+	__ptr;						\
+}) 
 #else
 #define __percpu_arg(x)		"%P" #x
 #endif
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index b5043a9..5820fcb 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -60,9 +60,14 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
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
-- 
1.7.2.2

