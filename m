Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab2BUOMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:12:44 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:33154 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2BUOMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:12:43 -0500
Date: Tue, 21 Feb 2012 15:12:31 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@intel.com>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RAS trace event proto
Message-ID: <20120221141231.GA15515@aftab>
References: <20120220145920.GB5728@aftab>
 <4F438CE9.7080807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F438CE9.7080807@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 10:24:09AM -0200, Mauro Carvalho Chehab wrote:
> The idea of having a separate ring buffer for the hardware errors seem

Not a separate ring buffer - ras_printk buffers the string before its
being sent through the tracepoint, i.e. once the string is done, we do:

	trace_mce_record(decoded_err_str, m);

in amd_decode_mce(). The tracepoint can be invoked in the same manner
from other places.

> to be interesting (the code there at ras.c seems incomplete on this dirty
> patch - at least I couldn't see how userspace would retrieve the messages,
> if the has agent is enabled).

The normal way you retrieve an ftrace trace.

> I prefer to code it arch-agnostic since the beginning, as there's nothing
> there that it is arch-specific.

Let me quote my last email:

"* Which brings me to it: ras_printk() is x86-only and it could probably
be moved to an arch-agnostic place for the other arches. I'd leave it
x86-only for now, for testing purposes, and then later the other arches
could consider using it (this is wrt non-x86 EDAC drivers)."

> It is not clear from this patch how errors are supposed to be reported,
> on your proposal, as, currently, you're using trace_mce_record() to report 
> just the MCE error, without any parsing,  using an empty string for the
> error description.

Let me quote my last email:

"* So there are two RAS tracepoints: trace_mce_record which dumps the
MCE-related errors + their decoded info and trace_hw_error which simply
carries a string to userspace. The second one can be used for non-MCA
errors."

> I _think_ you're planning to move trace_mce_record() to happen inside
> the driver (or at the edac core), for the cases where the error is
> parsed inside amd64_edac.

No.

> You're using ras_printk() to report not only RAS errors, but also errors
> that happened inside the amd64_edac driver, like:

Not the amd64_edac driver - this is the routine that decodes LS MCEs.

> 
> +		ras_printk(PR_EMERG, "You shouldn't be seeing an LS MCE on this"
> +				     " cpu family, please report on LKML.\n");
> 
> That sounds confusing.

No, that's ok since we're carrying a string of a decoded MCE to
userspace - if, instead, we have _another_ string saying that we don't
decode LS MCEs for a CPU family, it's still a string so we're fine. We
could do additional mappings like "DECODE_ERROR" in front of it so that
the userspace tools don't choke on it.

> It also should be noticed that the amd64_edac driver reports error on a
> different way than other drivers. Except for amd64_edac, the other drivers
> prepare an error string on some internal buffer, and then they call the
> RAS core (edac) to present that error to userspace. For example:

This is what I do too - ras_printk() buffers the string internally
before sendint it out through the tracepoint.

> 
> static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
> 					struct i5000_error_info *info,
> 					int handle_errors)
> {
> ...
> /* Only 1 bit will be on */
> 	switch (allErrors) {
> 	case FERR_FAT_M1ERR:
> 		specific = "Alert on non-redundant retry or fast "
> 				"reset timeout";
> 		break;
> ...
> 		/* Form out message */
> 		snprintf(msg, sizeof(msg),
> 			 "(Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d "
> 			 "CAS=%d, UE Err=0x%x (%s))",
> 			 branch >> 1, bank, rdwr ? "Write" : "Read", ras, cas,
> 			 ue_errors, specific);
> 
> 		/* Call the helper to output message */
> 		edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);
> 
> 
> So, the "msg" buffer will contain the entire error message, and the core call
> will increment the error counters, will identify the silkscreen label associated
> with the memory location and output the error.
> 
> In the case of amd64_edac, the error message is generated using KERN_COUNT, e. g.
> instead of storing it into some buffer and then doing just one call to output it,
> it calls pr_count() several times (or, after your patch, ras_printk).

I think you're confusing amd64_edac with <drivers/edac/mce_amd.c> which
contains the code that decodes _ALL_ MCEs and not only DRAM ECC errors
which amd64_edac decodes.

> 
> As the idea is to generate just one event for one hardware error, the better is
> to change the logic inside amd64_edac to use driver-specific buffer for the
> error message, and then call the RAS core error handler to output it, and let
> the core to generate the trace event, as this simplifies the logic on all
> drivers, as it removes redundancy, as reporting an error requires several
> operations, like:
> 	- incrementing error counts;
> 	- retrieving the motherboard silkscreen labels;
> 	- printing the error at dmesg and/or generating a trace event.

This is what the code does already.

> 
> <snip/>
> 
> >  TRACE_EVENT(mce_record,
> >  
> > -	TP_PROTO(struct mce *m),
> > +	TP_PROTO(const char *msg, struct mce *m),
> 
> That doesn't sound good on my eyes. It is basically preserving all MCE register
> values as-is (u32/u64 values), and folding all parsed information into just
> one string field. I fail to understand why it is more important to store in
> binary format the content of MCE registers than the other datat here.

The msg arg is the decoded string and not the MCE register values. We
carry the register values to userspace just in case, say, a RAS daemon
would like to look at them too. This makes sense in cases where a RAS
daemon, for example, wants to count how many errors have happened per
rank and at which address, etc...

> Also, folding everything into just one string prevents (or make hard) the usage of
> the perf filters, for example, to filter only the errors at the memory controller 1.

Huh, because you can't grep through the trace anymore...?

> It also requires that a RAS software to parse the messages in order to
> detect, for example, where the memory silkscreen label is inside it.
> This can be very tricky, as each driver could fill it with a different
> way, making very hard for RAS userspace developers to write a code
> that would be generic.

We can add an additional arg called char *silkscreen in case it is
needed.

> My proposal is to have more fields there than just one message. On my patches,
> the proposal is to use, instead:
> 
> TRACE_EVENT(mc_error_mce,
> 
> 	TP_PROTO(const unsigned int err_type,
> 		 const unsigned int mc_index,
> 		 const char *msg,
> 		 const char *label,
> 		 const char *location,
> 		 const char *detail,
> 		 const char *driver_detail,
> 		 const struct mce *m),

Hehe, so basically instead of one string you have a bunch of strings in
addition to some unneeded fields. I fail to see the difference.

The greatest common denominator between hw errors is a single string
containing the whole error message, that's it! The moment you start
implementing an arch-agnostic solution, a single string is all you can
use. And adding a tracepoint for each error type is a no-go too, as I've
explained it to you already.

> Where:
> 
> 	err_type - identifies if the error is corrected, uncorrected, fatal;
> 	mc_index - identifies the memory controller instance;
> 	msg - the error cause, like "read error" , "write error", etc;
> 	label - The silkscreen label of the affected component(s);
> 	location - the memory hierarchy location of the error (csrow/channel or
> 		   branch/channel/dimm, depending on the memory hierarchy);
> 	detail - contains the error page, offset, grain and syndrome.
> 	driver_detail - contains additional driver-specific details about
> 		 the error (other data that the driver error parser may get).
> 			    
> With the above, all possible usecases are covered. The normal usecase

As I've already explained it to you multiple times, this does NOT cover
all possible cases - this covers only DRAM errors and adds unnecessarily
too much info. If you start adding tracepoints for all the other error
types hw can report, you're going to enter Bloatland very quickly.

> where the user just needs to know if there were memory corruption, and what
> memory needs to be replaced is covered by "err_type", "msg" and "label".

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
