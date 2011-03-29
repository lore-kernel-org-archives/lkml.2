Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab1C2RdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 13:33:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab1C2RdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 13:33:01 -0400
Message-ID: <4D9217BE.2040205@redhat.com>
Date: Tue, 29 Mar 2011 14:32:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/30] amd64_edac: Cleanup chipselect handling
References: <1297358133-14320-1-git-send-email-bp@amd64.org> <1297358133-14320-6-git-send-email-bp@amd64.org> <4D91F31A.7040600@redhat.com> <20110329151643.GA22419@aftab> <4D91FD1D.4070508@redhat.com> <20110329160211.GC22419@aftab>
In-Reply-To: <20110329160211.GC22419@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 29-03-2011 13:02, Borislav Petkov escreveu:
> On Tue, Mar 29, 2011 at 11:39:09AM -0400, Mauro Carvalho Chehab wrote:
>>>>> + * Create a contiguous bitmask starting at bit position @lo and ending at
>>>>> + * position @hi. For example
>>>>> + *
>>>>> + * GENMASK(21, 39) gives us the 64bit vector 0x000000ffffe00000.
>>>>> + */
>>>>> +#define GENMASK(lo, hi)			(((1ULL << ((hi) - (lo) + 1)) - 1) << (lo))
>>>>> +
>>>>
>>>> This is a nice macro that could be useful outside amd64. It is probably a good
>>>> idea to move it to include/linux/bitops.h.
>>>
>>> I'd suggest rather <drivers/edac/edac_core.h> if you want to use it in
>>> EDAC. But if we have more users, I don't have a problem with putting
>>> it there (or somewhere else generic enough if people have a better
>>> suggestion).
>>
>> Yeah, other edac drivers could benefit of using it, and also could benefit on a
>> variant that would do an AND operation and shift it, something like (untested):
>>
>> /*
>>  * Create a contiguous bitmask starting at bit position @lo and ending at
>>  * position @hi. For example
>>  *
>>  * APPLY_BITMASK(v, 21, 39) will return the result of:
>>  * 	(v & 0x000000ffffe00000) >> 21
>>  */
>> #define APPLY_BITMASK(v, lo, hi)	(((v) & ((1ULL << ((hi) - (lo) + 1)) - 1) << (lo)) >> (lo))
> 
> The macro definition doesn't match the comment. In the comment you do a bitwise
> AND first and shift the result then. The way you've written it, it does
> 
> 	((v & 0x000000000007ffff << 21) >> 21)
> 
> you need to fixup the brackets:

Ah, yes. As I said, it was untested ;) I was in the middle of reviewing lots of edac patches,
but I didn't want to loose the idea, so I was quick on my reply ;)
> 
> #define APPLY_BITMASK(v, lo, hi)	(((v) & (((1ULL << ((hi) - (lo) + 1)) - 1) << (lo))) >> (lo))
> 
> Also, this doesn't only apply it but shifts too, so it should be
> 
> #define APPLY_BITMASK_AND_SHIFT(...)

Yeah, that name sounds better ;)
> 
> But this macro gets too special to put it in shared code.

Ok.

> 
>> Almost all edac drivers do something like the above, for example, to get DIMM rows/cols/banks, etc.
>>
>> Probably, the most complex part is to find a nice name for it ;)
>>
>> Yet, I think non-edac drivers could also benefit of such macro, and, as this is not
>> edac-specific, I think it would be better to add it at bitops.h.
> 
> No, this should go into generic code only if it has users - "it might
> benefit" is not strong-enough an argument for polluting generic code.
> I'd leave it in edac_core.h and push it somewhere more generic only when
> I need it in other subsystems.

Works for me.

Thanks!
Mauro

