Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab2GIVgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:36:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab2GIVg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:36:28 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 2/8] PCI: release temporary reference in
	__nv_msi_ht_cap_quirk()
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, ralf@linux-mips.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 15:36:08 -0600
Message-ID: <20120709213608.8975.90022.stgit@amt.stowe>
In-Reply-To: <20120709213554.8975.60552.stgit@amt.stowe>
References: <20120709213554.8975.60552.stgit@amt.stowe>
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
index 0f5ca86..8b2d553 100644
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

