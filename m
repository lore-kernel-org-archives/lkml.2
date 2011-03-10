Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1CJVLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:11:11 -0500
Received: from blu0-omc1-s37.blu0.hotmail.com ([65.55.116.48]:30662 "EHLO
	blu0-omc1-s37.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586Ab1CJVLJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:11:09 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP217A0D2C21D7A74E7B9D9296C80@phx.gbl>
Date: Thu, 10 Mar 2011 16:11:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Daney <ddaney@caviumnetworks.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        peterz@infradead.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 0/2] jump label: update for .39
References: <cover.1299702291.git.jbaron@redhat.com> <1299728191.15854.319.camel@gandalf.stny.rr.com> <BLU0-SMTP690BB959832A97E002293396C80@phx.gbl> <1299771504.15854.347.camel@gandalf.stny.rr.com> <4D790A13.4060705@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4D790A13.4060705@caviumnetworks.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:56:52 up 337 days,  6:46,  3 users,  load average: 0.18, 0.26,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 10 Mar 2011 21:11:07.0671 (UTC) FILETIME=[AC5ECA70:01CBDF67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Daney (ddaney@caviumnetworks.com) wrote:
> On 03/10/2011 07:38 AM, Steven Rostedt wrote:
>> On Thu, 2011-03-10 at 09:11 -0500, Mathieu Desnoyers wrote:
>>> * Steven Rostedt (rostedt@goodmis.org) wrote:
>>>> On Wed, 2011-03-09 at 15:47 -0500, Jason Baron wrote:
>>>>> Hi,
>>>>>
>>>>> Re-fresh of updates against latest -tip tree.
>>>>
>>>> Thanks Jason,
>>>>
>>>> I started looking at them, I should have comments tomorrow (if I have
>>>> any comments ;)
>>>>
>>>>>
>>>>> I've tried to split this update up somewhat, but I've only succeeded to split
>>>>> out the dynamic debug bits. The interface changes and re-write are quite
>>>>> intertwined.
>>>>>
>>>>> I believe this update should address all the comments from the previous posting
>>>>> except for Mathieu's request for a section of jump label pointers that point to
>>>>> the jump label structures (since the compiler might leave gaps in the jump label
>>>>> structures).
>>>>
>>>> The jump label structures is a list of 3 pointers, correct? I doubt that
>>>> gcc would place any holes in it as they are all aligned by natural word
>>>> size.
>>>>
>>>
>>> Hi Steven,
>>>
>>> Can you explain what would prevent gcc from aligning these 3 pointers
>>> (total of 24 bytes on 64-bit architectures) on 32-bytes ?
>
> I can:
>
> http://www.x86-64.org/documentation/abi.pdf Section 3.1.2:
>
>    Aggregates and Unions
>
>    Structures and unions assume the alignment of their most strictly
>    aligned component. Each member is assigned to the lowest
>    available offset with the appropriate alignment. The size of any
>    object is always a multiple of the object‘s alignment.
>
>    An array uses the same alignment as its elements, except that a
>    local or global array variable of length at least 16 bytes or a C99
>    variable-length array variable always has alignment of at least 16
>    bytes.
>
>    Structure and union objects can require padding to meet size and
>    alignment constraints. The contents of any padding is undefined.
>
> I don't think it is explicitly stated, but it is also true that the size  
> is the smallest value that meets the above constraints.

Your quote seems to apply in this case because:

a) the "structure" is defined in assembly, so the compiler is not
   deciding the alignment of the structure.

b) the C code that iterates on the section array in jump_label.c see an
   array of structures, which imply that gcc does not have no freedom in
   terms of up-aligning these structures.

The problem we faced with trace event and tracepoints was caused by the
fact that we did define static structures from within C code, and the
compiler mistakenly believed that it was the only one holding references
to these structures, so it could up-align them to larger multiples as it
wants, because they were each independent objects.

>
>
>>> Also, could
>>> you point out what would refrain the linker from aligning the start of
>>> object sections on the next 32-bytes (thus power of two) address
>>> multiple ?
>>
>
> The rules of the ABI are quite specific.  It would be a toolchain bug if  
> this were messed up.

The trace event and tracepoint code are doing static structure
declarations into specific sections for the linker to create array
bounds with, and this last part sadly falls outside of the compiler
knowledge, and therefore might be outside of the ABI scope because the
compiler believes that these objects are local to the object and never
ever exported. Note that up-aligning on larger multiples still meets the
local alignment requirements -- it's just not valid to e.g. create an
array that assumes that these statically defined structures are next to
another without any extra padding.

>
>
>
>> Maybe it would be just easier to add another long ;)
>
> Maybe we should audit all the data structures in the entire kernel and  
> add manual padding to power of 2 boundaries.

Only required when we play games with sections outside of the compiler
knowledge, which is really a handful of cases.

>
>>
>> Seriously, it would. Then it would be 32 bytes on 64bit and 16 bytes on
>> 32bit. Then I guess we can have our guarantee without doing a large
>> change to have this indirect pointer and still waste sizeof(long) bytes
>> in having it.
>>
>> Just insert a long "Reserved" word.
>>
>
> I disagree.  Wasting memory to work around non-existent hypothetical  
> bugs seems wrong to me.

This object layout problem has been me with tracepoints in the past, and
has bitter Steven with trace event recently. It is therefore very real.

Thanks,

Mathieu

>
> David Daney

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
