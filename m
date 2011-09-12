Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab1ILQsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:48:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42725 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab1ILQr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:47:58 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 07/10] hwspinlock/core: register a bank of hwspinlocks in a single API call
Date: Mon, 12 Sep 2011 19:47:02 +0300
Message-Id: <1315846025-11453-8-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315846025-11453-1-git-send-email-ohad@wizery.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware Spinlock devices usually contain numerous locks (known
devices today support between 32 to 256 locks).

Originally hwspinlock core required drivers to register (and later,
when needed, unregister) each lock separately.

That worked, but required hwspinlocks drivers to do a bit extra work
when they were probed/removed.

This patch changes hwspin_lock_{un}register() to allow a bank of
hwspinlocks to be {un}registered in a single invocation.

A new 'struct hwspinlock_device', which contains an array of 'struct
hwspinlock's is now being passed to the core upon registration (so
instead of wrapping each struct hwspinlock, a priv member has been added
to allow drivers to piggyback their private data with each hwspinlock).

While at it, several per-lock members were moved to be per-device:
1. struct device *dev
2. struct hwspinlock_ops *ops

In addition, now that the array of locks is handled by the core,
there's no reason to maintain a per-lock 'int id' member: the id of the
lock anyway equals to its index in the bank's array plus the bank's
base_id.
Remove this per-lock id member too, and instead use a simple pointers
arithmetic to derive it.

As a result of this change, hwspinlocks drivers are now simpler and smaller
(about %20 code reduction) and the memory footprint of the hwspinlock
framework is reduced.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 Documentation/hwspinlock.txt             |   58 +++++++----
 drivers/hwspinlock/hwspinlock_core.c     |  165 ++++++++++++++++++++----------
 drivers/hwspinlock/hwspinlock_internal.h |   38 +++++--
 drivers/hwspinlock/omap_hwspinlock.c     |   86 +++++----------
 include/linux/hwspinlock.h               |    8 +-
 5 files changed, 211 insertions(+), 144 deletions(-)

diff --git a/Documentation/hwspinlock.txt b/Documentation/hwspinlock.txt
index 9171f91..a903ee5 100644
--- a/Documentation/hwspinlock.txt
+++ b/Documentation/hwspinlock.txt
@@ -227,42 +227,62 @@ int hwspinlock_example2(void)
 
 4. API for implementors
 
-  int hwspin_lock_register(struct hwspinlock *hwlock);
+  int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
+		const struct hwspinlock_ops *ops, int base_id, int num_locks);
    - to be called from the underlying platform-specific implementation, in
-     order to register a new hwspinlock instance. Should be called from
-     a process context (this function might sleep).
+     order to register a new hwspinlock device (which is usually a bank of
+     numerous locks). Should be called from a process context (this function
+     might sleep).
      Returns 0 on success, or appropriate error code on failure.
 
-  struct hwspinlock *hwspin_lock_unregister(unsigned int id);
+  int hwspin_lock_unregister(struct hwspinlock_device *bank);
    - to be called from the underlying vendor-specific implementation, in order
-     to unregister an existing (and unused) hwspinlock instance.
+     to unregister an hwspinlock device (which is usually a bank of numerous
+     locks).
      Should be called from a process context (this function might sleep).
      Returns the address of hwspinlock on success, or NULL on error (e.g.
      if the hwspinlock is sill in use).
 
-5. struct hwspinlock
+5. Important structs
 
-This struct represents an hwspinlock instance. It is registered by the
-underlying hwspinlock implementation using the hwspin_lock_register() API.
+struct hwspinlock_device is a device which usually contains a bank
+of hardware locks. It is registered by the underlying hwspinlock
+implementation using the hwspin_lock_register() API.
 
 /**
- * struct hwspinlock - vendor-specific hwspinlock implementation
- *
- * @dev: underlying device, will be used with runtime PM api
- * @ops: vendor-specific hwspinlock handlers
- * @id: a global, unique, system-wide, index of the lock.
- * @lock: initialized and used by hwspinlock core
+ * struct hwspinlock_device - a device which usually spans numerous hwspinlocks
+ * @dev: underlying device, will be used to invoke runtime PM api
+ * @ops: platform-specific hwspinlock handlers
+ * @base_id: id index of the first lock in this device
+ * @num_locks: number of locks in this device
+ * @lock: dynamically allocated array of 'struct hwspinlock'
  */
-struct hwspinlock {
+struct hwspinlock_device {
 	struct device *dev;
 	const struct hwspinlock_ops *ops;
-	int id;
+	int base_id;
+	int num_locks;
+	struct hwspinlock lock[0];
+};
+
+struct hwspinlock_device contains an array of hwspinlock structs, each
+of which represents a single hardware lock:
+
+/**
+ * struct hwspinlock - this struct represents a single hwspinlock instance
+ * @bank: the hwspinlock_device structure which owns this lock
+ * @lock: initialized and used by hwspinlock core
+ * @priv: private data, owned by the underlying platform-specific hwspinlock drv
+ */
+struct hwspinlock {
+	struct hwspinlock_device *bank;
 	spinlock_t lock;
+	void *priv;
 };
 
-The underlying implementation is responsible to assign the dev, ops and id
-members. The lock member, OTOH, is initialized and used by the hwspinlock
-core.
+When registering a bank of locks, the hwspinlock driver only needs to
+set the priv members of the locks. The rest of the members are set and
+initialized by the hwspinlock core itself.
 
 6. Implementation callbacks
 
diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 0d20b82..61c9cf1 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -117,7 +117,7 @@ int __hwspin_trylock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
 		return -EBUSY;
 
 	/* try to take the hwspinlock device */
-	ret = hwlock->ops->trylock(hwlock);
+	ret = hwlock->bank->ops->trylock(hwlock);
 
 	/* if hwlock is already taken, undo spin_trylock_* and exit */
 	if (!ret) {
@@ -199,8 +199,8 @@ int __hwspin_lock_timeout(struct hwspinlock *hwlock, unsigned int to,
 		 * Allow platform-specific relax handlers to prevent
 		 * hogging the interconnect (no sleeping, though)
 		 */
-		if (hwlock->ops->relax)
-			hwlock->ops->relax(hwlock);
+		if (hwlock->bank->ops->relax)
+			hwlock->bank->ops->relax(hwlock);
 	}
 
 	return ret;
@@ -245,7 +245,7 @@ void __hwspin_unlock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
 	 */
 	mb();
 
-	hwlock->ops->unlock(hwlock);
+	hwlock->bank->ops->unlock(hwlock);
 
 	/* Undo the spin_trylock{_irq, _irqsave} called while locking */
 	if (mode == HWLOCK_IRQSTATE)
@@ -257,63 +257,32 @@ void __hwspin_unlock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
 }
 EXPORT_SYMBOL_GPL(__hwspin_unlock);
 
-/**
- * hwspin_lock_register() - register a new hw spinlock
- * @hwlock: hwspinlock to register.
- *
- * This function should be called from the underlying platform-specific
- * implementation, to register a new hwspinlock instance.
- *
- * Should be called from a process context (might sleep)
- *
- * Returns 0 on success, or an appropriate error code on failure
- */
-int hwspin_lock_register(struct hwspinlock *hwlock)
+static int hwspin_lock_register_single(struct hwspinlock *hwlock, int id)
 {
 	struct hwspinlock *tmp;
 	int ret;
 
-	if (!hwlock || !hwlock->ops ||
-		!hwlock->ops->trylock || !hwlock->ops->unlock) {
-		pr_err("invalid parameters\n");
-		return -EINVAL;
-	}
-
-	spin_lock_init(&hwlock->lock);
-
 	mutex_lock(&hwspinlock_tree_lock);
 
-	ret = radix_tree_insert(&hwspinlock_tree, hwlock->id, hwlock);
-	if (ret == -EEXIST)
-		pr_err("hwspinlock id %d already exists!\n", hwlock->id);
-	if (ret)
+	ret = radix_tree_insert(&hwspinlock_tree, id, hwlock);
+	if (ret) {
+		if (ret == -EEXIST)
+			pr_err("hwspinlock id %d already exists!\n", id);
 		goto out;
+	}
 
 	/* mark this hwspinlock as available */
-	tmp = radix_tree_tag_set(&hwspinlock_tree, hwlock->id,
-							HWSPINLOCK_UNUSED);
+	tmp = radix_tree_tag_set(&hwspinlock_tree, id, HWSPINLOCK_UNUSED);
 
 	/* self-sanity check which should never fail */
 	WARN_ON(tmp != hwlock);
 
 out:
 	mutex_unlock(&hwspinlock_tree_lock);
-	return ret;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(hwspin_lock_register);
 
-/**
- * hwspin_lock_unregister() - unregister an hw spinlock
- * @id: index of the specific hwspinlock to unregister
- *
- * This function should be called from the underlying platform-specific
- * implementation, to unregister an existing (and unused) hwspinlock.
- *
- * Should be called from a process context (might sleep)
- *
- * Returns the address of hwspinlock @id on success, or NULL on failure
- */
-struct hwspinlock *hwspin_lock_unregister(unsigned int id)
+static struct hwspinlock *hwspin_lock_unregister_single(unsigned int id)
 {
 	struct hwspinlock *hwlock = NULL;
 	int ret;
@@ -337,6 +306,88 @@ out:
 	mutex_unlock(&hwspinlock_tree_lock);
 	return hwlock;
 }
+
+/**
+ * hwspin_lock_register() - register a new hw spinlock device
+ * @bank: the hwspinlock device, which usually provides numerous hw locks
+ * @dev: the backing device
+ * @ops: hwspinlock handlers for this device
+ * @base_id: id of the first hardware spinlock in this bank
+ * @num_locks: number of hwspinlocks provided by this device
+ *
+ * This function should be called from the underlying platform-specific
+ * implementation, to register a new hwspinlock device instance.
+ *
+ * Should be called from a process context (might sleep)
+ *
+ * Returns 0 on success, or an appropriate error code on failure
+ */
+int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
+		const struct hwspinlock_ops *ops, int base_id, int num_locks)
+{
+	struct hwspinlock *hwlock;
+	int ret = 0, i;
+
+	if (!bank || !ops || !dev || !num_locks || !ops->trylock ||
+							!ops->unlock) {
+		pr_err("invalid parameters\n");
+		return -EINVAL;
+	}
+
+	bank->dev = dev;
+	bank->ops = ops;
+	bank->base_id = base_id;
+	bank->num_locks = num_locks;
+
+	for (i = 0; i < num_locks; i++) {
+		hwlock = &bank->lock[i];
+
+		spin_lock_init(&hwlock->lock);
+		hwlock->bank = bank;
+
+		ret = hwspin_lock_register_single(hwlock, i);
+		if (ret)
+			goto reg_failed;
+	}
+
+	return 0;
+
+reg_failed:
+	while (--i >= 0)
+		hwspin_lock_unregister_single(i);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hwspin_lock_register);
+
+/**
+ * hwspin_lock_unregister() - unregister an hw spinlock device
+ * @bank: the hwspinlock device, which usually provides numerous hw locks
+ *
+ * This function should be called from the underlying platform-specific
+ * implementation, to unregister an existing (and unused) hwspinlock.
+ *
+ * Should be called from a process context (might sleep)
+ *
+ * Returns 0 on success, or an appropriate error code on failure
+ */
+int hwspin_lock_unregister(struct hwspinlock_device *bank)
+{
+	struct hwspinlock *hwlock, *tmp;
+	int i;
+
+	for (i = 0; i < bank->num_locks; i++) {
+		hwlock = &bank->lock[i];
+
+		tmp = hwspin_lock_unregister_single(bank->base_id + i);
+		if (!tmp)
+			return -EBUSY;
+
+		/* self-sanity check that should never fail */
+		WARN_ON(tmp != hwlock);
+	}
+
+	return 0;
+}
 EXPORT_SYMBOL_GPL(hwspin_lock_unregister);
 
 /**
@@ -351,24 +402,25 @@ EXPORT_SYMBOL_GPL(hwspin_lock_unregister);
  */
 static int __hwspin_lock_request(struct hwspinlock *hwlock)
 {
+	struct device *dev = hwlock->bank->dev;
 	struct hwspinlock *tmp;
 	int ret;
 
 	/* prevent underlying implementation from being removed */
-	if (!try_module_get(hwlock->dev->driver->owner)) {
-		dev_err(hwlock->dev, "%s: can't get owner\n", __func__);
+	if (!try_module_get(dev->driver->owner)) {
+		dev_err(dev, "%s: can't get owner\n", __func__);
 		return -EINVAL;
 	}
 
 	/* notify PM core that power is now needed */
-	ret = pm_runtime_get_sync(hwlock->dev);
+	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
-		dev_err(hwlock->dev, "%s: can't power on device\n", __func__);
+		dev_err(dev, "%s: can't power on device\n", __func__);
 		return ret;
 	}
 
 	/* mark hwspinlock as used, should not fail */
-	tmp = radix_tree_tag_clear(&hwspinlock_tree, hwlock->id,
+	tmp = radix_tree_tag_clear(&hwspinlock_tree, hwlock_to_id(hwlock),
 							HWSPINLOCK_UNUSED);
 
 	/* self-sanity check that should never fail */
@@ -390,7 +442,7 @@ int hwspin_lock_get_id(struct hwspinlock *hwlock)
 		return -EINVAL;
 	}
 
-	return hwlock->id;
+	return hwlock_to_id(hwlock);
 }
 EXPORT_SYMBOL_GPL(hwspin_lock_get_id);
 
@@ -465,7 +517,7 @@ struct hwspinlock *hwspin_lock_request_specific(unsigned int id)
 	}
 
 	/* sanity check (this shouldn't happen) */
-	WARN_ON(hwlock->id != id);
+	WARN_ON(hwlock_to_id(hwlock) != id);
 
 	/* make sure this hwspinlock is unused */
 	ret = radix_tree_tag_get(&hwspinlock_tree, id, HWSPINLOCK_UNUSED);
@@ -500,6 +552,7 @@ EXPORT_SYMBOL_GPL(hwspin_lock_request_specific);
  */
 int hwspin_lock_free(struct hwspinlock *hwlock)
 {
+	struct device *dev = hwlock->bank->dev;
 	struct hwspinlock *tmp;
 	int ret;
 
@@ -511,28 +564,28 @@ int hwspin_lock_free(struct hwspinlock *hwlock)
 	mutex_lock(&hwspinlock_tree_lock);
 
 	/* make sure the hwspinlock is used */
-	ret = radix_tree_tag_get(&hwspinlock_tree, hwlock->id,
+	ret = radix_tree_tag_get(&hwspinlock_tree, hwlock_to_id(hwlock),
 							HWSPINLOCK_UNUSED);
 	if (ret == 1) {
-		dev_err(hwlock->dev, "%s: hwlock is already free\n", __func__);
+		dev_err(dev, "%s: hwlock is already free\n", __func__);
 		dump_stack();
 		ret = -EINVAL;
 		goto out;
 	}
 
 	/* notify the underlying device that power is not needed */
-	ret = pm_runtime_put(hwlock->dev);
+	ret = pm_runtime_put(dev);
 	if (ret < 0)
 		goto out;
 
 	/* mark this hwspinlock as available */
-	tmp = radix_tree_tag_set(&hwspinlock_tree, hwlock->id,
+	tmp = radix_tree_tag_set(&hwspinlock_tree, hwlock_to_id(hwlock),
 							HWSPINLOCK_UNUSED);
 
 	/* sanity check (this shouldn't happen) */
 	WARN_ON(tmp != hwlock);
 
-	module_put(hwlock->dev->driver->owner);
+	module_put(dev->driver->owner);
 
 out:
 	mutex_unlock(&hwspinlock_tree_lock);
diff --git a/drivers/hwspinlock/hwspinlock_internal.h b/drivers/hwspinlock/hwspinlock_internal.h
index fb25830..d26f78b 100644
--- a/drivers/hwspinlock/hwspinlock_internal.h
+++ b/drivers/hwspinlock/hwspinlock_internal.h
@@ -21,6 +21,8 @@
 #include <linux/spinlock.h>
 #include <linux/device.h>
 
+struct hwspinlock_device;
+
 /**
  * struct hwspinlock_ops - platform-specific hwspinlock handlers
  *
@@ -39,21 +41,37 @@ struct hwspinlock_ops {
 
 /**
  * struct hwspinlock - this struct represents a single hwspinlock instance
- *
- * @dev: underlying device, will be used to invoke runtime PM api
- * @ops: platform-specific hwspinlock handlers
- * @id: a global, unique, system-wide, index of the lock.
+ * @bank: the hwspinlock_device structure which owns this lock
  * @lock: initialized and used by hwspinlock core
- *
- * Note: currently simplicity was opted for, but later we can squeeze some
- * memory bytes by grouping dev, ops in a single
- * per-platform struct, and have all hwspinlocks point at it.
+ * @priv: private data, owned by the underlying platform-specific hwspinlock drv
  */
 struct hwspinlock {
+	struct hwspinlock_device *bank;
+	spinlock_t lock;
+	void *priv;
+};
+
+/**
+ * struct hwspinlock_device - a device which usually spans numerous hwspinlocks
+ * @dev: underlying device, will be used to invoke runtime PM api
+ * @ops: platform-specific hwspinlock handlers
+ * @base_id: id index of the first lock in this device
+ * @num_locks: number of locks in this device
+ * @lock: dynamically allocated array of 'struct hwspinlock'
+ */
+struct hwspinlock_device {
 	struct device *dev;
 	const struct hwspinlock_ops *ops;
-	int id;
-	spinlock_t lock;
+	int base_id;
+	int num_locks;
+	struct hwspinlock lock[0];
 };
 
+static inline int hwlock_to_id(struct hwspinlock *hwlock)
+{
+	int local_id = hwlock - &hwlock->bank->lock[0];
+
+	return hwlock->bank->base_id + local_id;
+}
+
 #endif /* __HWSPINLOCK_HWSPINLOCK_H */
diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/omap_hwspinlock.c
index 2044d18..aec3006 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -41,34 +41,20 @@
 #define SPINLOCK_NOTTAKEN		(0)	/* free */
 #define SPINLOCK_TAKEN			(1)	/* locked */
 
-#define to_omap_hwspinlock(lock)	\
-	container_of(lock, struct omap_hwspinlock, lock)
-
-struct omap_hwspinlock {
-	struct hwspinlock lock;
-	void __iomem *addr;
-};
-
-struct omap_hwspinlock_state {
-	int num_locks;			/* Total number of locks in system */
-	void __iomem *io_base;		/* Mapped base address */
-	struct omap_hwspinlock lock[0];	/* Array of 'num_locks' locks */
-};
-
 static int omap_hwspinlock_trylock(struct hwspinlock *lock)
 {
-	struct omap_hwspinlock *omap_lock = to_omap_hwspinlock(lock);
+	void __iomem *lock_addr = lock->priv;
 
 	/* attempt to acquire the lock by reading its value */
-	return (SPINLOCK_NOTTAKEN == readl(omap_lock->addr));
+	return (SPINLOCK_NOTTAKEN == readl(lock_addr));
 }
 
 static void omap_hwspinlock_unlock(struct hwspinlock *lock)
 {
-	struct omap_hwspinlock *omap_lock = to_omap_hwspinlock(lock);
+	void __iomem *lock_addr = lock->priv;
 
 	/* release the lock by writing 0 to it */
-	writel(SPINLOCK_NOTTAKEN, omap_lock->addr);
+	writel(SPINLOCK_NOTTAKEN, lock_addr);
 }
 
 /*
@@ -95,11 +81,11 @@ static const struct hwspinlock_ops omap_hwspinlock_ops = {
 static int __devinit omap_hwspinlock_probe(struct platform_device *pdev)
 {
 	struct hwspinlock_pdata *pdata = pdev->dev.platform_data;
-	struct omap_hwspinlock *omap_lock;
-	struct omap_hwspinlock_state *state;
+	struct hwspinlock_device *bank;
+	struct hwspinlock *hwlock;
 	struct resource *res;
 	void __iomem *io_base;
-	int i, ret;
+	int num_locks, i, ret;
 
 	if (!pdata)
 		return -ENODEV;
@@ -122,18 +108,18 @@ static int __devinit omap_hwspinlock_probe(struct platform_device *pdev)
 		goto iounmap_base;
 	}
 
-	i *= 32; /* actual number of locks in this device */
+	num_locks = i * 32; /* actual number of locks in this device */
 
-	state = kzalloc(sizeof(*state) + i * sizeof(*omap_lock), GFP_KERNEL);
-	if (!state) {
+	bank = kzalloc(sizeof(*bank) + num_locks * sizeof(*hwlock), GFP_KERNEL);
+	if (!bank) {
 		ret = -ENOMEM;
 		goto iounmap_base;
 	}
 
-	state->num_locks = i;
-	state->io_base = io_base;
+	platform_set_drvdata(pdev, bank);
 
-	platform_set_drvdata(pdev, state);
+	for (i = 0, hwlock = &bank->lock[0]; i < num_locks; i++, hwlock++)
+		hwlock->priv = io_base + LOCK_BASE_OFFSET + sizeof(u32) * i;
 
 	/*
 	 * runtime PM will make sure the clock of this module is
@@ -141,26 +127,16 @@ static int __devinit omap_hwspinlock_probe(struct platform_device *pdev)
 	 */
 	pm_runtime_enable(&pdev->dev);
 
-	for (i = 0; i < state->num_locks; i++) {
-		omap_lock = &state->lock[i];
-
-		omap_lock->lock.dev = &pdev->dev;
-		omap_lock->lock.id = pdata->base_id + i;
-		omap_lock->lock.ops = &omap_hwspinlock_ops;
-		omap_lock->addr = io_base + LOCK_BASE_OFFSET + sizeof(u32) * i;
-
-		ret = hwspin_lock_register(&omap_lock->lock);
-		if (ret)
-			goto free_locks;
-	}
+	ret = hwspin_lock_register(bank, &pdev->dev, &omap_hwspinlock_ops,
+						pdata->base_id, num_locks);
+	if (ret)
+		goto reg_fail;
 
 	return 0;
 
-free_locks:
-	while (--i >= 0)
-		hwspin_lock_unregister(i);
+reg_fail:
 	pm_runtime_disable(&pdev->dev);
-	kfree(state);
+	kfree(bank);
 iounmap_base:
 	iounmap(io_base);
 	return ret;
@@ -168,23 +144,19 @@ iounmap_base:
 
 static int omap_hwspinlock_remove(struct platform_device *pdev)
 {
-	struct omap_hwspinlock_state *state = platform_get_drvdata(pdev);
-	struct hwspinlock *lock;
-	int i;
-
-	for (i = 0; i < state->num_locks; i++) {
-		lock = hwspin_lock_unregister(i);
-		/* this shouldn't happen at this point. if it does, at least
-		 * don't continue with the remove */
-		if (!lock) {
-			dev_err(&pdev->dev, "%s: failed on %d\n", __func__, i);
-			return -EBUSY;
-		}
+	struct hwspinlock_device *bank = platform_get_drvdata(pdev);
+	void __iomem *io_base = bank->lock[0].priv - LOCK_BASE_OFFSET;
+	int ret;
+
+	ret = hwspin_lock_unregister(bank);
+	if (ret) {
+		dev_err(&pdev->dev, "%s failed: %d\n", __func__, ret);
+		return ret;
 	}
 
 	pm_runtime_disable(&pdev->dev);
-	iounmap(state->io_base);
-	kfree(state);
+	iounmap(io_base);
+	kfree(bank);
 
 	return 0;
 }
diff --git a/include/linux/hwspinlock.h b/include/linux/hwspinlock.h
index c246522..08a2fee 100644
--- a/include/linux/hwspinlock.h
+++ b/include/linux/hwspinlock.h
@@ -20,12 +20,15 @@
 
 #include <linux/err.h>
 #include <linux/sched.h>
+#include <linux/device.h>
 
 /* hwspinlock mode argument */
 #define HWLOCK_IRQSTATE	0x01	/* Disable interrupts, save state */
 #define HWLOCK_IRQ	0x02	/* Disable interrupts, don't save state */
 
 struct hwspinlock;
+struct hwspinlock_device;
+struct hwspinlock_ops;
 
 /**
  * struct hwspinlock_pdata - platform data for hwspinlock drivers
@@ -57,8 +60,9 @@ struct hwspinlock_pdata {
 
 #if defined(CONFIG_HWSPINLOCK) || defined(CONFIG_HWSPINLOCK_MODULE)
 
-int hwspin_lock_register(struct hwspinlock *lock);
-struct hwspinlock *hwspin_lock_unregister(unsigned int id);
+int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
+		const struct hwspinlock_ops *ops, int base_id, int num_locks);
+int hwspin_lock_unregister(struct hwspinlock_device *bank);
 struct hwspinlock *hwspin_lock_request(void);
 struct hwspinlock *hwspin_lock_request_specific(unsigned int id);
 int hwspin_lock_free(struct hwspinlock *hwlock);
-- 
1.7.4.1

