Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0DTIcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 04:32:16 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:36801 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab0DTIcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 04:32:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g3EebyYUQl7yNmbwvn1uQyp6wnAeZDozegA82KBQdlSlbl+f8biOTs71ynatIBrjHQ
         BIhgvRRih7nk6ii7YvsZl64uGgbBc/4MRL+QhIopmUZ3WZUla4zF5klNYxvtZFOxBx2c
         VtmrK+YJL9IPZk0a5igXAoOE+7NsHM3m4w/R4=
MIME-Version: 1.0
In-Reply-To: <20100420082057.GC19264@csn.ul.ie>
References: <201004152210.o3FMA7KV001909@imap1.linux-foundation.org>
	 <20100419190133.50a13021.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100419181442.GA19264@csn.ul.ie> <20100419193919.GB19264@csn.ul.ie>
	 <s2v28c262361004191939we64e5490ld59b21dc4fa5bc8d@mail.gmail.com>
	 <20100420082057.GC19264@csn.ul.ie>
Date: Tue, 20 Apr 2010 17:32:13 +0900
Message-ID: <x2h28c262361004200132q39fe5d5ex79251643a80d28b3@mail.gmail.com>
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

On Tue, Apr 20, 2010 at 5:20 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Tue, Apr 20, 2010 at 11:39:46AM +0900, Minchan Kim wrote:
>> On Tue, Apr 20, 2010 at 4:39 AM, Mel Gorman <mel@csn.ul.ie> wrote:
>> > On Mon, Apr 19, 2010 at 07:14:42PM +0100, Mel Gorman wrote:
>> >> On Mon, Apr 19, 2010 at 07:01:33PM +0900, KAMEZAWA Hiroyuki wrote:
>> >> >
>> >> > mmotm 2010-04-15-14-42
>> >> >
>> >> > When I tried
>> >> >  # echo 0 > /proc/sys/vm/compaction
>> >> >
>> >> > I see following.
>> >> >
>> >> > My enviroment was
>> >> >   2.6.34-rc4-mm1+ (2010-04-15-14-42) (x86-64) CPUx8
>> >> >   allocating tons of hugepages and reduce free memory.
>> >> >
>> >> > What I did was:
>> >> >   # echo 0 > /proc/sys/vm/compact_memory
>> >> >
>> >> > Hmm, I see this kind of error at migation for the 1st time..
>> >> > my.config is attached. Hmm... ?
>> >> >
>> >> > (I'm sorry I'll be offline soon.)
>> >>
>> >> That's ok, thanks you for the report. I'm afraid I made little progress
>> >> as I spent most of the day on other bugs but I do have something for
>> >> you.
>> >>
>> >> First, I reproduced the problem using your .config. However, the problem does
>> >> not manifest with the .config I normally use which is derived from the distro
>> >> kernel configuration (Debian Lenny). So, there is something in your .config
>> >> that triggers the problem. I very strongly suspect this is an interaction
>> >> between migration, compaction and page allocation debug.
>> >
>> > I unexpecedly had the time to dig into this. Does the following patch fix
>> > your problem? It Worked For Me.
>>
>> Nice catch during shot time. Below is comment.
>>
>> >
>> > ==== CUT HERE ====
>> > mm,compaction: Map free pages in the address space after they get split for compaction
>> >
>> > split_free_page() is a helper function which takes a free page from the
>> > buddy lists and splits it into order-0 pages. It is used by memory
>> > compaction to build a list of destination pages. If
>> > CONFIG_DEBUG_PAGEALLOC is set, a kernel paging request bug is triggered
>> > because split_free_page() did not call the arch-allocation hooks or map
>> > the page into the kernel address space.
>> >
>> > This patch does not update split_free_page() as it is called with
>> > interrupts held. Instead it documents that callers of split_free_page()
>> > are responsible for calling the arch hooks and to map the page and fixes
>> > compaction.
>>
>> Dumb question. Why can't we call arch_alloc_page and kernel_map_pages
>> as interrupt disabled?
>
> In theory, it isn't known what arch_alloc_page is going to do but more
> practically kernel_map_pages() is updating mappings and should be
> flushing all the TLBs. It can't do that with interrupts disabled.
>
> I checked X86 and it should be fine but only because it flushes the
> local CPU and appears to just hope for the best that this doesn't cause
> problems.

Okay.

>> And now compaction only uses split_free_page and it is exposed by mm.h.
>> I think it would be better to map pages inside split_free_page to
>> export others.(ie, making generic function).
>
> I considered that and it would not be ideal. It would have to disable and
> reenable interrupts as each page is taken from the list or alternatively
> require that the caller not have the zone lock taken. The latter of these
> options is more reasonable but would still result in more interrupt enabling
> and disabling.
>
> split_free_page() is extremely specialised and requires knowledge of the
> page allocator internals to call properly. There is little pressure to
> make this easier to use at the cost of increased locking.
>
>> If we can't do, how about making split_free_page static as static function?
>> And only uses it in compaction.
>>
>
> It pretty much has to be in page_alloc.c because it uses internal
> functions of the page allocator - e.g. rmv_page_order. I could move it
> to mm/internal.h because whatever about split_page, I can't imagine why
> anyone else would need to call split_free_page.

Yes. Then, Let's add comment like split_page. :)
 /*
 * Note: this is probably too low level an operation for use in drivers.
 * Please consult with lkml before using this in your driver.
 */


>
> --
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
>



-- 
Kind regards,
Minchan Kim
