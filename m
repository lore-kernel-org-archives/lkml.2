Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2JRKEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:04:06 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:15884 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab2JRKEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:04:04 -0400
X-IronPort-AV: E=Sophos;i="4.80,606,1344211200"; 
   d="scan'208";a="211697512"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xen.org
CC: "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3/5] xen-pcifront: handle backend CLOSED without CLOSING
Date: Thu, 18 Oct 2012 11:03:36 +0100
Message-ID: <1350554618-14582-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <507FD39F.4060601@citrix.com>
References: <507FD39F.4060601@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Backend drivers shouldn't transistion to CLOSED unless the frontend is
CLOSED.  If a backend does transition to CLOSED too soon then the
frontend may not see the CLOSING state and will not properly shutdown.

So, treat an unexpected backend CLOSED state the same as CLOSING.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
Cc: linux-pci@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/xen-pcifront.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 0aab85a..a0c7312 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -1068,13 +1068,16 @@ static void __init_refok pcifront_backend_changed(struct xenbus_device *xdev,
 	case XenbusStateInitialising:
 	case XenbusStateInitWait:
 	case XenbusStateInitialised:
-	case XenbusStateClosed:
 		break;
 
 	case XenbusStateConnected:
 		pcifront_try_connect(pdev);
 		break;
 
+	case XenbusStateClosed:
+		if (xdev->state == XenbusStateClosed)
+			break;
+		/* Missed the backend's CLOSING state -- fallthrough */
 	case XenbusStateClosing:
 		dev_warn(&xdev->dev, "backend going away!\n");
 		pcifront_try_disconnect(pdev);
-- 
1.7.2.5

