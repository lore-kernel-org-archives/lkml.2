Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1EFVlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:41:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:43903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932919Ab1EFVlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:41:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,328,1301900400"; 
   d="scan'208";a="689286805"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Sat, 7 May 2011 05:41:02 +0800
Subject: RE: [PATCH v2 1/2] x86: skip migrating IRQF_PER_CPU irq in
 fixup_irqs
Thread-Topic: [PATCH v2 1/2] x86: skip migrating IRQF_PER_CPU irq in
 fixup_irqs
Thread-Index: AcwL9buc9g3ESUzmSDy3ruiTS7ILVQAQBMnA
Message-ID: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F99C@shsmsx502.ccr.corp.intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E2@shsmsx502.ccr.corp.intel.com>
 <20110506135828.GC5500@dumpdata.com>
In-Reply-To: <20110506135828.GC5500@dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> Sent: Friday, May 06, 2011 9:58 PM
> 
> On Fri, May 06, 2011 at 02:43:36PM +0800, Tian, Kevin wrote:
> > x86: skip migrating IRQF_PER_CPU irq in fixup_irqs
> >
> > IRQF_PER_CPU marks a irq binding to a specific cpu, and can never be
> > moved away from that cpu. So it shouldn't be migrated when fixup irqs
> > to offline a cpu. Xen pvops guest is one source using IRQF_PER_CPU
>   ^- are called
> > on a set of virtual interrupts. Previously no error is observed
>                                                       ^^- was
> Which ones? Can you be more specific here of which type of virtual interrupts?
>  spinlock? timer?

all of them: spinlock, timer, resched, callfunc, ...

> > because Xen event chip silently fails the set_affinity ops, and
> > logically IRQF_PER_CPU should be recognized here.
> 
> OK, so what if the set_affinity ops was implemented?

it was implemented: (drivers/xen/event.c, rebind_irq_to_cpu)
        /*
         * If this fails, it usually just indicates that we're dealing with a
         * virq or IPI channel, which don't actually need to be rebound. Ignore
         * it, but don't do the xenlinux-level rebind in that case.
         */
        if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_vcpu, &bind_vcpu) >= 0)
                bind_evtchn_to_cpu(evtchn, tcpu);
Hypervisor doesn't allow to change affinity for virq and ipi.

Thanks,
Kevin

> >
> > Signed-off-by: Fengzhe Zhang <fengzhe.zhang@intel.com>
> > Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: Ingo Molnar <mingo@redhat.com>
> > CC: H. Peter Anvin <hpa@zytor.com>
> > CC: Ian Campbell <Ian.Campbell@citrix.com>
> > CC: Jan Beulich <JBeulich@novell.com>
> >
> > --- linux-2.6.39-rc6.orig/arch/x86/kernel/irq.c	2011-05-04
> 10:59:13.000000000 +0800
> > +++ linux-2.6.39-rc6/arch/x86/kernel/irq.c	2011-05-06 09:20:25.563963000
> +0800
> > @@ -249,7 +250,7 @@ void fixup_irqs(void)
> >
> >  		data = irq_desc_get_irq_data(desc);
> >  		affinity = data->affinity;
> > -		if (!irq_has_action(irq) ||
> > +		if (!irq_has_action(irq) || irqd_is_per_cpu(data) ||
> >  		    cpumask_subset(affinity, cpu_online_mask)) {
> >  			raw_spin_unlock(&desc->lock);
> >  			continue;
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
