Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1KXJGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:06:50 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42665 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab1KXJGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:06:47 -0500
Date: Thu, 24 Nov 2011 10:06:39 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/8] mm: memcg: remove unneeded checks from
 uncharge_page()
Message-ID: <20111124090639.GD6843@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <1322062951-1756-7-git-send-email-hannes@cmpxchg.org>
 <20111124090619.895988e7.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124090619.895988e7.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 09:06:19AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 23 Nov 2011 16:42:29 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > From: Johannes Weiner <jweiner@redhat.com>
> > 
> > mem_cgroup_uncharge_page() is only called on either freshly allocated
> > pages without page->mapping or on rmapped PageAnon() pages.  There is
> > no need to check for a page->mapping that is not an anon_vma.
> > 
> > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> 
> For making our assumption clearer to readers of codes,
> VM_BUG_ON(page->mapping && !PageAnon(page)) please.

Yep, delta patch below.

> Anyway,
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks!

---
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: memcg: remove unneeded checks from uncharge_page() fix

Document page state assumptions and catch if they are violated in
uncharge_page().

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 mm/memcontrol.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2f1fdc4..872dae1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2992,6 +2992,7 @@ void mem_cgroup_uncharge_page(struct page *page)
 	/* early check. */
 	if (page_mapped(page))
 		return;
+	VM_BUG_ON(page->mapping && !PageAnon(page));
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_MAPPED);
 }
 
-- 
1.7.6.4

