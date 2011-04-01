Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1DAHuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 03:50:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43521 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab1DAHuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 03:50:23 -0400
Date: Fri, 1 Apr 2011 09:50:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, rjw@sisk.pl, sedat.dilek@gmail.com,
        stable@kernel.org, #.34+@schatten.dmk.lab
Subject: Re: [PATCH v2] x86, ioapic: Skip looking for ioapic overrides when
 ioapics are not present
Message-ID: <20110401075011.GD7594@elte.hu>
References: <20110331084342.GA30105@elte.hu>
 <1301621025-3858-1-git-send-email-florian@mickler.org>
 <20110401062006.GC32378@elte.hu>
 <alpine.LFD.2.02.1104010245290.2797@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1104010245290.2797@x980>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> 
> > > --- a/arch/x86/kernel/apic/io_apic.c
> > > +++ b/arch/x86/kernel/apic/io_apic.c
> > > @@ -3789,6 +3789,10 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
> > >  {
> > >  	int ioapic, pin, idx;
> > >  
> > > +#ifdef CONFIG_ACPI
> > > +	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
> > > +		return -1;
> > > +#endif
> > 
> > That #ifdef is very ugly. Please introduce a suitable helper function in 
> > arch/x86/include/asm/acpi.h - acpi_irq_ioapic_model() or so, which could be 
> > used like this:
> > 
> > 	if (!acpi_irq_ioapic_model())
> > 		return -1;
> > 
> > And would be defined in the !CONFIG_ACPI case as well.
> 
> It would be better to compile _none_ of acpi_get_override_irq() for !ACPI.

Yeah, agreed - so just move the function into acpi.c and provide an inline stub 
in acpi.h for the !ACPI case.

Note: find_irq_entry() would have to be exported from io_apic.c in this case, 
renamed to ioapic_find_irq_entry() or so - and a stub provided for the !IO_APIC 
case.

Thanks,

	Ingo
