Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2KLNrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:47:01 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52875 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab2KLNq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:46:58 -0500
MIME-Version: 1.0
In-Reply-To: <20121112104601.GB2346@mudshark.cambridge.arm.com>
References: <1352495853-9790-1-git-send-email-rob.clark@linaro.org>
	<20121112104601.GB2346@mudshark.cambridge.arm.com>
Date: Mon, 12 Nov 2012 07:46:57 -0600
X-Google-Sender-Auth: dqsHYTvnFle9V2WY89iC9UtADI8
Message-ID: <CAF6AEGtR0WBjoWbb2BF-hJa9sQi2Aa75dfrfb1u5EncaOB7Pyw@mail.gmail.com>
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
From: Rob Clark <rob.clark@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 4:46 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Nov 09, 2012 at 09:17:33PM +0000, Rob Clark wrote:
>> From: Rob Clark <rob@ti.com>
>>
>> A new atomic modeset/pageflip ioctl being developed in DRM requires
>> get_user() to work for 64bit types (in addition to just put_user()).
>>
>> Signed-off-by: Rob Clark <rob@ti.com>
>> ---
>>  arch/arm/include/asm/uaccess.h | 25 ++++++++++++++++++++-----
>>  arch/arm/lib/getuser.S         | 17 ++++++++++++++++-
>>  2 files changed, 36 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
>> index 7e1f760..2e3fdb2 100644
>> --- a/arch/arm/include/asm/uaccess.h
>> +++ b/arch/arm/include/asm/uaccess.h
>> @@ -100,6 +100,7 @@ static inline void set_fs(mm_segment_t fs)
>>  extern int __get_user_1(void *);
>>  extern int __get_user_2(void *);
>>  extern int __get_user_4(void *);
>> +extern int __get_user_8(void *);
>>
>>  #define __GUP_CLOBBER_1      "lr", "cc"
>>  #ifdef CONFIG_CPU_USE_DOMAINS
>> @@ -108,6 +109,7 @@ extern int __get_user_4(void *);
>>  #define __GUP_CLOBBER_2 "lr", "cc"
>>  #endif
>>  #define __GUP_CLOBBER_4      "lr", "cc"
>> +#define __GUP_CLOBBER_8      "lr", "cc"
>>
>>  #define __get_user_x(__r2,__p,__e,__l,__s)                           \
>>          __asm__ __volatile__ (                                       \
>> @@ -122,22 +124,35 @@ extern int __get_user_4(void *);
>>       ({                                                              \
>>               unsigned long __limit = current_thread_info()->addr_limit - 1; \
>>               register const typeof(*(p)) __user *__p asm("r0") = (p);\
>> -             register unsigned long __r2 asm("r2");                  \
>>               register unsigned long __l asm("r1") = __limit;         \
>>               register int __e asm("r0");                             \
>>               switch (sizeof(*(__p))) {                               \
>> -             case 1:                                                 \
>> +             case 1: {                                               \
>> +                     register unsigned long __r2 asm("r2");          \
>>                       __get_user_x(__r2, __p, __e, __l, 1);           \
>> +                     x = (typeof(*(p))) __r2;                        \
>>                       break;                                          \
>> -             case 2:                                                 \
>> +             }                                                       \
>> +             case 2: {                                               \
>> +                     register unsigned long __r2 asm("r2");          \
>>                       __get_user_x(__r2, __p, __e, __l, 2);           \
>> +                     x = (typeof(*(p))) __r2;                        \
>>                       break;                                          \
>> -             case 4:                                                 \
>> +             }                                                       \
>> +             case 4: {                                               \
>> +                     register unsigned long __r2 asm("r2");          \
>>                       __get_user_x(__r2, __p, __e, __l, 4);           \
>> +                     x = (typeof(*(p))) __r2;                        \
>> +                     break;                                          \
>> +             }                                                       \
>> +             case 8: {                                               \
>> +                     register unsigned long long __r2 asm("r2");     \
>
> Does this matter? For EABI, we'll pass in (r2, r3) and it's all handcrafted
> asm, so the compiler shouldn't care much. For OABI, I think you may have to
> do some more work to get the two words where you want them.

Is the question whether the compiler is guaranteed to allocate r2 and
r3 in all cases?  I'm not quite sure, I confess to usually trying to
avoid inline asm.  But from looking at the disassembly (for little
endian EABI build) it seemed to do the right thing.

The only other idea I had was to explicitly declare two 'unsigned
long's and then shift them into a 64bit x, although I'm open to
suggestions if there is a better way.

>> +                     __get_user_x(__r2, __p, __e, __l, 8);           \
>> +                     x = (typeof(*(p))) __r2;                        \
>>                       break;                                          \
>> +             }                                                       \
>>               default: __e = __get_user_bad(); break;                 \
>>               }                                                       \
>> -             x = (typeof(*(p))) __r2;                                \
>>               __e;                                                    \
>>       })
>>
>> diff --git a/arch/arm/lib/getuser.S b/arch/arm/lib/getuser.S
>> index 9b06bb4..d05285c 100644
>> --- a/arch/arm/lib/getuser.S
>> +++ b/arch/arm/lib/getuser.S
>> @@ -18,7 +18,7 @@
>>   * Inputs:   r0 contains the address
>>   *           r1 contains the address limit, which must be preserved
>>   * Outputs:  r0 is the error code
>> - *           r2 contains the zero-extended value
>> + *           r2, r3 contains the zero-extended value
>>   *           lr corrupted
>>   *
>>   * No other registers must be altered.  (see <asm/uaccess.h>
>> @@ -66,6 +66,19 @@ ENTRY(__get_user_4)
>>       mov     pc, lr
>>  ENDPROC(__get_user_4)
>>
>> +ENTRY(__get_user_8)
>> +     check_uaccess r0, 4, r1, r2, __get_user_bad
>
> Shouldn't you be passing 8 here, so that we validate the correct range?

yes, sorry, I'll fix that

>> +#ifdef CONFIG_THUMB2_KERNEL
>> +5: TUSER(ldr)        r2, [r0]
>> +6: TUSER(ldr)        r3, [r0, #4]
>> +#else
>> +5: TUSER(ldr)        r2, [r0], #4
>> +6: TUSER(ldr)        r3, [r0]
>> +#endif
>
> This doesn't work for EABI big-endian systems.

Hmm, is that true?  Wouldn't put_user() then have the same problem?

I guess __ARMEB__ is the flag for big-endian?

BR,
-R

> Will
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
