Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab0HXXBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:01:50 -0400
Received: from kroah.org ([198.145.64.141]:40929 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933355Ab0HXXBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:45 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:03 2010
Message-Id: <20100824224503.639224857@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [027/114] x86, hotplug: Serialize CPU hotplug to avoid bringup concurrency issues
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <bp@amd64.org>

commit d7c53c9e822a4fefa13a0cae76f3190bfd0d5c11 upstream.

When testing cpu hotplug code on 32-bit we kept hitting the "CPU%d:
Stuck ??" message due to multiple cores concurrently accessing the
cpu_callin_mask, among others.

Since these codepaths are not protected from concurrent access due to
the fact that there's no sane reason for making an already complex
code unnecessarily more complex - we hit the issue only when insanely
switching cores off- and online - serialize hotplugging cores on the
sysfs level and be done with it.

[ v2.1: fix !HOTPLUG_CPU build ]

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20100819181029.GC17171@aftab>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/Kconfig          |    5 +++++
 arch/x86/kernel/smpboot.c |   19 +++++++++++++++++++
 2 files changed, 24 insertions(+)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -247,6 +247,11 @@ config ARCH_HWEIGHT_CFLAGS
 
 config KTIME_SCALAR
 	def_bool X86_32
+
+config ARCH_CPU_PROBE_RELEASE
+	def_bool y
+	depends on HOTPLUG_CPU
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -91,6 +91,25 @@ DEFINE_PER_CPU(int, cpu_state) = { 0 };
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


