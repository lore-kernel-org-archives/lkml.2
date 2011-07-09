Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab1GIAZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 20:25:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:46310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1GIAZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 20:25:01 -0400
Date: Sat, 9 Jul 2011 00:24:54 GMT
From: tip-bot for Vivek Goyal <vgoyal@redhat.com>
Message-ID: <tip-14cb6dcf0a023f5977461c94d8d5a163c937979b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        vgoyal@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, vgoyal@redhat.com,
        hpa@linux.intel.com
In-Reply-To: <20110708171926.GF2930@redhat.com>
References: <20110708171926.GF2930@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smpboot] x86, boot: Wait for boot cpu to show up if nr_cpus limit is about to hit
Git-Commit-ID: 14cb6dcf0a023f5977461c94d8d5a163c937979b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 09 Jul 2011 00:24:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14cb6dcf0a023f5977461c94d8d5a163c937979b
Gitweb:     http://git.kernel.org/tip/14cb6dcf0a023f5977461c94d8d5a163c937979b
Author:     Vivek Goyal <vgoyal@redhat.com>
AuthorDate: Fri, 8 Jul 2011 13:19:26 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 8 Jul 2011 15:33:35 -0700

x86, boot: Wait for boot cpu to show up if nr_cpus limit is about to hit

nr_cpus allows one to specify number of possible cpus in the system.
Current assumption seems to be that first cpu to show up is boot cpu
and this assumption will be broken in kdump scenario where we can be
booting on a non boot cpu with nr_cpus=1.

It might happen that first cpu we parse is not the cpu we boot on and
later we ignore boot cpu. Though code later seems to recognize this
anomaly and forcibly sets boot cpu in physical cpu map with following
warning.

if (!physid_isset(hard_smp_processor_id(), phys_cpu_present_map)) {
        printk(KERN_WARNING
                "weird, boot CPU (#%d) not listed by the BIOS.\n",
                hard_smp_processor_id());

        physid_set(hard_smp_processor_id(), phys_cpu_present_map);
}

This patch waits for boot cpu to show up and starts ignoring the cpus
once we have hit (nr_cpus - 1) number of cpus. So effectively we are
reserving one slot out of nr_cpus for boot cpu explicitly.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/20110708171926.GF2930@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
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
