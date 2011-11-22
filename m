Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab1KVKqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:46:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab1KVKqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:46:01 -0500
Message-ID: <4ECB7D48.6080307@redhat.com>
Date: Tue, 22 Nov 2011 05:45:28 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Johannes Weiner <jweiner@redhat.com>, Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH] [RFC] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
References: <1321932788-18043-1-git-send-email-john.stultz@linaro.org> <4ECB6D60.1010702@redhat.com>
In-Reply-To: <4ECB6D60.1010702@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 04:37 AM, Rik van Riel wrote:
> On 11/21/2011 10:33 PM, John Stultz wrote:
>> This patch provides new fadvise flags that can be used to mark
>> file pages as volatile, which will allow it to be discarded if the
>> kernel wants to reclaim memory.
>>
>> This is useful for userspace to allocate things like caches, and lets
>> the kernel destructively (but safely) reclaim them when there's memory
>> pressure.
>>
>> Right now, we can simply throw away pages if they are clean (backed
>> by a current on-disk copy). That only happens for anonymous/tmpfs/shmfs
>> pages when they're swapped out. This patch lets userspace select
>> dirty pages which can be simply thrown away instead of writing them
>> to disk first. See the mm/shmem.c for this bit of code. It's
>> different from FADV_DONTNEED since the pages are not immediately
>> discarded; they are only discarded under pressure.
>
> I've got a few questions:
>
> 1) How do you tell userspace some of its data got
> discarded?
>
> 2) How do you prevent the situation where every
> volatile object gets a few pages discarded, making
> them all unusable?
> (better to throw away an entire object at once)
>
> 3) Isn't it too slow for something like Firefox to
> create a new tmpfs object for every single throw-away
> cache object?

Oh, and a fourth issue with the _VOLATILE approach, which
I forgot to write down before:

4) Virtualization.  Marking an object (and its pages)
    _VOLATILE inside a guest will not be visible on the
    host side, which means a virtual system may continue
    to suffer the performance penalty anyway.

On the other hand, the approach I outlined will simply result
in a virtual machine being asked to reduce its memory, and
possibly later on passing that notification on to the programs
running inside. In other words, the "please shrink your caches"
notification naturally recurses into cgroups and virtual machines.
