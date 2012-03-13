Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab2CMXQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:16:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51332 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2CMXQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:16:19 -0400
MIME-Version: 1.0
In-Reply-To: <4F5C602B.4050806@parallels.com>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
	<1331325556-16447-4-git-send-email-ssouhlal@FreeBSD.org>
	<4F5C602B.4050806@parallels.com>
Date: Tue, 13 Mar 2012 16:16:18 -0700
Message-ID: <CABCjUKBUQ7QS-pJbzrN=8_AFj20uP+dgOH44AWfK4ZecpprybA@mail.gmail.com>
Subject: Re: [PATCH v2 03/13] memcg: Uncharge all kmem when deleting a cgroup.
From: Suleiman Souhlal <suleiman@google.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, cl@linux.com,
        yinghan@google.com, hughd@google.com, gthelen@google.com,
        peterz@infradead.org, dan.magenheimer@oracle.com, hannes@cmpxchg.org,
        mgorman@suse.de, James.Bottomley@hansenpartnership.com,
        linux-mm@kvack.org, devel@openvz.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 12:19 AM, Glauber Costa <glommer@parallels.com> wrote:
> On 03/10/2012 12:39 AM, Suleiman Souhlal wrote:
>>
>> Signed-off-by: Suleiman Souhlal<suleiman@google.com>
>> ---
>>  mm/memcontrol.c |   31 ++++++++++++++++++++++++++++++-
>>  1 files changed, 30 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index e6fd558..6fbb438 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -382,6 +382,7 @@ static void mem_cgroup_get(struct mem_cgroup *memcg);
>>  static void mem_cgroup_put(struct mem_cgroup *memcg);
>>  static void memcg_kmem_init(struct mem_cgroup *memcg,
>>      struct mem_cgroup *parent);
>> +static void memcg_kmem_move(struct mem_cgroup *memcg);
>>
>>  static inline bool
>>  mem_cgroup_test_flag(const struct mem_cgroup *memcg, enum memcg_flags
>> flag)
>> @@ -3700,6 +3701,7 @@ static int mem_cgroup_force_empty(struct mem_cgroup
>> *memcg, bool free_all)
>>        int ret;
>>        int node, zid, shrink;
>>        int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
>> +       unsigned long usage;
>>        struct cgroup *cgrp = memcg->css.cgroup;
>>
>>        css_get(&memcg->css);
>> @@ -3719,6 +3721,8 @@ move_account:
>>                /* This is for making all *used* pages to be on LRU. */
>>                lru_add_drain_all();
>>                drain_all_stock_sync(memcg);
>> +               if (!free_all)
>> +                       memcg_kmem_move(memcg);
>
> Any reason we're not moving kmem charges when free_all is set as well?

Because the slab moving code expects to be synchronized with
allocations (and itself). We can't call it when there are still tasks
in the cgroup.

-- Suleiman
