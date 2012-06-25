Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab2FYNyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:54:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756971Ab2FYNyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:54:02 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] acpi, cpuidle: Register with cpuidle even if cpu is onlined after boot (beyond maxcpus)
Date: Mon, 25 Jun 2012 15:53:55 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>, lenb@kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <4FDB549F.1020002@linaro.org> <4FE027AC.8010607@linaro.org> <4FE84AB7.6020305@linux.vnet.ibm.com>
In-Reply-To: <4FE84AB7.6020305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206251553.55867.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 25, 2012 01:25:43 PM Srivatsa S. Bhat wrote:
> 
> Daniel Lezcano noticed that after booting with maxcpus=X, if we online the
> remaining cpus by writing: echo 1 > /sys/devices/system/cpu/cpuY/online, then
> for the newly onlined cpus, the cpuidle directory is not found under
> /sys/devices/system/cpu/cpuY.
> 
> Partly, the reason for this is that acpi restricts the initialization to cpus
> within the maxcpus limit. (See commit 75cbfb9 "ACPI: Do not try to set up acpi
> processor stuff on cores exceeding maxcpus="). The maxcpus= kernel parameter is
> used to restrict the number of cpus brought up during boot. That doesn't mean
> that we should hard restrict the bring up of the remaining cpus later on.

Sorry, but IMO it exaclty does mean that (adding more general lists for
further comments).

If you can online more cores than maxcpus= via sysfs, this sounds like a bug.
Not the other way around.

Compare with Documentation/kernel-parameters.txt:
        maxcpus=        [SMP] Maximum number of processors that an SMP kernel
                        should make use of.  maxcpus=n : n >= 0 limits the
                        kernel to using 'n' processors.  n=0 is a special case,
                        it is equivalent to "nosmp", which also disables
                        the IO APIC.

Chances that you run into more problems are high.
It would help if it is explained why at all this would be needed.

If there really is a valid use-case, possibly a bootcpus= param could get
defined or above documentation is adjusted. But this would need thorough
double checking, because I expect maxcpus=X was never intended to bring up
more than X cores later via sysfs and I expect there are more
places where things have to get ajusted.

    Thomas

> So
> teach acpi to play nice with maxcpus= parameter, and perform the initialization
> for all present cpus, but defer their startup to the point when they are
> actually onlined later.
> 
> But that alone won't suffice as a fix, because there is one more thing that
> the present but !online cpus lack - the need_hotplug_init flag.
> The need_hotplug_init flag is set only for physically hotplugged cpus and not
> for cpus which were already present but not brought online during boot (due to
> the maxcpus= parameter). For cpus with this flag set, during the online
> operation, acpi_cpu_soft_notify() takes care of the registration with cpuidle.
> So, in order to allow the present but !online cpus to be onlined later with
> full features (by making use of acpi_cpu_soft_notify()), set their
> need_hotplug_init flag.
> 
> Reported-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> ---
> 
> Daniel, this patch works for me. Does it work for you as well?
> 
>  drivers/acpi/processor_driver.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index 0734086..f29d30f 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -551,11 +551,6 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
>  		return 0;
>  	}
>  
> -#ifdef CONFIG_SMP
> -	if (pr->id >= setup_max_cpus && pr->id != 0)
> -		return 0;
> -#endif
> -
>  	BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
>  
>  	/*
> @@ -580,6 +575,17 @@ static int __cpuinit acpi_processor_add(struct acpi_device *device)
>  		goto err_clear_processor;
>  	}
>  
> +#ifdef CONFIG_SMP
> +	if (pr->id >= setup_max_cpus && pr->id != 0) {
> +		/*
> +		 * Don't start cpus beyond maxcpus now. But allow them to
> +		 * to be brought online later.
> +		 */
> +		pr->flags.need_hotplug_init = 1;
> +		return 0;
> +	}
> +#endif
> +
>  	/*
>  	 * Do not start hotplugged CPUs now, but when they
>  	 * are onlined the first time
> 
> 
> 

