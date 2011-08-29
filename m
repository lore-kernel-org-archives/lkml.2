Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1H2H2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:28:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31847 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab1H2H2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:28:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=K+lvEV1QyDo4j4QrcSBkdMUcV+b8/jkpdjACFcqzu5Ym5Vl4sytOl3M1XN/qZ6Tf8
	azlwiwYXeBi+ILNvSbwLw==
MIME-Version: 1.0
In-Reply-To: <20110720003653.GA667@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<1306909519-7286-8-git-send-email-hannes@cmpxchg.org>
	<CALWz4iwDGD8xoUbzi=9Sy7C-njcYqmka_25rQL8RhkN_ArLgDw@mail.gmail.com>
	<20110720003653.GA667@cmpxchg.org>
Date: Mon, 29 Aug 2011 00:28:22 -0700
Message-ID: <CALWz4iy-EXmRrwPGW=d=0iHGVvKfB1yQEQBb2QYGmPCKHZtE=g@mail.gmail.com>
Subject: Re: [patch 7/8] vmscan: memcg-aware unevictable page rescue scanner
From: Ying Han <yinghan@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 5:36 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Tue, Jul 19, 2011 at 03:47:43PM -0700, Ying Han wrote:
>> On Tue, May 31, 2011 at 11:25 PM, Johannes Weiner <hannes@cmpxchg.org>wrote:
>>
>> > Once the per-memcg lru lists are exclusive, the unevictable page
>> > rescue scanner can no longer work on the global zone lru lists.
>> >
>> > This converts it to go through all memcgs and scan their respective
>> > unevictable lists instead.
>> >
>> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>> > ---
>> >  include/linux/memcontrol.h |    2 +
>> >  mm/memcontrol.c            |   11 +++++++++
>> >  mm/vmscan.c                |   53
>> > +++++++++++++++++++++++++++----------------
>> >  3 files changed, 46 insertions(+), 20 deletions(-)
>> >
>> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> > index cb02c00..56c1def 100644
>> > --- a/include/linux/memcontrol.h
>> > +++ b/include/linux/memcontrol.h
>> > @@ -60,6 +60,8 @@ extern void mem_cgroup_cancel_charge_swapin(struct
>> > mem_cgroup *ptr);
>> >
>> >  extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct
>> > *mm,
>> >                                        gfp_t gfp_mask);
>> > +struct page *mem_cgroup_lru_to_page(struct zone *, struct mem_cgroup *,
>> > +                                   enum lru_list);
>> >
>>
>> Did we miss a #ifdef case for this function? I got compile error by
>> disabling memcg.
>
> I assume it's because the call to it is not optimized away properly in
> the disabled case.  I'll have it fixed in the next round, thanks for
> letting me know.
>

Hi Johannes:

This is the change for the hierarchy_walk() sent on the other patch,
also including a fix. Please consider to fold in your patch:

Fix the hierarchy_walk() in the unevictable page rescue scanner

the patch including changes
1. adjust the change in hierarchy_walk() which needs to hold the reference to
the first mem_cgroup.
2. add stop_hierarchy_walk() at the end which is missed on the original patch.

Signed-off-by: Ying Han <yinghan@google.com>

Change-Id: I72fb5d351faf0f111c8c99edd90b6cfee6281d3f
---
 mm/memcontrol.c |    3 +++
 mm/vmscan.c     |    7 ++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9bcd429..426092b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1514,6 +1514,9 @@ void mem_cgroup_stop_hierarchy_walk(struct
mem_cgroup *target,
 >------>------->------->-------    struct mem_cgroup *first,
 >------>------->------->-------    struct mem_cgroup *mem)
 {
+>------if (!target)
+>------>-------target = root_mem_cgroup;
+
 >------if (mem && mem != target)
 >------>-------css_put(&mem->css);
·
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 290998e..fd9593b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4110,9 +4110,9 @@ static struct page *lru_tailpage(struct zone
*zone, struct mem_cgroup *mem,
 #define SCAN_UNEVICTABLE_BATCH_SIZE 16UL /* arbitrary lock hold batch size */
 static void scan_zone_unevictable_pages(struct zone *zone)
 {
->------struct mem_cgroup *first, *mem = NULL;
+>------struct mem_cgroup *first, *mem;
·
->------first = mem = mem_cgroup_hierarchy_walk(NULL, mem);
+>------first = mem = mem_cgroup_hierarchy_walk(NULL, NULL, NULL);
 >------do {
 >------>-------unsigned long nr_to_scan;
·
@@ -4139,8 +4139,9 @@ static void scan_zone_unevictable_pages(struct zone *zone)
 >------>------->-------spin_unlock_irq(&zone->lru_lock);
 >------>------->-------nr_to_scan -= batch_size;
 >------>-------}
->------>-------mem = mem_cgroup_hierarchy_walk(NULL, mem);
+>------>-------mem = mem_cgroup_hierarchy_walk(NULL, first, mem);
 >------} while (mem != first);
+>------mem_cgroup_stop_hierarchy_walk(NULL, first, mem);
 }

--Ying
