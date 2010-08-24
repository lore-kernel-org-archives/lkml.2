Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab0HXWxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:53:54 -0400
Received: from kroah.org ([198.145.64.141]:52112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451Ab0HXWxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:53:46 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:24 2010
Message-Id: <20100824222524.059207048@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Quan <David.Quan@atheros.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [19/59] ath5k: disable ASPM L0s for all cards
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Maxim Levitsky <maximlevitsky@gmail.com>

commit 6ccf15a1a76d2ff915cdef6ae4d12d0170087118 upstream.

Atheros PCIe wireless cards handled by ath5k do require L0s disabled.
For distributions shipping with CONFIG_PCIEASPM (this will be enabled
by default in the future in 2.6.36) this will also mean both L1 and L0s
will be disabled when a pre 1.1 PCIe device is detected. We do know L1
works correctly even for all ath5k pre 1.1 PCIe devices though but cannot
currently undue the effect of a blacklist, for details you can read
pcie_aspm_sanity_check() and see how it adjusts the device link
capability.

It may be possible in the future to implement some PCI API to allow
drivers to override blacklists for pre 1.1 PCIe but for now it is
best to accept that both L0s and L1 will be disabled completely for
distributions shipping with CONFIG_PCIEASPM rather than having this
issue present. Motivation for adding this new API will be to help
with power consumption for some of these devices.

Example of issues you'd see:

  - On the Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
    Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well
    with ASPM enabled, the card will eventually stall on heavy traffic
    with often 'unsupported jumbo' warnings appearing. Disabling
    ASPM L0s in ath5k fixes these problems.

  - On the same card you would see a storm of RXORN interrupts
    even though medium is idle.

Credit for root causing and fixing the bug goes to Jussi Kivilinna.

Cc: David Quan <David.Quan@atheros.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/base.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -48,6 +48,7 @@
 #include <linux/netdevice.h>
 #include <linux/cache.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/ethtool.h>
 #include <linux/uaccess.h>
 
@@ -448,6 +449,26 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	int ret;
 	u8 csz;
 
+	/*
+	 * L0s needs to be disabled on all ath5k cards.
+	 *
+	 * For distributions shipping with CONFIG_PCIEASPM (this will be enabled
+	 * by default in the future in 2.6.36) this will also mean both L1 and
+	 * L0s will be disabled when a pre 1.1 PCIe device is detected. We do
+	 * know L1 works correctly even for all ath5k pre 1.1 PCIe devices
+	 * though but cannot currently undue the effect of a blacklist, for
+	 * details you can read pcie_aspm_sanity_check() and see how it adjusts
+	 * the device link capability.
+	 *
+	 * It may be possible in the future to implement some PCI API to allow
+	 * drivers to override blacklists for pre 1.1 PCIe but for now it is
+	 * best to accept that both L0s and L1 will be disabled completely for
+	 * distributions shipping with CONFIG_PCIEASPM rather than having this
+	 * issue present. Motivation for adding this new API will be to help
+	 * with power consumption for some of these devices.
+	 */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
+
 	ret = pci_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "can't enable device\n");


