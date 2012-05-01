Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab2EABRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 21:17:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59969 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2EABRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 21:17:50 -0400
Message-ID: <4F9F3940.9000509@linaro.org>
Date: Mon, 30 Apr 2012 18:15:44 -0700
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
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org> <1335289787-11089-3-git-send-email-john.stultz@linaro.org> <20120427003953.GC9541@dastard> <4F9AF00A.5040604@linaro.org> <20120428020444.GK9541@dastard> <4F9EEA9D.8020909@linaro.org> <20120501002842.GR7015@dastard>
In-Reply-To: <20120501002842.GR7015@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050101-3270-0000-0000-000005F4713D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 05:28 PM, Dave Chinner wrote:
> On Mon, Apr 30, 2012 at 12:40:13PM -0700, John Stultz wrote:
>> On 04/27/2012 07:04 PM, Dave Chinner wrote:
>>> On Fri, Apr 27, 2012 at 12:14:18PM -0700, John Stultz wrote:
>>>> On 04/26/2012 05:39 PM, Dave Chinner wrote:
>>>>> This probably won't perform wonderfully, which is where the range
>>>>> tracking and delayed punching (and the implied memory freeing)
>>>>> optimiation comes into play. Sure, for tmpfs this can be implemented
>>>>> as a shrinker, but for real filesystems that have to punch blocks a
>>>>> shrinker is really the wrong context to be running such
>>>>> transactions. However, using the fallocate() interface allows each
>>>>> filesytsem to optimise the delayed hole punching as they see best,
>>>>> something that cannot be done with this fadvise() interface.
>>>> So if a shrinker isn't the right context, what would be a good
>>>> context for delayed hole punching?
>>> Like we in XFs for inode reclaim. We have a background workqueue
>>> that frees aged inodes periodically in the fastest manner possible
>>> (i.e. all async, no blocking on locks, etc), and the shrinker, when
>>> run kicks that background thread first, and then enters into
>>> synchronous reclaim. By the time a single sync reclaim cycle is run
>>> and throttled reclaim sufficiently, the background thread has done a
>>> great deal more work.
>>>
>>> A similar mechanism can be used for this functionality within XFS.
>>> Indeed, we could efficiently track which inodes have volatile ranges
>>> on them via a bit in the radix trees than index the inode cache,
>>> just like we do for reclaimable inodes. If we then used a bit in the
>>> page cache radix tree index to indicate volatile pages, we could
>>> then easily find the ranges we need to punch out without requiring
>>> some new tree and more per-inode memory.
>>>
>>> That's a very filesystem specific implementation - it's vastly
>>> different to you tmpfs implementation - but this is exactly what I
>>> mean about using fallocate to allow filesystems to optimise the
>>> implementation in the most suitable manner for them....
>>>
>> So, just to make sure I'm folloiwng you, you're suggesting that
>> there would be a filesystem specific implementation at the top
>> level. Something like a  mark_volatile(struct inode *, bool, loff_t,
>> loff_t) inode operation? And the filesystem would then be
>> responsible for managing the ranges and appropriately purging them?
> Not quite. I'm suggesting that you use the .fallocate() file
> operation to call into the filesystem specific code, and from there
> the filesystem code either calls a generic helper function to mark
> ranges as volatile and provides a callback for implementing the
> shrinker functionailty, or it implements it all itself.
>
> i.e. userspace would do:
>
> 	err = fallocate(fd, FALLOC_FL_MARK_VOLATILE, off, len);
> 	err = fallocate(fd, FALLOC_FL_CLEAR_VOLATILE, off, len);
>
> and that will get passed to the filesystem implementation of
> .fallocate (from do_fallocate()). The filesystem callout for this:
>
> 0 btrfs/file.c   1898 .fallocate = btrfs_fallocate,
> 1 ext4/file.c     247 .fallocate = ext4_fallocate,
> 2 gfs2/file.c    1015 .fallocate = gfs2_fallocate,
> 3 gfs2/file.c    1045 .fallocate = gfs2_fallocate,
> 4 ocfs2/file.c   2727 .fallocate = ocfs2_fallocate,
> 5 ocfs2/file.c   2774 .fallocate = ocfs2_fallocate,
> 6 xfs/xfs_file.c 1026 .fallocate = xfs_file_fallocate,
Ok.

Although noting that tmpfs doesn't implement fallocate, this isn't just 
a ruse to get me to implement fallocate for tmpfs, right? ;)

Out of curiosity: While for my uses, a tmpfs exclusive implementation 
isn't a problem for me,  I *really* appreciate your feedback and help 
focusing this into a more generic fs solution. But to get more context 
for your insights, I'm curious if you have any use cases in your mind 
that is directing this work to be more generic?

Again, you've been helpfully skeptical of the work, and also at the same 
time pushing it in a certain direction, and I want to make sure I better 
understand where you're coming from.  You've clarified the file security 
concern well enough, but is that all?  I just want to make sure that 
going the generic fallocate route is really worth it, as opposed to 
moving to madvise() and just failing file-data backed memory.

> can then call a generic helper like, say:
>
> 	filemap_mark_volatile_range(inode, off, len);
> 	filemap_clear_volatile_range(inode, off, len);
>
> to be able to use the range tree tracking you have written for this
> purpose. The filesystem is also free to track ranges however it
> pleases.
>
> The filesystem will need to be able to store a tree/list root for
> tracking all it's inodes that have volatile ranges, and register a
> shrinker to walk that list and do the work necessary when memory
> becomes low, but that is simple to do for a basic implementation.
>
Hrmm..  Currently I'm using a per-mapping range-tree along with a global 
LRU list that ties all the ranges together.

We could go for a per-filesystem filesystem controlled LRU as you 
suggest.  Although that along with the filesystem managed range-tree 
roots  would make the generic helpers a little complex. But it could 
probably be worked out.

I'll let you know when I have a first pass implementation or if I hit 
any walls.

Once again, thanks so much for all the feedback and guidance!
-john





