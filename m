Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab0K2IWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:22:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab0K2IWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:22:12 -0500
Date: Mon, 29 Nov 2010 03:21:28 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Dilger <adilger@dilger.ca>, David Howells <dhowells@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
        Michal Simek <monstr@monstr.eu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chen Liqin <liqin.chen@sunplusct.com>
Message-Id: <20101129082626.5991.46757.sendpatchset@localhost.localdomain>
Subject: [Patch] frv: do some cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. frv doesn't support SMP, remove the unless SMP bits.
2. frv has its own alloc_task_struct, so define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
   (I am not sure if frv should use generic alloc_task_struct().)

Signed-off-by: WANG Cong <amwang@redhat.com>
---
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index f6bcb03..ab0a983 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -364,7 +364,6 @@ menu "Power management options"
 
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
-	depends on !SMP
 
 source kernel/power/Kconfig
 endmenu
diff --git a/arch/frv/include/asm/system.h b/arch/frv/include/asm/system.h
index 0a6d8d9..6c10fd2 100644
--- a/arch/frv/include/asm/system.h
+++ b/arch/frv/include/asm/system.h
@@ -45,21 +45,12 @@ do {									\
 #define wmb()			asm volatile ("membar" : : :"memory")
 #define read_barrier_depends()	do { } while (0)
 
-#ifdef CONFIG_SMP
-#define smp_mb()			mb()
-#define smp_rmb()			rmb()
-#define smp_wmb()			wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
-#define set_mb(var, value) \
-	do { xchg(&var, (value)); } while (0)
-#else
 #define smp_mb()			barrier()
 #define smp_rmb()			barrier()
 #define smp_wmb()			barrier()
 #define smp_read_barrier_depends()	do {} while(0)
 #define set_mb(var, value) \
 	do { var = (value); barrier(); } while (0)
-#endif
 
 extern void die_if_kernel(const char *, ...) __attribute__((format(printf, 1, 2)));
 extern void free_initmem(void);
diff --git a/arch/frv/include/asm/thread_info.h b/arch/frv/include/asm/thread_info.h
index 11f33ea..d5c1a0a 100644
--- a/arch/frv/include/asm/thread_info.h
+++ b/arch/frv/include/asm/thread_info.h
@@ -21,6 +21,8 @@
 
 #define THREAD_SIZE		8192
 
+#define __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
+
 /*
  * low level task data that entry.S needs immediate access to
  * - this struct should fit entirely inside of one cache line
