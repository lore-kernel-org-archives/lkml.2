Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1ECOsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:48:53 -0400
Received: from mail-px0-f170.google.com ([209.85.212.170]:62652 "EHLO
	mail-px0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab1ECOss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:48:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pxh8hIWIsnqqGUXrZ0195XExCNTl07tPEZW424UaWnBcVkJGLdeBLRWFyXTw7y6jSf
         1KpAicN3YuNFzwecuaqbUc4uLZRAEGaow4ZxYfG5gBTQGbWlccbhC4wD0w3uoXEasNko
         /cHrKwtTTIiPgT476VffiRPckiTJ2qJWn2u2g=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Ying Han <yinghan@google.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v2 1/2] Check PageUnevictable in lru_deactivate_fn
Date: Tue,  3 May 2011 23:48:32 +0900
Message-Id: <bdccc644d628b8da0f1bc52332370191903371b2.1304433952.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1304433952.git.minchan.kim@gmail.com>
References: <cover.1304433952.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1304433952.git.minchan.kim@gmail.com>
References: <cover.1304433952.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lru_deactivate_fn should not move page which in on unevictable lru
into inactive list. Otherwise, we can meet BUG when we use isolate_lru_pages
as __isolate_lru_page could return -EINVAL.
It's really BUG and let's fix it.

Reported-by: Ying Han <yinghan@google.com>
Tested-by: Ying Han <yinghan@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel<riel@redhat.com>
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

