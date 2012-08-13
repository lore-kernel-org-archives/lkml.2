Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2HMQwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:52:07 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:55155 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2HMQwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:52:01 -0400
Date: Mon, 13 Aug 2012 09:50:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Silas Boyd-Wickizer <sbw@mit.edu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/4 V2] Use get_online_cpus to avoid races involving CPU
 hotplug
Message-ID: <20120813165000.GG2458@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120803193327.GB4227@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120803193327.GB4227@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081316-5518-0000-0000-000006CCDFF7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 12:33:27PM -0700, Silas Boyd-Wickizer wrote:
> If arch/x86/kernel/msr.c is a module, a CPU might offline or online
> between the for_each_online_cpu(i) loop and the call to
> register_hotcpu_notifier in msr_init or the call to
> unregister_hotcpu_notifier in msr_exit. The potential races can lead
> to leaks/duplicates, attempts to destroy non-existant devices, or
> random pointer dereferences.
> 
> For example, in msr_init if:
> 
>         for_each_online_cpu(i) {
>                 err = msr_device_create(i);
>                 if (err != 0)
>                         goto out_class;
>         }
>         <----- CPU offlines
>         register_hotcpu_notifier(&msr_class_cpu_notifier);
> 
> and the CPU never onlines before msr_exit, then the module will never
> call msr_device_destroy for the associated CPU.
> 
> This fix surrounds for_each_online_cpu and register_hotcpu_notifier or
> unregister_hotcpu_notifier with get_online_cpus+put_online_cpus.
> 
> Tested on a VM.
> 
> Signed-off-by: Silas Boyd-Wickizer <sbw@mit.edu>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  arch/x86/kernel/msr.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
> index eb11369..a7c5661 100644
> --- a/arch/x86/kernel/msr.c
> +++ b/arch/x86/kernel/msr.c
> @@ -257,12 +257,14 @@ static int __init msr_init(void)
>  		goto out_chrdev;
>  	}
>  	msr_class->devnode = msr_devnode;
> +	get_online_cpus();
>  	for_each_online_cpu(i) {
>  		err = msr_device_create(i);
>  		if (err != 0)
>  			goto out_class;
>  	}
>  	register_hotcpu_notifier(&msr_class_cpu_notifier);
> +	put_online_cpus();
> 
>  	err = 0;
>  	goto out;
> @@ -271,6 +273,7 @@ out_class:
>  	i = 0;
>  	for_each_online_cpu(i)
>  		msr_device_destroy(i);
> +	put_online_cpus();
>  	class_destroy(msr_class);
>  out_chrdev:
>  	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
> @@ -281,11 +284,13 @@ out:
>  static void __exit msr_exit(void)
>  {
>  	int cpu = 0;
> +	get_online_cpus();
>  	for_each_online_cpu(cpu)
>  		msr_device_destroy(cpu);
>  	class_destroy(msr_class);
>  	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
>  	unregister_hotcpu_notifier(&msr_class_cpu_notifier);
> +	put_online_cpus();
>  }
> 
>  module_init(msr_init);
> -- 
> 1.7.10.4
> 

