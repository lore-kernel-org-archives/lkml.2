Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab2AWMao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 07:30:44 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35900 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2AWMan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 07:30:43 -0500
MIME-Version: 1.0
In-Reply-To: <20120123104731.GA1707@cmpxchg.org>
References: <CAJd=RBBG5X8=vkdRTCZ1bvTaVxPAVun9O+yiX0SM6yDzrxDGDQ@mail.gmail.com>
	<20120123104731.GA1707@cmpxchg.org>
Date: Mon, 23 Jan 2012 20:30:42 +0800
Message-ID: <CAJd=RBDUK=LQVhQm_P3DO-bgWka=gK9cKUkm8esOaZs261EexA@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: check mem cgroup over reclaimed
From: Hillf Danton <dhillf@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 6:47 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Mon, Jan 23, 2012 at 09:55:07AM +0800, Hillf Danton wrote:
>> To avoid reduction in performance of reclaimee, checking overreclaim is added
>> after shrinking lru list, when pages are reclaimed from mem cgroup.
>>
>> If over reclaim occurs, shrinking remaining lru lists is skipped, and no more
>> reclaim for reclaim/compaction.
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/mm/vmscan.c     Mon Jan 23 00:23:10 2012
>> +++ b/mm/vmscan.c     Mon Jan 23 09:57:20 2012
>> @@ -2086,6 +2086,7 @@ static void shrink_mem_cgroup_zone(int p
>>       unsigned long nr_reclaimed, nr_scanned;
>>       unsigned long nr_to_reclaim = sc->nr_to_reclaim;
>>       struct blk_plug plug;
>> +     bool memcg_over_reclaimed = false;
>>
>>  restart:
>>       nr_reclaimed = 0;
>> @@ -2103,6 +2104,11 @@ restart:
>>
>>                               nr_reclaimed += shrink_list(lru, nr_to_scan,
>>                                                           mz, sc, priority);
>> +
>> +                             memcg_over_reclaimed = !scanning_global_lru(mz)
>> +                                     && (nr_reclaimed >= nr_to_reclaim);
>> +                             if (memcg_over_reclaimed)
>> +                                     goto out;
>
> Since this merge window, scanning_global_lru() is always false when
> the memory controller is enabled, i.e. most common configurations and
> distribution kernels.
>
> This will with quite likely have bad effects on zone balancing,
> pressure balancing between anon/file lru etc, while you haven't shown
> that any workloads actually benefit from this.
>
Hi Johannes

Thanks for your comment, first.

Impact on zone balance and lru-list balance is introduced actually, but I
dont think the patch is totally responsible for the balance mentioned,
because soft limit, embedded in mem cgroup, is setup by users according to
whatever tastes they have.

Though there is room for the patch to be fine tuned in this direction or that,
over reclaim should not be neglected entirely, but be avoided as much as we
could, or users are enforced to set up soft limit with much care not to mess
up zone balance.

Hillf
