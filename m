Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab1DZV3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:29:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:46509 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab1DZVOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738831837"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: jslaby@suse.cz, ak@linux.intel.com, remi.denis-courmont@nokia.com,
        davem@davemloft.net, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [56/106] NET: cdc-phonet, handle empty phonet header
Message-Id: <20110426211336.A790D3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jiri Slaby <jslaby@suse.cz>

commit 468c3f924f043cad7a04f4f4d5224a2c9bc886c1 upstream.

Currently, for N 5800 XM I get:
cdc_phonet: probe of 1-6:1.10 failed with error -22

It's because phonet_header is empty. Extra altsetting looks like
there:
E 05 24 00 01 10 03 24 ab 05 24 06 0a 0b 04 24 fd  .$....$..$....$.
E 00                                               .

I don't see the header used anywhere so just check if the phonet
descriptor is there, not the structure itself.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/cdc-phonet.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6.35.y/drivers/net/usb/cdc-phonet.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/usb/cdc-phonet.c
+++ linux-2.6.35.y/drivers/net/usb/cdc-phonet.c
@@ -326,13 +326,13 @@ int usbpn_probe(struct usb_interface *in
 {
 	static const char ifname[] = "usbpn%d";
 	const struct usb_cdc_union_desc *union_header = NULL;
-	const struct usb_cdc_header_desc *phonet_header = NULL;
 	const struct usb_host_interface *data_desc;
 	struct usb_interface *data_intf;
 	struct usb_device *usbdev = interface_to_usbdev(intf);
 	struct net_device *dev;
 	struct usbpn_dev *pnd;
 	u8 *data;
+	int phonet = 0;
 	int len, err;
 
 	data = intf->altsetting->extra;
@@ -353,10 +353,7 @@ int usbpn_probe(struct usb_interface *in
 					(struct usb_cdc_union_desc *)data;
 				break;
 			case 0xAB:
-				if (phonet_header || dlen < 5)
-					break;
-				phonet_header =
-					(struct usb_cdc_header_desc *)data;
+				phonet = 1;
 				break;
 			}
 		}
@@ -364,7 +361,7 @@ int usbpn_probe(struct usb_interface *in
 		len -= dlen;
 	}
 
-	if (!union_header || !phonet_header)
+	if (!union_header || !phonet)
 		return -EINVAL;
 
 	data_intf = usb_ifnum_to_if(usbdev, union_header->bSlaveInterface0);
