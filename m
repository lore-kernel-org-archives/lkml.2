Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab0CQDAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:00:32 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63317 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0CQDAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:00:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W7B4UwUn8hAaLi5QR2RREXOn96H+yd+oAnhu6SH2TUy25u1BcKBmtotDOMLirgs6Rw
         V58NtnR3v5OBEKY+c+35JV3oxJGWFYg/EU7jrESay7I7kd7HGBeS+5GUkRkE7GuYQ01a
         lAA17RT+B7SZ4yipKO3/DChwzN0r+R//A6bPo=
MIME-Version: 1.0
In-Reply-To: <20100317111234.d224f3fd.kamezawa.hiroyu@jp.fujitsu.com>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
	 <1268412087-13536-3-git-send-email-mel@csn.ul.ie>
	 <28c262361003141728g4aa40901hb040144c5a4aeeed@mail.gmail.com>
	 <20100315143420.6ec3bdf9.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100315112829.GI18274@csn.ul.ie>
	 <1268657329.1889.4.camel@barrios-desktop>
	 <20100315142124.GL18274@csn.ul.ie>
	 <20100316084934.3798576c.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100317111234.d224f3fd.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 17 Mar 2010 12:00:15 +0900
Message-ID: <28c262361003162000w34cc13ecnbd32840a0df80f95@mail.gmail.com>
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

On Wed, Mar 17, 2010 at 11:12 AM, KAMEZAWA Hiroyuki
> BTW, I doubt freeing anon_vma can happen even when we check mapcount.
>
> "unmap" is 2-stage operation.
>        1. unmap_vmas() => modify ptes, free pages, etc.
>        2. free_pgtables() => free pgtables, unlink vma and free it.
>
> Then, if migration is enough slow.
>
>        Migration():                            Exit():
>        check mapcount
>        rcu_read_lock
>        pte_lock
>        replace pte with migration pte
>        pte_unlock
>                                                pte_lock
>        copy page etc...                        zap pte (clear pte)
>                                                pte_unlock
>                                                free_pgtables
>                                                ->free vma
>                                                ->free anon_vma
>        pte_lock
>        remap pte with new pfn(fail)
>        pte_unlock
>
>        lock anon_vma->lock             # modification after free.
>        check list is empty

check list is empty?
Do you mean anon_vma->head?

If it is, is it possible that that list isn't empty since anon_vma is
used by others due to
SLAB_DESTROY_BY_RCU?

but such case is handled by page_check_address, vma_address, I think.

>        unlock anon_vma->lock
>        free anon_vma
>        rcu_read_unlock
>
>
> Hmm. IIUC, anon_vma is allocated as SLAB_DESTROY_BY_RCU. Then, while
> rcu_read_lock() is taken, anon_vma is anon_vma even if freed. But it
> may reused as anon_vma for someone else.
> (IOW, it may be reused but never pushed back to general purpose memory
>  until RCU grace period.)
> Then, touching anon_vma->lock never cause any corruption.
>
> Does use-after-free check for SLAB_DESTROY_BY_RCU correct behavior ?

Could you elaborate your point?

> Above case is not use-after-free. It's safe and expected sequence.
>
> Thanks,
> -Kame
>
>
>
>> > ---
>> >  mm/migrate.c |   13 +++++++++++++
>> >  1 files changed, 13 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/mm/migrate.c b/mm/migrate.c
>> > index 98eaaf2..6eb1efe 100644
>> > --- a/mm/migrate.c
>> > +++ b/mm/migrate.c
>> > @@ -603,6 +603,19 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>> >      */
>> >     if (PageAnon(page)) {
>> >             rcu_read_lock();
>> > +
>> > +           /*
>> > +            * If the page has no mappings any more, just bail. An
>> > +            * unmapped anon page is likely to be freed soon but worse,
>> > +            * it's possible its anon_vma disappeared between when
>> > +            * the page was isolated and when we reached here while
>> > +            * the RCU lock was not held
>> > +            */
>> > +           if (!page_mapcount(page)) {
>> > +                   rcu_read_unlock();
>> > +                   goto uncharge;
>> > +           }
>> > +
>> >             rcu_locked = 1;
>> >             anon_vma = page_anon_vma(page);
>> >             atomic_inc(&anon_vma->migrate_refcount);
>> >
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
>
>



-- 
Kind regards,
Minchan Kim
