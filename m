Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162417Ab1FAIvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:51:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162405Ab1FAIUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:20:09 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:23 2011
Message-Id: <20110601081123.258428165@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:27 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [057/165] macvlan: fix panic if lowerdev in a bond
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1039
Lines: 41


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
@@ -598,8 +598,8 @@ static int macvlan_port_create(struct ne
 	err = netdev_rx_handler_register(dev, macvlan_handle_frame, port);
 	if (err)
 		kfree(port);
-
-	dev->priv_flags |= IFF_MACVLAN_PORT;
+	else
+		dev->priv_flags |= IFF_MACVLAN_PORT;
 	return err;
 }
 


