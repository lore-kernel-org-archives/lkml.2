Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1GVB4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 21:56:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41480 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab1GVB4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 21:56:33 -0400
Message-ID: <4E28D85F.5000009@gmail.com>
Date: Fri, 22 Jul 2011 09:54:39 +0800
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW tracking
 of dirty & young
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>	<1310717238-13857-2-git-send-email-haishan.bai@gmail.com>	<1310725418.2586.309.camel@twins>	<4E21A526.8010904@gmail.com>	<1310860194.25044.17.camel@pasglop>	<4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>	<1310912990.25044.203.camel@pasglop>	<1310944453.25044.262.camel@pasglop>	<1310961691.25044.274.camel@pasglop>	<4E23D728.7090406@gmail.com>	<1310972462.25044.292.camel@pasglop>	<4E23E02C.8090401@gmail.com>	<1310974591.25044.298.camel@pasglop>	<4E24FA51.70602@gmail.com>	<1311049762.25044.392.camel@pasglop>	<20110721153606.37e6f432.akpm@linux-foundation.org>	<1311288726.25044.545.camel@pasglop> <20110721155938.2ff2dab5.akpm@linux-foundation.org>
In-Reply-To: <20110721155938.2ff2dab5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2011 06:59 AM, Andrew Morton wrote:
> On Fri, 22 Jul 2011 08:52:06 +1000
> Benjamin Herrenschmidt<benh@kernel.crashing.org>  wrote:
>
>> On Thu, 2011-07-21 at 15:36 -0700, Andrew Morton wrote:
>>> On Tue, 19 Jul 2011 14:29:22 +1000
>>> Benjamin Herrenschmidt<benh@kernel.crashing.org>  wrote:
>>>
>>>> The futex code currently attempts to write to user memory within
>>>> a pagefault disabled section, and if that fails, tries to fix it
>>>> up using get_user_pages().
>>>>
>>>> This doesn't work on archs where the dirty and young bits are
>>>> maintained by software, since they will gate access permission
>>>> in the TLB, and will not be updated by gup().
>>>>
>>>> In addition, there's an expectation on some archs that a
>>>> spurious write fault triggers a local TLB flush, and that is
>>>> missing from the picture as well.
>>>>
>>>> I decided that adding those "features" to gup() would be too much
>>>> for this already too complex function, and instead added a new
>>>> simpler fixup_user_fault() which is essentially a wrapper around
>>>> handle_mm_fault() which the futex code can call.
>>>>
>>>> Signed-off-by: Benjamin Herrenschmidt<benh@kernel.crashing.org>
>>>> ---
>>>>
>>>> Shan, can you test this ? It might not fix the problem
>>> um, what problem.  There's no description here of the user-visible
>>> effects of the bug hence it's hard to work out what kernel version(s)
>>> should receive this patch.
>> Shan could give you an actual example (it was in the previous thread),
>> but basically, livelock as the kernel keeps trying and trying the
>> in_atomic op and never resolves it.
>>
>>> What kernel version(s) should receive this patch?
>> I haven't dug. Probably anything it applies on as far as we did that
>> trick of atomic + gup() for futex.
> You're not understanding me.
>
> I need a good reason to merge this into 3.0.
>
> The -stable maintainers need even better reasons to merge this into
> earlier kernels.
>
> Please provide those reasons!
>

Summary:
- Encountered a 100% CPU system usage problem on pthread_mutex allocated 
in a
     shared memory region, and the problem occurs only on setting 
PRIORITY_INHERITANCE
     to the pthread_mutex.
- ftrace result reveals that an infinite loop in the futex_lock_pi 
caused high CPU usage.
- The powerpc e500 was affected but the x86 was not.
     I have not tested on other archs so I am not sure whether the other 
archs are attacked
     by the problem.
- Tested it on 2.6.34 and 3.0-rc7, both are affected, earlier versions 
might be affected.

Please refer the threads "[PATCH 0/1] Fixup write permission of TLB on 
powerpc e500 core"
and "[PATCH 1/1] Fixup write permission of TLB on powerpc e500 core" for 
the whole story.
Provided the test case code in the [PATH 0/1].

Thanks
Shan Hai

> (Documentation/stable_kernel_rules.txt, 4th bullet)
>
> (And it's not just me and -stable maintainers.  Distro maintainers will
> also look at this patch and wonder whether they should merge it)

