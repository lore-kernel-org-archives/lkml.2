Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab2LLU1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 15:27:17 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42110 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab2LLU1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 15:27:16 -0500
From: Ido Yariv <ido@wizery.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH] hwspinlock/core: Add testing capabilities
Date: Wed, 12 Dec 2012 22:27:06 +0200
Message-Id: <1355344026-17222-1-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add testing capabilities for verifying correctness of the underlying
hwspinlock layers. This can be handy especially during development.
These tests are performed only once as part of the hwspinlock
registration.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/hwspinlock/Kconfig           |    9 +++++
 drivers/hwspinlock/hwspinlock_core.c |   54 ++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/drivers/hwspinlock/Kconfig b/drivers/hwspinlock/Kconfig
index c7c3128..ad632cd 100644
--- a/drivers/hwspinlock/Kconfig
+++ b/drivers/hwspinlock/Kconfig
@@ -8,6 +8,15 @@ config HWSPINLOCK
 
 menu "Hardware Spinlock drivers"
 
+config HWSPINLOCK_TEST
+	bool "Verify underlying hwspinlock implementation"
+	depends on HWSPINLOCK
+	help
+	  Say Y here to perform tests on the underlying hwspinlock
+	  implementation. The tests are only performed once per implementation.
+
+	  Say N, unless you absolutely know what you are doing.
+
 config HWSPINLOCK_OMAP
 	tristate "OMAP Hardware Spinlock device"
 	depends on ARCH_OMAP4
diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 085e28e..1874e85 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -307,6 +307,53 @@ out:
 	return hwlock;
 }
 
+#ifdef CONFIG_HWSPINLOCK_TEST
+#define NUM_OF_TEST_ITERATIONS 100
+static int hwspin_lock_tests(const struct hwspinlock_ops *ops,
+			     struct hwspinlock *hwlock)
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < NUM_OF_TEST_ITERATIONS; i++) {
+		ret = ops->trylock(hwlock);
+		if (!ret) {
+			pr_err("%s: Initial lock failed\n", __func__);
+			return -EFAULT;
+		}
+
+		/* Verify lock actually works - re-acquiring it should fail */
+		ret = ops->trylock(hwlock);
+		if (ret) {
+			/* Keep locks balanced even in failure cases */
+			ops->unlock(hwlock);
+			ops->unlock(hwlock);
+			pr_err("%s: Recursive lock succeeded unexpectedly\n",
+			       __func__);
+			return -EFAULT;
+		}
+
+		/* Verify unlock by re-acquiring the lock after releasing it */
+		ops->unlock(hwlock);
+		ret = ops->trylock(hwlock);
+		if (!ret) {
+			pr_err("%s: Unlock failed\n", __func__);
+			return -EINVAL;
+		}
+
+		ops->unlock(hwlock);
+	}
+
+	return 0;
+}
+#else /* CONFIG_HWSPINLOCK_TEST*/
+static int hwspin_lock_tests(const struct hwspinlock_ops *ops,
+			     struct hwspinlock *hwlock)
+{
+	return 0;
+}
+#endif
+
 /**
  * hwspin_lock_register() - register a new hw spinlock device
  * @bank: the hwspinlock device, which usually provides numerous hw locks
@@ -345,6 +392,13 @@ int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
 		spin_lock_init(&hwlock->lock);
 		hwlock->bank = bank;
 
+		ret = hwspin_lock_tests(ops, hwlock);
+		if (ret) {
+			pr_err("hwspinlock tests failed on lock %d\n",
+			       base_id + i);
+			goto reg_failed;
+		}
+
 		ret = hwspin_lock_register_single(hwlock, base_id + i);
 		if (ret)
 			goto reg_failed;
-- 
1.7.7.6

