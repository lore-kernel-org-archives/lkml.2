Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1GRQjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:39:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab1GRQiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:38:21 -0400
From: Matthew Garrett <mjg@redhat.com>
To: cpufreq@vger.kernel.org
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, borislav.petkov@amd.com,
        mark.langsdorf@amd.com, andreas.herrmann3@amd.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH v4 5/7] cpufreq: Add compatibility hack to powernow-k8
Date: Mon, 18 Jul 2011 12:37:40 -0400
Message-Id: <1311007062-2050-6-git-send-email-mjg@redhat.com>
In-Reply-To: <1311007062-2050-1-git-send-email-mjg@redhat.com>
References: <1311007062-2050-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:721a:4ff:fed2:9f6c
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq modules are often loaded from init scripts that assume that all
recent AMD systems will use powernow-k8, so we should ensure that loading
it triggers a load of acpi-cpufreq if the latter is built as a module.
This avoids the problem of users ending up without any cpufreq support
after the transition.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/cpufreq/powernow-k8.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index bce576d..8de4446 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1549,8 +1549,12 @@ static int __cpuinit powernowk8_init(void)
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
1.7.6

