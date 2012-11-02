Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762566Ab2KBCMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 22:12:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab2KBCMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 22:12:47 -0400
Date: Fri, 2 Nov 2012 00:12:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC EDAC/GHES] edac: lock module owner to avoid error report
 conflicts
Message-ID: <20121102001220.64a394da@redhat.com>
In-Reply-To: <20121101195509.GE31271@liondog.tnic>
References: <048a00fa4a888b349be5954ce9fd063a7bcf2564.1351691230.git.mchehab@redhat.com>
	<20121101110512.GA31271@liondog.tnic>
	<20121101094721.2a57719c@redhat.com>
	<20121101195509.GE31271@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 1 Nov 2012 21:09:07 +0000
"Luck, Tony" <tony.luck@intel.com> escreveu:
> Em Thu, 1 Nov 2012 20:55:09 +0100
> Borislav Petkov <bp@alien8.de> escreveu:

> > On Thu, Nov 01, 2012 at 09:47:21AM -0200, Mauro Carvalho Chehab wrote:
> > > 1) when both APEI/GHES and sb_edac are loaded, error reports are
> > >    inconsistent: race issues; bad APEI/MCE interface, etc. So, there's
> > >    curently a bug that needs to be fixed;
> > 
> > That's correct. And we probably could add some filter logic to mce_log
> > path so that it doesn't call straight into EDAC over the notifier but go
> > over APEI.

This is one alternative, but I don't think we should invest at 
APEI->MCE interface.

Also, after applying those 4 patches I proposed:
	http://git.infradead.org/users/mchehab/edac.git/shortlog/refs/heads/experimental

There will be two alternatives for error report:

MCE----->EDAC driver ----> EDAC core error report

(usual EDAC way to report errors, on MCE-based platforms)

OR:

APEI---->MCE
    |
    \--->EDAC core error report

"Firmware first" APEI way. 

This is warranted by this proposed patch, as it warrants that, once the first
driver registers at EDAC core, the second one will fail, with a -EPERM return code.

> But as you say, if APEI fakes error information, then it is worth shit.

Yes. There are things that require fixes at the two APEI->EDAC glue patches,
but this path is more consistent than APEI--->MCE--->EDAC driver

Basically, at:
	http://git.infradead.org/users/mchehab/edac.git/commitdiff/e5c85a309f58b260c8ec0a2c6eff9a6d66b4c7e3

It doesn't fill some data needed by EDAC sysfs nodes, on this
proof of concept patches. We need to investigate further if 
APEI can provide such info in a consistent way.

If not... well, we can just disable any EDAC sysfs nodes or maybe
provide some way to fill it via some userspace interface, letting 
some application getting it via dmidecode and/or from some files
with will provide the mapping tables.

>From the error report point of view:
	http://git.infradead.org/users/mchehab/edac.git/commitdiff/654292c78376dfe2b65cd9027787ab54705eeaa6

Nothing is faked on this patch. The only missing information
there is that the label info is not filled.

So, except for Nehalem-EX reports, even with those simple PoC
patches, the error is provided consistently.

> > > 2) some vendors refuse to support EDAC[1];
> > > 
> > > 3) there are some really complex environments with memory hot-plugging,
> > > mirrored memory, spare memories, etc where only the BIOS may provide
> > > a reliable information about the DIMM location, as the configuration
> > > may change dynamically at runtime.

> > That is correct, unfortunately. That information is not available to
> > software in all cases. Maybe APEI could be used for that DIMM location
> > mapping through simple tables instead of letting it fumble the error
> > handling path.
> 
> Not much hope for "simple"[1] tables.  There is also a timings issue on
> system with rank sparing, memory mirroring etc.  ... you need to decode
> to the DIMM at the time the error happened. If you wait until later, then
> the system may have switched over to the spare rank or mirror ... and then
> your decode will point at the new target, rather than the old.

If APEI won't provide any way to uniquely identify the DIMM where the
error occurred, decoding will require a driver as complex as sb_edac, and
indeed, the APEI interface is useless.

However, the APEI interface provides a bunch of values:

+       sprintf(location,"node:%d card:%d module:%d bank:%d device:%d row: %d column:%d bit_pos:%d",
+               mem_err->node, mem_err->card, mem_err->module,
+               mem_err->bank, mem_err->device, mem_err->row, mem_err->column,
+               mem_err->bit_pos);

I didn't read the APEI specs, so, I'm not sure what is filled there, but,
based on the fields names, it seems that the DIMM location is there
(but not the DIMM label).

If so, a simple table is likely enough to convert a node/card/module/bank/device
information into a DIMM label.

There is one problem, though: in order to use the EDAC->dimm label conversion
logic, the APEI driver should be telling to the EDAC core how many nodes,
cards, modules, banks, devices are there at the memory architecture, in order
to allow the EDAC core to create the needed sysfs nodes for the DIMM labels.

I don't think APEI has such kind of information.


> > > [1] they claim that the firmware provided errors are more reliable 
> > > than reading directly from hardware, as they have some special
> > > heuristics logic on their BIOS that detects the difference between a
> > > simple interference and a damaged memory.
> > 
> > Let me guess: they do thresholding. And we actually have that already :)
> > 
> > > > * the error coming from APEI still needs to get decoded by EDAC? If yes,
> > > > then WTF we need APEI for anyway?
> > > 
> > > That's a good question. I understood on some discussions we had, that APEI
> > > would be able to provide the DIMM label. However, I didn't find any field
> > > with such information there at APEI mem_err struct.
> > > 
> > > So, either there are something missing (maybe DIMM labels are part of
> > > APEI 5.0), or we'll still need EDAC decoding logic to get the DIMM.
> > 
> > Right, so we should rely on BIOS telling us what the DIMM mapping is,
> > considering the fact that it does all the DRAM training during boot and
> > has intimate knowledge of the DIMM layout, in general.

If the DIMM layout can't be retrieved by the Kernel by any other means, 
relying on BIOS is the only option left.

> > 
> > APEI, being a WHEA port to the ACPI spec and thus Linux, is kinda
> > useless as I see it.
> > 
> > [ … ]
> > 
> > > Bank information there is fake; status is fake. Only addr is really filled
> > > there; it works only for corrected errors. 
> > > 
> > > Also if you try to decode this, the logic will likely fail, as not all
> > > fields used by either i7core_edac/sb_edac parsers or by userspace decoders
> > > are filled there.
> > > 
> > > For it to work, apei_mce_report_mem_error() would require a complex logic,
> > > that would identify what kind of CPU is in the system, emulating every single
> > > detail of the error reports there, with would be complex, and will be reversed
> > > in userspace anyway.
> > > 
> > > So, IMO, the APEI-MCE integration interface should be simply removed, in favor 
> > > of reporting errors using the EDAC/RAS interface.
> > 
> > Yes, my other concern I had is that once APEI is cast in the firmware,
> > it cannot be changed (or at least very hard: I've tried to get OEMs to
> > update their BIOS for different reasons but it has almost always ended
> > in nirvana). So, I want firmware error handling and OS error handling to
> > be interchangeable so that the one doesn't depend on the other and vice
> > versa.
> > 
> > I.e., I want to be able to turn off APEI and handle errors only in
> > software, without any disadvantage to the users, if APEI is buggy and/or
> > doesn't give all the required info.
> > 
> > And so, if we let APEI handle certain errors, it either should handle
> > them properly or not at all.
> > 
> > Otherwise, we don't need this useless overhead.

I agree: from Linux PoV, users should be free to select either the BIOS based
APEI interface, if they rely enough on their hardware/BIOS vendor, or to
use the hardware way of retrieving the errors (EDAC/MCE).

Regards,
Mauro
