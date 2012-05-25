Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab2EYObH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:31:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20550 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab2EYObE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:31:04 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=TNUJpsPSOZEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=3q-2_YYc-4VQX1cSNzwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337956262.13348.257.camel@gandalf.stny.rr.com>
Subject: BUG - function tracing with breakpoints (was: Re: tracing
 ring_buffer_resize oops.)
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Fri, 25 May 2012 10:31:02 -0400
In-Reply-To: <1337910106.13348.234.camel@gandalf.stny.rr.com>
References: <20120524160146.GA6226@redhat.com>
	 <1337876398.13348.178.camel@gandalf.stny.rr.com>
	 <20120524172223.GA10689@redhat.com>
	 <1337902816.13348.224.camel@gandalf.stny.rr.com>
	 <4FBEC9E6.8040301@linux.intel.com>
	 <1337909963.13348.232.camel@gandalf.stny.rr.com>
	 <1337910106.13348.234.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated status (been up to 2am debugging this :-( )

I did find a missing smp_mb() that could definitely cause issues. But
that alone is not fixing the problem. But it did change it slightly.
Here's a new dump:


[   45.605085] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
[   45.605682] IP: [<ffffffff8220b0c0>] lock_classes+0x3d8c0/0x3dfe20

Not associated with GS anymore. But that is still a data segment.

[   45.605682] PGD 609a3067 PUD 60a7c067 PMD 0 
[   45.605682] Oops: 0002 [#1] PREEMPT SMP 
[   45.605682] Dumping ftrace buffer:
[   45.605682]    (ftrace buffer empty)
[   45.605682] CPU 1
[   45.605682] Modules linked in: sunrpc nf_conntrack_ipv4
nf_defrag_ipv4 ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state
nf_conntrack ip6table_filter ip6_tables binfmt_misc uinput
snd_hda_codec_idt i915 drm_kms_helper snd_hda_intel snd_hda_codec
snd_hwdep snd_seq snd_seq_device snd_pcm drm snd_timer ata_generic snd
firewire_ohci ppdev soundcore i2c_algo_bit firewire_core pata_marvell
i2c_i801 i2c_core snd_page_alloc pata_acpi iTCO_wdt iTCO_vendor_support
microcode crc_itu_t video pcspkr e1000e parport_pc parport [last
unloaded: scsi_wait_scan]
[   45.605682] 
[   45.605682] Pid: 30, comm: kworker/1:1 Not tainted 3.4.0-rc5-test+ #6                  /DG965MQ
[   45.605682] RIP: ae10:[<ffffffff8220b0c0>]  [<ffffffff8220b0c0>] lock_classes+0x3d8c0/0x3dfe20
[   45.605682] RSP: fffffb52:ffffffff816161a9  EFLAGS: ffffffff816161a9
[   45.605682] RAX: ffff88007de08e98 RBX: 00000000000000b4 RCX: ffffffff812f2028
[   45.605682] RDX: 0000000000002e90 RSI: ffffffff810f3270 RDI: ffff88007abd9b20
[   45.605682] RBP: ffff88007de08e88 R08: 0000000000000000 R09: 0000000000000000
[   45.605682] R10: 0000000000000001 R11: 0000000000000001 R12: ffff880077ab0988
[   45.605682] R13: ffff88007d80ae10 R14: ffffffff816161a9 R15: ffffffff816161a9
[   45.605682] FS:  0000000000000000(0000) GS:ffff88007de00000(0000) knlGS:0000000000000000
[   45.605682] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   45.605682] CR2: 0000000000000001 CR3: 00000000762bd000 CR4: 00000000000007e0
[   45.605682] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   45.605682] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   45.605682] Process kworker/1:1 (pid: 30, threadinfo ffff880078a22000, task ffff880077ab0000)
[   45.605682] Stack:
[   45.605682]  8b4c6590666666cc 89480000ba80252c 6348002efbfee8fb ba4fc7c748c689d0

Look at the stack! 8b4c6590666666cc  That has: cc66666690, which is a
ftrace nop with a 'cc' breakpoint on it!

[   45.605682]  fc00d5148b48819b 98a38b4cc0318206 3ee8d18948000000 000b5fe4e800600b
[   45.605682]  df894800000001be 4d8b49ffffc877e8 000004a4958b4108 3100000658b58d49
[   45.605682] Call Trace:
[   45.605682] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 <00> 00 00 00 00 00 00 00 d0 51 7c 82 ff ff ff ff 00 00 00 00 00 
[   45.605682] RIP  [<ffffffff8220b0c0>] lock_classes+0x3d8c0/0x3dfe20
[   45.605682]  RSP <ffffffff816161a9>
[   45.605682] CR2: 0000000000000001

RSP <ffffffff816161a9> which leads to:

(gdb) li *0xffffffff816161a9 
0xffffffff816161a9 is in sub_preempt_count (/work/autotest/nobackup/linux-test.git/kernel/sched/core.c:3070).
3065                    trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
3066    }
3067    EXPORT_SYMBOL(add_preempt_count);
3068
3069    void __kprobes sub_preempt_count(int val)
3070    {
3071    #ifdef CONFIG_DEBUG_PREEMPT
3072            /*
3073             * Underflow?
3074             */


Looks like we set RSP to code. Again pointing to a corrupted iretq.
Maybe we are having nested debug stack usage, where we are hitting a
breakpoint before setting the idt to not change the stack?

-- Steve


