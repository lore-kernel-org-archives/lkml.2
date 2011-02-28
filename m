Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab1CATlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:41:14 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52544 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab1CAThW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:22 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 14:37:17 EST
Message-Id: <201103011934.p21JYcd3010304@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 15:19:10 -0500
Subject: [PATCH] arch/tile: sync up with <arch/sim.h> and <arch/sim_def.h> changes
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:39.0076 (UTC) FILETIME=[B4618A40:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These headers are used by Linux but are maintained upstream.
This change incorporates a few minor fixes to these headers,
including a new sim_print() function, cleaner support for the
sim_syscall() API, and a sim_query_cpu_speed() method.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/sim.h     |   48 ++++++++++++++++++++++++++++---------
 arch/tile/include/arch/sim_def.h |    3 ++
 2 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/arch/tile/include/arch/sim.h b/arch/tile/include/arch/sim.h
index 74b7c16..e54b7b0 100644
--- a/arch/tile/include/arch/sim.h
+++ b/arch/tile/include/arch/sim.h
@@ -152,16 +152,33 @@ sim_dump(unsigned int mask)
 /**
  * Print a string to the simulator stdout.
  *
- * @param str The string to be written; a newline is automatically added.
+ * @param str The string to be written.
+ */
+static __inline void
+sim_print(const char* str)
+{
+  for ( ; *str != '\0'; str++)
+  {
+    __insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_PUTC |
+                 (*str << _SIM_CONTROL_OPERATOR_BITS));
+  }
+  __insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_PUTC |
+               (SIM_PUTC_FLUSH_BINARY << _SIM_CONTROL_OPERATOR_BITS));
+}
+
+
+/**
+ * Print a string to the simulator stdout.
+ *
+ * @param str The string to be written (a newline is automatically added).
  */
 static __inline void
 sim_print_string(const char* str)
 {
-  int i;
-  for (i = 0; str[i] != 0; i++)
+  for ( ; *str != '\0'; str++)
   {
     __insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_PUTC |
-                 (str[i] << _SIM_CONTROL_OPERATOR_BITS));
+                 (*str << _SIM_CONTROL_OPERATOR_BITS));
   }
   __insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_PUTC |
                (SIM_PUTC_FLUSH_STRING << _SIM_CONTROL_OPERATOR_BITS));
@@ -203,7 +220,7 @@ sim_command(const char* str)
  * we are passing to the simulator are actually valid in the registers
  * (i.e. returned from memory) prior to the SIM_CONTROL spr.
  */
-static __inline int _sim_syscall0(int val)
+static __inline long _sim_syscall0(int val)
 {
   long result;
   __asm__ __volatile__ ("mtspr SIM_CONTROL, r0"
@@ -211,7 +228,7 @@ static __inline int _sim_syscall0(int val)
   return result;
 }
 
-static __inline int _sim_syscall1(int val, long arg1)
+static __inline long _sim_syscall1(int val, long arg1)
 {
   long result;
   __asm__ __volatile__ ("{ and zero, r1, r1; mtspr SIM_CONTROL, r0 }"
@@ -219,7 +236,7 @@ static __inline int _sim_syscall1(int val, long arg1)
   return result;
 }
 
-static __inline int _sim_syscall2(int val, long arg1, long arg2)
+static __inline long _sim_syscall2(int val, long arg1, long arg2)
 {
   long result;
   __asm__ __volatile__ ("{ and zero, r1, r2; mtspr SIM_CONTROL, r0 }"
@@ -233,7 +250,7 @@ static __inline int _sim_syscall2(int val, long arg1, long arg2)
    the register values for arguments 3 and up may still be in flight
    to the core from a stack frame reload. */
 
-static __inline int _sim_syscall3(int val, long arg1, long arg2, long arg3)
+static __inline long _sim_syscall3(int val, long arg1, long arg2, long arg3)
 {
   long result;
   __asm__ __volatile__ ("{ and zero, r3, r3 };"
@@ -244,7 +261,7 @@ static __inline int _sim_syscall3(int val, long arg1, long arg2, long arg3)
   return result;
 }
 
-static __inline int _sim_syscall4(int val, long arg1, long arg2, long arg3,
+static __inline long _sim_syscall4(int val, long arg1, long arg2, long arg3,
                                   long arg4)
 {
   long result;
@@ -256,7 +273,7 @@ static __inline int _sim_syscall4(int val, long arg1, long arg2, long arg3,
   return result;
 }
 
-static __inline int _sim_syscall5(int val, long arg1, long arg2, long arg3,
+static __inline long _sim_syscall5(int val, long arg1, long arg2, long arg3,
                                   long arg4, long arg5)
 {
   long result;
@@ -268,7 +285,6 @@ static __inline int _sim_syscall5(int val, long arg1, long arg2, long arg3,
   return result;
 }
 
-
 /**
  * Make a special syscall to the simulator itself, if running under
  * simulation. This is used as the implementation of other functions
@@ -281,7 +297,8 @@ static __inline int _sim_syscall5(int val, long arg1, long arg2, long arg3,
  */
 #define _sim_syscall(syscall_num, nr, args...) \
   _sim_syscall##nr( \
-    ((syscall_num) << _SIM_CONTROL_OPERATOR_BITS) | SIM_CONTROL_SYSCALL, args)
+    ((syscall_num) << _SIM_CONTROL_OPERATOR_BITS) | SIM_CONTROL_SYSCALL, \
+    ##args)
 
 
 /* Values for the "access_mask" parameters below. */
@@ -365,6 +382,13 @@ sim_validate_lines_evicted(unsigned long long pa, unsigned long length)
 }
 
 
+/* Return the current CPU speed in cycles per second. */
+static __inline long
+sim_query_cpu_speed(void)
+{
+  return _sim_syscall(SIM_SYSCALL_QUERY_CPU_SPEED, 0);
+}
+
 #endif /* !__DOXYGEN__ */
 
 
diff --git a/arch/tile/include/arch/sim_def.h b/arch/tile/include/arch/sim_def.h
index 7a17082..4b44a2b 100644
--- a/arch/tile/include/arch/sim_def.h
+++ b/arch/tile/include/arch/sim_def.h
@@ -243,6 +243,9 @@
  */
 #define SIM_SYSCALL_VALIDATE_LINES_EVICTED 5
 
+/** Syscall number for sim_query_cpu_speed(). */
+#define SIM_SYSCALL_QUERY_CPU_SPEED 6
+
 
 /*
  * Bit masks which can be shifted by 8, combined with
-- 
1.6.5.2

