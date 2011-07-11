Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1GKAFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 20:05:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10418 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab1GKAFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 20:05:05 -0400
From: Colin Cross <ccross@android.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] PM: Reintroduce dropped call to check_wakeup_irqs
Date: Sun, 10 Jul 2011 17:04:26 -0700
Message-Id: <1310342666-2493-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 2e711c04dbbf7a7732a3f7073b1fc285d12b369d
(PM: Remove sysdev suspend, resume and shutdown operations)
deleted sysdev_suspend, which was being relied on to call
check_wakeup_irqs in suspend.  If check_wakeup_irqs is not
called, wake interrupts that are pending when suspend is
entered may be lost.  It also breaks IRQCHIP_MASK_ON_SUSPEND,
which is handled in check_wakeup_irqs.

This patch adds a call to check_wakeup_irqs in syscore_suspend,
similar to what was deleted in sysdev_suspend.

CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/base/syscore.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/base/syscore.c b/drivers/base/syscore.c
index c126db3..9b8bbe0 100644
--- a/drivers/base/syscore.c
+++ b/drivers/base/syscore.c
@@ -9,6 +9,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
+#include <linux/interrupt.h>
 
 static LIST_HEAD(syscore_ops_list);
 static DEFINE_MUTEX(syscore_ops_lock);
@@ -48,6 +49,13 @@ int syscore_suspend(void)
 	struct syscore_ops *ops;
 	int ret = 0;
 
+	pr_debug("Checking wake-up interrupts\n");
+
+	/* Return error code if there are any wake-up interrupts pending */
+	ret = check_wakeup_irqs();
+	if (ret)
+		return ret;
+
 	WARN_ONCE(!irqs_disabled(),
 		"Interrupts enabled before system core suspend.\n");
 
-- 
1.7.4.1

