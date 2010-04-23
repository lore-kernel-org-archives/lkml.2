Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0DWT4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:56:01 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37162 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756050Ab0DWTz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:55:59 -0400
Date: Fri, 23 Apr 2010 15:55:56 -0400
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
Message-ID: <20100423195556.GD21997@Krystal>
References: <4BCFC3D0.5080904@codeaurora.org> <4BD0D9E5.3020606@codeaurora.org> <20100423184042.GA16190@Krystal> <20100423122259.49e0416a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423122259.49e0416a@infradead.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:41:18 up 90 days, 22:18,  5 users,  load average: 0.00, 0.09,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Fri, 23 Apr 2010 14:40:42 -0400
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > [CCing Arjan, who seems to have played a lot with ondemand lately]
> > 
> > * Saravana Kannan (skannan@codeaurora.org) wrote:
> > > Resending email to "cc" the maintainers.
> > >
> > > Maintainers,
> > >
> > > Any comments?
> > >
> > > -Saravana
> > >
> > > Saravana Kannan wrote:
> > >> Hi,
> > >>
> > >> I think there are a couple of issues with cpufreq and udelay  
> > >> interaction. But that's based on my understanding of cpufreq. I
> > >> have worked with it for sometime now, so hopefully I not
> > >> completely wrong. So, I will list my assumptions and what I think
> > >> is/are the issue(s) and their solutions.
> > >>
> > >> Please correct me if I'm wrong and let me know what you think.
> > >>
> > >> Assumptions:
> > >> ============
> > >> * Let's assume ondemand governor is being used.
> > >> * Ondemand uses one timer per core and they have CPU affinity set.
> > >> * For SMP, CPUfreq core expects the CPUfreq driver to adjust the 
> > >> per-CPU jiffies.
> > >> * P1 indicates for lower CPU perfomance levels and P2 indicates a
> > >> much higher CPU pref level (say 10 times faster).
> > >>
> 
> 
> so in reality, all hardware that does coordination between cores/etc
> like this also has a tsc that is invariant of the actual P state.
> If there are exceptions, those have a problem, but I can't think of any
> right now.
> Once the TSC is invariant of P state, udelay() is fine, since that goes
> of the tsc, not of some delay loop kind of thing....

I did an overview, back in 2007, of AMD and Intel processors that had either tsc
rate depending on P state and/or tsc rate changed by idle and/or tsc values
influenced by STPCLK-Throttling. Here are some notes, along with pointers to the
reference documents (please excuse the ad-hoc style of these notes):

http://git.dorsal.polymtl.ca/?p=lttv.git;a=blob_plain;f=doc/developer/tsc.txt

So I might be missing something about your statement "all hardware that does
coordination between cores/etc like this also has a tsc that is invariant of the
actual P state.". Do you mean that all udelay callers do not rely on it to
provide a guaranteed lower-bound, except for some sub-architectures ?

ARM currently does not rely on the c0_count register for udelay, but it could do
it in a near future on the omap3 at least. This register follows the CPU
frequency. I suspect that the current udelay loop implementation in
arch/arm/lib/delay.S, being calibrated on loops_per_jiffy, does not work that
well with ondemand cpufreq right now.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
