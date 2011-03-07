Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab1CGL4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:56:13 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60818 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1CGL4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:56:10 -0500
Date: Mon, 7 Mar 2011 17:26:04 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, anton@samba.org,
        benh@kernel.crashing.org
Subject: [PATCH 7/7] powerpc/kexec: Fix orphaned offline CPUs across kexec
Message-ID: <20110307115604.GI8194@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    powerpc/kexec: Fix orphaned offline CPUs across kexec

    Commit: e8e5c2155b0035b6e04f29be67f6444bc914005b upstream

    When CPU hotplug is used, some CPUs may be offline at the time a kexec is
    performed.  The subsequent kernel may expect these CPUs to be already running,
    and will declare them stuck.  On pseries, there's also a soft-offline (cede)
    state that CPUs may be in; this can also cause problems as the kexeced kernel
    may ask RTAS if they're online -- and RTAS would say they are.  The CPU will
    either appear stuck, or will cause a crash as we replace its cede loop beneath
    it.

    This patch kicks each present offline CPU awake before the kexec, so that
    none are forever lost to these assumptions in the subsequent kernel.

    Now, the behaviour is that all available CPUs that were offlined are now
    online & usable after the kexec.  This mimics the behaviour of a full reboot
    (on which all CPUs will be restarted).

    Signed-off-by: Matt Evans <matt@ozlabs.org>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Kamalesh babulal <kamalesh@linux.vnet.ibm.com>
    cc: Anton Blanchard <anton@samba.org>
---
 arch/powerpc/kernel/machine_kexec_64.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

Index: b/arch/powerpc/kernel/machine_kexec_64.c
===================================================================
--- a/arch/powerpc/kernel/machine_kexec_64.c	2011-03-07 01:04:04.248371888 -0800
+++ b/arch/powerpc/kernel/machine_kexec_64.c	2011-03-07 01:14:32.020629577 -0800
@@ -15,6 +15,7 @@
 #include <linux/thread_info.h>
 #include <linux/init_task.h>
 #include <linux/errno.h>
+#include <linux/cpu.h>

 #include <asm/page.h>
 #include <asm/current.h>
@@ -169,10 +170,34 @@
	/* NOTREACHED */
 }

+/*
+ * We need to make sure each present CPU is online.  The next kernel will scan
+ * the device tree and assume primary threads are online and query secondary
+ * threads via RTAS to online them if required.  If we don't online primary
+ * threads, they will be stuck.  However, we also online secondary threads as we
+ * may be using 'cede offline'.  In this case RTAS doesn't see the secondary
+ * threads as offline -- and again, these CPUs will be stuck.
+ *
+ * So, we online all CPUs that should be running, including secondary threads.
+ */
+static void wake_offline_cpus(void)
+{
+	int cpu = 0;
+
+	for_each_present_cpu(cpu) {
+		if (!cpu_online(cpu)) {
+			printk(KERN_INFO "kexec: Waking offline cpu %d.\n",
+					cpu);
+			cpu_up(cpu);
+		}
+	}
+}
+
 static void kexec_prepare_cpus(void)
 {
	int my_cpu, i, notified=-1;

+	wake_offline_cpus();
	smp_call_function(kexec_smp_down, NULL, /* wait */0);
	my_cpu = get_cpu();

