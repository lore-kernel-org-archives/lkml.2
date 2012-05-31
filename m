Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab2EaSYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:24:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab2EaSYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:24:37 -0400
Message-ID: <4FC7B754.5040209@redhat.com>
Date: Thu, 31 May 2012 15:24:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
References: <4FBE5E1D.7070804@redhat.com> <20120524164554.GM27063@aftab.osrc.amd.com> <4FBE7755.2080301@redhat.com> <20120529115851.GB29157@aftab.osrc.amd.com> <4FC4D6E2.9060501@redhat.com> <20120529145245.GG29157@aftab.osrc.amd.com> <4FC4E9EB.5030801@redhat.com> <3908561D78D1C84285E8C5FCA982C28F192F6672@ORSMSX104.amr.corp.intel.com> <20120531100005.GC14074@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F192F6C61@ORSMSX104.amr.corp.intel.com> <20120531172018.GO14515@aftab.osrc.amd.com>
In-Reply-To: <20120531172018.GO14515@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 31-05-2012 14:20, Borislav Petkov escreveu:
> On Thu, May 31, 2012 at 04:51:27PM +0000, Luck, Tony wrote:
>> No, it's a 6-bit field used as a shift ... so if it has value "6", it
>> means cache line granularity. Value "12" would mean 4K granularity.
>> Architecturally it could say "30" to mean gigabyte, or even "63" to
>> mean "everything is gone".
> 
> Right, 0x3f are 6 bits, correct, doh!
> 
>>>> while a few (IIRC patrol scrub) will report with page (4K)
>>>> granularity. Linux doesn't really care - they all have to get rounded
>>>> up to page size because we can't take away just one cache line from a
>>>> process.
>>>
>>> I'd like to see that :-)
>>
>> Patrol scrub works inside the depths of the memory controller on rank/row
>> addresses, not on system physical addresses. When it finds a problem, a
>> reverse translation is needed to be able to report a system physical
>> address in MCi_ADDR. Getting all the bits right is apparently a hard thing
>> to do, so the MCI_MISC_ADDR_LSB bits are used to indicate that some low
>> order bits are not valid.
> 
> Ok, thus the dynamic granularity. But we're going to end up reporting
> rank and row too so that it can be matched to the DIMM. I consider
> physical address a bonus in such cases and it is only of importance to
> those who like to replace single DRAM chips or single MOSFET transistors
> :-) :-) :-).
> 

A single corrected error doesn't mean you need to replace anything. The need
for a replacement is due to a joint probability of several independent
events:
	- a random noise;
	- a failure on a MOSFET transistor;
	- a failure at the DIMM contacts.

In order to distinguish between them, you need to know the statistics of
each of the above stochastic process and use some correlation functions
to detect to each group of event a series of error belongs.

For example, the error address at the DIMM contacts can be given by a
constant random variable, affecting a group of bits at the syndrome,
while a failure at a group of MOSFET transistors will be given by a
(series) of degenerate distribution function.

By properly exporting the address/grain/syndrome, an userspace program
can filter random noise failures from a defect at a DRAM or a bad contact
issue at the DIMM, and use different error count limits for each type of
error, when telling userspace when a memory should be replaced or not.

Regards,
Mauro

