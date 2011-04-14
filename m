Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035Ab1DNR64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:58:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:42193 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964981Ab1DNR6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 178/209] x86: Enable the intr-remap fault handling after local APIC setup
Date: Thu, 14 Apr 2011 13:55:36 -0400
Message-Id: <1302803767-9715-65-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/apic/apic.c     |    8 ++++++++
 arch/x86/kernel/apic/probe_64.c |    7 -------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a96489e..c00a104 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1340,6 +1340,14 @@ void __cpuinit end_local_APIC_setup(void)
 
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
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 83e9be4..fac49a8 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -76,13 +76,6 @@ void __init default_setup_apic_routing(void)
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
-- 
1.7.4.4

