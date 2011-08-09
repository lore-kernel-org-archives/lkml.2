Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1HIKQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 06:16:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46334 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1HIKQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 06:16:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 9 Aug 2011 19:09:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH v5 2/6]  memcg: stop vmscan when enough done.
Message-Id: <20110809190933.d965888b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110809190450.16d7f845.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110809190450.16d7f845.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcg :avoid node fallback scan if possible.

Now, try_to_free_pages() scans all zonelist because the page allocator
should visit all zonelists...but that behavior is harmful for memcg.
Memcg just scans memory because it hits limit...no memory shortage
in pased zonelist.

For example, with following unbalanced nodes

     Node 0    Node 1
File 1G        0
Anon 200M      200M

memcg will cause swap-out from Node1 at every vmscan.

Another example, assume 1024 nodes system.
With 1024 node system, memcg will visit 1024 nodes
pages per vmscan... This is overkilling. 

This is why memcg's victim node selection logic doesn't work
as expected.

This patch is a help for stopping vmscan when we scanned enough.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: mmotm-Aug3/mm/vmscan.c
===================================================================
--- mmotm-Aug3.orig/mm/vmscan.c
+++ mmotm-Aug3/mm/vmscan.c
@@ -2124,6 +2124,16 @@ static void shrink_zones(int priority, s
 		}
 
 		shrink_zone(priority, zone, sc);
+		if (!scanning_global_lru(sc)) {
+			/*
+			 * When we do scan for memcg's limit, it's bad to do
+			 * fallback into more node/zones because there is no
+			 * memory shortage. We quit as much as possible when
+			 * we reache target.
+			 */
+			if (sc->nr_to_reclaim <= sc->nr_reclaimed)
+				break;
+		}
 	}
 }
 

