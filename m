Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab1E3KAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:00:49 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:15066
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105Ab1E3KAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:00:47 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LM06H5-02-0U8-02
X-M-MSG: 
Date: Mon, 30 May 2011 12:00:39 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.40
Message-ID: <20110530100039.GB20052@erda.amd.com>
References: <20110526133948.GX20052@erda.amd.com>
 <20110527122301.GA32754@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110527122301.GA32754@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.05.11 08:23:01, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > Robert Richter (1):
> >       oprofile, x86: Enable preemption during pci device setup in IBS init
> 
> I'm wondering about this bit, as from a preempt_enable()/disable() 
> pattern POV it looks bogus. It does:
> 
>         preempt_disable();
>         for (offset = 1; offset < APIC_EILVT_NR_MAX; offset++) {
>                 if (get_eilvt(offset))
>                         break;
>         }
>         preempt_enable();
> 
> 	...
> 
> 
> 	ret = setup_ibs_ctl(offset);
> 
> So whatever condition it established at the get_eilvt() stage might 
> not be valid at the setup_ibs_ctl() point: we might be on a different 
> CPU.
> 
> Or are the IBS MSRs (which get twiddled in get_eilvt() absolutely 
> symmetric across all CPUs, thus making this a preempt invariant 
> thing? In that case we'd at least need a big fat comment in the code 
> as it's not obvious at all ...

The MSRC001_103A (IBS Control Register) register contains the LVT
offset. It is a per-node msr and a read-only copy of F3x1CC (pci
device register). The offset must be valid (bit set) and not yet taken
by another vector (kernel keeps track of it in eilvt_offsets).  Though
offsets must be the same on all nodes, the kernel implementation uses
same offsets on all cores of the system.

The BIOS is responsible to setup the vector. If the vector in IBS_CTL
is invalid or already taken, we reassign a different offset in
force_ibs_eilvt_setup() (family 10h only).

In get_eilvt()/setup_APIC_eilvt() there are reads and writes to the
local apic. Preemption must be disabled to not be switched to another
cpu in the middle of a sequence.

> But i really do not see how this can work. get_eilvt() twiddles the 
> APIC LVT of this current CPU. Does IBS only activate on a single CPU? 
> How will this LVT entry be cleared on deinit?

This is done on the current cpu to get the offset which is then used
on all cpus of the system. The actually per-core setup for ibs is in
op_amd_setup_ctrs(). Deinit is in op_amd_cpu_shutdown().

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

