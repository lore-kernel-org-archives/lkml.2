Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab2K1JvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 04:51:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab2K1Ju6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 04:50:58 -0500
Date: Wed, 28 Nov 2012 10:50:51 +0100
From: Petr Tesarik <ptesarik@suse.cz>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Save PG_compound or PG_head value in VMCOREINFO
Message-ID: <20121128105051.6c1585c1@azariah.suse.cz>
In-Reply-To: <87ehjeivqo.fsf@xmission.com>
References: <3774326.lMtTTFYZT3@azariah.suse.cz>
	<87ehjeivqo.fsf@xmission.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V Tue, 27 Nov 2012 15:25:35 -0600
ebiederm@xmission.com (Eric W. Biederman) napsáno:

> Petr Tesarik <ptesarik@suse.cz> writes:
> 
> > To allow filtering of huge pages, makedumpfile must be able to
> > identify them in the dump. This can be done by checking for the
> > appropriate page flag, so communicate its value to makedumpfile
> > through the VMCOREINFO interface.
> 
> I don't have any siginificant problems with exporting this
> information. However that #ifddef looks nasty and confusing.
> 
> Does that #ifdef exist in the huge page code as well?

For the huge page code, the #ifdef is constrained to
include/linux/page-flags.h, which has two sets of functions depending
on CONFIG_PAGEFLAGS_EXTENDED.

The page flag which does exist in a given configuration is implemented
directly using the standard page flag definitions, and the flags that do
not exist are emulated with inline functions of the corresponding name.

> Can we always export both?  Can we only export one?

Neither. Their existence is mutually exclusive, i.e.:

CONFIG_PAGEFLAGS_EXTENDED  -> PG_head, PG_tail, no PG_compound
!CONFIG_PAGEFLAGS_EXTENDED -> PG_compound, no PG_head, no PG_tail

All I can do is create a "virtual" page flag mask (e.g.
PG_hugepage_mask), which is initialized either to 1L << PG_compound or
to (1L << PG_head) | (1L << PG_tail). Such definition could then be
kept in <linux/page-flags.h>. I'm not sure it's worth it, because there
would be only one in-tree user of this new macro.

> What is the purpose of the #ifdef?
> 
> As it stands that looks like code that will figure out how to bitrot
> if we just leave it sitting there.

It cannot simply bitrot and be silently wrong. If it ever gets out of
sync with page-flags.h, this code won't even compile, because one or
the other page flag is always missing.

Petr Tesarik

> > Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> >
> > ---
> >  kernel/kexec.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > --- a/kernel/kexec.c
> > +++ b/kernel/kexec.c
> > @@ -1511,6 +1511,11 @@ static int __init crash_save_vmcoreinfo_
> >  	VMCOREINFO_NUMBER(NR_FREE_PAGES);
> >  	VMCOREINFO_NUMBER(PG_lru);
> >  	VMCOREINFO_NUMBER(PG_private);
> > +#ifdef CONFIG_PAGEFLAGS_EXTENDED
> > +	VMCOREINFO_NUMBER(PG_head);
> > +#else
> > +	VMCOREINFO_NUMBER(PG_compound);
> > +#endif
> >  	VMCOREINFO_NUMBER(PG_swapcache);
> >  
> >  	arch_crash_save_vmcoreinfo();

