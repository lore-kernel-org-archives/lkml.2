Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab0IJIe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 04:34:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:49199 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab0IJIe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 04:34:56 -0400
Message-ID: <4C89EDA7.8020506@kernel.org>
Date: Fri, 10 Sep 2010 10:34:47 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] x86, percpu: Fix __this_cpu_ptr with const pointers
References: <20100910124543.3e8604fd.sfr@canb.auug.org.au> <1284096664-4539-1-git-send-email-brgerst@gmail.com>
In-Reply-To: <1284096664-4539-1-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 08:34:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I folded the fix into the original patch and also updated the address
space casting for sparse.

Thanks.

>From 9c5b46f782cde2c88a5e4f02a6112bfcfb105f8f Mon Sep 17 00:00:00 2001
From: Brian Gerst <brgerst@gmail.com>
Date: Thu, 9 Sep 2010 18:17:26 +0200
Subject: [PATCH] x86, percpu: Optimize this_cpu_ptr

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

tj: * Beefed up the comment a bit and renamed in-macro temp variable
      to match neighboring macros.

    * Folded fix for const pointer case found in linux-next.

    * Fixed sparse notation.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/percpu.h |   14 ++++++++++++++
 include/asm-generic/percpu.h  |    9 +++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index cd28f9a..f899e01 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
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
+	unsigned long tcp_ptr__;			\
+	__verify_pcpu_ptr(ptr);				\
+	asm volatile("add " __percpu_arg(1) ", %0"	\
+		     : "=r" (tcp_ptr__)			\
+		     : "m" (this_cpu_off), "0" (ptr));	\
+	(typeof(*(ptr)) __kernel __force *)tcp_ptr__;	\
+})
 #else
 #define __percpu_arg(x)		"%P" #x
 #endif
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 08923b6..ec64311 100644
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
1.7.1

