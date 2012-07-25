Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2GYVUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 17:20:23 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41277 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2GYVUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 17:20:22 -0400
From: Colin Cross <ccross@android.com>
To: Len Brown <lenb@kernel.org>
Cc: Colin Cross <ccross@android.com>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: [PATCH] cpuidle: coupled: fix sleeping while atomic in cpu notifier
Date: Wed, 25 Jul 2012 14:20:11 -0700
Message-Id: <1343251216-24106-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu hotplug notifier gets called in both atomic and non-atomic
contexts, it is not always safe to lock a mutex.  Filter out all events
except the six necessary ones, which are all sleepable, before taking
the mutex.

Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/cpuidle/coupled.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index 2c9bf26..c24dda0 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -678,6 +678,18 @@ static int cpuidle_coupled_cpu_notify(struct notifier_block *nb,
 	int cpu = (unsigned long)hcpu;
 	struct cpuidle_device *dev;
 
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+	case CPU_DOWN_PREPARE:
+	case CPU_ONLINE:
+	case CPU_DEAD:
+	case CPU_UP_CANCELED:
+	case CPU_DOWN_FAILED:
+		break;
+	default:
+		return NOTIFY_OK;
+	}
+
 	mutex_lock(&cpuidle_lock);
 
 	dev = per_cpu(cpuidle_devices, cpu);
-- 
1.7.7.3

