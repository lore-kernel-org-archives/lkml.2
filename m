Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab2D3Tl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 15:41:28 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43808 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571Ab2D3TlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 15:41:25 -0400
Message-ID: <4F9EEA9D.8020909@linaro.org>
Date: Mon, 30 Apr 2012 12:40:13 -0700
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
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org> <1335289787-11089-3-git-send-email-john.stultz@linaro.org> <20120427003953.GC9541@dastard> <4F9AF00A.5040604@linaro.org> <20120428020444.GK9541@dastard>
In-Reply-To: <20120428020444.GK9541@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12043019-1976-0000-0000-00000CC86D91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 07:04 PM, Dave Chinner wrote:
> On Fri, Apr 27, 2012 at 12:14:18PM -0700, John Stultz wrote:
>> On 04/26/2012 05:39 PM, Dave Chinner wrote:
>>> On Tue, Apr 24, 2012 at 10:49:46AM -0700, John Stultz wrote:
>>>> @@ -128,6 +129,19 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
>>>>   			invalidate_mapping_pages(mapping, start_index,
>>>>   						end_index);
>>>>   		break;
>>>> +	case POSIX_FADV_VOLATILE:
>>>> +		/* First and last PARTIAL page! */
>>>> +		start_index = offset>>   PAGE_CACHE_SHIFT;
>>>> +		end_index = endbyte>>   PAGE_CACHE_SHIFT;
>>>> +		ret = mapping_range_volatile(mapping, start_index, end_index);
>>>> +		break;
>>>> +	case POSIX_FADV_NONVOLATILE:
>>>> +		/* First and last PARTIAL page! */
>>>> +		start_index = offset>>   PAGE_CACHE_SHIFT;
>>>> +		end_index = endbyte>>   PAGE_CACHE_SHIFT;
>>>> +		ret = mapping_range_nonvolatile(mapping, start_index,
>>>> +								end_index);
>>> As it is, I'm still not sold on these being an fadvise() interface
>>> because all it really is a delayed hole punching interface whose
>>> functionailty is currently specific to tmpfs. The behaviour cannot
>>> be implemented sanely by anything else at this point.
>> Yea. So I spent some time looking at the various hole punching
>> mechanisms and they aren't all together consistent across
>> filesystems. For instance, on some filesystems (ext4 and mostly disk
>> backed fs) you have to use fallocate(fd,
>> |FALLOC_FL_PUNCH_HOLE,...)|, while on tmpfs, its
>> madvise(...,MADV_REMOVE).   So in a way, currently, the
>> FADVISE_VOLATILE is closer to a delayed MADVISE_REMOVE.
> The MADVISE_REMOVE functionality for hole punching works *only* for
> tmpfs - no other filesystem implements the .truncate_range() method.
> In fact, several filesystems *can't* implement .truncate_range()
> because there is no callout from the page cache truncation code to
> allow filesystems to punch out the underlying blocks. The
> vmtruncate() code is deprecated for this reason (and various others
> like a lack of error handling), and .truncate_range() is just as
> nasty. .truncate_range() needs to die, IMO.
>
> So, rather than building more infrastructure on a nasty, filesystem
> specific mmap() hack, implement .fallocate() on tmpfs and use the
> same interface that every other filesystem uses for punching holes.

Ah. Ok.  I wasn't aware that vmtruncate was deprecated.  Thanks for 
cluing me in here!

>>> This probably won't perform wonderfully, which is where the range
>>> tracking and delayed punching (and the implied memory freeing)
>>> optimiation comes into play. Sure, for tmpfs this can be implemented
>>> as a shrinker, but for real filesystems that have to punch blocks a
>>> shrinker is really the wrong context to be running such
>>> transactions. However, using the fallocate() interface allows each
>>> filesytsem to optimise the delayed hole punching as they see best,
>>> something that cannot be done with this fadvise() interface.
>> So if a shrinker isn't the right context, what would be a good
>> context for delayed hole punching?
> Like we in XFs for inode reclaim. We have a background workqueue
> that frees aged inodes periodically in the fastest manner possible
> (i.e. all async, no blocking on locks, etc), and the shrinker, when
> run kicks that background thread first, and then enters into
> synchronous reclaim. By the time a single sync reclaim cycle is run
> and throttled reclaim sufficiently, the background thread has done a
> great deal more work.
>
> A similar mechanism can be used for this functionality within XFS.
> Indeed, we could efficiently track which inodes have volatile ranges
> on them via a bit in the radix trees than index the inode cache,
> just like we do for reclaimable inodes. If we then used a bit in the
> page cache radix tree index to indicate volatile pages, we could
> then easily find the ranges we need to punch out without requiring
> some new tree and more per-inode memory.
>
> That's a very filesystem specific implementation - it's vastly
> different to you tmpfs implementation - but this is exactly what I
> mean about using fallocate to allow filesystems to optimise the
> implementation in the most suitable manner for them....
>

So, just to make sure I'm folloiwng you, you're suggesting that there 
would be a filesystem specific implementation at the top level. 
Something like a  mark_volatile(struct inode *, bool, loff_t, loff_t) 
inode operation? And the filesystem would then be responsible for 
managing the ranges and appropriately purging them?

Thanks again for the feedback, I'll continue looking into this.

thanks
-john




