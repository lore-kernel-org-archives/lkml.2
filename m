Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2BVMCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:02:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab2BVMCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:02:46 -0500
Message-ID: <4F44D948.3000205@redhat.com>
Date: Wed, 22 Feb 2012 10:02:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RAS trace event proto
References: <20120220145920.GB5728@aftab> <4F438CE9.7080807@redhat.com> <20120221141231.GA15515@aftab> <1329835698.25686.60.camel@gandalf.stny.rr.com> <20120221145943.GB15515@aftab> <3908561D78D1C84285E8C5FCA982C28F03DA60@ORSMSX104.amr.corp.intel.com> <20120222104324.GA26845@aftab>
In-Reply-To: <20120222104324.GA26845@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 22-02-2012 08:43, Borislav Petkov escreveu:
> On Wed, Feb 22, 2012 at 12:58:37AM +0000, Luck, Tony wrote:
>> I'm also struggling to understand an end-user use case where you would
>> want filtering.  Mauro - can you expand a bit on why someone would just
>> want to see the errors from memory controller 1?
>>
>> My mental model of the world is that large systems have some background
>> noise - a trickle of corrected errors that happen in normal operation.
>> User shouldn't care about these errors unless they breach some threshold.
>>
>> When something goes wrong, you may see a storm of corrected errors, or
>> some uncorrected errors. In either case you'd like to get as much information
>> as possible to identify the component that is at fault. I'd definitely like
>> to see some structure to the error reporting, so that mining for data patterns
>> in a storm isn't hideously platform dependent.
> 
> Yep, I'm on the same page here.

The error counters will be incremented at the sysfs even if the events are
filtered. A RAS software could start with the tracing disabled, and only
enable the events as a hole or partially if the errors are above a certain 
limit (or rate limit).

>> It might be easier to evaluate the competing ideas here with some sample
>> output in addition to the code.
> 
> Well, to clarify:
> 
> When you get a decoded error, you get the same format as what you get in
> dmesg, for example:
> 
> [ 2666.646070] [Hardware Error]: CPU:64   MC1_STATUS[-|CE|MiscV|PCC|-|CECC]: 0x9a05c00007010011
> [ 2666.655003] [Hardware Error]: Instruction Cache Error: L1 TLB multimatch.
> [ 2666.655008] [Hardware Error]: cache level: L1, tx: INSN
> 
> And with the decoded string tracepoint, that thing above is a single
> string. If you use trace_mce_record(), you still can get the single
> MCE fields which we carry to userspace from struct mce, _in addition_.

Using the same concept I've adopted for my EDAC patches, I would map the 
above into 3 fields:

	CPU instance = 64
	error message = Instruction Cache Error: L1 TLB multimatch.
	detail = cache level: L1, tx: INSN
	(or, maybe, detail = [-|CE|MiscV|PCC|-|CECC] cache level: L1, tx: INSN)

Those fields contain what userspace needs, and it is easy for it to parse,
as different things are on different places.

> The hypothetical problem is for userspace not being able to use the
> tracepoint format to parse reported fields easily and in an unambiguous
> manner. Instead, it gets a single string which, I admit, is not that
> pretty.

Yes.

> Now, the problem is if we want to use a single tracepoint for all errors
> - it is unfeasible that any fields sharing can be done there except
> maybe the TSC stamp when it happened, the CPU that caught it and etc.
> not so important details.

Well, in this example, 3 fields could be very similar to the ones I used
for the memory errors.

"silkscreen label" may make some sense, in order to convert from
a CPU core and from some logical CPU number into the right CPU socket.

Other fields, like "location" wouldn't make much sense (as location in this
case matches the CPU number), but those could simply be filled with a blank 
string.

I don't see any problem on having some fields that would be filled with a
blank string (or that it would contain a value like -1 - in the case of
integers - to mean that such value is not relevant for that error type).

> IOW, the error format is different for each error type, almost, and
> there's no marrying between them. OTOH, ff we start adding tracepoints
> for each error type, we'll hit the other end - bloat. So also a no-no.

Indeed, one tracepoint per error type is a bad idea.

> Maybe the compromise would be to define a single tracepoint per
> _hardware_ error reporting scheme. That is, MCA has an own tracepoint,
> PCIE AER has its own error reporting tracepoint, then there's an EDAC
> !x86 one which doesn't use MCA for reporting and also any other scheme a
> hw vendor would come up with...
 
> This will keep the bloat level to a minimum, keep the TPs apart and
> hopefully make all of us happy :).

That sounds interesting.

There is also another alternative: one tracepoint per HW block (where
HW block in this context is: memory, cpu, PCI, ...).

I think we should start with one tracepoint per hw reporting scheme, and
see how it fits, using the parameters I found it is common denominator
for the memory errors.  

Regards,
Mauro
