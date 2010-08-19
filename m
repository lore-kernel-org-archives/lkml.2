Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0HSW6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 18:58:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:43359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab0HSW6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 18:58:44 -0400
Date: Thu, 19 Aug 2010 22:58:03 GMT
From: tip-bot for Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        bp@amd64.org, stable@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        bp@amd64.org, borislav.petkov@amd.com
In-Reply-To: <20100819181029.GC17171@aftab>
References: <20100819181029.GC17171@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, hotplug: Serialize CPU hotplug to avoid bringup concurrency issues
Message-ID: <tip-d7c53c9e822a4fefa13a0cae76f3190bfd0d5c11@git.kernel.org>
Git-Commit-ID: d7c53c9e822a4fefa13a0cae76f3190bfd0d5c11
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 Aug 2010 22:58:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7c53c9e822a4fefa13a0cae76f3190bfd0d5c11
Gitweb:     http://git.kernel.org/tip/d7c53c9e822a4fefa13a0cae76f3190bfd0d5c11
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Thu, 19 Aug 2010 20:10:29 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Aug 2010 14:47:43 -0700

x86, hotplug: Serialize CPU hotplug to avoid bringup concurrency issues

When testing cpu hotplug code on 32-bit we kept hitting the "CPU%d:
Stuck ??" message due to multiple cores concurrently accessing the
cpu_callin_mask, among others.

Since these codepaths are not protected from concurrent access due to
the fact that there's no sane reason for making an already complex
code unnecessarily more complex - we hit the issue only when insanely
switching cores off- and online - serialize hotplugging cores on the
sysfs level and be done with it.

[ v2.1: fix !HOTPLUG_CPU build ]

Cc: <stable@kernel.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100819181029.GC17171@aftab>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig          |    5 +++++
 arch/x86/kernel/smpboot.c |   19 +++++++++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a84fc34..ac7827f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -245,6 +245,11 @@ config ARCH_HWEIGHT_CFLAGS
 
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
index abf4a86..8b3bfc4 100644
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
