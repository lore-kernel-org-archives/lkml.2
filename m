Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965039Ab1C3VdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:33:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:47856 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964987Ab1C3VIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447934"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: matt@ozlabs.org, greg@kroah.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, anton@samba.org,
        kamalesh@linux.vnet.ibm.com, ak@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [178/275] powerpc/kexec: Fix orphaned offline CPUs across kexec
Message-Id: <20110330210701.247113E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/kernel/machine_kexec_64.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/powerpc/kernel/machine_kexec_64.c
===================================================================
--- linux-2.6.35.y.orig/arch/powerpc/kernel/machine_kexec_64.c	2011-03-29 22:50:52.264921091 -0700
+++ linux-2.6.35.y/arch/powerpc/kernel/machine_kexec_64.c	2011-03-29 23:03:01.938250575 -0700
@@ -15,6 +15,7 @@
 #include <linux/thread_info.h>
 #include <linux/init_task.h>
 #include <linux/errno.h>
+#include <linux/cpu.h>
 
 #include <asm/page.h>
 #include <asm/current.h>
@@ -199,9 +200,32 @@
 	mb();
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
-
+	wake_offline_cpus();
 	smp_call_function(kexec_smp_down, NULL, /* wait */0);
 	local_irq_disable();
 	mb(); /* make sure IRQs are disabled before we say they are */
