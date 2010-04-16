Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0DPCht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 22:37:49 -0400
Received: from dm-mail01.mozilla.org ([63.245.208.150]:46979 "EHLO
	dm-mail01.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab0DPChr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 22:37:47 -0400
Message-ID: <4BC7CD7A.3070904@mozilla.com>
Date: Thu, 15 Apr 2010 19:37:46 -0700
From: Taras Glek <tglek@mozilla.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
References: <4BBA6776.5060804@mozilla.com>	<20100415155309.2649a29b.akpm@linux-foundation.org>	<4BC7B24C.7040701@mozilla.com> <20100415182116.93dcacca.akpm@linux-foundation.org>
In-Reply-To: <20100415182116.93dcacca.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 03:21 PM, Andrew Morton wrote:
> On Thu, 15 Apr 2010 17:41:48 -0700 Taras Glek<tglek@mozilla.com>  wrote:
>
>    
>> On 04/15/2010 03:53 PM, Andrew Morton wrote:
>>      
>>> On Mon, 05 Apr 2010 15:43:02 -0700
>>> Taras Glek<tglek@mozilla.com>   wrote:
>>>
>>>
>>>        
>>>> To make matters worse,
>>>> the compile-time linker + gcc lay out code in a manner that does not
>>>> correspond to how the resulting executable will be executed(ie the
>>>> layout is basically random).
>>>>
>>>>          
>>> Yes, the linker scrambles the executable's block ordering.
>>>
>>> This just isn't an interesting case.  World-wide, the number of people
>>> who compile their own web browser and execute it from the file which ld
>>> produced is, umm, seven.
>>>
>>>        
>> I'm sorry that you don't find this interesting.
>>      
> It's not a case we should optimise for.  It's perfectly reasonable for
> the kernel to assume that the executable is reasonably well-laid-out on
> disk.  And if is _isn't_ well-laid-out than that should be fixed in
> userspace, because for simple locality-of-reference reasons, that's
> always going to produce the fastest result.
>
> Plus it's the common case as well - the executable was copied from DVD
> or over the network or whatever.
>
> Plus it's so utterly trivial for people who compile-their-own to
> straighten the file out - just run cp!  These people have gone and
> screwed up their file layout - they should fix that, rather than trying
> to get the kernel to perform the impossible for them.  See?
>
>    
>> I did not suggest that
>> people compile their own browser to get a perfect layout. This is
>> something that Mozilla can do when preparing builds and it's also
>> something distributions can do. It just so happens that large parts of
>> startup will be very similar for every single firefox install, might as
>> well layout the binary accordingly.
>>      
>>> So I'd suggest that you always copy the executable to a temp file and
>>> mv it back before running any timing tests.
>>>
>>>        
>> You mean to get it into a cache or to hope to avoid fragmentation?  If
>> you are suggesting this to avoid measuring the startup overhead of
>> paging the binary in, I strongly disagee. It is the slowest part of
>> firefox startup and needs to be addressed.
>>      
> No, nothing like that at all.
>
> What I'm saying is that you shouldn't be testing or attempting to
> optimise for files which were laid out by ld.  Because those files are
> an utter mess - the block ordering is simply all over the place.  And
> the great majority of people aren't using executables which were laid out
> on disk by ld!
>
> Instead, straighten out the block layout with `cp', then go and do the
> testing and the optimisation.  Because if you're not taking this first
> step then you're just not serious about performance at all!
>
> Here's a small executable, as laid out by ld:
>
> File offset	disk blocks
> 0-0: 		18383385-18383385 (1)
> 1-1: 		18383389-18383389 (1)
> 2-3: 		18383392-18383393 (2)
> 4-4: 		18383400-18383400 (1)
> 5-7: 		18383430-18383432 (3)
> 8-11: 		18383450-18383453 (4)
> 12-12: 		18383423-18383423 (1)
> 13-14: 		18383447-18383448 (2)
> 15-16: 		18383474-18383475 (2)
> 17-17: 		18383390-18383390 (1)
> 18-18: 		18383398-18383398 (1)
> 19-20: 		18383418-18383419 (2)
> 21-21: 		18383421-18383421 (1)
> 22-22: 		18383397-18383397 (1)
> 23-23: 		18383399-18383399 (1)
> 24-24: 		18383407-18383407 (1)
> 25-25: 		18383391-18383391 (1)
> 26-26: 		18383396-18383396 (1)
> 27-28: 		18383394-18383395 (2)
> 29-34: 		18383401-18383406 (6)
> 35-38: 		18383425-18383428 (4)
> 39-39: 		18383433-18383433 (1)
> 40-40: 		18383463-18383463 (1)
> 41-44: 		18383490-18383493 (4)
> 45-45: 		18383409-18383409 (1)
> 46-46: 		18383422-18383422 (1)
> 47-47: 		18383442-18383442 (1)
> 48-48: 		18383410-18383410 (1)
> 49-49: 		18383420-18383420 (1)
> 50-50: 		18383424-18383424 (1)
> 51-51: 		18383429-18383429 (1)
> 52-54: 		18383411-18383413 (3)
> 55-56: 		18383416-18383417 (2)
> 57-64: 		18383434-18383441 (8)
> 65-66: 		18383458-18383459 (2)
> 67-68: 		18383414-18383415 (2)
> 69-70: 		18383387-18383388 (2)
> 71-71: 		18383408-18383408 (1)
> 72-74: 		18383443-18383445 (3)
>
> Not only is it fragmented, it's also in jumbled-up order.
>
> And here it is after I did `cp':
>
> 0-11:		18391043-18391054 (12)
> 12-15:		18391056-18391059 (4)
> 16-74:		18391064-18391122 (59)
>
> Trying to get the kernel to fix up the first case is daft, when it is
> so easy to fix and so obviously _needs_ fixing.
>    
Yeah ok. We are talking about different things. I meant the linker lays 
out the program badly, ie within the executable itself. Turns out that 
naively concatenating various compilation units makes for binaries that 
load slowly due to excessive seeking within the file. I wasn't talking 
about filesystem fragmentation. I agree that filesystem bustage caused 
by executing the linker isn't interesting.

Taras
