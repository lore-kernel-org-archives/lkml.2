Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1B1Qg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:36:59 -0500
Received: from kroah.org ([198.145.64.141]:41191 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab1B1Qg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:36:57 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:06 2011
Message-Id: <20110228162406.465833956@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Apollon Oikonomopoulos <apollon@noc.grnet.gr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [08/68] x25: decrement netdev reference counts on unload
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


