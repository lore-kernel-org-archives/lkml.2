Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784Ab2EXSBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:01:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379Ab2EXSBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:01:13 -0400
Message-ID: <4FBE7755.2080301@redhat.com>
Date: Thu, 24 May 2012 15:00:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
References: <1337358773-6919-38-git-send-email-mchehab@redhat.com> <1337854460-25191-1-git-send-email-mchehab@redhat.com> <20120524105604.GC27063@aftab.osrc.amd.com> <4FBE5E1D.7070804@redhat.com> <20120524164554.GM27063@aftab.osrc.amd.com>
In-Reply-To: <20120524164554.GM27063@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-05-2012 13:45, Borislav Petkov escreveu:
> On Thu, May 24, 2012 at 01:13:17PM -0300, Mauro Carvalho Chehab wrote:
>>> Why are we even exporting grain actually with each tracepoint
>>> invocation? This is the granularity of reported error in bytes, and it,
>>> as such, is statically assigned to a value in each driver. Userspace can
>>> certainly figure out that value in a different way.
>>
>> The API doesn't export the grain, except via the tracepoint/printk.
> 
> And this is exactly my question: if it is a static value which is set
> once per driver, why do we have to issue it with _every_ tracepoint
> invocation? Room in the per-cpu trace buffers is not for free.

On the current drivers, the grain static. I'm not sure if the grain is really
a per-memory controller or if this is again yet-another-issue with the way
EDAC core handles such information.

I suspect that, on sophisticated memory controllers that can do any type of
DIMM interleaving, including no interleave at all, the grain can vary from
one memory address range to the other.

If we change the API to have an explicit sysfs node to express the grain,
and latter we end by needing a per-address range grain, we'll need to break
the kABI. 

So, keeping the grain information at the tracepoint is more flexible, as it
can cover both situations.

> 
>>> But the more important question is: does the grain help us when handling
>>> the error info in userspace?
>>>
>>> It tells us that at this physical address with "grain" granularity we
>>> had an error. So?
>>
>> While a certain number of corrected errors that happened on different, sparsed,
>> addresses may not mean a damaged memory, the same number of corrected errors
>> happening at the same physical address/grain means that the DRAM chip that
>> contains such address is damaged, so the corresponding DIMM needs to be 
>> replaced.
>>
>> So, the address/grain can be used by userspace algorithms to increase the
>> probability that a DIMM is damaged.
> 
> I have no idea what you're saying here.
> 
> The DIMM can be pinpointed using the address only, why do you need the
> grain too?

You can pinpoint a DIMM but in order to pinpoint the affected MOSFET transistors,
the address and address mask is needed, as most memory controllers can't point
to a single address, because the register that stores the address doesn't have
enough bits to store the full content of the instruction pointer register, or because
of some other internal device issues.

So, two different "addresses" could atually point to the same group of transistors
inside a DIMM.

Also, higher values of grains may affect the error statistics. For example, i3200_edac
driver has a grain that can be 64 MB, while other devices have a grain of 1.

If userspace uses some a stochastics analysis to measure the error distribution,
the grain will affect the parameters for the Probability Distribution Function to 
be used to estimate if the error was just due to a random noise, or if they're due 
to a bad memory.

Regards,
Mauro
