Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934246Ab1ESSQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:16:46 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49496 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934048Ab1ESSIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:52 -0400
X-Sasl-enc: SSLobX5WhaSGcEPNaD1IMFQnN/jsNi52cm7lie8Or0Nd 1305828531
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:58 2011
Message-Id: <20110519180558.440328693@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Breno Leitao <leitao@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [43/71] ehea: Fix memory hotplug oops
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 21ccc7936dac5ca9b3e2838bbc112a60f34e18b3 upstream.

The ehea driver oopses during memory hotplug if the ports are not
up. A simple testcase:

# ifconfig ethX down
# echo offline > /sys/devices/system/memory/memory32/state

Oops: Kernel access of bad area, sig: 11 [#1]
last sysfs file: /sys/devices/system/memory/memory32/state
REGS: c000000709393110 TRAP: 0300   Not tainted  (2.6.39-rc2-01385-g7ef73bc-dirty)
DAR: 0000000000000000, DSISR: 40000000
...
NIP [c000000000067c98] .__wake_up_common+0x48/0xf0
LR [c00000000006d034] .__wake_up+0x54/0x90
Call Trace:
[c00000000006d034] .__wake_up+0x54/0x90
[d000000006bb6270] .ehea_rereg_mrs+0x140/0x730 [ehea]
[d000000006bb69c4] .ehea_mem_notifier+0x164/0x170 [ehea]
[c0000000006fc8a8] .notifier_call_chain+0x78/0xf0
[c0000000000b3d70] .__blocking_notifier_call_chain+0x70/0xb0
[c000000000458d78] .memory_notify+0x28/0x40
[c0000000001871d8] .remove_memory+0x208/0x6d0
[c000000000458264] .memory_section_action+0x94/0x140
[c0000000004583ec] .memory_block_change_state+0xdc/0x1d0
[c0000000004585cc] .store_mem_state+0xec/0x160
[c00000000044768c] .sysdev_store+0x3c/0x50
[c00000000020b48c] .sysfs_write_file+0xec/0x1f0
[c00000000018f86c] .vfs_write+0xec/0x1e0
[c00000000018fa88] .SyS_write+0x58/0xd0

To fix this, initialise the waitqueues during port probe instead
of port open.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ehea/ehea_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -2688,9 +2688,6 @@ static int ehea_open(struct net_device *
 		netif_start_queue(dev);
 	}
 
-	init_waitqueue_head(&port->swqe_avail_wq);
-	init_waitqueue_head(&port->restart_wq);
-
 	mutex_unlock(&port->port_lock);
 
 	return ret;
@@ -3273,6 +3270,9 @@ struct ehea_port *ehea_setup_single_port
 
 	INIT_WORK(&port->reset_task, ehea_reset_port);
 
+	init_waitqueue_head(&port->swqe_avail_wq);
+	init_waitqueue_head(&port->restart_wq);
+
 	ret = register_netdev(dev);
 	if (ret) {
 		pr_err("register_netdev failed. ret=%d\n", ret);


