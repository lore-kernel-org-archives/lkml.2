Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1DMP6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:58:48 -0400
Received: from kroah.org ([198.145.64.141]:54575 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277Ab1DMPz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:49 2011
Message-Id: <20110413155149.658871261@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Philip Prindeville <philipp@redfish-solutions.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [62/74] atm/solos-pci: Dont include frame pseudo-header on transmit hex-dump
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Philip A. Prindeville <philipp@redfish-solutions.com>

commit 18b429e74eeafe42e947b1b0f9a760c7153a0b5c upstream.

Omit pkt_hdr preamble when dumping transmitted packet as hex-dump;
we can pull this up because the frame has already been sent, and
dumping it is the last thing we do with it before freeing it.

Also include the size, vpi, and vci in the debug as is done on
receive.

Use "port" consistently instead of "device" intermittently.

Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/atm/solos-pci.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -688,7 +688,7 @@ void solos_bh(unsigned long card_arg)
 					      size);
 			}
 			if (atmdebug) {
-				dev_info(&card->dev->dev, "Received: device %d\n", port);
+				dev_info(&card->dev->dev, "Received: port %d\n", port);
 				dev_info(&card->dev->dev, "size: %d VPI: %d VCI: %d\n",
 					 size, le16_to_cpu(header->vpi),
 					 le16_to_cpu(header->vci));
@@ -1008,8 +1008,15 @@ static uint32_t fpga_tx(struct solos_car
 
 			/* Clean up and free oldskb now it's gone */
 			if (atmdebug) {
+				struct pkt_hdr *header = (void *)oldskb->data;
+				int size = le16_to_cpu(header->size);
+
+				skb_pull(oldskb, sizeof(*header));
 				dev_info(&card->dev->dev, "Transmitted: port %d\n",
 					 port);
+				dev_info(&card->dev->dev, "size: %d VPI: %d VCI: %d\n",
+					 size, le16_to_cpu(header->vpi),
+					 le16_to_cpu(header->vci));
 				print_buffer(oldskb);
 			}
 


