Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab1GAKBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 06:01:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:41094 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab1GAKBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 06:01:31 -0400
Message-ID: <4E0D9B5E.3010901@windriver.com>
Date: Fri, 1 Jul 2011 18:03:10 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: <ananth@in.ibm.com>, Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, <paulus@samba.org>,
        <yrl.pp-manager.tt@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [BUG?]3.0-rc4+ftrace+kprobe: set kprobe at instruction 'stwu'
 lead to system crash/freeze
References: <BANLkTi=gx73d6-s-jqeke05SQYorpnzLVw@mail.gmail.com>	<1308911347.531.56.camel@gandalf.stny.rr.com>	<4E074671.7060100@hitachi.com> <20110627100104.GA24705@in.ibm.com> <BANLkTimYej4_dmBqvPBCLej=JA5atLrZVA@mail.gmail.com>
In-Reply-To: <BANLkTimYej4_dmBqvPBCLej=JA5atLrZVA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang wrote:
> On Mon, Jun 27, 2011 at 6:01 PM, Ananth N Mavinakayanahalli
> <ananth@in.ibm.com> wrote:
>> On Sun, Jun 26, 2011 at 11:47:13PM +0900, Masami Hiramatsu wrote:
>>> (2011/06/24 19:29), Steven Rostedt wrote:
>>>> On Fri, 2011-06-24 at 17:21 +0800, Yong Zhang wrote:
>>>>> Hi,
>>>>>
>>>>> When I use kprobe to do something, I found some wired thing.
>>>>>
>>>>> When CONFIG_FUNCTION_TRACER is disabled:
>>>>> (gdb) disassemble do_fork
>>>>> Dump of assembler code for function do_fork:
>>>>>    0xc0037390 <+0>:        mflr    r0
>>>>>    0xc0037394 <+4>:        stwu    r1,-64(r1)
>>>>>    0xc0037398 <+8>:        mfcr    r12
>>>>>    0xc003739c <+12>:       stmw    r27,44(r1)
>>>>>
>>>>> Then I:
>>>>> modprobe kprobe_example func=do_fork offset=4
>>>>> ls
>>>>> Things works well.
>>>>>
>>>>> But when CONFIG_FUNCTION_TRACER is enabled:
>>>>> (gdb) disassemble do_fork
>>>>> Dump of assembler code for function do_fork:
>>>>>    0xc0040334 <+0>:        mflr    r0
>>>>>    0xc0040338 <+4>:        stw     r0,4(r1)
>>>>>    0xc004033c <+8>:        bl      0xc00109d4 <mcount>
>>>>>    0xc0040340 <+12>:       stwu    r1,-80(r1)
>>>>>    0xc0040344 <+16>:       mflr    r0
>>>>>    0xc0040348 <+20>:       stw     r0,84(r1)
>>>>>    0xc004034c <+24>:       mfcr    r12
>>>>> Then I:
>>>>> modprobe kprobe_example func=do_fork offset=12
>>>>> ls
>>>>> 'ls' will never retrun. system freeze.
>>>> I'm not sure if x86 had a similar issue.
>>>>
>>>> Masami, have any ideas to why this happened?
>>> No, I don't familiar with ppc implementation. I guess
>>> that single-step resume code failed to emulate the
>>> instruction, but it strongly depends on ppc arch.
>>> Maybe IBM people may know what happened.
>>>
>>> Ananth, Jim, would you have any ideas?
>> On powerpc, we emulate sstep whenever possible. Only recently support to
>> emulate loads and stores got added. I don't have access to a powerpc box
>> today... but will try to recreate the problem ASAP and see what could be
>> happening in the presence of mcount.
> 
> After taking more testing on it, it looks like the issue doesn't
> depend on mcount
> (AKA. CONFIG_FUNCTION_TRACER)
> 
> As I said in the first email, with eldk-5.0 CONFIG_FUNCTION_TRACER=n
> will work well.
> 
> But when I'm using eldk-4.2[1], both will fail. But the funny thing is when I
> set kprobe at several functions some works fine but some will fail. For example,
> at this time do_fork() works well, but show_interrupt() will crash.
> 
> root@unknown:/root> insmod kprobe_example.ko func=show_interrupts
> Planted kprobe at c009be18
> root@unknown:/root> cat /proc/interrupts
> pre_handler: p->addr = 0xc009be18, nip = 0xc009be18, msr = 0x29000
> post_handler: p->addr = 0xc009be18, msr = 0x29000,boostable = 1
> Oops: Exception in kernel mode, sig: 11 [#1]
> PREEMPT MPC8536 DS
> Modules linked in: kprobe_example
> NIP: df159e74 LR: c0106f40 CTR: c009be18
> REGS: df159d90 TRAP: 0700   Not tainted  (3.0.0-rc4-00001-ge8ffcca-dirty)
> MSR: 00029000 <EE,ME,CE>  CR: 20202688  XER: 00000000
> TASK = dfaa5340[613] 'cat' THREAD: df158000
> GPR00: fffff000 df159e40 dfaa5340 df024a00 df159e78 00000000 df159f20 00000001
> GPR08: c10060d0 c009be18 00029000 df159e70 00000000 1001ca74 1ffb5f00 100a01cc
> GPR16: 00000000 00000000 00000000 00000000 df024a28 df159f20 00000000 dfbff080
> GPR24: 10016000 00001000 df159f20 df159e78 dfbff080 df159e78 df024a00 df159e70
> NIP [df159e74] 0xdf159e74
> LR [c0106f40] seq_read+0x2a4/0x568
> Call Trace:
> [df159e40] [00029000] 0x29000 (unreliable)
> [df159e74] [00000000]   (null)
> Instruction dump:
> XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
> XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
> ---[ end trace 60026bfc1fe79aed ]---
> Segmentation fault

Maybe I can understand this problem.

When we kprobe these operations such as store-and-update-word for SP(r1),

stwu r1, -A(r1)

The program exception is triggered then PPC always allocate an exception frame
as shown as the follows:

old r1 --------
	 ...
         nip
         gpr[2]~gpr[31]
         gpr[1] <--------- old r1 is stored here.
	 gpr[0]
       -------- <-- pr_regs @offset 16 bytes
       padding
       STACK_FRAME_REGS_MARKER
       LR
       back chain
new r1 --------

Here emulate_step() is called to emulate 'stwu'. Actually this is equivalent to
1> update pr_regs->gpr[1] = mem(old r1 + (-A))
2> 'stw <old r1>, mem<(old r1 + (-A)) >

You should notice the stack based on new r1 would be covered with mem<old r1
+(-A)>. So after this, the kernel exit from post_krpobe, something would be
broken. This should depend on sizeof(-A).

For kprobe show_interrupts, you can see pregs->nip is re-written violently so
kernel issued.

But sometimes we may only re-write some violate registers the kernel still
alive. And so this is just why the kernel works well for some kprobed point
after you change some kernel options/toolchains.

If I'm correct its difficult to kprobe these stwu sp operation since the
sizeof(-A) is undermined for the kernel. So we have to implement in-depend
interrupt stack like PPC64.

Tiejun

> 
> Thanks,
> Yong
> 
> [1]: http://ftp.denx.de/pub/eldk/4.2/
> 

