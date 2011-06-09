Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1FIO6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:58:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60419 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1FIO6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:58:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XIuvlpPLF79QLlzFO5tvMBVzW95BD5jErMpIE2T65PUAEkDBK/l4KIsiARkEb2PbxW
         Tw4w6Iy2dW/Nnlei31tvOLglvf1AeWMZ0wlInQG7Me8iQosA70+pYYY5xh0GDK9JKiay
         qTp4WidXYXe11ztU0f+YjoKUmOHB2wz+u5QXI=
MIME-Version: 1.0
In-Reply-To: <1307494057.2874.212.camel@pasglop>
References: <1307482573-25440-1-git-send-email-ericvh@gmail.com>
	<1307494057.2874.212.camel@pasglop>
Date: Thu, 9 Jun 2011 09:58:44 -0500
Message-ID: <BANLkTinD+1+QTUhKvQP-T_bZgbi1YS1jwQ@mail.gmail.com>
Subject: Re: [PATCH] [RFC][V3] bluegene: use MMU feature flag to
 conditionalize L1 writethrough code
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 7:47 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Tue, 2011-06-07 at 16:36 -0500, Eric Van Hensbergen wrote:
>
>> open to alternatives.  jimix also suggested changing NEED_L1_WRITETHROUGH
>> to DCBZ_BROKEN, which I'm open to if you think appropriate, or maybe
>> DCBZ_BROKEN_DAMNIT would be more apt.
>
> :-)
>
> I think NEED_L1_WRITETHROUGH isn't great since we are dealing with more
> than just that here. Let's call it 44x_SMP since afaik, all
> implementations, whether it's BG or other variants of the same hack
> (AMCC/APM has one too) need the same stuff here, no ?
>
> Let's not use more than one feature bit, it's not needed in practice, a
> better name is all we need. Might even call it MMU_FTR_BLUEGENE_44x_SMP
> if you want.
>

I've got it as MMU_FTR_44x_SMP now, just wanted to bounce off of Josh to
make sure he's okay with it since he owns the 44x stuff.  If he'd
rather, I'll change
it to MMU_FTR_BGP_44x_SMP.

>
> I'll add comments inline:
>
>>  #define PPC44x_MMUCR_TID     0x000000ff
>>  #define PPC44x_MMUCR_STS     0x00010000
>> +#define PPC44x_MMUCR_U2              0x00200000
>
> Please document in a comment what is the effect of U2 on the BG/P ASIC
> caches.
>

Is a comment sufficient, or would you rather also have something along
the lines of
+#define PPC44x_MMUCR_U2              0x00200000
+#define PPC44x_MMUCR_U2_SWOAE   PPC44x_MMUCR_U2 /* store without allocation */

or even...
+#define PPC44x_MMUCR_U2_BGP_SWOAE   PPC44x_MMUCR_U2 /* store without
allocation on BGP */

Seems like its getting a bit too verbose, maybe that's not a bad
thing.  As long as I don't have to type it
too many times :)

>
> BTW. Care to explain to me why you have U2 -both- in the arguments to
> tlbwe and in MMUCR ? That doesn't look right to me... which one is used
> where and when ?
>

My reading of the databook is that U2SWOAE is an enable bit that lets the U2
storage attribute control the behavior.

>> @@ -814,7 +829,15 @@ skpinv:  addi    r4,r4,1                         /* Increment */
>>       /* attrib fields */
>>       /* Added guarded bit to protect against speculative loads/stores */
>>       li      r5,0
>> -     ori     r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G)
>> +BEGIN_MMU_FTR_SECTION
>> +     ori     r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | \
>> +                                             PPC44x_TLB_G | PPC44x_TLB_U2)
>> +     oris    r5,r5,PPC44x_TLB_WL1@h
>> +END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)
>> +BEGIN_MMU_FTR_SECTION
>> +     ori     r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | \
>> +                     PPC44x_TLB_G)
>> +END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
>>
>>          li      r0,63                    /* TLB slot 63 */
>
> This isn't going to work. This happens before the CPU feature bits are
> established.
>
> I see two ways out of that dilemna:
>
>  - One is you find a way to identify the BG case at runtime from that
> very early asm code. It's a bit tricky since we never added the MMU type
> information to the device-tree blob header (but we're adding it to ePAPR
> via a register iirc, so we could hijack that), or maybe via inspecting
> what the FW left behind in the TLB...
>

Well, if we are using the u-boot scenario, I can control how the
bootloader sets up the device tree and add markers that we can use to
let us do this.



>> diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
>> index 998a100..b54e2e8 100644
>> --- a/arch/powerpc/kernel/misc_32.S
>> +++ b/arch/powerpc/kernel/misc_32.S
>> @@ -506,7 +506,27 @@ _GLOBAL(clear_pages)
>>       li      r0,PAGE_SIZE/L1_CACHE_BYTES
>>       slw     r0,r0,r4
>>       mtctr   r0
>> -1:   dcbz    0,r3
>> +     li      r4, 0
>> +1:
>> +BEGIN_MMU_FTR_SECTION
>> +     /* assuming 32 byte cacheline */
>> +     stw     r4, 0(r3)
>> +     stw     r4, 4(r3)
>> +     stw     r4, 8(r3)
>> +     stw     r4, 12(r3)
>> +     stw     r4, 16(r3)
>> +     stw     r4, 20(r3)
>> +     stw     r4, 24(r3)
>> +     stw     r4, 28(r3)
>> +END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)
>> +/*
>> + * would have used an ELSE_MMU_FTR_SECTION here but it
>> + * broke the code with Error: non-constant expression in ".if" statement
>> + *
>> + */
>> +BEGIN_MMU_FTR_SECTION
>> +     dcbz    0,r3
>> +END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
>>       addi    r3,r3,L1_CACHE_BYTES
>>       bdnz    1b
>>       blr
>> @@ -550,7 +570,9 @@ _GLOBAL(copy_page)
>>       mtctr   r0
>>  1:
>>       dcbt    r11,r4
>> +BEGIN_MMU_FTR_SECTION
>>       dcbz    r5,r3
>> +END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
>>       COPY_16_BYTES
>>  #if L1_CACHE_BYTES >= 32
>>       COPY_16_BYTES
>
> Instead here I would just do a single feature section as the first
> instruction of clear_pages() that covers a branch out of line to an
> alternate implementation of the whole function.
>
> _GLOBAL(clear_pages)
> BEGIN_MMU_FTR_SECTION
>        b       clear_pages_no_dcbz
> END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)
>        .../...
>

okay, jimi had suggested something similar:
clear_pages_fake:
	li	r4, 0
1:	fake_dcbz r4, r3, L1_CACHE_BYTES
	addi	r3,r3,L1_CACHE_BYTES
	bdnz	1b
	blr

_GLOBAL(clear_pages)
	li	r0,PAGE_SIZE/L1_CACHE_BYTES
	slw	r0,r0,r4
	mtctr	r0
BEGIN_MMU_FTR_SECTION
	b	clear_pages_fake
END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)


>> diff --git a/arch/powerpc/lib/copy_32.S b/arch/powerpc/lib/copy_32.S
>> index 55f19f9..2646838 100644
>> --- a/arch/powerpc/lib/copy_32.S
>> +++ b/arch/powerpc/lib/copy_32.S
>> @@ -12,6 +12,7 @@
>>  #include <asm/cache.h>
>>  #include <asm/errno.h>
>>  #include <asm/ppc_asm.h>
>> +#include <asm/mmu.h>
>
> This is a bit more nasty. At some point we'll have to butcher that code
> in order to deal with 440 and 476 that have different cache line sizes
> and which we still want in the same kernel binary. In the meantime
> I'd do like previously and just duplicate the whole lot with just a
> single branch out.
>
> Note that I fail to see how your cachable_memzero can be correct since
> you don't replace dcbz with anything. On the other hand, the only user
> of it in the entire tree is ... clearing the hash table in ppc_mmu_32.c
> which we don't use on 440.
>

Yeah, as I was going over the take2 version of the patch, I was
uncomfortable with this as well.  I guess the BG guys just never
tripped over it because it was never called.

> So why don't you just make a separate patch that just completely gets
> rid of cachable_memzero() and use a memset in ppc_mmu_32.c ? I don't
> think anybody will notice the difference....
>
> For cachable_memcpy and copy_tofrom_user, just removing the dcbz's will
> do for now, though I wonder whether we could just remove cachable_memcpy
> as well. The only user is the EMAC driver and I doubt anybody will be
> able to measure the difference. It will make everbody life easier in the
> long term to remove those.
>

Okay, will do.

>>       :
>>  #ifdef CONFIG_PPC47x
>>       : "r" (PPC47x_TLB2_S_RWX),
>> -#else
>> +#elseif CONFIG_BGP_L1_WRITETHROUGH
>> +     : "r" (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_WL1 \
>> +             | PPC44x_TLB_U2 | PPC44x_TLB_M),
>> +#else /* neither CONFIG_PPC47x or CONFIG_BGP_L1_WRITETHROUGH */
>>       : "r" (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G),
>> -#endif
>> +#endif /* CONFIG_PPC47x */
>>         "r" (phys),
>>         "r" (virt | PPC44x_TLB_VALID | PPC44x_TLB_256M),
>>         "r" (entry),
>
> Make this conditional at runtime.
>

Oops.  sorry, that one slipped through.  I'll try and turn around [V4]
later today.  Thanks for the feedback.

       -eric
