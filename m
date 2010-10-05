Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab0JEMu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:50:56 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:15680 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab0JEMuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:50:55 -0400
X-IronPort-AV: E=Sophos;i="4.57,284,1283745600"; 
   d="scan'208";a="116690265"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 1/2] xen: do not set xenstored_ready before xenbus_probe on hvm
Date: Tue,  5 Oct 2010 13:50:57 +0100
Message-Id: <1286283058-12011-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1010051243300.2440@kaball-desktop>
References: <alpine.DEB.2.00.1010051243300.2440@kaball-desktop>
X-OriginalArrivalTime: 05 Oct 2010 12:50:35.0596 (UTC) FILETIME=[E76AD0C0:01CB648B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Register_xenstore_notifier should guarantee that the caller gets
notified even if xenstore is already up.
Therefore we revert "do not notify callers from
register_xenstore_notifier" and set xenstored_read at the right time for
PV on HVM guests too.
In fact in case of PV on HVM guests xenstored is ready only after the
platform pci driver has completed the initialization, so do not set
xenstored_ready before the call to xenbus_probe().

This patch fixes a shutdown_event watcher registration bug that causes
"xm shutdown" not to work properly.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
---
 drivers/xen/xenbus/xenbus_probe.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 29bac51..d409495 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -755,7 +755,10 @@ int register_xenstore_notifier(struct notifier_block *nb)
 {
 	int ret = 0;
 
-	blocking_notifier_chain_register(&xenstore_chain, nb);
+	if (xenstored_ready > 0)
+		ret = nb->notifier_call(nb, 0, NULL);
+	else
+		blocking_notifier_chain_register(&xenstore_chain, nb);
 
 	return ret;
 }
@@ -769,7 +772,7 @@ EXPORT_SYMBOL_GPL(unregister_xenstore_notifier);
 
 void xenbus_probe(struct work_struct *unused)
 {
-	BUG_ON((xenstored_ready <= 0));
+	xenstored_ready = 1;
 
 	/* Enumerate devices in xenstore and watch for changes. */
 	xenbus_probe_devices(&xenbus_frontend);
@@ -835,8 +838,8 @@ static int __init xenbus_init(void)
 			xen_store_evtchn = xen_start_info->store_evtchn;
 			xen_store_mfn = xen_start_info->store_mfn;
 			xen_store_interface = mfn_to_virt(xen_store_mfn);
+			xenstored_ready = 1;
 		}
-		xenstored_ready = 1;
 	}
 
 	/* Initialize the interface to xenstore. */
-- 
1.5.6.5

