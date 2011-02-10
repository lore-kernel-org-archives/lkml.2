Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab1BJWIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 17:08:54 -0500
Received: from vms173011pub.verizon.net ([206.46.173.11]:56675 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab1BJWIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 17:08:53 -0500
Date: Thu, 10 Feb 2011 16:08:38 -0600
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Torvalds <torvalds@linux-foundation.org>
Cc: stable@kernel.org, openipmi-developer@lists.sourceforge.net,
        Peter Huewe <peterhuewe@gmx.de>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] char/ipmi: fix OOPS caused by pnp_unregister_driver on
 unregistered driver
Message-id: <20110210220838.GA25539@mail.minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an OOPS triggered when calling modprobe ipmi_si a
second time after the first modprobe returned without finding any ipmi
devices.  This can happen if you reload the module after having the
first module load fail.  The driver was not deregistering from
PNP in that case.

Peter Huewe originally reported this patch and supplied a fix, I have
a different patch based on Linus' suggestion that cleans things up a
bit more.

KernelVersion: 2.6.37
Cc: <stable@kernel.org>
Cc: <openipmi-developer@lists.sourceforge.net>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index b6ae6e9..7855f9f 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -320,6 +320,7 @@ static int unload_when_empty = 1;
 static int add_smi(struct smi_info *smi);
 static int try_smi_init(struct smi_info *smi);
 static void cleanup_one_si(struct smi_info *to_clean);
+static void cleanup_ipmi_si(void);
 
 static ATOMIC_NOTIFIER_HEAD(xaction_notifier_list);
 static int register_xaction_notifier(struct notifier_block *nb)
@@ -3450,16 +3451,7 @@ static int __devinit init_ipmi_si(void)
 	mutex_lock(&smi_infos_lock);
 	if (unload_when_empty && list_empty(&smi_infos)) {
 		mutex_unlock(&smi_infos_lock);
-#ifdef CONFIG_PCI
-		if (pci_registered)
-			pci_unregister_driver(&ipmi_pci_driver);
-#endif
-
-#ifdef CONFIG_PPC_OF
-		if (of_registered)
-			of_unregister_platform_driver(&ipmi_of_platform_driver);
-#endif
-		driver_unregister(&ipmi_driver.driver);
+		cleanup_ipmi_si();
 		printk(KERN_WARNING PFX
 		       "Unable to find any System Interface(s)\n");
 		return -ENODEV;
-- 
1.6.3.3.333.gdf68

