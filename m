Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2HMQuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:50:44 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45708 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab2HMQun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:50:43 -0400
Date: Mon, 13 Aug 2012 09:50:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Silas Boyd-Wickizer <sbw@mit.edu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: [PATCH 2/4 V2] Use get_online_cpus to avoid races involving CPU
 hotplug
Message-ID: <20120813165021.GH2458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120803193449.GC4227@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120803193449.GC4227@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081316-7182-0000-0000-0000024305E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 12:34:50PM -0700, Silas Boyd-Wickizer wrote:
> If arch/x86/kernel/cpuid.c is a module, a CPU might offline or online
> between the for_each_online_cpu() loop and the call to
> register_hotcpu_notifier in cpuid_init or the call to
> unregister_hotcpu_notifier in cpuid_exit.  The potential races can
> lead to leaks/duplicates, attempts to destroy non-existant devices, or
> random pointer dereferences.
> 
> For example, in cpuid_exit if:
> 
>         for_each_online_cpu(cpu)
>                 cpuid_device_destroy(cpu);
>         class_destroy(cpuid_class);
>         __unregister_chrdev(CPUID_MAJOR, 0, NR_CPUS, "cpu/cpuid");
>         <----- CPU onlines
>         unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
> 
> the hotcpu notifier will attempt to create a device for the
> cpuid_class, which the module already destroyed.
> 
> This fix surrounds for_each_online_cpu and register_hotcpu_notifier or
> unregister_hotcpu_notifier with get_online_cpus+put_online_cpus.
> 
> Tested on a VM.
> 
> Signed-off-by: Silas Boyd-Wickizer <sbw@mit.edu>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  arch/x86/kernel/cpuid.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
> index 39472dd..60c7891 100644
> --- a/arch/x86/kernel/cpuid.c
> +++ b/arch/x86/kernel/cpuid.c
> @@ -199,12 +199,14 @@ static int __init cpuid_init(void)
>  		goto out_chrdev;
>  	}
>  	cpuid_class->devnode = cpuid_devnode;
> +	get_online_cpus();
>  	for_each_online_cpu(i) {
>  		err = cpuid_device_create(i);
>  		if (err != 0)
>  			goto out_class;
>  	}
>  	register_hotcpu_notifier(&cpuid_class_cpu_notifier);
> +	put_online_cpus();
> 
>  	err = 0;
>  	goto out;
> @@ -214,6 +216,7 @@ out_class:
>  	for_each_online_cpu(i) {
>  		cpuid_device_destroy(i);
>  	}
> +	put_online_cpus();
>  	class_destroy(cpuid_class);
>  out_chrdev:
>  	__unregister_chrdev(CPUID_MAJOR, 0, NR_CPUS, "cpu/cpuid");
> @@ -225,11 +228,13 @@ static void __exit cpuid_exit(void)
>  {
>  	int cpu = 0;
> 
> +	get_online_cpus();
>  	for_each_online_cpu(cpu)
>  		cpuid_device_destroy(cpu);
>  	class_destroy(cpuid_class);
>  	__unregister_chrdev(CPUID_MAJOR, 0, NR_CPUS, "cpu/cpuid");
>  	unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
> +	put_online_cpus();
>  }
> 
>  module_init(cpuid_init);
> -- 
> 1.7.10.4
> 

