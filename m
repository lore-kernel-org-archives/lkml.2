Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab2JXBzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 21:55:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53139 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab2JXBzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 21:55:52 -0400
Date: Tue, 23 Oct 2012 18:55:49 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Julian Wollrath <jwollrath@web.de>, Hugh Dickins <hughd@google.com>,
        Patrik Kullman <patrik.kullman@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [patch for-3.7] mm, numa: avoid setting zone_reclaim_mode unless a
 node is sufficiently distant
In-Reply-To: <CAJL_dMtS-rc1b3s9YZ+9Eapc21vF06aCT23GV8eMp13ZxURvBA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1210231853360.11290@chino.kir.corp.google.com>
References: <CAGPN=9Qx1JAr6CGO-JfoR2ksTJG_CLLZY_oBA_TFMzA_OSfiFg@mail.gmail.com> <20121022173315.7b0da762@ilfaris> <20121022214502.0fde3adc@ilfaris> <20121022170452.cc8cc629.akpm@linux-foundation.org> <alpine.LNX.2.00.1210222059120.1136@eggly.anvils>
 <20121023110434.021d100b@ilfaris> <CAJL_dMvUktOx9BqFm5jn2JbWbL_RWH412rdU+=rtDUvkuaPRUw@mail.gmail.com> <alpine.DEB.2.00.1210231541350.1221@chino.kir.corp.google.com> <CAJL_dMtS-rc1b3s9YZ+9Eapc21vF06aCT23GV8eMp13ZxURvBA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 957f822a0ab9 ("mm, numa: reclaim from all nodes within reclaim
distance") caused zone_reclaim_mode to be set for all systems where two
nodes are within RECLAIM_DISTANCE of each other.  This is the opposite of
what we actually want: zone_reclaim_mode should be set if two nodes are
sufficiently distant.

Reported-by: Julian Wollrath <jwollrath@web.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1809,10 +1809,10 @@ static void __paginginit init_zone_allows_reclaim(int nid)
 	int i;
 
 	for_each_online_node(i)
-		if (node_distance(nid, i) <= RECLAIM_DISTANCE) {
+		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
 			node_set(i, NODE_DATA(nid)->reclaim_nodes);
+		else
 			zone_reclaim_mode = 1;
-		}
 }
 
 #else	/* CONFIG_NUMA */
