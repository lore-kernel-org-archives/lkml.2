Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab0CQEPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 00:15:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62800 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab0CQEPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 00:15:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j8eANTWtc3oRWPZAZx1RfgMoJPbrwLD1wQRC+NNeLqniO1B/rJnvdVr+BWnVYczB15
         Ntj5+MhVPzzdwhK8v1562Axd+jr/RQsIJbGVSSzULhPxJq/uWCOuBRWMqKiSYtwYODwf
         R/L9aSq6k7dL0H/k+3qUgVuM8zaI0TbTdeZCM=
MIME-Version: 1.0
In-Reply-To: <20100317121551.b619f55b.kamezawa.hiroyu@jp.fujitsu.com>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
	 <28c262361003141728g4aa40901hb040144c5a4aeeed@mail.gmail.com>
	 <20100315143420.6ec3bdf9.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100315112829.GI18274@csn.ul.ie>
	 <1268657329.1889.4.camel@barrios-desktop>
	 <20100315142124.GL18274@csn.ul.ie>
	 <20100316084934.3798576c.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100317111234.d224f3fd.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262361003162000w34cc13ecnbd32840a0df80f95@mail.gmail.com>
	 <20100317121551.b619f55b.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 17 Mar 2010 13:15:14 +0900
Message-ID: <28c262361003162115k79e3d40fka6e1def6472823ef@mail.gmail.com>
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped 
	anonymous pages
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 12:15 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 17 Mar 2010 12:00:15 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> On Wed, Mar 17, 2010 at 11:12 AM, KAMEZAWA Hiroyuki
>> > BTW, I doubt freeing anon_vma can happen even when we check mapcount.
>> >
>> > "unmap" is 2-stage operation.
>> >        1. unmap_vmas() => modify ptes, free pages, etc.
>> >        2. free_pgtables() => free pgtables, unlink vma and free it.
>> >
>> > Then, if migration is enough slow.
>> >
>> >        Migration():                            Exit():
>> >        check mapcount
>> >        rcu_read_lock
>> >        pte_lock
>> >        replace pte with migration pte
>> >        pte_unlock
>> >                                                pte_lock
>> >        copy page etc...                        zap pte (clear pte)
>> >                                                pte_unlock
>> >                                                free_pgtables
>> >                                                ->free vma
>> >                                                ->free anon_vma
>> >        pte_lock
>> >        remap pte with new pfn(fail)
>> >        pte_unlock
>> >
>> >        lock anon_vma->lock             # modification after free.
>> >        check list is empty
>>
>> check list is empty?
>> Do you mean anon_vma->head?
>>
> yes.
>
>> If it is, is it possible that that list isn't empty since anon_vma is
>> used by others due to
>> SLAB_DESTROY_BY_RCU?
>>
> There are 4 cases.
>        A) anon_vma->list is not empty because anon_vma is not freed.
>        B) anon_vma->list is empty because it's freed.
>        C) anon_vma->list is empty but it's reused.
>        D) anon_vma->list is not empty but it's reused.

E) anon_vma is used for other object.

That's because we don't hold rcu_read_lock.
I think Mel met this E) situation.

AFAIU, even slab page of SLAB_BY_RCU can be freed after grace period.
Do I miss something?

>
>> but such case is handled by page_check_address, vma_address, I think.
>>
> yes. Then, this corrupt nothing, as I wrote. We just modify anon_vma->lock
> and it's safe because of SLAB_DESTROY_BY_RCU.
>
>
>> >        unlock anon_vma->lock
>> >        free anon_vma
>> >        rcu_read_unlock
>> >
>> >
>> > Hmm. IIUC, anon_vma is allocated as SLAB_DESTROY_BY_RCU. Then, while
>> > rcu_read_lock() is taken, anon_vma is anon_vma even if freed. But it
>> > may reused as anon_vma for someone else.
>> > (IOW, it may be reused but never pushed back to general purpose memory
>> >  until RCU grace period.)
>> > Then, touching anon_vma->lock never cause any corruption.
>> >
>> > Does use-after-free check for SLAB_DESTROY_BY_RCU correct behavior ?
>>
>> Could you elaborate your point?
>>
>
> Ah, my point is "how use-after-free is detected ?"
>
> If use-after-free is detected by free_pages() (DEBUG_PGALLOC), it seems
> strange because DESTROY_BY_RCU guarantee that never happens.
>
> So, I assume use-after-free is detected in SLAB layer. If so,
> in above B), C), D) case, it seems there is use-after free in slab's point
> of view but it works as expected, no corruption.
>
> Then, my question is
> "Does use-after-free check for SLAB_DESTROY_BY_RCU work correctly ?"
>

I am not sure Mel found that by DEBUG_PGALLOC.
But, E) case can be founded by DEBUG_PGALLOC.

> and implies we need this patch ?
> (But this will prevent unnecessary page copy etc. by easy check.)
>
> Thanks,
> -Kame
>
>
>
>



-- 
Kind regards,
Minchan Kim
