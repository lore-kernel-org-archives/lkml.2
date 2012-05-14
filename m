Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab2ENNeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:34:23 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44477 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab2ENNeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:34:21 -0400
Date: Mon, 14 May 2012 15:34:04 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
Message-ID: <20120514133404.GE4231@aftab.osrc.amd.com>
References: <1336679788-4982-1-git-send-email-mchehab@redhat.com>
 <20120510204042.GA4598@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192EC1A2@ORSMSX104.amr.corp.intel.com>
 <4FAC3C35.70101@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F192EC247@ORSMSX104.amr.corp.intel.com>
 <4FAC6FF8.3050608@redhat.com>
 <20120511102527.GI8913@aftab.osrc.amd.com>
 <4FAD081C.5000704@redhat.com>
 <20120511172430.GB17299@aftab.osrc.amd.com>
 <4FAD5CAD.90508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAD5CAD.90508@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 03:38:37PM -0300, Mauro Carvalho Chehab wrote:
> True. Yet, "mc_event" fits better, as some drivers can also report events
> that aren't errors. So, calling it as "mc_error", as on my original patch
> is actually wrong. For example, i5100 can report those types of events:
> 
> 		"spare copy initiated", /* 20 */
> 		"spare copy completed", /* 21 */
> 
> Spare copy events don't fit into "errors". Other drivers can also report events
> like passing some temperature thresholds that aren't really errors.
> 
> Eventually, we might need yet-another severity type for those types of events,
> as they aren't Corrected/Uncorrected/Fatal errors, but just notify events.

Stupid i5100... :-)

> >>>> The error count msg ("1 error(s)") could be replaced by "count:1".
> >>>
> >>> Is there even a possibility to report more than one error when invoking
> >>> trace_mc_error once? If not, simply drop the count completely.
> >>
> >> Good point. It makes sense to add a count parameter to the error handling core, 
> >> in order to handle "count". AFAIKT, the only two drivers that currently reports
> >> error counts are sb_edac and i7core_edac.
> > 
> > What does that mean? You report multiple errors with one tracepoint
> > invocation? How do you report error details then?
> 
> When a burst of errors happen at the same memory address (within a grain), a 
> few memory controllers can merge them into a single report, providing an error

What does "a few memory controllers can merge them into a single report"
mean exactly? Which few? Do you have an example output?

> count and a overflow flag, if the burst is higher than the register size.
> 
> > If you only report single errors, error count will always be 1 so drop
> > it.
> 
> No, it is not single errors. It is multiple errors at the same address/grain.

Oh, so the SB MC can report multiple errors with one MCE or whatever it uses?

> >> With regards to sb_edac, it also needs another logic to be handled by
> >> the core: channel_mask. This is required to handle lockstep mode and
> >> mirror mode.
> > 
> > What does "handle lockstep mode" mean and how is that important for me
> > staring at the tracepoint output.
> 
> That were already explained dozens of time on the patch review threads:
> 
> The error check on lookstep mode is calculated over a 128 bits cacheline.
> The memory controller sometimes is not able to distinguish if the error 
> happened on the first channel or on the second channel.

Ah, channel interleaving.

> So, either one (or the two) envolved DIMMs should be responsible for it.

Ok, so in that case having channel mask in there doesn't begin to
explain the user what that means - only you and Intel people know that.

In that case, you probably want to make it much more explicit:

"kworker/u:6-201   [007] .N..   161.136624: [Hardware Error]: memory read on unknown memory... (... channel: ...)"

like in the case with interleaved csrow controllers or something to that
effect saying that you cannot pinpoint the DIMM but it could be either
of the n DIMMs on channels ....

?

> >>> Here's how it should look:
> >>>
> >>> kworker/u:6-201   [007] .N..   161.136624: [Hardware Error]: memory read on memory stick "DIMM_A1" (type: corrected socket:0 mc:0 channel:0 slot:0 rank:1 page:0x586b6e offset:0xa66 grain:32 syndrome:0x0 channel_mask:1)
> >>
> >> As already explained: the error_msg is not consistent among the drivers.
> >>
> >> So, "memory read on ..." will work fine on sb_edac/i7core_edac but it _won't_
> >> work on other drivers.
> >>
> >> Changing this field on each driver requires deep knowledge of each memory
> >> controller, and not all datasheets are publicly available. 
> >>
> >> For example, this is the code for Freescale MPC85xx EDAC driver:
> >>
> >> 	if (err_detect & DDR_EDE_SBE)
> >> 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
> >> 				     pfn, err_addr & ~PAGE_MASK, syndrome,
> >> 				     row_index, 0, -1,
> >> 				     mci->ctl_name, "", NULL);
> >>
> >> 	if (err_detect & DDR_EDE_MBE)
> >> 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
> >> 				     pfn, err_addr & ~PAGE_MASK, syndrome,
> >> 				     row_index, 0, -1,
> >> 				     mci->ctl_name, "", NULL);
> >>
> >> It uses a blank value for the error message. putting the error_msg at the beginning,
> >> as you proposed would print: 
> >>
> >> [Hardware Error]:  on memory stick "DIMM_A1" (type: corrected socket:0 mc:0 channel:0 slot:0 )
> > 
> > that's fine since we know the tracepoint purpose:
> > 
> >  "mc_error:  on memory stick "DIMM_A1" (type: corrected socket:0 mc:0 channel:0 slot:0)"
> > 
> > is pretty clear to me, IMHO.
> 
> yes, but: 
> 	mc_event:  on memory stick "DIMM_A1" (type: corrected socket:0 mc:0 channel:0 slot:0)
> 
> is not clear if this is either an error or something else.

Ok, I'd say we call it "mc_error" and i5100's two messages about spare
copying simply lose. We're reporting predominantly errors here anyway.

> >>> * count is gone
> >>
> >> While count is not properly addressed, I'll keep it on sb_edac/i7core_edac.
> >>
> >> The right thing here seems to move it to a core property and increment the error counters
> >> according with the error count.
> > 
> > Incrementing the error counters shouldn't have anything to do with the
> > error reporting.
> 
> Why?

Because incrementing error counters and reporting errors should be two
different things.

> >>> * MC-drivers shouldn't say "error" when reporting an error
> >>> * UE/CE moves into the brackets
> >>
> >> It seems that both Tony and me agrees that UE/CE/Fatal should be outside the brackets.
> > 
> > Why?
> 
> Also already discussed dozens of time: this is the error severity. The way users handle
> UE errors are different than the way they handle CE, e. g. CE errors are "tolerable". 
> UE errors might not be.

And why does that warrant having the error type in the beginning of the
message? I can still read it if it is in the brackets a couple of chars
later on.

> >>> * socket moves earlier in the brackets, and keep the whole deal hierarchical.
> >>
> >> Socket doesn't bring a very relevant information. It provides the CPU socket with the core that
> >> were running the code when an error was generated, not the CPU that were managing the memory.
> > 
> > Then drop it if it's not relevant.
> 
> Because irrelevant != "not very relevant".
> 
> I might eventually drop it on some latter cleanups on sb_edac driver.

You still don't give me a valid, technical reason to keep it.

And yes, it _IS_ black or white: the socket either tells you a valuable
piece of information which you need for handling the error after
reporting it, or not, is useless, and no one needs to have it in the
error log.

It is that simple.

> 
> >>> * drop "err_code" what is that?
> >>
> >> In this case:
> >> 	u32 errcode = GET_BITFIELD(m->status, 0, 15);
> > 
> > Either decode it like I do in amd_decode_err_code() or remove it
> > completely - no naked bit values.
> 
> It is decoded, but providing it might help with debugging.

I only see naked bit values, where is it decoded? It should be properly
decoded in the final error message that the user gets to see.

> >>> * drop second "socket"
> >>> * drop "area" Area "DRAM" - are there other?
> >>
> >> Yes. there are 4 types of area at sb_edac.
> > 
> > And they are?
> 
> See the driver:
> 
> static char *get_dram_attr(u32 reg)
> {
> 	switch(DRAM_ATTR(reg)) {
> 		case 0:
> 			return "DRAM";
> 		case 1:
> 			return "MMCFG";
> 		case 2:
> 			return "NXM";
> 		default:
> 			return "unknown";
> 	}

You mean 3 - "unknown" is not a memory region.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
