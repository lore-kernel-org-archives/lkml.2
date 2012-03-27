Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2C0Gb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 02:31:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58784 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab2C0Gbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 02:31:55 -0400
X-AuditID: cbfee61a-b7c49ae0000061d4-45-4f715ed93f43
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-pm@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Mark Gross <markgross@thegnar.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] PM / QoS: add pm_qos_update_request_timeout API
Date: Tue, 27 Mar 2012 15:31:54 +0900
Message-id: <1332829914-22790-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <CAJ0PZbThSc=WkmeOYtykTKZ7bhBHJa7KYYPeWPLNy_suCD0f+A@mail.gmail.com>
References: <CAJ0PZbThSc=WkmeOYtykTKZ7bhBHJa7KYYPeWPLNy_suCD0f+A@mail.gmail.com>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
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
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Mark Gross <markgross@thegnar.org>

--
Changes from v3
- The timeout value is expresses in us (1/1000000 sec), not ms (1/1000 sec).
Changes from v2
- Rebased to avoid merge conflict
Chages from v1(RFC)
- The semmantics of timeout changed. A timeout now means that the
 corresponding qos-req object is being cancelled, not rolling back to
the qos request state at the time of API call. With this changes,
combined with the conventional update_request API, there exists up to
only one qos request per qos-req object.
- The timeout value is expressed in ms (1/1000 sec), not jiffies.
- Style changes, removing unnecessary changes.
- Bugfixes regarding pending timeout work.
---
 include/linux/pm_qos.h |    4 +++
 kernel/power/qos.c     |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
index c8a541e..18689737 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -8,6 +8,7 @@
 #include <linux/notifier.h>
 #include <linux/miscdevice.h>
 #include <linux/device.h>
+#include <linux/workqueue.h>
 
 enum {
 	PM_QOS_RESERVED = 0,
@@ -29,6 +30,7 @@ enum {
 struct pm_qos_request {
 	struct plist_node node;
 	int pm_qos_class;
+	struct delayed_work work; /* for pm_qos_update_request_timeout */
 };
 
 struct dev_pm_qos_request {
@@ -73,6 +75,8 @@ void pm_qos_add_request(struct pm_qos_request *req, int pm_qos_class,
 			s32 value);
 void pm_qos_update_request(struct pm_qos_request *req,
 			   s32 new_value);
+void pm_qos_update_request_timeout(struct pm_qos_request *req,
+				   s32 new_value, unsigned long timeout_us);
 void pm_qos_remove_request(struct pm_qos_request *req);
 
 int pm_qos_request(int pm_qos_class);
diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index d6d6dbd..6a031e6 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -230,6 +230,21 @@ int pm_qos_request_active(struct pm_qos_request *req)
 EXPORT_SYMBOL_GPL(pm_qos_request_active);
 
 /**
+ * pm_qos_work_fn - the timeout handler of pm_qos_update_request_timeout
+ * @work: work struct for the delayed work (timeout)
+ *
+ * This cancels the timeout request by falling back to the default at timeout.
+ */
+static void pm_qos_work_fn(struct work_struct *work)
+{
+	struct pm_qos_request *req = container_of(to_delayed_work(work),
+						  struct pm_qos_request,
+						  work);
+
+	pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);
+}
+
+/**
  * pm_qos_add_request - inserts new qos request into the list
  * @req: pointer to a preallocated handle
  * @pm_qos_class: identifies which list of qos request to use
@@ -253,6 +268,7 @@ void pm_qos_add_request(struct pm_qos_request *req,
 		return;
 	}
 	req->pm_qos_class = pm_qos_class;
+	INIT_DELAYED_WORK(&req->work, pm_qos_work_fn);
 	pm_qos_update_target(pm_qos_array[pm_qos_class]->constraints,
 			     &req->node, PM_QOS_ADD_REQ, value);
 }
@@ -279,6 +295,9 @@ void pm_qos_update_request(struct pm_qos_request *req,
 		return;
 	}
 
+	if (delayed_work_pending(&req->work))
+		cancel_delayed_work_sync(&req->work);
+
 	if (new_value != req->node.prio)
 		pm_qos_update_target(
 			pm_qos_array[req->pm_qos_class]->constraints,
@@ -287,6 +306,34 @@ void pm_qos_update_request(struct pm_qos_request *req,
 EXPORT_SYMBOL_GPL(pm_qos_update_request);
 
 /**
+ * pm_qos_update_request_timeout - modifies an existing qos request temporarily.
+ * @req : handle to list element holding a pm_qos request to use
+ * @new_value: defines the temporal qos request
+ * @timeout_us: the effective duration of this qos request in usecs.
+ *
+ * After timeout_us, this qos request is cancelled automatically.
+ */
+void pm_qos_update_request_timeout(struct pm_qos_request *req, s32 new_value,
+				   unsigned long timeout_us)
+{
+	if (!req)
+		return;
+	if (WARN(!pm_qos_request_active(req),
+		 "%s called for unknown object.", __func__))
+		return;
+
+	if (delayed_work_pending(&req->work))
+		cancel_delayed_work_sync(&req->work);
+
+	if (new_value != req->node.prio)
+		pm_qos_update_target(
+			pm_qos_array[req->pm_qos_class]->constraints,
+			&req->node, PM_QOS_UPDATE_REQ, new_value);
+
+	schedule_delayed_work(&req->work, usecs_to_jiffies(timeout_us));
+}
+
+/**
  * pm_qos_remove_request - modifies an existing qos request
  * @req: handle to request list element
  *
@@ -305,6 +352,9 @@ void pm_qos_remove_request(struct pm_qos_request *req)
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

