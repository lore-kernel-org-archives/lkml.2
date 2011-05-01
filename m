Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab1EAPEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:04:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49587 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab1EAPEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SpkaxOqtSy3bEbRkkFccJBZB8+U+auO0HSdKSi1+idfpVs8eAt/ODfiVrpNf/4EnsY
         jyAU8SoVxgT8tAGWBMZ64NZKKAM69X6vnWIRjxIW0ljKiKfeV7LRO+fHR5pD8XfZECof
         BxHqjY93vGWwxOaedLEyAdyhviht/8SV7B6TE=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Ying Han <yinghan@google.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 2/2] Filter unevictable page out in deactivate_page
Date: Mon,  2 May 2011 00:03:31 +0900
Message-Id: <dc54a5771cf1f580a91d16816100d4a2bcf2cdf5.1304261567.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1304261567.git.minchan.kim@gmail.com>
References: <cover.1304261567.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1304261567.git.minchan.kim@gmail.com>
References: <cover.1304261567.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's pointless that deactive_page's pagevec operation about
unevictable page as it's nop.
This patch removes unnecessary overhead which might be a bit problem
in case that there are many unevictable page in system(ex, mprotect workload)

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/swap.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 2e9656d..b707694 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -511,6 +511,15 @@ static void drain_cpu_pagevecs(int cpu)
  */
 void deactivate_page(struct page *page)
 {
+
+	/*
+	 * In workload which system has many unevictable page(ex, mprotect),
+	 * unevictalge page deactivation for accelerating reclaim
+	 * is pointless.
+	 */
+	if (PageUnevictable(page))
+		return;
+
 	if (likely(get_page_unless_zero(page))) {
 		struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
 
-- 
1.7.1

