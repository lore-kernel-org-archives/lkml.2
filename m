Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab2K2OWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:22:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46478 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab2K2OWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:22:23 -0500
Date: Thu, 29 Nov 2012 15:22:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ian Kumlien <pomac@vapor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] NULL pointer dereference in 3.7-rc7 (syscall_trace_enter)
Message-ID: <20121129142220.GC30789@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ian Kumlien <pomac@vapor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1354144802.5396.3.camel@pi>
 <20121129092621.GA21100@liondog.tnic>
 <20121129122708.GA6365@pomac.netswarm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121129122708.GA6365@pomac.netswarm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 01:27:08PM +0100, Ian Kumlien wrote:
> I think that chrome does traceing all the time as a part of it's
> sandbox - this is most likely chrome monitoring flash...

Ah, ok.

> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000063
> IP: [<ffffffff8100b64b>] syscall_trace_enter+0x15e/0x191
> PGD 0
> Oops: 0000 [#1] PREEMPT SMP
> Modules linked in: snd_usb_audio snd_usbmidi_lib nouveau mxm_wmi wmi
> i2x_algo_bit ttm drm_kms_helper drm
> CPU 0
> Pid: 24590, comm: chrome Not tainted 3.7.0-rc7 #50 System manufacturer
> System Product Name/A8N32-SLI-Deluxe
> RIP: 0010:[<ffffffff8100b64b>] [<ffffffff8100b64b>]
> syscall_trace_enter+0x15e/0x191
> RSP: 0018:ffff8800058e3f38 EFLAGS: 00010206
> RAX: 0000000000000081 RBX: ffff8800058e3f58 RCX: 0000000000000063
> RDX: 00007fe1f2fbde18 RSI: 00000000000000ca RDI: 00007fe1f2fbde18
> RBP: 0000000000000000 R08: 0000000000000001 R09: 00007fe23f9fcb10
> R10: 00007fe23f9fcb10 R11: 0000000000000206 R12: 0000000000000032
> R13: 00007fe23f9fd9c0 R14: 00007fe25d743710 R15: 0000000000000007
> FS:  00007fe23f9fd700(0000) GS:ffff88013fc00000(0000)
> knlGS:00000000f5c88740
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000063 CR3: 0000000083a84000 CR4: 00000000000007f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process chrome (pid: 24590, threadinfo ffff8800058e2000, task
> ffff88003dacd3b0)
> Stack:
>  00007fe1f2fbde10 0000000000000001 0000000000000032 ffffffff8160646c
>  0000000000000007 00007fe25d743710 00007fe23f9fd9c0 0000000000000032
>  0000000000000001 00007fe1f2fbde10 0000000000000206 00007fe23f9fcb10
> Call Trace:
>  [<ffffffff8160646c>] ? tracesys+0x7e/0xe2
> Code: 53 28 48 85 ff 74 29 83 3f 00 75 24 eb 37 65 48 8b 0c 25 80 b8 00
> 00 48 8b 89 c0 04 00 00 4c 8b 4b 38 48 8b 53 70 48 85 c9 74 08 <83> 39
> 00 74 1f 48 83 ca ff 48 85 ed 75 04 48 8b 53 78 5b 5d 48
> RIP  [<ffffffff8100b64b>] syscall_trace_eneter+0x15e/0x191
>  RSP <ffff8800058e3f38>
> CR2: 0000000000000063

Right, so I can get the code now where it happens, but it is pretty
unreliable to map it to what my compiler generates here (of course,
different compilers and hardware):

Code: 53 28 48 85 ff 74 29 83 3f 00 75 24 eb 37 65 48 8b 0c 25 80 b8 00 00 48 8b 89 c0 04 00 00 4c 8b 4b 38 48 8b 53 70 48 85 c9 74 08 <83> 39 00 74 1f 48 83 ca ff 48 85 ed 75 04 48 8b 53 78 5b 5d 48
All code
========
   0:   53                      push   %rbx
   1:   28 48 85                sub    %cl,-0x7b(%rax)
   4:   ff 74 29 83             pushq  -0x7d(%rcx,%rbp,1)
   8:   3f                      (bad)  
   9:   00 75 24                add    %dh,0x24(%rbp)
   c:   eb 37                   jmp    0x45
   e:   65 48 8b 0c 25 80 b8    mov    %gs:0xb880,%rcx
  15:   00 00 
  17:   48 8b 89 c0 04 00 00    mov    0x4c0(%rcx),%rcx
  1e:   4c 8b 4b 38             mov    0x38(%rbx),%r9
  22:   48 8b 53 70             mov    0x70(%rbx),%rdx
  26:   48 85 c9                test   %rcx,%rcx
  29:   74 08                   je     0x33
  2b:*  83 39 00                cmpl   $0x0,(%rcx)     <-- trapping instruction
  2e:   74 1f                   je     0x4f
  30:   48 83 ca ff             or     $0xffffffffffffffff,%rdx
  34:   48 85 ed                test   %rbp,%rbp
  37:   75 04                   jne    0x3d
  39:   48 8b 53 78             mov    0x78(%rbx),%rdx
  3d:   5b                      pop    %rbx
  3e:   5d                      pop    %rbp
  3f:   48                      rex.W

So we oops when we try to deref 0x63 which is, of course, not a valid
pointer. The question is, what exactly is that thing in rcx. It looks
like a percpu variable to me but I'm not sure.

Can you do:

make arch/x86/kernel/ptrace.lst

and send me that file, privately is fine too.

Thanks.

-- 
Regards/Gruss,
    Boris.
