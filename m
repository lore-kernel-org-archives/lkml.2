Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0LLPxe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 10:53:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:56559 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab0LLPxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 10:53:24 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc: Tejun Heo <tj@kernel.org>, Breno Leitao <leitao@linux.vnet.ibm.com>
Subject: [PATCH 4/9] ehea: don't use flush_scheduled_work()
Date: Sun, 12 Dec 2010 16:53:00 +0100
Message-Id: <1292169185-10579-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292169185-10579-1-git-send-email-tj@kernel.org>
References: <1292169185-10579-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Dec 2010 15:53:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Directly cancel port->reset_task from ehea_shutdown_single_port()
instead.  As this cancels the work for each port on driver detach,
flushing system_wq from ehea_remove() or ehea_module_exit() is no
longer necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/ehea/ehea_main.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index d51def1..81e5b7b 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -3318,6 +3318,8 @@ out_err:
 static void ehea_shutdown_single_port(struct ehea_port *port)
 {
 	struct ehea_adapter *adapter = port->adapter;
+
+	cancel_work_sync(&port->reset_task);
 	unregister_netdev(port->netdev);
 	ehea_unregister_port(port);
 	kfree(port->mc_list);
@@ -3607,8 +3609,6 @@ static int __devexit ehea_remove(struct platform_device *dev)
 
 	ehea_remove_device_sysfs(dev);
 
-	flush_scheduled_work();
-
 	ibmebus_free_irq(adapter->neq->attr.ist1, adapter);
 	tasklet_kill(&adapter->neq_tasklet);
 
@@ -3797,7 +3797,6 @@ static void __exit ehea_module_exit(void)
 {
 	int ret;
 
-	flush_scheduled_work();
 	driver_remove_file(&ehea_driver.driver, &driver_attr_capabilities);
 	ibmebus_unregister_driver(&ehea_driver);
 	unregister_reboot_notifier(&ehea_reboot_nb);
-- 
1.7.1

