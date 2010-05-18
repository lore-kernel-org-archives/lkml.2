Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab0ERSLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:11:18 -0400
Received: from claw.goop.org ([74.207.240.146]:45719 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209Ab0ERSLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:11:11 -0400
Message-ID: <4BF2D83E.2090204@goop.org>
Date: Tue, 18 May 2010 11:11:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 07/12] Add suspend\resume support for PV on HVM guests.
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop> <1274178187-20602-7-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1274178187-20602-7-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 03:23 AM, Stefano Stabellini wrote:

"/"

Please describe what's needed to support suspend/resume.  Is this a
normal x86 ACPI suspend/resume, or a Xen save/restore?

> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/enlighten.c          |    9 ++--
>  arch/x86/xen/suspend.c            |    6 ++
>  arch/x86/xen/xen-ops.h            |    3 +
>  drivers/xen/manage.c              |   95 +++++++++++++++++++++++++++++++++++--
>  drivers/xen/platform-pci.c        |   29 +++++++++++-
>  drivers/xen/xenbus/xenbus_probe.c |   28 +++++++++++
>  include/xen/platform_pci.h        |    6 ++
>  include/xen/xen-ops.h             |    3 +
>  8 files changed, 170 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index aac47b0..23b8200 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1268,12 +1268,13 @@ static int init_hvm_pv_info(int *major, int *minor)
>  	return 0;
>  }
>  
> -static void __init init_shared_info(void)
> +void init_shared_info(void)
>  {
>  	struct xen_add_to_physmap xatp;
> -	struct shared_info *shared_info_page;
> +	static struct shared_info *shared_info_page = 0;
>  
> -	shared_info_page = (struct shared_info *) alloc_bootmem_pages(PAGE_SIZE);
> +	if (!shared_info_page)
> +		shared_info_page = (struct shared_info *) alloc_bootmem_pages(PAGE_SIZE);
>  	xatp.domid = DOMID_SELF;
>  	xatp.idx = 0;
>  	xatp.space = XENMAPSPACE_shared_info;
> @@ -1302,7 +1303,7 @@ void do_hvm_pv_evtchn_intr(void)
>  	xen_hvm_evtchn_do_upcall(get_irq_regs());
>  }
>  
> -static void xen_callback_vector(void)
> +void xen_callback_vector(void)
>  {
>  	uint64_t callback_via;
>  	if (xen_feature(XENFEAT_hvm_callback_vector)) {
> diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
> index 987267f..86f3b45 100644
> --- a/arch/x86/xen/suspend.c
> +++ b/arch/x86/xen/suspend.c
> @@ -26,6 +26,12 @@ void xen_pre_suspend(void)
>  		BUG();
>  }
>  
> +void xen_hvm_post_suspend(int suspend_cancelled)
> +{
> +		init_shared_info();
> +		xen_callback_vector();
> +}
> +
>  void xen_post_suspend(int suspend_cancelled)
>  {
>  	xen_build_mfn_list_list();
> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> index f9153a3..caf89ee 100644
> --- a/arch/x86/xen/xen-ops.h
> +++ b/arch/x86/xen/xen-ops.h
> @@ -38,6 +38,9 @@ void xen_enable_sysenter(void);
>  void xen_enable_syscall(void);
>  void xen_vcpu_restore(void);
>  
> +void xen_callback_vector(void);
> +void init_shared_info(void);
> +
>  void __init xen_build_dynamic_phys_to_machine(void);
>  
>  void xen_init_irq_ops(void);
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index 2ac4440..a73edd8 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -8,15 +8,20 @@
>  #include <linux/sysrq.h>
>  #include <linux/stop_machine.h>
>  #include <linux/freezer.h>
> +#include <linux/pci.h>
> +#include <linux/cpumask.h>
>  
> +#include <xen/xen.h>
>  #include <xen/xenbus.h>
>  #include <xen/grant_table.h>
>  #include <xen/events.h>
>  #include <xen/hvc-console.h>
>  #include <xen/xen-ops.h>
> +#include <xen/platform_pci.h>
>  
>  #include <asm/xen/hypercall.h>
>  #include <asm/xen/page.h>
> +#include <asm/xen/hypervisor.h>
>  
>  enum shutdown_state {
>  	SHUTDOWN_INVALID = -1,
> @@ -33,10 +38,30 @@ enum shutdown_state {
>  static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
>  
>  #ifdef CONFIG_PM_SLEEP
> -static int xen_suspend(void *data)
> +static int xen_hvm_suspend(void *data)
>  {
> +	struct sched_shutdown r = { .reason = SHUTDOWN_suspend };
>  	int *cancelled = data;
> +
> +	BUG_ON(!irqs_disabled());
> +
> +	*cancelled = HYPERVISOR_sched_op(SCHEDOP_shutdown, &r);
> +
> +	xen_hvm_post_suspend(*cancelled);
> +	gnttab_resume();
> +
> +	if (!*cancelled) {
> +		xen_irq_resume();
> +		platform_pci_resume();
> +	}
> +
> +	return 0;
> +}
> +
> +static int xen_suspend(void *data)
> +{
>  	int err;
> +	int *cancelled = data;
>  
>  	BUG_ON(!irqs_disabled());
>  
> @@ -73,6 +98,53 @@ static int xen_suspend(void *data)
>  	return 0;
>  }
>  
> +static void do_hvm_suspend(void)
> +{
> +	int err;
> +	int cancelled = 1;
> +
> +	shutting_down = SHUTDOWN_SUSPEND;
> +
> +#ifdef CONFIG_PREEMPT
> +	/* If the kernel is preemptible, we need to freeze all the processes
> +	   to prevent them from being in the middle of a pagetable update
> +	   during suspend. */
> +	err = freeze_processes();
> +	if (err) {
> +		printk(KERN_ERR "xen suspend: freeze failed %d\n", err);
> +		goto out;
> +	}
> +#endif
> +
> +	printk(KERN_DEBUG "suspending xenstore... ");
> +	xenbus_suspend();
> +	printk(KERN_DEBUG "xenstore suspended\n");
> +	platform_pci_disable_irq();
> +	
> +	err = stop_machine(xen_hvm_suspend, &cancelled, cpumask_of(0));
> +	if (err) {
> +		printk(KERN_ERR "failed to start xen_suspend: %d\n", err);
> +		cancelled = 1;
> +	}
> +
> +	platform_pci_enable_irq();
> +
> +	if (!cancelled) {
> +		xen_arch_resume();
> +		xenbus_resume();
> +	} else
> +		xs_suspend_cancel();
> +
> +	/* Make sure timer events get retriggered on all CPUs */
> +	clock_was_set();
> +
> +#ifdef CONFIG_PREEMPT
> +	thaw_processes();
> +out:
> +#endif
> +	shutting_down = SHUTDOWN_INVALID;
> +}
> +
>  static void do_suspend(void)
>  {
>  	int err;
> @@ -185,7 +257,10 @@ static void shutdown_handler(struct xenbus_watch *watch,
>  		ctrl_alt_del();
>  #ifdef CONFIG_PM_SLEEP
>  	} else if (strcmp(str, "suspend") == 0) {
> -		do_suspend();
> +		if (xen_hvm_domain())
> +			do_hvm_suspend();
>   

Why does HVM come via this path?  Wouldn't ACPI S3 be a better match for
HVM?  Does this make sure the full device model suspend/resume callbacks
get called?  Previously I think we cut corners because we knew there
wouldn't be any PCI devices in the system...

And if the full device model is being used properly, then can't all this
hvm-specific stuff be done in the platform pci driver itself, rather
than here?  Is checkpoint the issue?  (Is checkpointing hvm domains
supported?)

> +		else
> +			do_suspend();
>  #endif
>  	} else {
>  		printk(KERN_INFO "Ignoring shutdown request: %s\n", str);
> @@ -261,7 +336,19 @@ static int shutdown_event(struct notifier_block *notifier,
>  	return NOTIFY_DONE;
>  }
>  
> -static int __init setup_shutdown_event(void)
> +static int __init __setup_shutdown_event(void)
> +{
> +	/* Delay initialization in the PV on HVM case */
> +	if (xen_hvm_domain())
> +		return 0;
> +
> +	if (!xen_pv_domain())
> +		return -ENODEV;
> +
> +	return xen_setup_shutdown_event();
> +}
> +
> +int xen_setup_shutdown_event(void)
>  {
>  	static struct notifier_block xenstore_notifier = {
>  		.notifier_call = shutdown_event
> @@ -271,4 +358,4 @@ static int __init setup_shutdown_event(void)
>  	return 0;
>  }
>  
> -subsys_initcall(setup_shutdown_event);
> +subsys_initcall(__setup_shutdown_event);
> diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
> index 7a8da66..b15f809 100644
> --- a/drivers/xen/platform-pci.c
> +++ b/drivers/xen/platform-pci.c
> @@ -33,6 +33,7 @@
>  #include <xen/xenbus.h>
>  #include <xen/events.h>
>  #include <xen/hvm.h>
> +#include <xen/xen-ops.h>
>  
>  #define DRV_NAME    "xen-platform-pci"
>  
> @@ -43,6 +44,8 @@ MODULE_LICENSE("GPL");
>  static unsigned long platform_mmio;
>  static unsigned long platform_mmio_alloc;
>  static unsigned long platform_mmiolen;
> +static uint64_t callback_via;
> +struct pci_dev *xen_platform_pdev;
>  
>  unsigned long alloc_xen_mmio(unsigned long len)
>  {
> @@ -87,13 +90,33 @@ static int xen_allocate_irq(struct pci_dev *pdev)
>  			"xen-platform-pci", pdev);
>  }
>  
> +void platform_pci_disable_irq(void)
>   

If these are non-static they need a xen_ prefix.  In fact
"platform_pci_" is too generic anyway, and they should all have xen_
prefixes.

Aside from that, why do they need to be externally callable?  Can't the
pci device's own suspend/resume handlers do this?

> +{
> +	printk(KERN_DEBUG "platform_pci_disable_irq\n");
> +	disable_irq(xen_platform_pdev->irq);
> +}
> +
> +void platform_pci_enable_irq(void)
> +{
> +	printk(KERN_DEBUG "platform_pci_enable_irq\n");
> +	enable_irq(xen_platform_pdev->irq);
> +}
> +
> +void platform_pci_resume(void)
> +{
> +	if (!xen_have_vector_callback && xen_set_callback_via(callback_via)) {
> +		printk("platform_pci_resume failure!\n");
> +		return;
> +	}
> +}
> +
>  static int __devinit platform_pci_init(struct pci_dev *pdev,
>  				       const struct pci_device_id *ent)
>  {
>  	int i, ret;
>  	long ioaddr, iolen;
>  	long mmio_addr, mmio_len;
> -	uint64_t callback_via;
> +	xen_platform_pdev = pdev;
>  
>  	i = pci_enable_device(pdev);
>  	if (i)
> @@ -152,6 +175,10 @@ static int __devinit platform_pci_init(struct pci_dev *pdev,
>  	ret = xenbus_probe_init();
>  	if (ret)
>  		goto out;
> +	ret = xen_setup_shutdown_event();
> +	if (ret)
> +		goto out;
> +
>  
>  out:
>  	if (ret) {
> diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
> index dc6ed06..a679205 100644
> --- a/drivers/xen/xenbus/xenbus_probe.c
> +++ b/drivers/xen/xenbus/xenbus_probe.c
> @@ -746,6 +746,34 @@ static int xenbus_dev_resume(struct device *dev)
>  	return 0;
>  }
>  
> +static int dev_suspend(struct device *dev, void *data)
> +{
> +	return xenbus_dev_suspend(dev, PMSG_SUSPEND);
> +}
> +
> +void xenbus_suspend(void)
> +{
> +	DPRINTK("");
> +
> +	bus_for_each_dev(&xenbus_frontend.bus, NULL, NULL, dev_suspend);
> +	xs_suspend();
> +}
> +EXPORT_SYMBOL_GPL(xenbus_suspend);
> +
> +static int dev_resume(struct device *dev, void *data)
> +{
> +	return xenbus_dev_resume(dev);
> +}
> +
> +void xenbus_resume(void)
> +{
> +	DPRINTK("");
> +
> +	xs_resume();
> +	bus_for_each_dev(&xenbus_frontend.bus, NULL, NULL, dev_resume);
> +}
> +EXPORT_SYMBOL_GPL(xenbus_resume);
> +
>  /* A flag to determine if xenstored is 'ready' (i.e. has started) */
>  int xenstored_ready = 0;
>  
> diff --git a/include/xen/platform_pci.h b/include/xen/platform_pci.h
> index 59a120c..ced434d 100644
> --- a/include/xen/platform_pci.h
> +++ b/include/xen/platform_pci.h
> @@ -31,11 +31,17 @@
>  
>  #ifdef CONFIG_XEN_PLATFORM_PCI
>  unsigned long alloc_xen_mmio(unsigned long len);
> +void platform_pci_resume(void);
> +void platform_pci_disable_irq(void);
> +void platform_pci_enable_irq(void);
>  #else
>  static inline unsigned long alloc_xen_mmio(unsigned long len)
>  {
>  	return ~0UL;
>  }
> +static inline void platform_pci_resume(void) {}
> +static inline void platform_pci_disable_irq(void) {}
> +static inline void platform_pci_enable_irq(void) {}
>  #endif
>  
>  #endif /* _XEN_PLATFORM_PCI_H */
> diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
> index 883a21b..46bc81e 100644
> --- a/include/xen/xen-ops.h
> +++ b/include/xen/xen-ops.h
> @@ -7,6 +7,7 @@ DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
>  
>  void xen_pre_suspend(void);
>  void xen_post_suspend(int suspend_cancelled);
> +void xen_hvm_post_suspend(int suspend_cancelled);
>  
>  void xen_mm_pin_all(void);
>  void xen_mm_unpin_all(void);
> @@ -14,4 +15,6 @@ void xen_mm_unpin_all(void);
>  void xen_timer_resume(void);
>  void xen_arch_resume(void);
>  
> +int xen_setup_shutdown_event(void);
> +
>  #endif /* INCLUDE_XEN_OPS_H */
>   

