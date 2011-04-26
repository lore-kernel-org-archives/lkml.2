Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1DZVOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:14:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:38478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab1DZVON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738831755"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: philipp@redfish-solutions.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [44/106] atm/solos-pci: Don't include frame pseudo-header on transmit hex-dump
Message-Id: <20110426211324.0FD253E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/atm/solos-pci.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/atm/solos-pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/atm/solos-pci.c
+++ linux-2.6.35.y/drivers/atm/solos-pci.c
@@ -695,7 +695,7 @@ void solos_bh(unsigned long card_arg)
 					      size);
 			}
 			if (atmdebug) {
-				dev_info(&card->dev->dev, "Received: device %d\n", port);
+				dev_info(&card->dev->dev, "Received: port %d\n", port);
 				dev_info(&card->dev->dev, "size: %d VPI: %d VCI: %d\n",
 					 size, le16_to_cpu(header->vpi),
 					 le16_to_cpu(header->vci));
@@ -1015,8 +1015,15 @@ static uint32_t fpga_tx(struct solos_car
 
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
 
