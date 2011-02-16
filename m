Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab1BPAiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:38:12 -0500
Received: from kroah.org ([198.145.64.141]:49558 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab1BPAX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:57 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:45 2011
Message-Id: <20110216001445.848172974@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        openipmi-developer@lists.sourceforge.net,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [207/272] char/ipmi: fix OOPS caused by pnp_unregister_driver on unregistered driver
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Corey Minyard <minyard@acm.org>

commit d2478521afc20227658a10a8c5c2bf1a2aa615b3 upstream.

This patch fixes an OOPS triggered when calling modprobe ipmi_si a
second time after the first modprobe returned without finding any ipmi
devices.  This can happen if you reload the module after having the
first module load fail.  The driver was not deregistering from PNP in
that case.

Peter Huewe originally reported this patch and supplied a fix, I have a
different patch based on Linus' suggestion that cleans things up a bit
more.

Cc: openipmi-developer@lists.sourceforge.net
Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/ipmi/ipmi_si_intf.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -320,6 +320,7 @@ static int unload_when_empty = 1;
 static int add_smi(struct smi_info *smi);
 static int try_smi_init(struct smi_info *smi);
 static void cleanup_one_si(struct smi_info *to_clean);
+static void cleanup_ipmi_si(void);
 
 static ATOMIC_NOTIFIER_HEAD(xaction_notifier_list);
 static int register_xaction_notifier(struct notifier_block *nb)
@@ -3435,16 +3436,7 @@ static int __devinit init_ipmi_si(void)
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


