Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab2IKDkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 23:40:05 -0400
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:12428 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667Ab2IKDj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 23:39:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAIOxTlB787/Z/2dsb2JhbAANOL5/AQEBAwE4FhwOAQULCxIGCRYPCQMCAQIBHxgOBggFAQUCAQEZBIdcAQwRqAiUF4sMhjYDlnGSAQ
X-IronPort-AV: E=Sophos;i="4.80,401,1344182400"; 
   d="scan'208";a="259739686"
Message-ID: <504EB28A.9080607@westnet.com.au>
Date: Tue, 11 Sep 2012 13:39:54 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] status of execve() work - per-architecture patches solicited
References: <20120907182004.GE13973@ZenIV.linux.org.uk> <504DEDBB.1090404@westnet.com.au> <20120910164946.GO13973@ZenIV.linux.org.uk>
In-Reply-To: <20120910164946.GO13973@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 02:49 AM, Al Viro wrote:
> On Mon, Sep 10, 2012 at 11:40:11PM +1000, Greg Ungerer wrote:
>> Hi Al,
>>
>> On 09/08/2012 04:20 AM, Al Viro wrote:
>>> 	To architecture maintainers: please, review the current
>>> situation in git.kernel.org/pub/scm/linux/kernel/git/viro/signal #execve2
>>> and consider sending the corresponding patches for missing architectures.
>>
>> I can see you have some m68k patches in there as well.
>> They tested good on standard m68k (under emulator) and good on non-mmu
>> ColdFire. But it is geting an exception when I run on ColdFire with MMU
>> enabled:
>>
>> ...
>> Creating 1 MTD partitions on "RAM":
>> 0x000000000000-0x0000001b8000 : "ROMfs"
>> TCP: cubic registered
>> NET: Registered protocol family 17
>> VFS: Mounted root (romfs filesystem) readonly on device 31:0.
>> *** FORMAT ERROR ***   FORMAT=4
>> Current process id is 1
>> BAD KERNEL TRAP: 00000000
>> Modules linked in:
>> PC: [<0002562a>] 0x02562a
>> SR: 2704  SP: 0383dfc4  a2: 00000000
>> d0: 00000000    d1: 00000000    d2: 00000000    d3: 00000000
>> d4: 00000000    d5: 00000000    a0: 00000000    a1: 00000000
>> Process init (pid: 1, task=0383a000)
>> Frame format=4 eff addr=00000000 pc=6000169a
>> Stack from 0383e000:
>> Call Trace:
>> Code: 6610 4cd7 073e 4fef 0020 201f 588f dfdf <4e73> 2228 0004 46fc
>> 2000 0801 0007 66ff ffff c2ea 598f 4fef ffe8 48d7 78c0 486f
>> Disabling lock debugging due to kernel taint
>>
>> It is trapping at the return from exception (rte) in Lreturn.
>> Looks like it doesn't like the "format" field of the new stack frame
>> for some reason. If I get a few minutes tomorrow I'll dig into it.
>
> Interesting...  What it should get is format 0, same as before the change.

Thats a problem on ColdFire. The format field of the stack frame would
normally be 0x4 for a long-word aligned user stack pointer. The current
start_thread code doesn't set this on the ColdFire/MMU case, though we
do for the non-mmu case. The old code inherited this from the stack
frame of exec calling process.

So I will rework the m68k start_thread() code so it sets it explicitly
for all ColdFire cases.

With this fixed up the new exec code works in all cases I have tested
with ColdFire/MMU then.


> BTW, is there any convenient way to get an emulated coldfire-MMU system?

I only test it on real hardware. But it looks like qemu has coldfire
emulation. I haven't tried it, but as of version 1.0 it listed supported
ColdFire CPU's as:

     m5206
     m5208
     cfv4e

The cfv4e core is capable of having an MMU, so maybe someone is working
on it. I must go and check 1.2.0, it might be better.


> For m68k I'm using aranym with sid/m68k from debian-ports.org and it seems
> to work fine these days, but that obviously won't do for coldfire - neither
> the emulator itself, nor the userland (AFAICS, gcc will happily generate
> instructions that use weird addressing modes unless told not to, so I would
> be extremely surprised if normal debian m68k binaries would run on coldfire,
> MMU or no MMU).

Yeah, no way it will work without the appropriate compiler switches on
when generating even userland binaries.

Regards
Greg


> BTW, the same question goes for many other embedded targets - I'm using
> qemu for arm and mips and hercules for s390; alpha, parisc, ppc32 and sparc64 -
> on actual hardware, amd64 and i386 - on kvm guests (all with debian userland);
> ia64 kinda-sorta works with ski, but it's very much imperfect...  I think
> sh (at least sh4) should be usable with qemu as well, but I hadn't set that
> up yet.  sparc32 is usable on qemu, but only with very old userland.
> Everything else...  In theory, quite a few ought to be usable if one
> bootstraps uclinux userland with qemu, but I've no idea how well does that
> work in practice.  And seeing that e.g. FRV eval boards go for several
> hundred dollars even on ebay, let alone from manufacturer, I'd rather not
> add the actual hardware to the pile here ;-/
>
> What do people actually use?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

