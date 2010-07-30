Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab0G3Sgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:36:53 -0400
Received: from kroah.org ([198.145.64.141]:57977 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759789Ab0G3Ryk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:40 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:36 2010
Message-Id: <20100730175136.660204966@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Doug Kehn <rdkehn@yahoo.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [034/205] net/core: neighbour update Oops
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Doug Kehn <rdkehn@yahoo.com>

commit 91a72a70594e5212c97705ca6a694bd307f7a26b upstream.

When configuring DMVPN (GRE + openNHRP) and a GRE remote
address is configured a kernel Oops is observed.  The
obserseved Oops is caused by a NULL header_ops pointer
(neigh->dev->header_ops) in neigh_update_hhs() when

void (*update)(struct hh_cache*, const struct net_device*, const unsigned char *)
= neigh->dev->header_ops->cache_update;

is executed.  The dev associated with the NULL header_ops is
the GRE interface.  This patch guards against the
possibility that header_ops is NULL.

This Oops was first observed in kernel version 2.6.26.8.

Signed-off-by: Doug Kehn <rdkehn@yahoo.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/neighbour.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -948,7 +948,10 @@ static void neigh_update_hhs(struct neig
 {
 	struct hh_cache *hh;
 	void (*update)(struct hh_cache*, const struct net_device*, const unsigned char *)
-		= neigh->dev->header_ops->cache_update;
+		= NULL;
+
+	if (neigh->dev->header_ops)
+		update = neigh->dev->header_ops->cache_update;
 
 	if (update) {
 		for (hh = neigh->hh; hh; hh = hh->hh_next) {


