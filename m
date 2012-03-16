Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946590Ab2CPX5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:57:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946131Ab2CPXiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:38:22 -0400
Message-Id: <20120316233448.700578666@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michel Machado <michel@digirati.com.br>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [ 16/38] neighbour: Fixed race condition at tbl->nht
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Michel Machado <michel@digirati.com.br>

[ Upstream commit 84338a6c9dbb6ff3de4749864020f8f25d86fc81 ]

When the fixed race condition happens:

1. While function neigh_periodic_work scans the neighbor hash table
pointed by field tbl->nht, it unlocks and locks tbl->lock between
buckets in order to call cond_resched.

2. Assume that function neigh_periodic_work calls cond_resched, that is,
the lock tbl->lock is available, and function neigh_hash_grow runs.

3. Once function neigh_hash_grow finishes, and RCU calls
neigh_hash_free_rcu, the original struct neigh_hash_table that function
neigh_periodic_work was using doesn't exist anymore.

4. Once back at neigh_periodic_work, whenever the old struct
neigh_hash_table is accessed, things can go badly.

Signed-off-by: Michel Machado <michel@digirati.com.br>
CC: "David S. Miller" <davem@davemloft.net>
CC: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/neighbour.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -823,6 +823,8 @@ next_elt:
 		write_unlock_bh(&tbl->lock);
 		cond_resched();
 		write_lock_bh(&tbl->lock);
+		nht = rcu_dereference_protected(tbl->nht,
+						lockdep_is_held(&tbl->lock));
 	}
 	/* Cycle through all hash buckets every base_reachable_time/2 ticks.
 	 * ARP entry timeouts range from 1/2 base_reachable_time to 3/2


