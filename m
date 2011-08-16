Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab1HPRqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:46:42 -0400
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:53092 "EHLO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1HPRql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:46:41 -0400
Message-ID: <4E4AACBA.50408@cray.com>
Date: Tue, 16 Aug 2011 12:45:30 -0500
From: Andrew Barry <abarry@cray.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Jan Kiszka <jan.kiszka@web.de>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "agraf@suse.de" <agraf@suse.de>, kvm <kvm@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrew Hastings <abh@cray.com>,
        Adam Litke <agl@us.ibm.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: Fix refcounting in hugetlbfs quota handling
References: <20110811064059.GU6342@yookeroo.fritz.box> <CA+55aFzXJo78Ah_Qiy6cSHdXHv165nXJ2nTD186NNdCXBABZjA@mail.gmail.com> <CAEwNFnB+5DZQw0CrfkcdP_rd5FBM6fw26=_yS3P283a9TKLNiw@mail.gmail.com> <alpine.LSU.2.00.1108121126560.1290@sister.anvils> <20110813010839.GC30552@yookeroo.fritz.box> <alpine.LSU.2.00.1108151057380.1394@sister.anvils> <4E4980BF.7090801@cray.com> <20110816034748.GG18203@yookeroo.fritz.box>
In-Reply-To: <20110816034748.GG18203@yookeroo.fritz.box>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not a unique KVM problem. We saw the race while doing large async rDMA in
our network driver, but I can imagine it happening with a slow NFS server, or
other DMA that could complete after umount.

What I need, in order to push this upstream, is:
1. For you to light a fire under my feet to get this going. (done)
2. For you all to review the patch and let me know if I've missed anything.
Patch RFC coming ASAP.

-Andrew Barry


On 08/15/2011 10:47 PM, David Gibson wrote:
> On Mon, Aug 15, 2011 at 03:25:35PM -0500, Andrew Barry wrote:
>> I've been doing something similar to this last proposal. I put a
>> hugetlbfs_sb_info pointer into page_private, and dropped a reference counter and
>> an active/inactive bit into the hugetlbfs_sb_info struct. At Umount time, the
>> sbinfo is freed, only if the reference count is zero. Otherwise, the last
>> put_quota frees the sbinfo structure. This fixed the race we were seeing between
>> umount and a put_quota from an rdma transaction. I just gave it a cursory test
>> on a 3.0 kernel; it has seen quite a lot more testing on a 2.6.32-derived
>> kernel, with no more hits of the umount race.
>>
>> Does this address the problems you were thinking about?
> 
> Ah, this looks much better than my patch.  And the fact that you've
> seen your race demonstrates clearly that this isn't just a kvm
> problem.  I hope we can push this upstream very soon - what can I do
> to help?
> 
>> -Andrew Barry
>>

>>
>> On 08/15/2011 01:00 PM, Hugh Dickins wrote:
>>> On Sat, 13 Aug 2011, David Gibson wrote:
>>>> On Fri, Aug 12, 2011 at 12:15:21PM -0700, Hugh Dickins wrote:
>>>>>
>>>>> Setting that aside, I think this thing of grabbing a reference to inode
>>>>> for each page just does not work as you wish: when we unlink an inode,
>>>>> all its pages should be freed; but because they are themselves holding
>>>>> references to the inode, it and its pages stick around forever.
>>>>
>>>> Ugh, yes.  You're absolutely right.  That circular reference will mess
>>>> everything up.  Thinking it through and testing fail.
>>>>
>>>>> A quick experiment with your patch versus without confirmed that:
>>>>> meminfo HugePages_Free stayed down with your patch, but went back to
>>>>> HugePages_Total without it.  Please check, perhaps I'm just mistaken.
>>>>>
>>>>> Sorry, I've not looked into what a constructive alternative might be;
>>>>> and it's not the first time we've had this difficulty - it came up last
>>>>> year when the ->freepage function was added, that the inode may be gone
>>>>> by the time ->freepage(page) is called.
>>>>
>>>> Ok, so.  In fact the quota functions we call at free time only need
>>>> the super block, not the inode per se.  If we put a superblock pointer
>>>> instead of an inode pointer in page private, and refcounted that, I
>>>> think that should remove the circular ref.  The only reason I didn't
>>>> do it before is that the superblock refcounting functions didn't seem
>>>> to be globally visible in an obvious way.
>>>>
>>>> Does that sound like a reasonable approach?
>>>
>>> That does sound closer to a reaonable approach, but my guess is that it
>>> will suck you into a world of superblock mutexes and semaphores, which
>>> you cannot take at free_huge_page() time.
>>>
>>> It might be necessary to hang your own tiny structure off the superblock,
>>> with one refcount for the superblock, and one for each hugepage attached,
>>> you freeing that structure when the count goes down to zero from either
>>> direction.
>>>
>>> Whatever you do needs testing with lockdep and atomic sleep checks.
>>>
>>> I do dislike tying these separate levels together in such an unusual way,
>>> but it is a difficult problem and I don't know of an easy answer.  Maybe
>>> we'll need to find a better answer for other reasons, it does come up
>>> from time to time e.g. recent race between evicting inode and nrpages
>>> going down to 0.
>>>
>>> You might care to take a look at how tmpfs (mm/shmem.c) deals with
>>> the equivalent issue there (sbinfo->used_blocks).  But I expect you to
>>> conclude that hugetlbfs cannot afford the kind of approximations that
>>> tmpfs can afford.
>>>
>>> Although I think tmpfs is more correct, to be associating the count
>>> with pagecache (so the count goes down as soon as a page is truncated
>>> or evicted from pagecache), your fewer and huger pages, and reservation
>>> conventions, may well demand that the count stays up until the page is
>>> actually freed back to hugepool.  And let's not pretend that what tmpfs
>>> does is wonderful: the strange shmem_recalc_inode() tries its best to
>>> notice when memory pressure has freed clean pages, but it never looks
>>> beyond the inode being accessed at the times it's called.  Not at all
>>> satisfactory, but not actually an issue in practice, since we stopped
>>> allocating pages for simple reads from sparse file.  I did want to
>>> convert tmpfs to use ->freepage(), but couldn't manage it without
>>> stable mapping - same problem as you have.
>>>
>>> Hugh
>>
> 
> --
> David Gibson                    | I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au  | minimalist, thank you.  NOT _the_ _other_
>                                 | _way_ _around_!
> http://www.ozlabs.org/~dgibson

