Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1EAPET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:04:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54857 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab1EAPDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PSmaV/Sffj5BY83u32gSe2a0vt3fA0K4ALpvj8LWq7tAsQDDdH/+Vmiwj8Q+C9lwbC
         /hKWLdsoLHAg7iHdWXgIWj+4jg60yhv/r6rXm5Ps70G4A7T1JLAx9AU3XNEU0IzL0BKN
         z/jB7DIkUsODGrUtExptdTkxQbR6SPx2+mS+E=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Ying Han <yinghan@google.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 1/2] Check PageUnevictable in lru_deactivate_fn
Date: Mon,  2 May 2011 00:03:30 +0900
Message-Id: <c7a7b3ceafe4fdc4bc038774374504827c01481f.1304261567.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1304261567.git.minchan.kim@gmail.com>
References: <cover.1304261567.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1304261567.git.minchan.kim@gmail.com>
References: <cover.1304261567.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lru_deactivate_fn should not move page which in on unevictable lru
into inactive list. Otherwise, we can meet BUG when we use isolate_lru_pages
as __isolate_lru_page could return -EINVAL.
It's really BUG and let's fix it.

Reported-by: Ying Han <yinghan@google.com>
Tested-by: Ying Han <yinghan@google.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/swap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index a83ec5a..2e9656d 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -429,6 +429,9 @@ static void lru_deactivate_fn(struct page *page, void *arg)
 	if (!PageLRU(page))
 		return;
 
+	if (PageUnevictable(page))
+		return;
+
 	/* Some processes are using the page */
 	if (page_mapped(page))
 		return;
-- 
1.7.1

