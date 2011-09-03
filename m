Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab1ICOj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 10:39:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36658 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab1ICOju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 10:39:50 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <ccross@android.com>, <rjw@sisk.pl>, <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 2/5] cpu_pm: call notifiers during suspend
Date: Sat, 3 Sep 2011 20:09:12 +0530
Message-ID: <1315060755-4613-3-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Implements syscore_ops in cpu_pm to call the cpu and
cpu cluster notifiers during suspend and resume,
allowing drivers receiving the notifications to
avoid implementing syscore_ops.

Signed-off-by: Colin Cross <ccross@android.com>
[santosh.shilimkar@ti.com: Rebased against 3.1-rc4]
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 kernel/cpu_pm.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/kernel/cpu_pm.c b/kernel/cpu_pm.c
index 54aa892..3d115d0 100644
--- a/kernel/cpu_pm.c
+++ b/kernel/cpu_pm.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/spinlock.h>
+#include <linux/syscore_ops.h>
 
 static DEFINE_RWLOCK(cpu_pm_notifier_lock);
 static RAW_NOTIFIER_HEAD(cpu_pm_notifier_chain);
@@ -113,3 +114,35 @@ int cpu_cluster_pm_exit(void)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(cpu_cluster_pm_exit);
+
+#ifdef CONFIG_PM
+static int cpu_pm_suspend(void)
+{
+	int ret;
+
+	ret = cpu_pm_enter();
+	if (ret)
+		return ret;
+
+	ret = cpu_cluster_pm_enter();
+	return ret;
+}
+
+static void cpu_pm_resume(void)
+{
+	cpu_cluster_pm_exit();
+	cpu_pm_exit();
+}
+
+static struct syscore_ops cpu_pm_syscore_ops = {
+	.suspend = cpu_pm_suspend,
+	.resume = cpu_pm_resume,
+};
+
+static int cpu_pm_init(void)
+{
+	register_syscore_ops(&cpu_pm_syscore_ops);
+	return 0;
+}
+core_initcall(cpu_pm_init);
+#endif
-- 
1.7.4.1

