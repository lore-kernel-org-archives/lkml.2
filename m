Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab0JVSrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:47:06 -0400
Received: from kroah.org ([198.145.64.141]:45790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758256Ab0JVSiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:55 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:36:00 2010
Message-Id: <20101022183600.570695237@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [49/66] r6040: fix r6040_multicast_list
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Fainelli <florian@openwrt.org>

commit 3bcf8229a8c49769e48d3e0bd1e20d8e003f8106 upstream.

As reported in <https://bugzilla.kernel.org/show_bug.cgi?id=15355>, r6040_
multicast_list currently crashes. This is due a wrong maximum of multicast
entries. This patch fixes the following issues with multicast:

- number of maximum entries if off-by-one (4 instead of 3)

- the writing of the hash table index is not necessary and leads to invalid
values being written into the MCR1 register, so the MAC is simply put in a non
coherent state

- when we exceed the maximum number of mutlticast address, writing the
broadcast address should be done in registers MID_1{L,M,H} instead of
MID_O{L,M,H}, otherwise we would loose the adapter's MAC address

[bwh: Adjust for 2.6.32; should also apply to 2.6.27]

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r6040.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -135,7 +135,7 @@
 #define RX_DESC_SIZE	(RX_DCNT * sizeof(struct r6040_descriptor))
 #define TX_DESC_SIZE	(TX_DCNT * sizeof(struct r6040_descriptor))
 #define MBCR_DEFAULT	0x012A	/* MAC Bus Control Register */
-#define MCAST_MAX	4	/* Max number multicast addresses to filter */
+#define MCAST_MAX	3	/* Max number multicast addresses to filter */
 
 /* Descriptor status */
 #define DSC_OWNER_MAC	0x8000	/* MAC is the owner of this descriptor */
@@ -985,9 +985,6 @@ static void r6040_multicast_list(struct
 			crc >>= 26;
 			hash_table[crc >> 4] |= 1 << (15 - (crc & 0xf));
 		}
-		/* Write the index of the hash table */
-		for (i = 0; i < 4; i++)
-			iowrite16(hash_table[i] << 14, ioaddr + MCR1);
 		/* Fill the MAC hash tables with their values */
 		iowrite16(hash_table[0], ioaddr + MAR0);
 		iowrite16(hash_table[1], ioaddr + MAR1);
@@ -1003,9 +1000,9 @@ static void r6040_multicast_list(struct
 		dmi = dmi->next;
 	}
 	for (i = dev->mc_count; i < MCAST_MAX; i++) {
-		iowrite16(0xffff, ioaddr + MID_0L + 8*i);
-		iowrite16(0xffff, ioaddr + MID_0M + 8*i);
-		iowrite16(0xffff, ioaddr + MID_0H + 8*i);
+		iowrite16(0xffff, ioaddr + MID_1L + 8*i);
+		iowrite16(0xffff, ioaddr + MID_1M + 8*i);
+		iowrite16(0xffff, ioaddr + MID_1H + 8*i);
 	}
 }
 


