Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1LVBqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:46:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:45173 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab1LVBqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:46:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="88326174"
Message-Id: <20111222014632.484984298@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 17:45:15 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: yinghai@kernel.org, flyboy@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/5] x86, apic: add probe() for apic_flat
References: <20111222014514.410584964@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=flat_apic_probe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Currently we start with the default apic_flat mode and switch to some other
apic model depending on the apic drivers acpi_madt_oem_check() routines and
later followed by the apic drivers probe() routines.

Once we selected non flat mode there was no case where we fall back to
flat mode again.

Upcoming changes allow bios-enabled x2apic mode to be disabled by the OS
if interrupt-remapping etc is not setup properly by the bios.

We now has a case for the apic to fall back to legacy flat mode during
apic driver probe() seqeuence. Add a simple flat_probe() which allows
the apic_flat mode to be the last fallback option.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 57c1f41..8c3cdde 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -171,9 +171,14 @@ static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
 	return initial_apic_id >> index_msb;
 }
 
+static int flat_probe(void)
+{
+	return 1;
+}
+
 static struct apic apic_flat =  {
 	.name				= "flat",
-	.probe				= NULL,
+	.probe				= flat_probe,
 	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
 	.apic_id_registered		= flat_apic_id_registered,
 


