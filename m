Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab0L1Hji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 02:39:38 -0500
Received: from smtp-out.google.com ([216.239.44.51]:11300 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab0L1Hjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 02:39:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=MuxPvbggZFtz3eLK9mbP0byBGOLz+fuxITLS16SQTFRJtr7KJhgjQwnWpAMiTuLV56
         LH/C9d2YhoE0/Rt8jFKg==
Date: Mon, 27 Dec 2010 23:39:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhang Rui <rui.zhang@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] apic: use GFP_ATOMIC in lapic_resume
In-Reply-To: <1293520922.14005.616.camel@rui>
Message-ID: <alpine.DEB.2.00.1012272336001.25826@chino.kir.corp.google.com>
References: <1293518922.14005.601.camel@rui> <alpine.DEB.2.00.1012272300070.24243@chino.kir.corp.google.com> <1293520922.14005.616.camel@rui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Dec 2010, Zhang Rui wrote:

> > > Index: linux-2.6/arch/x86/kernel/apic/apic.c
> > > ===================================================================
> > > --- linux-2.6.orig/arch/x86/kernel/apic/apic.c
> > > +++ linux-2.6/arch/x86/kernel/apic/apic.c
> > > @@ -1459,7 +1459,7 @@ void __init enable_IR_x2apic(void)
> > >  	if (dmar_table_init_ret && !x2apic_supported())
> > >  		return;
> > >  
> > > -	ioapic_entries = alloc_ioapic_entries();
> > > +	ioapic_entries = alloc_ioapic_entries(GFP_KERNEL);
> > >  	if (!ioapic_entries) {
> > >  		pr_err("Allocate ioapic_entries failed\n");
> > >  		goto out;
> > > @@ -2084,7 +2084,7 @@ static int lapic_resume(struct sys_devic
> > >  
> > >  	local_irq_save(flags);
> > >  	if (intr_remapping_enabled) {
> > > -		ioapic_entries = alloc_ioapic_entries();
> > > +		ioapic_entries = alloc_ioapic_entries(GFP_ATOMIC);
> > >  		if (!ioapic_entries) {
> > >  			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
> > >  			ret = -ENOMEM;
> > 
> > You can't do the allocation before disabling irqs when 
> > intr_remapping_enabled is set?
> 
> yes, we can. The first idea came into my mind is to register a pm
> notifier callback to allocate/free the memory. But that one duplicates
> the code of alloc_ioapic_entries, which doesn't look nice, neither.
> Plus, is there any problem with this one?
> 

We try to avoid GFP_ATOMIC whenever possible and this seems like a 
particularly trivial case.  You can simply move the alloc_ioapic_entries() 
and NULL check before local_irq_save() and GFP_KERNEL will work fine.
