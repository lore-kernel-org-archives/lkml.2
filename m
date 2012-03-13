Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab2CMAWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:47519 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424Ab2CMAWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        "Philip A. Prindeville" <philipp@redfish-solutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 051/196] atm/solos-pci: Don't include frame pseudo-header on transmit hex-dump
Date: Mon, 12 Mar 2012 20:19:24 -0400
Message-Id: <1331598109-31424-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Philip A. Prindeville" <philipp@redfish-solutions.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 18b429e74eeafe42e947b1b0f9a760c7153a0b5c upstream.

Omit pkt_hdr preamble when dumping transmitted packet as hex-dump;
we can pull this up because the frame has already been sent, and
dumping it is the last thing we do with it before freeing it.

Also include the size, vpi, and vci in the debug as is done on
receive.

Use "port" consistently instead of "device" intermittently.

Signed-off-by: Philip Prindeville <philipp@redfish-solutions.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/atm/solos-pci.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 3613422..6ba851b 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -695,7 +695,7 @@ void solos_bh(unsigned long card_arg)
 					      size);
 			}
 			if (atmdebug) {
-				dev_info(&card->dev->dev, "Received: device %d\n", port);
+				dev_info(&card->dev->dev, "Received: port %d\n", port);
 				dev_info(&card->dev->dev, "size: %d VPI: %d VCI: %d\n",
 					 size, le16_to_cpu(header->vpi),
 					 le16_to_cpu(header->vci));
@@ -1015,8 +1015,15 @@ static uint32_t fpga_tx(struct solos_card *card)
 
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
 
-- 
1.7.9.3

