Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653Ab1IOMlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:41:35 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:27875 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab1IOMk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:40:56 -0400
X-IronPort-AV: E=Sophos;i="4.68,387,1312171200"; 
   d="scan'208";a="163268208"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 4/6] xen: xen-pciback: use xenbus_map_ring_page() to map rings
Date: Thu, 15 Sep 2011 13:40:09 +0100
Message-ID: <1316090411-22608-5-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>
References: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

xenbus_map_ring_valloc() is deprecated in favour of
xenbus_map_ring_page().

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 drivers/xen/xen-pciback/pciback.h |    1 +
 drivers/xen/xen-pciback/xenbus.c  |    7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/xen-pciback/pciback.h b/drivers/xen/xen-pciback/pciback.h
index a0e131a..956aef9 100644
--- a/drivers/xen/xen-pciback/pciback.h
+++ b/drivers/xen/xen-pciback/pciback.h
@@ -32,6 +32,7 @@ struct xen_pcibk_device {
 	struct xenbus_watch be_watch;
 	u8 be_watching;
 	int evtchn_irq;
+	struct page *ring_page;
 	struct xen_pci_sharedinfo *sh_info;
 	unsigned long flags;
 	struct work_struct op_work;
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index 978d2c6..41bfefc 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -79,7 +79,7 @@ static void xen_pcibk_disconnect(struct xen_pcibk_device *pdev)
 
 	spin_lock(&pdev->dev_lock);
 	if (pdev->sh_info != NULL) {
-		xenbus_unmap_ring_vfree(pdev->xdev, pdev->sh_info);
+		xenbus_unmap_ring_page(pdev->xdev, pdev->ring_page);
 		pdev->sh_info = NULL;
 	}
 	spin_unlock(&pdev->dev_lock);
@@ -107,13 +107,12 @@ static int xen_pcibk_do_attach(struct xen_pcibk_device *pdev, int gnt_ref,
 			     int remote_evtchn)
 {
 	int err = 0;
-	void *vaddr;
 
 	dev_dbg(&pdev->xdev->dev,
 		"Attaching to frontend resources - gnt_ref=%d evtchn=%d\n",
 		gnt_ref, remote_evtchn);
 
-	err = xenbus_map_ring_valloc(pdev->xdev, gnt_ref, &vaddr);
+	err = xenbus_map_ring_page(pdev->xdev, gnt_ref, &pdev->ring_page);
 	if (err < 0) {
 		xenbus_dev_fatal(pdev->xdev, err,
 				"Error mapping other domain page in ours.");
@@ -121,7 +120,7 @@ static int xen_pcibk_do_attach(struct xen_pcibk_device *pdev, int gnt_ref,
 	}
 
 	spin_lock(&pdev->dev_lock);
-	pdev->sh_info = vaddr;
+	pdev->sh_info = page_address(pdev->ring_page);
 	spin_unlock(&pdev->dev_lock);
 
 	err = bind_interdomain_evtchn_to_irqhandler(
-- 
1.7.2.5

