Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab2FUU0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:26:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224Ab2FUUYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:24:47 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 2/9] PCI: release temporary reference in
	__nv_msi_ht_cap_quirk()
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, ralf@linux-mips.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 14:24:29 -0600
Message-ID: <20120621202429.16865.86563.stgit@amt.stowe>
In-Reply-To: <20120621202415.16865.6226.stgit@amt.stowe>
References: <20120621202415.16865.6226.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__nv_msi_ht_cap_quirk() acquires a temporary reference via
'pci_get_bus_and_slot()' that is never released.

This patch releases the temporary reference.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/quirks.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 9c93558..1a7effa 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2541,15 +2541,18 @@ static void __devinit __nv_msi_ht_cap_quirk(struct pci_dev *dev, int all)
 			else
 				nv_ht_enable_msi_mapping(dev);
 		}
-		return;
+		goto out;
 	}
 
 	/* HT MSI is not enabled */
 	if (found == 1)
-		return;
+		goto out;
 
 	/* Host bridge is not to HT, disable HT MSI mapping on this device */
 	ht_disable_msi_mapping(dev);
+
+out:
+	pci_dev_put(host_bridge);
 }
 
 static void __devinit nv_msi_ht_cap_quirk_all(struct pci_dev *dev)

