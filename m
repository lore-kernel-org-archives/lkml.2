Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab2EUSIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:08:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:15338 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758454Ab2EUSIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:08:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="145842885"
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Alexander Gordeev <agordeev@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Yinghai Lu <yinghai@kernel.org>
Date: Mon, 21 May 2012 11:07:03 -0700
In-Reply-To: <CA+55aFxJxfx+OfDiATCCPojVAPew_Hy+2=jx9g4=2_WRvixBFw@mail.gmail.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
	 <20120521082240.GA31407@gmail.com>
	 <20120521093648.GC28930@dhcp-26-207.brq.redhat.com>
	 <20120521124025.GC17065@gmail.com>
	 <20120521144812.GD28930@dhcp-26-207.brq.redhat.com>
	 <20120521145904.GA7068@gmail.com>
	 <CA+55aFxJxfx+OfDiATCCPojVAPew_Hy+2=jx9g4=2_WRvixBFw@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337623623.1997.115.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 08:36 -0700, Linus Torvalds wrote:
> On Mon, May 21, 2012 at 7:59 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > For example we don't execute tasks for 100 usecs on one CPU,
> > then jump to another CPU and execute 100 usecs there, then to
> > yet another CPU to create an 'absolutely balanced use of CPU
> > resources'. Why? Because the cache-misses would be killing us.
> 
> That is likely generally not true within a single socket, though.
> 
> Interrupt handlers will basically never hit in the L1 anyway (*maybe*
> it happens if the CPU is totally idle, but quite frankly, I doubt it).
> Even the L2 is likely not large enough to have much cache across irqs,
> unless it's one of the big Core 2 L2's that are largely shared per
> socket anyway.
> 
> So it may well make perfect sense to allow a mask of CPU's for
> interrupt delivery, but just make sure that the mask all points to
> CPU's on the same socket. 

All the cluster members of a given x2apic cluster belong to the same
package. These x2apic cluster id's are setup by the HW and not by the
SW. And only one cluster (with one or multiple members of that cluster
set) can be specified in the interrupt destination field of the routing
table entry.

> That would give the hardware some leeway in
> choosing the actual core - it's very possible that hardware could
> avoid cores that are running with irq's disabled (possibly improving
> latecy) or even more likely - avoid cores that are in deeper
> powersaving modes.

Power aware interrupt routing in IVB does this. And the policy of
whether you want the interrupt to be routed to the busy core (to save
power) or an idle core (for minimizing the interruptions on the busy
core) can be selected by the SW (using IA32_ENERGY_PERF_BIAS MSR).

thanks,
suresh

