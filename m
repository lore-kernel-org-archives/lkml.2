Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1ATGmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 01:42:55 -0500
Received: from ebb06.tieto.com ([131.207.168.38]:58698 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab1ATGmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 01:42:54 -0500
X-AuditID: 83cfa826-b7bdbae000001a50-10-4d37d96cbf55
Date: Thu, 20 Jan 2011 14:50:40 +0800
From: Yang Ruirui <ruirui.r.yang@tieto.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Hao Wu <hao.wu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Alek Du <alek.du@intel.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb langwell otg: use notifier chain of struct
 otg_transceiver
Message-ID: <20110120065040.GA24879@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use notifier chain in otg_transceiver instead of own notifier chain.

This patch depends on another patch which change otg_transceiver notifier chain to atomic, please see:
https://lkml.org/lkml/2011/1/19/72

Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>
---
 drivers/usb/otg/langwell_otg.c    |    7 +++----
 include/linux/usb/intel_mid_otg.h |   17 -----------------
 2 files changed, 3 insertions(+), 21 deletions(-)

--- linux-2.6.orig/drivers/usb/otg/langwell_otg.c	2010-12-15 15:43:36.000000000 +0800
+++ linux-2.6/drivers/usb/otg/langwell_otg.c	2011-01-20 13:33:28.346040564 +0800
@@ -2124,12 +2124,11 @@ static int langwell_otg_probe(struct pci
 	}
 
 	init_timer(&lnw->hsm_timer);
-	ATOMIC_INIT_NOTIFIER_HEAD(&lnw->iotg.iotg_notifier);
+	ATOMIC_INIT_NOTIFIER_HEAD(&lnw->iotg.otg.notifier);
 
 	lnw->iotg_notifier.notifier_call = langwell_otg_iotg_notify;
 
-	retval = intel_mid_otg_register_notifier(&lnw->iotg,
-						&lnw->iotg_notifier);
+	retval = otg_register_notifier(&lnw->iotg.otg, &lnw->iotg_notifier);
 	if (retval) {
 		dev_dbg(lnw->dev, "Failed to register notifier\n");
 		goto err;
@@ -2187,7 +2186,7 @@ static void langwell_otg_remove(struct p
 		flush_workqueue(lnw->qwork);
 		destroy_workqueue(lnw->qwork);
 	}
-	intel_mid_otg_unregister_notifier(&lnw->iotg, &lnw->iotg_notifier);
+	otg_unregister_notifier(&lnw->iotg.otg, &lnw->iotg_notifier);
 	langwell_otg_free_timers();
 
 	/* disable OTGSC interrupt as OTGSC doesn't change in reset */
--- linux-2.6.orig/include/linux/usb/intel_mid_otg.h	2010-12-15 15:43:38.000000000 +0800
+++ linux-2.6/include/linux/usb/intel_mid_otg.h	2011-01-20 13:23:48.809375229 +0800
@@ -117,9 +117,6 @@ struct intel_mid_otg_xceiv {
 	/* ops to access ulpi */
 	struct iotg_ulpi_access_ops	ulpi_ops;
 
-	/* atomic notifier for interrupt context */
-	struct atomic_notifier_head	iotg_notifier;
-
 	/* start/stop USB Host function */
 	int	(*start_host)(struct intel_mid_otg_xceiv *iotg);
 	int	(*stop_host)(struct intel_mid_otg_xceiv *iotg);
@@ -163,18 +160,4 @@ struct intel_mid_otg_xceiv *otg_to_mid_x
 #define MID_OTG_NOTIFY_CLIENTADD	0x0009
 #define MID_OTG_NOTIFY_CLIENTREMOVE	0x000a
 
-static inline int
-intel_mid_otg_register_notifier(struct intel_mid_otg_xceiv *iotg,
-				struct notifier_block *nb)
-{
-	return atomic_notifier_chain_register(&iotg->iotg_notifier, nb);
-}
-
-static inline void
-intel_mid_otg_unregister_notifier(struct intel_mid_otg_xceiv *iotg,
-				struct notifier_block *nb)
-{
-	atomic_notifier_chain_unregister(&iotg->iotg_notifier, nb);
-}
-
 #endif /* __INTEL_MID_OTG_H */
