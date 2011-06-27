Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1F0VlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:41:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:25217 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab1F0Vjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:39:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,434,1304319600"; 
   d="scan'208";a="18970432"
Message-ID: <4E08F893.10103@linux.intel.com>
Date: Mon, 27 Jun 2011 14:39:31 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH v2] futex: Fix regression with read only mappings
References: <20110623194949.GA2083@BohrerMBP.rgmadvisors.com> <1308931186-28707-1-git-send-email-sbohrer@rgmadvisors.com> <4E052DC3.6000902@linux.intel.com> <20110627164008.GA2095@BohrerMBP.rgmadvisors.com> <1309198559.6701.108.camel@twins> <4E08EAE8.6060805@linux.intel.com> <20110627210818.GC2095@BohrerMBP.rgmadvisors.com>
In-Reply-To: <20110627210818.GC2095@BohrerMBP.rgmadvisors.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/27/2011 02:08 PM, Shawn Bohrer wrote:
> On Mon, Jun 27, 2011 at 01:41:12PM -0700, Darren Hart wrote:
>>
>>
>> On 06/27/2011 11:15 AM, Peter Zijlstra wrote:
>>> On Mon, 2011-06-27 at 11:40 -0500, Shawn Bohrer wrote:
>>>>>>     if (PageAnon(page_head)) {
>>>>>
>>>>> This bit needs a comment too (unless I am the only one to whom this
>>>> was
>>>>> non-obvious), maybe:
>>>>>
>>>>>               
>>>>>               /*
>>>>>                * A read-only anonymous page implies a COW on a
>>>>>                * MAP_PRIVATE mapping. There is no sane use-case
>>>>>                * for this scenario, return -EFAULT to userspace.
>>>>>                */
>>>>
>>>> Your comment is wrong.  Unfortunately the code is completly
>>>> non-obvious to me as well, and I have no idea why it is there.  This
>>>> little snippet came from Peter's suggested fix in:
>>>>
>>>> https://lkml.org/lkml/2011/6/6/368
>>>>
>>>> Sadly Peter's gone silent and I'm left wondering if he knew some
>>>> corner case that should return -EFAULT with a RO anonymous page or if
>>>> he _thought_ this was preventing RO MAP_PRIVATE mappings.  If it is
>>>> the latter then this block can be removed because it does NOT do that.
>>>>>> +           if (ro) {
>>>>>> +                   err = -EFAULT;
>>>>>> +                   goto out;
>>>>>> +           }
>>>>>> + 
>>>
>>> Peter simply gets too much email.. anyway, the reason I put that there
>>> is that a RO Anon page will never change and is thus a little pointless
>>> to use for futex ops.
>>>
>>
>> Right, and that was the logic I was trying to document. Shawn, how is my
>> comment above wrong? A read-only anonymous page but itself doesn't imply
>> a COW, but it does it does in the context of this code from my reading.
> 
> All I can tell you is from my testing is a PROT_READ, MAP_PRIVATE
> page isn't an anonymous page. In other words.
> 
> futex = (int *)mmap(0, sizeof(int), PROT_READ, MAP_PRIVATE, fd, 0);
> rc = syscall(SYS_futex, futex, FUTEX_WAIT, val, 0, 0, 0);
> 
> Works just fine with my patch and does NOT return EFAULT.  Your
> comment indicates the opposite.

I see. That would suggest to me then that the get_user_pages doesn't
force the COW when for read-only access when write access is requested.
This makes sense from a get_user_pages perspective.

Kosaki pointed out that the mapping information is contained in the VMA.
We could test for this only if the RW get_user_pages fails, that would
leave the common case fast, but would hurt the valid RO SHARED case. The
alternative it seems is to just let RW private users hang themselves.

I'm tempted to accept the latter and document it in the futex.c file and
then in the man page.

Thoughts?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
