Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2AEAs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:48:29 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:64875 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab2AEAsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:48:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/5] xen/pciback: Fix "device has been assigned to X domain!" warning
Date: Wed,  4 Jan 2012 19:46:43 -0500
Message-Id: <1325724403-29642-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
References: <1325724403-29642-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F04F353.0053,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The full warning is:
"pciback 0000:05:00.0: device has been assigned to 2 domain! Over-writting the ownership, but beware."

which is correct - the previous domain that was using the device
forgot to unregister the ownership. This patch fixes this by
calling the unregister ownership function when the PCI device is
relinquished from the guest domain.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index d66328e..6f63b9d 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -260,6 +260,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	xen_pcibk_config_free_dyn_fields(found_psdev->dev);
 	xen_pcibk_config_reset_dev(found_psdev->dev);
 
+	xen_unregister_device_domain_owner(found_psdev->dev);
+
 	spin_lock_irqsave(&found_psdev->lock, flags);
 	found_psdev->pdev = NULL;
 	spin_unlock_irqrestore(&found_psdev->lock, flags);
-- 
1.7.7.4

