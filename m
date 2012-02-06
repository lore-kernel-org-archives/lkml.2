Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2BFHcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:32:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:54923 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab2BFHcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:32:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121267493"
From: Huang Ying <ying.huang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>,
        Huang Ying <ying.huang@intel.com>
Subject: [RFC 1/5] pm, runtime, Add resume notifier
Date: Mon,  6 Feb 2012 15:32:24 +0800
Message-Id: <1328513548-19786-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
References: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asynchronous interface is provided for runtime PM, when the requested
action (suspend/resume) is completed, the caller may need to be
notified.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/base/power/runtime.c |    1 +
 include/linux/pm.h           |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -733,6 +733,7 @@ static int rpm_resume(struct device *dev
 			atomic_inc(&parent->power.child_count);
 	}
 	wake_up_all(&dev->power.wait_queue);
+	atomic_notifier_call_chain(&dev->power.notifier, RPM_REQ_RESUME, dev);
 
 	if (!retval)
 		rpm_idle(dev, RPM_ASYNC);
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -27,6 +27,7 @@
 #include <linux/wait.h>
 #include <linux/timer.h>
 #include <linux/completion.h>
+#include <linux/notifier.h>
 
 /*
  * Callbacks for platform drivers to implement.
@@ -488,6 +489,7 @@ struct dev_pm_info {
 	unsigned long		timer_expires;
 	struct work_struct	work;
 	wait_queue_head_t	wait_queue;
+	struct atomic_notifier_head notifier;
 	atomic_t		usage_count;
 	atomic_t		child_count;
 	unsigned int		disable_depth:3;
