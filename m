Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761803Ab2EJWIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 18:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761790Ab2EJWIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 18:08:07 -0400
Message-ID: <4FAC3C35.70101@redhat.com>
Date: Thu, 10 May 2012 19:07:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
References: <1336679788-4982-1-git-send-email-mchehab@redhat.com> <20120510204042.GA4598@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F192EC1A2@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192EC1A2@ORSMSX104.amr.corp.intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 10-05-2012 18:10, Luck, Tony escreveu:
>>> +	TP_printk(HW_ERR "mce#%d: %s error %s on memory stick \"%s\" (%s %s %s)",
>>
>> This still says "mce" and it should say "MC" or "mem_ctl" or similar.
> 
> I'm trying to look at how this will look to an end user who is not intimately
> acquainted with the internals of how memory subsystems work.

This is what patch v23 prints on sb_edac:

# cat /sys/kernel/debug/tracing/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 30/30   #P:32
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
     kworker/u:6-201   [007] .N..   186.197280: mc_error: [Hardware Error]: mem_ctl#0: Corrected error memory read error on memory stick "DIMM_A1" (channel:0 slot:1  page:0x2f1eb3 offset:0x446 grain:32 syndrome:0x0 1 error(s): Unknown: Err=0001:0090 socket=0 channel=0/mask=1 rank=5)
     kworker/u:6-201   [007] .N..   186.239536: mc_error: [Hardware Error]: mem_ctl#1: Corrected error memory read error on memory stick "DIMM_E2" (channel:0 slot:0  page:0x93180b offset:0x927 grain:32 syndrome:0x0 1 error(s): Unknown: Err=0001:0090 socket=1 channel=2/mask=4 rank=0)

There are still some space to improve the fields provided by the drivers.

> Whether the string starts with "mce" or "MC" or whatever ... what will the
> user do with the mc_index that is printed with that first %d?  I don't think
> it helps them find the DIMM when they open the box.  

Well, it helps to match the memory information on the trace with the sysfs nodes
that are memory-controller based and with the dmesg info.

Calling it as "mc" is more coherent with the dmesg prints.

> I suppose it is useful
> if there are multiple messages ... and they see that the same memory controller
> is mentioned in each. But I almost think it belongs inside the parentheses at
> the end as the "low level details that most users won't need to care about.

I don't have a strong preference, although I think it is better to have it at
the beginning.
 
> Next %s is "Corrected" or "Fatal" or "Uncorrected" ... that's good.
> 
> What are the options for the next "%s" (msg)?

The type of the error. In the above, it is "memory read error".
 
> "memory stick"?? I suppose "DIMM" is a bit implementation dependent (SIMMs
> are long gone ... but perhaps there will be some new acronym for stacked
> memory ... STIMS :-) )

Memory stick is described at edac.h as:

 * Memory Stick:	A printed circuit board that aggregates multiple
 *			memory devices in parallel.  In general, this is the
 *			Field Replaceable Unit (FRU) which gets replaced, in
 *			the case of excessive errors. Most often it is also
 *			called DIMM (Dual Inline Memory Module).
 *

DIMM is implementation dependent. As EDAC is also used on non-x86 archs, calling
it as DIMM on ARM is probably wrong.

Calling it as "STIMS" (or any other unusual acronym) seems worse ;)

> 
> Then label (from SMBIOS) ... then the internal details. Good.

Regards,
Mauro
