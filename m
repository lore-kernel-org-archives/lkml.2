Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab0HPMiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:38:14 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59867 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0HPMiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:38:13 -0400
Date: Mon, 16 Aug 2010 14:39:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joerg Roedel <joro@8bytes.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2 2/2] x86, cpu hotplug: Fix cpu bringup concurrency issue
Message-ID: <20100816123959.GC28147@aftab>
References: <4C59F24B.1010702@zytor.com>
 <20100805074503.GI18307@amd.com>
 <4C5AC736.20903@zytor.com>
 <20100812144142.GY23755@8bytes.org>
 <4C64148D.5080305@zytor.com>
 <20100812170644.GZ23755@8bytes.org>
 <4C644507.9020606@zytor.com>
 <20100812190414.GA23755@8bytes.org>
 <20100813123543.GC9046@aftab>
 <20100816121933.GA28147@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816121933.GA28147@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When testing cpu hotplug code on 32-bit we kept hitting the "CPU%d:
Stuck ??" message due to multiple cores concurrently accessing the
cpu_callin_mask, among others.

Since these codepaths are not protected from concurrent access due to
the fact that there's no sane reason for making an already complex
code unnecessarily more complex - we hit the issue only when insanely
switching cores off- and online - serialize hotplugging cores on the
sysfs level and be done with it.

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
index 2d148a9..733ad2b 100644
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
+	mutex_lock(&x86_cpu_hotplug_driver_mutex);
+}
+
+void cpu_hotplug_driver_unlock()
+{
+	mutex_unlock(&x86_cpu_hotplug_driver_mutex);
+}
+
+ssize_t arch_cpu_probe(const char *buf, size_t count) { return -1; }
+ssize_t arch_cpu_release(const char *buf, size_t count) { return -1; }
 #else
 static struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
 #define get_idle_for_cpu(x)      (idle_thread_array[(x)])
-- 
1.7.1


-- 
Regards/Gruss,
Boris.
