Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1CJWLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:11:19 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16954 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1CJWLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:11:18 -0500
Message-ID: <4D794C7C.5010008@caviumnetworks.com>
Date: Thu, 10 Mar 2011 14:11:08 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
References: <1299771504.15854.347.camel@gandalf.stny.rr.com>	 <4D790A13.4060705@caviumnetworks.com>	 <1299780241.15854.393.camel@gandalf.stny.rr.com>	 <20110310182000.GB2906@redhat.com>	 <1299782143.15854.402.camel@gandalf.stny.rr.com>	 <4D791CAA.7090108@caviumnetworks.com>	 <1299783236.15854.405.camel@gandalf.stny.rr.com>	 <4D791F31.6040100@caviumnetworks.com>	 <1299785143.15854.407.camel@gandalf.stny.rr.com>	 <1299786329.15854.409.camel@gandalf.stny.rr.com>	 <BLU0-SMTP311155BEBE5F141636A6E596C80@phx.gbl> <1299793339.15854.430.camel@gandalf.stny.rr.com>
In-Reply-To: <1299793339.15854.430.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2011 22:11:13.0443 (UTC) FILETIME=[1193EF30:01CBDF70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 01:42 PM, Steven Rostedt wrote:
> On Thu, 2011-03-10 at 16:22 -0500, Mathieu Desnoyers wrote:
>
>>> Anyway, I think the best thing for now is to have Jason add
>>> the .align(sizeof(long)) in the inline assembly for all locations and be
>>> done with it.
>>
>> You seem to be contradicting yourself here. I'm concerned about having
>> "structures" of a size not power of two. Can we simply either
>
> But we don't have structures. We have data that has been allocated in
> assembly. Come to think of it, it may be best to keep these as
> ".align 4".
>
>
>>
>> - Add a padding element at the end
>> or
>> - use .align 4*sizeof(long) at the beginning
>>
>> to make sure the linker won't put any holes when it puts objects
>> together ?
>>
>
> The linker should be dumb and not trying to "optimize", because it has
> no idea what the content is. If anything, it should try to compact
> things as best as possible, with the exception of keeping things
> naturally word aligned. If you added even ".align(4)" on a 64bit system,
> the linker should be trying to keep everything packed.
>
> If I get time, I could look at the linker code to see exactly what it
> does, but adding holes into sections that are naturally word align seems
> more like a bug in the linker than a problem that we need to deal with.
>
> The only issue I could fathom, is if gcc added its own padding in a
> section. That is, when it created the __jump_table section with one
> element, it added another 4/8 bytes to make the section size a power of
> two. Maybe that is a true issue, maybe not. It would seems stupid to do
> so IMHO, because when you get to bigger numbers, the aligning a power of
> 2 can get much bigger. But perhaps it does it for small power of 2s?
>

GCC on x86_64 likes to align its data with .align 16:
-------------------------------
$ cat jl.c

struct foo {
   long a;
   long b;
   long c;
};

struct foo bar = {1,2,3};

$ gcc -O3 -S jl.c
$ cat jl.s
	.file	"jl.c"
.globl bar
	.data
	.align 16
	.type	bar, @object
	.size	bar, 24
bar:
	.quad	1
	.quad	2
	.quad	3
	.ident	"GCC: (GNU) 4.4.4 20100630 (Red Hat 4.4.4-10)"
	.section	.note.GNU-stack,"",@progbits
----------------------------------

But that shouldn't matter because we only emit data to the __jump_table 
section from asm().

GCC is getting a reference to that table (array of structures really) 
from a global variable, I don't see how it can violate the ABI in this case.


David Daney
