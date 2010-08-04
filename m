Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0HDQpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:45:35 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:32983 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab0HDQpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:45:31 -0400
From: Borislav Petkov <bp@amd64.org>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>
Cc: <andreas.herrmann3@amd.com>, conny.seidel@amd.com, <joerg.roedel@amd.com>,
        Bhavna.Sarathy@amd.com, <greg@kroah.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86, cpu hotplug: Fix cpu bringup concurrency issue
Date: Wed,  4 Aug 2010 18:45:16 +0200
Message-Id: <1280940316-7966-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280940316-7966-1-git-send-email-bp@amd64.org>
References: <1280940316-7966-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

When testing cpu hotplug code on 32-bit we kept hitting the "CPU%d:
Stuck ??" message due to multiple cores concurrently accessing the
cpu_callin_mask, among others.

Since these codepaths are not protected from concurrent access due to
the fact that there's no sane reason for making an already complex
code unnecessarily more complex - we hit the issue only when insanely
switching cores off- and online - serialize hotplugging cores on the
sysfs level and be done with it.

Cc: <stable@kernel.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/Kconfig          |    6 ++++++
 arch/x86/kernel/smpboot.c |   19 +++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dcb0593..1598663 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -58,6 +58,7 @@ config X86
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
+	select ARCH_CPU_PROBE_RELEASE
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
@@ -247,6 +248,11 @@ config ARCH_HWEIGHT_CFLAGS
 
 config KTIME_SCALAR
 	def_bool X86_32
+
+config ARCH_CPU_PROBE_RELEASE
+	def_bool y
+	depends on HOTPLUG_CPU
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6859a42..9e8e61b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -90,6 +90,25 @@ DEFINE_PER_CPU(int, cpu_state) = { 0 };
 static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
 #define get_idle_for_cpu(x)      (per_cpu(idle_thread_array, x))
 #define set_idle_for_cpu(x, p)   (per_cpu(idle_thread_array, x) = (p))
+
+/*
+ * We need this for trampoline_base protection from concurrent accesses when
+ * off- and onlining cores wildly.
+ */
+static DEFINE_MUTEX(x86_cpu_hotplug_driver_mutex);
+
+void cpu_hotplug_driver_lock()
+{
+        mutex_lock(&x86_cpu_hotplug_driver_mutex);
+}
+
+void cpu_hotplug_driver_unlock()
+{
+        mutex_unlock(&x86_cpu_hotplug_driver_mutex);
+}
+
+ssize_t arch_cpu_probe(const char *buf, size_t count) { return -1; }
+ssize_t arch_cpu_release(const char *buf, size_t count) { return -1; }
 #else
 static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
 #define get_idle_for_cpu(x)      (idle_thread_array[(x)])
-- 
1.6.4.4

