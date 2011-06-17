Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab1FQTvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 15:51:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933005Ab1FQTvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 15:51:22 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: borislav.petkov@amd.com, davej@redhat.com, mark.langsdorf@amd.com,
        cpufreq@vger.kernel.org, andreas.herrmann3@amd.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2 5/6] cpufreq: Add compatibility hack to powernow-k8
Date: Fri, 17 Jun 2011 15:50:56 -0400
Message-Id: <1308340257-10117-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1308340257-10117-1-git-send-email-mjg@redhat.com>
References: <1308340257-10117-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:8a9f:faff:fefa:2632
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
index 83479b6..8591ec8 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1545,8 +1545,12 @@ static int __cpuinit powernowk8_init(void)
 			supported_cpus++;
 	}
 
-	if (supported_cpus != num_online_cpus())
+	if (supported_cpus != num_online_cpus()) {
+		if (cpu_has(0, X86_FEATURE_HW_PSTATE))
+			request_module("acpi_cpufreq");
+
 		return -ENODEV;
+	}
 
 	printk(KERN_INFO PFX "Found %d %s (%d cpu cores) (" VERSION ")\n",
 		num_online_nodes(), boot_cpu_data.x86_model_id, supported_cpus);
-- 
1.7.5.2

