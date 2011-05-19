Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934173Ab1ESSJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:09:38 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53249 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934096Ab1ESSJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:35 -0400
X-Sasl-enc: OVRuUGbdLo3zB/yr+ExRPSaprFdYckxUp2QcVQuCR9Ja 1305828574
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:06:00 2011
Message-Id: <20110519180600.693780242@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [67/71] vmxnet3: Fix inconsistent LRO state after initialization
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

commit ebde6f8acba92abfc203585198a54f47e83e2cd0 upstream.

During initialization of vmxnet3, the state of LRO
gets out of sync with netdev->features.

This leads to very poor TCP performance in a IP forwarding
setup and is hitting many VMware users.

Simplified call sequence:
1. vmxnet3_declare_features() initializes "adapter->lro" to true.

2. The kernel automatically disables LRO if IP forwarding is enabled,
so vmxnet3_set_flags() gets called. This also updates netdev->features.

3. Now vmxnet3_setup_driver_shared() is called. "adapter->lro" is still
set to true and LRO gets enabled again, even though
netdev->features shows it's disabled.

Fix it by updating "adapter->lro", too.

The private vmxnet3 adapter flags are scheduled for removal
in net-next, see commit a0d2730c9571aeba793cb5d3009094ee1d8fda35
"net: vmxnet3: convert to hw_features".

Patch applies to 2.6.37 / 2.6.38 and 2.6.39-rc6.

Please CC: comments.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/vmxnet3/vmxnet3_ethtool.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -311,6 +311,9 @@ vmxnet3_set_flags(struct net_device *net
 		/* toggle the LRO feature*/
 		netdev->features ^= NETIF_F_LRO;
 
+		/* Update private LRO flag */
+		adapter->lro = lro_requested;
+
 		/* update harware LRO capability accordingly */
 		if (lro_requested)
 			adapter->shared->devRead.misc.uptFeatures |=


