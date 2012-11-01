Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2KALrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 07:47:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab2KALrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:47:37 -0400
Date: Thu, 1 Nov 2012 09:47:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC EDAC/GHES] edac: lock module owner to avoid error report
 conflicts
Message-ID: <20121101094721.2a57719c@redhat.com>
In-Reply-To: <20121101110512.GA31271@liondog.tnic>
References: <048a00fa4a888b349be5954ce9fd063a7bcf2564.1351691230.git.mchehab@redhat.com>
	<20121101110512.GA31271@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 1 Nov 2012 12:05:12 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> + Tony.
> 
> On Wed, Oct 31, 2012 at 11:58:15AM -0200, Mauro Carvalho Chehab wrote:
> > There's a know bug that happens when apei/ghes is loaded together
> > with an EDAC module: the same error is reported several times,
> > as ghes calls mcelog, with, in tune, calls edac.
> 
> This is exactly why I think APEI is crap. So it is a completely useless
> additional layer between the MCA code and the rest.

I agree with you on that: getting data directly from the MC is, IMHO, 
more reliable, see below for the reasons why we need this.

> The #MC handler runs, logs the error, and then a split happens which
> runs in parallel:
> 
> * we do mce_log which carries the error to EDAC
> * we enter APEI, do some mumbo jumbo and then do mce_log AGAIN! Wtf?
> 
> So, in order to sort this out properly, let's take a step back first:
> what do we actually want to do?

I can give you more details in person next week, but, basically, there are
a few issues we're trying to solve:

1) when both APEI/GHES and sb_edac are loaded, error reports are
   inconsistent: race issues; bad APEI/MCE interface, etc. So, there's
   curently a bug that needs to be fixed;

2) some vendors refuse to support EDAC[1];

3) there are some really complex environments with memory hot-plugging,
mirrored memory, spare memories, etc where only the BIOS may provide
a reliable information about the DIMM location, as the configuration
may change dynamically at runtime.

[1] they claim that the firmware provided errors are more reliable 
than reading directly from hardware, as they have some special
heuristics logic on their BIOS that detects the difference between a
simple interference and a damaged memory.

> * the error coming from APEI still needs to get decoded by EDAC? If yes,
> then WTF we need APEI for anyway?

That's a good question. I understood on some discussions we had, that APEI
would be able to provide the DIMM label. However, I didn't find any field
with such information there at APEI mem_err struct.

So, either there are something missing (maybe DIMM labels are part of
APEI 5.0), or we'll still need EDAC decoding logic to get the DIMM.

> * the error coming from APEI is already decoded, so no need for EDAC? I
> highly doubt that.

The interface I wrote is a "minimum EDAC" interface: it currently bypasses
almost all EDAC error logic; it only uses the EDAC way to report errors: via
trace and/or via printk. E. g. it is almost a direct call to the RAS tracing
facility.

I did this because I assumed that there's a way to get the DIMM labels
directly at apei/ghes.c.

> * add a filter to the MCE code so that certain types of errors are not
> reported by it but by APEI so that the double reporting doesn't happen?


Take a look at arch/x86/kernel/cpu/mcheck/mce-apei.c:

	void apei_mce_report_mem_error(int corrected, struct cper_sec_mem_err *mem_err)
	{
		struct mce m;

		/* Only corrected MC is reported */
		if (!corrected || !(mem_err->validation_bits &
					CPER_MEM_VALID_PHYSICAL_ADDRESS))
			return;

		mce_setup(&m);
		m.bank = 1;
		/* Fake a memory read corrected error with unknown channel */
		m.status = MCI_STATUS_VAL | MCI_STATUS_EN | MCI_STATUS_ADDRV | 0x9f;
		m.addr = mem_err->physical_addr;
		mce_log(&m);
		mce_notify_irq();
	}

Bank information there is fake; status is fake. Only addr is really filled
there; it works only for corrected errors. 

Also if you try to decode this, the logic will likely fail, as not all
fields used by either i7core_edac/sb_edac parsers or by userspace decoders
are filled there.

For it to work, apei_mce_report_mem_error() would require a complex logic,
that would identify what kind of CPU is in the system, emulating every single
detail of the error reports there, with would be complex, and will be reversed
in userspace anyway.

So, IMO, the APEI-MCE integration interface should be simply removed, in favor 
of reporting errors using the EDAC/RAS interface.

> Right about now, I'm open for hints as to why we need that APEI crap at
> all. And I don't want to hear that "clear interface so that OS coders
> don't need to know the hardware" bullshit argument from the sick world
> of windoze.

-- 
Regards,
Mauro
