Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0DGIHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 04:07:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38536 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0DGIGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 04:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WyP3FowBXnwPGL0GD/ww63oAiJYzjfFFzhbmJwIcZtyKxHzKO0ZR2/4pHuKGOr0dPp
         tjB/bbEbLVlZhVHDnr8T/6U/52Qh7EyHXkJS7YHkswXoO3cP+iVO2dv1YPizGxLl39U+
         HhGk65grUg1tv1pzl7DH8EJjTn26ajlWtkPSM=
MIME-Version: 1.0
In-Reply-To: <20100407074732.GC17892@localhost>
References: <4BBA6776.5060804@mozilla.com> <20100406095135.GB5183@cmpxchg.org>
	 <20100407022456.GA9468@localhost> <4BBBF402.70403@mozilla.com>
	 <u2p28c262361004062106neea0a64ax2ee0d1e1caf7fce5@mail.gmail.com>
	 <20100407071408.GA17892@localhost>
	 <v2r28c262361004070033z43fc5f07jcb5581a7a8c48310@mail.gmail.com>
	 <20100407074732.GC17892@localhost>
Date: Wed, 7 Apr 2010 17:06:54 +0900
Message-ID: <g2q28c262361004070106le671ad63u965e8137ad2e4f41@mail.gmail.com>
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Taras Glek <tglek@mozilla.com>, Johannes Weiner <hannes@cmpxchg.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 7, 2010 at 4:47 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Wed, Apr 07, 2010 at 03:33:52PM +0800, Minchan Kim wrote:
>> On Wed, Apr 7, 2010 at 4:14 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> > On Wed, Apr 07, 2010 at 12:06:07PM +0800, Minchan Kim wrote:
>> >> On Wed, Apr 7, 2010 at 11:54 AM, Taras Glek <tglek@mozilla.com> wrote:
>> >> > On 04/06/2010 07:24 PM, Wu Fengguang wrote:
>> >> >>
>> >> >> Hi Taras,
>> >> >>
>> >> >> On Tue, Apr 06, 2010 at 05:51:35PM +0800, Johannes Weiner wrote:
>> >> >>
>> >> >>>
>> >> >>> On Mon, Apr 05, 2010 at 03:43:02PM -0700, Taras Glek wrote:
>> >> >>>
>> >> >>>>
>> >> >>>> Hello,
>> >> >>>> I am working on improving Mozilla startup times. It turns out that page
>> >> >>>> faults(caused by lack of cooperation between user/kernelspace) are the
>> >> >>>> main cause of slow startup. I need some insights from someone who
>> >> >>>> understands linux vm behavior.
>> >> >>>>
>> >> >>
>> >> >> How about improve Fedora (and other distros) to preload Mozilla (and
>> >> >> other apps the user run at the previous boot) with fadvise() at boot
>> >> >> time? This sounds like the most reasonable option.
>> >> >>
>> >> >
>> >> > That's a slightly different usecase. I'd rather have all large apps startup
>> >> > as efficiently as possible without any hacks. Though until we get there,
>> >> > we'll be using all of the hacks we can.
>> >> >>
>> >> >> As for the kernel readahead, I have a patchset to increase default
>> >> >> mmap read-around size from 128kb to 512kb (except for small memory
>> >> >> systems).  This should help your case as well.
>> >> >>
>> >> >
>> >> > Yes. Is the current readahead really doing read-around(ie does it read pages
>> >> > before the one being faulted)? From what I've seen, having the dynamic
>> >> > linker read binary sections backwards causes faults.
>> >> > http://sourceware.org/bugzilla/show_bug.cgi?id=11447
>> >> >>
>> >> >>
>> >> >>>>
>> >> >>>> Current Situation:
>> >> >>>> The dynamic linker mmap()s  executable and data sections of our
>> >> >>>> executable but it doesn't call madvise().
>> >> >>>> By default page faults trigger 131072byte reads. To make matters worse,
>> >> >>>> the compile-time linker + gcc lay out code in a manner that does not
>> >> >>>> correspond to how the resulting executable will be executed(ie the
>> >> >>>> layout is basically random). This means that during startup 15-40mb
>> >> >>>> binaries are read in basically random fashion. Even if one orders the
>> >> >>>> binary optimally, throughput is still suboptimal due to the puny
>> >> >>>> readahead.
>> >> >>>>
>> >> >>>> IO Hints:
>> >> >>>> Fortunately when one specifies madvise(WILLNEED) pagefaults trigger 2mb
>> >> >>>> reads and a binary that tends to take 110 page faults(ie program stops
>> >> >>>> execution and waits for disk) can be reduced down to 6. This has the
>> >> >>>> potential to double application startup of large apps without any clear
>> >> >>>> downsides.
>> >> >>>>
>> >> >>>> Suse ships their glibc with a dynamic linker patch to fadvise()
>> >> >>>> dynamic libraries(not sure why they switched from doing madvise
>> >> >>>> before).
>> >> >>>>
>> >> >>
>> >> >> This is interesting. I wonder how SuSE implements the policy.
>> >> >> Do you have the patch or some strace output that demonstrates the
>> >> >> fadvise() call?
>> >> >>
>> >> >
>> >> > glibc-2.3.90-ld.so-madvise.diff in
>> >> > http://www.rpmseek.com/rpm/glibc-2.4-31.12.3.src.html?hl=com&cba=0:G:0:3732595:0:15:0:
>> >> >
>> >> > As I recall they just fadvise the filedescriptor before accessing it.
>> >> >>
>> >> >>
>> >> >>>>
>> >> >>>> I filed a glibc bug about this at
>> >> >>>> http://sourceware.org/bugzilla/show_bug.cgi?id=11431 . Uli commented
>> >> >>>> with his concern about wasting memory resources. What is the impact of
>> >> >>>> madvise(WILLNEED) or the fadvise equivalent on systems under memory
>> >> >>>> pressure? Does the kernel simply start ignoring these hints?
>> >> >>>>
>> >> >>>
>> >> >>> It will throttle based on memory pressure.  In idle situations it will
>> >> >>> eat your file cache, however, to satisfy the request.
>> >> >>>
>> >> >>> Now, the file cache should be much bigger than the amount of unneeded
>> >> >>> pages you prefault with the hint over the whole library, so I guess the
>> >> >>> benefit of prefaulting the right pages outweighs the downside of evicting
>> >> >>> some cache for unused library pages.
>> >> >>>
>> >> >>> Still, it's a workaround for deficits in the demand-paging/readahead
>> >> >>> heuristics and thus a bit ugly, I feel.  Maybe Wu can help.
>> >> >>>
>> >> >>
>> >> >> Program page faults are inherently random, so the straightforward
>> >> >> solution would be to increase the mmap read-around size (for desktops
>> >> >> with reasonable large memory), rather than to improve program layout
>> >> >> or readahead heuristics :)
>> >> >>
>> >> >
>> >> > Program page faults may exhibit random behavior once they've started.
>> >> >
>> >> > During startup page-in pattern of over-engineered OO applications is very
>> >> > predictable. Programs are laid out based on compilation units, which have no
>> >> > relation to how they are executed. Another problem is that any large old
>> >> > application will have lots of code that is either rarely executed or
>> >> > completely dead. Random sprinkling of live code among mostly unneeded code
>> >> > is a problem.
>> >> > I'm able to reduce startup pagefaults by 2.5x and mem usage by a few MB with
>> >> > proper binary layout. Even if one lays out a program wrongly, the worst-case
>> >> > pagein pattern will be pretty similar to what it is by default.
>> >> >
>> >> > But yes, I completely agree that it would be awesome to increase the
>> >> > readahead size proportionally to available memory. It's a little silly to be
>> >> > reading tens of megabytes in 128kb increments :)  You rock for trying to
>> >> > modernize this.
>> >>
>> >> Hi, Wu and Taras.
>> >>
>> >> I have been watched at this thread.
>> >> That's because I had a experience on reducing startup latency of application
>> >> in embedded system.
>> >>
>> >> I think sometime increasing of readahead size wouldn't good in embedded.
>> >> Many of embedded system has nand as storage and compression file system.
>> >> About nand, as you know, random read effect isn't rather big than hdd.
>> >> About compression file system, as one has a big compression,
>> >> it would make startup late(big block read and decompression).
>> >> We had to disable readahead of code page with kernel hacking.
>> >> And it would make application slow as time goes by.
>> >> But at that time we thought latency is more important than performance
>> >> on our application.
>> >>
>> >> Of course, it is different whenever what is file system and
>> >> compression ratio we use .
>> >> So I think increasing of readahead size might always be not good.
>> >>
>> >> Please, consider embedded system when you have a plan to tweak
>> >> readahead, too. :)
>> >
>> > Minchan, glad to know that you have experiences on embedded Linux.
>> >
>> > While increasing the general readahead size from 128kb to 512kb, I
>> > also added a limit for mmap read-around: if system memory size is less
>> > than X MB, then limit read-around size to X KB. For example, do only
>> > 128KB read-around for a 128MB embedded box, and 32KB ra for 32MB box.
>> >
>> > Do you think it a reasonable safety guard? Patch attached.
>>
>> Thanks for reply, Wu.
>>
>> I didn't have looked at the your attachment.
>> That's because it's not matter of memory size in my case.
>
> In general, the more memory size, the less we care about the possible
> readahead misses :)
>
>> It was alone application on system and it was first main application of system.
>> It means we had a enough memory.
>>
>> I guess there are such many of embedded system.
>> At that time, although I could disable readahead totally with read_ahead_kb,
>> I didn't want it. That's because I don't want to disable readahead on
>> the file I/O
>> and data section of program. So at a loss, I hacked kernel to disable
>> readahead of
>> only code section.
>
> I would like to auto tune readahead size based on the device's
> IO throughput and latency estimation, however that's not easy..

Indeed.

> Other than that, if we can assert "this class of devices won't benefit
> from large readahead", then we can do some static assignment.

A few month ago, I saw your patch about enhancing readahead.
At that time, many guys tested several size of USB and SSD which are
consist of nand device.
The result is good if we does readahead untile some crossover point.
So I think we need readahead about file I/O in non-rotation device, too.

But startup latency is important than file I/O performance in some machine.
With analysis at that time, code readahead of application affected slow startup.
In addition, during bootup, cache hit ratio was very small.

So I hoped we can disable readahead just only code section(ie, roughly
exec vma's filemap fault). :)

I don't want you to solve this problem right now.
Just let you understand embedded system's some problem
for enhancing readahead in future.  :)

> Thanks,
> Fengguang
>



-- 
Kind regards,
Minchan Kim
