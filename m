Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964870Ab2CMA53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:57:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:47777 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673Ab2CMAWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jiri Slaby <jslaby@suse.cz>,
        =?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= 
	<remi.denis-courmont@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 058/196] NET: cdc-phonet, handle empty phonet header
Date: Mon, 12 Mar 2012 20:19:31 -0400
Message-Id: <1331598109-31424-13-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/usb/cdc-phonet.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index dc94445..b18cda4 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -326,13 +326,13 @@ int usbpn_probe(struct usb_interface *intf, const struct usb_device_id *id)
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
@@ -353,10 +353,7 @@ int usbpn_probe(struct usb_interface *intf, const struct usb_device_id *id)
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
@@ -364,7 +361,7 @@ int usbpn_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		len -= dlen;
 	}
 
-	if (!union_header || !phonet_header)
+	if (!union_header || !phonet)
 		return -EINVAL;
 
 	data_intf = usb_ifnum_to_if(usbdev, union_header->bSlaveInterface0);
-- 
1.7.9.3

