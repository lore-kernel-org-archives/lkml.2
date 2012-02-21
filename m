Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2BUTL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:11:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819Ab2BUTLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:11:24 -0500
Message-ID: <4F43D44C.4020903@redhat.com>
Date: Tue, 21 Feb 2012 15:28:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Tony Luck <tony.luck@intel.com>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RAS trace event proto
References: <20120220145920.GB5728@aftab> <4F438CE9.7080807@redhat.com> <20120221141231.GA15515@aftab>
In-Reply-To: <20120221141231.GA15515@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 21-02-2012 12:12, Borislav Petkov escreveu:
> On Tue, Feb 21, 2012 at 10:24:09AM -0200, Mauro Carvalho Chehab wrote:
>> The idea of having a separate ring buffer for the hardware errors seem
> 
> Not a separate ring buffer - ras_printk buffers the string before its
> being sent through the tracepoint, i.e. once the string is done, we do:
> 
> 	trace_mce_record(decoded_err_str, m);
> in amd_decode_mce(). The tracepoint can be invoked in the same manner
> from other places.

Ah, ok. I missed this call for trace_mce_record() on my first review.

The ras.c seems to be a way to help your amd64 mce parser. After reviewing
how errors are output on the other drivers, I don't think that these
routines would help the other drivers, as, on all other places, there is
a driver buffer that does the same.

Also, it doesn't sound a good idea to have this hunk:

--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -701,7 +703,11 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 		return;
 	}
 
-	if (edac_mc_get_log_ce())
+	if (edac_mc_get_log_ce()) {
+		if (ras_agent)
+			ras_printk(PR_CONT, "row: %d, channel: %d\n",
+				   row, channel);
+
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
 			"CE page 0x%lx, offset 0x%lx, grain %d, syndrome "

The routine that handles the error should be generating the trace, and not
filling a buffer for the trace to happen on some other place.

>> to be interesting (the code there at ras.c seems incomplete on this dirty
>> patch - at least I couldn't see how userspace would retrieve the messages,
>> if the has agent is enabled).
> 
> The normal way you retrieve an ftrace trace.
> 
>> I prefer to code it arch-agnostic since the beginning, as there's nothing
>> there that it is arch-specific.
> 
> Let me quote my last email:
> 
> "* Which brings me to it: ras_printk() is x86-only and it could probably
> be moved to an arch-agnostic place for the other arches. I'd leave it
> x86-only for now, for testing purposes, and then later the other arches
> could consider using it (this is wrt non-x86 EDAC drivers)."

The ras_printk() seems to be mce_amd only.

>> It is not clear from this patch how errors are supposed to be reported,
>> on your proposal, as, currently, you're using trace_mce_record() to report 
>> just the MCE error, without any parsing,  using an empty string for the
>> error description.
> 
> Let me quote my last email:
> 
> "* So there are two RAS tracepoints: trace_mce_record which dumps the
> MCE-related errors + their decoded info and trace_hw_error which simply
> carries a string to userspace. The second one can be used for non-MCA
> errors."
> 
>> I _think_ you're planning to move trace_mce_record() to happen inside
>> the driver (or at the edac core), for the cases where the error is
>> parsed inside amd64_edac.
> 
> No.

The main purpose of edac_mc_handle_ce() & friends is to report the
error to userspace and increment the error counters. Not having the trace
call there is a failure on doing that.

> 
>> You're using ras_printk() to report not only RAS errors, but also errors
>> that happened inside the amd64_edac driver, like:
> 
> Not the amd64_edac driver - this is the routine that decodes LS MCEs.

Ok.

> 
>>
>> +		ras_printk(PR_EMERG, "You shouldn't be seeing an LS MCE on this"
>> +				     " cpu family, please report on LKML.\n");
>>
>> That sounds confusing.
> 
> No, that's ok since we're carrying a string of a decoded MCE to
> userspace - if, instead, we have _another_ string saying that we don't
> decode LS MCEs for a CPU family, it's still a string so we're fine. We
> could do additional mappings like "DECODE_ERROR" in front of it so that
> the userspace tools don't choke on it.
> 
>> It also should be noticed that the amd64_edac driver reports error on a
>> different way than other drivers. Except for amd64_edac, the other drivers
>> prepare an error string on some internal buffer, and then they call the
>> RAS core (edac) to present that error to userspace. For example:
> 
> This is what I do too - ras_printk() buffers the string internally
> before sendint it out through the tracepoint.

So, it is your way to implement an amd64_edac/mce_amd string buffer.
I don't see any value of changing the other drivers to do it, as, on
all other drivers, a simple char * buffer would produce the same result.

<snip/>

>>>  TRACE_EVENT(mce_record,
>>>  
>>> -	TP_PROTO(struct mce *m),
>>> +	TP_PROTO(const char *msg, struct mce *m),
>>
>> That doesn't sound good on my eyes. It is basically preserving all MCE register
>> values as-is (u32/u64 values), and folding all parsed information into just
>> one string field. I fail to understand why it is more important to store in
>> binary format the content of MCE registers than the other datat here.
> 
> The msg arg is the decoded string and not the MCE register values. We
> carry the register values to userspace just in case, say, a RAS daemon
> would like to look at them too. This makes sense in cases where a RAS
> daemon, for example, wants to count how many errors have happened per
> rank and at which address, etc...

The rank information may not be there! On Sandy Bridge, the rank is the
result of a complex decoding logic that _doesn't_ use the MCE registers.
In a matter of fact, the only thing that it is provided at the MCE registers
on Sandy Bridge is the address and the error type. All the other information
is parsed by using non-MCE registers: memory controller, channel, rank, dimm.
So, exporting struct mce to userspace doesn't help a RAS daemon for Sandy
Bridge.

On the other hand, the "location" field on my proposal will always have
the error location (csrow/dimm or branch/channel/slot, depending on the
memory architecture). This makes much more sense to have there than the
raw MCE register values.

On the other hand, on Nehalem, the MCE registers contains the memory location.
So, a RAS daemon could use them, or could equally use the location field.

<snip/>
> 
>> It also requires that a RAS software to parse the messages in order to
>> detect, for example, where the memory silkscreen label is inside it.
>> This can be very tricky, as each driver could fill it with a different
>> way, making very hard for RAS userspace developers to write a code
>> that would be generic.
> 
> We can add an additional arg called char *silkscreen in case it is
> needed.

It is not just the silkscreen label. See my patch series, if you want to
see the dirty details on all drivers, or try to convert the other drivers
to use your proposal, and you'll see what I'm talking about.

>> My proposal is to have more fields there than just one message. On my patches,
>> the proposal is to use, instead:
>>
>> TRACE_EVENT(mc_error_mce,
>>
>> 	TP_PROTO(const unsigned int err_type,
>> 		 const unsigned int mc_index,
>> 		 const char *msg,
>> 		 const char *label,
>> 		 const char *location,
>> 		 const char *detail,
>> 		 const char *driver_detail,
>> 		 const struct mce *m),
> 
> Hehe, so basically instead of one string you have a bunch of strings in
> addition to some unneeded fields. I fail to see the difference.

Some of them could be, instead, integers or some other way to represent
the error details. For example, the location could be, instead:

	u32 layer0_pos, u32 layer1_pos, u32 layer2_pos

to represent the memory location (csrow/channel, branch/channel/slot or
channel/slot, depending on how the location is defined on the memory
hierarchy.

The bad thing of using this way is that, when just 2 layers are filled,
layer2_pos will be meaningless.

The detail could be, instead:
	u32 page, u32 offset, u32 grain, u32 syndrome
or even:
	u64 address, u32 grain, u32 syndrome

The other fields are, per their nature, strings (error message, DIMM label,
extra driver-specific details).

I'm not entirely convinced to use strings there. Comments are welcome.

> The greatest common denominator between hw errors is a single string
> containing the whole error message, that's it!

If you use this argument, the MCE fields should also be converted to
string, as less than 10% of the existing drivers have it.

> The moment you start
> implementing an arch-agnostic solution, a single string is all you can
> use. And adding a tracepoint for each error type is a no-go too, as I've
> explained it to you already.

This trace can easily be generalized to cover any type of error, like:

	TP_PROTO(const unsigned int error_severity,
		 const unsigned int error_type,
		 const unsigned int instance,
		 const char *error_msg,
		 const char *silkscreen_label,
		 const char *location,
		 const char *detail,
		 const char *driver_detail,
 		 const struct mce *m),

as there's nothing there that it is really memory specific:

	- error_severity: corrected, uncorrected, fatal, ...;
	- error_type: memory error, PCI error, bus error, ...;
	- instance: an instance number to uniquelly identify the affected resource;
	- silkscreen_label: can be a memory slot, a bus slot, a cpu slot, ...,
			    depending on the error type;
	- location: "csrow 1 channel 0" for MC; "07:05.0" for PCI, 
		    "Bus 003 Device 001" for USB, ...
	- detail: some additional error_type-specific detail handled by the core;
	- driver_detail: some additional error_type-specific detail handled by the driver.

By having several fields, RAS software can group errors by location, by label, etc.

> 
>> Where:
>>
>> 	err_type - identifies if the error is corrected, uncorrected, fatal;
>> 	mc_index - identifies the memory controller instance;
>> 	msg - the error cause, like "read error" , "write error", etc;
>> 	label - The silkscreen label of the affected component(s);
>> 	location - the memory hierarchy location of the error (csrow/channel or
>> 		   branch/channel/dimm, depending on the memory hierarchy);
>> 	detail - contains the error page, offset, grain and syndrome.
>> 	driver_detail - contains additional driver-specific details about
>> 		 the error (other data that the driver error parser may get).
>> 			    
>> With the above, all possible usecases are covered. The normal usecase
> 
> As I've already explained it to you multiple times, this does NOT cover
> all possible cases - this covers only DRAM errors and adds unnecessarily
> too much info. If you start adding tracepoints for all the other error
> types hw can report, you're going to enter Bloatland very quickly.

I fail to see it. Most cases will fail on the above trace.

>> where the user just needs to know if there were memory corruption, and what
>> memory needs to be replaced is covered by "err_type", "msg" and "label".
> 

Regards,
Mauro
