Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab0I1MSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:18:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:35447 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab0I1MRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:17:32 -0400
X-IronPort-AV: E=Sophos;i="4.57,247,1283745600"; 
   d="scan'208";a="115729364"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Juan Quintela <quintela@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 05/12] xen: Initialize xenbus for dom0.
Date: Tue, 28 Sep 2010 13:16:51 +0100
Message-Id: <1285676218-26218-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
References: <alpine.DEB.2.00.1009281217540.2864@kaball-desktop>
X-OriginalArrivalTime: 28 Sep 2010 12:17:10.0214 (UTC) FILETIME=[13398E60:01CB5F07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juan Quintela <quintela@redhat.com>

Do initial xenbus/xenstore setup in dom0.  In dom0 we need to actually
allocate the xenstore resources, rather than being given them from
outside.

[ Impact: initialize Xenbus ]

Signed-off-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/xenbus/xenbus_probe.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 29bac51..df0049e 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -798,6 +798,7 @@ device_initcall(xenbus_probe_initcall);
 static int __init xenbus_init(void)
 {
 	int err = 0;
+	unsigned long page = 0;
 
 	DPRINTK("");
 
@@ -818,7 +819,31 @@ static int __init xenbus_init(void)
 	 * Domain0 doesn't have a store_evtchn or store_mfn yet.
 	 */
 	if (xen_initial_domain()) {
-		/* dom0 not yet supported */
+		struct evtchn_alloc_unbound alloc_unbound;
+
+		/* Allocate Xenstore page */
+		page = get_zeroed_page(GFP_KERNEL);
+		if (!page)
+			goto out_error;
+
+		xen_store_mfn = xen_start_info->store_mfn =
+			pfn_to_mfn(virt_to_phys((void *)page) >>
+				   PAGE_SHIFT);
+
+		/* Next allocate a local port which xenstored can bind to */
+		alloc_unbound.dom        = DOMID_SELF;
+		alloc_unbound.remote_dom = 0;
+
+		err = HYPERVISOR_event_channel_op(EVTCHNOP_alloc_unbound,
+						  &alloc_unbound);
+		if (err == -ENOSYS)
+			goto out_error;
+
+		BUG_ON(err);
+		xen_store_evtchn = xen_start_info->store_evtchn =
+			alloc_unbound.port;
+
+		xen_store_interface = mfn_to_virt(xen_store_mfn);
 	} else {
 		if (xen_hvm_domain()) {
 			uint64_t v = 0;
@@ -864,6 +889,8 @@ static int __init xenbus_init(void)
 	bus_unregister(&xenbus_frontend.bus);
 
   out_error:
+	if (page != 0)
+		free_page(page);
 	return err;
 }
 
-- 
1.5.6.5

