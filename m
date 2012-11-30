Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2K3WLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 17:11:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38349 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2K3WLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 17:11:03 -0500
Date: Fri, 30 Nov 2012 14:10:37 -0800
From: tip-bot for Vincent Palatin <vpalatin@chromium.org>
Message-ID: <tip-644c154186386bb1fa6446bc5e037b9ed098db46@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        olofj@chromium.org, dlaurie@chromium.org, vpalatin@chromium.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        olofj@chromium.org, vpalatin@chromium.org, dlaurie@chromium.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1354306532-1014-1-git-send-email-vpalatin@chromium.org>
References: <1354306532-1014-1-git-send-email-vpalatin@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, fpu: Avoid FPU lazy restore after suspend
Git-Commit-ID: 644c154186386bb1fa6446bc5e037b9ed098db46
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 14:10:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  644c154186386bb1fa6446bc5e037b9ed098db46
Gitweb:     http://git.kernel.org/tip/644c154186386bb1fa6446bc5e037b9ed098db46
Author:     Vincent Palatin <vpalatin@chromium.org>
AuthorDate: Fri, 30 Nov 2012 12:15:32 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 30 Nov 2012 13:48:05 -0800

x86, fpu: Avoid FPU lazy restore after suspend

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
Cc: <stable@kernel.org> v3.4+ # for 3.4 need to replace this_cpu_write by percpu_write
Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
Link: http://lkml.kernel.org/r/1354306532-1014-1-git-send-email-vpalatin@chromium.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/fpu-internal.h | 15 +++++++++------
 arch/x86/kernel/smpboot.c           |  5 +++++
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
