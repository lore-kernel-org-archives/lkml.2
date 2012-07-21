Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab2GUMpW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 08:45:22 -0400
Received: from osrc3.amd.com ([217.9.48.20]:48783 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab2GUMpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 08:45:21 -0400
Date: Sat, 21 Jul 2012 14:45:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] x86/mce: Add quirk for instruction recovery on Sandy
 Bridge processors
Message-ID: <20120721124516.GB3632@aftab.osrc.amd.com>
References: <cover.1342723082.git.tony.luck@intel.com>
 <180a06f3f357cf9f78259ae443a082b14a29535b.1342723082.git.tony.luck@intel.com>
 <20120720121848.GA29183@aftab.osrc.amd.com>
 <CA+8MBbLX_cLR1+DpjuG-D5=5YhnTy3aGS4RL1iviRYomYoveWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbLX_cLR1+DpjuG-D5=5YhnTy3aGS4RL1iviRYomYoveWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 09:33:23AM -0700, Tony Luck wrote:
> > Maybe define a default empty quirk_no_way_out() on the remaining
> > families/vendors so that the compiler can optimize it away and we save
> > ourselves the if-test?
> 
> Perhaps I misunderstood your suggestion. I don't see how the compiler will
> manage to optimize it all away.  I just tried defining
> 
> static void quirk_no_way_out_nop(int bank, struct mce *m, struct pt_regs *regs)
> {
> }
> 
> and providing that as an initial value for the quirk_no_way_out
> function pointer.
> 
> Then I deleted the "if (quirk_no_way_out)".
> 
> Looking at the assembly code produced, I now just have an unconditional call:
> 
>  callq  *0x9fe992(%rip)        # ffffffff81a18668 <quirk_no_way_out>
> 
> 
> I'd think that a call through a function pointer to an empty function is
> more expensive that testing whether that function pointer was NULL.

Agreed.

Right, so I was thinking about something along the lines of what tglx
did for the CMCI poll timer: http://lkml.org/lkml/2012/7/18/79 and
I've been playing with this for a bit now and am seeing the same thing
as you: obviously the compiler cannot optimize away an unconditional
function call to an empty function *through* a function pointer
(tried gcc 4.6 and 4.7). Maybe because it is a function pointer we're
calling...

If you make the function pointer const like this:

static void default_quirk_no_way_out(int bank, struct mce *m,
                                           struct pt_regs *regs) { }

static void (* const quirk_no_way_out)(int bank, struct mce *m, struct pt_regs *regs) =
        default_quirk_no_way_out;

The "call... " is not issued but you cannot assign to it later in
__mcheck_cpu_apply_quirks().

Other things which could probably be used are alternatives or jump
labels but one if-test is simply not worth the complexity.

Oh well, enough games.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
