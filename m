Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab2KWXgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 18:36:55 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:35456 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab2KWXgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 18:36:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH] PM / QoS: Handle device PM QoS flags while removing constraints
Date: Sat, 24 Nov 2012 00:41:25 +0100
Message-ID: <12198078.HQz2VYRPzC@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

PM QoS flags have to be handled by dev_pm_qos_constraints_destroy()
in the same way as PM QoS resume latency constraits.  That is, if
they have been exposed to user space, they have to be hidden from it
and the list of flags requests has to be flushed before destroying
the device's PM QoS object.  Make that happen.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/qos.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux/drivers/base/power/qos.c
===================================================================
--- linux.orig/drivers/base/power/qos.c
+++ linux/drivers/base/power/qos.c
@@ -223,12 +223,14 @@ void dev_pm_qos_constraints_destroy(stru
 	struct dev_pm_qos *qos;
 	struct dev_pm_qos_request *req, *tmp;
 	struct pm_qos_constraints *c;
+	struct pm_qos_flags *f;
 
 	/*
-	 * If the device's PM QoS resume latency limit has been exposed to user
-	 * space, it has to be hidden at this point.
+	 * If the device's PM QoS resume latency limit or PM QoS flags have been
+	 * exposed to user space, they have to be hidden at this point.
 	 */
 	dev_pm_qos_hide_latency_limit(dev);
+	dev_pm_qos_hide_flags(dev);
 
 	mutex_lock(&dev_pm_qos_mtx);
 
@@ -237,8 +239,8 @@ void dev_pm_qos_constraints_destroy(stru
 	if (!qos)
 		goto out;
 
+	/* Flush the constraints lists for the device. */
 	c = &qos->latency;
-	/* Flush the constraints list for the device */
 	plist_for_each_entry_safe(req, tmp, &c->list, data.pnode) {
 		/*
 		 * Update constraints list and call the notification
@@ -247,6 +249,11 @@ void dev_pm_qos_constraints_destroy(stru
 		apply_constraint(req, PM_QOS_REMOVE_REQ, PM_QOS_DEFAULT_VALUE);
 		memset(req, 0, sizeof(*req));
 	}
+	f = &qos->flags;
+	list_for_each_entry_safe(req, tmp, &f->list, data.flr.node) {
+		apply_constraint(req, PM_QOS_REMOVE_REQ, PM_QOS_DEFAULT_VALUE);
+		memset(req, 0, sizeof(*req));
+	}
 
 	spin_lock_irq(&dev->power.lock);
 	dev->power.qos = NULL;

