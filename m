Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1GDCX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 22:23:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61440 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1GDCX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 22:23:26 -0400
MIME-Version: 1.0
In-Reply-To: <4E0D9B5E.3010901@windriver.com>
References: <BANLkTi=gx73d6-s-jqeke05SQYorpnzLVw@mail.gmail.com>
	<1308911347.531.56.camel@gandalf.stny.rr.com>
	<4E074671.7060100@hitachi.com>
	<20110627100104.GA24705@in.ibm.com>
	<BANLkTimYej4_dmBqvPBCLej=JA5atLrZVA@mail.gmail.com>
	<4E0D9B5E.3010901@windriver.com>
Date: Mon, 4 Jul 2011 10:23:25 +0800
Message-ID: <CAM2zO=AO2bxvBgZopZAkhhr++VNby9MvvLv-dae8t=QUu8_C0w@mail.gmail.com>
Subject: Re: [BUG?]3.0-rc4+ftrace+kprobe: set kprobe at instruction 'stwu'
 lead to system crash/freeze
From: Yong Zhang <yong.zhang0@gmail.com>
To: "tiejun.chen" <tiejun.chen@windriver.com>
Cc: ananth@in.ibm.com, Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, paulus@samba.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 6:03 PM, tiejun.chen <tiejun.chen@windriver.com> wrote:
>> root@unknown:/root> insmod kprobe_example.ko func=show_interrupts
>> Planted kprobe at c009be18
>> root@unknown:/root> cat /proc/interrupts
>> pre_handler: p->addr = 0xc009be18, nip = 0xc009be18, msr = 0x29000
>> post_handler: p->addr = 0xc009be18, msr = 0x29000,boostable = 1
>> Oops: Exception in kernel mode, sig: 11 [#1]
>> PREEMPT MPC8536 DS
>> Modules linked in: kprobe_example
>> NIP: df159e74 LR: c0106f40 CTR: c009be18
>> REGS: df159d90 TRAP: 0700   Not tainted  (3.0.0-rc4-00001-ge8ffcca-dirty)
>> MSR: 00029000 <EE,ME,CE>  CR: 20202688  XER: 00000000
>> TASK = dfaa5340[613] 'cat' THREAD: df158000
>> GPR00: fffff000 df159e40 dfaa5340 df024a00 df159e78 00000000 df159f20 00000001
>> GPR08: c10060d0 c009be18 00029000 df159e70 00000000 1001ca74 1ffb5f00 100a01cc
>> GPR16: 00000000 00000000 00000000 00000000 df024a28 df159f20 00000000 dfbff080
>> GPR24: 10016000 00001000 df159f20 df159e78 dfbff080 df159e78 df024a00 df159e70
>> NIP [df159e74] 0xdf159e74
>> LR [c0106f40] seq_read+0x2a4/0x568
>> Call Trace:
>> [df159e40] [00029000] 0x29000 (unreliable)
>> [df159e74] [00000000]   (null)
>> Instruction dump:
>> XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>> XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX
>> ---[ end trace 60026bfc1fe79aed ]---
>> Segmentation fault
>
> Maybe I can understand this problem.
>
> When we kprobe these operations such as store-and-update-word for SP(r1),
>
> stwu r1, -A(r1)
>
> The program exception is triggered then PPC always allocate an exception frame
> as shown as the follows:
>
> old r1 --------
>         ...
>         nip
>         gpr[2]~gpr[31]
>         gpr[1] <--------- old r1 is stored here.
>         gpr[0]
>       -------- <-- pr_regs @offset 16 bytes
>       padding
>       STACK_FRAME_REGS_MARKER
>       LR
>       back chain
> new r1 --------
>
> Here emulate_step() is called to emulate 'stwu'. Actually this is equivalent to
> 1> update pr_regs->gpr[1] = mem(old r1 + (-A))
> 2> 'stw <old r1>, mem<(old r1 + (-A)) >
>
> You should notice the stack based on new r1 would be covered with mem<old r1
> +(-A)>. So after this, the kernel exit from post_krpobe, something would be
> broken. This should depend on sizeof(-A).
>
> For kprobe show_interrupts, you can see pregs->nip is re-written violently so
> kernel issued.

Yeah, my debug also show this, so this is the root cause.
Thanks for your explanation.

>
> But sometimes we may only re-write some violate registers the kernel still
> alive. And so this is just why the kernel works well for some kprobed point
> after you change some kernel options/toolchains.
>
> If I'm correct its difficult to kprobe these stwu sp operation since the
> sizeof(-A) is undermined for the kernel. So we have to implement in-depend
> interrupt stack like PPC64.

Hmmm, a dedicated exception stack will smooth the concern IMHO,
Ben, Kuma?

Thanks,
Yong


-- 
Only stand for myself
