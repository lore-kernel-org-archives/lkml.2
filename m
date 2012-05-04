Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105Ab2EDAZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 20:25:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41873 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab2EDAZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 20:25:47 -0400
MIME-Version: 1.0
Date: Thu, 3 May 2012 17:25:46 -0700
Message-ID: <CAOsG7tqPgAJcLBx4hTE9-0bnCPymzCU4dhOHMjAPd+w9fqijVg@mail.gmail.com>
Subject: [PATCH] Prevent process migration during vfp_init()
From: Hyungwoo Yang <hwoo.yang@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I think I've found a bug but actually I'm not sure whether it only
happens to me due to our changes in kernel.

I really need your opinion.

In vfp_init() in "arch/arm/vfp/vfpmodule.c", if there is process
migration between vfp_enable() and smp_call_function() then kernel
crashes.

===== original code =====

       if (cpu_arch >= CPU_ARCH_ARMv6)
               vfp_enable(NULL); <== if migration happens just after
vfp_enable(NULL), kernel crashes.
                 :
                 :
       vfpsid = fmrx(FPSID); <== if migration happens, read tries to
access disbled VFP unit.
                 :
                 :
      if (VFP_arch)
               printk("not present\n");
       else if (vfpsid & FPSID_NODOUBLE) {
               printk("no double precision support\n");
       } else {
               hotcpu_notifier(vfp_hotplug, 0);

               smp_call_function(vfp_enable, NULL, 1); <== if migration happens,
smp_call_function will not work as it is expected.
=======================

Do you have any opinion?


There're a few ways of preventing migration (like set affinity or
disable premption) but the following is one of the way.
=======================

>From 6d48d0aaac03e845646b445ad02ef3c228dcfdb9 Mon Sep 17 00:00:00 2001
From: Hyungwoo Yang <hyungwooy@nvidia.com>
Date: Thu, 3 May 2012 16:49:13 -0700
Subject: [PATCH] ARM: vfp: Prevent process migration during vfp_init()

System crashes if there is process migration during vfp_init() call.

During vfp_init(), if a process which called vfp_enable() is migrated just
after the call, then the process executing the rest of code will access
a VFP unit which is not ENABLED and also smp_call_function() will not work
as it is expected.

This patch prevents accessing VFP unit disabled by preventing migration
and also replaces smp_call_function() with on_each_cpu() to make sure that
no VFP remains disabled.

Signed-off-by: Hyungwoo Yang <hyungwooy@nvidia.com>
---
 arch/arm/vfp/vfpmodule.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index bc683b8..fefa4cb 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -655,7 +655,9 @@ static int __init vfp_init(void)
 {
 	unsigned int vfpsid;
 	unsigned int cpu_arch = cpu_architecture();
-
+#ifdef CONFIG_SMP
+	preempt_disable();
+#endif
 	if (cpu_arch >= CPU_ARCH_ARMv6)
 		vfp_enable(NULL);

@@ -669,6 +671,9 @@ static int __init vfp_init(void)
 	vfpsid = fmrx(FPSID);
 	barrier();
 	vfp_vector = vfp_null_entry;
+#ifdef CONFIG_SMP
+	preempt_enable();
+#endif

 	printk(KERN_INFO "VFP support v0.3: ");
 	if (VFP_arch)
@@ -678,7 +683,7 @@ static int __init vfp_init(void)
 	} else {
 		hotcpu_notifier(vfp_hotplug, 0);

-		smp_call_function(vfp_enable, NULL, 1);
+		on_each_cpu(vfp_enable, NULL, 1);

 		VFP_arch = (vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT;  /*
Extract the architecture version */
 		printk("implementor %02x architecture %d part %02x variant %x rev %x\n",
-- 
1.7.0.4
