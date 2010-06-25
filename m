Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab0FYNEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:04:23 -0400
Received: from ozlabs.org ([203.10.76.45]:38738 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab0FYNER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:04:17 -0400
To: Ingo Molnar <mingo@elte.hu>
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <201006252234.11308.rusty@rustcorp.com.au>
Date: Fri, 25 Jun 2010 22:34:10 +0930
Subject: [PATCH 3/5] cpumask: select disabling obsolete cpumask functions on x86
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       anton@samba.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mike Travis <travis@sgi.com>
Cc: anton@samba.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It currently depends on CONFIG_BROKEN; change to be set by
CONFIG_CPUMASK_OFFSTACK now it all compiles.

We also complete it: the header shouldn't refer to the deprected
CPU_MASK_LAST_WORD, and the deprecated implementations are removed.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: anton@samba.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |    4 ++--
 include/linux/sched.h   |    2 +-
 lib/Kconfig             |    5 ++++-
 lib/cpumask.c           |    2 ++
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -700,7 +700,7 @@ static inline const struct cpumask *get_
 #if NR_CPUS <= BITS_PER_LONG
 #define CPU_BITS_ALL						\
 {								\
-	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
+	[BITS_TO_LONGS(NR_CPUS)-1] = BITMAP_LAST_WORD_MASK(NR_CPUS)	\
 }
 
 #else /* NR_CPUS > BITS_PER_LONG */
@@ -708,7 +708,7 @@ static inline const struct cpumask *get_
 #define CPU_BITS_ALL						\
 {								\
 	[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,		\
-	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD		\
+	[BITS_TO_LONGS(NR_CPUS)-1] = BITMAP_LAST_WORD_MASK(NR_CPUS)	\
 }
 #endif /* NR_CPUS > BITS_PER_LONG */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1826,7 +1826,7 @@ static inline int set_cpus_allowed_ptr(s
 }
 #endif
 
-#ifndef CONFIG_CPUMASK_OFFSTACK
+#ifndef CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
 static inline int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 {
 	return set_cpus_allowed_ptr(p, &new_mask);
diff --git a/lib/Kconfig b/lib/Kconfig
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -179,6 +179,7 @@ config HAVE_LMB
 
 config CPUMASK_OFFSTACK
 	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
+	select DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
 	help
 	  Use dynamic allocation for cpumask_var_t, instead of putting
 	  them on the stack.  This is a bit more expensive, but avoids
@@ -186,7 +187,9 @@ config CPUMASK_OFFSTACK
 
 config DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
        bool "Disable obsolete cpumask functions" if DEBUG_PER_CPU_MAPS
-       depends on EXPERIMENTAL && BROKEN
+       help
+	 Remove all the definitions of things which are dangerous with
+	 offstack (ie. dynamically allocated) cpumasks.
 
 #
 # Netlink attribute parsing support is select'ed if needed
diff --git a/lib/cpumask.c b/lib/cpumask.c
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/bootmem.h>
 
+#ifndef CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
 int __first_cpu(const cpumask_t *srcp)
 {
 	return min_t(int, NR_CPUS, find_first_bit(srcp->bits, NR_CPUS));
@@ -36,6 +37,7 @@ int __any_online_cpu(const cpumask_t *ma
 	return cpu;
 }
 EXPORT_SYMBOL(__any_online_cpu);
+#endif /* CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS */
 
 /**
  * cpumask_next_and - get the next cpu in *src1p & *src2p

