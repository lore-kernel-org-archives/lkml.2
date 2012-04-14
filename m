Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab2DNWHX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 18:07:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388Ab2DNWHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 18:07:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
Date: Sun, 15 Apr 2012 00:11:53 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204132219.23106.rjw@sisk.pl> <1334350068.79333.YahooMailNeo@web161804.mail.bf1.yahoo.com>
In-Reply-To: <1334350068.79333.YahooMailNeo@web161804.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204150011.53556.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday, April 13, 2012, Mikko Vinni wrote:
> From: Rafael J. Wysocki:
> 
> > On Friday, April 13, 2012, Mikko Vinni wrote:
> >>  From: Rafael J. Wysocki:
> >> 
> >>  > On Friday, April 13, 2012, Mikko Vinni wrote:
> >>  >>  Bug report:
> >>  >>    https://bugzilla.kernel.org/show_bug.cgi?id=43099
> >>  >> 
> 
> ^^^ some of the home-work is already there, including dmesg with and without the patch
> with PCI debug on, which hopefully does the same as dev_info
> 
> > 
> > Please change that dev_dbg() in pci_restore_state() into dev_info()
> > and see how many times it gets printed with the commit applied (not reverted).
> 
> 
> I ran the dmesg through "uniq -c" and it looks like this:
> 
>       1 ACPI: Low-level resume complete
>       1 PM: Restoring platform NVS memory
>       1 Enabling non-boot CPUs ...
>       1 Booting Node 0 Processor 1 APIC 0x1
>       1 CPU1 is up
>       1 ACPI: Waking up from system sleep state S3
>      10 pcieport 0000:00:02.0: restoring config space at offset 0x7 (was 0x20005151, writing 0x5151)

Well, yeah.  So the commit you bisected it to is total and utter crap.
Most importantly, it retries the writes for all of the dwords in the device's
config space _including_ the status register (which by definition need not be
the same as the written value).

I wonder if the appended patch helps?

Rafael


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
