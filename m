Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2DPVDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:03:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46609 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2DPVDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:03:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] PCI: Retry BARs restoration for Type 0 headers only
Date: Mon, 16 Apr 2012 23:07:50 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, Mikko Vinni <mmvinni@yahoo.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204162235.49901.rjw@sisk.pl> <CA+55aFyccAfEpECmD5yKYE4AquV1ZsfjRAL4coP39LmkAqrO=w@mail.gmail.com>
In-Reply-To: <CA+55aFyccAfEpECmD5yKYE4AquV1ZsfjRAL4coP39LmkAqrO=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204162307.51168.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 16, 2012, Linus Torvalds wrote:
> On Mon, Apr 16, 2012 at 1:35 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Some shortcomings introduced into pci_restore_state() by commit
> > 26f41062f28d ("PCI: check for pci bar restore completion and
> > retry") have been fixed by recent commit ebfc5b802fa76 ("PCI: Fix
> > regression in pci_restore_state(), v3"), but that commit treats
> > all PCI devices as those with Type 0 configuration headers.
> 
> Make me happier and just make all of this a helper function again.
> Call that helper function pci_restore_config_space(), and make the
> existing "pci_restore_config_space()" be called
> "pci_restore_config_space_range()" or something. Ok?

Something like this, you mean?

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI: Retry BARs restoration for Type 0 headers only

Some shortcomings introduced into pci_restore_state() by commit
26f41062f28d ("PCI: check for pci bar restore completion and
retry") have been fixed by recent commit ebfc5b802fa76 ("PCI: Fix
regression in pci_restore_state(), v3"), but that commit treats
all PCI devices as those with Type 0 configuration headers.  That
is not entirely correct, because Type 1 and Type 2 headers have
different layouts.  In particular, the area occupied by BARs in
Type 0 config headers contains the secondary status register in
Type 1 ones and it doesn't make sense to retry the restoration of
that register even if the value read back from it after a write is
not the same as the written one (it very well may be different).

For this reason, make pci_restore_state() only retry the restoration
of BARs for Type 0 config headers.  This effectively makes it behave
as before commit 26f41062f28d for all header types except for Type 0.

Tested-by: Mikko Vinni <mmvinni@yahoo.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

Index: linux/drivers/pci/pci.c
===================================================================
--- linux.orig/drivers/pci/pci.c
+++ linux/drivers/pci/pci.c
@@ -991,8 +991,8 @@ static void pci_restore_config_dword(str
 	}
 }
 
-static void pci_restore_config_space(struct pci_dev *pdev, int start, int end,
-				     int retry)
+static void pci_restore_config_space_range(struct pci_dev *pdev,
+					   int start, int end, int retry)
 {
 	int index;
 
@@ -1002,6 +1002,18 @@ static void pci_restore_config_space(str
 					 retry);
 }
 
+static void pci_restore_config_space(struct pci_dev *pdev)
+{
+	if (pdev->hdr_type == PCI_HEADER_TYPE_NORMAL) {
+		pci_restore_config_space_range(pdev, 10, 15, 0);
+		/* Restore BARs before the command register. */
+		pci_restore_config_space_range(pdev, 4, 9, 10);
+		pci_restore_config_space_range(pdev, 0, 3, 0);
+	} else {
+		pci_restore_config_space_range(pdev, 0, 15, 0);
+	}
+}
+
 /** 
  * pci_restore_state - Restore the saved state of a PCI device
  * @dev: - PCI device that we're dealing with
@@ -1015,13 +1027,7 @@ void pci_restore_state(struct pci_dev *d
 	pci_restore_pcie_state(dev);
 	pci_restore_ats_state(dev);
 
-	pci_restore_config_space(dev, 10, 15, 0);
-	/*
-	 * The Base Address register should be programmed before the command
-	 * register(s)
-	 */
-	pci_restore_config_space(dev, 4, 9, 10);
-	pci_restore_config_space(dev, 0, 3, 0);
+	pci_restore_config_space(dev);
 
 	pci_restore_pcix_state(dev);
 	pci_restore_msi_state(dev);
