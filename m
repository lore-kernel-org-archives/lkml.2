Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab2BNFRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 00:17:04 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:16680 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab2BNFQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 00:16:59 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-25-4f39ee495715
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean Pihet <j-pihet@ti.com>, markgross <markgross@thegnar.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: [RFC PATCH] PM / QoS: add pm_qos_update_request_timeout API
Date: Tue, 14 Feb 2012 14:16:54 +0900
Message-id: <1329196614-6218-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new API, pm_qos_update_request_timeout() is to provide a timeout
with pm_qos_update_request.

For example, pm_qos_update_request_timeout(req, 100, 1000), means that
QoS request on req with value 100 will be active for 1000 jiffies.
After 1000 jiffies, the QoS request thru req is rolled back to the
request status when pm_qos_update_request_timeout() was called. If there
were another pm_qos_update_request(req, x) during the 1000 jiffies, this
new request with value x will override as this is another request on the
same req handle. A new request on the same req handle will always
override the previous request whether it is the conventional request or
it is the new timeout request.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 include/linux/pm_qos.h |    5 ++++
 kernel/power/qos.c     |   54 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
index f8ccb7b..1c29f52 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -8,6 +8,7 @@
 #include <linux/notifier.h>
 #include <linux/miscdevice.h>
 #include <linux/device.h>
+#include <linux/workqueue.h>
 
 #define PM_QOS_RESERVED 0
 #define PM_QOS_CPU_DMA_LATENCY 1
@@ -29,6 +30,8 @@
 struct pm_qos_request {
 	struct plist_node node;
 	int pm_qos_class;
+	s32 value; /* the back-up value for pm_qos_update_request_timeout */
+	struct delayed_work work; /* for pm_qos_update_request_timeout */
 };
 
 struct dev_pm_qos_request {
@@ -74,6 +77,8 @@ void pm_qos_add_request(struct pm_qos_request *req, int pm_qos_class,
 			s32 value);
 void pm_qos_update_request(struct pm_qos_request *req,
 			   s32 new_value);
+void pm_qos_update_request_timeout(struct pm_qos_request *req,
+				   s32 new_value, unsigned long timeout);
 void pm_qos_remove_request(struct pm_qos_request *req);
 
 int pm_qos_request(int pm_qos_class);
diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index b15e0b7..acfa433 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -259,6 +259,21 @@ int pm_qos_request_active(struct pm_qos_request *req)
 EXPORT_SYMBOL_GPL(pm_qos_request_active);
 
 /**
+ * pm_qos_timeout - the timeout handler of pm_qos_update_request_timeout
+ * @work: work struct for the delayed work (timeout)
+ *
+ * This cancels the timeout request and rolls the request value back.
+ */
+static void pm_qos_timeout(struct work_struct *work)
+{
+	struct pm_qos_request *req = container_of(to_delayed_work(work),
+						  struct pm_qos_request,
+						  work);
+
+	pm_qos_update_request(req, req->value);
+}
+
+/**
  * pm_qos_add_request - inserts new qos request into the list
  * @req: pointer to a preallocated handle
  * @pm_qos_class: identifies which list of qos request to use
@@ -282,6 +297,8 @@ void pm_qos_add_request(struct pm_qos_request *req,
 		return;
 	}
 	req->pm_qos_class = pm_qos_class;
+	req->value = value;
+	INIT_DELAYED_WORK(&req->work, pm_qos_timeout);
 	pm_qos_update_target(pm_qos_array[pm_qos_class]->constraints,
 			     &req->node, PM_QOS_ADD_REQ, value);
 }
@@ -308,14 +325,46 @@ void pm_qos_update_request(struct pm_qos_request *req,
 		return;
 	}
 
-	if (new_value != req->node.prio)
+	if (delayed_work_pending(&req->work))
+		cancel_delayed_work_sync(&req->work);
+
+	req->value = new_value;
+	if (new_value != req->node.prio) {
 		pm_qos_update_target(
 			pm_qos_array[req->pm_qos_class]->constraints,
 			&req->node, PM_QOS_UPDATE_REQ, new_value);
+	}
 }
 EXPORT_SYMBOL_GPL(pm_qos_update_request);
 
 /**
+ * pm_qos_update_request_timeout - modifies an existing qos request temporarily.
+ * @req : handle to list element holding a pm_qos request to use
+ * @new_value: defines the temporal qos request
+ * @timeout: the effective duration of this qos request in jiffies
+ *
+ * After timeout, this qos request is cancelled automatically.
+ */
+void pm_qos_update_request_timeout(struct pm_qos_request *req, s32 new_value,
+				   unsigned long timeout)
+{
+	if (!req)
+		return;
+	if (WARN(!pm_qos_request_active(req),
+		 "pm_qos_update_request_timeout() called for unknown object."))
+		return;
+
+	if (new_value != req->node.prio) {
+		pm_qos_update_target(
+			pm_qos_array[req->pm_qos_class]->constraints,
+			&req->node, PM_QOS_UPDATE_REQ, new_value);
+		if (delayed_work_pending(&req->work))
+			cancel_delayed_work_sync(&req->work);
+		schedule_delayed_work(&req->work, timeout);
+	}
+}
+
+/**
  * pm_qos_remove_request - modifies an existing qos request
  * @req: handle to request list element
  *
@@ -334,6 +383,9 @@ void pm_qos_remove_request(struct pm_qos_request *req)
 		return;
 	}
 
+	if (delayed_work_pending(&req->work))
+		cancel_delayed_work_sync(&req->work);
+
 	pm_qos_update_target(pm_qos_array[req->pm_qos_class]->constraints,
 			     &req->node, PM_QOS_REMOVE_REQ,
 			     PM_QOS_DEFAULT_VALUE);
-- 
1.7.4.1

