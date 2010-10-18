Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0JRHuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 03:50:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37861 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0JRHu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 03:50:29 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>, "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
Date: Mon, 18 Oct 2010 09:44:33 +0200
Message-Id: <1287387875-14168-2-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287387875-14168-1-git-send-email-ohad@wizery.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Que <sque@ti.com>

Add driver for OMAP's Hardware Spinlock module.

The OMAP Hardware Spinlock module, initially introduced in OMAP4,
provides hardware assistance for synchronization between the
multiple processors in the device (Cortex-A9, Cortex-M3 and
C64x+ DSP).

Signed-off-by: Simon Que <sque@ti.com>
Signed-off-by: Hari Kanigeri <h-kanigeri2@ti.com>
Signed-off-by: Krishnamoorthy, Balaji T <balajitk@ti.com>
[ohad@wizery.com: disable interrupts/preemption to prevent hw abuse]
[ohad@wizery.com: add memory barriers to prevent memory reordering issues]
[ohad@wizery.com: relax omap interconnect between subsequent lock attempts]
[ohad@wizery.com: timeout param to use jiffies instead of number of attempts]
[ohad@wizery.com: remove code duplication in lock, trylock, lock_timeout]
[ohad@wizery.com: runtime pm usage count to reflect num of requested locks]
[ohad@wizery.com: move to drivers/misc, general cleanups, document]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 Documentation/misc-devices/omap_hwspinlock.txt |  199 +++++++++
 drivers/misc/Kconfig                           |   10 +
 drivers/misc/Makefile                          |    1 +
 drivers/misc/omap_hwspinlock.c                 |  555 ++++++++++++++++++++++++
 include/linux/omap_hwspinlock.h                |  108 +++++
 5 files changed, 873 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/omap_hwspinlock.txt
 create mode 100644 drivers/misc/omap_hwspinlock.c
 create mode 100644 include/linux/omap_hwspinlock.h

diff --git a/Documentation/misc-devices/omap_hwspinlock.txt b/Documentation/misc-devices/omap_hwspinlock.txt
new file mode 100644
index 0000000..b093347
--- /dev/null
+++ b/Documentation/misc-devices/omap_hwspinlock.txt
@@ -0,0 +1,199 @@
+OMAP Hardware Spinlocks
+
+1. Introduction
+
+Hardware spinlock modules provide hardware assistance for synchronization
+and mutual exclusion between heterogeneous processors and those not operating
+under a single, shared operating system.
+
+For example, OMAP4 has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP,
+each of which is running a different Operating System (the master, A9,
+is usually running Linux and the slave processors, the M3 and the DSP,
+are running some flavor of RTOS).
+
+A hwspinlock driver allows kernel code to access data structures (or hardware
+resources) that are shared with any of the existing remote processors, with
+which there is no alternative mechanism to accomplish synchronization and
+mutual exclusion operations.
+
+This is necessary, for example, for Inter-processor communications:
+on OMAP4, cpu-intensive multimedia tasks are offloaded by the host to the
+remote M3 and/or C64x+ slave processors (by an IPC subsystem called Syslink).
+
+To achieve fast message-based communications, a minimal kernel support
+is needed to deliver messages arriving from a remote processor to the
+appropriate user process.
+
+This communication is based on simple data structures that are shared between
+the remote processors, and access to them is synchronized using the hwspinlock
+module (remote processor directly places new messages in this shared data
+structure).
+
+2. User API
+
+  struct omap_hwspinlock *omap_hwspinlock_request(void);
+   - dynamically assign an hwspinlock and return its address, or
+     ERR_PTR(-EBUSY) if an unused hwspinlock isn't available. Users of this
+     API will usually want to communicate the lock's id to the remote core
+     before it can be used to achieve synchronization (to get the id of the
+     lock, use omap_hwspinlock_get_id()).
+     Can be called from an atomic context (this function will not sleep) but
+     not from within interrupt context.
+
+  struct omap_hwspinlock *omap_hwspinlock_request_specific(unsigned int id);
+   - assign a specific hwspinlock id and return its address, or
+     ERR_PTR(-EBUSY) if that hwspinlock is already in use. Usually board code
+     will be calling this function in order to reserve specific hwspinlock
+     ids for predefined purposes.
+     Can be called from an atomic context (this function will not sleep) but
+     not from within interrupt context.
+
+  int omap_hwspinlock_free(struct omap_hwspinlock *hwlock);
+   - free a previously-assigned hwspinlock; returns 0 on success, or an
+     appropriate error code on failure (e.g. -EINVAL if the hwspinlock
+     was not assigned).
+     Can be called from an atomic context (this function will not sleep) but
+     not from within interrupt context.
+
+  int omap_hwspin_lock(struct omap_hwspinlock *hwlock, unsigned long *flags);
+   - lock a previously assigned hwspinlock. If the hwspinlock is already
+     taken, the function will busy loop waiting for it to be released.
+     Note: if a faulty remote core never releases this lock, this function
+     will deadlock.
+     This function will fail if hwlock is invalid, but otherwise it will
+     always succeed (or deadlock; see above) and will never sleep. It is safe
+     to call it from any context.
+     Upon a successful return from this function, interrupts and preemption
+     are disabled so the caller must not sleep, and is advised to release the
+     hwspinlock as soon as possible, in order to minimize remote cores polling
+     on the hardware interconnect.
+     The flags parameter is a pointer to where the interrupts state of the
+     caller will be saved at.
+
+  int omap_hwspin_lock_timeout(struct omap_hwspinlock *hwlock,
+				unsigned long timeout, unsigned long *flags);
+   - lock a previously-assigned hwspinlock with a timeout limit (specified in
+     jiffies). If the hwspinlock is already taken, the function will busy loop
+     waiting for it to be released, but give up when the timeout meets jiffies.
+     If timeout is 0, the function will never give up (therefore if a faulty
+     remote core never releases the hwspinlock, it will deadlock).
+     Upon a successful return from this function, interrupts and preemption
+     are disabled so the caller must not sleep, and is advised to release the
+     hwspinlock as soon as possible, in order to minimize remote cores polling
+     on the hardware interconnect.
+     This function can be called from any context (it will never sleep). It
+     returns 0 when successful and an appropriate error code otherwise (most
+     notably -ETIMEDOUT if the hwspinlock is still busy after timeout meets
+     jiffies).
+     The flags parameter is a pointer to where the interrupts state of the
+     caller will be saved at.
+
+  int
+  omap_hwspin_trylock(struct omap_hwspinlock *hwlock, unsigned long *flags);
+   - attempt to lock a previously-assigned hwspinlock, but immediately fail if
+     it is already taken.
+     Upon a successful return from this function, interrupts and preemption
+     are disabled so the caller must not sleep, and is advised to release the
+     hwspinlock as soon as possible, in order to minimize remote cores polling
+     on the hardware interconnect.
+     This function can be called from any context (it will never sleep). It
+     returns 0 when successful and an appropriate error code otherwise (most
+     notably -EBUSY if the hwspinlock was already taken when it was called).
+     The flags parameter is a pointer to where the interrupts state of the
+     caller will be saved at.
+
+  int
+  omap_hwspin_unlock(struct omap_hwspinlock *hwlock, unsigned long *flags);
+   - unlock a previously-locked hwspinlock. Always succeed, and can be called
+     from any context (the function never sleeps). Note: code should _never_
+     unlock an hwspinlock which is already unlocked (there is no protection
+     against this).
+     Upon a successful return from this function, the interrupts state of the
+     caller is restored and preemption is reenabled.
+     This function can be called from any context (it will never sleep). It
+     returns 0 when successful and -EINVAL if hwlock is invalid.
+     The flags parameter points to the caller saved interrupts state.
+
+  int omap_hwspinlock_get_id(struct omap_hwspinlock *hwlock);
+   - returns the id of hwlock, or -EINVAL if hwlock is invalid.
+
+3. Typical usage
+
+#include <linux/omap_hwspinlock.h>
+#include <linux/err.h>
+
+int hwspinlock_example1(void)
+{
+	struct omap_hwspinlock *lock;
+	unsigned long flags;
+	int ret;
+
+	/* dynamically assign a hwspinlock */
+	lock = omap_hwspinlock_request();
+	if (IS_ERR(lock))
+		... handle error ...
+
+	/*
+	 * probably need to communicate the id of the hwspinlock to the
+	 * remote processor which we intend to achieve synchronization
+	 * with. The id of the lock can be obtained by calling
+	 * omap_hwspinlock_get_id(lock)
+	 */
+
+	/* take the lock, spin if it's already taken */
+	ret = omap_hwspin_lock(hwlock, &flags);
+	if (ret)
+		... handle error ...
+
+	/*
+	 * we took the lock, do our thing asap, and do NOT sleep
+	 */
+
+	/* release the lock */
+	ret = omap_hwspin_unlock(hwlock, &flags);
+	if (ret)
+		... handle error ...
+
+	/* free the lock */
+	ret = omap_hwspinlock_free(hwlock);
+	if (ret)
+		... handle error ...
+
+	return ret;
+}
+
+int hwspinlock_example2(void)
+{
+	struct omap_hwspinlock *lock;
+	unsigned long flags;
+	int ret;
+
+	/*
+	 * request a specific hwspinlock id - this should be called by early
+	 * board init code.
+	 */
+	lock = omap_hwspinlock_request_specific(PREDEFINED_LOCK_ID);
+	if (IS_ERR(lock))
+		... handle error ...
+
+	/* try to take it, but don't spin on it */
+	ret = omap_hwspin_trylock(hwlock);
+	if (!ret)
+		... handle error ... /* lock is busy */
+
+	/*
+	 * we took the lock, do our thing asap, but do NOT sleep
+	 */
+
+	/* release the lock */
+	ret = omap_hwspin_unlock(hwlock, &flags);
+	if (ret)
+		... handle error ...
+
+	/* free the lock */
+	ret = omap_hwspinlock_free(hwlock);
+	if (ret)
+		... handle error ...
+
+	return ret;
+}
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b743312..ce4b7a6 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -390,6 +390,16 @@ config BMP085
 	  To compile this driver as a module, choose M here: the
 	  module will be called bmp085.
 
+config OMAP_HWSPINLOCK
+	bool "OMAP Hardware Spinlock module"
+	help
+	  Say Y here to enable OMAP's hardware spinlock module (first
+	  introduced in OMAP4). This module is needed to achieve
+	  synchronization and mutual exclusion between the several
+	  remote processors on the system.
+
+	  If unsure, say N.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 42eab95..a4427ad 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -35,3 +35,4 @@ obj-y				+= eeprom/
 obj-y				+= cb710/
 obj-$(CONFIG_VMWARE_BALLOON)	+= vmw_balloon.o
 obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
+obj-$(CONFIG_OMAP_HWSPINLOCK)	+= omap_hwspinlock.o
diff --git a/drivers/misc/omap_hwspinlock.c b/drivers/misc/omap_hwspinlock.c
new file mode 100644
index 0000000..63dc5a2
--- /dev/null
+++ b/drivers/misc/omap_hwspinlock.c
@@ -0,0 +1,555 @@
+/*
+ * hardware spinlock driver for OMAP
+ *
+ * Copyright (C) 2010 Texas Instruments, Inc.
+ *
+ * Authors: Simon Que <sque@ti.com>
+ *	    Hari Kanigeri <h-kanigeri2@ti.com>
+ *	    Ohad Ben-Cohen <ohad@wizery.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt)	"%s: " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/err.h>
+#include <linux/jiffies.h>
+#include <linux/omap_hwspinlock.h>
+#include <linux/pm_runtime.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/log2.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+
+/* Spinlock register offsets */
+#define SPINLOCK_SYSSTATUS_OFFSET	0x0014
+#define SPINLOCK_BASE_OFFSET		0x0800
+
+#define SPINLOCK_NUMLOCKS_BIT_OFFSET	(24)
+
+/* Possible values of SPINLOCK_LOCK_REG */
+#define SPINLOCK_NOTTAKEN		(0)	/* free */
+#define SPINLOCK_TAKEN			(1)	/* locked */
+
+/**
+ * struct omap_hwspinlock - represents a single hardware spinlock
+ *
+ * @node: linked list member
+ * @id: unique and system-wide index number of this lock
+ * @lock: regular spinlock; we have one for every hwspinlock instance
+ * @addr: mapped address of the register which contains this lock's hw state
+ * @dev: underlying device, will be used to invoke runtime PM api
+ */
+struct omap_hwspinlock {
+	struct list_head node;
+	int id;
+	spinlock_t lock;
+	void __iomem *addr;
+	struct device *dev;
+};
+
+/**
+ * struct omap_hwspinlock_state - represents state of the underlying device
+ *
+ * @io_base: mapped base address of the hwspinlock device
+ * @hwlocks: array of omap_hwspinlocks that belong to this device
+ * @num_locks: number of hwspinlocks provided by this device
+ */
+struct omap_hwspinlock_state {
+	void __iomem *io_base;
+	struct omap_hwspinlock *hwlocks;
+	int num_locks;
+};
+
+/* List for keeping track of free locks */
+static LIST_HEAD(free_hwlocks);
+
+/* Access to the list of free locks is protected by this spinlock */
+static DEFINE_SPINLOCK(free_hwlocks_lock);
+
+/*
+ * "Multiple hwspinlock devices" is still an imaginary scenario,
+ * so maintaining a global state of our device is just fine for now.
+ */
+static struct omap_hwspinlock_state hwspinlock_state;
+
+/**
+ * omap_hwspin_trylock() - attempt to lock a specific hwspinlock
+ * @hwlock: a hwspinlock which we want to trylock
+ * @flags: a pointer to where the caller's interrupt state will be saved at
+ *
+ * This function attempt to lock the underlying hwspinlock. Unlike
+ * hwspinlock_lock, this function will immediately fail if the hwspinlock
+ * is already taken.
+ *
+ * Upon a successful return from this function, preemption and interrupts
+ * are disabled, so the caller must not sleep, and is advised to release
+ * the hwspinlock as soon as possible. This is required in order to minimize
+ * remote cores polling on the hardware interconnect.
+ *
+ * This function can be called from any context.
+ *
+ * Returns 0 if we successfully locked the hwspinlock, -EBUSY if
+ * the hwspinlock was already taken, and -EINVAL if @hwlock is invalid.
+ */
+int omap_hwspin_trylock(struct omap_hwspinlock *hwlock, unsigned long *flags)
+{
+	u32 ret;
+
+	if (IS_ERR_OR_NULL(hwlock)) {
+		pr_err("invalid hwlock\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * This spin_trylock_irqsave serves two purposes:
+	 *
+	 * 1. Disable local interrupts and preemption, in order to
+	 *    minimize the period of time in which the hwspinlock
+	 *    is taken (so caller will not preempted). This is
+	 *    important in order to minimize the possible polling on
+	 *    the hardware interconnect by a remote user of this lock.
+	 *
+	 * 2. Make this hwspinlock primitive SMP-safe (so we can try to
+	 *    take it from additional contexts on the local cpu)
+	 */
+	if (!spin_trylock_irqsave(&hwlock->lock, *flags))
+		return -EBUSY;
+
+	/* attempt to acquire the lock by reading its value */
+	ret = readl(hwlock->addr);
+
+	/* lock is already taken */
+	if (ret == SPINLOCK_TAKEN) {
+		spin_unlock_irqrestore(&hwlock->lock, *flags);
+		return -EBUSY;
+	}
+
+	/*
+	 * We can be sure the other core's memory operations
+	 * are observable to us only _after_ we successfully take
+	 * the hwspinlock, so we must make sure that subsequent memory
+	 * operations will not be reordered before we actually took the
+	 * hwspinlock.
+	 * Note: the implicit memory barrier of the spinlock above is too
+	 * early, so we need this additional explicit memory barrier.
+	 */
+	mb();
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(omap_hwspin_trylock);
+
+/**
+ * omap_hwspin_lock_timeout() - lock a specific hwspinlock with timeout limit
+ * @hwlock: the hwspinlock to be locked
+ * @to: timeout, in jiffies
+ * @flags: a pointer to where the caller's interrupts state will be saved at
+ *
+ * This function locks the underlying @hwlock. If the @hwlock
+ * is already taken, the function will busy loop waiting for it to
+ * be released, but give up when @timeout meets jiffies. If @timeout
+ * is 0, the function will never give up (therefore if a
+ * faulty remote core never releases the @hwlock, it will deadlock).
+ *
+ * Upon a successful return from this function, preemption and interrupts
+ * are disabled, so the caller must not sleep, and is advised to release
+ * the hwspinlock as soon as possible. This is required in order to minimize
+ * remote cores polling on the hardware interconnect.
+ *
+ * This function can be called from any context.
+ *
+ * Returns 0 when the @hwlock was successfully taken, and an appropriate
+ * error code otherwise (most notably an -ETIMEDOUT if the @hwlock is still
+ * busy after @timeout meets jiffies). The function will never sleep.
+ */
+int omap_hwspin_lock_timeout(struct omap_hwspinlock *hwlock, unsigned long to,
+							unsigned long *flags)
+{
+	int ret;
+
+	for (;;) {
+		/* Try to take the hwspinlock */
+		ret = omap_hwspin_trylock(hwlock, flags);
+		if (ret != -EBUSY)
+			break;
+
+		/*
+		 * The lock is already taken, let's check if the user wants
+		 * us to try again
+		 */
+		if (to && time_is_before_eq_jiffies(to))
+			return -ETIMEDOUT;
+
+		/*
+		 * Do not hog the omap interconnect.
+		 *
+		 * It is recommended that the retry delay time will be
+		 * just over half of the time that a requester would be
+		 * expected to hold the lock.
+		 *
+		 * The number below is taken from an hardware specs example,
+		 * obviously it is somewhat arbitrary.
+		 */
+		ndelay(50);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(omap_hwspin_lock_timeout);
+
+/**
+ * omap_hwspinlock_unlock() - unlock a specific hwspinlock
+ * @hwlock: a previously-acquired hwspinlock which we want to unlock
+ * @flags: a pointer to the caller's saved interrupts state
+ *
+ * This function will unlock a specific hwspinlock, enable preemption and
+ * restore the interrupts state. @hwlock must be taken (by us!) before
+ * calling this function: it is a bug to call unlock on a @hwlock that was
+ * not taken by us, i.e. using one of omap_hwspin_{lock trylock, lock_timeout}.
+ *
+ * This function can be called from any context.
+ *
+ * Returns 0 when the @hwlock on success, or -EINVAL if @hwlock is invalid.
+ */
+int omap_hwspin_unlock(struct omap_hwspinlock *hwlock, unsigned long *flags)
+{
+	if (IS_ERR_OR_NULL(hwlock)) {
+		pr_err("invalid hwlock\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * We must make sure that memory operations, done before unlocking
+	 * the hwspinlock, will not be reordered after the lock is released.
+	 * The memory barrier induced by the spin_unlock below is too late:
+	 * the other core is going to access memory soon after it will take
+	 * the hwspinlock, and by then we want to be sure our memory operations
+	 * were already observable.
+	 */
+	mb();
+
+	/* release the lock by writing 0 to it (NOTTAKEN) */
+	writel(SPINLOCK_NOTTAKEN, hwlock->addr);
+
+	/* undo the spin_trylock_irqsave called in the locking function */
+	spin_unlock_irqrestore(&hwlock->lock, *flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(omap_hwspin_unlock);
+
+/**
+ * __omap_hwspinlock_assign() - prepare hwspinlock for assignment
+ * @hwlock: a hwspinlock which we want to assign to the user
+ *
+ * This is an internal function that prepares a specific hwspinlock
+ * for assignment.
+ *
+ * Returns 0 or 1 for success, or an appropriate error code on a failue
+ */
+static int __omap_hwspinlock_assign(struct omap_hwspinlock *hwlock)
+{
+	int ret;
+
+	/* notify the underlying device that power is now needed */
+	ret = pm_runtime_get_sync(hwlock->dev);
+	if (ret < 0) {
+		dev_err(hwlock->dev, "%s: can't power on device\n", __func__);
+		goto out;
+	}
+
+	/* remove the lock from the list of free locks */
+	list_del(&hwlock->node);
+
+	/*
+	 * mark this hwlock as used; needed in case someone will try to request
+	 * this hwlock specifically (using omap_hwspinlock_request_specific)
+	 * while it is already being used
+	 */
+	INIT_LIST_HEAD(&hwlock->node);
+
+out:
+	return ret;
+}
+
+/**
+ * omap_hwspinlock_request() - request a hw spinlock
+ *
+ * This function should be called by users of the hwspinlock module,
+ * in order to dynamically assign them an unused hwspinlock.
+ * Usually the user of this lock will then have to communicate the lock's id
+ * to the remote core before it can be used to synchronize (to get the id
+ * of a given hwlock, use omap_hwspinlock_get_id()).
+ *
+ * Can be called from an atomic context (will not sleep) but not from
+ * within interrupt context (simply because there is no use case for
+ * that yet).
+ *
+ * Returns the address of the assigned hwspinlock, or an appropriate error
+ * code on a failue (such as ERR_PTR(-EBUSY) if an unused hwspinlock wasn't
+ * found)
+ */
+struct omap_hwspinlock *omap_hwspinlock_request(void)
+{
+	struct omap_hwspinlock *hwlock;
+	int ret;
+
+	spin_lock(&free_hwlocks_lock);
+
+	if (list_empty(&free_hwlocks)) {
+		pr_warn("a free hwspinlock is not available\n");
+		hwlock = ERR_PTR(-EBUSY);
+		goto out;
+	}
+
+	hwlock = list_first_entry(&free_hwlocks, struct omap_hwspinlock, node);
+
+	ret = __omap_hwspinlock_assign(hwlock);
+	if (ret < 0)
+		hwlock = ERR_PTR(ret);
+
+out:
+	spin_unlock(&free_hwlocks_lock);
+	return hwlock;
+}
+EXPORT_SYMBOL_GPL(omap_hwspinlock_request);
+
+/**
+ * omap_hwspinlock_request_specific() - request for a specific hwspinlock
+ * @id: index of the specific hwspinlock that is requested
+ *
+ * This function should be called by users of the hwspinlock module,
+ * in order to assign them a specific hwspinlock.
+ * Usually board code will be calling this function in order to
+ * reserve specific hwspinlock ids for predefined purposes.
+ *
+ * Can be called from an atomic context (will not sleep) but not from
+ * within interrupt context (simply because there is no use case for
+ * that yet).
+ *
+ * Returns the address of the assigned lock on success, or appropriate
+ * error codes on failures (should be tested with IS_ERR)
+ */
+struct omap_hwspinlock *omap_hwspinlock_request_specific(unsigned int id)
+{
+	struct omap_hwspinlock *hwlock;
+	int ret;
+
+	if (id >= hwspinlock_state.num_locks) {
+		pr_warn("invalid id requested\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	spin_lock(&free_hwlocks_lock);
+
+	hwlock = &hwspinlock_state.hwlocks[id];
+	if (list_empty(&hwlock->node)) {
+		pr_warn("hwspinlock %d was already assigned\n", id);
+		hwlock = ERR_PTR(-EBUSY);
+		goto out;
+	}
+
+	ret = __omap_hwspinlock_assign(hwlock);
+	if (ret < 0)
+		hwlock = ERR_PTR(ret);
+
+out:
+	spin_unlock(&free_hwlocks_lock);
+	return hwlock;
+}
+EXPORT_SYMBOL_GPL(omap_hwspinlock_request_specific);
+
+/**
+ * omap_hwspinlock_free() - free a specific hwspinlock
+ * @hwlock: the specific hwspinlock to free
+ *
+ * This function returns @hwlock to the list of free hwspinlocks.
+ * Should only be called with an @hwlock that was retrieved from
+ * an earlier call to omap_hwspinlock_request{_specific}.
+ *
+ * Can be called from an atomic context (will not sleep) but not from
+ * within interrupt context (simply because there is no use case for
+ * that yet).
+ *
+ * Returns 0 on success, or an appropriate error code on failure
+ */
+int omap_hwspinlock_free(struct omap_hwspinlock *hwlock)
+{
+	int ret;
+
+	if (IS_ERR_OR_NULL(hwlock)) {
+		pr_err("invalid hwlock\n");
+		return -EINVAL;
+	}
+
+	spin_lock(&free_hwlocks_lock);
+
+	/* make sure hwlock is marked as used */
+	if (!list_empty(&hwlock->node)) {
+		pr_err("hwlock doesn't seem to be used\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	list_add(&hwlock->node, &free_hwlocks);
+
+	/* notify the underlying device that power is not needed */
+	ret = pm_runtime_put(hwlock->dev);
+	if (ret < 0)
+		dev_err(hwlock->dev, "%s: pm_runtime_put failed\n", __func__);
+
+out:
+	spin_unlock(&free_hwlocks_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(omap_hwspinlock_free);
+
+/**
+ * omap_hwspinlock_get_id() - retrieves id number of a given hwspinlock
+ * @hwlock: a valid hwspinlock instance
+ *
+ * Returns id number of a given @hwlock, or -EINVAL if @hwlock is invalid.
+ */
+int omap_hwspinlock_get_id(struct omap_hwspinlock *hwlock)
+{
+	if (IS_ERR_OR_NULL(hwlock)) {
+		pr_err("invalid hwlock\n");
+		return -EINVAL;
+	}
+
+	return hwlock->id;
+}
+EXPORT_SYMBOL_GPL(omap_hwspinlock_get_id);
+
+static int __devinit omap_hwspinlock_probe(struct platform_device *pdev)
+{
+	struct omap_hwspinlock *hwlock, *hwlocks;
+	struct resource *res;
+	void __iomem *io_base;
+	int i, ret, num_locks;
+
+	/* Multiple hwspinlock devices have no meaning, yet */
+	if (hwspinlock_state.hwlocks) {
+		dev_err(&pdev->dev, "unexpected spinlock device\n");
+		return -EBUSY;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	io_base = ioremap(res->start, resource_size(res));
+	if (!io_base)
+		return -ENOMEM;
+
+	/* Determine number of locks */
+	i = readl(io_base + SPINLOCK_SYSSTATUS_OFFSET);
+	i >>= SPINLOCK_NUMLOCKS_BIT_OFFSET;
+
+	/* exactly one of the four least significant bits must be 1 */
+	if (!i || !is_power_of_2(i) || i > 8) {
+		ret = -EINVAL;
+		goto iounmap_base;
+	}
+
+	num_locks = i * 32;
+
+	hwlocks = kzalloc(sizeof(*hwlock) * num_locks, GFP_KERNEL);
+	if (!hwlocks) {
+		ret = -ENOMEM;
+		goto iounmap_base;
+	}
+
+	for (i = 0; i < num_locks; i++) {
+		hwlock = &hwlocks[i];
+
+		spin_lock_init(&hwlock->lock);
+
+		hwlock->id	= i;
+		hwlock->dev	= &pdev->dev;
+		hwlock->addr	= io_base + SPINLOCK_BASE_OFFSET +
+							sizeof(u32) * i;
+
+		/* Add hwlock to the list of free locks */
+		list_add(&hwlock->node, &free_hwlocks);
+	}
+
+	hwspinlock_state.io_base = io_base;
+	hwspinlock_state.hwlocks = hwlocks;
+	hwspinlock_state.num_locks = num_locks;
+
+	/*
+	 * runtime PM will make sure the clock of this module is
+	 * enabled iff at least one lock is requested
+	 */
+	pm_runtime_enable(&pdev->dev);
+
+	pr_info("registered %d hwspinlocks\n", num_locks);
+
+	return 0;
+
+iounmap_base:
+	iounmap(hwspinlock_state.io_base);
+	return ret;
+}
+
+static int omap_hwspinlock_remove(struct platform_device *pdev)
+{
+	pm_runtime_disable(&pdev->dev);
+
+	hwspinlock_state.num_locks = 0;
+	hwspinlock_state.hwlocks = NULL;
+
+	/* clear list of free locks */
+	INIT_LIST_HEAD(&free_hwlocks);
+
+	kfree(hwspinlock_state.hwlocks);
+
+	iounmap(hwspinlock_state.io_base);
+
+	return 0;
+}
+
+static struct platform_driver omap_hwspinlock_driver = {
+	.probe		= omap_hwspinlock_probe,
+	.remove		= omap_hwspinlock_remove,
+	.driver		= {
+		.name	= "omap_hwspinlock",
+	},
+};
+
+static int __init omap_hwspinlock_init(void)
+{
+	return platform_driver_register(&omap_hwspinlock_driver);
+}
+/* early board code might need to reserve specific hwspinlocks */
+postcore_initcall(omap_hwspinlock_init);
+
+static void __exit omap_hwspinlock_exit(void)
+{
+	platform_driver_unregister(&omap_hwspinlock_driver);
+}
+module_exit(omap_hwspinlock_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Hardware spinlock driver for OMAP");
+MODULE_AUTHOR("Simon Que <sque@ti.com>");
+MODULE_AUTHOR("Hari Kanigeri <h-kanigeri2@ti.com>");
+MODULE_AUTHOR("Ohad Ben-Cohen <ohad@wizery.com>");
diff --git a/include/linux/omap_hwspinlock.h b/include/linux/omap_hwspinlock.h
new file mode 100644
index 0000000..8faabb8
--- /dev/null
+++ b/include/linux/omap_hwspinlock.h
@@ -0,0 +1,108 @@
+/*
+ * Copyright (C) 2010 Texas Instruments, Inc.
+ *
+ * Author: Ohad Ben-Cohen <ohad@wizery.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#ifndef __LINUX_OMAP_HWSPINLOCK_H
+#define __LINUX_OMAP_HWSPINLOCK_H
+
+#include <linux/err.h>
+
+struct omap_hwspinlock;
+
+#ifdef CONFIG_OMAP_HWSPINLOCK
+
+struct omap_hwspinlock *omap_hwspinlock_request(void);
+struct omap_hwspinlock *omap_hwspinlock_request_specific(unsigned int id);
+int omap_hwspinlock_free(struct omap_hwspinlock *hwlock);
+int omap_hwspinlock_get_id(struct omap_hwspinlock *hwlock);
+int omap_hwspin_lock_timeout(struct omap_hwspinlock *hwlock, unsigned long to,
+							unsigned long *flags);
+int omap_hwspin_trylock(struct omap_hwspinlock *hwlock, unsigned long *flags);
+int omap_hwspin_unlock(struct omap_hwspinlock *hwlock, unsigned long *flags);
+
+#else /* !CONFIG_OMAP_HWSPINLOCK */
+
+static inline struct omap_hwspinlock *omap_hwspinlock_request(void)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline
+struct omap_hwspinlock *omap_hwspinlock_request_specific(unsigned int id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline int omap_hwspinlock_free(struct omap_hwspinlock *hwlock)
+{
+	return -ENOSYS;
+}
+
+static inline int omap_hwspin_lock_timeout(struct omap_hwspinlock *hwlock,
+							unsigned long timeout)
+{
+	return -ENOSYS;
+}
+
+static inline int omap_hwspin_trylock(struct omap_hwspinlock *hwlock)
+{
+	return -ENOSYS;
+}
+
+static inline int omap_hwspin_unlock(struct omap_hwspinlock *hwlock)
+{
+	return -ENOSYS;
+}
+
+static inline int omap_hwspinlock_get_id(struct omap_hwspinlock *hwlock)
+{
+	return -ENOSYS;
+}
+
+#endif /* !CONFIG_OMAP_HWSPINLOCK */
+
+/**
+ * omap_hwspin_lock - take a specific hwspinlock, with no time limits
+ * @hwlock: the hwspinlock to be locked
+ * @flags: a pointer to where the caller's interrups state will be saved at
+ *
+ * This function locks the underlying @hwlock. If the @hwlock
+ * is already taken, the function will busy loop waiting for it to
+ * be released. Note: if a faulty remote core never releases the
+ * @hwlock, this function will deadlock.
+ *
+ * Upon a successful return from this function, preemption and interrupts
+ * are disabled, so the caller must not sleep, and is advised to release
+ * the hwspinlock as soon as possible. This is required in order to minimize
+ * remote cores polling on the hardware interconnect.
+ *
+ * Calling this function with a @hwlock which is already taken will have the
+ * same effects as calling spin_lock_irqsave on a taken spinlock.
+ *
+ * This function can be called from any context.
+ *
+ * Returns 0 when the @hwlock was successfully taken, and an appropriate
+ * error code otherwise (can only fail if @hwlock is invalid).
+ */
+static inline
+int omap_hwspin_lock(struct omap_hwspinlock *hwlock, unsigned long *flags)
+{
+	return omap_hwspin_lock_timeout(hwlock, 0, flags);
+}
+
+#endif /* __LINUX_OMAP_HWSPINLOCK_H */
-- 
1.7.0.4

