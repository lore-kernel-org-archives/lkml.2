Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab1EFN7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:59:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42433 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab1EFN7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:59:01 -0400
Date: Fri, 6 May 2011 09:58:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v2 1/2] x86: skip migrating IRQF_PER_CPU irq in fixup_irqs
Message-ID: <20110506135828.GC5500@dumpdata.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E2@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E2@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DC3FE90.00A4:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 02:43:36PM +0800, Tian, Kevin wrote:
> x86: skip migrating IRQF_PER_CPU irq in fixup_irqs
> 
> IRQF_PER_CPU marks a irq binding to a specific cpu, and can never be
> moved away from that cpu. So it shouldn't be migrated when fixup irqs
> to offline a cpu. Xen pvops guest is one source using IRQF_PER_CPU
  ^- are called 
> on a set of virtual interrupts. Previously no error is observed 
                                                      ^^- was
 Which ones? Can you be more specific here of which type of virtual interrupts?
 spinlock? timer? 
> because Xen event chip silently fails the set_affinity ops, and
> logically IRQF_PER_CPU should be recognized here.

OK, so what if the set_affinity ops was implemented?
> 
> Signed-off-by: Fengzhe Zhang <fengzhe.zhang@intel.com>
> Signed-off-by: Kevin Tian <kevin.tian@intel.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: H. Peter Anvin <hpa@zytor.com>
> CC: Ian Campbell <Ian.Campbell@citrix.com>
> CC: Jan Beulich <JBeulich@novell.com>
> 
> --- linux-2.6.39-rc6.orig/arch/x86/kernel/irq.c	2011-05-04 10:59:13.000000000 +0800
> +++ linux-2.6.39-rc6/arch/x86/kernel/irq.c	2011-05-06 09:20:25.563963000 +0800
> @@ -249,7 +250,7 @@ void fixup_irqs(void)
>  
>  		data = irq_desc_get_irq_data(desc);
>  		affinity = data->affinity;
> -		if (!irq_has_action(irq) ||
> +		if (!irq_has_action(irq) || irqd_is_per_cpu(data) ||
>  		    cpumask_subset(affinity, cpu_online_mask)) {
>  			raw_spin_unlock(&desc->lock);
>  			continue;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
