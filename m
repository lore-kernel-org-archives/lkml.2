Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161569Ab1FAILM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:11:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161196Ab1FAILE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:11:04 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:15 2011
Message-Id: <20110601080314.603787084@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:50 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [054/146] macvlan: fix panic if lowerdev in a bond
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit d93515611bbc70c2fe4db232e5feb448ed8e4cc9 ]

commit a35e2c1b6d905 (macvlan: use rx_handler_data pointer to store
macvlan_port pointer V2) added a bug in macvlan_port_create()

Steps to reproduce the bug:

# ifenslave bond0 eth0 eth1

# ip link add link eth0 up name eth0#1 type macvlan
->error EBUSY

# ip link add link eth0 up name eth0#1 type macvlan
->panic

Fix: Dont set IFF_MACVLAN_PORT in error case.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/macvlan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -586,8 +586,8 @@ static int macvlan_port_create(struct ne
 	err = netdev_rx_handler_register(dev, macvlan_handle_frame, port);
 	if (err)
 		kfree(port);
-
-	dev->priv_flags |= IFF_MACVLAN_PORT;
+	else
+		dev->priv_flags |= IFF_MACVLAN_PORT;
 	return err;
 }
 


