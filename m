Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab0G0SYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:24:43 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53748 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab0G0SYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:24:42 -0400
To: Milton Miller <miltonm@bga.com>
Cc: WANG Cong <amwang@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        Neil Horman <nhorman@redhat.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <kexec@lists.infadead.org>
Subject: Re: [Patch v2] kexec: increase max of kexec segments and use dynamic allocation
References: <kexec-nrseg-reply1@mdm.bga.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 27 Jul 2010 11:24:34 -0700
In-Reply-To: <kexec-nrseg-reply1@mdm.bga.com> (Milton Miller's message of "Tue\, 27 Jul 2010 05\:00\:32 -0500")
Message-ID: <m1ocdshjfh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milton Miller <miltonm@bga.com> writes:

> [ Added kexec at lists.infradead.org and linuxppc-dev@lists.ozlabs.org ]
>
>> 
>> Currently KEXEC_SEGMENT_MAX is only 16 which is too small for machine with
>> many memory ranges.  When hibernate on a machine with disjoint memory we do
>> need one segment for each memory region. Increase this hard limit to 16K
>> which is reasonably large.
>> 
>> And change ->segment from a static array to a dynamically allocated memory.
>> 
>> Cc: Neil Horman <nhorman@redhat.com>
>> Cc: huang ying <huang.ying.caritas@gmail.com>
>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> 
>> ---
>> diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
>> index ed31a29..f115585 100644
>> --- a/arch/powerpc/kernel/machine_kexec_64.c
>> +++ b/arch/powerpc/kernel/machine_kexec_64.c
>> @@ -131,10 +131,7 @@ static void copy_segments(unsigned long ind)
>>  void kexec_copy_flush(struct kimage *image)
>>  {
>>  	long i, nr_segments = image->nr_segments;
>> -	struct  kexec_segment ranges[KEXEC_SEGMENT_MAX];
>> -
>> -	/* save the ranges on the stack to efficiently flush the icache */
>> -	memcpy(ranges, image->segment, sizeof(ranges));
>> +	struct  kexec_segment range;
>
> I'm glad you found our copy on the stack and removed the stack overflow
> that comes with this bump, but ...
>
>>  
>>  	/*
>>  	 * After this call we may not use anything allocated in dynamic
>> @@ -148,9 +145,11 @@ void kexec_copy_flush(struct kimage *image)
>>  	 * we need to clear the icache for all dest pages sometime,
>>  	 * including ones that were in place on the original copy
>>  	 */
>> -	for (i = 0; i < nr_segments; i++)
>> -		flush_icache_range((unsigned long)__va(ranges[i].mem),
>> -			(unsigned long)__va(ranges[i].mem + ranges[i].memsz));
>> +	for (i = 0; i < nr_segments; i++) {
>> +		memcpy(&range, &image->segment[i], sizeof(range));
>> +		flush_icache_range((unsigned long)__va(range.mem),
>> +			(unsigned long)__va(range.mem + range.memsz));
>> +	}
>>  }
>
> This is executed after the copy, so as it says,
> "we may not use anything allocated in dynamic memory".
>
> We could allocate control pages to copy the segment list into.
> Actually ppc64 doesn't use the existing control page, but that
> is only 4kB today.
>
> We need the list to icache flush all the pages in all the segments.
> The as the indirect list doesn't have pages that were allocated at
> their destination.

An interesting point.

> Or maybe the icache flush should be done in the generic code
> like it does for crash load segments?

Please.  I don't quite understand the icache flush requirement.
But we really should not be looking at the segments in the
architecture specific code.

Ideally we would only keep the segment information around for
the duration of the kexec_load syscall and not have it when
it comes time to start the second kernel.

I am puzzled.  We should be completely replacing the page tables so
can't we just do a global flush?  Perhaps I am being naive about what
is required for a ppc flush.

Eric
