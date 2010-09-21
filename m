Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab0IUVnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:43:46 -0400
Received: from www.tglx.de ([62.245.132.106]:35087 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0IUVno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:43:44 -0400
Date: Tue, 21 Sep 2010 23:34:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Jack Steiner <steiner@sgi.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 - irq vector assignment
In-Reply-To: <AANLkTinkiZC6bvRJ10EsG-CZSjdJtqW4N7pfq7vnvz3i@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1009212310410.2416@localhost6.localdomain6>
References: <20100921200502.GA26587@sgi.com> <AANLkTinkiZC6bvRJ10EsG-CZSjdJtqW4N7pfq7vnvz3i@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1251286666-1285103865=:2416"
Content-ID: <alpine.LFD.2.00.1009212317570.2416@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1251286666-1285103865=:2416
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1009212317571.2416@localhost6.localdomain6>

On Tue, 21 Sep 2010, Yinghai Lu wrote:
> >  arch/x86/kernel/apic/io_apic.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > Index: linux/arch/x86/kernel/apic/io_apic.c
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/apic/io_apic.c   2010-09-17 13:00:19.164638447 -0500
> > +++ linux/arch/x86/kernel/apic/io_apic.c        2010-09-17 13:00:23.448595373 -0500
> > @@ -3253,6 +3253,11 @@ unsigned int create_irq_nr(unsigned int
> >                desc_new = move_irq_desc(desc_new, node);
> >                cfg_new = desc_new->chip_data;
> >
> > +#ifdef CONFIG_NUMA
> > +               if (node >= 0 && __assign_irq_vector(new, cfg_new, node_to_cpumask_map[node]) == 0)
> > +                       irq = new;
> > +               else
> > +#endif
> >                if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
> >                        irq = new;
> >                break;
> 
> target_cpus() for uv_x and x2apic phys mode all have cpu_online_mask()
> 
> so we should get the vector for other cpus. aka __assign_irq_vector()
> should not fail. unless you have so many irq > nr_irqs.

Did you even read the changelog ? It's not about "should".

All CPU0 vectors are assigned already just because the current code
takes the first cpu in the target_cpus mask regardless of the node on
which the irq_desc is allocated. That's crap. Why do we allocate
irq_desc on node and leave the vector assigned to node(cpu0) ?
 
> current code we only make sure irq_desc on device local node.

Brilliant.

> for the vectors, user can set irq smp_affinity move the device local
> cpus if needed.

What a nonsense. If we allocate irq_desc on a target node it does not
make any sense to target the vector to whatever random node/cpu in the
first place and wait for user space to fix it up. What about running
into that situation _before_ we hit user space ?

Thanks,

	tglx
---1463795968-1251286666-1285103865=:2416--
