Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab2DOS2G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 14:28:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44098 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab2DOS2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 14:28:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] PCI: Fix regression in pci_restore_state()
Date: Sun, 15 Apr 2012 20:32:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Mikko Vinni <mmvinni@yahoo.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204150011.53556.rjw@sisk.pl> <1334486385.82898.YahooMailNeo@web161803.mail.bf1.yahoo.com>
In-Reply-To: <1334486385.82898.YahooMailNeo@web161803.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204152032.36770.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 26f41062f28de65e11d3cf353e52d0be73442be1

    PCI: check for pci bar restore completion and retry

attempted to address problems with PCI BAR restoration on systems
where FLR had not been completed before pci_restore_state() was
called, but it did that in an utterly wrong way.

First off, instead of retrying the writes for the BAR registers
only, it did that for all of the PCI config space of the device,
including the status register (whose value after the write quite
obviously need not be the same as the written one).  Second, it
added arbitrary delay to pci_restore_state() even for systems
where the PCI config space restoration was successful at first
attempt.  Finally, it used mdelay() for that, although there's
no rule stating that pci_restore_state() could not sleep (at least
I'm not aware of such a rule).

All of this actually caused resume failures for some devices on
the Mikko's system.

To fix the regression, make pci_restore_state() only retry the
writes for BAR registers and only wait if the first read from
the register doesn't return the written value.  Additionally, make
it use msleep() instead of mdelay() for waiting.

Reported-and-tested-by: Mikko Vinni <mmvinni@yahoo.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |   50 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 18 deletions(-)

Index: linux/drivers/pci/pci.c
===================================================================
--- linux.orig/drivers/pci/pci.c
+++ linux/drivers/pci/pci.c
@@ -967,16 +967,40 @@ pci_save_state(struct pci_dev *dev)
 	return 0;
 }
 
+static void pci_restore_config_space(struct pci_dev *pdev, int start, int end,
+				     int retry)
+{
+	int index;
+
+	for (index = end; index >= start; index--) {
+		u32 val, saved;
+		int offset = 4 * index;
+		int count = retry;
+
+		saved = pdev->saved_config_space[index];
+		pci_read_config_dword(pdev, offset, &val);
+		while (saved != val) {
+			dev_dbg(&pdev->dev, "restoring config space at offset "
+				"%#x (was %#x, writing %#x)\n",
+				offset, val, saved);
+			pci_write_config_dword(pdev, offset, saved);
+			if (count-- > 0) {
+				pci_read_config_dword(pdev, offset, &val);
+				if (saved != val)
+					msleep(10);
+			} else {
+				break;
+			}
+		}
+	}
+}
+
 /** 
  * pci_restore_state - Restore the saved state of a PCI device
  * @dev: - PCI device that we're dealing with
  */
 void pci_restore_state(struct pci_dev *dev)
 {
-	int i;
-	u32 val;
-	int tries;
-
 	if (!dev->state_saved)
 		return;
 
@@ -984,24 +1008,14 @@ void pci_restore_state(struct pci_dev *d
 	pci_restore_pcie_state(dev);
 	pci_restore_ats_state(dev);
 
+	pci_restore_config_space(dev, 10, 15, 0);
 	/*
 	 * The Base Address register should be programmed before the command
 	 * register(s)
 	 */
-	for (i = 15; i >= 0; i--) {
-		pci_read_config_dword(dev, i * 4, &val);
-		tries = 10;		
-		while (tries && val != dev->saved_config_space[i]) {
-			dev_dbg(&dev->dev, "restoring config "
-				"space at offset %#x (was %#x, writing %#x)\n",
-				i, val, (int)dev->saved_config_space[i]);
-			pci_write_config_dword(dev,i * 4,
-				dev->saved_config_space[i]);
-			pci_read_config_dword(dev, i * 4, &val);
-			mdelay(10);
-			tries--;
-		}
-	}
+	pci_restore_config_space(dev, 4, 9, 10);
+	pci_restore_config_space(dev, 0, 3, 0);
+
 	pci_restore_pcix_state(dev);
 	pci_restore_msi_state(dev);
 	pci_restore_iov_state(dev);
