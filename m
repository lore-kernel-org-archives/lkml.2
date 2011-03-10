Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1CJR1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:27:53 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:7808 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab1CJR1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:27:52 -0500
Message-ID: <4D790A13.4060705@caviumnetworks.com>
Date: Thu, 10 Mar 2011 09:27:47 -0800
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
References: <cover.1299702291.git.jbaron@redhat.com>	 <1299728191.15854.319.camel@gandalf.stny.rr.com>	 <BLU0-SMTP690BB959832A97E002293396C80@phx.gbl> <1299771504.15854.347.camel@gandalf.stny.rr.com>
In-Reply-To: <1299771504.15854.347.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Mar 2011 17:27:47.0568 (UTC) FILETIME=[79495700:01CBDF48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 07:38 AM, Steven Rostedt wrote:
> On Thu, 2011-03-10 at 09:11 -0500, Mathieu Desnoyers wrote:
>> * Steven Rostedt (rostedt@goodmis.org) wrote:
>>> On Wed, 2011-03-09 at 15:47 -0500, Jason Baron wrote:
>>>> Hi,
>>>>
>>>> Re-fresh of updates against latest -tip tree.
>>>
>>> Thanks Jason,
>>>
>>> I started looking at them, I should have comments tomorrow (if I have
>>> any comments ;)
>>>
>>>>
>>>> I've tried to split this update up somewhat, but I've only succeeded to split
>>>> out the dynamic debug bits. The interface changes and re-write are quite
>>>> intertwined.
>>>>
>>>> I believe this update should address all the comments from the previous posting
>>>> except for Mathieu's request for a section of jump label pointers that point to
>>>> the jump label structures (since the compiler might leave gaps in the jump label
>>>> structures).
>>>
>>> The jump label structures is a list of 3 pointers, correct? I doubt that
>>> gcc would place any holes in it as they are all aligned by natural word
>>> size.
>>>
>>
>> Hi Steven,
>>
>> Can you explain what would prevent gcc from aligning these 3 pointers
>> (total of 24 bytes on 64-bit architectures) on 32-bytes ?

I can:

http://www.x86-64.org/documentation/abi.pdf Section 3.1.2:

    Aggregates and Unions

    Structures and unions assume the alignment of their most strictly
    aligned component. Each member is assigned to the lowest
    available offset with the appropriate alignment. The size of any
    object is always a multiple of the object‘s alignment.

    An array uses the same alignment as its elements, except that a
    local or global array variable of length at least 16 bytes or a C99
    variable-length array variable always has alignment of at least 16
    bytes.

    Structure and union objects can require padding to meet size and
    alignment constraints. The contents of any padding is undefined.

I don't think it is explicitly stated, but it is also true that the size 
is the smallest value that meets the above constraints.


>> Also, could
>> you point out what would refrain the linker from aligning the start of
>> object sections on the next 32-bytes (thus power of two) address
>> multiple ?
>

The rules of the ABI are quite specific.  It would be a toolchain bug if 
this were messed up.



> Maybe it would be just easier to add another long ;)

Maybe we should audit all the data structures in the entire kernel and 
add manual padding to power of 2 boundaries.

>
> Seriously, it would. Then it would be 32 bytes on 64bit and 16 bytes on
> 32bit. Then I guess we can have our guarantee without doing a large
> change to have this indirect pointer and still waste sizeof(long) bytes
> in having it.
>
> Just insert a long "Reserved" word.
>

I disagree.  Wasting memory to work around non-existent hypothetical 
bugs seems wrong to me.

David Daney
