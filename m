Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab0L1J6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 04:58:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58579 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab0L1J6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 04:58:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] apic: use GFP_ATOMIC in lapic_resume
Date: Tue, 28 Dec 2010 10:57:54 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7+; KDE/4.4.4; x86_64; ; )
Cc: David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <1293518922.14005.601.camel@rui> <1293522983.14005.624.camel@rui> <1293526102.14005.632.camel@rui>
In-Reply-To: <1293526102.14005.632.camel@rui>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012281057.54647.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 28, 2010, Zhang Rui wrote:
> On Tue, 2010-12-28 at 15:56 +0800, Zhang Rui wrote:
> > On Tue, 2010-12-28 at 15:39 +0800, David Rientjes wrote:
> > > On Tue, 28 Dec 2010, Zhang Rui wrote:
> > > 
> > > > > > Index: linux-2.6/arch/x86/kernel/apic/apic.c
> > > > > > ===================================================================
> > > > > > --- linux-2.6.orig/arch/x86/kernel/apic/apic.c
> > > > > > +++ linux-2.6/arch/x86/kernel/apic/apic.c
> > > > > > @@ -1459,7 +1459,7 @@ void __init enable_IR_x2apic(void)
> > > > > >  	if (dmar_table_init_ret && !x2apic_supported())
> > > > > >  		return;
> > > > > >  
> > > > > > -	ioapic_entries = alloc_ioapic_entries();
> > > > > > +	ioapic_entries = alloc_ioapic_entries(GFP_KERNEL);
> > > > > >  	if (!ioapic_entries) {
> > > > > >  		pr_err("Allocate ioapic_entries failed\n");
> > > > > >  		goto out;
> > > > > > @@ -2084,7 +2084,7 @@ static int lapic_resume(struct sys_devic
> > > > > >  
> > > > > >  	local_irq_save(flags);
> > > > > >  	if (intr_remapping_enabled) {
> > > > > > -		ioapic_entries = alloc_ioapic_entries();
> > > > > > +		ioapic_entries = alloc_ioapic_entries(GFP_ATOMIC);
> > > > > >  		if (!ioapic_entries) {
> > > > > >  			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
> > > > > >  			ret = -ENOMEM;
> > > > > 
> > > > > You can't do the allocation before disabling irqs when 
> > > > > intr_remapping_enabled is set?
> > > > 
> > > > yes, we can. The first idea came into my mind is to register a pm
> > > > notifier callback to allocate/free the memory. But that one duplicates
> > > > the code of alloc_ioapic_entries, which doesn't look nice, neither.
> > > > Plus, is there any problem with this one?
> > > > 
> > > 
> > > We try to avoid GFP_ATOMIC whenever possible and this seems like a 
> > > particularly trivial case.  You can simply move the alloc_ioapic_entries() 
> > > and NULL check before local_irq_save() and GFP_KERNEL will work fine.
> > 
> > I'm afraid not.
> > lapic_resume is invoked in sysdev_resume, which is done with irq
> > disabled, please refer to the code in kernel/power/suspend.c.
> > 
> >         arch_suspend_disable_irqs();
> >         BUG_ON(!irqs_disabled()); 
> > 
> >         error = sysdev_suspend(PMSG_SUSPEND);
> >         if (!error) {    
> >                 if (!suspend_test(TEST_CORE) &&
> > pm_check_wakeup_events()) {
> >                         error = suspend_ops->enter(state);
> >                         events_check_enabled = false;
> >                 }
> >                 sysdev_resume();
> >         }       
> >         
> >         arch_suspend_enable_irqs();
> >         BUG_ON(irqs_disabled());
> > 
> > To pre-allocate the memory, we need to build a notifier bloack and call
> > register_pm_notifier.
> 
> what about this one?

Quite frankly, I very much prefer the simple patch doing an atomic allocation.

Using GFP_KERNEL in a sysdev callback is a plain bug and should be fixed,
preferably in the simplest possible way (ie. replace GFP_KERNEL with
GFP_ATOMIC).

The question whether or not we can avoid allocating memory in there is a
different one and I'm not sure if the solution below is the most
straightforward one.

Thanks,
Rafael


> Note that it just builds okay, I have not test the patch yet.
> 
> pre-allocate the memory used in lapic_resume because lapic_resume, as a
> sysdev .resume callback, is always invoked with irq disabled.
> 
> Without this patch, I got the following warning messages after resume.
> [  109.780371] BUG: sleeping function called from invalid context at
> mm/slub.c:793
> [  109.780782] in_atomic(): 0, irqs_disabled(): 1, pid: 1391, name: bash
> [  109.781024] Pid: 1391, comm: bash Not tainted 2.6.37-rc5+ #182
> [  109.781264] Call Trace:
> [  109.781501]  [<ffffffff8104156a>] __might_sleep+0xeb/0xf0
> [  109.781743]  [<ffffffff8110d5e2>] slab_pre_alloc_hook.clone.33
> +0x28/0x31
> [  109.781987]  [<ffffffff8110dcef>] __kmalloc+0x88/0x115
> [  109.782224]  [<ffffffff81025e4a>] ? kzalloc.clone.19+0x13/0x15
> [  109.782465]  [<ffffffff81025e4a>] kzalloc.clone.19+0x13/0x15
> [  109.782704]  [<ffffffff81025ff0>] alloc_ioapic_entries+0x20/0x82
> [  109.782948]  [<ffffffff81024201>] lapic_resume+0x3a/0x245
> [  109.783189]  [<ffffffff813a8329>] ? cpufreq_resume+0x30/0xb0
> [  109.783431]  [<ffffffff812ec4ee>] __sysdev_resume+0x25/0xc5
> [  109.783673]  [<ffffffff812ec644>] sysdev_resume+0xb6/0xfb
> [  109.783914]  [<ffffffff81083256>] suspend_devices_and_enter
> +0x13c/0x1c1
> [  109.784159]  [<ffffffff810833b8>] enter_state+0xdd/0x12e
> [  109.784398]  [<ffffffff81082a61>] state_store+0xae/0xcb
> [  109.784640]  [<ffffffff81225737>] kobj_attr_store+0x17/0x19
> [  109.784882]  [<ffffffff81173311>] sysfs_write_file+0x114/0x150
> [  109.785124]  [<ffffffff8111aebb>] vfs_write+0xac/0xff
> [  109.785365]  [<ffffffff8111b0c2>] sys_write+0x4a/0x6e
> [  109.785604]  [<ffffffff8100ac82>] system_call_fastpath+0x16/0x1b
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  arch/x86/kernel/apic/apic.c |   38 +++++++++++++++++++++++++++++++++-----
>  1 file changed, 33 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/apic/apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/apic.c
> +++ linux-2.6/arch/x86/kernel/apic/apic.c
> @@ -34,6 +34,7 @@
>  #include <linux/nmi.h>
>  #include <linux/smp.h>
>  #include <linux/mm.h>
> +#include <linux/suspend.h>
>  
>  #include <asm/perf_event.h>
>  #include <asm/x86_init.h>
> @@ -2033,6 +2034,34 @@ static struct {
>  	unsigned int apic_thmr;
>  } apic_pm_state;
>  
> +static struct IO_APIC_route_entry **ioapic_entries;
> +
> +static int lapic_notifier_cb(struct notifier_block *nb,
> +			unsigned long val, void *unused)
> +{
> +	switch(val) {
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
> +	case PM_RESTORE_PREPARE:
> +		ioapic_entries = alloc_ioapic_entries();
> +		if (!ioapic_entries)
> +			return NOTIFY_BAD;
> +		return NOTIFY_OK;
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_SUSPEND:
> +	case PM_POST_RESTORE:
> +		free_ioapic_entries(ioapic_entries);
> +		ioapic_entries = NULL;
> +		return NOTIFY_OK;
> +	}
> +	return NOTIFY_BAD;
> +}
> +
> +static struct notifier_block lapic_pm_nb = {
> +	.notifier_call = lapic_notifier_cb,
> +	.priority = 0,
> +};
> +
>  static int lapic_suspend(struct sys_device *dev, pm_message_t state)
>  {
>  	unsigned long flags;
> @@ -2077,14 +2106,12 @@ static int lapic_resume(struct sys_devic
>  	unsigned long flags;
>  	int maxlvt;
>  	int ret = 0;
> -	struct IO_APIC_route_entry **ioapic_entries = NULL;
>  
>  	if (!apic_pm_state.active)
>  		return 0;
>  
>  	local_irq_save(flags);
>  	if (intr_remapping_enabled) {
> -		ioapic_entries = alloc_ioapic_entries();
>  		if (!ioapic_entries) {
>  			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
>  			ret = -ENOMEM;
> @@ -2094,7 +2121,6 @@ static int lapic_resume(struct sys_devic
>  		ret = save_IO_APIC_setup(ioapic_entries);
>  		if (ret) {
>  			WARN(1, "Saving IO-APIC state failed: %d\n", ret);
> -			free_ioapic_entries(ioapic_entries);
>  			goto restore;
>  		}
>  
> @@ -2145,7 +2171,6 @@ static int lapic_resume(struct sys_devic
>  		reenable_intr_remapping(x2apic_mode);
>  		legacy_pic->restore_mask();
>  		restore_IO_APIC_setup(ioapic_entries);
> -		free_ioapic_entries(ioapic_entries);
>  	}
>  restore:
>  	local_irq_restore(flags);
> @@ -2183,8 +2208,11 @@ static int __init init_lapic_sysfs(void)
>  	/* XXX: remove suspend/resume procs if !apic_pm_state.active? */
>  
>  	error = sysdev_class_register(&lapic_sysclass);
> -	if (!error)
> +	if (!error) {
>  		error = sysdev_register(&device_lapic);
> +        	if (!error)
> +			error = register_pm_notifier(&lapic_pm_nb);
> +	}
>  	return error;
>  }
>  
> 
> 
> 
> 

