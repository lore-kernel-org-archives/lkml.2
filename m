Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab1HNQ3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:29:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1HNQGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:53 2011
Message-Id: <20110812210553.079701119@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:03:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [11/90] rtlwifi: Fix kernel oops on ARM SOC
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit b6b67df3f24c45af0012ee3c8af2f62ca083ae18 upstream.

This driver uses information from the self member of the pci_bus struct to
get information regarding the bridge to which the PCIe device is attached.
Unfortunately, this member is not established on all architectures, which
leads to a kernel oops.

Skipping the entire block that uses the self member to determine the bridge
vendor will only affect RTL8192DE devices as that driver sets the ASPM support
flag differently when the bridge vendor is Intel. If the self member is
available, there is no functional change.

This patch fixes Bugzilla No. 40212.

Reported-by: Hubert Liao <liao.hubertt@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtlwifi/pci.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1709,15 +1709,17 @@ static bool _rtl_pci_find_adapter(struct
 	pcipriv->ndis_adapter.devnumber = PCI_SLOT(pdev->devfn);
 	pcipriv->ndis_adapter.funcnumber = PCI_FUNC(pdev->devfn);
 
-	/*find bridge info */
-	pcipriv->ndis_adapter.pcibridge_vendorid = bridge_pdev->vendor;
-	for (tmp = 0; tmp < PCI_BRIDGE_VENDOR_MAX; tmp++) {
-		if (bridge_pdev->vendor == pcibridge_vendors[tmp]) {
-			pcipriv->ndis_adapter.pcibridge_vendor = tmp;
-			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				 ("Pci Bridge Vendor is found index: %d\n",
-				  tmp));
-			break;
+	if (bridge_pdev) {
+		/*find bridge info if available */
+		pcipriv->ndis_adapter.pcibridge_vendorid = bridge_pdev->vendor;
+		for (tmp = 0; tmp < PCI_BRIDGE_VENDOR_MAX; tmp++) {
+			if (bridge_pdev->vendor == pcibridge_vendors[tmp]) {
+				pcipriv->ndis_adapter.pcibridge_vendor = tmp;
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+					 ("Pci Bridge Vendor is found index:"
+					 " %d\n", tmp));
+				break;
+			}
 		}
 	}
 


