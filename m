Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab1CXJwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:52:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54695 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab1CXJww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:52:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eJlQe1r3whH1MUlY1NuX8IaUwi5+FRLcRQsmpRHahcdpuLn4VvntH7qlUTcBNnZc62
         YPWOzQJYqXAPZcf1c5KlBDEDIw5sAwKpuiCPMwiL1z68n7OSiWsOaVfOJUIGsV87xJRj
         LTXUGA9yxCevFUDNDrt0pX/cII9kLjAWs2cGc=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH] Accelerate OOM killing
Date: Thu, 24 Mar 2011 18:52:33 +0900
Message-Id: <1300960353-2596-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I test Andrey's problem, I saw the livelock and sysrq-t says
there are many tasks in cond_resched after try_to_free_pages.

If did_some_progress is false, cond_resched could delay oom killing so
It might be killing another task.

This patch accelerates oom killing without unnecessary giving CPU
to another task. It could help avoding unnecessary another task killing
and livelock situation a litte bit.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/page_alloc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cdef1d4..b962575 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1887,11 +1887,10 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	lockdep_clear_current_reclaim_state();
 	current->flags &= ~PF_MEMALLOC;
 
-	cond_resched();
-
 	if (unlikely(!(*did_some_progress)))
 		return NULL;
 
+	cond_resched();
 retry:
 	page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
-- 
1.7.1

