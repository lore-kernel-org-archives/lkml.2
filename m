Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1CJX7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 18:59:51 -0500
Received: from kroah.org ([198.145.64.141]:46884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab1CJX51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:37 2011
Message-Id: <20110310235537.833453647@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julian Anastasov <ja@ssi.bg>, Hans Schillstrom <hans@schillstrom.com>,
        Simon Horman <horms@verge.net.au>, Simon Kirby <sim@hostway.ca>
Subject: [patch 18/29] ipvs: fix dst_lock locking on dest update
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Julian Anastasov <ja@ssi.bg>

commit ff75f40f44ae9b79d520bf32a05d35af74a805c0 upstream.

	Fix dst_lock usage in __ip_vs_update_dest. We need
_bh locking because destination is updated in user context.
Can cause lockups on frequent destination updates.
Problem reported by Simon Kirby. Bug was introduced
in 2.6.37 from the "ipvs: changes for local real server"
change.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Hans Schillstrom <hans@schillstrom.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: Simon Kirby <sim@hostway.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/ipvs/ip_vs_ctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -810,9 +810,9 @@ __ip_vs_update_dest(struct ip_vs_service
 	dest->u_threshold = udest->u_threshold;
 	dest->l_threshold = udest->l_threshold;
 
-	spin_lock(&dest->dst_lock);
+	spin_lock_bh(&dest->dst_lock);
 	ip_vs_dst_reset(dest);
-	spin_unlock(&dest->dst_lock);
+	spin_unlock_bh(&dest->dst_lock);
 
 	if (add)
 		ip_vs_new_estimator(&dest->stats);


