Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab2DOTgK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 15:36:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44182 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab2DOTgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 15:36:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] PCI: Fix regression in pci_restore_state()
Date: Sun, 15 Apr 2012 21:40:40 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, Mikko Vinni <mmvinni@yahoo.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204152047.51019.rjw@sisk.pl> <CA+55aFyShMvUjkyGv4DgSGByuoU18o8=MnGJqbz5aSwDVyOyOA@mail.gmail.com>
In-Reply-To: <CA+55aFyShMvUjkyGv4DgSGByuoU18o8=MnGJqbz5aSwDVyOyOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204152140.40747.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 15, 2012, Linus Torvalds wrote:
> On Sun, Apr 15, 2012 at 11:47 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > mdelay(10) doesn't really look good either to me in this case, though.
> 
> Oh, I agree. What kind of ass-backwards device actually needs that
> kind of crazy delays? It is almost certainly buggy.
> 
> With retries, 10ms delays are totally unacceptable. There's something wrong.
> 
> A single ms *may* be ok.
> 
> Anyway, can you also split the actual "write _one_ register with
> retry" into a function of its own? The code looks like crap with those
> multiple levels of looping, with conditionals inside them etc. With a
> simple helper function, you could change the break into return, and it
> would look much better, I bet.

Sure.  It appears cleaner this way.

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI: Fix regression in pci_restore_state(), v3

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
attempt.  Finally, the mdelay(10) it added to every iteration of the
writing loop was way too much of a delay for any reasonable device.

All of this actually caused resume failures for some devices on
the Mikko's system.

To fix the regression, make pci_restore_state() only retry the
writes for BAR registers and only wait if the first read from
the register doesn't return the written value.  Additionaly, make
it wait for 1 ms, instead of 10 ms, after every failing attempt
to write into config space.

Reported-by: Mikko Vinni <mmvinni@yahoo.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |   57 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 18 deletions(-)

Index: linux/drivers/pci/pci.c
===================================================================
--- linux.orig/drivers/pci/pci.c
+++ linux/drivers/pci/pci.c
@@ -967,16 +967,47 @@ pci_save_state(struct pci_dev *dev)
 	return 0;
 }
 
+static void pci_restore_config_dword(struct pci_dev *pdev, int offset,
+				     u32 saved_val, int retry)
+{
+	u32 val;
+
+	pci_read_config_dword(pdev, offset, &val);
+	if (val == saved_val)
+		return;
+
+	for (;;) {
+		dev_dbg(&pdev->dev, "restoring config space at offset "
+			"%#x (was %#x, writing %#x)\n", offset, val, saved_val);
+		pci_write_config_dword(pdev, offset, saved_val);
+		if (retry-- <= 0)
+			return;
+
+		pci_read_config_dword(pdev, offset, &val);
+		if (val == saved_val)
+			return;
+
+		mdelay(1);
+	}
+}
+
+static void pci_restore_config_space(struct pci_dev *pdev, int start, int end,
+				     int retry)
+{
+	int index;
+
+	for (index = end; index >= start; index--)
+		pci_restore_config_dword(pdev, 4 * index,
+					 pdev->saved_config_space[index],
+					 retry);
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
 
@@ -984,24 +1015,14 @@ void pci_restore_state(struct pci_dev *d
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
