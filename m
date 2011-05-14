Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467Ab1ENXgr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 19:36:47 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36335 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab1ENXgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 19:36:45 -0400
Date: Sun, 15 May 2011 01:36:09 +0200
From: Borislav Petkov <bp@amd64.org>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
        Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.38.6 -stable regression: kernel insta-death on boot.
Message-ID: <20110514233609.GA6850@aftab>
References: <20110514195741.GA10757@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110514195741.GA10757@elliptictech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 03:57:42PM -0400, Nick Bowler wrote:
> 2.6.38.6 panics almost immediately on boot.  2.6.38.3 works fine.  Full
> kernel log and bisection results follow.  Reverting the implicated
> commit corrects the issue.
> 
> This system has a really old (circa 2004) Athlon64 CPU, and has worked fine
> until today.

Yeah, you damn right it's old! :)

>   general protection fault: 0000 [#1] PREEMPT
>   last sysfs file:
>   CPU 0
>   Modules linked in:
> 
>   Pid: 0, comm: swapper Not tainted 2.6.38.6 #1 ASUSTek Computer Inc. K8N-E-Deluxe/'K8N-E-Deluxe'
>   RIP: 0010:[<ffffffff81008f76>]  [<ffffffff81008f76>] c1e_idle+0x2e/0xde
>   RSP: 0018:ffffffff813e1ef8  EFLAGS: 00010046
>   RAX: 0000000400000000 RBX: ffffffff813e0000 RCX: 00000000c0010055
>   RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff814970e8
>   RBP: ffffffff813e1f18 R08: 0000000000000000 R09: ffffffff810f39b8
>   R10: ffff88003e05dc40 R11: ffff88003e077868 R12: 6db6db6db6db6db7
>   R13: ffff88003ffba740 R14: ffffffffffffffff R15: 0000000000000000
>   FS:  0000000000000000(0000) GS:ffffffff813fa000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>   CR2: 0000000000000000 CR3: 00000000013ea000 CR4: 00000000000006f0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>   Process swapper (pid: 0, threadinfo ffffffff813e0000, task ffffffff813f2040)
>   Stack:
>    ffffffff813e1f08 ffffffff81041a6b ffffffff813e1f18 ffffffff813e0000
>    ffffffff813e1f38 ffffffff81001155 ffffffffffffffff ffffffff813e0000
>    ffffffff813e1f58 ffffffff812d1bf4 ffffffff813e1f58 0000000000000000
>   Call Trace:
>    [<ffffffff81041a6b>] ? atomic_notifier_call_chain+0xf/0x11
>    [<ffffffff81001155>] cpu_idle+0x37/0x56
>    [<ffffffff812d1bf4>] rest_init+0x88/0x8c
>    [<ffffffff8143dab1>] start_kernel+0x31c/0x327
>    [<ffffffff8143d2a6>] x86_64_start_reservations+0xb6/0xba
>    [<ffffffff8143d3a1>] x86_64_start_kernel+0xf7/0xfe
>   Code: 04 25 48 90 3f 81 48 89 e5 53 48 83 ec 18 48 8b 80 38 e0 ff ff a8 08 0f 85 b7 00 00 00 80 3d b1 f7 48 00 00 75 3e b9 55 00 01 c0 <0f> 32 a9 00 00 00 18 74 30 48 8b 05 56 02 43 00 c6 05 93 f7 48
>   RIP  [<ffffffff81008f76>] c1e_idle+0x2e/0xde
>    RSP <ffffffff813e1ef8>
>   ---[ end trace 6d450e935ee1897c ]---

According to the opcode stream, your machine is #GPing when doing a
rdmsr on the HWCR MSR:

$ ./scripts/decodecode < /tmp/nick_fowler.oops
Code: 04 25 48 90 3f 81 48 89 e5 53 48 83 ec 18 48 8b 80 38 e0 ff ff a8 08 0f 85 b7 00 00 00 80 3d b1 f7 48 00 00 75 3e b9 55 00 01 c0 <0f> 32 a9 00
All code
========
   0:   04 25                   add    $0x25,%al
   2:   48 90                   rex.W nop
   4:   3f                      (bad)  
   5:   81 48 89 e5 53 48 83    orl    $0x834853e5,-0x77(%rax)
   c:   ec                      in     (%dx),%al
   d:   18 48 8b                sbb    %cl,-0x75(%rax)
  10:   80 38 e0                cmpb   $0xe0,(%rax)
  13:   ff                      (bad)  
  14:   ff a8 08 0f 85 b7       ljmpq  *-0x487af0f8(%rax)
  1a:   00 00                   add    %al,(%rax)
  1c:   00 80 3d b1 f7 48       add    %al,0x48f7b13d(%rax)
  22:   00 00                   add    %al,(%rax)
  24:   75 3e                   jne    0x64
  26:   b9 55 00 01 c0          mov    $0xc0010055,%ecx
  2b:*  0f 32                   rdmsr       <-- trapping instruction
  2d:   a9                      .byte 0xa9
        ...

Code starting with the faulting instruction
===========================================
   0:   0f 32                   rdmsr  
   2:   a9                      .byte 0xa9


And this is because the enlarging of the erratum 400 interval which the
commit you bisected to does, forces your machine to use the special C1E
routine, which, however, barfs due to the fact that your CPU might not
have that MSR defined - it is _that_ old.

Just to verify, can you go to http://codemonkey.org.uk/projects/x86info/,
checkout the git repository, do

$ make

and then

$ ./x86info -a

as root, catch the whole output and send it to me please.

Alternatively, you could send me /proc/cpuinfo if you can't manage to
get the x86info output for some reason.

>   Kernel panic - not syncing: Attempted to kill the idle task!
>   Pid: 0, comm: swapper Tainted: G      D     2.6.38.6 #1
>   Call Trace:
>    [<ffffffff812d83fd>] ? panic+0x9a/0x195
>    [<ffffffff8102ab81>] ? do_exit+0x6c/0x660
>    [<ffffffff81029480>] ? kmsg_dump+0xe9/0xf9
>    [<ffffffff81005bd7>] ? oops_end+0x9d/0xa5
>    [<ffffffff81005d0d>] ? die+0x55/0x5e
>    [<ffffffff81003bb4>] ? do_general_protection+0x129/0x131
>    [<ffffffff812da7df>] ? general_protection+0x1f/0x30
>    [<ffffffff810f39b8>] ? rb_insert_color+0xb8/0xe1
>    [<ffffffff81008f76>] ? c1e_idle+0x2e/0xde
>    [<ffffffff81041a6b>] ? atomic_notifier_call_chain+0xf/0x11
>    [<ffffffff81001155>] ? cpu_idle+0x37/0x56
>    [<ffffffff812d1bf4>] ? rest_init+0x88/0x8c
>    [<ffffffff8143dab1>] ? start_kernel+0x31c/0x327
>    [<ffffffff8143d2a6>] ? x86_64_start_reservations+0xb6/0xba
>    [<ffffffff8143d3a1>] ? x86_64_start_kernel+0xf7/0xfe
> 
>   15f0758f185241ad9c358a5bf60ff0a21eccc218 is the first bad commit
>   commit 15f0758f185241ad9c358a5bf60ff0a21eccc218
>   Author: Boris Ostrovsky <ostr@amd64.org>
>   Date:   Fri Apr 29 17:47:43 2011 -0400
> 
>       x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors

Btw, thanks for bisecting this, good job!

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
