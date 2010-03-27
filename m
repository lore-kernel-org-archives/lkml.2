Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab0C0Rdp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 13:33:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47939
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701Ab0C0Rdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 13:33:44 -0400
Date: Sat, 27 Mar 2010 10:34:07 -0700 (PDT)
Message-Id: <20100327.103407.260084965.davem@davemloft.net>
To: michael.s.gilbert@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: CVE-2009-4537
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100327142100.38d21565.michael.s.gilbert@gmail.com>
References: <20100327142100.38d21565.michael.s.gilbert@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Gilbert <michael.s.gilbert@gmail.com>
Date: Sat, 27 Mar 2010 14:21:00 -0400

> Hi,
> 
> CVE-2009-4537 has been disclosed without any upstream activity for a
> while now. Discussion about the issue dried up in January [0], and a
> patch had been proposed [1], but no arguments were seen either for or
> against it. Note that redhat has already shipped that in their various
> kernel security updates.  Would it make sense to merge those changes
> officially?

A different version of the fix went into the tree.

commit 8812304cf1110ae16b0778680f6022216cf4716a
Author: Raimonds Cicans <ray@apollo.lv>
Date:   Fri Nov 13 10:52:19 2009 +0000

    r8169: Fix receive buffer length when MTU is between 1515 and 1536
    
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

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index fa49356..b9221bd 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3243,9 +3243,9 @@ static void __devexit rtl8169_remove_one(struct pci_dev *pdev)
 static void rtl8169_set_rxbufsize(struct rtl8169_private *tp,
 				  struct net_device *dev)
 {
-	unsigned int mtu = dev->mtu;
+	unsigned int max_frame = dev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
 
-	tp->rx_buf_sz = (mtu > RX_BUF_SIZE) ? mtu + ETH_HLEN + 8 : RX_BUF_SIZE;
+	tp->rx_buf_sz = (max_frame > RX_BUF_SIZE) ? max_frame : RX_BUF_SIZE;
 }
 
 static int rtl8169_open(struct net_device *dev)
