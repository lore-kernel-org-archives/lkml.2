Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030286Ab2EKSi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:38:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab2EKSiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:38:54 -0400
Message-ID: <4FAD5CAD.90508@redhat.com>
Date: Fri, 11 May 2012 15:38:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
References: <1336679788-4982-1-git-send-email-mchehab@redhat.com> <20120510204042.GA4598@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F192EC1A2@ORSMSX104.amr.corp.intel.com> <4FAC3C35.70101@redhat.com> <3908561D78D1C84285E8C5FCA982C28F192EC247@ORSMSX104.amr.corp.intel.com> <4FAC6FF8.3050608@redhat.com> <20120511102527.GI8913@aftab.osrc.amd.com> <4FAD081C.5000704@redhat.com> <20120511172430.GB17299@aftab.osrc.amd.com>
In-Reply-To: <20120511172430.GB17299@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 11-05-2012 14:24, Borislav Petkov escreveu:
> On Fri, May 11, 2012 at 09:37:48AM -0300, Mauro Carvalho Chehab wrote:
>>> HW_ERR is the "official" prefix used by the MCE code in the kernel.
>>> Maybe we can shorten it but it is needed to raise attention when staring
>>> at dmesg output.
>>>
>>> Now, since this tracepoint is not dmesg, we don't need it there at all
>>> since we know that trace_mc_error reports memory errors.
>>
>> IMO, we can get rid of it on trace, keeping it at dmesg.
>>
>>> "mc_error" is also not needed.
>>
>> Some name is required there. This parameter affects:
>> 	- the name of the tracepoint function;
>> 	- the TP_printk() output;
>> 	- the trace filter name.
>>
>> mc_event is probably a good name.
> 
> If this tracepoint is going to report memory errors and we drop HW_ERR,
> then I guess "mc_error" is the most fitting one because it says what the
> message is.

True. Yet, "mc_event" fits better, as some drivers can also report events
that aren't errors. So, calling it as "mc_error", as on my original patch
is actually wrong. For example, i5100 can report those types of events:

		"spare copy initiated", /* 20 */
		"spare copy completed", /* 21 */

Spare copy events don't fit into "errors". Other drivers can also report events
like passing some temperature thresholds that aren't really errors.

Eventually, we might need yet-another severity type for those types of events,
as they aren't Corrected/Uncorrected/Fatal errors, but just notify events.

>>>> The error count msg ("1 error(s)") could be replaced by "count:1".
>>>
>>> Is there even a possibility to report more than one error when invoking
>>> trace_mc_error once? If not, simply drop the count completely.
>>
>> Good point. It makes sense to add a count parameter to the error handling core, 
>> in order to handle "count". AFAIKT, the only two drivers that currently reports
>> error counts are sb_edac and i7core_edac.
> 
> What does that mean? You report multiple errors with one tracepoint
> invocation? How do you report error details then?

When a burst of errors happen at the same memory address (within a grain), a 
few memory controllers can merge them into a single report, providing an error
count and a overflow flag, if the burst is higher than the register size.

> If you only report single errors, error count will always be 1 so drop
> it.

No, it is not single errors. It is multiple errors at the same address/grain.

>> With regards to sb_edac, it also needs another logic to be handled by
>> the core: channel_mask. This is required to handle lockstep mode and
>> mirror mode.
> 
> What does "handle lockstep mode" mean and how is that important for me
> staring at the tracepoint output.

That were already explained dozens of time on the patch review threads:

The error check on lookstep mode is calculated over a 128 bits cacheline.
The memory controller sometimes is not able to distinguish if the error 
happened on the first channel or on the second channel.

So, either one (or the two) envolved DIMMs should be responsible for it.

> 
> [ … ]
> 
>>> Here's how it should look:
>>>
>>> kworker/u:6-201   [007] .N..   161.136624: [Hardware Error]: memory read on memory stick "DIMM_A1" (type: corrected socket:0 mc:0 channel:0 slot:0 rank:1 page:0x586b6e offset:0xa66 grain:32 syndrome:0x0 channel_mask:1)
>>
>> As already explained: the error_msg is not consistent among the drivers.
>>
>> So, "memory read on ..." will work fine on sb_edac/i7core_edac but it _won't_
>> work on other drivers.
>>
>> Changing this field on each driver requires deep knowledge of each memory
>> controller, and not all datasheets are publicly available. 
>>
>> For example, this is the code for Freescale MPC85xx EDAC driver:
>>
>> 	if (err_detect & DDR_EDE_SBE)
>> 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
>> 				     pfn, err_addr & ~PAGE_MASK, syndrome,
>> 				     row_index, 0, -1,
>> 				     mci->ctl_name, "", NULL);
>>
>> 	if (err_detect & DDR_EDE_MBE)
>> 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
>> 				     pfn, err_addr & ~PAGE_MASK, syndrome,
>> 				     row_index, 0, -1,
>> 				     mci->ctl_name, "", NULL);
>>
>> It uses a blank value for the error message. putting the error_msg at the beginning,
>> as you proposed would print: 
>>
>> [Hardware Error]:  on memory stick "DIMM_A1" (type: corrected socket:0 mc:0 channel:0 slot:0 )
> 
> that's fine since we know the tracepoint purpose:
> 
>  "mc_error:  on memory stick "DIMM_A1" (type: corrected socket:0 mc:0 channel:0 slot:0)"
> 
> is pretty clear to me, IMHO.

yes, but: 
	mc_event:  on memory stick "DIMM_A1" (type: corrected socket:0 mc:0 channel:0 slot:0)

is not clear if this is either an error or something else.

> 
>>> * count is gone
>>
>> While count is not properly addressed, I'll keep it on sb_edac/i7core_edac.
>>
>> The right thing here seems to move it to a core property and increment the error counters
>> according with the error count.
> 
> Incrementing the error counters shouldn't have anything to do with the
> error reporting.

Why? The error counters is part of the API. Some utilities like edac-ctl actually don't even
care about the error logs. They only look into the error counting.

The API has 3 ways to report errors:
	- via counters;
	- via tracepoints;
	- via dmesg.

The error handling routine should update the error on all of them.

Of course, we may opt to remove error counting from the Kernel as a hole, letting it for
userspace handling. Even so, the driver needs to provide how many errors were reported,
in order to implement it on userspace.

>>> * MC-drivers shouldn't say "error" when reporting an error
>>> * UE/CE moves into the brackets
>>
>> It seems that both Tony and me agrees that UE/CE/Fatal should be outside the brackets.
> 
> Why?

Also already discussed dozens of time: this is the error severity. The way users handle
UE errors are different than the way they handle CE, e. g. CE errors are "tolerable". 
UE errors might not be.

> 
>>> * socket moves earlier in the brackets, and keep the whole deal hierarchical.
>>
>> Socket doesn't bring a very relevant information. It provides the CPU socket with the core that
>> were running the code when an error was generated, not the CPU that were managing the memory.
> 
> Then drop it if it's not relevant.

Because irrelevant != "not very relevant".

I might eventually drop it on some latter cleanups on sb_edac driver.

>>> * drop "err_code" what is that?
>>
>> In this case:
>> 	u32 errcode = GET_BITFIELD(m->status, 0, 15);
> 
> Either decode it like I do in amd_decode_err_code() or remove it
> completely - no naked bit values.

It is decoded, but providing it might help with debugging.

I might eventually drop it on some latter cleanups on sb_edac driver.

> 
>>> * drop second "socket"
>>> * drop "area" Area "DRAM" - are there other?
>>
>> Yes. there are 4 types of area at sb_edac.
> 
> And they are?

See the driver:

static char *get_dram_attr(u32 reg)
{
	switch(DRAM_ATTR(reg)) {
		case 0:
			return "DRAM";
		case 1:
			return "MMCFG";
		case 2:
			return "NXM";
		default:
			return "unknown";
	}
}

> 
>>> * what is "channel_mask"?
>>
>> It is a bitmask mask showing all channels affected by an error, on sb_edac.
>> Handing it is on my TODO list.
> 
> What can the user do with it when it sees it reported?

Instead of blaming just one DIMM, blaming 2 or 4 DIMMs.

>>> * move "rank" to earlier
>>
>> Why? This is the least relevant information provided by the driver-specific logic:
>>
>> 	snprintf(msg, sizeof(msg),
>> 		 "count:%d%s%s area:%s err_code:%04x:%04x socket:%d channel_mask:%ld rank:%d",
>> 		 core_err_cnt,
>> 		 overflow ? " OVERFLOW" : "",
>> 		 (uncorrected_error && recoverable) ? " recoverable" : "",
>> 		 area_type,
>> 		 mscod, errcode,
>> 		 socket,
>> 		 channel_mask,
>> 		 rank);
>>
>> Error count, overflow, recoverable bit, etc are more relevant than it, as it actually affects
>> the user.
>>
>> Rank, on the other hand, might only help someone interested on replacing a DRAM chip. Still,
>> it is doubtful that this would be used, in practice, as companies that replaces DIMM chip likely
>> have some specific equipments to test the DIMMs.
>>
>> So, I almost dropped it. The only reason for me to not drop is that it allows me to compare
>> the driver results with some other testing tools I'm using on driver's development.
> 
> Then drop it and keep a local version for your testing needs only.

It is too early to do that, as there literally thousands of ways to configure SB Memory Controllers,
and I was not able to test all of them.

So, at least while we don't have a report of having all possible SB modes tested by somebody,
I won't be dropping things that will help me to address bugzillas opened for this driver.

Regards,
Mauro
