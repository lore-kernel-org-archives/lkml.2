Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2BDI7u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 03:59:50 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56614 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab2BDI7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 03:59:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAEik5nOEBgtEf766CxcRPTXb5CnTdwn1JYm+yaaqV1aOTjpJ0g@mail.gmail.com>
References: <CAEik5nNsct2CL0Pfu8XaBGpZ4UOc-6EWtbk_LO5AxGzK9Vajjg@mail.gmail.com>
 <4F2C96F7.9070307@cavium.com> <CAEik5nOEBgtEf766CxcRPTXb5CnTdwn1JYm+yaaqV1aOTjpJ0g@mail.gmail.com>
From: Sorin Dumitru <dumitru.sorin87@gmail.com>
Date: Sat, 4 Feb 2012 10:59:28 +0200
Message-ID: <CAB6DaTO3nVHG7mhxKZDXEaTbV10UQ62qVBgTJDCQuY_ERREggA@mail.gmail.com>
Subject: Re: [perf] perf top segfaulting
To: Dan McGee <dpmcgee@gmail.com>
Cc: David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 4, 2012 at 4:46 AM, Dan McGee <dpmcgee@gmail.com> wrote:
> On Fri, Feb 3, 2012 at 8:24 PM, David Daney <david.daney@cavium.com> wrote:
>> On 02/03/2012 04:45 PM, Dan McGee wrote:
>>>
>>> On i686, version 3.2-2, but looks like annotate.c hasn't changed much
>>> since. It sometimes happens within 5 seconds of starting perf,
>>> sometimes much later, but almost always if I leave it running I well
>>> come back to it having segfaulted. When ran with gdb here it took
>>> about 3 minutes; I had a 5 second segfault and a 5 minute segfault
>>> before and after this run as well. I'm not sure what triggers it other
>>> than it isn't user input, as I can start `perf top`, not touch it, and
>>> it will eventually segfault.
>>>
>>
>>
>> I have seen the same thing (basically the same stack trace), so I think what
>> I see is probably closely related.  My failures however are on mips64 based
>> systems.
>>
>> My debugging suggests that this happens when the ABIs used by the running
>> processes are heterogeneous (A mixture of 32-bit and 64-bit processes).
>>  What I see is that all processes use a library with a common name, but
>> differing in paths (/lib32/libc-2.11.3.so and /lib64/libc-2.11.3.so for
>> example).  It looks like perf is confusing the offsets it caches from one
>> library to look up information in the other and since the symbols are in
>> different locations, the resulting erroneous address calculations result in
>> accesses to unmapped portions of perf's address space and you get SIGSEGV.
>>
>> I haven't dug into the code enough to suggest a fix, but I think that at a
>> high hand-waving level, this is what is happening.  I have never observed
>> the failure when using only a single ABI on the system
>
> Note that in this case, it is a pure 32-bit x86 system, and no library
> changes were going on in the background. So I wouldn't be surprised if
> the causes are similar (or the same), but I don't think I can chalk it
> up to being a single ABI vs multiple ABI problem; i686 only has one
> ABI.
>
> -Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I've seen this same problem on a pure 32-bit x86 system. So it definitely isn't
an ABI problem.
>From what i can tell the problem is in perf_event__process_sample. When calling
perf_event__process_sample, we set al->sym based on al->address. The symbol
in the hist_entry is set to the one from al but in the call to
perf_top__record_precise_ip
we pass in the address from the event struct which is sometimes
different than the one
in the al structure. When this situation occurs, when calculating the offset in
symbol__inc_addr_samples, because addr is not in the symbol [start,end] range,
we get a very big value which causes the segfault when we use it to
index something.
I've sent a patch that works for me, but i don't know if it's the
right solution at [1].

[1] https://lkml.org/lkml/2012/1/29/59
