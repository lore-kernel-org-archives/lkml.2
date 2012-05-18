Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761303Ab2ERA3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:29:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45106 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067Ab2ERA3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:29:41 -0400
Message-ID: <4FB597F3.3060909@gmail.com>
Date: Thu, 17 May 2012 17:29:39 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <1337292816-10839-9-git-send-email-hjl.tools@gmail.com> <4FB58EFD.7010302@zytor.com> <CA+55aFy+XOc350sVuLKDHAaKtz9GdLcVmjxs98N8XLTK4zmMYg@mail.gmail.com> <4FB59474.2020505@zytor.com>
In-Reply-To: <4FB59474.2020505@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 05:14 PM, H. Peter Anvin wrote:
> On 05/17/2012 05:07 PM, Linus Torvalds wrote:
>> On Thu, May 17, 2012 at 4:51 PM, H. Peter Anvin<hpa@zytor.com>  wrote:
>>>
>>> The sane thing would seem to be to change __BITS_PER_LONG to 32 on x32
>>> and fix the padding hacks in struct shmid64_ds; H.J., would you agree?
>>
>> Ugh. That looks like a disaster.
>>
>> The padding hacks that depend on __BITS_PER_LONG seem pretty damn broken anyway.
>>
>> They only work if the kernel agrees with the value (which is against
>> the whole point of making __BITS_PER_LONG be about some user-level ABI
>> thing) or for little-endian machines.
>>
>> IOW, all the __BITS_PER_LONG games look totally broken to me. I can't
>> see how they could possibly even be fixed.
>>
>
> Well, on existing compat (e.g. i386) __BITS_PER_LONG is definitely not
> the same as kernel.  And yes, I don't see how the heck this was ever
> correct on bigendian machines or even for compat in any form (if the
> kernel tries to interpret the extra bits and user space didn't
> initialize them we're lost.)
>
> The "logical" thing to do here seems to just use __s64, but I have no
> idea if that would suddenly break bigendian architectures...
>
> David, Ralf, do you have any idea what e.g. MIPS does here?

At the top of arch/mips/include/asm/types.h we have:

#ifdef __KERNEL__
# include <asm-generic/int-ll64.h>
#else
# if _MIPS_SZLONG == 64
#  include <asm-generic/int-l64.h>
# else
#  include <asm-generic/int-ll64.h>
# endif
#endif

In this case the userspace gcc will define _MIPS_SZLONG according to the 
selected ABI.

in arch/mips/include/asm/bitsperlong.h we have:

#define __BITS_PER_LONG _MIPS_SZLONG

Again, the proper value for the userspace ABI.

This is either 32 or 64 depending which of the three userspace ABIs are 
selected.

I don't know if that answers your question though.

My preference would be that any type that has a width that varies by 
userspace ABI, not include "64" or "32" within its name.

David Daney
