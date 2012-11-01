Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761958Ab2KARrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 13:47:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab2KARrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 13:47:51 -0400
Date: Thu, 1 Nov 2012 15:47:30 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC EDAC/GHES] edac: lock module owner to avoid error report
 conflicts
Message-ID: <20121101154730.3580c356@redhat.com>
In-Reply-To: <CA+8MBbK5J1qWqTZjC6nHsVbqk05t0yF1F7d-_0PQpvBQBXgO1w@mail.gmail.com>
References: <048a00fa4a888b349be5954ce9fd063a7bcf2564.1351691230.git.mchehab@redhat.com>
	<20121101110512.GA31271@liondog.tnic>
	<20121101094721.2a57719c@redhat.com>
	<CA+8MBbK5J1qWqTZjC6nHsVbqk05t0yF1F7d-_0PQpvBQBXgO1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 1 Nov 2012 10:25:23 -0700
Tony Luck <tony.luck@intel.com> escreveu:

> On Thu, Nov 1, 2012 at 4:47 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Take a look at arch/x86/kernel/cpu/mcheck/mce-apei.c:
> >
> >         void apei_mce_report_mem_error(int corrected, struct cper_sec_mem_err *mem_err)
> >         {
> >                 struct mce m;
> >
> >                 /* Only corrected MC is reported */
> >                 if (!corrected || !(mem_err->validation_bits &
> >                                         CPER_MEM_VALID_PHYSICAL_ADDRESS))
> >                         return;
> >
> >                 mce_setup(&m);
> >                 m.bank = 1;
> >                 /* Fake a memory read corrected error with unknown channel */
> >                 m.status = MCI_STATUS_VAL | MCI_STATUS_EN | MCI_STATUS_ADDRV | 0x9f;
> >                 m.addr = mem_err->physical_addr;
> >                 mce_log(&m);
> >                 mce_notify_irq();
> >         }
> >
> > Bank information there is fake; status is fake. Only addr is really filled
> > there; it works only for corrected errors.
> 
> This went in like this to help out the Westmere-EX processors that
> didn't fill out MCi_ADDR for corrected errors. APEI could get the
> address from some platform CSRs ... reporting via /dev/mcelog
> so that predictive analysis in mcelog(8) would work on these machines.

Ok, but it is broken on other platforms like Sandy Bridge.

> I don't think we can rip it out yet ... not until those machines are
> shuffled off to recycle heaven.

Perhaps then we could add a logic at apei-mce to only forward errors to
MCE on the platforms where the MCE log is known to be right.

> But perhaps we should get smarter about which machines we enable
> APEI on?

That makes sense. IMO, APEI should be on by default only if no other driver
exists, like in the case of Nehalem-EX. For platforms supported by i7core_edac,
sb_edac and amd64_edac, we could add a parameter to explicitly force it to
be on, otherwise, APEI will be disabled.

> If we get everything we need from the machine check banks,
> then the detour via the BIOS to report the same thing again isn't helpful.

Agreed.

Regards,
Mauro
