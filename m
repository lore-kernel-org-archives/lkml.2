Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261Ab2D0TOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:14:40 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43103 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760458Ab2D0TOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:14:39 -0400
Message-ID: <4F9AF00A.5040604@linaro.org>
Date: Fri, 27 Apr 2012 12:14:18 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org> <1335289787-11089-3-git-send-email-john.stultz@linaro.org> <20120427003953.GC9541@dastard>
In-Reply-To: <20120427003953.GC9541@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042719-5806-0000-0000-000014AF7912
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 05:39 PM, Dave Chinner wrote:
> On Tue, Apr 24, 2012 at 10:49:46AM -0700, John Stultz wrote:
>> @@ -128,6 +129,19 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
>>   			invalidate_mapping_pages(mapping, start_index,
>>   						end_index);
>>   		break;
>> +	case POSIX_FADV_VOLATILE:
>> +		/* First and last PARTIAL page! */
>> +		start_index = offset>>  PAGE_CACHE_SHIFT;
>> +		end_index = endbyte>>  PAGE_CACHE_SHIFT;
>> +		ret = mapping_range_volatile(mapping, start_index, end_index);
>> +		break;
>> +	case POSIX_FADV_NONVOLATILE:
>> +		/* First and last PARTIAL page! */
>> +		start_index = offset>>  PAGE_CACHE_SHIFT;
>> +		end_index = endbyte>>  PAGE_CACHE_SHIFT;
>> +		ret = mapping_range_nonvolatile(mapping, start_index,
>> +								end_index);
> As it is, I'm still not sold on these being an fadvise() interface
> because all it really is a delayed hole punching interface whose
> functionailty is currently specific to tmpfs. The behaviour cannot
> be implemented sanely by anything else at this point.
Yea. So I spent some time looking at the various hole punching 
mechanisms and they aren't all together consistent across filesystems. 
For instance, on some filesystems (ext4 and mostly disk backed fs) you 
have to use fallocate(fd, |FALLOC_FL_PUNCH_HOLE,...)|, while on tmpfs, 
its madvise(...,MADV_REMOVE).   So in a way, currently, the 
FADVISE_VOLATILE is closer to a delayed MADVISE_REMOVE.


>> + * The goal behind volatile ranges is to allow applications to interact
>> + * with the kernel's cache management infrastructure.  In particular an
>> + * application can say "this memory contains data that might be useful in
>> + * the future, but can be reconstructed if necessary, so if the kernel
>> + * needs, it can zap and reclaim this memory without having to swap it out.
> This is what I mean - the definition of volatility is specific to a
> filesystem implementation - one that doesn't store persistent data.
Well,  I'd like to think that it could be extended to do delayed hole 
punching on disk backed persistent files, but again, currently there's 
no unified way to punch holes across the disk and memory backed 
filesystems.

If other filesystems implemented vmtruncate_range for hole punching, we 
could (modulo the circular mutex lock issue of calling vmtruncate_range 
from a shrinker) support this on other filesystems.

Are there inherent reasons why vmtruncate_range isn't implemented (or 
can't be sanely implemented) by non-tmpfs filesystems?


>> + * The proposed mechanism - at a high level - is for user-space to be able
>> + * to say "This memory is volatile" and then later "this memory is no longer
>> + * volatile".  If the content of the memory is still available the second
>> + * request succeeds.  If not, the memory is marked non-volatile and an
>> + * error is returned to denote that the contents have been lost.
> For a filesystem, it's not "memory" that is volatile - it is the
> *data* that we have to consider that these hints apply to, and that
> implies both in memory and on stable storage. because you are
> targetting a filesystem without persisten storage, you are using
> "memory" interchangably with "data". That basically results in an
> interface that can only be used by non-persistent filesystems.
> However, for managing on-disk caches of fixed sizes, being able to
> mark regions as volatile or not is just as helpful to them as it is
> to memory based caches on tmpfs....
>
> So why can't you implement this as fallocate() flags, and then make
> the tmpfs implementation of those fallocate flags do the right
> things?  I think fallocate is the right interface, because this is
> simply an extension of the existing hole punching implementation.
> IOWs, the specification you are describing means that FADV_VOLATILE
> could be correctly implemented as an immediate hole punch by every
> filesystem that supports hole punching.

So yea, I'm fine with changing interface as long as fallocate is where 
the consensus is.  I'm not sure I maybe understand the subtlety of the 
interface differences, and it doesn't necessarily seem more intuitive to 
me (as seems more advisory then allocation based).  But I can give it a 
shot.

Another way we could go is using madvise, somewhat mimicing the 
MADVISE_REMOVE call, which again, is not implemented everywhere.

Although as DaveH said, doing the hole punch on disk is extra overhead. 
But I agree it makes more sense from a least-surprise approach (no data 
is less surprising then old data after a purge).

As for your immediate hole punch thought, that could work, although 
FADV_VOLATILE would be just as correctly implemented by not purging any 
of data on disk backed files.  Either way, a difference might be 
slightly confusing for users (since either way changes the global LRU 
purge behavior).

> This probably won't perform wonderfully, which is where the range
> tracking and delayed punching (and the implied memory freeing)
> optimiation comes into play. Sure, for tmpfs this can be implemented
> as a shrinker, but for real filesystems that have to punch blocks a
> shrinker is really the wrong context to be running such
> transactions. However, using the fallocate() interface allows each
> filesytsem to optimise the delayed hole punching as they see best,
> something that cannot be done with this fadvise() interface.

So if a shrinker isn't the right context, what would be a good context 
for delayed hole punching?


> It's all great that this can replace a single function in ashmem,
> but focussing purely on ashmem misses the point that this
> functionality has wider use, and that using a different interface
> allows independently tailored and optimised implementations of that
> functionality....

Very much agreed, I'd like this to be more generically usable as well.

Thanks again for the helpful feedback! Let me know your thoughts on my 
questions above, and I'll start working on seeing what is required to 
switch over to fallocate().

thanks
-john



