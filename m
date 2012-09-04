Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab2IDIZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:25:49 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:48733
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754651Ab2IDIZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:25:38 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah1155h)
X-WSS-ID: 0M9TGQG-02-27L-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Renninger <trenn@suse.de>
CC: Matthew Garret <mjg@redhat.com>, <linux-pm@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 2/8 v2] acpi-cpufreq: Add quirk to disable _PSD usage on all AMD CPUs
Date: Tue, 4 Sep 2012 10:28:03 +0200
Message-ID: <1346747289-8421-3-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346747289-8421-1-git-send-email-andre.przywara@amd.com>
References: <1346747289-8421-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To workaround some Windows specific behavior, the ACPI _PSD table
on AMD desktop boards advertises all cores as dependent, meaning
that they all can only use the same P-state. acpi-cpufreq strictly
obeys this description, instantiating one CPU only and symlinking
the others. But the hardware can have distinct frequencies for each
core and powernow-k8 did it that way.
So, in order to use the hardware to its full potential and keep the
original powernow-k8 behavior, lets override the _PSD table setting
on AMD hardware.
We use the siblings table, as it matches the current hardware
behavior.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 drivers/cpufreq/acpi-cpufreq.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 067a61f..70e7173 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -51,6 +51,8 @@ MODULE_AUTHOR("Paul Diefenbaugh, Dominik Brodowski");
 MODULE_DESCRIPTION("ACPI Processor P-States Driver");
 MODULE_LICENSE("GPL");
 
+#define PFX "acpi-cpufreq: "
+
 enum {
 	UNDEFINED_CAPABLE = 0,
 	SYSTEM_INTEL_MSR_CAPABLE,
@@ -586,6 +588,14 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
 		cpumask_copy(policy->cpus, cpu_core_mask(cpu));
 	}
+
+	if (check_amd_hwpstate_cpu(cpu) && !acpi_pstate_strict) {
+		cpumask_clear(policy->cpus);
+		cpumask_set_cpu(cpu, policy->cpus);
+		cpumask_copy(policy->related_cpus, cpu_sibling_mask(cpu));
+		policy->shared_type = CPUFREQ_SHARED_TYPE_HW;
+		pr_info_once(PFX "overriding BIOS provided _PSD data\n");
+	}
 #endif
 
 	/* capability check */
-- 
1.7.12


