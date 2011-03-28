Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1C1RDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:03:20 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57736 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1C1RDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:03:18 -0400
Date: Mon, 28 Mar 2011 19:03:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Borislav Petkov <bp@alien8.de>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly
 Report Mechanism (HARM)
Message-ID: <20110328170302.GF11590@aftab>
References: <cover.1300996141.git.mchehab@redhat.com>
 <20110324173257.36680b90@pedra>
 <20110324223907.GA10498@liondog.tnic>
 <4D8C6C80.8010600@redhat.com>
 <20110325141322.GB28313@gere.osrc.amd.com>
 <4D8D078C.1040201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8D078C.1040201@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 05:22:20PM -0400, Mauro Carvalho Chehab wrote:

[..]

> >> *) Report errors against human readable labels (e.g. using motherboard
> >>    labels to identify DIMM or PCI slots).  This is hard (will often need
> >>    some platform-specific mapping table to provide, or override, detailed
> >>    information).
> > 
> > That doesn't have anything to do with the hw event - a DRAM CE/UE error
> > is a MCE with certain bits set. You can have an additional field in the
> > MCE TP:
> > 
> > 		__field(	const char *,	label			)
> 
> Assuming an architecture with MCE, I think it should provide a little more than just
> the label: it should also provide the parsed information about the event.
> In other words, I think that such error should have those two extra fields:
> 
>  		__field(	const char *,	msg			)
>  		__field(	const char *,	label			)
> 
> where msg is a brief description about what type of error happened, extracted
> from MCE log.

Yep, either 'msg' or 'desc' or so which is the decoded error string. One
has to be careful when building the whole string but yes, this should
do.

[..]

> >> *) Useful to make it easy to adapt existing EDAC drivers, machine-check
> >>    bank decoders and other existing error reporters to use this new
> >>    mechanism.
> >>
> >> *) Robust - should not lose error information.  If the platform provides
> >>    some sort of persistent storage, should make use of it to preserve
> >>    details for fatal errors across reboot.  But may need some threshold
> >>    mechanism that copes with floods of errors from a failed object.
> > 
> > This can be done in userspace - a logging daemon which flushes the trace
> > buffers so that there's more room for new errors.
> 
> Yes, but it helps to have support for it on Kernel and hardware, in order to
> avoid loose events that may happen before the daemon starts.

Well, last time I checked there's only a small window between enabling
MCA on the machine and initializing perf buffers so we can use the
buffer in mce.c for temporary storage. Once perf initializes and
persistent MCE events get enabled, we copy the mce.c buffer into the
persistent MCE's buffer and done.

When the persistent storage or perf kernel buffers overflow and there's no
userspace consumer, we simply overwrite the oldest events - nothing much
we can do there.

[..]

> >> People at the audience also commented that there are some other parts of the
> >> Kernel that produce hardware errors and may also be interesting to map them
> >> via perf, so grouping them together into just two types may not fit.
> >>
> >> Also, as we want to have errors generated even for uncorrected errors that
> >> can be fatal, and the report system should provide user-friendly error
> >> reports, just printing a MCE code (and the MCE-specific data) is not enough:
> >> the error should be parsed on kernel to avoid loosing fatal errors.
> > 
> > This is already the case on AMD - we decode those. 
> 
> Yes, and that's great. The i7core_edac driver also does that, but only for a 
> subset of the existing errors and CPU's.
> 
> I think that moving the call to the tracepoint function on MCE to happen after
> the AMD decode routine (for AMD), and adding a similar logic for Intel will
> be the proper way to provide useful info to the system admin.

Yes.

You might want to split the decoding functionality out from i7core_edac
since the last deals with DRAM ECC errors only AFAICT and the first
deals with MCE errors in general.

> > However, there's
> > another issue with fatal errors - you want to execute as less code as
> > possible in the wake of a fatal error.
> 
> Yes. That's one of the reasons why it may make sense to have a separate event
> for fatal errors.

No, you don't need a different tracepoint for that. The most
conservative approach when you cannot recover from such an error is to
save raw error info to pstore and die, as Tony says in the other mail.
You decode it _after_ you've rebooted the machine. However, we still
haven't addressed clients with no pstore with such a strategy.

I don't know whether relaxing the approach and running into the decoding
code is still fine with all fatal errors, maybe that needs to be decided
on a case-by-case basis and since this probably will also be family- and
arch-specific, the whole decision code might get very hairy, very fast.

And yes, deferred errors should get decoded and reported - I think the
poisoning code should handle them just fine. But back to the issue, no
need for different TPs on x86 - one is just fine.

[..]

> > However, we still don't have a solution for clients like laptops
> > and desktops with no RAS features. We need to think about those too,
> > especially for debugging kernel oopses, suspend/resume, etc.
> 
> It would be good to use some non-volatile ram for these. I was told that
> APEI spec defines a way for that, but I'm not sure if low end machines would
> be shipped with that.

This is only ACPI 4.0 spec - you still need the hw device that
actually acts as a non-volatile storage. And if we don't have that
physically present, we can't save to pstore - we need a different
approach but I don't have the slightest idea what to do. The BIOS idea
(http://www.spinics.net/lists/linux-ide/msg40038.html) was neat in
theory, but it kinda sucked when trying to keep it generic enough and
working with all storage controllers.

> >> Maybe the way I mapped is too fine-grained, and we may want to group some
> >> events together, but, on the other hand, having more events allow users
> >> to filter some events that may not be relevant to them. For example, some
> >> systems with i7300 memory controller, under certain circumstances (it seems
> >> to be related to a bug at BIOS quick boot implementation), don't properly 
> >> initialize the memory controller registers. The net result is that, on every 
> >> one second (the poll interval of the edac driver), a false error report is 
> >> produced. Having events fine-grained, users can just change the perf filter 
> >> to discard the false alarms, but keeping the other hardware errors enabled.
> >>  
> >> In the specific case of MCE errors, I think we should create a new
> >> hw_event pair that will provide the decoded info and the raw MCE info, on
> >> a format like:
> >>
> >> 	Corrected Error %s at label "%s" (CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: % x)
> >> 	Uncorrected Error %s at label "%s" (CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: % x)

Again, this is the same information (all MCE fields are the same) except
CE/UE bit in MCi_STATUS. You don't need this differentiation because:

a) either we're fatal and we don't decode, or

b) we're deferred/correctable and we then decode but the decoding code
says what kind of error it is by looking at MCi_STATUS.

IOW, the tracepoint carries the raw info only and the decoding code adds
the proper error type in the const char *msg field.

> > 
> > Why like this? This is the same tracepoint with almost all fields
> > repeated except a small difference which can be expressed with a single
> > bit: Corrected vs Uncorrected error.
> 
> It might be mapped as a bit, like:
> 
>  		__field(	bool,	is_uncorrected			)
> 
> and the printk might do something like:
> 
> 	"%s ...",
> 	(is_uncorrected ? " Uncorrected" : "Corrected" )
> 
> However, this would prevent the capability of filtering just the UE events.
> Also, we may eventually provide more information for the corrected case, as we may
> execute more code on that situation.

Filtering can be done in userspace too. At least on those UCs which still keep
the machine alive.

[..]

> >> This way, the info that it is relevant to the system admin is clearly pointed
> >> (error type and label), while hardware vendors may use the MCE data to better
> >> analyse the issue.
> > 
> > So it all sounds like we need simply to expand the MCE tracepoint with
> > DIMM-related information and wrap it in an arch-agnostic macro in the
> > EDAC code. Other arches will hide their error sources behind it too
> > depending on how they read those errors from the hardware.
> 
> It seems so. By purpose, I decided to take the approach of touching first the
> EDAC arch-agnostic events. With those mapped, it is easier to compare them with
> the MCE traces and adjust both trace calls to get the best of the both words.
> 
> I think that, in the specific case of i7core_edac and amd64_edac, what we need
> is to add a function at the EDAC core that will translate a MCE event into
> a memory label, and call it from the arch-dependent code (so, inside the mce driver).
> 
> Alternatively, edac could fill a translation table, and the decoding code at
> mce would be just a table retrieve routine (in order to speed-up translation,
> in the case of fatal errors.

I'm afraid I don't understand this one completely. Remember that with
MCEs, you don't always have a memory label - MCEs report all kinds of
errors in the CPU core and not only DRAM errors.

Concerning the translation table, I thought about this too but this
might become too big too fast since you have a different set of MCE
signatures per family and, at the same time, families share some of the
MCE error signatures and with tables it might be hard/ugly to share
code. I think I'll worry about this only if MCE decoding becomes very
expensive - I haven't traced how long it takes but it should be too
small a time to measure since we don't do any special stuff except array
lookups and bit fiddling.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
