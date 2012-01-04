Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2ADFcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 00:32:25 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52410 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2ADFcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 00:32:20 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <davej@redhat.com>, <cpufreq@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <nsekhar@ti.com>, <hvaibhav@ti.com>, Afzal Mohammed <afzal@ti.com>
Subject: [PATCH 1/2] cpufreq:userspace: fix cpu_cur_freq updation
Date: Wed, 4 Jan 2012 10:52:31 +0530
Message-ID: <1325654551-14169-1-git-send-email-afzal@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU frequency is guranteed to be changed on notifier callback with
CPUFREQ_POSTCHANGE. Notifier callback with CPUFREQ_PRECHANGE does
not gurantee a change in frequency; after it, if cpufreq driver is
unable to change CPU to new frequency. This results in wrong
information being fed to user (if setting CPU frequency fails)
upon doing like,

cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed

Hence in userspace governer update cpu_cur_freq only if notifier
has been called with POSTCHANGE.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/cpufreq/cpufreq_userspace.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index f231015..bedac1a 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -47,9 +47,11 @@ userspace_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 	if (!per_cpu(cpu_is_managed, freq->cpu))
 		return 0;
 
-	pr_debug("saving cpu_cur_freq of cpu %u to be %u kHz\n",
-			freq->cpu, freq->new);
-	per_cpu(cpu_cur_freq, freq->cpu) = freq->new;
+	if (val == CPUFREQ_POSTCHANGE) {
+		pr_debug("saving cpu_cur_freq of cpu %u to be %u kHz\n",
+				freq->cpu, freq->new);
+		per_cpu(cpu_cur_freq, freq->cpu) = freq->new;
+	}
 
 	return 0;
 }
-- 
1.7.1

