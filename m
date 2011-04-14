Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab1DNSOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:14:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:41931 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964923Ab1DNR6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:15 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Apollon Oikonomopoulos <apollon@noc.grnet.gr>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 151/209] x25: decrement netdev reference counts on unload
Date: Thu, 14 Apr 2011 13:55:09 -0400
Message-Id: <1302803767-9715-38-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Apollon Oikonomopoulos <apollon@noc.grnet.gr>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 171995e5d82dcc92bea37a7d2a2ecc21068a0f19 upstream

x25 does not decrement the network device reference counts on module unload.
Thus unregistering any pre-existing interface after unloading the x25 module
hangs and results in

 unregister_netdevice: waiting for tap0 to become free. Usage count = 1

This patch decrements the reference counts of all interfaces in x25_link_free,
the way it is already done in x25_link_device_down for NETDEV_DOWN events.

Signed-off-by: Apollon Oikonomopoulos <apollon@noc.grnet.gr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/x25/x25_link.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index 73e7b95..b25c646 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -394,6 +394,7 @@ void __exit x25_link_free(void)
 	list_for_each_safe(entry, tmp, &x25_neigh_list) {
 		nb = list_entry(entry, struct x25_neigh, node);
 		__x25_remove_neigh(nb);
+		dev_put(nb->dev);
 	}
 	write_unlock_bh(&x25_neigh_list_lock);
 }
-- 
1.7.4.4

