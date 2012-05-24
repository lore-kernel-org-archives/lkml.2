Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099Ab2EXXkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 19:40:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3788 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab2EXXkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 19:40:18 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=irseqbIK9hsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=CxmBBH5uRkQnLlwNU14A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337902816.13348.224.camel@gandalf.stny.rr.com>
Subject: Re: tracing ring_buffer_resize oops.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 24 May 2012 19:40:16 -0400
In-Reply-To: <20120524172223.GA10689@redhat.com>
References: <20120524160146.GA6226@redhat.com>
	 <1337876398.13348.178.camel@gandalf.stny.rr.com>
	 <20120524172223.GA10689@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 13:22 -0400, Dave Jones wrote:

I found a clue!


> [ 1013.243754] BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
> [ 1013.272665] IP: [<ffff880145cc0000>] 0xffff880145cbffff
> [ 1013.285186] PGD 1401b2067 PUD 14324c067 PMD 0 
> [ 1013.298832] Oops: 0010 [#1] PREEMPT SMP 
> [ 1013.310600] CPU 2 
> [ 1013.317904] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clmulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vendor_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
> [ 1013.401848] 
> [ 1013.407399] Pid: 112, comm: kworker/2:1 Not tainted 3.4.0+ #30 
> [ 1013.437943] RIP: 8eb8:[<ffff88014630a000>]  [<ffff88014630a000>] 0xffff880146309fff

RIP is always near the GS segment. As GS points to the per_cpu area, we
may somehow be getting our GS screwed up. I'm not sure why that would
affect the RIP. Maybe stacks are not being processed properly somewhere?

It's strange because I can either trigger it on the first try, or it
never triggers at all??


> [ 1013.459871] RSP: ffffffff8165e919:ffff88014780f408  EFLAGS: 00010046
> [ 1013.477909] RAX: 0000000000000001 RBX: ffffffff81104020 RCX: 0000000000000000
> [ 1013.499458] RDX: ffff880148008ea8 RSI: ffffffff8131ef40 RDI: ffffffff82203b20
> [ 1013.521612] RBP: ffffffff81005751 R08: 0000000000000000 R09: 0000000000000000
> [ 1013.543121] R10: ffffffff82cdc318 R11: 0000000000000000 R12: ffff880145cc0000
> [ 1013.564614] R13: ffff880148008eb8 R14: 0000000000000002 R15: ffff88014780cb40
> [ 1013.586108] FS:  0000000000000000(0000) GS:ffff880148000000(0000) knlGS:0000000000000000

Your GS is ffff880148000000 and the RIP was: <ffff880145cc0000>

Here's some of the crashes I've had:

RIP: ffff88007dc042a0	GS:ffff88007e200000

RIP: ffff88007de08ea8	GS:ffff88007de00000

Interesting, the above is one of the few that the RIP is greater than GS.

RIP: ffff88007dc042a0	GS:ffff88007e280000

RIP: ffff88007dc042a0	GS:ffff88007e280000

The above are the same but two different runs, actually, a third run had
the same as well.

Dave, I'm looking into your other issue (irqsoff), that looks totally
unrelated.

Andi and Peter, to bring you up to speed, we are getting this very
strange crash when enabling function tracing. At first it looked like a
kernel compiler issue as after doing a make clean the problem went away.
But I've now done two make cleans and have had the build still produce
the error. But it either errors on the first instantiation of the
function tracer or it never errors on it. Well, that's not totally true.
I do have the ftrace start up tests enabled so the function tracer is
enabled on boot up for testing. But that never seems to error. Only when
the system is live does it produce this error.

Now this code now has the new "breakpoint" logic. That is, instead of
running stop machine, it adds a break point to the first byte of the
nop, does a IPI to all CPUS (to sync), modify the rest of the nop, send
IPI, and then remove the break point.

But on some boxes, this crashes. But the symptom is always the same. The
RIP is that of something similar to the GS. Perhaps we have a stack
mismatch? But this still doesn't make sense, as the GS is never saved on
the stack.

Any ideas?

-- Steve



> [ 1013.609458] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1013.627420] CR2: 0000000000000002 CR3: 0000000141f10000 CR4: 00000000001407e0
> [ 1013.649051] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1013.670724] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1013.692376] Process kworker/2:1 (pid: 112, threadinfo ffff88013fe0e000, task ffff88014020a6a0)
> [ 1013.717028] Stack:
> [ 1013.724131]  ffff88014780f570 ffff880145cc0000 0000400000004000 0000000000000000
> [ 1013.745918]  cccccccccccccccc ffff88014780cca8 ffffffff811072bb ffffffff81651627
> [ 1013.767870]  ffffffff8118f8a7 ffffffff811072bb ffffffff81f2b6c5 ffffffff81f11bdb
> [ 1013.790021] Call Trace:
> [ 1013.800701] Code: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a <e7> d7 64 81 ff ff ff ff 01 00 00 00 00 00 00 00 65 d9 64 81 ff 
> [ 1013.861443] RIP  [<ffff88014630a000>] 0xffff880146309fff
> [ 1013.884466]  RSP <ffff88014780f408>
> [ 1013.901507] CR2: 0000000000000002
> [ 1013.918628] ---[ end trace d0e6e5741aaf56ac ]---
> [ 1013.940297] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
> [ 1013.972340] in_atomic(): 0, irqs_disabled(): 1, pid: 112, name: kworker/2:1
> [ 1014.001470] INFO: lockdep is turned off.
> [ 1014.021285] irq event stamp: 146784
> [ 1014.039375] hardirqs last  enabled at (146783): [<ffffffff8165b4f4>] paranoid_restore+0x10/0x66
> [ 1014.074744] hardirqs last disabled at (146784): [<ffffffff8165b380>] int3+0x10/0x40
> [ 1014.106164] softirqs last  enabled at (146418): [<ffffffff81052054>] __do_softirq+0x144/0x3d0
> [ 1014.141604] softirqs last disabled at (146407): [<ffffffff81663e4c>] call_softirq+0x1c/0x30
> [ 1014.174829] Pid: 112, comm: kworker/2:1 Tainted: G      D      3.4.0+ #30
> [ 1014.204753] Call Trace:
> [ 1014.220719]  <#DB>  [<ffffffff810b3eb0>] ? print_irqtrace_events+0xd0/0xe0
> [ 1014.251033]  [<ffffffff8107f5c0>] __might_sleep+0x140/0x1f0
> [ 1014.276482]  [<ffffffff81657fc6>] down_read+0x26/0x93
> [ 1014.301499]  [<ffffffff810624e4>] exit_signals+0x24/0x130
> [ 1014.326264]  [<ffffffff8104e95c>] do_exit+0xbc/0xb70
> [ 1014.348709]  [<ffffffff8104b8b3>] ? kmsg_dump+0x83/0x2b0
> [ 1014.373726]  [<ffffffff8164d5e3>] ? printk+0x61/0x63
> [ 1014.396878]  [<ffffffff8165c007>] oops_end+0x97/0xe0
> [ 1014.420306]  [<ffffffff8164cece>] no_context+0x258/0x283
> [ 1014.446640]  [<ffffffff8164d0bd>] __bad_area_nosemaphore+0x1c4/0x1e3
> [ 1014.474615]  [<ffffffff8164d0ef>] bad_area_nosemaphore+0x13/0x15
> [ 1014.505249]  [<ffffffff8165e540>] do_page_fault+0x3c0/0x4b0
> [ 1014.531368]  [<ffffffff8106f708>] ? __kernel_text_address+0x58/0x80
> [ 1014.560247]  [<ffffffff810057cf>] ? print_context_stack+0x8f/0xf0
> [ 1014.589070]  [<ffffffff810860f1>] ? get_parent_ip+0x11/0x50
> [ 1014.614948]  [<ffffffff8165b613>] ? error_sti+0x5/0x6
> [ 1014.641105]  [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
> [ 1014.671882]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
> [ 1014.700148]  [<ffffffff8131ac5d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [ 1014.730928]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
> [ 1014.759028]  [<ffffffff8165b42f>] page_fault+0x1f/0x30
> [ 1014.784924]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0
> [ 1014.812910]  [<ffffffff81104020>] ? __add_hash_entry+0x90/0x90
> [ 1014.840108]  [<ffffffff8131ef40>] ? bsearch+0x60/0x90
> [ 1014.864867]  [<ffffffff81104020>] ? __add_hash_entry+0x90/0x90
> [ 1014.891647]  [<ffffffff8165e919>] ? sub_preempt_count+0x9/0xd0
> [ 1014.918212]  [<ffffffff8165b466>] ? paranoid_exit+0x6/0x1b
> [ 1014.942506]  [<ffffffff810b0b38>] ? trace_hardirqs_off_caller+0x28/0xc0
> [ 1014.971053]  [<ffffffff8131ac5d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [ 1014.999788]  [<ffffffff81104020>] ? __add_hash_entry+0x90/0x90
> [ 1015.026354]  [<ffffffff8165e919>] ? sub_preempt_count+0x9/0xd0
> [ 1015.052818]  [<ffffffff8165b466>] ? paranoid_exit+0x6/0x1b
> [ 1015.077099]  [<ffffffff81005751>] ? print_context_stack+0x11/0xf0

