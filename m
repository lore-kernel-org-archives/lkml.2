Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1AXE35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:29:57 -0500
Received: from www.tglx.de ([62.245.132.106]:42917 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab1AXE3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:29:55 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andres Salomon <dilinger@queued.net>
Subject: [PATCH OF 12/14] x86/rtc: don't register rtc if we the DT blob
Date: Mon, 24 Jan 2011 09:59:00 +0530
Message-Id: <1295843342-1122-13-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

or we might end up with two device nodes for the same hardware.

Cc: Andres Salomon <dilinger@queued.net>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kernel/rtc.c |    3 +++
 include/linux/of.h    |   12 ++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 6f39cab..3f2ad26 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -6,6 +6,7 @@
 #include <linux/acpi.h>
 #include <linux/bcd.h>
 #include <linux/pnp.h>
+#include <linux/of.h>
 
 #include <asm/vsyscall.h>
 #include <asm/x86_init.h>
@@ -236,6 +237,8 @@ static __init int add_rtc_cmos(void)
 		}
 	}
 #endif
+	if (of_have_populated_dt())
+		return 0;
 
 	platform_device_register(&rtc_device);
 	dev_info(&rtc_device.dev,
diff --git a/include/linux/of.h b/include/linux/of.h
index cad7cf0..016968d 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -70,6 +70,11 @@ extern struct device_node *allnodes;
 extern struct device_node *of_chosen;
 extern rwlock_t devtree_lock;
 
+static inline int of_have_populated_dt(void)
+{
+	return allnodes != NULL;
+}
+
 static inline bool of_node_is_root(const struct device_node *node)
 {
 	return node && (node->parent == NULL);
@@ -222,5 +227,12 @@ extern void of_attach_node(struct device_node *);
 extern void of_detach_node(struct device_node *);
 #endif
 
+#else
+
+static inline int of_have_populated_dt(void)
+{
+	return 0;
+}
+
 #endif /* CONFIG_OF */
 #endif /* _LINUX_OF_H */
-- 
1.7.3.2

