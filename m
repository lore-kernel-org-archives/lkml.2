Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2ILXgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:36:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab2ILXgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:36:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Ren, Yongjie" <yongjie.ren@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 104/108] xen/pciback: Fix proper FLR steps.
Date: Wed, 12 Sep 2012 16:29:42 -0700
Message-Id: <20120912232501.404255572@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 80ba77dfbce85f2d1be54847de3c866de1b18a9a upstream.

When we do FLR and save PCI config we did it in the wrong order.
The end result was that if a PCI device was unbind from
its driver, then binded to xen-pciback, and then back to its
driver we would get:

> lspci -s 04:00.0
04:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
13:42:12 # 4 :~/
> echo "0000:04:00.0" > /sys/bus/pci/drivers/pciback/unbind
> modprobe e1000e
e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
e1000e 0000:04:00.0: Disabling ASPM L0s L1
e1000e 0000:04:00.0: enabling device (0000 -> 0002)
xen: registering gsi 48 triggering 0 polarity 1
Already setup the GSI :48
e1000e 0000:04:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
e1000e: probe of 0000:04:00.0 failed with error -2

This fixes it by first saving the PCI configuration space, then
doing the FLR.

Reported-by: Ren, Yongjie <yongjie.ren@intel.com>
Reported-and-Tested-by: Tobias Geiger <tobias.geiger@vido.info>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xen-pciback/pci_stub.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -353,16 +353,16 @@ static int __devinit pcistub_init_device
 	if (err)
 		goto config_release;
 
-	dev_dbg(&dev->dev, "reseting (FLR, D3, etc) the device\n");
-	__pci_reset_function_locked(dev);
-
 	/* We need the device active to save the state. */
 	dev_dbg(&dev->dev, "save state of device\n");
 	pci_save_state(dev);
 	dev_data->pci_saved_state = pci_store_saved_state(dev);
 	if (!dev_data->pci_saved_state)
 		dev_err(&dev->dev, "Could not store PCI conf saved state!\n");
-
+	else {
+		dev_dbg(&dev->dev, "reseting (FLR, D3, etc) the device\n");
+		__pci_reset_function_locked(dev);
+	}
 	/* Now disable the device (this also ensures some private device
 	 * data is setup before we export)
 	 */


