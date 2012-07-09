Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2GISUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:20:23 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:49935 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab2GISUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:20:20 -0400
Subject: [PATCH 1/2] PCI: leave MEM and IO decoding disabled during 64-bit BAR
	sizing, too
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Robert Hancock <hancockrwd@gmail.com>
Date: Mon, 09 Jul 2012 12:20:18 -0600
Message-ID: <20120709182018.18165.98339.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20120709181745.18165.93914.stgit@bhelgaas.mtv.corp.google.com>
References: <20120709181745.18165.93914.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After 253d2e5498, we disable MEM and IO decoding for most devices while we
size 32-bit BARs.  However, we restore the original COMMAND register before
we size the upper 32 bits of 64-bit BARs, so we can still cause a conflict.

This patch waits to restore the original COMMAND register until we're
completely finished sizing the BAR.

Reference: https://lkml.org/lkml/2007/8/25/154
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 658ac97..66b3a6f 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -152,9 +152,6 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 	pci_read_config_dword(dev, pos, &sz);
 	pci_write_config_dword(dev, pos, l);
 
-	if (!dev->mmio_always_on)
-		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
-
 	/*
 	 * All bits set in sz means the device isn't working properly.
 	 * If the BAR isn't implemented, all bits must be 0.  If it's a
@@ -239,6 +236,9 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 	}
 
  out:
+	if (!dev->mmio_always_on)
+		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
+
 	return (res->flags & IORESOURCE_MEM_64) ? 1 : 0;
  fail:
 	res->flags = 0;

