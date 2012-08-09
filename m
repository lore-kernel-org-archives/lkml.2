Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab2HISg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 14:36:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:16466 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758871Ab2HISg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 14:36:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,741,1336374000"; 
   d="scan'208";a="183737023"
Message-Id: <4670a300a2169e1e922593c5d35b0cdaee112901.1344536972.git.tony.luck@intel.com>
In-Reply-To: <2afe0125e4a9724f9cf22f03b0a1747ce67cdc8c.1344379657.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Thu, 9 Aug 2012 10:59:21 -0700
Subject: [PATCH 5/6] x86/mce: Make cmci_discover() quiet
To: Chen Gong <gong.chen@linux.intel.com>
Cc: bp@amd64.org, x86@kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cmci_discover() works out which machine check banks support CMCI, and
which of those are shared by multiple logical processors. It uses this
information to ensure that exactly one cpu is designated the owner of
each bank so that when interrupts are broadcast to multiple cpus, only one
of them will look in a shared bank to log the error and clear the bank.

At boot time cmci_discover() performs this task silently. But during
certain cpu hotplug operations it prints out a set of summary lines
like this:

CPU 35 MCA banks CMCI:0 CMCI:1 CMCI:3 CMCI:5 CMCI:6 CMCI:7 CMCI:8 CMCI:9 CMCI:10 CMCI:11
CPU 1 MCA banks CMCI:0 CMCI:1 CMCI:3
CPU 39 MCA banks CMCI:0 CMCI:1 CMCI:3
CPU 38 MCA banks CMCI:0 CMCI:1 CMCI:3
CPU 32 MCA banks CMCI:0 CMCI:1 CMCI:3
CPU 37 MCA banks CMCI:0 CMCI:1 CMCI:3
CPU 36 MCA banks CMCI:0 CMCI:1 CMCI:3
CPU 34 MCA banks CMCI:0 CMCI:1 CMCI:3

The value of these messages seems very low. A user might painstakingly
cross-check against the data sheet for a processor to ensure that all
CMCI supported banks are correctly reported, but this seems improbable.
If users really wanted to do this, we should print the information at
boot time too.

Remove the messages.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---

Gong pointed out to me offline that my previous "patch 5/6" would not
do what I said it did in the case where a processor is taken offline
during a CMCI storm. We'd have a topology change, but would suppress
the bank attribution messages when the storm ended.  I took a longer
look at the messages, and decided that we can live without them.

 arch/x86/kernel/cpu/mcheck/mce_intel.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 38e49bc..59648e4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -65,24 +65,15 @@ static void intel_threshold_interrupt(void)
 	mce_notify_irq();
 }
 
-static void print_update(char *type, int *hdr, int num)
-{
-	if (*hdr == 0)
-		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
-	*hdr = 1;
-	printk(KERN_CONT " %s:%d", type, num);
-}
-
 /*
  * Enable CMCI (Corrected Machine Check Interrupt) for available MCE banks
  * on this CPU. Use the algorithm recommended in the SDM to discover shared
  * banks.
  */
-static void cmci_discover(int banks, int boot)
+static void cmci_discover(int banks)
 {
 	unsigned long *owned = (void *)&__get_cpu_var(mce_banks_owned);
 	unsigned long flags;
-	int hdr = 0;
 	int i;
 
 	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
@@ -96,8 +87,7 @@ static void cmci_discover(int banks, int boot)
 
 		/* Already owned by someone else? */
 		if (val & MCI_CTL2_CMCI_EN) {
-			if (test_and_clear_bit(i, owned) && !boot)
-				print_update("SHD", &hdr, i);
+			clear_bit(i, owned);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 			continue;
 		}
@@ -109,16 +99,13 @@ static void cmci_discover(int banks, int boot)
 
 		/* Did the enable bit stick? -- the bank supports CMCI */
 		if (val & MCI_CTL2_CMCI_EN) {
-			if (!test_and_set_bit(i, owned) && !boot)
-				print_update("CMCI", &hdr, i);
+			set_bit(i, owned);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 		} else {
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
 	}
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
-	if (hdr)
-		printk(KERN_CONT "\n");
 }
 
 /*
@@ -186,7 +173,7 @@ void cmci_rediscover(int dying)
 			continue;
 		/* Recheck banks in case CPUs don't all have the same */
 		if (cmci_supported(&banks))
-			cmci_discover(banks, 0);
+			cmci_discover(banks);
 	}
 
 	set_cpus_allowed_ptr(current, old);
@@ -200,7 +187,7 @@ void cmci_reenable(void)
 {
 	int banks;
 	if (cmci_supported(&banks))
-		cmci_discover(banks, 0);
+		cmci_discover(banks);
 }
 
 static void intel_init_cmci(void)
@@ -211,7 +198,7 @@ static void intel_init_cmci(void)
 		return;
 
 	mce_threshold_vector = intel_threshold_interrupt;
-	cmci_discover(banks, 1);
+	cmci_discover(banks);
 	/*
 	 * For CPU #0 this runs with still disabled APIC, but that's
 	 * ok because only the vector is set up. We still do another
-- 
1.7.10.2.552.gaa3bb87

