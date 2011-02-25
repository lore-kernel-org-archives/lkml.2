Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab1BYRMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:12:39 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:28475 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab1BYRLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:11:32 -0500
X-IronPort-AV: E=Sophos;i="4.62,226,1297054800"; 
   d="scan'208";a="137550342"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy.Fitzhardinge@citrix.com,
        konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 1/6] xen: no need to delay xen_setup_shutdown_event for hvm guests anymore
Date: Fri, 25 Feb 2011 17:11:55 +0000
Message-Id: <1298653920-20299-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop>
References: <alpine.DEB.2.00.1102251651570.19277@kaball-desktop>
X-OriginalArrivalTime: 25 Feb 2011 17:11:27.0455 (UTC) FILETIME=[09B936F0:01CBD50F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Now that xenstore_ready is used correctly for PV on HVM guests too, we
don't need to delay the initialization of xen_setup_shutdown_event
anymore.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
---
 drivers/xen/manage.c       |   17 ++++-------------
 drivers/xen/platform-pci.c |    3 ---
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 2417727..b2a8d78 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -291,27 +291,18 @@ static int shutdown_event(struct notifier_block *notifier,
 	return NOTIFY_DONE;
 }
 
-static int __init __setup_shutdown_event(void)
-{
-	/* Delay initialization in the PV on HVM case */
-	if (xen_hvm_domain())
-		return 0;
-
-	if (!xen_pv_domain())
-		return -ENODEV;
-
-	return xen_setup_shutdown_event();
-}
-
 int xen_setup_shutdown_event(void)
 {
 	static struct notifier_block xenstore_notifier = {
 		.notifier_call = shutdown_event
 	};
+
+	if (!xen_domain())
+		return -ENODEV;
 	register_xenstore_notifier(&xenstore_notifier);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xen_setup_shutdown_event);
 
-subsys_initcall(__setup_shutdown_event);
+subsys_initcall(xen_setup_shutdown_event);
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index afbe041..319dd0a 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -156,9 +156,6 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
 	if (ret)
 		goto out;
 	xenbus_probe(NULL);
-	ret = xen_setup_shutdown_event();
-	if (ret)
-		goto out;
 	return 0;
 
 out:
-- 
1.5.6.5

