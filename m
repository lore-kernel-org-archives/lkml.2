Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662Ab0HEC2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 22:28:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759452Ab0HEC2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 22:28:13 -0400
Message-ID: <4C5A22B0.7050207@redhat.com>
Date: Thu, 05 Aug 2010 10:32:16 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Milton Miller <miltonm@bga.com>
CC: Neil Horman <nhorman@tuxdriver.com>, Neil Horman <nhorman@redhat.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kexec@lists.infadead.org
Subject: Re: [Patch v2] kexec: increase max of kexec segments and use dynamic
 allocation
References: <kexec-nrseg-reply1@mdm.bga.com> <4C5122D1.8080203@redhat.com>
In-Reply-To: <4C5122D1.8080203@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Ping Milton...)

On 07/29/10 14:42, Cong Wang wrote:
> On 07/27/10 18:00, Milton Miller wrote:
>> [ Added kexec at lists.infradead.org and linuxppc-dev@lists.ozlabs.org ]
>>
>>>
>>> Currently KEXEC_SEGMENT_MAX is only 16 which is too small for machine
>>> with
>>> many memory ranges. When hibernate on a machine with disjoint memory
>>> we do
>>> need one segment for each memory region. Increase this hard limit to 16K
>>> which is reasonably large.
>>>
>>> And change ->segment from a static array to a dynamically allocated
>>> memory.
>>>
>>> Cc: Neil Horman<nhorman@redhat.com>
>>> Cc: huang ying<huang.ying.caritas@gmail.com>
>>> Cc: Eric W. Biederman<ebiederm@xmission.com>
>>> Signed-off-by: WANG Cong<amwang@redhat.com>
>>>
>>> ---
>>> diff --git a/arch/powerpc/kernel/machine_kexec_64.c
>>> b/arch/powerpc/kernel/machine_kexec_64.c
>>> index ed31a29..f115585 100644
>>> --- a/arch/powerpc/kernel/machine_kexec_64.c
>>> +++ b/arch/powerpc/kernel/machine_kexec_64.c
>>> @@ -131,10 +131,7 @@ static void copy_segments(unsigned long ind)
>>> void kexec_copy_flush(struct kimage *image)
>>> {
>>> long i, nr_segments = image->nr_segments;
>>> - struct kexec_segment ranges[KEXEC_SEGMENT_MAX];
>>> -
>>> - /* save the ranges on the stack to efficiently flush the icache */
>>> - memcpy(ranges, image->segment, sizeof(ranges));
>>> + struct kexec_segment range;
>>
>> I'm glad you found our copy on the stack and removed the stack overflow
>> that comes with this bump, but ...
>>
>>>
>>> /*
>>> * After this call we may not use anything allocated in dynamic
>>> @@ -148,9 +145,11 @@ void kexec_copy_flush(struct kimage *image)
>>> * we need to clear the icache for all dest pages sometime,
>>> * including ones that were in place on the original copy
>>> */
>>> - for (i = 0; i< nr_segments; i++)
>>> - flush_icache_range((unsigned long)__va(ranges[i].mem),
>>> - (unsigned long)__va(ranges[i].mem + ranges[i].memsz));
>>> + for (i = 0; i< nr_segments; i++) {
>>> + memcpy(&range,&image->segment[i], sizeof(range));
>>> + flush_icache_range((unsigned long)__va(range.mem),
>>> + (unsigned long)__va(range.mem + range.memsz));
>>> + }
>>> }
>>
>> This is executed after the copy, so as it says,
>> "we may not use anything allocated in dynamic memory".
>>
>> We could allocate control pages to copy the segment list into.
>> Actually ppc64 doesn't use the existing control page, but that
>> is only 4kB today.
>>
>> We need the list to icache flush all the pages in all the segments.
>> The as the indirect list doesn't have pages that were allocated at
>> their destination.
>>
>> Or maybe the icache flush should be done in the generic code
>> like it does for crash load segments?
>>
>
> I don't get the point here, according to the comments,
> it is copied into stack because of efficiency.
>


-- 
The opposite of love is not hate, it's indifference.
  - Elie Wiesel
