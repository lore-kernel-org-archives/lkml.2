Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab0DXVAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 17:00:46 -0400
Received: from mail.openrapids.net ([64.15.138.104]:32801 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753278Ab0DXVAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 17:00:45 -0400
Date: Sat, 24 Apr 2010 17:00:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Saravana Kannan <skannan@codeaurora.org>,
       cpufreq <cpufreq@vger.kernel.org>,
       linux-arm-msm <linux-arm-msm@vger.kernel.org>,
       Dave Jones <davej@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: CPUfreq - udelay() interaction issues
Message-ID: <20100424210042.GA2371@Krystal>
References: <4BCFC3D0.5080904@codeaurora.org> <4BD0D9E5.3020606@codeaurora.org> <20100423184042.GA16190@Krystal> <20100423122259.49e0416a@infradead.org> <20100423195556.GD21997@Krystal> <20100424115616.01aaa997@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100424115616.01aaa997@infradead.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:55:56 up 91 days, 23:33,  9 users,  load average: 0.00, 0.05,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> > 
> > I did an overview, back in 2007, of AMD and Intel processors that had
> > either tsc rate depending on P state and/or tsc rate changed by idle
> > and/or tsc values influenced by STPCLK-Throttling. Here are some
> > notes, along with pointers to the reference documents (please excuse
> > the ad-hoc style of these notes):
> > 
> > http://git.dorsal.polymtl.ca/?p=lttv.git;a=blob_plain;f=doc/developer/tsc.txt
> > 
> > So I might be missing something about your statement "all hardware
> > that does coordination between cores/etc like this also has a tsc
> > that is invariant of the actual P state.". Do you mean that all
> > udelay callers do not rely on it to provide a guaranteed lower-bound,
> > except for some sub-architectures ?
> 
> ok there's basically 3 cases
> 
> Case 1: single core, no hyperthreading. It does not matter what tsc
> does, since the kernel knows what it does and will either scale it or
> not for udelay depending on that.
> (this case includes single core SMP configurations)

The kernel will scale things like gettimeofday and the monotonic clocks in these
cases, but which piece of code takes care of arch/x86/lib/delay.c:delay_tsc()
exactly ? AFAIK, it reads the cycle counter with rdtscl() directly.

> 
> Case 2: multi core or HT, TSC is variable with CPU frequency.
> This is the really sucky case, since logical CPU 0's tsc frequency in
> part depends on what logical CPU 1 will do etc. No good answer
> for this other than assuming the worst. Based on your document these do
> actually exist in early P4 cpus.

Keeping track of the cpu frequency changes can help here. Along with periodic
resynchronization if cpu clocks drift too far apart. I've done that for the
LTTng omap3 trace clock.

> 
> Case 3: multi core/HT but with fixed rate TSC; no problem whatsoever,
> tsc is a good measure for udelay.

Agreed for case 3.

> 
> Only case 2 sucks :-(

Not sure about case 1 specifically for udelay. I might have missed something
though.

Thanks,

Mathieu

> 
> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
