Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab2LMOfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:35:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44731 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758Ab2LMOKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:10:18 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Duncan Laurie <dlaurie@chromium.org>, Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 154/241] x86, fpu: Avoid FPU lazy restore after suspend
Date: Thu, 13 Dec 2012 11:58:39 -0200
Message-Id: <1355407206-17100-155-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Palatin <vpalatin@chromium.org>

commit 644c154186386bb1fa6446bc5e037b9ed098db46 upstream.

When a cpu enters S3 state, the FPU state is lost.
After resuming for S3, if we try to lazy restore the FPU for a process running
on the same CPU, this will result in a corrupted FPU context.

Ensure that "fpu_owner_task" is properly invalided when (re-)initializing a CPU,
so nobody will try to lazy restore a state which doesn't exist in the hardware.

Tested with a 64-bit kernel on a 4-core Ivybridge CPU with eagerfpu=off,
by doing thousands of suspend/resume cycles with 4 processes doing FPU
operations running. Without the patch, a process is killed after a
few hundreds cycles by a SIGFPE.

Cc: Duncan Laurie <dlaurie@chromium.org>
Cc: Olof Johansson <olofj@chromium.org>
Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
Link: http://lkml.kernel.org/r/1354306532-1014-1-git-send-email-vpalatin@chromium.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/include/asm/fpu-internal.h |   15 +++++++++------
 arch/x86/kernel/smpboot.c           |    5 +++++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 75f4c6d..04cb0f8 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -334,14 +334,17 @@ static inline void __thread_fpu_begin(struct task_struct *tsk)
 typedef struct { int preload; } fpu_switch_t;
 
 /*
- * FIXME! We could do a totally lazy restore, but we need to
- * add a per-cpu "this was the task that last touched the FPU
- * on this CPU" variable, and the task needs to have a "I last
- * touched the FPU on this CPU" and check them.
+ * Must be run with preemption disabled: this clears the fpu_owner_task,
+ * on this CPU.
  *
- * We don't do that yet, so "fpu_lazy_restore()" always returns
- * false, but some day..
+ * This will disable any lazy FPU state restore of the current FPU state,
+ * but if the current thread owns the FPU, it will still be saved by.
  */
+static inline void __cpu_disable_lazy_restore(unsigned int cpu)
+{
+	per_cpu(fpu_owner_task, cpu) = NULL;
+}
+
 static inline int fpu_lazy_restore(struct task_struct *new, unsigned int cpu)
 {
 	return new == this_cpu_read_stable(fpu_owner_task) &&
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7bd8a08..6977453 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -66,6 +66,8 @@
 #include <asm/mwait.h>
 #include <asm/apic.h>
 #include <asm/io_apic.h>
+#include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
@@ -826,6 +828,9 @@ int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
+	/* the FPU context is blank, nobody can own it */
+	__cpu_disable_lazy_restore(cpu);
+
 	err = do_boot_cpu(apicid, cpu, tidle);
 	if (err) {
 		pr_debug("do_boot_cpu failed %d\n", err);
-- 
1.7.9.5

