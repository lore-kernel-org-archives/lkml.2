Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab1KYMxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 07:53:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50046 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1KYMxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 07:53:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [PATCH] powerpc/40x: Add APM8018X SOC support
Date: Fri, 25 Nov 2011 12:53:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: jwboyer@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
References: <1322041464-20605-1-git-send-email-tinamdar@apm.com> <201111231415.51985.arnd@arndb.de> <CACoXjcnfCM8Z5qFfrHtxsXkpf492LVbkDA3X=a9dRv9Lcv7Asw@mail.gmail.com>
In-Reply-To: <CACoXjcnfCM8Z5qFfrHtxsXkpf492LVbkDA3X=a9dRv9Lcv7Asw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111251253.29528.arnd@arndb.de>
X-Provags-ID: V02:K0:c7KXaaYVm7z1wdVXxkKxcV+PDzA5qysZw39KU/hVB9a
 256MMR0Lzc2R6MMtijEMVDKyGIqiDxm6F/laDjUoyOYScKESFV
 qqtJHJEu2CVLr/rLJK3+o/XvXiEB1VSHUazVZzbF3xpSbnN/PQ
 hd51mzO5ULmI60zHF8Kn2Qzgj+rIzpIZwNeYnGu1eG1G+p/5xc
 3kVsa1pLayJ8JDB01czYRXSro2mXPXdxUWa02yIwtNlTQ80xSK
 pj0VwC30Zy+h3gExhKnV54zhbwv2f2eNxH4ZUYjyKJUXp+VIwd
 lS2d04SyOMIqm4o+muemhiGCzhDDWi9+VCmjaDB6mzr7pfmjBp
 YSBt1FR7tpDYnYs3tYzc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 November 2011, Tanmay Inamdar wrote:
> > >
> > > +#if defined(CONFIG_APM8018X)
> > > +/* CPR */
> > > +#define DCRN_CPR0_CONFIG_ADDR        0xa
> > > +#define DCRN_CPR1_CONFIG_DATA        0xb
> > > +/* AHB */
> > > +#define DCRN_SDR1_CONFIG_ADDR        0xc
> > > +#define DCRN_SDR1_CONFIG_DATA        0xd
> > > +#else
> > >  /* CPRs (440GX and 440SP/440SPe) */
> > >  #define DCRN_CPR0_CONFIG_ADDR        0xc
> > >  #define DCRN_CPR0_CONFIG_DATA        0xd
> > > +#endif /* CONFIG_APM8018X */
> >
> > same comment as above.
> >
> 
> Some existing drivers use these macros. If I change the names, I will have
> to update the
> driver code.

Not so many apparently:

$ git grep DCRN_CPR._CONFIG 
arch/powerpc/include/asm/dcr-regs.h:#define DCRN_CPR0_CONFIG_ADDR       0xc
arch/powerpc/include/asm/dcr-regs.h:#define DCRN_CPR0_CONFIG_DATA       0xd
arch/powerpc/kvm/44x_emulate.c:                 case DCRN_CPR0_CONFIG_ADDR:
arch/powerpc/kvm/44x_emulate.c:                 case DCRN_CPR0_CONFIG_DATA:
arch/powerpc/kvm/44x_emulate.c:                         mtdcr(DCRN_CPR0_CONFIG_ADDR,
arch/powerpc/kvm/44x_emulate.c:                                        mfdcr(DCRN_CPR0_CONFIG_DATA));
arch/powerpc/kvm/44x_emulate.c:                 case DCRN_CPR0_CONFIG_ADDR:

Don't worry about out of tree drivers. If you want to be nice to the authors,
rename the macros so that the drivers break in an obvious way rather than
silently.

Note that any drivers relying on these as a constant are already broken
as soon as you try to build a kernel with both APM8018X and 440 enabled,
so you absolutely have to change the device drivers to work with those
kernels.

> > > diff --git a/arch/powerpc/kernel/cputable.c
> > b/arch/powerpc/kernel/cputable.c
> > > index edae5bb..e5c51a6 100644
> > > --- a/arch/powerpc/kernel/cputable.c
> > > +++ b/arch/powerpc/kernel/cputable.c
> > > @@ -1505,6 +1505,58 @@ static struct cpu_spec __initdata cpu_specs[] = {
> > >               .machine_check          = machine_check_4xx,
> > >               .platform               = "ppc405",
> > >       },
> > > +     {       /* APM80186-SK */
> > > +             .pvr_mask               = 0xffffffff,
> > > +             .pvr_value              = 0x7ff11432,
> >
> > If you mask out the lower bits, you only need a single entry instead of
> > four identical ones.
> >
> 
> You are right. But each PVR represent different version of SOC. If I create
> single
> entry, then I will have to give generic cpu_name which I don't want.

Isn't the common name for these always "APM80186"? If you don't need to tell
the difference between them for the purposes of cpu_spec, then don't do
it here.

	Arnd
