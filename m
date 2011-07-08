Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab1GHVRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:17:14 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:37170 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752947Ab1GHVRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:17:13 -0400
Date: Fri, 8 Jul 2011 14:17:12 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Vmware balloon: switch to using sysem-wide freezable
 workqueue
Message-ID: <20110708211712.GA20258@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the arrival of concurrency-managed workqueues there is no need
for our driver to use dedicated workqueue; system-wide one should
suffice just fine.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 drivers/misc/vmw_balloon.c |   31 +++++++++++--------------------
 1 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 6df5a55..ca72de3 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -45,7 +45,7 @@
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
-MODULE_VERSION("1.2.1.2-k");
+MODULE_VERSION("1.2.1.3-k");
 MODULE_ALIAS("dmi:*:svnVMware*:*");
 MODULE_ALIAS("vmware_vmmemctl");
 MODULE_LICENSE("GPL");
@@ -215,7 +215,6 @@ struct vmballoon {
 };
 
 static struct vmballoon balloon;
-static struct workqueue_struct *vmballoon_wq;
 
 /*
  * Send "start" command to the host, communicating supported version
@@ -674,7 +673,12 @@ static void vmballoon_work(struct work_struct *work)
 			vmballoon_deflate(b);
 	}
 
-	queue_delayed_work(vmballoon_wq, dwork, round_jiffies_relative(HZ));
+	/*
+	 * We are using freezable workqueue so that balloon operations are
+	 * stopped while system transitions to/from sleep/hibernation.
+	*/
+	queue_delayed_work(system_freezable_wq,
+			   dwork, round_jiffies_relative(HZ));
 }
 
 /*
@@ -785,12 +789,6 @@ static int __init vmballoon_init(void)
 	if (x86_hyper != &x86_hyper_vmware)
 		return -ENODEV;
 
-	vmballoon_wq = create_freezable_workqueue("vmmemctl");
-	if (!vmballoon_wq) {
-		pr_err("failed to create workqueue\n");
-		return -ENOMEM;
-	}
-
 	INIT_LIST_HEAD(&balloon.pages);
 	INIT_LIST_HEAD(&balloon.refused_pages);
 
@@ -805,34 +803,27 @@ static int __init vmballoon_init(void)
 	 */
 	if (!vmballoon_send_start(&balloon)) {
 		pr_err("failed to send start command to the host\n");
-		error = -EIO;
-		goto fail;
+		return -EIO;
 	}
 
 	if (!vmballoon_send_guest_id(&balloon)) {
 		pr_err("failed to send guest ID to the host\n");
-		error = -EIO;
-		goto fail;
+		return -EIO;
 	}
 
 	error = vmballoon_debugfs_init(&balloon);
 	if (error)
-		goto fail;
+		return error;
 
-	queue_delayed_work(vmballoon_wq, &balloon.dwork, 0);
+	queue_delayed_work(system_freezable_wq, &balloon.dwork, 0);
 
 	return 0;
-
-fail:
-	destroy_workqueue(vmballoon_wq);
-	return error;
 }
 module_init(vmballoon_init);
 
 static void __exit vmballoon_exit(void)
 {
 	cancel_delayed_work_sync(&balloon.dwork);
-	destroy_workqueue(vmballoon_wq);
 
 	vmballoon_debugfs_exit(&balloon);
 
-- 
1.7.4.1

