Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1BUOH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:07:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63234 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab1BUOH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:07:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ODo6Od477Mn3D/djgVYhgxNHgmGxY/QZQ+mCGNWU6tmcbO6wd3LZ5rh+vGG7PCi9RS
         SXEbQmPU5pyBieBEq8ahr5Ai8wA0Y71Nyi+9+sgOWDo4aqs7LMAwaV9FvQQe+uEVYAZZ
         6cz2cVkT0dv1xOEBzVvhY7+90ei4N45hh4RWg=
MIME-Version: 1.0
In-Reply-To: <20110221084014.GC25382@cmpxchg.org>
References: <cover.1298212517.git.minchan.kim@gmail.com>
	<c76a1645aac12c3b8ffe2cc5738033f5a6da8d32.1298212517.git.minchan.kim@gmail.com>
	<20110221084014.GC25382@cmpxchg.org>
Date: Mon, 21 Feb 2011 23:07:26 +0900
Message-ID: <AANLkTikkGGQdxtshsWb8k2Lb89LwWznNjZLBB5i=UQrm@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] memcg: move memcg reclaimable page into tail of
 inactive list
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Barrett <damentz@liquorix.net>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 5:40 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Sun, Feb 20, 2011 at 11:43:37PM +0900, Minchan Kim wrote:
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -813,6 +813,33 @@ void mem_cgroup_del_lru(struct page *page)
>>       mem_cgroup_del_lru_list(page, page_lru(page));
>>  }
>>
>> +/*
>> + * Writeback is about to end against a page which has been marked for immediate
>> + * reclaim.  If it still appears to be reclaimable, move it to the tail of the
>> + * inactive list.
>> + */
>> +void mem_cgroup_rotate_reclaimable_page(struct page *page)
>> +{
>> +     struct mem_cgroup_per_zone *mz;
>> +     struct page_cgroup *pc;
>> +     enum lru_list lru = page_lru(page);
>> +
>> +     if (mem_cgroup_disabled())
>> +             return;
>> +
>> +     pc = lookup_page_cgroup(page);
>> +     /*
>> +      * Used bit is set without atomic ops but after smp_wmb().
>> +      * For making pc->mem_cgroup visible, insert smp_rmb() here.
>> +      */
>> +     smp_rmb();
>> +     /* unused or root page is not rotated. */
>> +     if (!PageCgroupUsed(pc) || mem_cgroup_is_root(pc->mem_cgroup))
>> +             return;
>
> The placement of this barrier is confused and has been fixed up in the
> meantime in other places.  It has to be between PageCgroupUsed() and
> accessing pc->mem_cgroup.  You can look at the other memcg lru
> functions for reference.

Yes. I saw your patch at that time but forgot it.
I will resend fixed version.
Thanks.

-- 
Kind regards,
Minchan Kim
