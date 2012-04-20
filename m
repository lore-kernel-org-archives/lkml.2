Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2DTNHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:07:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:44821 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab2DTNGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:06:00 -0400
Message-Id: <20120420124557.035417523@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Howells <dhowells@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org
Subject: [patch 03/18] smp: Add generic smpboot facility
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline; filename=smp-add-generic-smpboot-facility.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start a new file, which will hold SMP and CPU hotplug related generic
infrastructure.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org
---
 kernel/Makefile  |    1 +
 kernel/cpu.c     |    8 ++++++++
 kernel/smpboot.c |   12 ++++++++++++
 kernel/smpboot.h |    6 ++++++
 4 files changed, 27 insertions(+)

Index: linux-2.6/kernel/Makefile
===================================================================
--- linux-2.6.orig/kernel/Makefile
+++ linux-2.6/kernel/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmute
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 obj-$(CONFIG_SMP) += smp.o
+obj-$(CONFIG_SMP) += smpboot.o
 ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -17,6 +17,8 @@
 #include <linux/gfp.h>
 #include <linux/suspend.h>
 
+#include "smpboot.h"
+
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
 static DEFINE_MUTEX(cpu_add_remove_lock);
@@ -300,6 +302,11 @@ static int __cpuinit _cpu_up(unsigned in
 		return -EINVAL;
 
 	cpu_hotplug_begin();
+
+	ret = smpboot_prepare(cpu);
+	if (ret)
+		goto out;
+
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
@@ -320,6 +327,7 @@ static int __cpuinit _cpu_up(unsigned in
 out_notify:
 	if (ret != 0)
 		__cpu_notify(CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
+out:
 	cpu_hotplug_done();
 
 	return ret;
Index: linux-2.6/kernel/smpboot.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/smpboot.c
@@ -0,0 +1,12 @@
+/*
+ * Common SMP CPU bringup/teardown functions
+ */
+
+#include "smpboot.h"
+
+/**
+ * smpboot_prepare - generic smpboot preparation
+ */
+int __cpuinit smpboot_prepare(unsigned int cpu)
+{
+}
Index: linux-2.6/kernel/smpboot.h
===================================================================
--- /dev/null
+++ linux-2.6/kernel/smpboot.h
@@ -0,0 +1,6 @@
+#ifndef SMPBOOT_H
+#define SMPBOOT_H
+
+int smpboot_prepare(unsigned int cpu);
+
+#endif


