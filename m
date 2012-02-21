Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2BUMYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 07:24:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab2BUMYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:24:34 -0500
Message-ID: <4F438CE9.7080807@redhat.com>
Date: Tue, 21 Feb 2012 10:24:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Tony Luck <tony.luck@intel.com>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RAS trace event proto
References: <20120220145920.GB5728@aftab>
In-Reply-To: <20120220145920.GB5728@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 20-02-2012 12:59, Borislav Petkov escreveu:
> Hi all,
> 
> here's a dirty patch which should hopefully show what I have in mind wrt
> using tracepoints for RAS events. The code compiles and should only give
> an initial idea, it is subject to significant changes until it reaches
> its final form thus it is only exemplary and not final in any case.
> 
> Notes:
> 
> * So there are two RAS tracepoints: trace_mce_record which dumps the
> MCE-related errors + their decoded info and trace_hw_error which simply
> carries a string to userspace. The second one can be used for non-MCA
> errors.
> 
> * When prepping the string for the tracepoint, we cache the string by
> calling ras_printk which buffers the so-far done string internally,
> so everything that wants to dump into it needs to be converted to use
> ras_printk.
> 
> * Which brings me to it: ras_printk() is x86-only and it could probably
> be moved to an arch-agnostic place for the other arches. I'd leave it
> x86-only for now, for testing purposes, and then later the other arches
> could consider using it (this is wrt non-x86 EDAC drivers).
> 
> * When writing a 1 into /sys/devices/system/ras/agent, we enable the
> string buffering functionality - this could be done by the RAS daemon or
> whatever agent is requesting putting hw errors info into tracing.
> 
> * I'd like to have conditional printk-ing in trace_mce_record depending
> on the TP args, Steve probably knows what can be done:
> 
> @Steven:
> 
> I'd like to do the following:
> 
> 	TP_printk("%s, ARG1: %d, ARG2: %c ...", str1, arg1, arg2)
> 
> and have it print only the first arg, i.e. the string and drop the rest
> of the args while still doing the TP_fast_assign into the ring buffer
> and carrying the stuff to its consumers. Background is that I want to
> dump the decoded string of a hardware error, if it is decoded, but carry
> the MCE info to userspace and only dump the fields of the MCE if I
> haven't managed to decode it, i.e. str1 == "".
> 
> So, my question is, can I do something like:
> 
> 	TP_printk("%s, ARG1: %d, ARG2: %c ...", __print_conditional(str1, arg1, arg2))
> 
> where __print_conditional is a vararg macro which calls a
> ftrace_print_cond() which prints only str1 if strlen(str1) > 0 and
> otherwise calls a vsnprintf() variant to deal with the va_args?
> 
> As always, all comments are welcome.

Boris,

The idea of having a separate ring buffer for the hardware errors seem
to be interesting (the code there at ras.c seems incomplete on this dirty
patch - at least I couldn't see how userspace would retrieve the messages,
if the has agent is enabled).

I prefer to code it arch-agnostic since the beginning, as there's nothing
there that it is arch-specific.

It is not clear from this patch how errors are supposed to be reported,
on your proposal, as, currently, you're using trace_mce_record() to report 
just the MCE error, without any parsing,  using an empty string for the
error description.

I _think_ you're planning to move trace_mce_record() to happen inside the
driver (or at the edac core), for the cases where the error is parsed 
inside amd64_edac.

You're using ras_printk() to report not only RAS errors, but also errors
that happened inside the amd64_edac driver, like:

+		ras_printk(PR_EMERG, "You shouldn't be seeing an LS MCE on this"
+				     " cpu family, please report on LKML.\n");

That sounds confusing.

It also should be noticed that the amd64_edac driver reports error on a
different way than other drivers. Except for amd64_edac, the other drivers
prepare an error string on some internal buffer, and then they call the
RAS core (edac) to present that error to userspace. For example:

static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
					struct i5000_error_info *info,
					int handle_errors)
{
...
/* Only 1 bit will be on */
	switch (allErrors) {
	case FERR_FAT_M1ERR:
		specific = "Alert on non-redundant retry or fast "
				"reset timeout";
		break;
...
		/* Form out message */
		snprintf(msg, sizeof(msg),
			 "(Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d "
			 "CAS=%d, UE Err=0x%x (%s))",
			 branch >> 1, bank, rdwr ? "Write" : "Read", ras, cas,
			 ue_errors, specific);

		/* Call the helper to output message */
		edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);


So, the "msg" buffer will contain the entire error message, and the core call
will increment the error counters, will identify the silkscreen label associated
with the memory location and output the error.

In the case of amd64_edac, the error message is generated using KERN_COUNT, e. g.
instead of storing it into some buffer and then doing just one call to output it,
it calls pr_count() several times (or, after your patch, ras_printk).

As the idea is to generate just one event for one hardware error, the better is
to change the logic inside amd64_edac to use driver-specific buffer for the
error message, and then call the RAS core error handler to output it, and let
the core to generate the trace event, as this simplifies the logic on all
drivers, as it removes redundancy, as reporting an error requires several
operations, like:
	- incrementing error counts;
	- retrieving the motherboard silkscreen labels;
	- printing the error at dmesg and/or generating a trace event.

<snip/>

>  TRACE_EVENT(mce_record,
>  
> -	TP_PROTO(struct mce *m),
> +	TP_PROTO(const char *msg, struct mce *m),

That doesn't sound good on my eyes. It is basically preserving all MCE register
values as-is (u32/u64 values), and folding all parsed information into just
one string field. I fail to understand why it is more important to store in
binary format the content of MCE registers than the other datat here. 

Also, folding everything into just one string prevents (or make hard) the usage of
the perf filters, for example, to filter only the errors at the memory controller 1.

It also requires that a RAS software to parse the messages in order to detect, 
for example, where the memory silkscreen label is inside it. This can be very tricky, 
as each driver could fill it with a different way, making very hard for RAS userspace
developers to write a code that would be generic.

My proposal is to have more fields there than just one message. On my patches,
the proposal is to use, instead:

TRACE_EVENT(mc_error_mce,

	TP_PROTO(const unsigned int err_type,
		 const unsigned int mc_index,
		 const char *msg,
		 const char *label,
		 const char *location,
		 const char *detail,
		 const char *driver_detail,
		 const struct mce *m),

Where:

	err_type - identifies if the error is corrected, uncorrected, fatal;
	mc_index - identifies the memory controller instance;
	msg - the error cause, like "read error" , "write error", etc;
	label - The silkscreen label of the affected component(s);
	location - the memory hierarchy location of the error (csrow/channel or
		   branch/channel/dimm, depending on the memory hierarchy);
	detail - contains the error page, offset, grain and syndrome.
	driver_detail - contains additional driver-specific details about
		 the error (other data that the driver error parser may get).
			    
With the above, all possible usecases are covered. The normal usecase
where the user just needs to know if there were memory corruption, and what
memory needs to be replaced is covered by "err_type", "msg" and "label".

If more information is required, the other fields will provide him enough
detail to either replace the bad DRAM chip or to provide enough data for 
the user to discuss the issues with the hardware vendor.

Regards,
Mauro
