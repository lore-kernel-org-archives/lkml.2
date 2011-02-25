Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1BYPjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:39:44 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:46042 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1BYPjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:39:43 -0500
X-IronPort-AV: E=Sophos;i="4.62,225,1297036800"; 
   d="scan'208";a="4510722"
Date: Fri, 25 Feb 2011 15:40:18 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 6/7] xen: enable event channels to send and receive IPIs
 for PV on HVM guests
In-Reply-To: <20110222193052.GB17866@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1102251539500.2156@kaball-desktop>
References: <alpine.DEB.2.00.1102161739370.2826@kaball-desktop> <1297878787-378-6-git-send-email-stefano.stabellini@eu.citrix.com> <20110222193052.GB17866@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, Konrad Rzeszutek Wilk wrote:
> On Wed, Feb 16, 2011 at 05:53:06PM +0000, stefano.stabellini@eu.citrix.com wrote:
> > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > Enable the usage of event channels to send and receive IPIs when
> > running as a PV on HVM guest.
> 
> Why not squash this with the other patch? After this, the only thing
> that the other patch had done was to add in the 'xen_hvm_cpu_notify' function
> a call to setup the spinlocks..

Yeah, I'll do that.

> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/x86/xen/enlighten.c |   16 +---------------
> >  arch/x86/xen/smp.c       |   42 ++++++++++++++++++++++++++++++++++++++++++
> >  arch/x86/xen/xen-ops.h   |    2 ++
> >  3 files changed, 45 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index 9c1628b..fe02574 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -1343,20 +1343,6 @@ static struct notifier_block __cpuinitdata xen_hvm_cpu_notifier = {
> >  	.notifier_call	= xen_hvm_cpu_notify,
> >  };
> >  
> > -static void xen_hvm_spinlock_init(void)
> > -{
> > -	if (!xen_have_vector_callback)
> > -		return;
> > -	xen_init_lock_cpu(0);
> > -	xen_init_spinlocks();
> > -}
> > -
> > -static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
> > -{
> > -	native_smp_prepare_cpus(max_cpus);
> > -	xen_hvm_spinlock_init();
> > -}
> > -
> >  static void __init xen_hvm_guest_init(void)
> >  {
> >  	int r;
> > @@ -1370,13 +1356,13 @@ static void __init xen_hvm_guest_init(void)
> >  
> >  	if (xen_feature(XENFEAT_hvm_callback_vector))
> >  		xen_have_vector_callback = 1;
> > +	xen_hvm_smp_init();
> >  	register_cpu_notifier(&xen_hvm_cpu_notifier);
> >  	xen_unplug_emulated_devices();
> >  	have_vcpu_info_placement = 0;
> >  	x86_init.irqs.intr_init = xen_init_IRQ;
> >  	xen_hvm_init_time_ops();
> >  	xen_hvm_init_mmu_ops();
> > -	smp_ops.smp_prepare_cpus = xen_hvm_smp_prepare_cpus;
> >  }
> >  
> >  static bool __init xen_hvm_platform(void)
> > diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> > index 72a4c79..2300d4b 100644
> > --- a/arch/x86/xen/smp.c
> > +++ b/arch/x86/xen/smp.c
> > @@ -509,3 +509,45 @@ void __init xen_smp_init(void)
> >  	xen_fill_possible_map();
> >  	xen_init_spinlocks();
> >  }
> > +
> > +static void xen_hvm_spinlock_init(void)
> > +{
> > +	if (!xen_have_vector_callback)
> > +		return;
> > +	xen_init_lock_cpu(0);
> > +	xen_init_spinlocks();
> > +}
> > +
> > +static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
> > +{
> > +	native_smp_prepare_cpus(max_cpus);
> > +	WARN_ON(xen_smp_intr_init(0));
> > +	xen_hvm_spinlock_init();
> 
> Why not merge 'xen_hvm_spinlock_init' in here?
> 

sure

