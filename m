Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab2APRfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 12:35:17 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:11048 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755607Ab2APRfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 12:35:15 -0500
Message-ID: <1326735308.3065.29.camel@bwh-desktop>
Subject: Re: [PATCH v5 03/12] x86/topology.c: Support functions for CPU0
 online/offline
From: Ben Hutchings <bhutchings@solarflare.com>
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Date: Mon, 16 Jan 2012 17:35:08 +0000
In-Reply-To: <1326301493-28760-4-git-send-email-fenghua.yu@intel.com>
References: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
	 <1326301493-28760-4-git-send-email-fenghua.yu@intel.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18648.005
X-TM-AS-Result: No--15.047800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 09:04 -0800, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> If CONFIG_BOOTPARAM_HOTPLUG_CPU is turned on, CPU0 hotplug feature is enabled
> by default.
> 
> If CONFIG_BOOTPARAM_HOTPLUG_CPU is not turned on, CPU0 hotplug feature is not
> enabled by default. The kernel parameter cpu0_hotplug can enable CPU0 hotplug
> feature at boot.
[...]
>  int __ref arch_register_cpu(int num)
>  {
>  	/*
> -	 * CPU0 cannot be offlined due to several
> -	 * restrictions and assumptions in kernel. This basically
> -	 * doesn't add a control file, one cannot attempt to offline
> -	 * BSP.
> +	 * Two known BSP/CPU0 dependencies: Resume from suspend/hibernate
> +	 * depends on BSP. PIC interrupts depend on BSP.
>  	 *
> -	 * Also certain PCI quirks require not to enable hotplug control
> -	 * for all CPU's.
> +	 * If the BSP depencies are under control, one can tell kernel to
> +	 * enable BSP hotplug. This basically adds a control file and
> +	 * one can attempt to offline BSP.
>  	 */
> -	if (num)
> +	if (num || cpu0_hotpluggable)
>  		per_cpu(cpu_devices, num).cpu.hotpluggable = 1;
>  
>  	return register_cpu(&per_cpu(cpu_devices, num).cpu, num);

This change belongs at the end of the series.  It should not be possible
to enable CPU0 hotplug until after the hotplug logic can do it
correctly, and this might break bisection.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

