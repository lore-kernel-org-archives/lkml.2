Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab1ATWzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 17:55:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:29155 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab1ATWzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:55:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eQ2xwpi6cWl9XjMfdg1jZ14cZMR5GSx77fXW8iLWJou4EPvCx+tV8wvCGp06COPWGu
         mc+wUStq7Xpf2e91HjLg==
Message-ID: <4D38BCFA.8050609@google.com>
Date: Thu, 20 Jan 2011 14:53:46 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: huang ying <huang.ying.caritas@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>,
        Robert Lippert <rlippert@google.com>
Subject: Re: [PATCH -v10 0/4] Lock-less list
References: <1295245019-7816-1-git-send-email-ying.huang@intel.com> <20110119135546.bb7e8f62.akpm@linux-foundation.org> <1295484358.15213.25.camel@yhuang-dev> <20110119165247.cca2f434.akpm@linux-foundation.org> <1295520247.28776.152.camel@laptop> <AANLkTimR6xd1PxCP6jmuNwFkANrGPdTf2wpiGsBXGpKx@mail.gmail.com> <1295522876.28776.158.camel@laptop> <AANLkTin3_NuGG_E0Juy7=1Q7PcMJ6id1ZU-Gngfp_=dg@mail.gmail.com> <20110120121455.GA7680@elte.hu> <AANLkTikv3h_QoHs4uj6CNJdC7tb_-e0osKa47KWEJvFV@mail.gmail.com> <20110120130625.GA14436@elte.hu>
In-Reply-To: <20110120130625.GA14436@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/11 05:06, Ingo Molnar wrote:
>
> * huang ying<huang.ying.caritas@gmail.com>  wrote:
>
>> On Thu, Jan 20, 2011 at 8:14 PM, Ingo Molnar<mingo@elte.hu>  wrote:
>>>
>>> * huang ying<huang.ying.caritas@gmail.com>  wrote:
>>>
>>>>> But will all that stuff be accepted? Please stop sending infrastructure bits and
>>>>> focus on your larger RAS picture, once you have consensus on that from all
>>>>> parties involved, then, and only then, does it make sense to submit everything,
>>>>> including infrastructure.
>>>>
>>>> I am not sending hardware error reporting infrastructure.  As far as I know, Linus
>>>> and Andrew suggest to use printk for hardware error reporting.  And now, I just
>>>> try to write APEI driver and reporting hardware error with printk.  Is it
>>>> acceptable?  Do you have some other idea about hardware error reporting?
>>>
>>> Erm, how could you possible have missed the perf based RAS daemon work of Boris,
>>> which we've pointed out about half a dozen times already?
>>
>> Even if there is some other hardware error reporting infrastructure
>> such as perf based, I think we still need printk too. After all, as
>> Linus pointed out, printk is the most popular error reporting
>> mechanism so far. Do you think so?
>
> Of course, that's why the upstream EDAC code uses printk too. In fact it does all
> sorts of in-kernel decoding to make the printk output more useful - the /dev/mcelog
> method of pushing all decoding to user-space is fundamentally flawed.

Geez, I don't know how to approach this preposition in a concise way :( 
  Processing machine checks in-kernel is just as flawed as relying on 
/dev/mcelog alone IMO.  I agree with you that relying on /dev/mcelog to 
get all of our error data out is flawed, but so is relying on an 
in-kernel "abstraction" of the data exposed from the hardware.


There are many different ways a system can fail such that an MCE isn't 
received and processed by the kernel.  Sometimes the error is just too 
fatal to do anything useful.  Errors like a NB buffer CRC error, a bus 
syncflood, or a cache hierarchy ECC error that was incorrectly 
propagated up through to the L1 (which may only have parity checking) 
can cause the kernel to fall over as the CPU is either cut off from the 
rest of the world or too confused to get anything right.

Getting at this information is still very worthwhile however, and I'm 
guessing that this is what the APEI bits are meant to be doing.  You'll 
be seeing patches for Google firmware drivers that provide 
functionality along the same vein in the coming days (I'm still busy 
whitewashing and documenting them).

It's also very ignorant to assume that the kernel knows everything about 
the system and is capable of decoding errors to the satisfaction of 
userland.  As Duncan Laurie pointed out 
(https://lkml.org/lkml/2011/1/11/390) we care about not only the 
physical address, but which stick and which dimm *chip* on the stick is 
having problems.  In-kernel abstractions  break down due to the following:

    * The kernel couldn't possible know how my i2c busses are setup and 
the SPD EEPROMs are related to the physical memory abstraction that the 
bios sets up for me.  I don't know of any standard way to have the BIOS 
expose this sort of information to the operating system.  This sort of 
layout changes between motherboard spins quite frequently as well, so 
good luck mapping it yourself in any generic way.

    * The kernel couldn't know how to map SPD JEDEC Manufacturer ID, 
Model part number and revision to anything useful about the chips 
themselves.

    * The kernel also couldn't know how to communicate with the AMBs in 
a meaningful way (if present).


At the end of the day,   The only things I really care about are:

    * I don't care if the kernel pre-processes the data it gets from the 
hardware when there is an error.  For most users, burping something out 
to the logs in decoded form is generally useful.  It isn't for us.
    * Don't ever put the kernel in a position where it will spam the 
logs and wedge the system -- even if the hardware is wonky.
    * Don't dummy the data such that I can't do the same calculations 
with better visibility from userland.
    * Don't ever enforce a reactive policy that can't be changed from 
userland.
    * I don't care whether the data comes from netlink, /dev/mcelog, 
whiz-bang-sysfs uevent, or thingamaboo perfevents doohickie: as long as 
I get events that are both atomic+consistent and the ABI is maintained.

I've CCed Robert who owns our userland bits as he may have something to add.

That said, I'd love to have generic NMI-safe data-passing for improved 
debugability, regardless of this conflated bickering about RAS 
infrastructure :)
