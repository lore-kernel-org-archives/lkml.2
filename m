Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab2BXNrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:47:18 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43970 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757439Ab2BXNqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:46:39 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: "David S. Miller" <davem@davemloft.net>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] cirrus/mac89x0: print MAC via printk format specifier
Date: Fri, 24 Feb 2012 14:45:54 +0100
Message-Id: <1330091162-8141-4-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
References: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330091199;e20e0528;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print MAC/dev_addr via printk extended format specifier %pM instead
of custom code.

Use memcpy to set the address to dev->dev_addr in set_mac_address,
instead of mxing it up in a for loop with printing a debug msg.

Check also if the given address is valid.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/ethernet/cirrus/mac89x0.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/mac89x0.c b/drivers/net/ethernet/cirrus/mac89x0.c
index 83781f3..a7324ce 100644
--- a/drivers/net/ethernet/cirrus/mac89x0.c
+++ b/drivers/net/ethernet/cirrus/mac89x0.c
@@ -592,10 +592,14 @@ static void set_multicast_list(struct net_device *dev)
 static int set_mac_address(struct net_device *dev, void *addr)
 {
 	int i;
-	printk("%s: Setting MAC address to ", dev->name);
-	for (i = 0; i < 6; i++)
-		printk(" %2.2x", dev->dev_addr[i] = ((unsigned char *)addr)[i]);
-	printk(".\n");
+	struct sockaddr *saddr = addr;
+
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
+	printk("%s: Setting MAC address to %pM\n", dev->name, dev->dev_addr);
+
 	/* set the Ethernet address */
 	for (i=0; i < ETH_ALEN/2; i++)
 		writereg(dev, PP_IA+i*2, dev->dev_addr[i*2] | (dev->dev_addr[i*2+1] << 8));
-- 
1.7.8.3

