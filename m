Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946949Ab2ERXS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:18:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38665 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946592Ab2ERXFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:05:48 -0400
Message-Id: <20120518212650.055640307@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:26:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hyungwoo Yang <hwoo.yang@gmail.com>,
        Hyungwoo Yang <hyungwooy@nvidia.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 09/47] ARM: 7417/1: vfp: ensure preemption is disabled when enabling VFP access
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 998de4acb2ba188d20768d1065658377a2e7d29b upstream.

The vfp_enable function enables access to the VFP co-processor register
space (cp10 and cp11) on the current CPU and must be called with
preemption disabled. Unfortunately, the vfp_init late initcall does not
disable preemption and can lead to an oops during boot if thread
migration occurs at the wrong time and we end up attempting to access
the FPSID on a CPU with VFP access disabled.

This patch fixes the initcall to call vfp_enable from a non-preemptible
context on each CPU and adds a BUG_ON(preemptible) to ensure that any
similar problems are easily spotted in the future.

Reported-by: Hyungwoo Yang <hwoo.yang@gmail.com>
Signed-off-by: Hyungwoo Yang <hyungwooy@nvidia.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/vfp/vfpmodule.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/cpu.h>
 #include <linux/cpu_pm.h>
+#include <linux/hardirq.h>
 #include <linux/kernel.h>
 #include <linux/notifier.h>
 #include <linux/signal.h>
@@ -428,7 +429,10 @@ void VFP_bounce(u32 trigger, u32 fpexc,
 
 static void vfp_enable(void *unused)
 {
-	u32 access = get_copro_access();
+	u32 access;
+
+	BUG_ON(preemptible());
+	access = get_copro_access();
 
 	/*
 	 * Enable full access to VFP (cp10 and cp11)
@@ -556,7 +560,7 @@ static int __init vfp_init(void)
 	unsigned int cpu_arch = cpu_architecture();
 
 	if (cpu_arch >= CPU_ARCH_ARMv6)
-		vfp_enable(NULL);
+		on_each_cpu(vfp_enable, NULL, 1);
 
 	/*
 	 * First check that there is a VFP that we can use.
@@ -577,8 +581,6 @@ static int __init vfp_init(void)
 	} else {
 		hotcpu_notifier(vfp_hotplug, 0);
 
-		smp_call_function(vfp_enable, NULL, 1);
-
 		VFP_arch = (vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT;  /* Extract the architecture version */
 		printk("implementor %02x architecture %d part %02x variant %x rev %x\n",
 			(vfpsid & FPSID_IMPLEMENTER_MASK) >> FPSID_IMPLEMENTER_BIT,


