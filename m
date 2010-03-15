Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936535Ab0COOdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:33:07 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:41980 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab0COOdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M05BohbvxOeFy4pXvn47OTsfH7RkpxdV9EFwWm0YP8XIodP/lT1eYeQUp80XCAWJij
         xm2PNJScvpaxv2gwLAto3Efjnh8J2Rh6UZvTW96+wtkhnjJhOJrkg9j9KGDlftmwZKEc
         X8QVkiR9r3+sJ2Y7HgzrKvkNbN6fHLhRosNYI=
MIME-Version: 1.0
In-Reply-To: <20100315142124.GL18274@csn.ul.ie>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
	 <1268412087-13536-3-git-send-email-mel@csn.ul.ie>
	 <28c262361003141728g4aa40901hb040144c5a4aeeed@mail.gmail.com>
	 <20100315143420.6ec3bdf9.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100315112829.GI18274@csn.ul.ie>
	 <1268657329.1889.4.camel@barrios-desktop>
	 <20100315142124.GL18274@csn.ul.ie>
Date: Mon, 15 Mar 2010 23:33:01 +0900
Message-ID: <28c262361003150733j4d0c708eyfc525e1e3c5c1f7d@mail.gmail.com>
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped 
	anonymous pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
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

On Mon, Mar 15, 2010 at 11:21 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Mon, Mar 15, 2010 at 09:48:49PM +0900, Minchan Kim wrote:
>> On Mon, 2010-03-15 at 11:28 +0000, Mel Gorman wrote:
>> > The use after free looks like
>> >
>> > 1. page_mapcount(page) was zero so anon_vma was no longer reliable
>> > 2. rcu lock taken but the anon_vma at this point can already be garbage because the
>> >    process exited
>> > 3. call try_to_unmap, looks up tha anon_vma and locks it. This causes problems
>> >
>> > I thought the race would be closed but there is still a very tiny window there all
>> > right. The following alternative should close it. What do you think?
>> >
>> >         if (PageAnon(page)) {
>> >             rcu_read_lock();
>> >
>> >                 /*
>> >                  * If the page has no mappings any more, just bail. An
>> >                  * unmapped anon page is likely to be freed soon but worse,
>> >                  * it's possible its anon_vma disappeared between when
>> >                  * the page was isolated and when we reached here while
>> >                  * the RCU lock was not held
>> >                  */
>> >                 if (!page_mapcount(page)) {
>> >                     rcu_read_unlock();
>> >                         goto uncharge;
>> >             }
>> >
>> >                 rcu_locked = 1;
>> >                 anon_vma = page_anon_vma(page);
>> >                 atomic_inc(&anon_vma->external_refcount);
>> >         }
>> >
>> > The rcu_unlock label is not used here because the reference counts were not taken in
>> > the case where page_mapcount == 0.
>> >
>>
>> Please, repost above code with your use-after-free scenario comment.
>>
>
> This will be the replacement patch so.
>
> ==== CUT HERE ====
> mm,migration: Do not try to migrate unmapped anonymous pages
>
> rmap_walk_anon() was triggering errors in memory compaction that look like
> use-after-free errors. The problem is that between the page being isolated
> from the LRU and rcu_read_lock() being taken, the mapcount of the page
> dropped to 0 and the anon_vma gets freed. This can happen during memory
> compaction if pages being migrated belong to a process that exits before
> migration completes. Hence, the use-after-free race looks like
>
>  1. Page isolated for migration
>  2. Process exits
>  3. page_mapcount(page) drops to zero so anon_vma was no longer reliable
>  4. unmap_and_move() takes the rcu_lock but the anon_vma is already garbage
>  4. call try_to_unmap, looks up tha anon_vma and "locks" it but the lock
>    is garbage.
>
> This patch checks the mapcount after the rcu lock is taken. If the
> mapcount is zero, the anon_vma is assumed to be freed and no further
> action is taken.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim
