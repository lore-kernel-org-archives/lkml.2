Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab2DOUvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 16:51:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44257 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2DOUvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 16:51:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
Date: Sun, 15 Apr 2012 22:56:02 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204152030.23148.rjw@sisk.pl> <201204152152.56048.rjw@sisk.pl>
In-Reply-To: <201204152152.56048.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204152256.03198.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 15, 2012, Rafael J. Wysocki wrote:
> On Sunday, April 15, 2012, Rafael J. Wysocki wrote:
> > On Sunday, April 15, 2012, Mikko Vinni wrote:
> > > From: Rafael J. Wysocki:
> > > 
> > > >>  > Please change that dev_dbg() in pci_restore_state() into dev_info()
> > > >>  > and see how many times it gets printed with the commit applied (not 
> > > > reverted).
> > > >> 
> > > >> 
> > > >>  I ran the dmesg through "uniq -c" and it looks like this:
> > > >> 
> > > >>        1 ACPI: Low-level resume complete
> > > >>        1 PM: Restoring platform NVS memory
> > > >>        1 Enabling non-boot CPUs ...
> > > >>        1 Booting Node 0 Processor 1 APIC 0x1
> > > >>        1 CPU1 is up
> > > >>        1 ACPI: Waking up from system sleep state S3
> > > >>       10 pcieport 0000:00:02.0: restoring config space at offset 0x7 (was 
> > > > 0x20005151, writing 0x5151)
> > > > 
> > > > Well, yeah.  So the commit you bisected it to is total and utter crap.
> > > > Most importantly, it retries the writes for all of the dwords in the 
> > > > device's
> > > > config space _including_ the status register (which by definition need not be
> > > > the same as the written value).
> > > > 
> > > > I wonder if the appended patch helps?
> > > 
> > > It does. It seems there is a change only in the devices that refuse to wake up;
> > > somehow writing too many times to them affects the rest of the machine.
> > > So, for this machine your patch fixes the problem of the touchpad not working.
> > 
> > Good, thanks for the confirmation. :-)
> > 
> > > The write is now attempted (at most) 11 times, as shown below. Probably not
> > > a huge deal.
> > > 
> > >       1 ACPI: Waking up from system sleep state S3
> > >      11 pcieport 0000:00:02.0: restoring config space at offset 0x1c (was 0x20005151, writing 0x5151)
> > 
> > Well, here you see that the PCI Express port is refusing to accept a new BAR value.
> > It seems not to be operational and this probably is the reason why the device below
> > the port don't respond later.
> > 
> > I'm not sure why that happens, though.
> 
> OK, I know.  There simply are fewer BARs for bridges (and PCIe ports)
> and here we're attempting to overwrite the secondary status register.  Sigh.
> 
> Well, I guess we should only retry the writes to BARs for Type 0 headers.

Which is done by the appended updated patch.  Can you please give it a try?

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI: Fix regression in pci_restore_state(), v4

Commit 26f41062f28de65e11d3cf353e52d0be73442be1

    PCI: check for pci bar restore completion and retry

attempted to address problems with PCI BAR restoration on systems
where FLR had not been completed before pci_restore_state() was
called, but it did that in an utterly wrong way.

First off, instead of retrying the writes for the BAR registers
only, it did that for all of the PCI config space of the device,
including the status registers (whose values after the write quite
obviously need not be the same as the written ones).  Second, it
added arbitrary delay to pci_restore_state() even for systems
where the PCI config space restoration was successful at first
attempt.  Finally, the mdelay(10) it added to every iteration of the
writing loop was way too much of a delay for any reasonable device.

All of this actually caused resume failures for some devices on
the Mikko's system.

To fix the regression, make pci_restore_state() only retry the
writes to BAR registers and only for devices with Type 0 headers.
Moreover, make it wait only if the next first read from the given
register doesn't return the value written to it.  Finally, make it
wait for 1 ms, instead of 10 ms, after every failing attempt to write
into the device's config space.

Reported-by: Mikko Vinni <mmvinni@yahoo.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |   67 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 21 deletions(-)

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
 
@@ -984,24 +1015,18 @@ void pci_restore_state(struct pci_dev *d
 	pci_restore_pcie_state(dev);
 	pci_restore_ats_state(dev);
 
-	/*
-	 * The Base Address register should be programmed before the command
-	 * register(s)
-	 */
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
+	if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL) {
+		pci_restore_config_space(dev, 10, 15, 0);
+		/*
+		 * The Base Address register should be programmed before the
+		 * command register(s)
+		 */
+		pci_restore_config_space(dev, 4, 9, 10);
+		pci_restore_config_space(dev, 0, 3, 0);
+	} else {
+		pci_restore_config_space(dev, 0, 15, 0);
 	}
+
 	pci_restore_pcix_state(dev);
 	pci_restore_msi_state(dev);
 	pci_restore_iov_state(dev);
