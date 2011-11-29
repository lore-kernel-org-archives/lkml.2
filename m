Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1K2GLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:11:40 -0500
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:38610 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750804Ab1K2GLj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:11:39 -0500
MIME-Version: 1.0
In-Reply-To: <1322435957.23348.23.camel@pasglop>
References: <1322041464-20605-1-git-send-email-tinamdar@apm.com>
	<201111231415.51985.arnd@arndb.de>
	<CACoXjcnfCM8Z5qFfrHtxsXkpf492LVbkDA3X=a9dRv9Lcv7Asw@mail.gmail.com>
	<1322435957.23348.23.camel@pasglop>
Date: Tue, 29 Nov 2011 11:41:37 +0530
Message-ID: <CACoXjc=tcZr_82JwfTzT+6re3d_e3pbn-yXvq=2ofbFSvSXM5g@mail.gmail.com>
Subject: Re: [PATCH] powerpc/40x: Add APM8018X SOC support
From: Tanmay Inamdar <tinamdar@apm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 4:49 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Fri, 2011-11-25 at 17:49 +0530, Tanmay Inamdar wrote:
>
>>
>>         >
>>         > +#if defined(CONFIG_APM8018X)
>>         > +/* CPR */
>>         > +#define DCRN_CPR0_CONFIG_ADDR        0xa
>>         > +#define DCRN_CPR1_CONFIG_DATA        0xb
>>         > +/* AHB */
>>         > +#define DCRN_SDR1_CONFIG_ADDR        0xc
>>         > +#define DCRN_SDR1_CONFIG_DATA        0xd
>>         > +#else
>>         >  /* CPRs (440GX and 440SP/440SPe) */
>>         >  #define DCRN_CPR0_CONFIG_ADDR        0xc
>>         >  #define DCRN_CPR0_CONFIG_DATA        0xd
>>         > +#endif /* CONFIG_APM8018X */
>>
>>
>>         same comment as above.
>>
>> Some existing drivers use these macros. If I change the names, I will
>> have to update the
>> driver code.
>
> Right, the best approach is to create a small wrapper that provides cpr
> and sdr accesses using helpers. That way you can:
>
>  - Properly lock since it's all indirect
>
>  - Obtain the right DCRs at boot time, stick them in variables
>   and use them at runtime, avoiding the hard coded constants completely
>
>  - Make the code generally look much better
>
> Ie. Provide something like read_sdr1() and write_sdr1() accessors and
> change the drivers to use them.

Ok.
There are 'mfdcri' and 'mtdcri' macros in
"arch/powerpc/include/asm/dcr-native.h" file.
They internally use '__mfdcri' and '__mtdcri' functions which can be
used for the same
purpose as mentioned above.
Instead of putting this change in current patch, I will make separate
patch for this purpose.

>
>>         > diff --git a/arch/powerpc/kernel/cputable.c
>>         b/arch/powerpc/kernel/cputable.c
>>         > index edae5bb..e5c51a6 100644
>>         > --- a/arch/powerpc/kernel/cputable.c
>>         > +++ b/arch/powerpc/kernel/cputable.c
>>         > @@ -1505,6 +1505,58 @@ static struct cpu_spec __initdata
>>         cpu_specs[] = {
>>         >               .machine_check          = machine_check_4xx,
>>         >               .platform               = "ppc405",
>>         >       },
>>         > +     {       /* APM80186-SK */
>>         > +             .pvr_mask               = 0xffffffff,
>>         > +             .pvr_value              = 0x7ff11432,
>>
>>
>>         If you mask out the lower bits, you only need a single entry
>>         instead of
>>         four identical ones.
>>
>> You are right. But each PVR represent different version of SOC. If I
>> create single entry, then I will have to give generic cpu_name which I
>> don't want.
>
> Note that you should really tell you designers to move away from using
> the PVR to identify the SoC's. This is BAD and isn't sustainable long
> run. Stick to representing the core itself in the PVR and provide a
> different mechanism to identify the SoC (different SPR would do, or even
> a DCR).
>
>>         > --- a/arch/powerpc/kernel/udbg_16550.c
>>         > +++ b/arch/powerpc/kernel/udbg_16550.c
>>         > @@ -18,6 +18,19 @@ extern void real_writeb(u8 data, volatile
>>         u8 __iomem *addr);
>>         >  extern u8 real_205_readb(volatile u8 __iomem  *addr);
>>         >  extern void real_205_writeb(u8 data, volatile u8 __iomem
>>         *addr);
>>         >
>>         > +#ifdef CONFIG_UART_16550_WORD_ADDRESSABLE
>>         > +struct NS16550 {
>>         > +     /* this struct must be packed */
>>         > +     unsigned char rbr;  /* 0 */ u8 s0[3];
>>         > +     unsigned char ier;  /* 1 */ u8 s1[3];
>>         > +     unsigned char fcr;  /* 2 */ u8 s2[3];
>>         > +     unsigned char lcr;  /* 3 */ u8 s3[3];
>>         > +     unsigned char mcr;  /* 4 */ u8 s4[3];
>>         > +     unsigned char lsr;  /* 5 */ u8 s5[3];
>>         > +     unsigned char msr;  /* 6 */ u8 s6[3];
>>         > +     unsigned char scr;  /* 7 */ u8 s7[3];
>>         > +};
>>         > +#else
>>         >  struct NS16550 {
>>         >       /* this struct must be packed */
>>         >       unsigned char rbr;  /* 0 */
>>         > @@ -29,6 +42,7 @@ struct NS16550 {
>>         >       unsigned char msr;  /* 6 */
>>         >       unsigned char scr;  /* 7 */
>>         >  };
>>         > +#endif /* CONFIG_UART_16550_WORD_ADDRESSABLE */
>>         >
>>
>>
>>         Same things as with the register definitions. Please make this
>>         run-time selectable to allow build-time configurations that
>>         support both layouts.
>>
>> Yes. I will try to find better solution.
>
> Cheers,
> Ben.
>
>
>
Regards,
Tanmay
CONFIDENTIALITY NOTICE: This e-mail message, including any attachments, 
is for the sole use of the intended recipient(s) and contains information 
that is confidential and proprietary to AppliedMicro Corporation or its subsidiaries. 
It is to be used solely for the purpose of furthering the parties' business relationship. 
All unauthorized review, use, disclosure or distribution is prohibited. 
If you are not the intended recipient, please contact the sender by reply e-mail 
and destroy all copies of the original message.


