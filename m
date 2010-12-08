Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab0LHBVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:21:10 -0500
Received: from kroah.org ([198.145.64.141]:33593 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496Ab0LHBDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:03 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:42 2010
Message-Id: <20101208005742.278736115@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Brian Tarricone <brian@tarricone.org>
Subject: [208/289] USB: ehci: disable LPM and PPCD for nVidia MCP89 chips
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brian J. Tarricone <brian@tarricone.org>

commit a85b4e7f4481c5a1ca89fa63c9c871151965075e upstream.

Tested on MacBookAir3,1.  Without this, we get EPROTO errors when
fetching device config descriptors.

Signed-off-by: Brian Tarricone <brian@tarricone.org>
Reported-by: Benoit Gschwind <gschwind@gnu-log.net>
Tested-by: Edgar Hucek <gimli@dark-green.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-pci.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -148,6 +148,18 @@ static int ehci_pci_setup(struct usb_hcd
 			if (pdev->revision < 0xa4)
 				ehci->no_selective_suspend = 1;
 			break;
+
+		/* MCP89 chips on the MacBookAir3,1 give EPROTO when
+		 * fetching device descriptors unless LPM is disabled.
+		 * There are also intermittent problems enumerating
+		 * devices with PPCD enabled.
+		 */
+		case 0x0d9d:
+			ehci_info(ehci, "disable lpm/ppcd for nvidia mcp89");
+			ehci->has_lpm = 0;
+			ehci->has_ppcd = 0;
+			ehci->command &= ~CMD_PPCEE;
+			break;
 		}
 		break;
 	case PCI_VENDOR_ID_VIA:


