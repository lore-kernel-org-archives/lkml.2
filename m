Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965344Ab2KATzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:55:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39883 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964853Ab2KATzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:55:12 -0400
Date: Thu, 1 Nov 2012 20:55:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC EDAC/GHES] edac: lock module owner to avoid error report
 conflicts
Message-ID: <20121101195509.GE31271@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Tony Luck <tony.luck@intel.com>,
	Linux Edac Mailing List <linux-edac@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <048a00fa4a888b349be5954ce9fd063a7bcf2564.1351691230.git.mchehab@redhat.com>
 <20121101110512.GA31271@liondog.tnic>
 <20121101094721.2a57719c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121101094721.2a57719c@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 09:47:21AM -0200, Mauro Carvalho Chehab wrote:
> 1) when both APEI/GHES and sb_edac are loaded, error reports are
>    inconsistent: race issues; bad APEI/MCE interface, etc. So, there's
>    curently a bug that needs to be fixed;

That's correct. And we probably could add some filter logic to mce_log
path so that it doesn't call straight into EDAC over the notifier but go
over APEI.

But as you say, if APEI fakes error information, then it is worth shit.

> 2) some vendors refuse to support EDAC[1];
> 
> 3) there are some really complex environments with memory hot-plugging,
> mirrored memory, spare memories, etc where only the BIOS may provide
> a reliable information about the DIMM location, as the configuration
> may change dynamically at runtime.

That is correct, unfortunately. That information is not available to
software in all cases. Maybe APEI could be used for that DIMM location
mapping through simple tables instead of letting it fumble the error
handling path.

> [1] they claim that the firmware provided errors are more reliable 
> than reading directly from hardware, as they have some special
> heuristics logic on their BIOS that detects the difference between a
> simple interference and a damaged memory.

Let me guess: they do thresholding. And we actually have that already :)

> > * the error coming from APEI still needs to get decoded by EDAC? If yes,
> > then WTF we need APEI for anyway?
> 
> That's a good question. I understood on some discussions we had, that APEI
> would be able to provide the DIMM label. However, I didn't find any field
> with such information there at APEI mem_err struct.
> 
> So, either there are something missing (maybe DIMM labels are part of
> APEI 5.0), or we'll still need EDAC decoding logic to get the DIMM.

Right, so we should rely on BIOS telling us what the DIMM mapping is,
considering the fact that it does all the DRAM training during boot and
has intimate knowledge of the DIMM layout, in general.

APEI, being a WHEA port to the ACPI spec and thus Linux, is kinda
useless as I see it.

[ … ]

> Bank information there is fake; status is fake. Only addr is really filled
> there; it works only for corrected errors. 
> 
> Also if you try to decode this, the logic will likely fail, as not all
> fields used by either i7core_edac/sb_edac parsers or by userspace decoders
> are filled there.
> 
> For it to work, apei_mce_report_mem_error() would require a complex logic,
> that would identify what kind of CPU is in the system, emulating every single
> detail of the error reports there, with would be complex, and will be reversed
> in userspace anyway.
> 
> So, IMO, the APEI-MCE integration interface should be simply removed, in favor 
> of reporting errors using the EDAC/RAS interface.

Yes, my other concern I had is that once APEI is cast in the firmware,
it cannot be changed (or at least very hard: I've tried to get OEMs to
update their BIOS for different reasons but it has almost always ended
in nirvana). So, I want firmware error handling and OS error handling to
be interchangeable so that the one doesn't depend on the other and vice
versa.

I.e., I want to be able to turn off APEI and handle errors only in
software, without any disadvantage to the users, if APEI is buggy and/or
doesn't give all the required info.

And so, if we let APEI handle certain errors, it either should handle
them properly or not at all.

Otherwise, we don't need this useless overhead.

-- 
Regards/Gruss,
    Boris.
