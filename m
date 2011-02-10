Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab1BJOng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 09:43:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:46310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327Ab1BJOne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 09:43:34 -0500
Date: Thu, 10 Feb 2011 14:43:15 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        gorcunov@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        gorcunov@gmail.com, mingo@elte.hu
In-Reply-To: <4D525C7E0200007800030EE1@vpn.id2.novell.com>
References: <4D525C7E0200007800030EE1@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix section mismatch in LAPIC initialization
Message-ID: <tip-2fb270f3212a1e6a73f86f76c85caee93aae4386@git.kernel.org>
Git-Commit-ID: 2fb270f3212a1e6a73f86f76c85caee93aae4386
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Feb 2011 14:43:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fb270f3212a1e6a73f86f76c85caee93aae4386
Gitweb:     http://git.kernel.org/tip/2fb270f3212a1e6a73f86f76c85caee93aae4386
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Wed, 9 Feb 2011 08:21:02 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Feb 2011 13:26:53 +0100

x86: Fix section mismatch in LAPIC initialization

Additionally doing things conditionally upon smp_processor_id()
being zero is generally a bad idea, as this means CPU 0 cannot
be offlined and brought back online later again.

While there may be other places where this is done, I think adding
more of those should be avoided so that some day SMP can really
become "symmetrical".

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
LKML-Reference: <4D525C7E0200007800030EE1@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h |    1 +
 arch/x86/kernel/apic/apic.c |    9 +++++++--
 arch/x86/kernel/smpboot.c   |    4 ++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 5e3969c..3c89694 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -233,6 +233,7 @@ extern void sync_Arb_IDs(void);
 extern void init_bsp_APIC(void);
 extern void setup_local_APIC(void);
 extern void end_local_APIC_setup(void);
+extern void bsp_end_local_APIC_setup(void);
 extern void init_apic_mappings(void);
 void register_lapic_address(unsigned long address);
 extern void setup_boot_APIC_clock(void);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 06c196d..76b96d7 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1381,12 +1381,17 @@ void __cpuinit end_local_APIC_setup(void)
 #endif
 
 	apic_pm_activate();
+}
+
+void __init bsp_end_local_APIC_setup(void)
+{
+	end_local_APIC_setup();
 
 	/*
 	 * Now that local APIC setup is completed for BP, configure the fault
 	 * handling for interrupt remapping.
 	 */
-	if (!smp_processor_id() && intr_remapping_enabled)
+	if (intr_remapping_enabled)
 		enable_drhd_fault_handling();
 
 }
@@ -1756,7 +1761,7 @@ int __init APIC_init_uniprocessor(void)
 		enable_IO_APIC();
 #endif
 
-	end_local_APIC_setup();
+	bsp_end_local_APIC_setup();
 
 #ifdef CONFIG_X86_IO_APIC
 	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 03273b6..08776a9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1060,7 +1060,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 
 		connect_bsp_APIC();
 		setup_local_APIC();
-		end_local_APIC_setup();
+		bsp_end_local_APIC_setup();
 		return -1;
 	}
 
@@ -1137,7 +1137,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	if (!skip_ioapic_setup && nr_ioapics)
 		enable_IO_APIC();
 
-	end_local_APIC_setup();
+	bsp_end_local_APIC_setup();
 
 	map_cpu_to_logical_apicid();
 
