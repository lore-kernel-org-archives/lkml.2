Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1G1VF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 17:05:57 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13887 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab1G1VFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 17:05:53 -0400
Date: Thu, 28 Jul 2011 23:05:51 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, kanoj@sgi.com,
        sct@redhat.com
Subject: [PATCH] vmscan: Remove if statement that will never trigger
Message-ID: <alpine.LNX.2.00.1107282302580.20477@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have this code in mm/vmscan.c:shrink_slab() :
...
		if (total_scan < 0) {
			printk(KERN_ERR "shrink_slab: %pF negative objects to "
			       "delete nr=%ld\n",
			       shrinker->shrink, total_scan);
			total_scan = max_pass;
		}
...
but since 'total_scan' is of type 'unsigned long' it will never be
less than zero, so there is no way we'll ever enter the true branch of
this if statement - so let's just remove it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 mm/vmscan.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

	Compile tested only.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7ef6912..c07d9b1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -271,12 +271,6 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 		delta *= max_pass;
 		do_div(delta, lru_pages + 1);
 		total_scan += delta;
-		if (total_scan < 0) {
-			printk(KERN_ERR "shrink_slab: %pF negative objects to "
-			       "delete nr=%ld\n",
-			       shrinker->shrink, total_scan);
-			total_scan = max_pass;
-		}
 
 		/*
 		 * We need to avoid excessive windup on filesystem shrinkers
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

