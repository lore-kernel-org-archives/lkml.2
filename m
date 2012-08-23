Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273Ab2HWVfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:35:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43937 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab2HWVfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:35:34 -0400
Date: Thu, 23 Aug 2012 14:35:29 -0700
From: Tejun Heo <tj@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pci: rewrite pci_call_probe() to use workqueue instead of
 work_on_cpu()
Message-ID: <20120823213529.GH14962@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_call_probe() uses work_on_cpu(), which creates and tears down a
full kthread on each call, to invoke ->probe() on node local CPU for
allocation affinity.

The same goal can easily be achieved using a work item.  This patch
rewrites pci_call_probe() so that it uses a work item instead of
work_on_cpu().

Note that the function is restructured for simplicity.  This adds
get/put_online_cpus() pair for devices without node but the overhead
of doing so isn't anything material at this level.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
I tested both paths but had to simulate device on foreign node.

Thanks.

 drivers/pci/pci-driver.c |   48 +++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 5270f1a..554c15a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -274,11 +274,14 @@ struct drv_dev_and_id {
 	struct pci_driver *drv;
 	struct pci_dev *dev;
 	const struct pci_device_id *id;
+	struct work_struct work;
+	int error;
 };
 
-static long local_pci_probe(void *_ddi)
+static void pci_probe_fn(struct work_struct *work)
 {
-	struct drv_dev_and_id *ddi = _ddi;
+	struct drv_dev_and_id *ddi = container_of(work, struct drv_dev_and_id,
+						  work);
 	struct device *dev = &ddi->dev->dev;
 	int rc;
 
@@ -298,33 +301,38 @@ static long local_pci_probe(void *_ddi)
 		pm_runtime_set_suspended(dev);
 		pm_runtime_put_noidle(dev);
 	}
-	return rc;
+
+	ddi->error = rc;
 }
 
 static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 			  const struct pci_device_id *id)
 {
-	int error, node;
+	int node;
+	int cpu = nr_cpu_ids;
 	struct drv_dev_and_id ddi = { drv, dev, id };
 
-	/* Execute driver initialization on node where the device's
-	   bus is attached to.  This way the driver likely allocates
-	   its local memory on the right node without any need to
-	   change it. */
-	node = dev_to_node(&dev->dev);
-	if (node >= 0) {
-		int cpu;
+	/*
+	 * Execute driver initialization on node where the device's bus is
+	 * attached to.  This way the driver likely allocates its local
+	 * memory on the right node without any need to change it.
+	 */
+	get_online_cpus();
 
-		get_online_cpus();
+	node = dev_to_node(&dev->dev);
+	if (node >= 0)
 		cpu = cpumask_any_and(cpumask_of_node(node), cpu_online_mask);
-		if (cpu < nr_cpu_ids)
-			error = work_on_cpu(cpu, local_pci_probe, &ddi);
-		else
-			error = local_pci_probe(&ddi);
-		put_online_cpus();
-	} else
-		error = local_pci_probe(&ddi);
-	return error;
+
+	if (cpu < nr_cpu_ids) {
+		INIT_WORK_ONSTACK(&ddi.work, pci_probe_fn);
+		schedule_work_on(cpu, &ddi.work);
+		flush_work(&ddi.work);
+	} else {
+		pci_probe_fn(&ddi.work);
+	}
+
+	put_online_cpus();
+	return ddi.error;
 }
 
 /**
