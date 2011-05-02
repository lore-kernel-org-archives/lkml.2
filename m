Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1EBUHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 16:07:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41409 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846Ab1EBUHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 16:07:32 -0400
Subject: memcg: fix fatal livelock in kswapd
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Chris Mason <chris.mason@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 15:07:29 -0500
Message-ID: <1304366849.15370.27.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fatal livelock in kswapd, reported in this thread:

http://marc.info/?t=130392066000001

Is mitigateable if we prevent the cgroups code being so aggressive in
its zone shrinking (by reducing it's default shrink from 0 [everything]
to DEF_PRIORITY [some things]).  This will have an obvious knock on
effect to cgroup accounting, but it's better than hanging systems.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>

---

>From 74b62fc417f07e1411d98181631e4e097c8e3e68 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Mon, 2 May 2011 14:56:29 -0500
Subject: [PATCH] vmscan: move containers scan back to default priority


diff --git a/mm/vmscan.c b/mm/vmscan.c
index f6b435c..46cde92 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2173,8 +2173,12 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
 	 * if we don't reclaim here, the shrink_zone from balance_pgdat
 	 * will pick up pages from other mem cgroup's as well. We hack
 	 * the priority and make it zero.
+	 *
+	 * FIXME: jejb: zero here was causing a livelock in the
+	 * shrinker so changed to DEF_PRIORITY to fix this. Now need to
+	 * sort out cgroup accounting.
 	 */
-	shrink_zone(0, zone, &sc);
+	shrink_zone(DEF_PRIORITY, zone, &sc);
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 


