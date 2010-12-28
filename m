Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab0L1HWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 02:22:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:32896 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab0L1HV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 02:21:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,238,1291622400"; 
   d="scan'208";a="587714324"
Subject: Re: [PATCH] apic: use GFP_ATOMIC in lapic_resume
From: Zhang Rui <rui.zhang@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <alpine.DEB.2.00.1012272300070.24243@chino.kir.corp.google.com>
References: <1293518922.14005.601.camel@rui>
	 <alpine.DEB.2.00.1012272300070.24243@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 15:22:02 +0800
Message-ID: <1293520922.14005.616.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-28 at 15:00 +0800, David Rientjes wrote:
> On Tue, 28 Dec 2010, Zhang Rui wrote:
> 
> > Index: linux-2.6/arch/x86/kernel/apic/apic.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/kernel/apic/apic.c
> > +++ linux-2.6/arch/x86/kernel/apic/apic.c
> > @@ -1459,7 +1459,7 @@ void __init enable_IR_x2apic(void)
> >  	if (dmar_table_init_ret && !x2apic_supported())
> >  		return;
> >  
> > -	ioapic_entries = alloc_ioapic_entries();
> > +	ioapic_entries = alloc_ioapic_entries(GFP_KERNEL);
> >  	if (!ioapic_entries) {
> >  		pr_err("Allocate ioapic_entries failed\n");
> >  		goto out;
> > @@ -2084,7 +2084,7 @@ static int lapic_resume(struct sys_devic
> >  
> >  	local_irq_save(flags);
> >  	if (intr_remapping_enabled) {
> > -		ioapic_entries = alloc_ioapic_entries();
> > +		ioapic_entries = alloc_ioapic_entries(GFP_ATOMIC);
> >  		if (!ioapic_entries) {
> >  			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
> >  			ret = -ENOMEM;
> 
> You can't do the allocation before disabling irqs when 
> intr_remapping_enabled is set?

yes, we can. The first idea came into my mind is to register a pm
notifier callback to allocate/free the memory. But that one duplicates
the code of alloc_ioapic_entries, which doesn't look nice, neither.
Plus, is there any problem with this one?

thanks,
rui
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


