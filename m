Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1ARVnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:43:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47348 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1ARVnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:43:13 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101181621140.8580@xanadu.home>
References: <20110118195933.13011.56098.stgit@localhost6.localdomain6>
 <20110118202902.13011.68847.stgit@localhost6.localdomain6> <alpine.LFD.2.00.1101181621140.8580@xanadu.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 18 Jan 2011 14:42:52 -0700
X-Google-Sender-Auth: 4PWPqMtH_AdgY24GGc8gp43vcDk
Message-ID: <AANLkTinLRkqY1Ovf4xbBeYCRfs5fsEG7JKnbE1Z_dd29@mail.gmail.com>
Subject: Re: [PATCH 1/8] arm/dt: Make __vet_atags also accept a dtb image
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        devicetree-discuss@lists.ozlabs.org,
        lkml <linux-kernel@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        John Linn <John.Linn@xilinx.com>,
        Lennert Buijtenhek <buytenh@wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Tue, Jan 18, 2011 at 2:26 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Tue, 18 Jan 2011, Grant Likely wrote:
>
>> The dtb is passed to the kernel via register r2, which is the same
>> method that is used to pass an atags pointer.  This patch modifies
>> __vet_atags to not clear r2 when it encounters a dtb image.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>  arch/arm/kernel/head-common.S |   19 +++++++++++++------
>>  arch/arm/kernel/head.S        |    8 ++++----
>>  2 files changed, 17 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
>> index 8f57515..d9a9105 100644
>> --- a/arch/arm/kernel/head-common.S
>> +++ b/arch/arm/kernel/head-common.S
>> @@ -14,6 +14,7 @@
>>  #define ATAG_CORE 0x54410001
>>  #define ATAG_CORE_SIZE ((2*4 + 3*4) >> 2)
>>  #define ATAG_CORE_SIZE_EMPTY ((2*4) >> 2)
>> +#define OF_DT_MAGIC 0xedfe0dd0 /* 0xd00dfeed in big-endian */
>
> ARM can be big endian too.  Would be nice to make this endian
> independent, or at least list this limitation in the commit log.

How about:
#ifdef CONFIG_CPU_BIG_ENDIAN
#define OF_DT_MAGIC 0xd00dfeed
#else
#define OF_DT_MAGIC 0xedfe0dd0 /* 0xd00dfeed in big-endian */
#endif

Or is there a better way for loading and comparing big endian values in ARM?

>
>>  /*
>>   * Exception handling.  Something went wrong and we can't proceed.  We
>> @@ -105,22 +106,28 @@ __lookup_machine_type_data:
>>
>>  /* Determine validity of the r2 atags pointer.  The heuristic requires
>>   * that the pointer be aligned, in the first 16k of physical RAM and
>> - * that the ATAG_CORE marker is first and present.  Future revisions
>> + * that the ATAG_CORE marker is first and present.  If CONFIG_OF_FLATTREE
>> + * is selected, then it will also accept a dtb pointer.  Future revisions
>>   * of this function may be more lenient with the physical address and
>>   * may also be able to move the ATAGS block if necessary.
>>   *
>>   * r8  = machinfo
>>   *
>>   * Returns:
>> - *  r2 either valid atags pointer, or zero
>> + *  r2 either valid atags pointer, valid dtb pointer, or zero
>>   *  r5, r6 corrupted
>>   */
>>  __vet_atags:
>>       tst     r2, #0x3                        @ aligned?
>>       bne     1f
>>
>> -     ldr     r5, [r2, #0]                    @ is first tag ATAG_CORE?
>> -     cmp     r5, #ATAG_CORE_SIZE
>> +#ifdef CONFIG_OF_FLATTREE
>> +     ldr     r5, [r2, #0]                    @ is it a DTB?
>> +     ldr     r6, =OF_DT_MAGIC
>> +     cmp     r5, r6
>> +     beq     2f
>> +#endif
>> +     cmp     r5, #ATAG_CORE_SIZE             @ is first tag ATAG_CORE?
>
> The "ldr r5 ..." is now done only within #ifdef CONFIG_OF_FLATTREE.  So
> if CONFIG_OF_FLATTREE is undefined then r5 will contain garbage.

Oops, that was a silly oversight.  Fixed now.

g.

>
>
> Nicolas
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
