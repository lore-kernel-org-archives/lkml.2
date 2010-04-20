Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab0DTD6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:58:45 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:52715 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab0DTD6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E7TA4+4UM7xVswBFvN9KBexVJG0aOHRplRPgewJqUWUJBL0/8Hqc6ZUpvJP/J8pnxf
         941YKz1noEWv/015W5b+q7+lhZNXeehi7x+vB3fJXEe5tJzJYzadReF/IvYHJPQcGm7T
         2z1Y0OsEcWoo1CuZm0MULtZT7zfbClrFIshic=
MIME-Version: 1.0
In-Reply-To: <20100420120753.b161dea9.kamezawa.hiroyu@jp.fujitsu.com>
References: <201004152210.o3FMA7KV001909@imap1.linux-foundation.org>
	 <20100419190133.50a13021.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100419181442.GA19264@csn.ul.ie> <20100419193919.GB19264@csn.ul.ie>
	 <s2v28c262361004191939we64e5490ld59b21dc4fa5bc8d@mail.gmail.com>
	 <20100420120753.b161dea9.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 20 Apr 2010 12:58:43 +0900
Message-ID: <g2x28c262361004192058y64f4d316qcb1547909168e31f@mail.gmail.com>
Subject: Re: error at compaction (Re: mmotm 2010-04-15-14-42 uploaded
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 12:07 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 20 Apr 2010 11:39:46 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
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
>> as interrupt disabled? It's deadlock issue or latency issue?
>> I don't found any comment about it.
>> It should have added the comment around that functions. :)
>>
>
> I guess it's from the same reason as vfree(), which can't be called under
> irq-disabled.
>
> Both of them has to flush TLB of all cpus. At flushing TLB (of other cpus), cpus has
> to send IPI via smp_call_function. What I know from old stories is below.
>
> At sendinf IPI, usual sequence is following. (This may be old.)
>
>        spin_lock(&ipi_lock);
>                set up cpu mask for getting notification from other cpu for declearing
>                "I received IPI and finished my own work".
>        spin_unlock(&ipi_lock);
>
> Then,
>          CPU0                             CPU1
>
>    irq_disable (somewhere)             spin_lock
>                                        send IPI and wait for notification.
>    spin_lock()
>
> deadlock.  Seeing decription of kernel/smp.c::smp_call_function_many(), it says
> this function should not be called under irq-disabled.
> (Maybe the same kind of spin-wait deadlock can happen.)
>

Thanks for kind explanation.
Actually I guessed TLB issue but I can't find any glue point which
connect tlb flush to smp_call_function_xxx. :(

Now look at the __native_flush_tlb_global.
It just read and write cr4 with just mask off X86_CR4_PGE.
So i don't know how connect this and smp_schedule_xxxx.
Hmm,, maybe APIC?

Sorry for dumb question.



-- 
Kind regards,
Minchan Kim
