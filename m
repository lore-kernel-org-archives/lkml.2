Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384Ab1ETO03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:26:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39610 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933715Ab1ETO01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:26:27 -0400
Message-ID: <4DD679F8.10002@kernel.org>
Date: Fri, 20 May 2011 07:26:00 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, steiner@sgi.com,
        linux-kernel@vger.kernel.org, gorcunov@openvz.org
Subject: Re: [patch 6/6] x86, apic: use .apicdrivers section to find the list
 of apic drivers
References: <20110519234545.700125442@sbsiddha-MOBL3.sc.intel.com> <20110519234637.671736436@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <20110519234637.671736436@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4DD67A04.0062,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2011 04:45 PM, Suresh Siddha wrote:
> --- linux-2.6-tip.orig/arch/x86/kernel/apic/apic_flat_64.c
> +++ linux-2.6-tip/arch/x86/kernel/apic/apic_flat_64.c
> @@ -24,6 +24,8 @@
>  #include <acpi/acpi_bus.h>
>  #endif
>  
> +static struct apic apic_physflat;
> +
>  static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>  {
>  	return 1;
> @@ -164,7 +166,7 @@ static int flat_phys_pkg_id(int initial_
>  	return initial_apic_id >> index_msb;
>  }
>  
> -struct apic apic_flat =  {
> +static struct apic apic_flat =  {
>  	.name				= "flat",
>  	.probe				= NULL,
>  	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
> @@ -320,7 +322,7 @@ static int physflat_probe(void)
>  	return 0;
>  }
>  
> -struct apic apic_physflat =  {
> +static struct apic apic_physflat =  {
>  
>  	.name				= "physical flat",
>  	.probe				= physflat_probe,
> @@ -377,3 +379,8 @@ struct apic apic_physflat =  {
>  	.wait_icr_idle			= native_apic_wait_icr_idle,
>  	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
>  };
> +
> +/*
> + * We need to check for physflat first, so this order is important.
> + */
> +apic_drivers(apic_physflat, apic_flat);
> Index: linux-2.6-tip/arch/x86/kernel/apic/probe_64.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/x86/kernel/apic/probe_64.c
> +++ linux-2.6-tip/arch/x86/kernel/apic/probe_64.c
> @@ -23,27 +23,9 @@
>  #include <asm/ipi.h>
>  #include <asm/setup.h>
>  
> -extern struct apic apic_flat;
> -extern struct apic apic_physflat;
> -extern struct apic apic_x2xpic_uv_x;
> -extern struct apic apic_x2apic_phys;
> -extern struct apic apic_x2apic_cluster;
> -
> -struct apic __read_mostly *apic = &apic_flat;
> +struct apic __read_mostly *apic;
>  EXPORT_SYMBOL_GPL(apic);
>  
> -static struct apic *apic_probe[] __initdata = {
> -#ifdef CONFIG_X86_UV
> -	&apic_x2apic_uv_x,
> -#endif
> -#ifdef CONFIG_X86_X2APIC
> -	&apic_x2apic_phys,
> -	&apic_x2apic_cluster,
> -#endif
> -	&apic_physflat,
> -	NULL,
> -};
> -
>  static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
>  {
>  	return hard_smp_processor_id() >> index_msb;
> @@ -54,19 +36,19 @@ static int apicid_phys_pkg_id(int initia
>   */
>  void __init default_setup_apic_routing(void)
>  {
> -	int i;
> +	struct apic **drv;
>  
>  	enable_IR_x2apic();
>  
> -	for (i = 0; apic_probe[i]; ++i) {
> -		if (apic_probe[i]->probe()) {
> -			apic = apic_probe[i];
> +	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
> +		if ((*drv)->probe()) {
> +			apic = *drv;
> +			printk(KERN_INFO "APIC routing finalized to %s.\n",
> +			       apic->name);
>  			break;
>  		}
>  	}

can you change to:

+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if ((*drv)->probe()) {
+			if (apic != *drv) {
+				apic = *drv;				
+				printk(KERN_INFO "Changing APIC routing to %s.\n",
+				       apic->name);
+			}
 			break;
 		}
 	}

Thanks

Yinghai
