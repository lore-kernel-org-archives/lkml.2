Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0DTSli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 14:41:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab0DTSle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 14:41:34 -0400
From: Matthew Garrett <mjg@redhat.com>
To: minyard@acm.org
Cc: openipmi-developer@lists.sourceforge.net, bjorn.helgaas@hp.com,
       linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] ipmi: Split device discovery and registration
Date: Tue, 20 Apr 2010 14:40:26 -0400
Message-Id: <1271788828-10231-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ipmi spec indicates that we should only make use of one si per bmc,
so separate device discovery and registration to make that possible.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |  115 +++++++++++++++++++++++++-------------
 1 files changed, 75 insertions(+), 40 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 4462b11..d2bdf92 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -300,6 +300,7 @@ static int num_max_busy_us;
 
 static int unload_when_empty = 1;
 
+static int add_smi(struct smi_info *smi);
 static int try_smi_init(struct smi_info *smi);
 static void cleanup_one_si(struct smi_info *to_clean);
 
@@ -1777,7 +1778,9 @@ static int hotmod_handler(const char *val, struct kernel_param *kp)
 				info->irq_setup = std_irq_setup;
 			info->slave_addr = ipmb;
 
-			try_smi_init(info);
+			if (!add_smi(info))
+				if (try_smi_init(info))
+					cleanup_one_si(info);
 		} else {
 			/* remove */
 			struct smi_info *e, *tmp_e;
@@ -1863,7 +1866,9 @@ static __devinit void hardcode_find_bmc(void)
 			info->irq_setup = std_irq_setup;
 		info->slave_addr = slave_addrs[i];
 
-		try_smi_init(info);
+		if (!add_smi(info))
+			if (try_smi_init(info))
+				cleanup_one_si(info);
 	}
 }
 
@@ -2061,7 +2066,7 @@ static __devinit int try_init_spmi(struct SPMITable *spmi)
 	}
 	info->io.addr_data = spmi->addr.address;
 
-	try_smi_init(info);
+	add_smi(info);
 
 	return 0;
 }
@@ -2159,7 +2164,7 @@ static int __devinit ipmi_pnp_probe(struct pnp_dev *dev,
 	info->dev = &acpi_dev->dev;
 	pnp_set_drvdata(dev, info);
 
-	return try_smi_init(info);
+	return add_smi(info);
 
 err_free:
 	kfree(info);
@@ -2318,7 +2323,7 @@ static __devinit void try_init_dmi(struct dmi_ipmi_data *ipmi_data)
 	if (info->irq)
 		info->irq_setup = std_irq_setup;
 
-	try_smi_init(info);
+	add_smi(info);
 }
 
 static void __devinit dmi_find_bmc(void)
@@ -2421,7 +2426,7 @@ static int __devinit ipmi_pci_probe(struct pci_dev *pdev,
 	info->dev = &pdev->dev;
 	pci_set_drvdata(pdev, info);
 
-	return try_smi_init(info);
+	return add_smi(info);
 }
 
 static void __devexit ipmi_pci_remove(struct pci_dev *pdev)
@@ -2534,7 +2539,7 @@ static int __devinit ipmi_of_probe(struct of_device *dev,
 
 	dev_set_drvdata(&dev->dev, info);
 
-	return try_smi_init(info);
+	return add_smi(info);
 }
 
 static int __devexit ipmi_of_remove(struct of_device *dev)
@@ -2960,14 +2965,17 @@ static __devinit void default_find_bmc(void)
 		info->io.regsize = DEFAULT_REGSPACING;
 		info->io.regshift = 0;
 
-		if (try_smi_init(info) == 0) {
-			/* Found one... */
-			printk(KERN_INFO "ipmi_si: Found default %s state"
-			       " machine at %s address 0x%lx\n",
-			       si_to_str[info->si_type],
-			       addr_space_to_str[info->io.addr_type],
-			       info->io.addr_data);
-			return;
+		if (add_smi(info) == 0) {
+			if ((try_smi_init(info)) == 0) {
+				/* Found one... */
+				printk(KERN_INFO "ipmi_si: Found default %s"
+				" state machine at %s address 0x%lx\n",
+				si_to_str[info->si_type],
+				addr_space_to_str[info->io.addr_type],
+				info->io.addr_data);
+			} else {
+				cleanup_one_si(info);
+			}
 		}
 	}
 }
@@ -2986,9 +2994,36 @@ static int is_new_interface(struct smi_info *info)
 	return 1;
 }
 
+static int add_smi(struct smi_info *new_smi)
+{
+	int rv = 0;
+
+	printk(KERN_INFO "ipmi_si: Adding %s-specified %s state machine",
+			new_smi->addr_source, si_to_str[new_smi->si_type]);
+	mutex_lock(&smi_infos_lock);
+	if (!is_new_interface(new_smi)) {
+		printk(KERN_CONT ": duplicate interface\n");
+		rv = -EBUSY;
+		goto out_err;
+	}
+
+	printk(KERN_CONT "\n");
+
+	/* So we know not to free it unless we have allocated one. */
+	new_smi->intf = NULL;
+	new_smi->si_sm = NULL;
+	new_smi->handlers = NULL;
+
+	list_add_tail(&new_smi->link, &smi_infos);
+
+out_err:
+	mutex_unlock(&smi_infos_lock);
+	return rv;
+}
+
 static int try_smi_init(struct smi_info *new_smi)
 {
-	int rv;
+	int rv = 0;
 	int i;
 
 	if (new_smi->addr_source) {
@@ -3002,18 +3037,6 @@ static int try_smi_init(struct smi_info *new_smi)
 		       new_smi->slave_addr, new_smi->irq);
 	}
 
-	mutex_lock(&smi_infos_lock);
-	if (!is_new_interface(new_smi)) {
-		printk(KERN_WARNING "ipmi_si: duplicate interface\n");
-		rv = -EBUSY;
-		goto out_err;
-	}
-
-	/* So we know not to free it unless we have allocated one. */
-	new_smi->intf = NULL;
-	new_smi->si_sm = NULL;
-	new_smi->handlers = NULL;
-
 	switch (new_smi->si_type) {
 	case SI_KCS:
 		new_smi->handlers = &kcs_smi_handlers;
@@ -3174,8 +3197,6 @@ static int try_smi_init(struct smi_info *new_smi)
 		goto out_err_stop_timer;
 	}
 
-	list_add_tail(&new_smi->link, &smi_infos);
-
 	mutex_unlock(&smi_infos_lock);
 
 	printk(KERN_INFO "IPMI %s interface initialized\n",
@@ -3188,11 +3209,17 @@ static int try_smi_init(struct smi_info *new_smi)
 	wait_for_timer_and_thread(new_smi);
 
  out_err:
-	if (new_smi->intf)
+	new_smi->interrupt_disabled = 1;
+
+	if (new_smi->intf) {
 		ipmi_unregister_smi(new_smi->intf);
+		new_smi->intf = NULL;
+	}
 
-	if (new_smi->irq_cleanup)
+	if (new_smi->irq_cleanup) {
 		new_smi->irq_cleanup(new_smi);
+		new_smi->irq_cleanup = NULL;
+	}
 
 	/*
 	 * Wait until we know that we are out of any interrupt
@@ -3205,16 +3232,21 @@ static int try_smi_init(struct smi_info *new_smi)
 		if (new_smi->handlers)
 			new_smi->handlers->cleanup(new_smi->si_sm);
 		kfree(new_smi->si_sm);
+		new_smi->si_sm = NULL;
 	}
-	if (new_smi->addr_source_cleanup)
+	if (new_smi->addr_source_cleanup) {
 		new_smi->addr_source_cleanup(new_smi);
-	if (new_smi->io_cleanup)
+		new_smi->addr_source_cleanup = NULL;
+	}
+	if (new_smi->io_cleanup) {
 		new_smi->io_cleanup(new_smi);
+		new_smi->io_cleanup = NULL;
+	}
 
-	if (new_smi->dev_registered)
+	if (new_smi->dev_registered) {
 		platform_device_unregister(new_smi->pdev);
-
-	kfree(new_smi);
+		new_smi->dev_registered = 0;
+	}
 
 	mutex_unlock(&smi_infos_lock);
 
@@ -3317,7 +3349,7 @@ module_init(init_ipmi_si);
 
 static void cleanup_one_si(struct smi_info *to_clean)
 {
-	int           rv;
+	int           rv = 0;
 	unsigned long flags;
 
 	if (!to_clean)
@@ -3361,14 +3393,17 @@ static void cleanup_one_si(struct smi_info *to_clean)
 		schedule_timeout_uninterruptible(1);
 	}
 
-	rv = ipmi_unregister_smi(to_clean->intf);
+	if (to_clean->intf)
+		rv = ipmi_unregister_smi(to_clean->intf);
+
 	if (rv) {
 		printk(KERN_ERR
 		       "ipmi_si: Unable to unregister device: errno=%d\n",
 		       rv);
 	}
 
-	to_clean->handlers->cleanup(to_clean->si_sm);
+	if (to_clean->handlers)
+		to_clean->handlers->cleanup(to_clean->si_sm);
 
 	kfree(to_clean->si_sm);
 
-- 
1.6.5.2

