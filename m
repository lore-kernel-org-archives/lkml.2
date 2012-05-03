Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab2ECW7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:59:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46664 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab2ECW7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:59:41 -0400
MIME-Version: 1.0
Date: Thu, 3 May 2012 15:59:41 -0700
Message-ID: <CAOsG7to=Ap9O0vbJGSbC72fyDBa6dzBxvwBYqCJiB=GVnu=S4A@mail.gmail.com>
Subject: process migration during vfp_init() generates kernel crash
From: Hyungwoo Yang <hwoo.yang@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I think I've found a bug but actually I'm not sure whether it only
happens to me due to our changes in kernel.

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

====== modified code =====
/*
 * VFP support code initialisation.
 */
static int __init vfp_init(void)
{
	unsigned int vfpsid;
	unsigned int cpu_arch = cpu_architecture();
#ifdef CONFIG_SMP
	preempt_disable(); <== disable preemption !!!!!!
#endif
	if (cpu_arch >= CPU_ARCH_ARMv6)
		vfp_enable(NULL);

	/*
	 * First check that there is a VFP that we can use.
	 * The handler is already setup to just log calls, so
	 * we just need to read the VFPSID register.
	 */
	vfp_vector = vfp_testing_entry;
	barrier();
	vfpsid = fmrx(FPSID);
	barrier();
	vfp_vector = vfp_null_entry;
#ifdef CONFIG_SMP
	preempt_enable(); <== enable preemption  !!!!!!
#endif

	printk(KERN_INFO "VFP support v0.3: ");
	if (VFP_arch)
		printk("not present\n");
	else if (vfpsid & FPSID_NODOUBLE) {
		printk("no double precision support\n");
	} else {
		hotcpu_notifier(vfp_hotplug, 0);

		on_each_cpu(vfp_enable, NULL, 1); <== call on_each_cpu() instead of
smp_call_function() !!!!!!
                                :
                                :		
                                :
	}
	return 0;
}
=====================================================

- Hyungwoo Yang
