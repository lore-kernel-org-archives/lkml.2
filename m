Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab2E3OtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:49:03 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:49278
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510Ab2E3OtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:49:01 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2dI9371I148cI1432N98dKzz1202hzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M4UBTH-02-709-02
X-M-MSG: 
Date: Wed, 30 May 2012 09:48:51 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Andre Przywara <andre.przywara@amd.com>
CC: Jan Beulich <JBeulich@suse.com>, <mingo@elte.hu>, <jeremy@goop.org>,
        <tglx@linutronix.de>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120530144851.GA12184@jshin-Toonie>
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC63DAF0200007800086DC5@nat28.tlf.novell.com>
 <4FC62888.9010407@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FC62888.9010407@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 04:02:48PM +0200, Andre Przywara wrote:
> On 05/30/2012 03:33 PM, Jan Beulich wrote:
> >>>>On 30.05.12 at 15:10, Andre Przywara<andre.przywara@amd.com>  wrote:
> >>Because we are behind a family check before tweaking the topology
> >>bit, we can use the standard rd/wrmsr variants for the CPUID feature
> >>register.
> >>This fixes a crash when using the kernel as a Xen Dom0 on affected
> >>Trinity systems. The wrmsrl_amd_safe is not properly paravirtualized
> >>yet (this will be fixed in another patch).
> >
> >I'm not following: If the AMD variants (putting a special value into
> >%edi) can be freely replaced by the non-AMD variants, why did
> >the AMD special ones get used in the first place?
> 
> Older CPUs (K8) needed the AMD variants, starting with family 10h we
> can use the normal versions.
> 
> >Further, I can't see how checking_wrmsrl() is being paravirtualized
> >any better than wrmsrl_amd_safe() - both have nothing but an
> >exception handling fixup attached to the wrmsr invocation. Care
> >to point out what actual crash it is that was seen?
> 
> AFAIK, the difference is between the "l" and the regs version for
> rd/wrmsr. We have a patch already here to fix this. Will send it out
> soon. Jacob, can you comment on this?

Right, the checking_wrmsrl turns into wrmsr_safe which is paravirtualized
but the rdmsrl_amd_safe which turns into rdmsr_regs is not paravirtualized
by enlighten.

> 
> The crash dump:
> 
> [    1.601021] ------------[ cut here ]------------
> [    1.601025] kernel BUG at
> /buildrepos/linux-2.6-stable/arch/x86/include/asm/paravirt.h:133!
> [    1.601031] invalid opcode: 0000 [#1] SMP
> [    1.601038] CPU 0
> [    1.601041] Modules linked in:
> [    1.601047]
> [    1.601050] Pid: 0, comm: swapper/0 Not tainted 3.4.0 #1 AMD
> Virgo Platform/Annapurna
> [    1.601061] RIP: e030:[<ffffffff8169b4fe>]  [<ffffffff8169b4fe>]
> init_amd+0x21d/0x603
> [    1.601072] RSP: e02b:ffffffff81c01df8  EFLAGS: 00010246
> [    1.601076] RAX: 0000000000000000 RBX: ffffffff81ca7500 RCX:
> 0000000000000000
> [    1.601081] RDX: 0000000000000020 RSI: 000000000000c000 RDI:
> ffffffff81c01e78
> [    1.601086] RBP: ffffffff81c01ea8 R08: 0000000000004003 R09:
> 00000000ffffffff
> [    1.601090] R10: 0000000000000000 R11: 00000000ffffffff R12:
> ffffffff81ca7574
> [    1.601095] R13: ffffffff81ca7514 R14: ffffffff81ca754c R15:
> ffffffff81ca756c
> [    1.601103] FS:  0000000000000000(0000) GS:ffff8801ce600000(0000)
> knlGS:0000000000000000
> [    1.601108] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    1.601112] CR2: 0000000000000000 CR3: 0000000001c0c000 CR4:
> 0000000000040660
> [    1.601117] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [    1.601122] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [    1.601127] Process swapper/0 (pid: 0, threadinfo
> ffffffff81c00000, task ffffffff81c14020)
> [    1.601131] Stack:
> [    1.601134]  ffffffff81c01ea8 ffffffff8169a7d8 0000001600000017
> 0000000000000000
> [    1.601146]  ffff8801c1c3ac00 ffff8801c1c002d0 ffffffff81c01e48
> ffffffff81140118
> [    1.601157]  ffffffff811415cc ffff8801c1c04220 ffff8801c1c02480
> 00000000000000d0
> [    1.601169] Call Trace:
> [    1.601175]  [<ffffffff8169a7d8>] ? get_cpu_cap+0x1f2/0x201
> [    1.601183]  [<ffffffff81140118>] ? init_kmem_cache_cpus+0x3e/0x4d
> [    1.601189]  [<ffffffff811415cc>] ? sysfs_slab_alias+0x60/0x8d
> [    1.601195]  [<ffffffff8169aa3d>] identify_cpu+0x256/0x34d
> [    1.601201]  [<ffffffff81141649>] ? kmem_cache_alloc+0x50/0xe4
> [    1.601209]  [<ffffffff81cd1c51>] identify_boot_cpu+0x10/0x3c
> [    1.601216]  [<ffffffff81cd2052>] check_bugs+0x9/0x2d
> [    1.601222]  [<ffffffff81cc7e08>] start_kernel+0x445/0x461
> [    1.601227]  [<ffffffff81cc77d6>] ? kernel_init+0x1d8/0x1d8
> [    1.601233]  [<ffffffff81cc72cf>] x86_64_start_reservations+0xba/0xc1
> [    1.601240]  [<ffffffff81041797>] ? xen_setup_runstate_info+0x2c/0x36
> [    1.601247]  [<ffffffff81ccbdc4>] xen_start_kernel+0x58b/0x592
> [    1.601251] Code: 0f 85 d3 00 00 00 31 c0 48 83 3d cd 5c 58 00 00
> 48 8d 7d b0 b9 08 00 00 00 f3
> ab c7 45 b4 05 10 01 c0 c7 45 cc 3a 20 5a 9c 75 04 <0f> 0b eb fe 4c
> 8d 75 b0 4c 89 f7 ff 14 25 b0 11
> c2 81 85 c0 8b
> [    1.601374] RIP  [<ffffffff8169b4fe>] init_amd+0x21d/0x603
> [    1.601381]  RSP <ffffffff81c01df8>
> [    1.601391] ---[ end trace a7919e7f17c0a725 ]---
> [    1.601397] Kernel panic - not syncing: Attempted to kill the idle task!
> 
> >Finally, I would question whether re-enabling the topology
> >extensions under Xen shouldn't be skipped altogether, perhaps
> >even on Dom0 (as the hypervisor is controlling this MSR, but in
> >any case on DomU - the hypervisor won't allow (read: ignore,
> >not fault on) the write anyway (and will log a message for each
> >(v)CPU that attempts this).
> 
> This is probably right. Let me think about this.
> 
> Thanks for picking this up.
> 
> Regards,
> Andre.
> 
> >
> >>Signed-off-by: Andre Przywara<andre.przywara@amd.com>
> >>Cc: stable@vger.kernel.org # 3.4+
> >>---
> >>  arch/x86/kernel/cpu/amd.c |    4 ++--
> >>  1 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> >>index 146bb62..80ccd99 100644
> >>--- a/arch/x86/kernel/cpu/amd.c
> >>+++ b/arch/x86/kernel/cpu/amd.c
> >>@@ -586,9 +586,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
> >>  	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
> >>  		u64 val;
> >>
> >>-		if (!rdmsrl_amd_safe(0xc0011005,&val)) {
> >>+		if (!rdmsrl_safe(0xc0011005,&val)) {
> >>  			val |= 1ULL<<  54;
> >>-			wrmsrl_amd_safe(0xc0011005, val);
> >>+			checking_wrmsrl(0xc0011005, val);
> >>  			rdmsrl(0xc0011005, val);
> >>  			if (val&  (1ULL<<  54)) {
> >>  				set_cpu_cap(c, X86_FEATURE_TOPOEXT);
> >
> >
> >
> 
> 
> -- 
> Andre Przywara
> AMD-Operating System Research Center (OSRC), Dresden, Germany

