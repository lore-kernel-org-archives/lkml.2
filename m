Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab1GMROk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 13:14:40 -0400
Received: from sous-sol.org ([216.99.217.87]:40249 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932216Ab1GMROi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 13:14:38 -0400
Date: Wed, 13 Jul 2011 10:14:33 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>
Subject: [PATCH resend] pci: ARI is a PCIe v2 feature
Message-ID: <20110713171433.GU15844@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function pci_enable_ari() may mistakenly set the downstream port
of a v1 PCIe switch in ARI Forwarding mode.  This is a PCIe v2 feature,
and with an SR-IOV device on that switch port believing the switch above
is ARI capable it may attempt to use functions 8-255, translating into
invalid (non-zero) device numbers for that bus.  This has been seen
to cause Completion Timeouts and general misbehaviour including hangs
and panics.

Cc: stable@kernel.org
Acked-by: Don Dutile <ddutile@redhat.com>
Tested-by: Don Dutile <ddutile@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 drivers/pci/pci.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 2c5b9b9..7f83236 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1905,7 +1905,7 @@ void pci_enable_ari(struct pci_dev *dev)
 {
 	int pos;
 	u32 cap;
-	u16 ctrl;
+	u16 flags, ctrl;
 	struct pci_dev *bridge;
 
 	if (!pci_is_pcie(dev) || dev->devfn)
@@ -1923,6 +1923,11 @@ void pci_enable_ari(struct pci_dev *dev)
 	if (!pos)
 		return;
 
+	/* ARI is a PCIe v2 feature */
+	pci_read_config_word(bridge, pos + PCI_EXP_FLAGS, &flags);
+	if ((flags & PCI_EXP_FLAGS_VERS) < 2)
+		return;
+
 	pci_read_config_dword(bridge, pos + PCI_EXP_DEVCAP2, &cap);
 	if (!(cap & PCI_EXP_DEVCAP2_ARI))
 		return;
