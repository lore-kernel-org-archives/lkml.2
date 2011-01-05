Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab1AEXGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:06:36 -0500
Received: from kroah.org ([198.145.64.141]:50811 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab1AEXGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:34 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:26 2011
Message-Id: <20110105230326.068443369@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Chris Wright <chrisw@sous-sol.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [26/49] x86: Enable the intr-remap fault handling after local APIC setup
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

commit 7f7fbf45c6b748074546f7f16b9488ca71de99c1 upstream.

Interrupt-remapping gets enabled very early in the boot, as it determines the
apic mode that the processor can use. And the current code enables the vt-d
fault handling before the setup_local_APIC(). And hence the APIC LDR registers
and data structure in the memory may not be initialized. So the vt-d fault
handling in logical xapic/x2apic modes were broken.

Fix this by enabling the vt-d fault handling in the end_local_APIC_setup()

A cleaner fix of enabling fault handling while enabling intr-remapping
will be addressed for v2.6.38. [ Enabling intr-remapping determines the
usage of x2apic mode and the apic mode determines the fault-handling
configuration. ]

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
LKML-Reference: <20101201062244.541996375@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/apic.c     |    8 ++++++++
 arch/x86/kernel/apic/probe_64.c |    7 -------
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1361,6 +1361,14 @@ void __cpuinit end_local_APIC_setup(void
 
 	setup_apic_nmi_watchdog(NULL);
 	apic_pm_activate();
+
+	/*
+	 * Now that local APIC setup is completed for BP, configure the fault
+	 * handling for interrupt remapping.
+	 */
+	if (!smp_processor_id() && intr_remapping_enabled)
+		enable_drhd_fault_handling();
+
 }
 
 #ifdef CONFIG_X86_X2APIC
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -76,13 +76,6 @@ void __init default_setup_apic_routing(v
 		/* need to update phys_pkg_id */
 		apic->phys_pkg_id = apicid_phys_pkg_id;
 	}
-
-	/*
-	 * Now that apic routing model is selected, configure the
-	 * fault handling for intr remapping.
-	 */
-	if (intr_remapping_enabled)
-		enable_drhd_fault_handling();
 }
 
 /* Same for both flat and physical. */


