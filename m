Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2GZM3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:29:15 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:24349
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960Ab2GZM3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:29:00 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M7RPC5-02-2A3-02
X-M-MSG: 
From: Andre Przywara <andre.przywara@amd.com>
To: <cpufreq@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Renninger <trenn@suse.de>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH 3/8] cpufreq: Add compatibility hack to powernow-k8
Date: Thu, 26 Jul 2012 14:28:39 +0200
Message-ID: <1343305724-2809-4-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1343305724-2809-1-git-send-email-andre.przywara@amd.com>
References: <1343305724-2809-1-git-send-email-andre.przywara@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

cpufreq modules are often loaded from init scripts that assume that all
recent AMD systems will use powernow-k8, so we should ensure that loading
it triggers a load of acpi-cpufreq if the latter is built as a module.
This avoids the problem of users ending up without any cpufreq support
after the transition.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 drivers/cpufreq/powernow-k8.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index c0e8164..6e35ed2 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1567,8 +1567,12 @@ static int __cpuinit powernowk8_init(void)
 			supported_cpus++;
 	}
 
-	if (supported_cpus != num_online_cpus())
+	if (supported_cpus != num_online_cpus()) {
+		if (static_cpu_has(X86_FEATURE_HW_PSTATE))
+			request_module("acpi_cpufreq");
+
 		return -ENODEV;
+	}
 
 	printk(KERN_INFO PFX "Found %d %s (%d cpu cores) (" VERSION ")\n",
 		num_online_nodes(), boot_cpu_data.x86_model_id, supported_cpus);
-- 
1.7.4.4


