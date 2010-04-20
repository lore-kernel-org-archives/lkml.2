Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab0DTCjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 22:39:49 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:51890 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0DTCjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 22:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uGVeM4D88cGIWVEQjkZN9vHVV43J0ljkVxK5LlYEZ+hhknmTchCde4BjlM1hxo++Cu
         IcIGkCIUmi/m6bcUCwtgLgMeAIHlvG5gKjNGr4UjweM2pm0bCycD/m0hNfKmtF+a+GCS
         rwV8h8ZhdezdQJC1ugcTWDDPP0qYyRafgo2uc=
MIME-Version: 1.0
In-Reply-To: <20100419193919.GB19264@csn.ul.ie>
References: <201004152210.o3FMA7KV001909@imap1.linux-foundation.org>
	 <20100419190133.50a13021.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100419181442.GA19264@csn.ul.ie> <20100419193919.GB19264@csn.ul.ie>
Date: Tue, 20 Apr 2010 11:39:46 +0900
Message-ID: <s2v28c262361004191939we64e5490ld59b21dc4fa5bc8d@mail.gmail.com>
Subject: Re: error at compaction (Re: mmotm 2010-04-15-14-42 uploaded
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 4:39 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Mon, Apr 19, 2010 at 07:14:42PM +0100, Mel Gorman wrote:
>> On Mon, Apr 19, 2010 at 07:01:33PM +0900, KAMEZAWA Hiroyuki wrote:
>> >
>> > mmotm 2010-04-15-14-42
>> >
>> > When I tried
>> >  # echo 0 > /proc/sys/vm/compaction
>> >
>> > I see following.
>> >
>> > My enviroment was
>> >   2.6.34-rc4-mm1+ (2010-04-15-14-42) (x86-64) CPUx8
>> >   allocating tons of hugepages and reduce free memory.
>> >
>> > What I did was:
>> >   # echo 0 > /proc/sys/vm/compact_memory
>> >
>> > Hmm, I see this kind of error at migation for the 1st time..
>> > my.config is attached. Hmm... ?
>> >
>> > (I'm sorry I'll be offline soon.)
>>
>> That's ok, thanks you for the report. I'm afraid I made little progress
>> as I spent most of the day on other bugs but I do have something for
>> you.
>>
>> First, I reproduced the problem using your .config. However, the problem does
>> not manifest with the .config I normally use which is derived from the distro
>> kernel configuration (Debian Lenny). So, there is something in your .config
>> that triggers the problem. I very strongly suspect this is an interaction
>> between migration, compaction and page allocation debug.
>
> I unexpecedly had the time to dig into this. Does the following patch fix
> your problem? It Worked For Me.

Nice catch during shot time. Below is comment.

>
> ==== CUT HERE ====
> mm,compaction: Map free pages in the address space after they get split for compaction
>
> split_free_page() is a helper function which takes a free page from the
> buddy lists and splits it into order-0 pages. It is used by memory
> compaction to build a list of destination pages. If
> CONFIG_DEBUG_PAGEALLOC is set, a kernel paging request bug is triggered
> because split_free_page() did not call the arch-allocation hooks or map
> the page into the kernel address space.
>
> This patch does not update split_free_page() as it is called with
> interrupts held. Instead it documents that callers of split_free_page()
> are responsible for calling the arch hooks and to map the page and fixes
> compaction.

Dumb question. Why can't we call arch_alloc_page and kernel_map_pages
as interrupt disabled? It's deadlock issue or latency issue?
I don't found any comment about it.
It should have added the comment around that functions. :)

And now compaction only uses split_free_page and it is exposed by mm.h.
I think it would be better to map pages inside split_free_page to
export others.(ie, making generic function).
If we can't do, how about making split_free_page static as static function?
And only uses it in compaction.

-- 
Kind regards,
Minchan Kim
