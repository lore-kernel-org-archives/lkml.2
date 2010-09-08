Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab0IHLeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 07:34:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41299 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0IHLeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 07:34:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=cEZ+DV4swLWcYF5+cvanZmSFRnko5mobHiHfNtSQaqES6asA5ROdK04ryGk3lPtmNG
         wo1YW+MaD6RCP68F8iL9cC8VfF19wTaTrarh9VSPj5lFTyFr6sPwos+ajoyrGm4pepjQ
         +Ffo6Jhj6sytYp/ia02Izvvbb1MzlCA5Gwty8=
MIME-Version: 1.0
In-Reply-To: <201009081115.15544.hpj@urpla.net>
References: <fmbxh-5N8-41@gated-at.bofh.it>
	<55BC9463-95B9-4034-AA1E-55042D6E9354@gmail.com>
	<201009081115.15544.hpj@urpla.net>
Date: Wed, 8 Sep 2010 12:34:12 +0100
Message-ID: <AANLkTi=U40mzeMh-UJJy=ggVDry2qDWW-MYYyBhS_Kex@mail.gmail.com>
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
From: Nick Lowe <nick.lowe@gmail.com>
To: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If a process crashes because of NOPL usage, you get the feedback loop to fix it.

The beauty of open source is that we can recompile to correct the bad
assumption; the latest version of binutils (GAS) finally corrects the
bad semantic that generic i686 includes NOPL.

http://sourceware.org/ml/binutils-cvs/2010-08/msg00057.html
http://gcc.gnu.org/ml/gcc/2010-08/msg00194.html

That fixes the vast vast majority of cases, so I really don't see the
need for this.

I've posted a RFC on "Promoting Crusoe and Geode Processors to i686
Status" if you have any thoughts on that?

Cheers,

Nick

On Wed, Sep 8, 2010 at 10:15 AM, Hans-Peter Jansen <hpj@urpla.net> wrote:
> On Tuesday 07 September 2010, 17:57:17 Nick Lowe wrote:
>> In my opinion, this patch shouldn't be seen as a solution in the
>> slightest. To me, it's a ugly hack and a kludge at best!
>>
>> Abstractly a NOP is meant to be exactly as it says on the tin, a No
>> Operation.
>>
>> It's meant to do nothing at all - for a predefined number of clock
>> cycles. A NOP is commonly used for timing purposes, this completely
>> breaks that contract surely?
>>
>> NOPL is not standard i686, it was undocumented and has just been de facto
>> supported since the Pentium Pro.
>>
>> The solution is surely to ensure that when something is compiled for
>> generic i686, NOPL is nowhere to be seen... Any compiler that does
>> otherwise is broken.
>
> From a user POV, this patch done right is the better solution, because you
> cannot ensure, that all code _generally_ comply to your *policy*. This is
> not a kernel only issue! Keep processes crashing is worse IMHO.
>
> With properly done, I mean:
>  - runtime check, if iopl opcode exists
>  - emulate, if not
>
> Hence, don't bind this to nor label it after a certain cpu model.
>
> Remember: we do not live in a perfect world.
>
> Pete
>
>> For example, until recently, the basic semantics for choosing the NOP
>> sequence were completely wrong in binutils. This has, finally, been
>> fixed!
>>
>> http://sourceware.org/ml/binutils-cvs/2010-08/msg00057.html
>> http://gcc.gnu.org/ml/gcc/2010-08/msg00194.html
>>
>> On 27 Aug 2010, at 19:10, Matteo Croce wrote:
>> > Hi,
>> > I have received many mails asking to refresh the patch so I decided to
>> > post them on the public mailing list
>> > In this version such feature is configurable via a kernel config option
>> >
>> > Signed-off-by: Matteo Croce <matteo@openwrt.org>
>> >
>> > --- a/arch/x86/kernel/Makefile      2010-08-27 00:27:50.101261000 +0200
>> > +++ b/arch/x86/kernel/Makefile      2010-08-27 00:31:11.391261002 +0200
>> > @@ -88,6 +88,8 @@
>> > obj-$(CONFIG_APB_TIMER)             += apb_timer.o
>> >
>> > obj-$(CONFIG_K8_NB)         += k8.o
>> > +obj-$(CONFIG_GEODE_NOPL)   += nopl_emu.o
>> > +obj-$(CONFIG_GEODE_NOPL)   += nopl_emu.o
>> > obj-$(CONFIG_DEBUG_RODATA_TEST)     += test_rodata.o
>> > obj-$(CONFIG_DEBUG_NX_TEST) += test_nx.o
>> >
>> > --- a/arch/x86/kernel/cpu/amd.c     2010-08-27 00:27:50.161261000 +0200
>> > +++ b/arch/x86/kernel/cpu/amd.c     2010-08-27 00:34:13.371261000 +0200
>> > @@ -137,11 +137,15 @@
>> >             return;
>> >     }
>> >
>> > +#ifdef CONFIG_GEODE_NOPL
>> >     if (c->x86_model == 10) {
>> > -           /* AMD Geode LX is model 10 */
>> > -           /* placeholder for any needed mods */
>> > +           /* Geode only lacks the NOPL instruction to be i686,
>> > +              but we can promote it to a i686 class cpu
>> > +              and emulate NOPLs in the exception handler*/
>> > +           boot_cpu_data.x86 = 6;
>> >             return;
>> >     }
>> > +#endif
>> > }
>> >
>> > static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
>> > --- a/arch/x86/kernel/entry_32.S    2010-08-27 00:27:50.051261000 +0200
>> > +++ b/arch/x86/kernel/entry_32.S    2010-08-27 00:57:35.531261000 +0200
>> > @@ -978,7 +978,11 @@
>> >     RING0_INT_FRAME
>> >     pushl $0
>> >     CFI_ADJUST_CFA_OFFSET 4
>> > +#ifdef CONFIG_GEODE_NOPL
>> > +   pushl $do_nopl_emu
>> > +#else
>> >     pushl $do_invalid_op
>> > +#endif
>> >     CFI_ADJUST_CFA_OFFSET 4
>> >     jmp error_code
>> >     CFI_ENDPROC
>> > --- /dev/null       1970-01-01 00:00:00.000000000 +0000
>> > +++ b/arch/x86/kernel/nopl_emu.c    2010-08-27 00:27:57.881261002 +0200
>> > @@ -0,0 +1,110 @@
>> > +/*
>> > + *  linux/arch/x86/kernel/nopl_emu.c
>> > + *
>> > + *  Copyright (C) 2002  Willy Tarreau
>> > + *  Copyright (C) 2010  Matteo Croce
>> > + */
>> > +
>> > +#include <asm/processor.h>
>> > +#include <asm/traps.h>
>> > +
>> > +/* This code can be used to allow the AMD Geode to hopefully correctly
>> > execute + * some code which was originally compiled for an i686, by
>> > emulating NOPL, + * the only missing i686 instruction in the CPU
>> > + *
>> > + * Willy Tarreau <willy@meta-x.org>
>> > + * Matteo Croce <technoboy85@gmail.co>
>> > + */
>> > +
>> > +static inline int do_1f(u8 *ip)
>> > +{
>> > +   int length = 3;
>> > +   switch (*ip) {
>> > +   case 0x84:
>> > +           if (!ip[5])
>> > +                   length++;
>> > +           else
>> > +                   return 0;
>> > +   case 0x80:
>> > +           if (!ip[4] && !ip[3])
>> > +                   length += 2;
>> > +           else
>> > +                   return 0;
>> > +   case 0x44:
>> > +           if (!ip[2])
>> > +                   length++;
>> > +           else
>> > +                   return 0;
>> > +   case 0x40:
>> > +           if (!ip[1])
>> > +                   length++;
>> > +           else
>> > +                   return 0;
>> > +   case 0x00:
>> > +           return length;
>> > +   }
>> > +   return 0;
>> > +}
>> > +
>> > +static inline int do_0f(u8 *ip)
>> > +{
>> > +   if (*ip == 0x1f)
>> > +           return do_1f(ip + 1);
>> > +   return 0;
>> > +}
>> > +
>> > +static inline int do_66(u8 *ip)
>> > +{
>> > +   if (*ip == 0x90)
>> > +           return 2;
>> > +   if (*ip == 0x0f) {
>> > +           int res = do_0f(ip + 1);
>> > +           if (res)
>> > +                   return res + 1;
>> > +           else
>> > +                   return 0;
>> > +   }
>> > +   return 0;
>> > +}
>> > +
>> > +static inline int do_start(u8 *ip)
>> > +{
>> > +   if (*ip == 0x0f)
>> > +           return do_0f(ip + 1);
>> > +   if (*ip == 0x66)
>> > +           return do_66(ip + 1);
>> > +   return 0;
>> > +}
>> > +
>> > +/* [do_nopl_emu] is called by exception 6 after an invalid opcode has
>> > been + * encountered. It will try to emulate it by doing nothing,
>> > + * and will send a SIGILL or SIGSEGV to the process if not possible.
>> > + * the NOPL can have variable length opcodes:
>> > +
>> > +bytes number       opcode
>> > +   2       66 90
>> > +   3       0f 1f 00
>> > +   4       0f 1f 40 00
>> > +   5       0f 1f 44 00 00
>> > +   6       66 0f 1f 44 00 00
>> > +   7       0f 1f 80 00 00 00 00
>> > +   8       0f 1f 84 00 00 00 00 00
>> > +   9       66 0f 1f 84 00 00 00 00 00
>> > +*/
>> > +void do_nopl_emu(struct pt_regs *regs, long error_code)
>> > +{
>> > +   u8 *ip = (u8 *)instruction_pointer(regs);
>> > +   int res = do_start(ip);
>> > +
>> > +   if (res) {
>> > +           int i = 0;
>> > +           do {
>> > +                   ip += res;
>> > +                   i++;
>> > +                   res = do_start(ip);
>> > +           } while(res);
>> > +           printk(KERN_DEBUG "geode_nopl: emulated %d instructions\n", i);
>> > +           regs->ip = (typeof(regs->ip))ip;
>> > +   } else
>> > +           do_invalid_op(regs, error_code);
>> > +}
>> >
>> >
>> > --
>> > Matteo Croce
>> > OpenWrt developer
>> > Â  _______Â  Â  Â  Â  Â  Â  Â  Â  Â  Â Â  ________Â  Â  Â  Â  __
>> > Â |Â  Â  Â Â  |.-----.-----.-----.|Â  |Â  |Â  |.----.|Â  |_
>> > Â |Â Â  -Â Â  ||Â  _Â  |Â  -__|Â  Â Â  ||Â  |Â  |Â  ||Â Â  _||Â Â  _|
>> > Â |_______||Â Â  __|_____|__|__||________||__|Â  |____|
>> > Â  Â  Â  Â  Â  |__| W I R E L E S SÂ Â  F R E E D O M
>> > Â KAMIKAZE (bleeding edge) ------------------
>> > Â  * 10 oz VodkaÂ  Â  Â Â  Shake well with ice and strain
>> > Â  * 10 oz Triple secÂ  mixture into 10 shot glasses.
>> > Â  * 10 oz lime juiceÂ  Salute!
>> > Â ---------------------------------------------------
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> > in the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
