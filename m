Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab1FWP0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:26:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:5902 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484Ab1FWP0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:26:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,413,1304319600"; 
   d="scan'208";a="21986260"
Message-ID: <4E035B39.1080207@linux.intel.com>
Date: Thu, 23 Jun 2011 08:26:49 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: sbohrer@rgmadvisors.com, peterz@infradead.org, eric.dumazet@gmail.com,
        david@rgmadvisors.com, linux-kernel@vger.kernel.org,
        zvonler@rgmadvisors.com, hughd@google.com, tglx@linutronix.de,
        mingo@elte.hu
Subject: Re: [PATCH RFC] futex: Fix regression with read only mappings
References: <4DF8FFF6.4060000@linux.intel.com> <1308770340-21895-1-git-send-email-sbohrer@rgmadvisors.com> <4E024D2D.6070308@linux.intel.com> <4E02AA40.30203@jp.fujitsu.com>
In-Reply-To: <4E02AA40.30203@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/22/2011 07:51 PM, KOSAKI Motohiro wrote:
> (2011/06/23 5:14), Darren Hart wrote:
>> Hi Shawn,
>>
>> Thanks for taking this up. Would you share your testcases as well?
>>
>> On 06/22/2011 12:19 PM, Shawn Bohrer wrote:
>>> commit 7485d0d3758e8e6491a5c9468114e74dc050785d (futexes: Remove rw
>>> parameter from get_futex_key()) in 2.6.33 introduced a user-mode
>>> regression in that it additionally prevented futex operations on a
>>> region within a read only memory mapped file.  For example this breaks
>>> workloads that have one or more reader processes doing a FUTEX_WAIT on a
>>> futex within a read only shared mapping, and a writer processes that has
>>> a writable mapping issuing the FUTEX_WAKE.
>>>
>>> This fixes the regression for futex operations that should be valid on
>>> RO mappings by trying a RO get_user_pages_fast() when the RW
>>> get_user_pages_fast() fails so as not to slow down the common path of
>>> writable anonymous maps and bailing when we used the RO path on
>>> anonymous memory.
>>>
>>> Patch based on Peter Zijlstra's initial patch with modifications to only
>>> allow RO mappings for futex operations that need VERIFY_READ access.
>>>
>>> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
>>> ---
>>>
>>> Interestingly this patch also allows doing a FUTEX_WAIT on a RO private
>>> mapping.
>>
>> I don't see any harm in this.
> 
> Hi
> 
> I have no objection. However I'd like to explain why I decided to
> prefer to refuse RO private mappings and used prefault.
> 
> private mapping semantics is, to write access makes process private pages
> (ie PageAnon=1).
> 
> So, this patch introduce following another corner case.
> 
> Thread-A: call futex(FUTEX_WAIT, memory-region-A).
>           get_futex_key() return inode based key.
>           sleep on the key
> Thread-B: call mprotect(PROT_READ|PROT_WRITE, memory-region-A)
> Thread-B: write memory-region-A.
>           COW happen. This process's memory-region-A become related
>           to new COWed private (ie PageAnon=1) page.
> Thread-B: call futex(FUETX_WAKE, memory-region-A).
>           get_futex_key() return mm based key.
>           IOW, we fail to wake up Thread-A.
> 
> It's unclear real world issue or not. But I hope everybody realize it.
> So, Probably it would be great if you add some comments for this issue.
> 
> 2.6.18 had an another trick. It used vma walk for avoiding this issue.
> and, unfortunately, it's slow.


Let me try and restate, please tell me if I have this correct:

RO file backed private mappings can be converted to a RW mapping between
FUTEX_WAIT and FUTEX_WAKE, resulting in the use of different keys (as
the RO mapping finds an inode key and the RW mapping returns an
anonymous key). The way to fix this is to use the virtual address
instead of the physical address, like shared futexes, but this has to be
done all the time as there is no way to know if the RO mapping will be
changed after a key is looked up, so it would eliminate the gains of the
private futexes.

A RO private mapping doesn't make a lot of sense to me since at least
one thread of the process will have to have write permission in order
for the mechanism to be useful, so the approach taken in the patch
(EFAULT on RO anonymous private mappings) seems reasonable.

Do I have this right?

--
Darren
> 
> 
>>
>>>  Where my tests on 2.6.18 show that this used to wait
>>> indefinitely.  Performing a FUTEX_WAIT on a RW private mapping waits
>>> indefinitely in 2.6.18, 3.0.0, and with this patch applied.  It is
>>> unclear to me if this is a good thing or a bug.
>>>
>>>  kernel/futex.c |   38 ++++++++++++++++++++++++++------------
>>>  1 files changed, 26 insertions(+), 12 deletions(-)
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
