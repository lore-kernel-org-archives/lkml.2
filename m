Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab0C3XI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:08:58 -0400
Received: from kroah.org ([198.145.64.141]:48403 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab0C3XIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:08:54 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:45 2010
Message-Id: <20100330224944.777509723@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Raimonds Cicans <ray@apollo.lv>,
       "David S. Miller" <davem@davemloft.net>,
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [09/45] r8169: Fix receive buffer length when MTU is between 1515 and 1536
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Raimonds Cicans <ray@apollo.lv>

commit 8812304cf1110ae16b0778680f6022216cf4716a upstream.

In r8169 driver MTU is used to calculate receive buffer size.
Receive buffer size is used to configure hardware incoming packet filter.

For jumbo frames:
Receive buffer size = Max frame size = MTU + 14 (ethernet header) + 4
(vlan header) + 4 (ethernet checksum) = MTU + 22

Bug:
driver for all MTU up to 1536 use receive buffer size 1536

As you can see from formula, this mean all IP packets > 1536 - 22
(for vlan tagged, 1536 - 18 for not tagged) are dropped by hardware
filter.

Example:

host_good>  ifconfig eth0 mtu 1536
host_r8169> ifconfig eth0 mtu 1536
host_good>  ping host_r8169
Ok
host_good>  ping -s 1500 host_r8169
Fail
host_good>  ifconfig eth0 mtu 7000
host_r8169> ifconfig eth0 mtu 7000
host_good>  ping -s 1500 host_r8169
Ok

Bonus: got rid of magic number 8

Signed-off-by: Raimonds Cicans <ray@apollo.lv>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1842,9 +1842,9 @@ static void __devexit rtl8169_remove_one
 static void rtl8169_set_rxbufsize(struct rtl8169_private *tp,
 				  struct net_device *dev)
 {
-	unsigned int mtu = dev->mtu;
+	unsigned int max_frame = dev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
 
-	tp->rx_buf_sz = (mtu > RX_BUF_SIZE) ? mtu + ETH_HLEN + 8 : RX_BUF_SIZE;
+	tp->rx_buf_sz = (max_frame > RX_BUF_SIZE) ? max_frame : RX_BUF_SIZE;
 }
 
 static int rtl8169_open(struct net_device *dev)


