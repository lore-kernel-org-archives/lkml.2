Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1B1Cf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 21:35:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33309 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1B1Cf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 21:35:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mz05q2TXajA5wPVf9HwjsFfUcHFu3rhcng1ScJGutWUsJBtVPRiQJaW9kOXZaIglNu
         mkKOFUI5yOrSft/2gJE3KLBDSC79fr1B3DAGe5DZ7xp/bimZP5ATVsB5cBKTvYH9qdn+
         oz79p0OxyrCA7W0ospJ8bV3C02rloF1yP4eRs=
MIME-Version: 1.0
In-Reply-To: <20110228111822.41484020.nishimura@mxp.nes.nec.co.jp>
References: <1298821765-3167-1-git-send-email-minchan.kim@gmail.com>
	<20110228111822.41484020.nishimura@mxp.nes.nec.co.jp>
Date: Mon, 28 Feb 2011 11:35:26 +0900
Message-ID: <AANLkTik44K60MLTw_m431xd3ZFatAo=9O+42jUHscdFR@mail.gmail.com>
Subject: Re: [PATCH] memcg: clean up migration
From: Minchan Kim <minchan.kim@gmail.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Daisuke

On Mon, Feb 28, 2011 at 11:18 AM, Daisuke Nishimura
<nishimura@mxp.nes.nec.co.jp> wrote:
> On Mon, 28 Feb 2011 00:49:25 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> This patch cleans up unncessary BUG_ON check and confusing
>> charge variable.
>>
>> That's because memcg charge/uncharge could be handled by
>> mem_cgroup_[prepare/end] migration itself so charge local variable
>> in unmap_and_move lost the role since we introduced 01b1ae63c2.
>>
>> And mem_cgroup_prepare_migratio return 0 if only it is successful.
>> Otherwise, it jumps to unlock label to clean up so BUG_ON(charge)
>> isn;t meaningless.
>>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
>> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>
> It looks good to me, but I have one minor comment.
>
>> ---
>>  mm/memcontrol.c |    1 +
>>  mm/migrate.c    |   14 ++++----------
>>  2 files changed, 5 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 2fc97fc..6832926 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2872,6 +2872,7 @@ static inline int mem_cgroup_move_swap_account(swp_entry_t entry,
>>  /*
>>   * Before starting migration, account PAGE_SIZE to mem_cgroup that the old
>>   * page belongs to.
>> + * Return 0 if charge is successful. Otherwise return -errno.
>>   */
>>  int mem_cgroup_prepare_migration(struct page *page,
>>       struct page *newpage, struct mem_cgroup **ptr, gfp_t gfp_mask)
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index eb083a6..737c2e5 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -622,7 +622,6 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>>       int *result = NULL;
>>       struct page *newpage = get_new_page(page, private, &result);
>>       int remap_swapcache = 1;
>> -     int charge = 0;
>>       struct mem_cgroup *mem;
>>       struct anon_vma *anon_vma = NULL;
>>
>> @@ -637,9 +636,7 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>>               if (unlikely(split_huge_page(page)))
>>                       goto move_newpage;
>>
>> -     /* prepare cgroup just returns 0 or -ENOMEM */
>>       rc = -EAGAIN;
>> -
>>       if (!trylock_page(page)) {
>>               if (!force)
>>                       goto move_newpage;
>> @@ -678,13 +675,11 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>>       }
>>
>>       /* charge against new page */
>> -     charge = mem_cgroup_prepare_migration(page, newpage, &mem, GFP_KERNEL);
>> -     if (charge == -ENOMEM) {
>> -             rc = -ENOMEM;
>> +     rc = mem_cgroup_prepare_migration(page, newpage, &mem, GFP_KERNEL);
>> +     if (rc)
>>               goto unlock;
>> -     }
>> -     BUG_ON(charge);
>>
>> +     rc = -EAGAIN;
>>       if (PageWriteback(page)) {
>>               if (!force || !sync)
>>                       goto uncharge;
> How about
>
>        if (mem_cgroup_prepare_migration(..)) {
>                rc = -ENOMEM;
>                goto unlock;
>        }
>
> ?
>
> Re-setting "rc" to -EAGAIN is not necessary in this case.
> "if (mem_cgroup_...)" is commonly used in many places.
>
It works now but Johannes doesn't like it and me, either.
It makes unnecessary dependency which mem_cgroup_preparre_migration
can't propagate error to migrate_pages.
Although we don't need it, I want to remove such unnecessary dependency.

> Anyway,
>
>        Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>
>

Thanks!.

-- 
Kind regards,
Minchan Kim
