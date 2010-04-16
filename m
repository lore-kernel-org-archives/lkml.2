Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab0DPHVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 03:21:00 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:63542 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0DPHU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 03:20:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fcbdFBh1fDwYVA1jhLmXrOdQ/SMM3YSbRzufNF586U4RWONpmUTumGHt74hrmVsYbg
         cXFxiw2KJYAa0zHBLNlEaAArKN0ANMejf/AwEhVpzHIqov7Xbk5wk+Ud4HKKBInwsOIv
         s00zOu4pZU+aijdZtV/Dfr8eFIYMRBeoiLR70=
MIME-Version: 1.0
In-Reply-To: <20100416061226.GJ5683@laptop>
References: <1271089672.7196.63.camel@localhost.localdomain>
	 <1271249354.7196.66.camel@localhost.localdomain>
	 <m2g28c262361004140813j5d70a80fy1882d01436d136a6@mail.gmail.com>
	 <1271262948.2233.14.camel@barrios-desktop>
	 <1271320388.2537.30.camel@localhost> <20100416061226.GJ5683@laptop>
Date: Fri, 16 Apr 2010 16:20:58 +0900
Message-ID: <m2g28c262361004160020r6c85f5e6g61c3cb0d03b9cc6e@mail.gmail.com>
Subject: Re: vmalloc performance
From: Minchan Kim <minchan.kim@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 3:12 PM, Nick Piggin <npiggin@suse.de> wrote:
> On Thu, Apr 15, 2010 at 09:33:08AM +0100, Steven Whitehouse wrote:
>> Hi,
>>
>> On Thu, 2010-04-15 at 01:35 +0900, Minchan Kim wrote:
>> > On Thu, 2010-04-15 at 00:13 +0900, Minchan Kim wrote:
>> > > On Wed, Apr 14, 2010 at 9:49 PM, Steven Whitehouse <swhiteho@redhat.com> wrote:
>> > > >> When this module is run on my x86_64, 8 core, 12 Gb machine, then on an
>> > > >> otherwise idle system I get the following results:
>> > > >>
>> > > >> vmalloc took 148798983 us
>> > > >> vmalloc took 151664529 us
>> > > >> vmalloc took 152416398 us
>> > > >> vmalloc took 151837733 us
>> > > >>
>> > > >> After applying the two line patch (see the same bz) which disabled the
>> > > >> delayed removal of the structures, which appears to be intended to
>> > > >> improve performance in the smp case by reducing TLB flushes across cpus,
>> > > >> I get the following results:
>> > > >>
>> > > >> vmalloc took 15363634 us
>> > > >> vmalloc took 15358026 us
>> > > >> vmalloc took 15240955 us
>> > > >> vmalloc took 15402302 us
>> >
>> >
>> > > >>
>> > > >> So thats a speed up of around 10x, which isn't too bad. The question is
>> > > >> whether it is possible to come to a compromise where it is possible to
>> > > >> retain the benefits of the delayed TLB flushing code, but reduce the
>> > > >> overhead for other users. My two line patch basically disables the delay
>> > > >> by forcing a removal on each and every vfree.
>> > > >>
>> > > >> What is the correct way to fix this I wonder?
>> > > >>
>> > > >> Steve.
>> > > >>
>> >
>> > In my case(2 core, mem 2G system), 50300661 vs 11569357.
>> > It improves 4 times.
>> >
>> Looking at the code, it seems that the limit, against which my patch
>> removes a test, scales according to the number of cpu cores. So with
>> more cores, I'd expect the difference to be greater. I have a feeling
>> that the original reporter had a greater number than the 8 of my test
>> machine.
>>
>> > It would result from larger number of lazy_max_pages.
>> > It would prevent many vmap_area freed.
>> > So alloc_vmap_area takes long time to find new vmap_area. (ie, lookup
>> > rbtree)
>> >
>> > How about calling purge_vmap_area_lazy at the middle of loop in
>> > alloc_vmap_area if rbtree lookup were long?
>> >
>> That may be a good solution - I'm happy to test any patches but my worry
>> is that any change here might result in a regression in whatever
>> workload the lazy purge code was originally designed to improve. Is
>> there any way to test that I wonder?
>
> Ah this is interesting. What we could do is have a "free area cache"
> like the user virtual memory allocator has, which basically avoids
> restarting the search from scratch.
>
> Or we could perhaps go one better and do a more sophisticated free space
> allocator.


AFAIR, vmalloc's performance regression is first. I am not sure
whoever suffers from it and
didn't report. Anyway, with fist report, complicated allocator
implement is rather overkill, I think.

So I votes free_area_cache.

Early ending of lookup from last cache point makes overflow fast and
it results in flush.
I think it's good in that it doesn't depends on system resource environment.
And it could improve search time than one from scratch unless it's
very unfortunate.

>
> Bigger systems will indeed get hurt by increasing flushes so I'd prefer
> to avoid that. But that's not a good justification for a slowdown for
> small systems. What good is having cake if you can't also eat it? :)

Indeed. :)

-- 
Kind regards,
Minchan Kim
