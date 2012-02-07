Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab2BGJGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 04:06:50 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:32889 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab2BGJGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 04:06:47 -0500
Date: Tue, 7 Feb 2012 10:06:09 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Venki Pallipadi <venki@google.com>, Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, eric.dumazet@gmail.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [BUG] perf: perf sched warning possibly due to clock granularity
 on AMD
Message-ID: <20120207090609.GB4852@aftab>
References: <1328538403.2482.4.camel@laptop>
 <20120206153408.GA31237@aftab>
 <1328546246.2482.10.camel@laptop>
 <20120206164626.GA31704@aftab>
 <1328547259.2482.11.camel@laptop>
 <20120206202722.GA556@aftab>
 <1328560293.2482.24.camel@laptop>
 <20120206203738.GB556@aftab>
 <CABeCy1ZH_BQhoSegeyBnY0XkjL9afm5=onKrmt9SApufCWgs3A@mail.gmail.com>
 <20120207083253.GC12821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207083253.GC12821@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 09:32:53AM +0100, Ingo Molnar wrote:
> > Yes. If these two flags are set, TSC should be consistent and 
> > sched_clock_stable could be set and it will be reset if there 
> > is a call to mark_tsc_unstable().
> 
> Most of the details swapped out from my brain meanwhile, but I 
> have some vague memories of a DMI quirk for some high-end system 
> that just did a sched_clock_stable = 0 or such.
> 
> So if the common case is that the TSC is entirely synchronized 
> across CPUs, then we can default to that and rely on platform 
> initialization code or DMI quirks setting the few large-NUMA 
> systems to an unstable TSC.

There's also 14be1f7454ea96ee614467a49cf018a1a383b189 which removed
the setting of sched_clock_stable to 1 due to UV systems not being
TSC-synchronized across blades.

I guess, we could tentatively enable it on AMD provided nothing has
marked the TSC as unstable already:

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f4773f4..ddee619 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -456,6 +456,8 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
        if (c->x86_power & (1 << 8)) {
                set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
                set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
+               if (!check_tsc_unstable())
+                       sched_clock_stable = 1;
        }
 
 #ifdef CONFIG_X86_64

Hmm...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
