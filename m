Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab2JHIKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 04:10:10 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36161 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab2JHIKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 04:10:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Huang Ying <ying.huang@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Jean Pihet <j-pihet@ti.com>, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] PM / QoS: Prepare struct dev_pm_qos_request for more request types
Date: Mon, 08 Oct 2012 10:06:08 +0200
Message-ID: <1701634.Jkkbu1sQKe@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.0-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1413438.1MkXj8vjQK@vostro.rjw.lan>
References: <201209282351.10663.rjw@sisk.pl> <1413438.1MkXj8vjQK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The subsequent patches will use struct dev_pm_qos_request for
representing both latency requests and flags requests.  To make that
easier, put the node member of struct dev_pm_qos_request (under the
name "pnode") into a union called "data" that will represent the
request's  value and list node depending on its type.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Jean Pihet <j-pihet@ti.com>
---
 drivers/base/power/qos.c   |    6 +++---
 drivers/base/power/sysfs.c |    2 +-
 include/linux/pm_qos.h     |    4 +++-
 3 files changed, 7 insertions(+), 5 deletions(-)

Index: linux/include/linux/pm_qos.h
===================================================================
--- linux.orig/include/linux/pm_qos.h
+++ linux/include/linux/pm_qos.h
@@ -39,7 +39,9 @@ struct pm_qos_flags_request {
 };
 
 struct dev_pm_qos_request {
-	struct plist_node node;
+	union {
+		struct plist_node pnode;
+	} data;
 	struct device *dev;
 };
 
Index: linux/drivers/base/power/sysfs.c
===================================================================
--- linux.orig/drivers/base/power/sysfs.c
+++ linux/drivers/base/power/sysfs.c
@@ -221,7 +221,7 @@ static DEVICE_ATTR(autosuspend_delay_ms,
 static ssize_t pm_qos_latency_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", dev->power.pq_req->node.prio);
+	return sprintf(buf, "%d\n", dev->power.pq_req->data.pnode.prio);
 }
 
 static ssize_t pm_qos_latency_store(struct device *dev,
Index: linux/drivers/base/power/qos.c
===================================================================
--- linux.orig/drivers/base/power/qos.c
+++ linux/drivers/base/power/qos.c
@@ -90,7 +90,7 @@ static int apply_constraint(struct dev_p
 	int ret, curr_value;
 
 	ret = pm_qos_update_target(&req->dev->power.qos->latency,
-				   &req->node, action, value);
+				   &req->data.pnode, action, value);
 
 	if (ret) {
 		/* Call the global callbacks if needed */
@@ -183,7 +183,7 @@ void dev_pm_qos_constraints_destroy(stru
 
 	c = &qos->latency;
 	/* Flush the constraints list for the device */
-	plist_for_each_entry_safe(req, tmp, &c->list, node) {
+	plist_for_each_entry_safe(req, tmp, &c->list, data.pnode) {
 		/*
 		 * Update constraints list and call the notification
 		 * callbacks if needed
@@ -293,7 +293,7 @@ int dev_pm_qos_update_request(struct dev
 	mutex_lock(&dev_pm_qos_mtx);
 
 	if (req->dev->power.qos) {
-		if (new_value != req->node.prio)
+		if (new_value != req->data.pnode.prio)
 			ret = apply_constraint(req, PM_QOS_UPDATE_REQ,
 					       new_value);
 	} else {

