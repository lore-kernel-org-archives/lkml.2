Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab1CAWWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:22:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40452 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab1CAWWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AWam8A9zTU9bWVCNmia93QQi8MHib9IFHKfQh8/AtafZEdONgfIliH+TQoVio0FG3/
         JXR2JjAC2c/QQzJkMwgKBvYU7k3U7Ge8gZI+L4arapChu8uyHhpAraRFX3Hm9AXKiGzs
         TxgZ4vLQfb4TrOPWeFTYzWGRmtQZubSOIj2sg=
MIME-Version: 1.0
In-Reply-To: <20110301161900.GA21860@random.random>
References: <20110301153558.GA2031@barrios-desktop>
	<20110301161900.GA21860@random.random>
Date: Wed, 2 Mar 2011 07:22:33 +0900
Message-ID: <AANLkTimpTyaAU0JzFKp4s14w=ciq152MWSmbgn8xtkOx@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: compaction: Minimise the time IRQs are disabled
 while isolating pages for migration
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 1:19 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Wed, Mar 02, 2011 at 12:35:58AM +0900, Minchan Kim wrote:
>> On Tue, Mar 01, 2011 at 01:49:25PM +0900, KAMEZAWA Hiroyuki wrote:
>> > On Tue, 1 Mar 2011 13:11:46 +0900
>> > Minchan Kim <minchan.kim@gmail.com> wrote:
>> >
>> > > On Tue, Mar 01, 2011 at 08:42:09AM +0900, KAMEZAWA Hiroyuki wrote:
>> > > > On Mon, 28 Feb 2011 10:18:27 +0000
>> > > > Mel Gorman <mel@csn.ul.ie> wrote:
>> > > >
>> > > > > > BTW, can't we drop disable_irq() from all lru_lock related codes ?
>> > > > > >
>> > > > >
>> > > > > I don't think so - at least not right now. Some LRU operations such as LRU
>> > > > > pagevec draining are run from IPI which is running from an interrupt so
>> > > > > minimally spin_lock_irq is necessary.
>> > > > >
>> > > >
>> > > > pagevec draining is done by workqueue(schedule_on_each_cpu()).
>> > > > I think only racy case is just lru rotation after writeback.
>> > >
>> > > put_page still need irq disable.
>> > >
>> >
>> > Aha..ok. put_page() removes a page from LRU via __page_cache_release().
>> > Then, we may need to remove a page from LRU under irq context.
>> > Hmm...
>>
>> But as __page_cache_release's comment said, normally vm doesn't release page in
>> irq context. so it would be rare.
>> If we can remove it, could we change all of spin_lock_irqsave with spin_lock?
>> If it is right, I think it's very desirable to reduce irq latency.
>>
>> How about this? It's totally a quick implementation and untested.
>> I just want to hear opinions of you guys if the work is valuable or not before
>> going ahead.
>
> pages freed from irq shouldn't be PageLRU.

Hmm..
As looking code, it seems to be no problem and I didn't see the any
comment about such rule. It should have been written down in
__page_cache_release.
Just out of curiosity.
What kinds of problem happen if we release lru page in irq context?

>
> deferring freeing to workqueue doesn't look ok. firewall loads runs
> only from irq and this will cause some more work and a delay in the
> freeing. I doubt it's worhwhile especially for the lru_lock.
>

As you said, if it is for decreasing lock contention in SMP to deliver
overall better performance, maybe we need to check again how much it
helps.
If it doesn't help much, could we remove irq_save/restore of lru_lock?
Do you know any benchmark to prove it had a benefit at that time or
any thread discussing about that in lkml?

Thanks, Andrea.

-- 
Kind regards,
Minchan Kim
