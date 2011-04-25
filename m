Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab1DYUgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:36:21 -0400
Received: from 1wt.eu ([62.212.114.60]:34438 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398Ab1DYUZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:16 -0400
Message-Id: <20110425200236.384451034@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:50 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: greg@kroah.com, benh@kernel.crashing.org, anton@samba.org,
        Matt Evans <matt@ozlabs.org>,
        Kamalesh babulal <kamalesh@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 078/173] powerpc/kexec: Fix orphaned offline CPUs across kexec
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Evans <matt@ozlabs.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/kernel/machine_kexec_64.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -15,6 +15,7 @@
 #include <linux/thread_info.h>
 #include <linux/init_task.h>
 #include <linux/errno.h>
+#include <linux/cpu.h>
 
 #include <asm/page.h>
 #include <asm/current.h>
@@ -169,10 +170,34 @@ static void kexec_smp_down(void *arg)
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
 


