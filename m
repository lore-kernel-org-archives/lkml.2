Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab0LNBRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:17:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:46607 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758790Ab0LNBRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:17:06 -0500
Date: Tue, 14 Dec 2010 01:16:41 GMT
From: tip-bot for Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        chrisw@sous-sol.org, suresh.b.siddha@intel.com,
        kaneshige.kenji@jp.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        chrisw@sous-sol.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        kaneshige.kenji@jp.fujitsu.com, hpa@linux.intel.com
In-Reply-To: <20101201062244.541996375@intel.com>
References: <20101201062244.541996375@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Enable the intr-remap fault handling after local APIC setup
Message-ID: <tip-7f7fbf45c6b748074546f7f16b9488ca71de99c1@git.kernel.org>
Git-Commit-ID: 7f7fbf45c6b748074546f7f16b9488ca71de99c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 01:16:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f7fbf45c6b748074546f7f16b9488ca71de99c1
Gitweb:     http://git.kernel.org/tip/7f7fbf45c6b748074546f7f16b9488ca71de99c1
Author:     Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
AuthorDate: Tue, 30 Nov 2010 22:22:28 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 13 Dec 2010 16:53:32 -0800

x86: Enable the intr-remap fault handling after local APIC setup

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
Cc: stable@kernel.org [v2.6.32+]
Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apic/apic.c     |    8 ++++++++
 arch/x86/kernel/apic/probe_64.c |    7 -------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3f838d5..7821813 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1389,6 +1389,14 @@ void __cpuinit end_local_APIC_setup(void)
 
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
index f9e4e6a..d8c4a6f 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -79,13 +79,6 @@ void __init default_setup_apic_routing(void)
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
