Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1CJSrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:47:17 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:10382 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1CJSrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:47:16 -0500
Message-ID: <4D791CAA.7090108@caviumnetworks.com>
Date: Thu, 10 Mar 2011 10:47:06 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, peterz@infradead.org,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
References: <cover.1299702291.git.jbaron@redhat.com>	 <1299728191.15854.319.camel@gandalf.stny.rr.com>	 <BLU0-SMTP690BB959832A97E002293396C80@phx.gbl>	 <1299771504.15854.347.camel@gandalf.stny.rr.com>	 <4D790A13.4060705@caviumnetworks.com>	 <1299780241.15854.393.camel@gandalf.stny.rr.com>	 <20110310182000.GB2906@redhat.com> <1299782143.15854.402.camel@gandalf.stny.rr.com>
In-Reply-To: <1299782143.15854.402.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2011 18:47:11.0537 (UTC) FILETIME=[90D55210:01CBDF53]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 10:35 AM, Steven Rostedt wrote:
> On Thu, 2011-03-10 at 13:20 -0500, Jason Baron wrote:
>> On Thu, Mar 10, 2011 at 01:04:01PM -0500, Steven Rostedt wrote:
>> Now its up to the linker to decide where to place that element. Can we
>>> guarantee that it will always be on an 8 byte boundery?
>>> Hmm, I wonder if we could add a .ALIGN sizeof(long) before that?
>>>
>>
>> we can. Sparc does it, see: arch/sparc/include/asm/jump_label.h.
>>
>> So I guess it would be .align 8 for 64-bit and .align 4 for 32-bit...
>
> Now what about the vmlinux.ld? That has a align 8. Is that a one time
> short (align to 8 bytes here), or will it carry through aligning the
> rest of the section. If not, perhaps we may be OK.
>

That is the alignment of the start of the section in the *output* 
object.  The linker will respect the requested alignment of the various 
__jump_table sections in the *input* objects.  So adding an .align 8 
before emitting data into the __jump_table section would not hurt (It 
could even help.)

I empirically determined that if no .align is specified, the requested 
alignment defaults to 4 for x86_64.

The alignment requested by the assembler will have to satisfy *all* the 
requested alignments, so manually forcing everything to .align 8 (or 
.align 4 for 32-bit) should ensure that the linker doesn't put in any holes.

David Daney
