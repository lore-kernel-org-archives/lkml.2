Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760367Ab0JZUUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:20:45 -0400
Received: from claw.goop.org ([74.207.240.146]:57888 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760247Ab0JZUUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:20:41 -0400
Message-ID: <4CC73816.50108@goop.org>
Date: Tue, 26 Oct 2010 13:20:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [Xen-devel] Re: [PATCH 1/5] xen: events: use irq_alloc_desc(_at)
 instead of open-coding an IRQ allocator.
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>  <1288023813-31989-1-git-send-email-ian.campbell@citrix.com>  <20101025173522.GA5590@dumpdata.com>  <1288029736.10179.35.camel@localhost.localdomain> <1288080948.10179.57.camel@localhost.localdomain> <alpine.DEB.2.00.1010261847150.1407@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1010261847150.1407@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/26/2010 12:49 PM, Stefano Stabellini wrote:
> On Tue, 26 Oct 2010, Ian Campbell wrote:
>> On Mon, 2010-10-25 at 19:02 +0100, Ian Campbell wrote:
>>>
>>>> What do you see when you pass in a PCI device and say give the guest
>>> 32 CPUs??
>>>
>>> I can try tomorrow and see, based on what you say above without
>>> implementing what I described I suspect the answer will be "carnage". 
>> Actually, it looks like multi-vcpu is broken, I only see 1 regardless of
>> how many I configured. It's not clear if this is breakage in Linus'
>> tree, something I pulled in from one of Jeremy's, yours or Stefano's
>> trees or some local pebcak. I'll investigate...
>  
> I found the bug, it was introduced by:
>
> "xen: use vcpu_ops to setup cpu masks"
>
> I have added the fix at the end of my branch and I am also appending the
> fix here.

Acked.

    J

> ---
>
>
> xen: initialize cpu masks for pv guests in xen_smp_init
>
> Pv guests don't have ACPI and need the cpu masks to be set
> correctly as early as possible so we call xen_fill_possible_map from
> xen_smp_init.
> On the other hand the initial domain supports ACPI so in this case we skip
> xen_fill_possible_map and rely on it. However Xen might limit the number
> of cpus usable by the domain, so we filter those masks during smp
> initialization using the VCPUOP_is_up hypercall.
> It is important that the filtering is done before
> xen_setup_vcpu_info_placement.
>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 1386767..834dfeb 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -28,6 +28,7 @@
>  #include <asm/xen/interface.h>
>  #include <asm/xen/hypercall.h>
>  
> +#include <xen/xen.h>
>  #include <xen/page.h>
>  #include <xen/events.h>
>  
> @@ -156,6 +157,25 @@ static void __init xen_fill_possible_map(void)
>  {
>  	int i, rc;
>  
> +	if (xen_initial_domain())
> +		return;
> +
> +	for (i = 0; i < nr_cpu_ids; i++) {
> +		rc = HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
> +		if (rc >= 0) {
> +			num_processors++;
> +			set_cpu_possible(i, true);
> +		}
> +	}
> +}
> +
> +static void __init xen_filter_cpu_maps(void)
> +{
> +	int i, rc;
> +
> +	if (!xen_initial_domain())
> +		return;
> +
>  	num_processors = 0;
>  	disabled_cpus = 0;
>  	for (i = 0; i < nr_cpu_ids; i++) {
> @@ -179,6 +199,7 @@ static void __init xen_smp_prepare_boot_cpu(void)
>  	   old memory can be recycled */
>  	make_lowmem_page_readwrite(xen_initial_gdt);
>  
> +	xen_filter_cpu_maps();
>  	xen_setup_vcpu_info_placement();
>  }
>  
> @@ -195,8 +216,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
>  	if (xen_smp_intr_init(0))
>  		BUG();
>  
> -	xen_fill_possible_map();
> -
>  	if (!alloc_cpumask_var(&xen_cpu_initialized_map, GFP_KERNEL))
>  		panic("could not allocate xen_cpu_initialized_map\n");
>  
> @@ -487,5 +506,6 @@ static const struct smp_ops xen_smp_ops __initdata = {
>  void __init xen_smp_init(void)
>  {
>  	smp_ops = xen_smp_ops;
> +	xen_fill_possible_map();
>  	xen_init_spinlocks();
>  }
>

