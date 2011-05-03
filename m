Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1ECOu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:50:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55811 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab1ECOsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:48:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JKcBx1kZMq7h0G2od7kUt9AKmU4YVJND2zDndjI4VlX668SqnhtECSjbUUVlDPVtCu
         hViFpXayA46TvimkVkYKrE0FaeEE1GTnlYeCL14a48UXdwNrtS2R7VNWtn5OWdHfNiFD
         MAf4JRRvkcVxSjkXiD4YgG0jmRtpvQerzOV+U=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Ying Han <yinghan@google.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v2 2/2] Filter unevictable page out in deactivate_page
Date: Tue,  3 May 2011 23:48:33 +0900
Message-Id: <60486ca121ee8f526a0046f47384579e465bb59e.1304433952.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1304433952.git.minchan.kim@gmail.com>
References: <cover.1304433952.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1304433952.git.minchan.kim@gmail.com>
References: <cover.1304433952.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's pointless that deactive_page's pagevec operation about
unevictable page as it's nop.
This patch removes unnecessary overhead which might be a bit problem
in case that there are many unevictable page in system(ex, mprotect workload)

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/swap.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 2e9656d..e121ceb 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -511,6 +511,15 @@ static void drain_cpu_pagevecs(int cpu)
  */
 void deactivate_page(struct page *page)
 {
+
+	/*
+	 * In workload which system has many unevictable page(ex, mprotect),
+	 * unevictable page deactivation for accelerating reclaim
+	 * is pointless.
+	 */
+	if (PageUnevictable(page))
+		return;
+
 	if (likely(get_page_unless_zero(page))) {
 		struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
 
-- 
1.7.1

