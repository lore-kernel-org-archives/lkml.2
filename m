Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab2K3UPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:15:51 -0500
Received: from mail-wi0-f202.google.com ([209.85.212.202]:53884 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab2K3UPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:15:50 -0500
From: Vincent Palatin <vpalatin@chromium.org>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Duncan Laurie <dlaurie@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: [PATCH v3] x86, fpu: avoid FPU lazy restore after suspend
Date: Fri, 30 Nov 2012 12:15:32 -0800
Message-Id: <1354306532-1014-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1354305164-10601-1-git-send-email-vpalatin@chromium.org>
References: <1354305164-10601-1-git-send-email-vpalatin@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: <stable@kernel.org> [v3.4+] # for 3.4 need to replace this_cpu_write by percpu_write
Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
Hi,

The patch updated according the HPA and Linus comments.
I'm still re-running the testing on v3.

Change in v3:
- remove misleading comment about 3.4 in the description.

Change in v2:
- add an helper function and comment in fpu-internal.h as described by Linus
- do the cleaning in the native_cpu_up function as suggested by HPA

Vincent

 arch/x86/include/asm/fpu-internal.h |   15 +++++++++------
 arch/x86/kernel/smpboot.c           |    5 +++++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 831dbb9..41ab26e 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -399,14 +399,17 @@ static inline void drop_init_fpu(struct task_struct *tsk)
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
index c80a33b..f3e2ec8 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -68,6 +68,8 @@
 #include <asm/mwait.h>
 #include <asm/apic.h>
 #include <asm/io_apic.h>
+#include <asm/i387.h>
+#include <asm/fpu-internal.h>
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
@@ -818,6 +820,9 @@ int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
+	/* the FPU context is blank, nobody can own it */
+	__cpu_disable_lazy_restore(cpu);
+
 	err = do_boot_cpu(apicid, cpu, tidle);
 	if (err) {
 		pr_debug("do_boot_cpu failed %d\n", err);
-- 
1.7.7.3

