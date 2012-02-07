Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab2BGUHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 15:07:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062Ab2BGUHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 15:07:13 -0500
Date: Tue, 7 Feb 2012 17:47:35 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        jacob.jun.pan@linux.intel.com, alan@linux.intel.com,
        feng.tang@intel.com, konrad.wilk@oracle.com, avi@redhat.com,
        glommer@redhat.com, johnstul@us.ibm.com, riel@redhat.com,
        tj@kernel.org, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH] Introduce x86_cpuinit.early_percpu_clock_init hook
Message-ID: <20120207194735.GB20618@amt.cnet>
References: <1328626364-22591-1-git-send-email-imammedo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328626364-22591-1-git-send-email-imammedo@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 03:52:44PM +0100, Igor Mammedov wrote:
> When kvm guest uses kvmclock, it may hang on vcpu hot-plug.
> This is caused by an overflow in pvclock_get_nsec_offset,
> 
>     u64 delta = tsc - shadow->tsc_timestamp;
> 
> which in turn is caused by an undefined values from percpu
> hv_clock that hasn't been initialized yet.
> Uninitialized clock on being booted cpu is accessed from
>    start_secondary
>     -> smp_callin
>       ->  smp_store_cpu_info
>         -> identify_secondary_cpu
>           -> mtrr_ap_init
>             -> mtrr_restore
>               -> stop_machine_from_inactive_cpu
>                 -> queue_stop_cpus_work
>                   ...
>                     -> sched_clock
>                       -> kvm_clock_read
> which is well before x86_cpuinit.setup_percpu_clockev call in
> start_secondary, where percpu clock is initialized.
> 
> This patch introduces a hook that allows to setup/initialize
> per_cpu clock early and avoid overflow due to reading
>   - undefined values
>   - old values if cpu was offlined and then onlined again
> 
> Another possible early user of this clock source is ftrace that
> accesses it to get timestamps for ring buffer entries. So if
> mtrr_ap_init is moved from identify_secondary_cpu to past
> x86_cpuinit.setup_percpu_clockev in start_secondary, ftrace
> may cause the same overflow/hang on cpu hot-plug anyway.
> 
> More complete description of the problem:
>   https://lkml.org/lkml/2012/2/2/101
> 
> Credits to Marcelo Tosatti <mtosatti@redhat.com> for hook idea.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  arch/x86/include/asm/x86_init.h |    2 ++
>  arch/x86/kernel/kvmclock.c      |    4 +---
>  arch/x86/kernel/smpboot.c       |    1 +
>  arch/x86/kernel/x86_init.c      |    1 +
>  4 files changed, 5 insertions(+), 3 deletions(-)

Applied, thanks.

