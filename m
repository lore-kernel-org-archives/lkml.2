Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab1KKRHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:07:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286Ab1KKRG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:06:59 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/2] PCI: Enable is not exposed as a PASID capability
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        joerg.roedel@amd.com, bhelgaas@google.com
Date: Fri, 11 Nov 2011 10:06:56 -0700
Message-ID: <20111111170629.32668.44205.stgit@bling.home>
In-Reply-To: <20111111170319.32668.48479.stgit@bling.home>
References: <20111111170319.32668.48479.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PASID ECN indicates bit 0 is reserved in the capability register.
Switch pci_enable_pasid() to error if PASID is already enabled and
don't expose enable as a feature in pci_pasid_features().

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/ats.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index 831e192..8e95a12 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -348,7 +348,7 @@ int pci_enable_pasid(struct pci_dev *pdev, int features)
 	pci_read_config_word(pdev, pos + PCI_PASID_CONTROL_OFF, &control);
 	pci_read_config_word(pdev, pos + PCI_PASID_CAP_OFF,     &supported);
 
-	if (!(supported & PCI_PASID_ENABLE))
+	if (control & PCI_PASID_ENABLE)
 		return -EINVAL;
 
 	supported &= PCI_PASID_EXEC | PCI_PASID_PRIV;
@@ -390,7 +390,6 @@ EXPORT_SYMBOL_GPL(pci_disable_pasid);
  * Returns a negative value when no PASI capability is present.
  * Otherwise is returns a bitmask with supported features. Current
  * features reported are:
- * PCI_PASID_ENABLE - PASID capability can be enabled
  * PCI_PASID_EXEC - Execute permission supported
  * PCI_PASID_PRIV - Priviledged mode supported
  */
@@ -405,7 +404,7 @@ int pci_pasid_features(struct pci_dev *pdev)
 
 	pci_read_config_word(pdev, pos + PCI_PASID_CAP_OFF, &supported);
 
-	supported &= PCI_PASID_ENABLE | PCI_PASID_EXEC | PCI_PASID_PRIV;
+	supported &= PCI_PASID_EXEC | PCI_PASID_PRIV;
 
 	return supported;
 }

