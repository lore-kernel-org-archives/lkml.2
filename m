Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab1DSUml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:42:41 -0400
Received: from kroah.org ([198.145.64.141]:58914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab1DSUmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:42:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:41:17 2011
Message-Id: <20110419204117.145772267@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:30:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>,
        =?ISO-8859-15?q?R=C3=A9mi=20Denis-Courmont?= 
	<remi.denis-courmont@nokia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [04/28] NET: cdc-phonet, handle empty phonet header
In-Reply-To: <20110419204122.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
Cc: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/cdc-phonet.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -325,13 +325,13 @@ int usbpn_probe(struct usb_interface *in
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
@@ -352,10 +352,7 @@ int usbpn_probe(struct usb_interface *in
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
@@ -363,7 +360,7 @@ int usbpn_probe(struct usb_interface *in
 		len -= dlen;
 	}
 
-	if (!union_header || !phonet_header)
+	if (!union_header || !phonet)
 		return -EINVAL;
 
 	data_intf = usb_ifnum_to_if(usbdev, union_header->bSlaveInterface0);


