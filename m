Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab2IDI1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:27:54 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:56008 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287Ab2IDIZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:25:33 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah1155h)
X-WSS-ID: 0M9TGQC-02-27F-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Renninger <trenn@suse.de>
CC: Matthew Garret <mjg@redhat.com>, <linux-pm@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 4/8 v2] powernow-k8: delay info messages until initialization has succeeded
Date: Tue, 4 Sep 2012 10:28:05 +0200
Message-ID: <1346747289-8421-5-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1346747289-8421-1-git-send-email-andre.przywara@amd.com>
References: <1346747289-8421-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powernow-k8 is quite prematurely crying Hooray and outputs diagnostic
messages, although the actual initialization can still fail.
Since now we may have acpi-cpufreq already loaded, we move the
messages at the end of the init routine to avoid confusing output
if the loading of powernow-k8 should not succeed.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 drivers/cpufreq/powernow-k8.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 16c7fb6..8ff0621 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1573,9 +1573,6 @@ static int __cpuinit powernowk8_init(void)
 	if (supported_cpus != num_online_cpus())
 		return -ENODEV;
 
-	printk(KERN_INFO PFX "Found %d %s (%d cpu cores) (" VERSION ")\n",
-		num_online_nodes(), boot_cpu_data.x86_model_id, supported_cpus);
-
 	if (boot_cpu_has(X86_FEATURE_CPB)) {
 
 		cpb_capable = true;
@@ -1594,16 +1591,23 @@ static int __cpuinit powernowk8_init(void)
 			struct msr *reg = per_cpu_ptr(msrs, cpu);
 			cpb_enabled |= !(!!(reg->l & BIT(25)));
 		}
-
-		printk(KERN_INFO PFX "Core Performance Boosting: %s.\n",
-			(cpb_enabled ? "on" : "off"));
 	}
 
 	rv = cpufreq_register_driver(&cpufreq_amd64_driver);
-	if (rv < 0 && boot_cpu_has(X86_FEATURE_CPB)) {
-		unregister_cpu_notifier(&cpb_nb);
-		msrs_free(msrs);
-		msrs = NULL;
+
+	if (!rv)
+		pr_info(PFX "Found %d %s (%d cpu cores) (" VERSION ")\n",
+			num_online_nodes(), boot_cpu_data.x86_model_id,
+			supported_cpus);
+
+	if (boot_cpu_has(X86_FEATURE_CPB)) {
+		if (rv < 0) {
+			unregister_cpu_notifier(&cpb_nb);
+			msrs_free(msrs);
+			msrs = NULL;
+		} else
+			pr_info(PFX "Core Performance Boosting: %s.\n",
+				(cpb_enabled ? "on" : "off"));
 	}
 	return rv;
 }
-- 
1.7.12


