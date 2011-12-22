Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1LVBqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:46:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:33181 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab1LVBqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:46:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104862529"
Message-Id: <20111222014632.702932458@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 17:45:19 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: yinghai@kernel.org, flyboy@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 5/5] x86: skip cpus with apic-ids >= 255 in !x2apic_mode
References: <20111222014514.410584964@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=skip_AP_with_bigger_apicids_in_xapic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

If the x2apic mode is disabled for reasons like interrupt-remapping
not available etc, then we need to skip the logical cpu bringup of
apic-id's >= 255. Otherwise as the platform is in xapic mode, init/startup
IPI's will consider only the low 8-bits and there is a possibility of
re-sending init/startup IPI's to the logical cpu that is already online.

This will avoid potential reboots/unpredictable behavior etc.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/smpboot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: tip/arch/x86/kernel/smpboot.c
===================================================================
--- tip.orig/arch/x86/kernel/smpboot.c
+++ tip/arch/x86/kernel/smpboot.c
@@ -840,7 +840,8 @@ int __cpuinit native_cpu_up(unsigned int
 	pr_debug("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
 
 	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
-	    !physid_isset(apicid, phys_cpu_present_map)) {
+	    !physid_isset(apicid, phys_cpu_present_map) ||
+	    (!x2apic_mode && apicid >= 255)) {
 		printk(KERN_ERR "%s: bad cpu %d\n", __func__, cpu);
 		return -EINVAL;
 	}


