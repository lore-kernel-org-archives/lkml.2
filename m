Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1LIXoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:44:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51438 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab1LIXoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:44:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [RFC][PATCH 3/4] PM / QoS: Introduce dev_pm_qos_add_ancestor_request()
Date: Sat, 10 Dec 2011 00:45:31 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <201112100042.45168.rjw@sisk.pl>
In-Reply-To: <201112100042.45168.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112100045.31677.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Some devices, like the I2C controller on SH7372, are not
necessary for providing power to their children or forwarding
wakeup signals (and generally interrupts) from them.  They are
only needed by their children when there's some data to transfer,
so they may be suspended for the majority of time and resumed
on demand, when the children have data to send or receive.  For this
purpose, however, their power.ignore_children flags have to be set,
or the PM core wouldn't allow them to be suspended while their
children were active.

Unfortunately, in some situations it may take too much time to
resume such devices so that they can assist their children in
transferring data.  For example, if such a device belongs to a PM
domain which goes to the "power off" state when that device is
suspended, it may take too much time to restore power to the
domain in response to the request from one of the device's
children.  In that case, if the parent's resume time is critical,
the domain should stay in the "power on" state, although it still may
be desirable to power manage the parent itself (e.g. by manipulating
its clock).

In general, device PM QoS may be used to address this problem.
Namely, if the device's children added PM QoS latency constraints
for it, they would be able to prevent it from being put into an
overly deep low-power state.  However, in some cases the devices
needing to be serviced are not the immediate children of a
"children-ignoring" device, but its grandchildren or even less
direct descendants.  In those cases, the entity wanting to add a
PM QoS request for a given device's ancestor that ignores its
children will have to find it in the first place, so introduce a new
helper function that may be used to achieve that.  This function,
dev_pm_qos_add_ancestor_request(), will search for the first
ancestor of the given device whose power.ignore_children flag is
set and will add a device PM QoS latency request for that ancestor
on behalf of the caller.  The request added this way may be removed
with the help of dev_pm_qos_remove_request() in the future, like
any other device PM QoS latency request.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/qos.c |   25 +++++++++++++++++++++++++
 include/linux/pm_qos.h   |    5 +++++
 2 files changed, 30 insertions(+)

Index: linux/drivers/base/power/qos.c
===================================================================
--- linux.orig/drivers/base/power/qos.c
+++ linux/drivers/base/power/qos.c
@@ -420,3 +420,28 @@ int dev_pm_qos_remove_global_notifier(st
 	return blocking_notifier_chain_unregister(&dev_pm_notifiers, notifier);
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_remove_global_notifier);
+
+/**
+ * dev_pm_qos_add_ancestor_request - Add PM QoS request for device's ancestor.
+ * @dev: Device whose ancestor to add the request for.
+ * @req: Pointer to the preallocated handle.
+ * @value: Constraint latency value.
+ */
+int dev_pm_qos_add_ancestor_request(struct device *dev,
+				    struct dev_pm_qos_request *req, s32 value)
+{
+	struct device *ancestor = dev->parent;
+	int error = -ENODEV;
+
+	while (ancestor && !ancestor->power.ignore_children)
+		ancestor = ancestor->parent;
+
+	if (ancestor)
+		error = dev_pm_qos_add_request(ancestor, req, value);
+
+	if (error)
+		req->dev = NULL;
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(dev_pm_qos_add_ancestor_request);
Index: linux/include/linux/pm_qos.h
===================================================================
--- linux.orig/include/linux/pm_qos.h
+++ linux/include/linux/pm_qos.h
@@ -92,6 +92,8 @@ int dev_pm_qos_add_global_notifier(struc
 int dev_pm_qos_remove_global_notifier(struct notifier_block *notifier);
 void dev_pm_qos_constraints_init(struct device *dev);
 void dev_pm_qos_constraints_destroy(struct device *dev);
+int dev_pm_qos_add_ancestor_request(struct device *dev,
+				    struct dev_pm_qos_request *req, s32 value);
 #else
 static inline int pm_qos_update_target(struct pm_qos_constraints *c,
 				       struct plist_node *node,
@@ -153,6 +155,9 @@ static inline void dev_pm_qos_constraint
 {
 	dev->power.power_state = PMSG_INVALID;
 }
+int dev_pm_qos_add_ancestor_request(struct device *dev,
+				    struct dev_pm_qos_request *req, s32 value)
+			{ return 0; }
 #endif
 
 #endif

