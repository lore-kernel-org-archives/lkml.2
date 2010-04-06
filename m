Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab0DFV5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:57:38 -0400
Received: from dm-mail02.mozilla.org ([63.245.208.176]:54842 "EHLO
	dm-mail02.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab0DFV5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:57:32 -0400
Message-ID: <4BBBAE4A.7070000@mozilla.com>
Date: Tue, 06 Apr 2010 14:57:30 -0700
From: Taras Glek <tglek@mozilla.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
References: <4BBA6776.5060804@mozilla.com> <20100406095135.GB5183@cmpxchg.org>
In-Reply-To: <20100406095135.GB5183@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 02:51 AM, Johannes Weiner wrote:
> On Mon, Apr 05, 2010 at 03:43:02PM -0700, Taras Glek wrote:
>    
>> Hello,
>> I am working on improving Mozilla startup times. It turns out that page
>> faults(caused by lack of cooperation between user/kernelspace) are the
>> main cause of slow startup. I need some insights from someone who
>> understands linux vm behavior.
>>
>> Current Situation:
>> The dynamic linker mmap()s  executable and data sections of our
>> executable but it doesn't call madvise().
>> By default page faults trigger 131072byte reads. To make matters worse,
>> the compile-time linker + gcc lay out code in a manner that does not
>> correspond to how the resulting executable will be executed(ie the
>> layout is basically random). This means that during startup 15-40mb
>> binaries are read in basically random fashion. Even if one orders the
>> binary optimally, throughput is still suboptimal due to the puny readahead.
>>
>> IO Hints:
>> Fortunately when one specifies madvise(WILLNEED) pagefaults trigger 2mb
>> reads and a binary that tends to take 110 page faults(ie program stops
>> execution and waits for disk) can be reduced down to 6. This has the
>> potential to double application startup of large apps without any clear
>> downsides. Suse ships their glibc with a dynamic linker patch to
>> fadvise() dynamic libraries(not sure why they switched from doing
>> madvise before).
>>
>> I filed a glibc bug about this at
>> http://sourceware.org/bugzilla/show_bug.cgi?id=11431 . Uli commented
>> with his concern about wasting memory resources. What is the impact of
>> madvise(WILLNEED) or the fadvise equivalent on systems under memory
>> pressure? Does the kernel simply start ignoring these hints?
>>      
> It will throttle based on memory pressure.  In idle situations it will
> eat your file cache, however, to satisfy the request.
>    
Define idle situations. Do you mean that madv(willneed) will aggresively 
readahead, but only while cpu(or disk?) is idle?
I am trying to optimize application startup which means that the cpu is 
busy while not blocked on io.
> Now, the file cache should be much bigger than the amount of unneeded
> pages you prefault with the hint over the whole library, so I guess the
> benefit of prefaulting the right pages outweighs the downside of evicting
> some cache for unused library pages.
>    
> Still, it's a workaround for deficits in the demand-paging/readahead
> heuristics and thus a bit ugly, I feel.  Maybe Wu can help.
>
>    
Can't wait to hear the juicy details.
>> Also, once an application is started is it reasonable to keep it
>> madvise(WILLNEED)ed or should the madvise flags be reset?
>>      
> It's a one-time operation that starts immediate readahead, no permanent
> changes are done.
>    
I may be measuring this wrong, but in my experience the only change 
madvise(willneed) does in increase the length parameter to 
__do_page_cache_readahead(). My script is at 
http://hg.mozilla.org/users/tglek_mozilla.com/startup/file/6453ad2a7906/kernelio.stp 
.


Taras
