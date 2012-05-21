Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab2EUTa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:30:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52079 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab2EUTa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:30:57 -0400
Date: Mon, 21 May 2012 21:30:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Gordeev <agordeev@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120521193051.GB28819@gmail.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120521082240.GA31407@gmail.com>
 <20120521093648.GC28930@dhcp-26-207.brq.redhat.com>
 <20120521124025.GC17065@gmail.com>
 <20120521144812.GD28930@dhcp-26-207.brq.redhat.com>
 <20120521145904.GA7068@gmail.com>
 <CA+55aFxJxfx+OfDiATCCPojVAPew_Hy+2=jx9g4=2_WRvixBFw@mail.gmail.com>
 <1337623623.1997.115.camel@sbsiddha-desk.sc.intel.com>
 <CA+55aFx3ogOzGWZvfETgoKqoLzTc7qw6QjmouSLG4JF9aRdjig@mail.gmail.com>
 <1337625434.1997.126.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337625434.1997.126.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> > But I do agree with Ingo that it would be really good to 
> > actually see numbers (and no, I don't mean "look here, now 
> > the irq's are nicely spread out", but power and/or 
> > performance numbers showing that it actually helps 
> > something).
> 
> I agree. This is the reason why I held up posting these 
> patches before. I can come up with micro-benchmarks that can 
> show some difference but the key is to find good 
> workload/benchmark that can show measurable difference. Any 
> suggestions?

It's rather difficult to measure this reliably. The main 
complication is the inherent noise of cache stats on SMP/NUMA 
systems, which all modern multi-socket systems are ...

But, since you asked, if you can generate a *very* precise 
incoming external IRQ rate, it's possible:

Generate say 10,000 irqs/sec of a workload directed at a single 
CPU - something like multiple copies of ping -i 0.001 -q 
executed on a nearby system might do.

Then run a user-space cycle soaker, nice -19 running NOPs on all 
CPUs. It's important that it *only* a user-space infinite loop, 
with no kernel instructions executed at all - see later.

Then play around with variants of:

  perf stat -a --repeat 10 -e cycles:u -e instructions:u sleep 1

this will tell you the number of user-space cycles and 
instructions executed, per second. The ':u' attribute to limit 
to user-space cycles filters apart the IRQ handler overhead from 
your user-space cycle soaker.

This number of 'available user-space performance' should not get 
worse when you switch from single-CPU APIC target to a 
harware-round-robin target mask. You can switch the mask using 
/proc/irq/nr/smp_affinity with very low overhead, while all the 
above masurements are running - this allows you to see how 
user-space throughput reacts to the IRQ details.

Double check that the irq rate is constant, via 'vmstat 1'.

Thanks,

	Ingo
