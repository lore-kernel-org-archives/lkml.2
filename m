Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab1F2Glu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 02:41:50 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33100 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab1F2Glp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 02:41:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110628104128.GA4310@in.ibm.com>
References: <BANLkTi=gx73d6-s-jqeke05SQYorpnzLVw@mail.gmail.com>
	<1308911347.531.56.camel@gandalf.stny.rr.com>
	<4E074671.7060100@hitachi.com>
	<20110627100104.GA24705@in.ibm.com>
	<20110628104128.GA4310@in.ibm.com>
Date: Wed, 29 Jun 2011 14:41:44 +0800
Message-ID: <BANLkTikqXYWBzj9LgrRrN=iGhtAU0xzvXg@mail.gmail.com>
Subject: Re: [BUG?]3.0-rc4+ftrace+kprobe: set kprobe at instruction 'stwu'
 lead to system crash/freeze
From: Yong Zhang <yong.zhang0@gmail.com>
To: ananth@in.ibm.com
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, paulus@samba.org,
        yrl.pp-manager.tt@hitachi.com, linuxppc-dev@lists.ozlabs.org,
        galak@kernel.crashing.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 6:41 PM, Ananth N Mavinakayanahalli
<ananth@in.ibm.com> wrote:
>
> My access to a 32bit powerpc box is very limited. Also, embedded powerpc
> has had issues with gcc-4.6 while gcc-4.5 worked fine.

I think I can do some test if you have any ideas :)

>
>> > > I'm not sure if x86 had a similar issue.
>> > >
>> > > Masami, have any ideas to why this happened?
>> >
>> > No, I don't familiar with ppc implementation. I guess
>> > that single-step resume code failed to emulate the
>> > instruction, but it strongly depends on ppc arch.
>> > Maybe IBM people may know what happened.
>> >
>> > Ananth, Jim, would you have any ideas?
>>
>> On powerpc, we emulate sstep whenever possible. Only recently support to
>> emulate loads and stores got added. I don't have access to a powerpc box
>> today... but will try to recreate the problem ASAP and see what could be
>> happening in the presence of mcount.
>
> I tried to recreate this problem on a 64-bit pSeries box without
> success. Every one of the instructions in the stream at .do_fork are
> emulated and work fine there -- no hangs/crashes with or without
> function tracer.
>
> Yong,
> I am copying Kumar to see if he knows of any issues with 32-bit kprobes
> (he wrote it) or with the function tracer, or with the toolchain itself.
>
> You may want to check if, in the failure case, the instruction in
> question is single-stepped or emulated (print out the value of
> kprobe->ainsn.boostable in the post_handler)

It's emulated:
root@unknown:/root> insmod kprobe_example.ko func=show_interrupts
Planted kprobe at c009be18
root@unknown:/root> cat /proc/interrupts
pre_handler: p->addr = 0xc009be18, nip = 0xc009be18, msr = 0x29000
post_handler: p->addr = 0xc009be18, msr = 0x29000,boostable = 1

Since commit 0016a4cf5582415849fafbf9f019dd9530824789 almost all
of the instructions are emulated.

But if we disable the emulation of stwu(so let single-stepped take it) like
below:
diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index 9a52349..07f0d4a 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1486,7 +1486,7 @@ int __kprobes emulate_step(struct pt_regs *regs,
unsigned int instr)
 		goto ldst_done;

 	case 36:	/* stw */
-	case 37:	/* stwu */
+	//case 37:	/* stwu */
 		val = regs->gpr[rd];
 		err = write_mem(val, dform_ea(instr, regs), 4, regs);
 		goto ldst_done;

The system will crash after single-step(looks
like the stack is currupted from the preempt_count value of
'cat/617/0x0000020a'):

pre_handler: p->addr = 0xc00ab12c, nip = 0xc00ab12c, msr = 0x29000
post_handler: p->addr = 0xc00ab12c, msr = 0x1000,boostable = -1
pre_handler: p->addr = 0xc00ab12c, nip = 0xc00ab12c, msr = 0x29000
post_handler: p->addr = 0xc00ab12c, msr = 0x1000,boostable = -1
BUG: scheduling while atomic: cat/617/0x0000020a
Modules linked in: kprobe_example [last unloaded: kprobe_example]
Call Trace:
[df157e90] [c00087c0] show_stack+0x98/0x1e4 (unreliable)
[df157ee0] [c0008938] dump_stack+0x2c/0x44
[df157ef0] [c00377c0] __schedule_bug+0x6c/0x84
[df157f00] [c060a364] schedule+0x398/0x48c
[df157f40] [c00107f4] recheck+0x0/0x24
--- Exception: c01 at 0xff1bbb8
    LR = 0x1000310c
Page fault in user mode with in_atomic() = 1 mm = df01c700
NIP = ff29314  MSR = 2d000
Oops: Weird page fault, sig: 11 [#1]
PREEMPT MPC8536 DS
Modules linked in: kprobe_example [last unloaded: kprobe_example]
NIP: 0ff29314 LR: 10001944 CTR: 0ff29314
REGS: df157f50 TRAP: 0401   Tainted: G        W
(3.0.0-rc4-00001-ge8ffcca-dirty)
MSR: 0002d000 <EE,PR,ME,CE>  CR: 88202682  XER: 20000000
TASK = df237190[617] 'cat' THREAD: df156000
GPR00: 100018b4 bfb5c060 48007ee0 00000000 0000000e 10004354 bfb5ccde 0ff1af28
GPR08: 0202d000 48000ee8 00000000 0ff29314 1000192c
NIP [0ff29314] 0xff29314
LR [10001944] 0x10001944
Call Trace:
Kernel panic - not syncing: Fatal exception in interrupt
Call Trace:
[df157da0] [c00087c0] show_stack+0x98/0x1e4 (unreliable)
[df157df0] [c0008938] dump_stack+0x2c/0x44
[df157e00] [c0042a80] panic+0xc4/0x1f4
[df157e60] [c000c4e0] die+0x1fc/0x22c
[df157e90] [c060e4a4] do_page_fault+0x130/0x4c4
[df157f40] [c00100fc] handle_page_fault+0xc/0x80
--- Exception: 401 at 0xff29314
    LR = 0x10001944

Thanks,
Yong


-- 
Only stand for myself
