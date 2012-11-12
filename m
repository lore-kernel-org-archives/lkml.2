Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2KLOiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:38:52 -0500
Received: from service87.mimecast.com ([91.220.42.44]:36462 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2KLOiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:38:51 -0500
Date: Mon, 12 Nov 2012 14:38:46 +0000
From: Will Deacon <will.deacon@arm.com>
To: Rob Clark <rob.clark@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
Message-ID: <20121112143846.GI2346@mudshark.cambridge.arm.com>
References: <1352495853-9790-1-git-send-email-rob.clark@linaro.org>
 <20121112104601.GB2346@mudshark.cambridge.arm.com>
 <CAF6AEGtR0WBjoWbb2BF-hJa9sQi2Aa75dfrfb1u5EncaOB7Pyw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAF6AEGtR0WBjoWbb2BF-hJa9sQi2Aa75dfrfb1u5EncaOB7Pyw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 12 Nov 2012 14:38:47.0587 (UTC) FILETIME=[6C9BC730:01CDC0E3]
X-MC-Unique: 112111214384908401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 01:46:57PM +0000, Rob Clark wrote:
> On Mon, Nov 12, 2012 at 4:46 AM, Will Deacon <will.deacon@arm.com> wrote:
> > On Fri, Nov 09, 2012 at 09:17:33PM +0000, Rob Clark wrote:
> >> @@ -122,22 +124,35 @@ extern int __get_user_4(void *);
> >>       ({                                                              \
> >>               unsigned long __limit = current_thread_info()->addr_limit - 1; \
> >>               register const typeof(*(p)) __user *__p asm("r0") = (p);\
> >> -             register unsigned long __r2 asm("r2");                  \
> >>               register unsigned long __l asm("r1") = __limit;         \
> >>               register int __e asm("r0");                             \
> >>               switch (sizeof(*(__p))) {                               \
> >> -             case 1:                                                 \
> >> +             case 1: {                                               \
> >> +                     register unsigned long __r2 asm("r2");          \
> >>                       __get_user_x(__r2, __p, __e, __l, 1);           \
> >> +                     x = (typeof(*(p))) __r2;                        \
> >>                       break;                                          \
> >> -             case 2:                                                 \
> >> +             }                                                       \
> >> +             case 2: {                                               \
> >> +                     register unsigned long __r2 asm("r2");          \
> >>                       __get_user_x(__r2, __p, __e, __l, 2);           \
> >> +                     x = (typeof(*(p))) __r2;                        \
> >>                       break;                                          \
> >> -             case 4:                                                 \
> >> +             }                                                       \
> >> +             case 4: {                                               \
> >> +                     register unsigned long __r2 asm("r2");          \
> >>                       __get_user_x(__r2, __p, __e, __l, 4);           \
> >> +                     x = (typeof(*(p))) __r2;                        \
> >> +                     break;                                          \
> >> +             }                                                       \
> >> +             case 8: {                                               \
> >> +                     register unsigned long long __r2 asm("r2");     \
> >
> > Does this matter? For EABI, we'll pass in (r2, r3) and it's all handcrafted
> > asm, so the compiler shouldn't care much. For OABI, I think you may have to
> > do some more work to get the two words where you want them.
> 
> Is the question whether the compiler is guaranteed to allocate r2 and
> r3 in all cases?  I'm not quite sure, I confess to usually trying to
> avoid inline asm.  But from looking at the disassembly (for little
> endian EABI build) it seemed to do the right thing.

I can't recall how OABI represents 64-bit values and particularly whether this
differs between little and big-endian, so I wondered whether you may have to
do some marshalling when you assign x. However, a few quick experiments with
GCC suggest that the register representation matches EABI in regards to word
ordering (it just doesn't require an even base register), although it would
be good to find this written down somewhere...

> The only other idea I had was to explicitly declare two 'unsigned
> long's and then shift them into a 64bit x, although I'm open to
> suggestions if there is a better way.

Can't you just use register unsigned long long for all cases? Even better,
follow what put_user does and use typeof(*(p))?

> >> diff --git a/arch/arm/lib/getuser.S b/arch/arm/lib/getuser.S
> >> index 9b06bb4..d05285c 100644
> >> --- a/arch/arm/lib/getuser.S
> >> +++ b/arch/arm/lib/getuser.S
> >> @@ -18,7 +18,7 @@
> >>   * Inputs:   r0 contains the address
> >>   *           r1 contains the address limit, which must be preserved
> >>   * Outputs:  r0 is the error code
> >> - *           r2 contains the zero-extended value
> >> + *           r2, r3 contains the zero-extended value
> >>   *           lr corrupted
> >>   *
> >>   * No other registers must be altered.  (see <asm/uaccess.h>
> >> @@ -66,6 +66,19 @@ ENTRY(__get_user_4)
> >>       mov     pc, lr
> >>  ENDPROC(__get_user_4)
> >>
> >> +ENTRY(__get_user_8)
> >> +     check_uaccess r0, 4, r1, r2, __get_user_bad
> >
> > Shouldn't you be passing 8 here, so that we validate the correct range?
> 
> yes, sorry, I'll fix that
> 
> >> +#ifdef CONFIG_THUMB2_KERNEL
> >> +5: TUSER(ldr)        r2, [r0]
> >> +6: TUSER(ldr)        r3, [r0, #4]
> >> +#else
> >> +5: TUSER(ldr)        r2, [r0], #4
> >> +6: TUSER(ldr)        r3, [r0]
> >> +#endif
> >
> > This doesn't work for EABI big-endian systems.
> 
> Hmm, is that true?  Wouldn't put_user() then have the same problem?

I dug up the PCS and it seems that we arrange the two halves of the
doubleword to match the ldm/stm memory representation for EABI, so sorry
for the confusion.

> I guess __ARMEB__ is the flag for big-endian?

That's the thing defined by the compiler, yes.

Will

