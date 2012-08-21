Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab2HUSX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:23:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59791 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab2HUSXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:23:53 -0400
Date: Tue, 21 Aug 2012 20:23:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120821182346.GA7325@gmail.com>
References: <1345043096.31459.106.camel@twins>
 <502BE38D.9030405@linux.intel.com>
 <20120820080606.GA6931@gmail.com>
 <20120820181651.GA737@srcf.ucam.org>
 <20120821094203.GB12385@gmail.com>
 <20120821113951.GA22436@srcf.ucam.org>
 <20120821151910.GA5359@gmail.com>
 <20120821152828.GB28241@srcf.ucam.org>
 <20120821155908.GA5499@gmail.com>
 <20120821161324.GA29665@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821161324.GA29665@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Tue, Aug 21, 2012 at 05:59:08PM +0200, Ingo Molnar wrote:
> > * Matthew Garrett <mjg@redhat.com> wrote:
> > > The scheduler's behaviour is going to have a minimal impact on 
> > > power consumption on laptops. Other things are much more 
> > > important - backlight level, ASPM state, that kind of thing. 
> > > So why special case the scheduler? [...]
> > 
> > I'm not special casing the scheduler - but we are talking about 
> > scheduler policies here, so *if* it makes sense to handle this 
> > dynamically then obviously the scheduler wants to use system 
> > state information when/if the kernel can get it.
> > 
> > Your argument is as if you said that the shape of a car's side 
> > view mirrors is not important to its top speed, because the 
> > overall shape of the chassis and engine power are much more 
> > important.
> > 
> > But we are desiging side view mirrors here, so we might as well 
> > do a good job there.
> 
> If the kernel is going to make power choices automatically 
> then it should do it everywhere, not piecemeal.

Why? Good scheduling is useful even in isolation.

> The scheduler is unaware of whether I care about a process 
> finishing quickly or whether I care about it consuming less 
> power.

You are posing them as if the two were mutually exclusive, while 
in reality they are not necessarily exclusive: it's quite 
possible that the highest (non-turbo) CPU frequency happens to 
be the most energy efficient one for a CPU with a particular 
workload ...

You also missed the bit of my mail where I suggested that such 
user preferences and tolerances can be communicated to the 
scheduler via a policy toggle - which the scheduler would take 
into account.

I suggest to use sane defaults, such as being energy efficient 
on battery power (within a sane threshold) and maximizing 
throughput on AC power (within a sane threshold).

That would go a *long* way improving the current mess. If Linux 
power efficiency was so good today then I'd not ask for kernel 
driven defaults - but the reality is that in terms of process 
scheduling we suck today (and have sucked for the last 10 years) 
so pretty much any approach will improve things.

> > > > The thing is, when I use Linux on a laptop then 
> > > > AC/battery is *the* main policy input.
> > > 
> > > And it's already well handled from userspace, as it has to 
> > > be.
> > 
> > Not according to the developers switching away from Linux 
> > desktop distros in droves, because MacOSX or Win7 has 30%+ 
> > better battery efficiency.
> 
> Ok so what you're actually telling me here is that you don't 
> understand anything about power management and where our 
> problems are.

Huh? In practice we suck today in terms of energy efficiency. 
That covers both scheduling and other areas.

Saying this out aloud does not tell anything about my 
understanding of power management...

So please outline a technical point.

> > The scheduler might be a small part of the picture, but it's 
> > certainly a part of it.
> 
> It's in the drivers, which is where it has been since we went 
> tickless.

You mean the code is in drivers? Or the problem is in drivers? 

Both is true currently - this discussion is about the future, to 
make the scheduler aware of power concerns, as the scheduler 
(and the timer subsystem) already calculates various interesting 
metrics that matter to energy efficient scheduling.

> > > No, because sched_mt_powersave usually crippled performance 
> > > more than it saved power and nobody makes multi-socket 
> > > laptops.
> > 
> > That's a user-space policy management fail right there: why 
> > wasn't this fixed? If the default policy is in the kernel we can 
> > at least fix it in one place for the most common cases. If it's 
> > spread out amongst multiple projects then progress only happens 
> > at glacial speed ...
> 
> sched_mt_powersave was inherently going to have a huge impact 
> on performance, and with modern chips that would result in the 
> platform consuming more power. It was a feature that was 
> useful for a small number of generations of desktop CPUs - I 
> don't think it would ever skew the power/performance ratio in 
> a useful direction on mobile hardware. But feel free to blame 
> userspace for hardware design.

FYI, sched_mt_powersave is *GONE* in recent kernels, because it 
basically never worked. This thread is about designing and 
implementing something that actually works.

Thanks,

	Ingo
