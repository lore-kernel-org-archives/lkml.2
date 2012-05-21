Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2EUJhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:37:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab2EUJhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:37:07 -0400
Date: Mon, 21 May 2012 11:36:49 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120521093648.GC28930@dhcp-26-207.brq.redhat.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120521082240.GA31407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521082240.GA31407@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 10:22:40AM +0200, Ingo Molnar wrote:
> 
> * Alexander Gordeev <agordeev@redhat.com> wrote:
> 
> > Currently x2APIC in logical destination mode delivers 
> > interrupts to a single CPU, no matter how many CPUs were 
> > specified in the destination cpumask.
> > 
> > This fix enables delivery of interrupts to multiple CPUs by 
> > bit-ORing Logical IDs of destination CPUs that have matching 
> > Cluster ID.
> > 
> > Because only one cluster could be specified in a message 
> > destination address, the destination cpumask is tried for a 
> > cluster that contains maximum number of CPUs matching this 
> > cpumask. The CPUs in this cluster are selected to receive the 
> > interrupts while all other CPUs (in the cpumask) are ignored.
> 
> I'm wondering how you tested this. AFAICS current irqbalanced 
> will create masks but on x2apic only the first CPU is targeted 
> by the kernel.

Right, that is what this patch is intended to change. So I use:
'hwclock --test' to generate rtc interruts
/proc/interrupts to check where/how many interrupts were delevired
/proc/irq/8/smp_affinity to check how clusters are chosen

> So, in theory, prior the patch you should be seeing irqs go to 
> only one CPU, while after the patch they are spread out amongst 
> the CPU. If it's using LowestPrio delivery then we depend on the 
> hardware doing this for us - how does this work out in practice, 
> are the target CPUs round-robin-ed, with a new CPU for every new 
> IRQ delivered?


That is exactly what I can observe.

As of 'target CPUs round-robin-ed' and 'with a new CPU for every new IRQ
delivered' -- that is something we can not control as you noted. Nor do we
care to my understanding.

I can not commit on every h/w out there obviously, but on my PowerEdge M910
with some half-dozen clusters with six CPU per each, the interrupts are
perfectly balanced among those ones present in IRTEs.


> Thanks,
> 
> 	Ingo

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
