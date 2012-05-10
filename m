Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2EJI1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:27:50 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:54107 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab2EJI1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:27:47 -0400
Date: Thu, 10 May 2012 10:27:31 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, riel@redhat.com,
        luto@mit.edu, avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/7] x86/tlb: add tlb_flushall_factor into sysfs for
 user testing/tuning
Message-ID: <20120510082731.GC30055@aftab.osrc.amd.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
 <1336626013-28413-8-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336626013-28413-8-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 01:00:13PM +0800, Alex Shi wrote:
> kernel will replace cr3 rewrite with invlpg when
>   tlb_flush_entries <= active_tlb_entries / 2^tlb_flushall_factor
> if tlb_flushall_factor is -1, kernel won't do this replacement.
> 
> User can modify its value according to specific applications.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>

Just minor nitpicks below.

> ---
>  Documentation/ABI/testing/sysfs-devices-system-cpu |   12 ++++++
>  arch/x86/Kconfig.debug                             |   11 ++++++
>  arch/x86/kernel/cpu/common.c                       |   37 ++++++++++++++++++++
>  drivers/base/cpu.c                                 |    4 ++
>  include/linux/cpu.h                                |    4 ++
>  5 files changed, 68 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index e7be75b..05f8eb7 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -78,6 +78,18 @@ Description:	Dynamic addition and removal of CPU's.  This is not hotplug
>  		the system.  Information writtento the file to remove CPU's
>  		is architecture specific.
>  
> +What:		/sys/devices/system/cpu/tlb_flushall_factor
> +Date:		May 2012
> +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> +Description:	tlb_flushall_factor show and setting interface
> +		tlb_flushall_factor shows the balance point in replacing cr3
> +		writting with multiple 'invlpg'. It will do this replacement
> +		when flush_tlb_lines <= active_lines/2^tlb_flushall_factor
> +		If tlb_flushall_factor is -1, means the replacement will be
> +		disabled.
> +
> +		User can set this for the specific CPU or application.
> +
>  What:		/sys/devices/system/cpu/cpu#/node
>  Date:		October 2009
>  Contact:	Linux memory management mailing list <linux-mm@kvack.org>
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index e46c214..5b87493 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -129,6 +129,17 @@ config DOUBLEFAULT
>  	  option saves about 4k and might cause you much additional grey
>  	  hair.
>  
> +config DEBUG_TLBFLUSH
> +	bool "Enable user level tlb flush all setting"

	bool "Set top limit of TLB entries to flush one-by-one"

> +	depends on DEBUG_KERNEL && (X86_64 || X86_INVLPG)
> +	---help---
> +	  This option allows user tune tlb_flushall_factor knob that under

			allows the user to tune the	... (remove "that")

> +	  /sys/devices/system/cpu, set to -1 means do tlb flush all for any

				 . Set to -1 means to flush the whole TLB for any

> +	  multiple tlb lines evacuation demand. Otherwise kernel will use
> +	  multiple 'invlpg' for the demand when
> +	      flush_lines <= active_tlb_lines / 2^tlb_flushall_factor
> +	  If in doubt, say "N"
> +
>  config IOMMU_DEBUG
>  	bool "Enable IOMMU debugging"
>  	depends on GART_IOMMU && DEBUG_KERNEL
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 8879d20..d1986c6 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -481,6 +481,43 @@ void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
>  		tlb_flushall_factor);
>  }
>  
> +#ifdef CONFIG_DEBUG_TLBFLUSH
> +static ssize_t __tlb_flushall_factor_store(const char *buf,
> +					size_t count, int smt)
> +{
> +	short factor = 0;
> +
> +	if (sscanf(buf, "%hd", &factor) != 1)
> +		return -EINVAL;

This means only single-digit factors, right?

Why not use kstrtoul?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
