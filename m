Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab1ELRL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:11:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62178 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113Ab1ELRLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:11:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=S4oaC+bU8A1PFb9VIqT6rTGxdCctOjwG4RZAiStEFv7qqZ+s2ufF4W3q9AZY/M3lE+
         WwaMctVqx8bizjaQGfoqXkJPzgFdUoKBgx7kLOBikY0rNl7MeyYWkBof7/9ZrRyliJBH
         UI1JLa5+cpqd5KMW6qBCC4mlTc9PjGcV8wGZI=
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: linux-pm@lists.linux-foundation.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>,
        Raffaele Recalcati <raffaele.recalcati@bticino.it>
Subject: [PATCH 2/4] PM / Loss: power loss management
Date: Thu, 12 May 2011 19:11:03 +0200
Message-Id: <1305220265-9020-3-git-send-email-lamiaposta71@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

On some embedded systems, an asynchronous power failure notification event is
available some tens to hundreds milliseconds before the actual power failure
takes place.
Such an event can be used to trigger some actions, typically shutting down
all non-vital power sinks, thus allowing the board to survive longer to
temporary power losses.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
---
 Documentation/power/loss.txt |  191 +++++++++++++
 drivers/base/bus.c           |    6 +
 drivers/base/init.c          |    1 +
 drivers/base/platform.c      |   14 +
 drivers/base/power/Makefile  |    2 +
 drivers/base/power/loss.c    |  648 ++++++++++++++++++++++++++++++++++++++++++
 drivers/base/power/power.h   |   14 +
 include/linux/pm.h           |   16 +
 include/linux/pm_loss.h      |  109 +++++++
 kernel/power/Kconfig         |   27 ++
 10 files changed, 1028 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/power/loss.txt
 create mode 100644 drivers/base/power/loss.c
 create mode 100644 include/linux/pm_loss.h

diff --git a/Documentation/power/loss.txt b/Documentation/power/loss.txt
new file mode 100644
index 0000000..10da89c
--- /dev/null
+++ b/Documentation/power/loss.txt
@@ -0,0 +1,191 @@
+**** POWER LOSS MANAGEMENT ****
+
+Davide Ciminaghi <ciminaghi@gnudd.com> 2011
+
+1. Overview
+
+On some embedded systems, an asynchronous power failure notification event is
+available some tens to hundreds milliseconds before the actual power failure
+takes place.
+Such an event can be used to trigger some actions, typically shutting down
+all non-vital power sinks, thus allowing the board to survive longer to
+temporary power losses. Sometimes, also flash-based block devices can be
+stopped after a power loss event notification has been received. This should
+be useful for mmc devices, for which a sudden power failure while a write
+command is being executed can threaten file system integrity even in case a
+journalling fs is in use.
+Generally speaking, one can expect the course of action taken when a power
+failure warning is received to be deeply system specific. Similarly, the
+mechanism used for power failure notifications can equally be board/platform
+specific. For these reasons, support for power loss management has been split
+into three parts:
+
+	+ Generic code (board and driver independent).
+	+ Board dependent code.
+	+ Power loss policy definition.
+
+The generic part of the code is located under drivers/base/power/loss.c .
+On the other hand, board dependent code and power loss policies definitions
+should live somewhere in the platform/board specific files.
+The header file include/linux/pm_loss.h contains all the pm_loss function
+prototypes, together with definitions of data structures.
+For what concerns power loss policies, the framework already contains a couple
+of predefined policies: "nop" and "default" (see later paragraphs for more
+details).
+
+1.1 Sysfs interface.
+
+It can be useful (for instance during tests), to be able to quickly switch
+from one power loss policy to another, or to simulate power fail and resume
+events. To this end, a sysfs interface of the following form has been devised:
+
+/sys/power/loss +
+		|
+		+-- active_policy
+		|
+		+-- policies -+
+		|	      |
+		|	      +-- nop
+		|	      |
+		|	      +-- default +
+		|	      |		  |
+		|	      |	 	  +-- bus_table
+		|	      |
+		|	      +-- ....
+		|
+		+-- pwrfail_sim
+
+2. Details
+
+2.1 Sending events to the power loss management core.
+
+The board specific code shall trigger a power failure event notification by
+calling pm_loss_power_changed(SYS_PWR_FAILING).
+In case of a temporary power loss, the same function shall be called with
+SYS_PWR_GOOD argument on power resume. pm_loss_power_changed() can sleep, so
+it shall not be called from interrupt context.
+
+2.3 Effects on bus and device drivers.
+
+One more entry has been added to the device PM callbacks:
+
+   int (*power_changed)(struct device *, enum sys_power_state);
+
+This function can be optionally invoked by power loss policies in case of
+system power changes (loss and/or resume). Of course every bus or device driver
+can react to such events in some specific way. For instance the mmc block
+driver will probably block its request queue during a temporary power loss.
+
+2.3.1 The platform bus.
+
+For what concerns platform bus drivers, platform specific code can override
+the power_changed() callback :
+
+platform_pm_loss_power_changed(struct device *dev, enum sys_power_state s)
+
+whose default (empty) version is defined as a __weak symbol in
+drivers/base/platform.c.
+
+2.4 Power loss policies.
+
+A power loss policy can be registered via the pm_loss_register_policy()
+function, which receives:
+
+      + A pointer to a struct pm_loss_policy_ops , which hosts the pointers
+      to the policy's specific callbacks (see below for more details).
+      + A pointer to a struct kobj_type, which will allow the pm loss core
+      to setup the policy related directory under /sys/power/loss/policies.
+      See Documentation/kobject.txt for more details on struct kobj_type.
+      + A pointer to an array of chars containing the name of the policy.
+      + A pointer to the policy's private data (void *).
+
+A power loss policy can define the following callbacks:
+
+      + int (*bus_added)(struct pm_loss_policy *, struct bus_type *) : this
+      is invoked whenever a new bus has been registered within the system.
+      Since power related events are often managed at bus level, it can be
+      useful for the policy to have a list of available busses within the
+      system. When a policy is registered, this callback is invoked once
+      for every already registered bus.
+      + int (*bus_removed)(struct pm_loss_policy *, struct bus_type *):
+      this is invoked when a bus is removed from the system.
+      + int (*start)(struct pm_loss_policy *): this is called when a policy
+      becomes active.
+      + void (*stop)(struct pm_loss_policy *): this is called when a policy
+      becomes inactive.
+
+2.4.1 The nop predefined policy
+
+The nop policy is the first active policy when the pm loss framework is
+initialized. It just does nothing in case of power loss / power resume
+events.
+
+2.4.2 The default predefined policy
+
+When a power failure warning is received, the default policy walks through a
+list of critical busses and invokes their drivers' power_changed() callback.
+The default policy can be customized and registered by calling:
+
+    pm_loss_setup_default_policy(struct pm_loss_default_policy_table *);
+
+This function receives a pointer to a pm_loss_default_policy_table structure,
+which defines a priority ordered list of critical buffers:
+
+      struct pm_loss_default_policy_table {
+	     struct module *owner ;
+	     const char *name ;
+	     struct pm_loss_default_policy_item *items;
+	     int nitems;
+      };
+
+Here's a short description of such structure:
+
+      + owner  : shall point to the module registering the table (or NULL
+		 if the table is not instantiated by a module).
+      + name   : this is the name given to this particular customization of
+		 the default policy.
+      + items  : pointer to an array of table items.
+      + nitems : number of the items in the array.
+
+Each item is a struct pm_loss_default_policy_item, defined as follows:
+
+     struct pm_loss_default_policy_item {
+	const char *bus_name;
+	int bus_priority ;
+     };
+
+where bus_name is the name of a bus and bus_priority is a numerical priority
+of the bus itself. Numerically higher priorities correspond to more prioritary
+busses.
+
+2.4.3 Activating a specific policy.
+
+A policy can be activated:
+
+	+ From within the kernel by calling pm_loss_set_policy(char *name).
+	The argument passed to this function shall be the name of the policy
+	to be activated.
+
+	+ From user space by writing the name of the policy to be activated
+	to /sys/power/loss/active_policy.
+
+2.4.4 Unregistering a policy
+
+For a generic user defined policy, just call :
+
+     pm_loss_unregister_policy(struct pm_loss_policy *);
+
+For a default policy customization:
+
+     pm_loss_shutdown_default_policy(struct pm_loss_policy *);
+
+3. Kernel configuration
+
+The following configuration options have been defined:
+
+    CONFIG_PM_LOSS     : this enables the generic pm_loss framework.
+    CONFIG_PM_LOSS_SIM : this adds the pwrfail_sim file to the sysfs interface
+		         and allows power loss events simulation.
+    CONFIG_PM_LOSS_DEBUG : this option enables some debug printk's .
+    CONFIG_PM_LOSS_TEST: this enables the compilation of a sample test module
+                         containing a customized default policy definition
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 2134248..d67a506 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -910,6 +910,9 @@ int bus_register(struct bus_type *bus)
 	if (retval)
 		goto bus_attrs_fail;
 
+#ifdef CONFIG_PM_LOSS
+	pm_loss_on_bus_added(bus);
+#endif
 	pr_debug("bus: '%s': registered\n", bus->name);
 	return 0;
 
@@ -940,6 +943,9 @@ EXPORT_SYMBOL_GPL(bus_register);
 void bus_unregister(struct bus_type *bus)
 {
 	pr_debug("bus: '%s': unregistering\n", bus->name);
+#ifdef CONFIG_PM_LOSS
+	pm_loss_on_bus_removed(bus);
+#endif
 	bus_remove_attrs(bus);
 	remove_probe_files(bus);
 	kset_unregister(bus->p->drivers_kset);
diff --git a/drivers/base/init.c b/drivers/base/init.c
index c8a934e..d979da9 100644
--- a/drivers/base/init.c
+++ b/drivers/base/init.c
@@ -10,6 +10,7 @@
 #include <linux/memory.h>
 
 #include "base.h"
+#include "power/power.h"
 
 /**
  * driver_init - initialize driver model.
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f051cff..427b686 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_loss.h>
 
 #include "base.h"
 
@@ -947,6 +948,18 @@ int __weak platform_pm_runtime_idle(struct device *dev)
 
 #endif /* !CONFIG_PM_RUNTIME */
 
+#ifdef CONFIG_PM_LOSS
+
+int __weak platform_pm_loss_power_changed(struct device *dev,
+					  enum sys_power_state s)
+{
+	return -ENOSYS;
+}
+
+#else
+#define platform_pm_loss_power_changed NULL
+#endif
+
 static const struct dev_pm_ops platform_dev_pm_ops = {
 	.prepare = platform_pm_prepare,
 	.complete = platform_pm_complete,
@@ -965,6 +978,7 @@ static const struct dev_pm_ops platform_dev_pm_ops = {
 	.runtime_suspend = platform_pm_runtime_suspend,
 	.runtime_resume = platform_pm_runtime_resume,
 	.runtime_idle = platform_pm_runtime_idle,
+	.power_changed = platform_pm_loss_power_changed,
 };
 
 struct bus_type platform_bus_type = {
diff --git a/drivers/base/power/Makefile b/drivers/base/power/Makefile
index abe46ed..6373944 100644
--- a/drivers/base/power/Makefile
+++ b/drivers/base/power/Makefile
@@ -1,6 +1,8 @@
 obj-$(CONFIG_PM)	+= sysfs.o
 obj-$(CONFIG_PM_SLEEP)	+= main.o wakeup.o
 obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
+obj-$(CONFIG_PM_LOSS)            += loss.o
+obj-$(CONFIG_PM_LOSS_TEST)       += loss_test.o
 obj-$(CONFIG_PM_OPS)	+= generic_ops.o
 obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
 obj-$(CONFIG_PM_OPP)	+= opp.o
diff --git a/drivers/base/power/loss.c b/drivers/base/power/loss.c
new file mode 100644
index 0000000..a265b8b
--- /dev/null
+++ b/drivers/base/power/loss.c
@@ -0,0 +1,648 @@
+/*
+ * drivers/base/power/loss.c - Power loss management related functions
+ *
+ * Copyright (C) 2011 Davide Ciminaghi <ciminaghi@gnudd.com>
+ * Copyright (C) 2011 BTicino S.p.A.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifdef CONFIG_PM_LOSS_DEBUG
+#define DEBUG
+#endif
+
+#include <linux/kernel.h>
+#include <linux/kobject.h>
+#include <linux/list.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/pm_loss.h>
+#include "../base.h"
+
+#define LOSS_STR "pm_loss"
+
+#define xstr(s) str(s)
+#define str(s) #s
+#define MAX_POLICY_NAME_LENGHT 20
+
+struct power_loss_state_struct {
+	spinlock_t lock;
+	enum sys_power_state state;
+	struct pm_loss_policy *active_policy;
+	wait_queue_head_t wq;
+	struct kobject *loss_kobj;
+	struct kset *policies;
+};
+
+static struct power_loss_state_struct power_state;
+
+
+void pm_loss_power_changed(enum sys_power_state s)
+{
+	pr_debug_pm_loss("pm_loss_power_changed, "
+			 "power_state.active_policy = %p\n",
+			 power_state.active_policy);
+	if (!power_state.active_policy ||
+	    !power_state.active_policy->ops ||
+	    !power_state.active_policy->ops->power_changed) {
+		pr_debug_pm_loss("pm_loss_power_changed with no active "
+				 "policy or "
+				 "policy with no sys_power_changed cb\n");
+		return ;
+	}
+	pr_debug_pm_loss("pm_loss_power_changed(%d)\n", s);
+	spin_lock_irq(&power_state.lock);
+	if (power_state.state == s) {
+		spin_unlock_irq(&power_state.lock);
+		return ;
+	}
+	if (power_state.state == SYS_PWR_NOTIFYING) {
+		DEFINE_WAIT(wait);
+
+		for (;;) {
+			prepare_to_wait(&power_state.wq, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (power_state.state != SYS_PWR_NOTIFYING)
+				break;
+			spin_unlock_irq(&power_state.lock);
+			schedule();
+			spin_lock_irq(&power_state.lock);
+		}
+	}
+	power_state.state = SYS_PWR_NOTIFYING ;
+	spin_unlock_irq(&power_state.lock);
+	if (power_state.active_policy->ops->power_changed) {
+		pr_debug_pm_loss("invoking sys_power_changed cb\n");
+		power_state.active_policy->ops->power_changed
+			(power_state.active_policy, s);
+	}
+	power_state.state = s;
+}
+EXPORT_SYMBOL(pm_loss_power_changed);
+
+#define to_bus(obj) container_of(obj, struct subsys_private, subsys.kobj)
+
+static int __bus_added_removed(struct pm_loss_policy *p,
+			       struct bus_type *bus, bool added)
+{
+	int ret = 0;
+	spin_lock_irq(&power_state.lock);
+	if (power_state.state == SYS_PWR_NOTIFYING) {
+		DEFINE_WAIT(wait);
+
+		for (;;) {
+			prepare_to_wait(&power_state.wq, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (power_state.state != SYS_PWR_NOTIFYING)
+				break;
+			spin_unlock_irq(&power_state.lock);
+			schedule();
+			spin_lock_irq(&power_state.lock);
+		}
+	}
+	if (added)
+		ret = p->ops->bus_added ? p->ops->bus_added(p, bus) : 0;
+	else
+		ret = p->ops->bus_removed ? p->ops->bus_removed(p, bus) : 0;
+	spin_unlock_irq(&power_state.lock);
+	return ret;
+}
+
+static int bus_added(struct pm_loss_policy *p, struct bus_type *bus)
+{
+	return __bus_added_removed(p, bus, true);
+}
+
+static int bus_removed(struct pm_loss_policy *p, struct bus_type *bus)
+{
+	return __bus_added_removed(p, bus, false);
+}
+
+static int policy_add_busses(struct pm_loss_policy *p)
+{
+	struct kobject *k;
+	int stat;
+
+	if (!p || !p->ops)
+		return -EINVAL;
+	if (!p->ops->bus_added)
+		return 0;
+
+	pr_debug_pm_loss("policy_add_busses()\n");
+
+	if (!bus_kset) {
+		pr_debug_pm_loss("bus_kset still NULL\n");
+		return 0;
+	}
+
+	spin_lock(&bus_kset->list_lock);
+	list_for_each_entry(k, &bus_kset->list, entry) {
+		spin_unlock(&bus_kset->list_lock);
+		/* This might sleep */
+		pr_debug_pm_loss("invoking bus_added()\n");
+		stat = bus_added(p, to_bus(k)->bus);
+		spin_lock(&bus_kset->list_lock);
+	}
+	spin_unlock(&bus_kset->list_lock);
+	return 0;
+}
+
+static void __pm_loss_on_bus_added_removed(struct bus_type *bus, bool added)
+{
+	struct list_head *i;
+	struct kobject *k;
+
+	if (!power_state.policies)
+		/* Not yet initialized */
+		return ;
+
+	spin_lock(&power_state.policies->list_lock);
+	list_for_each(i, &power_state.policies->list) {
+		k = container_of(i, struct kobject, entry);
+		if (added)
+			bus_added(to_policy(k), bus);
+		else
+			bus_removed(to_policy(k), bus);
+	}
+	spin_unlock(&power_state.policies->list_lock);
+}
+
+void pm_loss_on_bus_added(struct bus_type *bus)
+{
+	__pm_loss_on_bus_added_removed(bus, true);
+}
+EXPORT_SYMBOL(pm_loss_on_bus_added);
+
+void pm_loss_on_bus_removed(struct bus_type *bus)
+{
+	__pm_loss_on_bus_added_removed(bus, false);
+}
+EXPORT_SYMBOL(pm_loss_on_bus_removed);
+
+struct pm_loss_policy *
+pm_loss_register_policy(const struct pm_loss_policy_ops *ops,
+			struct kobj_type *ktype,
+			const char *name, void *priv)
+{
+	struct pm_loss_policy *out = NULL;
+	int ret ;
+
+	if (strlen(name) > MAX_POLICY_NAME_LENGHT)
+		printk(KERN_WARNING LOSS_STR "warning : name %s is too long, "
+		       "will be truncated\n", name);
+
+	out = kzalloc(sizeof(struct pm_loss_policy), GFP_KERNEL);
+	if (!out)
+		return NULL;
+	out->ops = ops;
+	out->priv = priv;
+	out->kobj.kset = power_state.policies;
+
+	if (policy_add_busses(out) < 0)
+		goto err0;
+
+	ret = kobject_init_and_add(&out->kobj, ktype, NULL, "%s", name);
+	if (ret < 0)
+		goto err1;
+
+	kobject_uevent(&out->kobj, KOBJ_ADD);
+
+	return out;
+
+ err1:
+	kobject_put(&out->kobj);
+ err0:
+	kfree(out);
+	return NULL;
+}
+EXPORT_SYMBOL(pm_loss_register_policy);
+
+int pm_loss_unregister_policy(struct pm_loss_policy *p)
+{
+	pr_debug_pm_loss("pm_loss_unregister_policy(%p)\n", p);
+	if (power_state.active_policy == p) {
+		pr_debug_pm_loss("cannot unregister policy (busy)\n");
+		return -EBUSY ;
+	}
+	kobject_del(&p->kobj);
+	kobject_put(&p->kobj);
+	return 0;
+}
+EXPORT_SYMBOL(pm_loss_unregister_policy);
+
+int pm_loss_set_policy(const char *name)
+{
+	struct kobject *o;
+	struct pm_loss_policy *p ;
+	spin_lock_irq(&power_state.lock);
+	o = kset_find_obj(power_state.policies, name);
+	if (!o) {
+		spin_unlock_irq(&power_state.lock);
+		return -ENODEV;
+	}
+	p = to_policy(o);
+	if (power_state.active_policy) {
+		if (power_state.active_policy->ops->stop)
+			power_state.active_policy->ops->stop
+				(power_state.active_policy);
+	}
+	power_state.active_policy = p;
+	if (power_state.active_policy->ops->start)
+		power_state.active_policy->ops->start
+			(power_state.active_policy);
+	spin_unlock_irq(&power_state.lock);
+	return 0;
+}
+EXPORT_SYMBOL(pm_loss_set_policy);
+
+/*
+ * Default release function for pm_loss_policy object
+ */
+static void pm_loss_policy_release(struct kobject *kobj)
+{
+	struct pm_loss_policy *p;
+	p = to_policy(kobj);
+	pr_debug_pm_loss("pm_loss_policy_release(%p)\n", p);
+	kfree(p);
+}
+
+/*
+ * Dummy nop policy implementation (all null pointers)
+ */
+static const struct pm_loss_policy_ops nop_policy_ops = {
+};
+
+static const struct sysfs_ops nop_sysfs_ops = {
+	.show = NULL,
+	.store = NULL,
+};
+
+static struct attribute *nop_default_attrs[] = {
+	NULL,
+};
+
+static struct kobj_type nop_ktype = {
+	.sysfs_ops = &nop_sysfs_ops,
+	.release = pm_loss_policy_release,
+	.default_attrs = nop_default_attrs,
+};
+
+/*
+ * Default policy implementation
+ */
+
+struct pm_loss_default_policy_data {
+	struct pm_loss_default_policy_table *table;
+	struct list_head busses ;
+};
+
+struct pm_loss_default_policy_bus_data {
+	struct bus_type *bus;
+	int priority ;
+	struct list_head list;
+};
+
+static struct pm_loss_default_policy_item *
+__find_bus_by_name(const char *name,
+		   struct pm_loss_default_policy_table *table)
+{
+	int i;
+	struct pm_loss_default_policy_item *out = NULL;
+	for (i = 0; i < table->nitems; i++)
+		if (!strcmp(table->items[i].bus_name, name)) {
+			out = &table->items[i];
+			break;
+		}
+	return out;
+}
+
+static void __add_bus(struct pm_loss_default_policy_data *data,
+		      struct pm_loss_default_policy_bus_data *new)
+{
+	struct pm_loss_default_policy_bus_data *bd;
+	list_for_each_entry(bd, &data->busses, list)
+		if (new->priority > bd->priority) {
+			list_add_tail(&new->list, &bd->list);
+			return;
+		}
+	list_add_tail(&new->list, &bd->list);
+}
+
+static int pm_loss_default_policy_bus_added(struct pm_loss_policy *p,
+					   struct bus_type *bus)
+{
+	struct pm_loss_default_policy_item *item ;
+	struct pm_loss_default_policy_data *pd = p->priv;
+	struct pm_loss_default_policy_bus_data *bd =
+		kzalloc(sizeof(struct pm_loss_default_policy_bus_data),
+			GFP_KERNEL);
+
+	BUG_ON(!pd);
+	if (!bd)
+		return -ENOMEM;
+	pr_debug_pm_loss("pm_loss_default_policy_bus_added(), name = %s\n",
+		 bus->name);
+	item = __find_bus_by_name(bus->name, pd->table);
+	if (!item)
+		return 0;
+
+	pr_debug_pm_loss("bus_found\n");
+
+	bd->priority = item->bus_priority ;
+	bd->bus = bus ;
+	__add_bus(pd, bd);
+
+	return 0;
+}
+
+static int pm_loss_default_policy_bus_removed(struct pm_loss_policy *p,
+					     struct bus_type *bus)
+{
+	struct pm_loss_default_policy_data *pd = p->priv;
+	struct pm_loss_default_policy_bus_data *bd, *tmp;
+
+	BUG_ON(!pd);
+	list_for_each_entry_safe(bd, tmp, &pd->busses, list)
+		if (bd->bus == bus) {
+			list_del(&bd->list);
+			kfree(bd);
+			break;
+		}
+	return 0;
+}
+
+struct bus_sys_pwr_changed_data {
+	struct bus_type *bus;
+	enum sys_power_state s;
+};
+
+static int __bus_sys_pwr_changed(struct device *dev, void *_d)
+{
+	struct bus_sys_pwr_changed_data *data =
+		(struct bus_sys_pwr_changed_data *)_d;
+	struct bus_type *bus = data->bus;
+
+	BUG_ON(!dev);
+	BUG_ON(!bus);
+
+	pr_debug_pm_loss("__bus_sys_pwr_changed(%p), bus %s\n", dev,
+			 bus->name);
+
+	if (bus->pm && bus->pm->power_changed)
+		bus->pm->power_changed(dev, data->s);
+	return 0;
+}
+
+
+static void
+pm_loss_default_policy_sys_power_changed(struct pm_loss_policy *p,
+					enum sys_power_state s)
+{
+	struct pm_loss_default_policy_data *pd = p->priv;
+	struct pm_loss_default_policy_bus_data *bd ;
+	struct bus_sys_pwr_changed_data cb_data ;
+
+	pr_debug_pm_loss("pm_loss_default_policy_sys_power_changed()\n");
+
+	BUG_ON(!pd);
+
+	list_for_each_entry(bd, &pd->busses, list) {
+		struct bus_type *bus = bd->bus;
+		const struct dev_pm_ops *pm = bus->pm;
+		pr_debug_pm_loss("bus = %s\n", bus->name);
+		if (pm && pm->power_changed) {
+			cb_data.bus = bus ; cb_data.s = s;
+			pr_debug_pm_loss("before bus_for_each_dev\n");
+			bus_for_each_dev(bus, NULL, (void *)&cb_data,
+					 __bus_sys_pwr_changed);
+		}
+	}
+}
+
+static int pm_loss_default_policy_start(struct pm_loss_policy *p)
+{
+	return 0;
+}
+
+static void pm_loss_default_policy_stop(struct pm_loss_policy *p)
+{
+	struct pm_loss_default_policy_data *pd = p->priv;
+	if (pd->table->owner)
+		module_put(pd->table->owner);
+}
+
+static const struct pm_loss_policy_ops default_policy_ops = {
+	.bus_added = pm_loss_default_policy_bus_added,
+	.bus_removed = pm_loss_default_policy_bus_removed,
+	.power_changed = pm_loss_default_policy_sys_power_changed,
+	.start = pm_loss_default_policy_start,
+	.stop = pm_loss_default_policy_stop,
+};
+
+/* sysfs stuff */
+
+struct dflt_bus_table_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct pm_loss_policy *,
+			struct dflt_bus_table_attribute *attr,
+			char *buf);
+};
+#define to_dflt_bus_table_attr(x) \
+container_of(x, struct dflt_bus_table_attribute, attr)
+
+
+static ssize_t bus_table_show(struct pm_loss_policy *p,
+			      struct dflt_bus_table_attribute *attr,
+			      char *buf)
+{
+	struct pm_loss_default_policy_data *pd = p->priv;
+	struct pm_loss_default_policy_bus_data *bd ;
+	char *ptr = buf;
+
+	BUG_ON(!pd);
+
+	list_for_each_entry(bd, &pd->busses, list) {
+		struct bus_type *bus = bd->bus;
+		ptr += snprintf(ptr, PAGE_SIZE - (ptr - buf), "%s:%d,",
+				bus->name, bd->priority);
+	}
+	return ptr - buf;
+}
+
+static struct dflt_bus_table_attribute bus_table_attribute =
+__ATTR_RO(bus_table);
+
+
+static struct attribute *dflt_default_attrs[] = {
+	&bus_table_attribute.attr,
+	NULL,
+};
+
+/* dflt sysfs ops */
+
+static ssize_t dflt_show(struct kobject *kobj, struct attribute *_attr,
+			 char *buf)
+{
+	if (!strcmp(_attr->name, "bus_table")) {
+		struct dflt_bus_table_attribute *attr =
+			to_dflt_bus_table_attr(_attr);
+		struct pm_loss_policy *p =
+			to_policy(kobj);
+		return attr->show(p, attr, buf);
+	}
+	return -EIO;
+}
+
+static ssize_t dflt_store(struct kobject *kobj,
+			  struct attribute *attr,
+			  const char *buf, size_t len)
+{
+	return -EIO;
+}
+
+static const struct sysfs_ops dflt_sysfs_ops = {
+	.show = dflt_show,
+	.store = dflt_store,
+};
+
+static struct kobj_type dflt_ktype = {
+	.sysfs_ops = &dflt_sysfs_ops,
+	.release = pm_loss_policy_release,
+	.default_attrs = dflt_default_attrs,
+};
+
+struct pm_loss_policy *
+pm_loss_setup_default_policy(struct pm_loss_default_policy_table *table)
+{
+	struct pm_loss_policy *p ;
+	struct pm_loss_default_policy_data *data ;
+
+	if (!table)
+		return NULL;
+
+	if (table->owner && try_module_get(table->owner) < 0)
+		return NULL;
+
+	data = kzalloc(sizeof(struct pm_loss_default_policy_data), GFP_KERNEL);
+	if (!data)
+		return NULL;
+	INIT_LIST_HEAD(&data->busses);
+	data->table = table;
+
+	p = pm_loss_register_policy(&default_policy_ops, &dflt_ktype,
+				    table->name, data);
+	if (!p) {
+		kfree(data);
+		return p;
+	}
+	return p;
+}
+EXPORT_SYMBOL(pm_loss_setup_default_policy);
+
+int pm_loss_shutdown_default_policy(struct pm_loss_policy *p)
+{
+	int ret;
+	pr_debug_pm_loss("pm_loss_shutdown_default_policy()\n");
+	ret = pm_loss_unregister_policy(p);
+	if (ret < 0)
+		pr_debug_pm_loss("cannot unregister policy\n");
+	return ret;
+}
+EXPORT_SYMBOL(pm_loss_shutdown_default_policy);
+
+static ssize_t active_policy_show(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  char *buf)
+{
+	return sprintf(buf, "%s\n",
+		       kobject_name(&power_state.active_policy->kobj));
+}
+
+
+static ssize_t active_policy_store(struct kobject *kobj,
+				   struct kobj_attribute *attr,
+				   const char *buf, size_t count)
+{
+	char pname[MAX_POLICY_NAME_LENGHT];
+	int ret;
+
+	sscanf(buf, "%" xstr(MAX_POLICY_NAME_LENGHT) "s", pname);
+	ret = pm_loss_set_policy(pname);
+	return ret < 0 ? ret : count;
+}
+
+static struct kobj_attribute active_policy_attribute =
+	__ATTR(active_policy, 0644, active_policy_show, active_policy_store);
+
+#ifdef CONFIG_PM_LOSS_SIM
+static ssize_t pwrfail_sim_store(struct kobject *kobj,
+				 struct kobj_attribute *attr,
+				 const char *buf, size_t count)
+{
+	int n;
+	sscanf(buf, "%d", &n);
+	pm_loss_power_changed(n ? SYS_PWR_FAILING : SYS_PWR_GOOD);
+	return count;
+}
+
+
+static struct kobj_attribute pwrfail_sim_attribute =
+	__ATTR(pwrfail_sim, 0200, NULL, pwrfail_sim_store);
+#endif
+
+
+static struct attribute *loss_attrs[] = {
+	&active_policy_attribute.attr,
+#ifdef CONFIG_PM_LOSS_SIM
+	&pwrfail_sim_attribute.attr,
+#endif
+	NULL,
+};
+
+static struct attribute_group loss_attr_group = {
+	.attrs = loss_attrs,
+};
+
+/*
+ * Init function
+ */
+int __init pm_loss_init(void)
+{
+	struct pm_loss_policy *p ;
+	int ret = 0;
+
+	pr_debug_pm_loss("pm_loss_init()\n");
+	spin_lock_init(&power_state.lock);
+	power_state.state = SYS_PWR_GOOD;
+	init_waitqueue_head(&power_state.wq);
+	power_state.active_policy = NULL;
+	power_state.loss_kobj = kobject_create_and_add("loss", power_kobj);
+	if (!power_state.loss_kobj) {
+		ret = -ENOMEM;
+		goto err0;
+	}
+	power_state.policies =
+		kset_create_and_add("policies", NULL, power_state.loss_kobj);
+	if (!power_state.policies) {
+		ret = -ENOMEM;
+		goto err1;
+	}
+	ret = sysfs_create_group(power_state.loss_kobj, &loss_attr_group);
+	if (ret < 0)
+		goto err2;
+	pr_debug_pm_loss("invoking pm_loss_register_policy (nop)\n");
+	p = pm_loss_register_policy(&nop_policy_ops, &nop_ktype, "nop", NULL);
+	BUG_ON(!p);
+	pr_debug_pm_loss("setting nop policy as current one\n");
+	pm_loss_set_policy("nop");
+	return ret;
+
+ err2:
+	kset_unregister(power_state.policies);
+ err1:
+	kobject_put(power_state.loss_kobj);
+ err0:
+	return ret;
+}
+
+core_initcall(pm_loss_init);
diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index 698dde7..ad54ef5 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -10,6 +10,20 @@ static inline void pm_runtime_remove(struct device *dev) {}
 
 #endif /* !CONFIG_PM_RUNTIME */
 
+#ifdef CONFIG_PM_LOSS
+
+extern void pm_loss_init(void) ;
+extern void pm_loss_on_bus_added(struct bus_type *);
+extern void pm_loss_on_bus_removed(struct bus_type *);
+
+#else /* !CONFIG_PM_LOSS */
+
+static inline void pm_loss_init(void) {}
+static inline void pm_loss_on_bus_added(struct bus_type *b) {};
+static inline void pm_loss_on_bus_removed(struct bus_type *b) {};
+
+#endif
+
 #ifdef CONFIG_PM_SLEEP
 
 /* kernel/power/main.c */
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 21415cc..0316cd0 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -40,6 +40,7 @@ extern void (*pm_power_off_prepare)(void);
  */
 
 struct device;
+enum sys_power_state ;
 
 #ifdef CONFIG_PM
 extern const char power_group_name[];		/* = "power" */
@@ -199,6 +200,10 @@ typedef struct pm_message {
  *	power state if all of the necessary conditions are satisfied.  Check
  *	these conditions and handle the device as appropriate, possibly queueing
  *	a suspend request for it.  The return value is ignored by the PM core.
+ *
+ * @power_changed: device power has changed state (used by pm_loss). This
+ *      is invoked whenever system power changes its state (from GOOD to
+ *      FAILING or viceversa)
  */
 
 struct dev_pm_ops {
@@ -219,6 +224,7 @@ struct dev_pm_ops {
 	int (*runtime_suspend)(struct device *dev);
 	int (*runtime_resume)(struct device *dev);
 	int (*runtime_idle)(struct device *dev);
+	int (*power_changed)(struct device *, enum sys_power_state);
 };
 
 #ifdef CONFIG_PM_SLEEP
@@ -421,6 +427,16 @@ enum rpm_request {
 
 struct wakeup_source;
 
+/**
+ * System power states
+ *
+ */
+enum sys_power_state {
+	SYS_PWR_GOOD = 0,
+	SYS_PWR_FAILING,
+	SYS_PWR_NOTIFYING,
+};
+
 struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned int		can_wakeup:1;
diff --git a/include/linux/pm_loss.h b/include/linux/pm_loss.h
new file mode 100644
index 0000000..46af47c
--- /dev/null
+++ b/include/linux/pm_loss.h
@@ -0,0 +1,109 @@
+/*
+ * pm_loss.h - Power loss management related functions, header file
+ *
+ * Copyright (C) 2011 Davide Ciminaghi <ciminaghi@gnudd.com>
+ * Copyright (C) 2011 BTicino S.p.A.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifndef _LINUX_PM_LOSS_H
+#define _LINUX_PM_LOSS_H
+
+#include <linux/device.h>
+#include <linux/pm.h>
+
+struct pm_loss_policy ;
+
+struct pm_loss_policy_ops {
+	int (*bus_added)(struct pm_loss_policy *,
+			 struct bus_type *);
+	int (*bus_removed)(struct pm_loss_policy *,
+			   struct bus_type *);
+	void (*power_changed)(struct pm_loss_policy *,
+			      enum sys_power_state);
+	int (*start)(struct pm_loss_policy *);
+	void (*stop)(struct pm_loss_policy *);
+};
+
+struct pm_loss_policy {
+	const struct pm_loss_policy_ops *ops;
+	void *priv;
+	struct list_head list;
+	struct kobject kobj;
+};
+
+#define to_policy(k) container_of(k, struct pm_loss_policy, kobj)
+
+struct pm_loss_default_policy_table {
+	struct module *owner ;
+	const char *name ;
+	struct pm_loss_default_policy_item *items;
+	int nitems;
+};
+
+#ifdef CONFIG_PM_LOSS
+
+#ifdef CONFIG_PM_LOSS_DEBUG
+#define PM_LOSS_STR "pm_loss:"
+#define pr_debug_pm_loss(a, args...) \
+printk(KERN_INFO PM_LOSS_STR a, ## args)
+#else
+#define pr_debug_pm_loss(a, args...)
+#endif
+
+extern void pm_loss_power_changed(enum sys_power_state s);
+
+extern struct pm_loss_policy *
+pm_loss_register_policy(const struct pm_loss_policy_ops *ops,
+			struct kobj_type *ktype,
+			const char *name, void *priv);
+
+extern int pm_loss_unregister_policy(struct pm_loss_policy *);
+
+extern int pm_loss_set_policy(const char *name);
+
+struct pm_loss_default_policy_item {
+	const char *bus_name;
+	int bus_priority ;
+};
+
+extern struct pm_loss_policy *
+pm_loss_setup_default_policy(struct pm_loss_default_policy_table *);
+
+extern int pm_loss_shutdown_default_policy(struct pm_loss_policy *);
+
+#else /* !CONFIG_PM_LOSS */
+
+static inline struct pm_loss_policy *
+pm_loss_register_policy(const struct pm_loss_policy_ops *ops,
+		       void *priv)
+{
+	return NULL ;
+}
+
+static inline int pm_loss_unregister_policy(struct pm_loss_policy *p)
+{
+	return -ENOSYS ;
+}
+
+static inline int pm_loss_set_policy(struct pm_loss_policy *p)
+{
+	return -ENOSYS ;
+}
+
+static inline struct pm_loss_policy *
+pm_loss_setup_default_policy(struct pm_loss_default_policy_table *t)
+{
+	return NULL;
+}
+
+static inline int
+pm_loss_shutdown_default_policy(struct pm_loss_policy *p)
+{
+	return -ENOSYS;
+}
+
+#endif /* !CONFIG_PM_LOSS */
+
+#endif /* _LINUX_PM_LOSS_H */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 2657299..7527847 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -236,6 +236,33 @@ config PM_RUNTIME
 	  responsible for the actual handling of the autosuspend requests and
 	  wake-up events.
 
+config PM_LOSS
+	bool "Help drivers reacting to system power losses"
+	depends on PM
+	---help---
+	  Enable power loss management. On some embedded systems, an
+          asynchronous power failure notification event is sometimes available
+	  less than one second before the actual power failure takes place.
+	  Custom policies can be setup to react to such an event. See
+	  Documentation/power/loss.txt for more details.
+	  If unsure, say No.
+
+config PM_LOSS_SIM
+	bool "Simulate power fail events"
+	depends on PM_LOSS
+	---help---
+	  Add the /sys/power/loss/pwrfail_sim file. Do
+		echo 1 > /sys/power/loss/pwrfail_sim
+	  to simulate a power failure and
+		echo 0 > /sys/power/loss/pwrfail_sim
+	  to simulate a power resume
+
+config PM_LOSS_DEBUG
+	bool "Enable power fail debug"
+	depends on PM_LOSS
+	---help---
+	This option enables debugging printk's for the PM_LOSS framework
+
 config PM_OPS
 	bool
 	depends on PM_SLEEP || PM_RUNTIME
-- 
1.7.0.4

