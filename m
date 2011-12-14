Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1LNHsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:48:54 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48027 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1LNHsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:48:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 14 Dec 2011 16:47:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH 0/4] memcg: simplify LRU handling.
Message-Id: <20111214164734.4d7d6d97.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series is onto linux-next + 
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch

The 1st purpose of this patch is reduce overheads of mem_cgroup_add/del_lru.
They uses some atomic ops. After this patch, lru handling routine will be

==
struct lruvec *mem_cgroup_lru_add_list(struct zone *zone, struct page *page,
                                       enum lru_list lru)
{
        struct mem_cgroup_per_zone *mz;
        struct mem_cgroup *memcg;
        struct page_cgroup *pc;

        if (mem_cgroup_disabled())
                return &zone->lruvec;

        pc = lookup_page_cgroup(page);
        memcg = pc->mem_cgroup;
        VM_BUG_ON(!memcg);
        mz = page_cgroup_zoneinfo(memcg, page);
        /* compound_order() is stabilized through lru_lock */
        MEM_CGROUP_ZSTAT(mz, lru) += 1 << compound_order(page);
        return &mz->lruvec;
}
==

simple and no atomic ops. Because of Johannes works in linux-next,
this can be archived by very straightforward way.

Thanks,
-Kame


