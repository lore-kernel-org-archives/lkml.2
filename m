Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030206Ab2HVWdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 18:33:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34552 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030193Ab2HVWcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 18:32:42 -0400
Date: Wed, 22 Aug 2012 15:32:38 -0700
From: Tejun Heo <tj@kernel.org>
To: Julian Andres Klode <jak@jak-linux.org>, Marc Dietrich <marvin24@gmx.de>
Cc: ac100@lists.launchpad.net, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH staging] nvec: use system_nrt_wq instead of custom one
Message-ID: <20120822223238.GO19212@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There isn't much reason to use custom workqueue in nvec.  It can use
system_nrt_wq instead and cancel the two work items on removal.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Marc, I think I'll do this conversion in two steps.  system_nrt_wq ->
system_wq conversion should be trivial after 3.7 merge window.

Thanks.

 drivers/staging/nvec/nvec.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 695ea35..daaef24 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -264,7 +264,7 @@ int nvec_write_async(struct nvec_chip *nvec, const unsigned char *data,
 	list_add_tail(&msg->node, &nvec->tx_data);
 	spin_unlock_irqrestore(&nvec->tx_lock, flags);
 
-	queue_work(nvec->wq, &nvec->tx_work);
+	queue_work(system_nrt_wq, &nvec->tx_work);
 
 	return 0;
 }
@@ -470,7 +470,7 @@ static void nvec_rx_completed(struct nvec_chip *nvec)
 	if (!nvec_msg_is_event(nvec->rx))
 		complete(&nvec->ec_transfer);
 
-	queue_work(nvec->wq, &nvec->rx_work);
+	queue_work(system_nrt_wq, &nvec->rx_work);
 }
 
 /**
@@ -791,13 +791,11 @@ static int __devinit tegra_nvec_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&nvec->tx_data);
 	INIT_WORK(&nvec->rx_work, nvec_dispatch);
 	INIT_WORK(&nvec->tx_work, nvec_request_master);
-	nvec->wq = alloc_workqueue("nvec", WQ_NON_REENTRANT, 2);
 
 	err = devm_gpio_request_one(&pdev->dev, nvec->gpio, GPIOF_OUT_INIT_HIGH,
 					"nvec gpio");
 	if (err < 0) {
 		dev_err(nvec->dev, "couldn't request gpio\n");
-		destroy_workqueue(nvec->wq);
 		return -ENODEV;
 	}
 
@@ -805,7 +803,6 @@ static int __devinit tegra_nvec_probe(struct platform_device *pdev)
 				"nvec", nvec);
 	if (err) {
 		dev_err(nvec->dev, "couldn't request irq\n");
-		destroy_workqueue(nvec->wq);
 		return -ENODEV;
 	}
 	disable_irq(nvec->irq);
@@ -859,7 +856,8 @@ static int __devexit tegra_nvec_remove(struct platform_device *pdev)
 
 	nvec_write_async(nvec, EC_DISABLE_EVENT_REPORTING, 3);
 	mfd_remove_devices(nvec->dev);
-	destroy_workqueue(nvec->wq);
+	cancel_work_sync(&nvec->rx_work);
+	cancel_work_sync(&nvec->tx_work);
 
 	return 0;
 }
