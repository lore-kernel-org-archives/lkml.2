Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab2BEWcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:32:31 -0500
Received: from 1wt.eu ([62.212.114.60]:62148 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab2BEW1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:11 -0500
Message-Id: <20120205220952.698841788@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:05 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Andy Gospodarek <andy@greyhouse.net>,
        Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 76/91] bonding: Ensure that we unshare skbs prior to calling pskb_may_pull
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit b30532515f0a62bfe17207ab00883dd262497006 upstream.

Recently reported oops:

kernel BUG at net/core/skbuff.c:813!
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/net/bond0/broadcast
CPU 8
Modules linked in: sit tunnel4 cpufreq_ondemand acpi_cpufreq freq_table bonding
ipv6 dm_mirror dm_region_hash dm_log cdc_ether usbnet mii serio_raw i2c_i801
i2c_core iTCO_wdt iTCO_vendor_support shpchp ioatdma i7core_edac edac_core bnx2
ixgbe dca mdio sg ext4 mbcache jbd2 sd_mod crc_t10dif mptsas mptscsih mptbase
scsi_transport_sas dm_mod [last unloaded: microcode]

Modules linked in: sit tunnel4 cpufreq_ondemand acpi_cpufreq freq_table bonding
ipv6 dm_mirror dm_region_hash dm_log cdc_ether usbnet mii serio_raw i2c_i801
i2c_core iTCO_wdt iTCO_vendor_support shpchp ioatdma i7core_edac edac_core bnx2
ixgbe dca mdio sg ext4 mbcache jbd2 sd_mod crc_t10dif mptsas mptscsih mptbase
scsi_transport_sas dm_mod [last unloaded: microcode]
Pid: 0, comm: swapper Not tainted 2.6.32-71.el6.x86_64 #1 BladeCenter HS22
-[7870AC1]-
RIP: 0010:[<ffffffff81405b16>]  [<ffffffff81405b16>]
pskb_expand_head+0x36/0x1e0
RSP: 0018:ffff880028303b70  EFLAGS: 00010202
RAX: 0000000000000002 RBX: ffff880c6458ec80 RCX: 0000000000000020
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880c6458ec80
RBP: ffff880028303bc0 R08: ffffffff818a6180 R09: ffff880c6458ed64
R10: ffff880c622b36c0 R11: 0000000000000400 R12: 0000000000000000
R13: 0000000000000180 R14: ffff880c622b3000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000038653452a4 CR3: 0000000001001000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff8806649c2000, task ffff880c64f16ab0)
Stack:
 ffff880028303bc0 ffffffff8104fff9 000000000000001c 0000000100000000
<0> ffff880000047d80 ffff880c6458ec80 000000000000001c ffff880c6223da00
<0> ffff880c622b3000 0000000000000000 ffff880028303c10 ffffffff81407f7a
Call Trace:
<IRQ>
 [<ffffffff8104fff9>] ? __wake_up_common+0x59/0x90
 [<ffffffff81407f7a>] __pskb_pull_tail+0x2aa/0x360
 [<ffffffffa0244530>] bond_arp_rcv+0x2c0/0x2e0 [bonding]
 [<ffffffff814a0857>] ? packet_rcv+0x377/0x440
 [<ffffffff8140f21b>] netif_receive_skb+0x2db/0x670
 [<ffffffff8140f788>] napi_skb_finish+0x58/0x70
 [<ffffffff8140fc89>] napi_gro_receive+0x39/0x50
 [<ffffffffa01286eb>] ixgbe_clean_rx_irq+0x35b/0x900 [ixgbe]
 [<ffffffffa01290f6>] ixgbe_clean_rxtx_many+0x136/0x240 [ixgbe]
 [<ffffffff8140fe53>] net_rx_action+0x103/0x210
 [<ffffffff81073bd7>] __do_softirq+0xb7/0x1e0
 [<ffffffff810d8740>] ? handle_IRQ_event+0x60/0x170
 [<ffffffff810142cc>] call_softirq+0x1c/0x30
 [<ffffffff81015f35>] do_softirq+0x65/0xa0
 [<ffffffff810739d5>] irq_exit+0x85/0x90
 [<ffffffff814cf915>] do_IRQ+0x75/0xf0
 [<ffffffff81013ad3>] ret_from_intr+0x0/0x11
 <EOI>
 [<ffffffff8101bc01>] ? mwait_idle+0x71/0xd0
 [<ffffffff814cd80a>] ? atomic_notifier_call_chain+0x1a/0x20
 [<ffffffff81011e96>] cpu_idle+0xb6/0x110
 [<ffffffff814c17c8>] start_secondary+0x1fc/0x23f

Resulted from bonding driver registering packet handlers via dev_add_pack and
then trying to call pskb_may_pull. If another packet handler (like for AF_PACKET
sockets) gets called first, the delivered skb will have a user count > 1, which
causes pskb_may_pull to BUG halt when it does its skb_shared check.  Fix this by
calling skb_share_check prior to the may_pull call sites in the bonding driver
to clone the skb when needed.  Tested by myself and the reported successfully.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: Jay Vosburgh <fubar@us.ibm.com>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/bonding/bond_3ad.c  |    4 ++++
 drivers/net/bonding/bond_alb.c  |    4 ++++
 drivers/net/bonding/bond_main.c |    4 ++++
 3 files changed, 12 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/drivers/net/bonding/bond_3ad.c
===================================================================
--- longterm-2.6.27.orig/drivers/net/bonding/bond_3ad.c	2012-02-05 22:34:45.523916489 +0100
+++ longterm-2.6.27/drivers/net/bonding/bond_3ad.c	2012-02-05 22:34:45.677916635 +0100
@@ -2436,6 +2436,10 @@
 	if (!(dev->flags & IFF_MASTER))
 		goto out;
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
+		goto out;
+
 	if (!pskb_may_pull(skb, sizeof(struct lacpdu)))
 		goto out;
 
Index: longterm-2.6.27/drivers/net/bonding/bond_alb.c
===================================================================
--- longterm-2.6.27.orig/drivers/net/bonding/bond_alb.c	2012-02-05 22:34:45.528915452 +0100
+++ longterm-2.6.27/drivers/net/bonding/bond_alb.c	2012-02-05 22:34:45.682915651 +0100
@@ -359,6 +359,10 @@
 		goto out;
 	}
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
+		goto out;
+
 	if (!pskb_may_pull(skb, arp_hdr_len(bond_dev)))
 		goto out;
 
Index: longterm-2.6.27/drivers/net/bonding/bond_main.c
===================================================================
--- longterm-2.6.27.orig/drivers/net/bonding/bond_main.c	2012-02-05 22:34:32.651914903 +0100
+++ longterm-2.6.27/drivers/net/bonding/bond_main.c	2012-02-05 22:34:45.691916958 +0100
@@ -2699,6 +2699,10 @@
 	if (!slave || !slave_do_arp_validate(bond, slave))
 		goto out_unlock;
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
+		goto out_unlock;
+
 	if (!pskb_may_pull(skb, arp_hdr_len(dev)))
 		goto out_unlock;
 


