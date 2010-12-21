Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab0LUKnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 05:43:06 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35997 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab0LUKnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 05:43:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xki3B4e5Vc9ss4Sv6EMVogR3qz116by2hiuhTbBr+E0+TX2dh/hHaZpy0JEsznjE/Z
         MWTv8F4cO2/pdJtRL08AJ+mXyWn5r3WAOwdwYM/XTimZbwQ42RGMOqntLkRQ3F/6EXDu
         ikGmmRSY2F7XZ+o1RNvko1QT011I3flocxvEA=
MIME-Version: 1.0
In-Reply-To: <20101220214445.85816469.akpm@linux-foundation.org>
References: <AANLkTi=kX8NraxuLn-f=s=nqja71Ayq2kYwgG6gq+7YF@mail.gmail.com>
	<20101220214445.85816469.akpm@linux-foundation.org>
Date: Tue, 21 Dec 2010 10:43:03 +0000
Message-ID: <AANLkTikpHn4EkaTUznshMOAnhC9FfL5Yy9vZohvoy8cG@mail.gmail.com>
Subject: Re: [PATCH] include/linux/unaligned: Pack the whole struct rather
 than just the field.
From: Will Newton <will.newton@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 5:44 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 1 Dec 2010 22:11:53 +0000 Will Newton <will.newton@gmail.com> wrote:
>
>> The current packed struct implementation of unaligned access adds
>> the packed attribute only to the field within the unaligned struct
>> rather than to the struct as a whole. This is not sufficient to
>> enforce proper behaviour on architectures with a default struct
>> alignment of more than one byte.
>>
>> For example, the current implementation of __get_unaligned_cpu16
>> when compiled for arm with gcc -O1 -mstructure-size-boundary=32
>> assumes the struct is on a 4 byte boundary so performs the load
>> of the 16bit packed field as if it were on a 4 byte boundary:
>>
>> __get_unaligned_cpu16:
>>         ldrh    r0, [r0, #0]
>>         bx      lr
>>
>> Moving the packed attribute to the struct rather than the field
>> causes the proper unaligned access code to be generated:
>>
>> __get_unaligned_cpu16:
>>       ldrb    r3, [r0, #0]    @ zero_extendqisi2
>>       ldrb    r0, [r0, #1]    @ zero_extendqisi2
>>       orr     r0, r3, r0, asl #8
>>       bx      lr
>>
>> Signed-off-by: Will Newton <will.newton@gmail.com>
>> ---
>>  include/linux/unaligned/packed_struct.h |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/unaligned/packed_struct.h
>> b/include/linux/unaligned/packed_struct.h
>> index 2498bb9..c9a6abd 100644
>> --- a/include/linux/unaligned/packed_struct.h
>> +++ b/include/linux/unaligned/packed_struct.h
>> @@ -3,9 +3,9 @@
>>
>>  #include <linux/kernel.h>
>>
>> -struct __una_u16 { u16 x __attribute__((packed)); };
>> -struct __una_u32 { u32 x __attribute__((packed)); };
>> -struct __una_u64 { u64 x __attribute__((packed)); };
>> +struct __una_u16 { u16 x; } __attribute__((packed));
>> +struct __una_u32 { u32 x; } __attribute__((packed));
>> +struct __una_u64 { u64 x; } __attribute__((packed));
>>
>
> Yes, that was wrong.
>
> Do you think this bug affects 2.6.36 or earlier?

The code is present in 2.6.36 and earlier (the code itself has been
around since 2.6.26). However from looking at the gcc source code, the
only architectures that have a non-8 bit STRUCTURE_SIZE_BOUNDARY are:

arm - although it may need a compiler flag, and it uses bitshift
unaligned access code by default.
crx - doesn't run Linux.
m68k/openbsd
sh - with a deprecated compiler flag

So I think the likelihood of someone tripping over it is quite small,
and is most likely to affect freshly merged architectures that aren't
in the gcc tree yet.

> Even if it doesn't, it looks like a bit of a hand-grenade to leave it
> unfixed in earlier kernels.

I'm not sure what the right thing to do is - there is a very small
chance that the change could cause compiler bugs to surface that have
gone unnoticed before now, but the new code is strictly more correct.
