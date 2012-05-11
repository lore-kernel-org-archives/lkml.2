Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759091Ab2EKMiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758454Ab2EKMiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:38:05 -0400
Message-ID: <4FAD081C.5000704@redhat.com>
Date: Fri, 11 May 2012 09:37:48 -0300
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
References: <1336679788-4982-1-git-send-email-mchehab@redhat.com> <20120510204042.GA4598@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F192EC1A2@ORSMSX104.amr.corp.intel.com> <4FAC3C35.70101@redhat.com> <3908561D78D1C84285E8C5FCA982C28F192EC247@ORSMSX104.amr.corp.intel.com> <4FAC6FF8.3050608@redhat.com> <20120511102527.GI8913@aftab.osrc.amd.com>
In-Reply-To: <20120511102527.GI8913@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 11-05-2012 07:25, Borislav Petkov escreveu:
> On Thu, May 10, 2012 at 10:48:40PM -0300, Mauro Carvalho Chehab wrote:
>> Em 10-05-2012 19:37, Luck, Tony escreveu:
>>>      kworker/u:6-201   [007] .N..   186.197280: mc_error: [Hardware Error]: mem_ctl#0: Corrected error memory read error on memory stick "DIMM_A1" (channel:0 slot:1  page:0x2f1eb3 offset:0x446 grain:32 syndrome:0x0 1 error(s): Unknown: Err=0001:0090 socket=0 channel=0/mask=1 rank=5)
>>>      
>>> The word "error" appears *five* times on this line (once with a capital E).
>>> I feel beaten, bruised and ready to give up on this machine with just one
>>> actual error reported :-)
>>
>> :)
>>
>> Several of them come from the driver-provided details.
>>
>> The edac-mc core contributes with "mc_error", "[Hardware Error]" and "Corrected error".
>> The sb-edac driver contributes with "memory read error" and "1 error(s)".
>>
>> We can get easily get rid of "[Hardware Error]" by removing HW_ERR from:
>>
>> 	TP_printk(HW_ERR "mem_ctl#%d: %s error %s on memory stick \"%s\" (%s %s %s)",
>>
>> replacing mc_error by something else is not hard, but this is the name of the trace call:
>>
>> TRACE_EVENT(mc_error,
>> ...
>>
>> Maybe the better is to do s/mc_error/mc_event/g.
> 
> HW_ERR is the "official" prefix used by the MCE code in the kernel.
> Maybe we can shorten it but it is needed to raise attention when staring
> at dmesg output.
> 
> Now, since this tracepoint is not dmesg, we don't need it there at all
> since we know that trace_mc_error reports memory errors.

IMO, we can get rid of it on trace, keeping it at dmesg.

> "mc_error" is also not needed.

Some name is required there. This parameter affects:
	- the name of the tracepoint function;
	- the TP_printk() output;
	- the trace filter name.

mc_event is probably a good name.

>> The error count msg ("1 error(s)") could be replaced by "count:1".
> 
> Is there even a possibility to report more than one error when invoking
> trace_mc_error once? If not, simply drop the count completely.

Good point. It makes sense to add a count parameter to the error handling core, 
in order to handle "count". AFAIKT, the only two drivers that currently reports
error counts are sb_edac and i7core_edac.

With regards to sb_edac, it also needs another logic to be handled by the core:
channel_mask. This is required to handle lockstep mode and mirror mode.

Adding support for it is already on my TODO list. I'll also put "count" 
on my TODO list.

>>> We could get rid of one by:
>>>  s/Corrected error memory read error/Corrected memory read error/
>>
>> This is the hardest possible solution ;) Changing it will cause weird messages
>> all over EDAC drivers ;)
> 
> I agree with Tony here - repeating error a gazillion times on one report
> only is a "naaah!"
> 
> Here's how it should look:
> 
> kworker/u:6-201   [007] .N..   161.136624: [Hardware Error]: memory read on memory stick "DIMM_A1" (type: corrected socket:0 mc:0 channel:0 slot:0 rank:1 page:0x586b6e offset:0xa66 grain:32 syndrome:0x0 channel_mask:1)

As already explained: the error_msg is not consistent among the drivers.

So, "memory read on ..." will work fine on sb_edac/i7core_edac but it _won't_
work on other drivers.

Changing this field on each driver requires deep knowledge of each memory
controller, and not all datasheets are publicly available. 

For example, this is the code for Freescale MPC85xx EDAC driver:

	if (err_detect & DDR_EDE_SBE)
		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
				     pfn, err_addr & ~PAGE_MASK, syndrome,
				     row_index, 0, -1,
				     mci->ctl_name, "", NULL);

	if (err_detect & DDR_EDE_MBE)
		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
				     pfn, err_addr & ~PAGE_MASK, syndrome,
				     row_index, 0, -1,
				     mci->ctl_name, "", NULL);

It uses a blank value for the error message. putting the error_msg at the beginning,
as you proposed would print: 

[Hardware Error]:  on memory stick "DIMM_A1" (type: corrected socket:0 mc:0 channel:0 slot:0 )

> * count is gone

While count is not properly addressed, I'll keep it on sb_edac/i7core_edac.

The right thing here seems to move it to a core property and increment the error counters
according with the error count.

> * MC-drivers shouldn't say "error" when reporting an error
> * UE/CE moves into the brackets

It seems that both Tony and me agrees that UE/CE/Fatal should be outside the brackets.

> * socket moves earlier in the brackets, and keep the whole deal hierarchical.

Socket doesn't bring a very relevant information. It provides the CPU socket with the core that
were running the code when an error was generated, not the CPU that were managing the memory.

The CPU managing the memory is called "memory controller".

It might be used by something that would kill the affected task, but doing such things
is probably not easy.

So, the hierarchical information that translates into "DIMM_A1" is "mc:0 channel:0 slot:0".

> * drop "err_code" what is that?

In this case:
	u32 errcode = GET_BITFIELD(m->status, 0, 15);

> * drop second "socket"
> * drop "area" Area "DRAM" - are there other?

Yes. there are 4 types of area at sb_edac.

> * what is "channel_mask"?

It is a bitmask mask showing all channels affected by an error, on sb_edac.
Handing it is on my TODO list.

> * move "rank" to earlier

Why? This is the least relevant information provided by the driver-specific logic:

	snprintf(msg, sizeof(msg),
		 "count:%d%s%s area:%s err_code:%04x:%04x socket:%d channel_mask:%ld rank:%d",
		 core_err_cnt,
		 overflow ? " OVERFLOW" : "",
		 (uncorrected_error && recoverable) ? " recoverable" : "",
		 area_type,
		 mscod, errcode,
		 socket,
		 channel_mask,
		 rank);

Error count, overflow, recoverable bit, etc are more relevant than it, as it actually affects
the user.

Rank, on the other hand, might only help someone interested on replacing a DRAM chip. Still,
it is doubtful that this would be used, in practice, as companies that replaces DIMM chip likely
have some specific equipments to test the DIMMs.

So, I almost dropped it. The only reason for me to not drop is that it allows me to compare
the driver results with some other testing tools I'm using on driver's development.


> Now this is an output format I can get on board with.
> 

Regards,
Mauro.
