Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab1DYU7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:59:00 -0400
Received: from 1wt.eu ([62.212.114.60]:33800 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192Ab1DYUXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:42 -0400
Message-Id: <20110425200234.643863898@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Apollon Oikonomopoulos <apollon@noc.grnet.gr>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 038/173] x25: decrement netdev reference counts on unload
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Apollon Oikonomopoulos <apollon@noc.grnet.gr>

commit 171995e5d82dcc92bea37a7d2a2ecc21068a0f19 upstream.

x25 does not decrement the network device reference counts on module unload.
Thus unregistering any pre-existing interface after unloading the x25 module
hangs and results in

 unregister_netdevice: waiting for tap0 to become free. Usage count = 1

This patch decrements the reference counts of all interfaces in x25_link_free,
the way it is already done in x25_link_device_down for NETDEV_DOWN events.

Signed-off-by: Apollon Oikonomopoulos <apollon@noc.grnet.gr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/x25/x25_link.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -393,6 +393,7 @@ void __exit x25_link_free(void)
 	list_for_each_safe(entry, tmp, &x25_neigh_list) {
 		nb = list_entry(entry, struct x25_neigh, node);
 		__x25_remove_neigh(nb);
+		dev_put(nb->dev);
 	}
 	write_unlock_bh(&x25_neigh_list_lock);
 }


