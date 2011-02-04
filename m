Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1BDJ1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 04:27:07 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:38309 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab1BDJ1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 04:27:04 -0500
Date: Fri, 4 Feb 2011 10:26:50 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] memcg: no uncharged pages reach page_cgroup_zoneinfo
Message-ID: <20110204092650.GB2289@cmpxchg.org>
References: <1296743166-9412-1-git-send-email-hannes@cmpxchg.org>
 <1296743166-9412-2-git-send-email-hannes@cmpxchg.org>
 <20110204090145.7f1918fc.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110204090145.7f1918fc.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 09:01:45AM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu,  3 Feb 2011 15:26:02 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > All callsites check PCG_USED before passing pc->mem_cgroup, so the
> > latter is never NULL.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thank you!

> I want BUG_ON() here.

I thought about it too at first.  But look at the callsites, all but
one of them do not even expect this function to return NULL, so if
this condition had ever been true, we would have seen crashes in the
callsites.

The only caller that checks for NULL is
mem_cgroup_get_reclaim_stat_from_page() and I propose to remove that
as well; patch attached.

Do you insist on the BUG_ON?

---
Subject: memcg: page_cgroup_zoneinfo never returns NULL

For a page charged to a memcg, there is always valid memcg per-zone
info.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4a4483d..5f974b3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1017,9 +1017,6 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
 	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 	smp_rmb();
 	mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
-	if (!mz)
-		return NULL;
-
 	return &mz->reclaim_stat;
 }
 
