Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab0CSQY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 12:24:26 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46887 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0CSQYY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Fri, 19 Mar 2010 12:24:24 -0400
Message-Id: <4BA3B3480200007800035F1A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 19 Mar 2010 16:24:24 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: "nosmp" command line option should force the
	 system into UP mode
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bits set in cpu_possible_mask prior to the execution of
prefill_possible_map() (i.e. when parsing ACPI or MPS tables) would
prevent the SMP alternatives logic from switching to UP mode, plus
unnecessary setup of per-CPU data for CPUs that can never come online.

Additionally, without CONFIG_HOTPLUG_CPU disabled CPUs can never come
online, and hence setting cpu_possible_mask bits for them is again a
simple waste of resources.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/smpboot.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

--- linux-2.6.34-rc1/arch/x86/kernel/smpboot.c
+++ 2.6.34-rc1-x86-nosmp-UP-mode/arch/x86/kernel/smpboot.c
@@ -1214,9 +1214,17 @@ __init void prefill_possible_map(void)
 	if (!num_processors)
 		num_processors = 1;
 
-	if (setup_possible_cpus == -1)
-		possible = num_processors + disabled_cpus;
-	else
+	i = setup_max_cpus ?: 1;
+	if (setup_possible_cpus == -1) {
+		possible = num_processors;
+#ifdef CONFIG_HOTPLUG_CPU
+		if (setup_max_cpus)
+			possible += disabled_cpus;
+#else
+		if (possible > i)
+			possible = i;
+#endif
+	} else
 		possible = setup_possible_cpus;
 
 	total_cpus = max_t(int, possible, num_processors + disabled_cpus);
@@ -1229,11 +1237,23 @@ __init void prefill_possible_map(void)
 		possible = nr_cpu_ids;
 	}
 
+#ifdef CONFIG_HOTPLUG_CPU
+	if (!setup_max_cpus)
+#endif
+	if (possible > i) {
+		printk(KERN_WARNING
+			"%d Processors exceeds max_cpus limit of %u\n",
+			possible, setup_max_cpus);
+		possible = i;
+	}
+
 	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
 		possible, max_t(int, possible - num_processors, 0));
 
 	for (i = 0; i < possible; i++)
 		set_cpu_possible(i, true);
+	for (; i < NR_CPUS; i++)
+		set_cpu_possible(i, false);
 
 	nr_cpu_ids = possible;
 }



