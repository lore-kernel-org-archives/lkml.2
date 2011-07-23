Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab1GWJh4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 05:37:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38284 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1GWJhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 05:37:50 -0400
Date: Sat, 23 Jul 2011 11:37:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/smpboot change for v3.1
Message-ID: <20110723093710.GA21914@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-smpboot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-smpboot-for-linus

 Thanks,

	Ingo

------------------>
Vivek Goyal (1):
      x86, boot: Wait for boot cpu to show up if nr_cpus limit is about to hit


 arch/x86/kernel/apic/apic.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b9338b8..68219a9 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1943,10 +1943,28 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 
 void __cpuinit generic_processor_info(int apicid, int version)
 {
-	int cpu;
+	int cpu, max = nr_cpu_ids;
+	bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
+				phys_cpu_present_map);
+
+	/*
+	 * If boot cpu has not been detected yet, then only allow upto
+	 * nr_cpu_ids - 1 processors and keep one slot free for boot cpu
+	 */
+	if (!boot_cpu_detected && num_processors >= nr_cpu_ids - 1 &&
+	    apicid != boot_cpu_physical_apicid) {
+		int thiscpu = max + disabled_cpus - 1;
+
+		pr_warning(
+			"ACPI: NR_CPUS/possible_cpus limit of %i almost"
+			" reached. Keeping one slot for boot cpu."
+			"  Processor %d/0x%x ignored.\n", max, thiscpu, apicid);
+
+		disabled_cpus++;
+		return;
+	}
 
 	if (num_processors >= nr_cpu_ids) {
-		int max = nr_cpu_ids;
 		int thiscpu = max + disabled_cpus;
 
 		pr_warning(
