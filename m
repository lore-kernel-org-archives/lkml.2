Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0KPFd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 00:33:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:46932 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab0KPFd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 00:33:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,204,1288594800"; 
   d="scan'208";a="627161696"
Date: Tue, 16 Nov 2010 12:13:30 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: lethal@linux-sh.org
Cc: linux-kernel@vger.kernel.org
Subject: [v2,5/8] NUMA Hotplug emulator
Message-ID: <20101116041330.GA20694@shaohui>
Mail-Followup-To: lethal@linux-sh.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>This looks like an incredibly painful interface. How about scrapping all
>of this _emu() mess and just reworking the register_cpu() interface?
> Something like:

hi, Paul
	I saw your reply on patchwork.kernel.org, but I did not find your email 
in my mailbox, you might forget to cc to me.

	I think that your register_cpu_node interface seems good, but this will 
remove the interface register_cpu. it is not the original purpose of the 
emulator, we want to emulate the oringal process, but we did not want to change
the old interface, that is a rule.

	I want to share some piece of codes, and I did not want to do so much change,
so I call register_cpu and register_cpu_emu in the same function. yes, it is a 
painful interface, I will add a function arch_register_cpu_emu to solve it.

Real hotplug process:
arch_register_cpu
	- call register_cpu

Emulated hotplug process:
arch_register_cpu_emu
	- call register_cpu_emu

diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 7e45159..93859d5 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -52,6 +52,16 @@ int __ref arch_register_cpu(int num)
 }
 EXPORT_SYMBOL(arch_register_cpu);
 
+/* emulated version for arch_register_cpu */
+int __ref arch_register_cpu_emu(int num, int nid)
+{
+	if (num)
+		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
+
+	return register_cpu_emu(&per_cpu(cpu_devices, num).cpu, nid);
+}
+EXPORT_SYMBOL(arch_register_cpu_emu);
+
 void arch_unregister_cpu(int num)
 {
 	unregister_cpu(&per_cpu(cpu_devices, num).cpu);

-- 
Thanks & Regards,
Shaohui

