Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab1AGNJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:09:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:49543 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1AGNJ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:09:28 -0500
Subject: Re: [PATCH 3/6] x86, NMI: Add priorities to handlers
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Robert Richter <robert.richter@amd.com>,
        ying.huang@intel.com, gorcunov@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1294348732-15030-4-git-send-email-dzickus@redhat.com>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
	 <1294348732-15030-4-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 07 Jan 2011 14:09:51 +0100
Message-ID: <1294405791.2016.450.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 16:18 -0500, Don Zickus wrote:
> In order to consolidate the NMI die_chain events, we need to setup the priorities
> for the die notifiers.
> 
> I started by defining a bunch of common priorities that can be used by the
> notifier blocks.  Then I modified the notifier blocks to use the newly created
> priorities.
> 
> Now that the priorities are straightened out, it should be easier to remove the
> event DIE_NMI_IPI.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/include/asm/nmi.h              |   20 ++++++++++++++++++++
>  arch/x86/kernel/apic/hw_nmi.c           |    2 +-
>  arch/x86/kernel/cpu/mcheck/mce-inject.c |    2 +-
>  arch/x86/kernel/cpu/perf_event.c        |    2 +-
>  arch/x86/kernel/kgdb.c                  |    2 +-
>  arch/x86/kernel/reboot.c                |    2 ++
>  arch/x86/oprofile/nmi_int.c             |    2 +-
>  arch/x86/oprofile/nmi_timer_int.c       |    2 +-
>  8 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
> index c4021b9..fb82fb6 100644
> --- a/arch/x86/include/asm/nmi.h
> +++ b/arch/x86/include/asm/nmi.h
> @@ -23,6 +23,26 @@ void arch_trigger_all_cpu_backtrace(void);
>  #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
>  #endif
>  
> +/*
> + * Define some priorities for the nmi notifier call chain.
> + *
> + * Create a local nmi bit that has a higher priority than
> + * external nmis, because the local ones are more frequent.
> + * 
> + * Also setup some default high/normal/low settings for
> + * subsystems to registers with.  Using 4 bits to seperate
> + * the priorities.  This can go alot higher if needed be.
> + */
> +
> +#define NMI_LOCAL_SHIFT		16	/* randomly picked */
> +#define NMI_LOCAL_BIT		(1ULL << NMI_LOCAL_SHIFT)
> +#define NMI_HIGH_PRIOR		(1ULL << 8)
> +#define NMI_NORMAL_PRIOR	(1ULL << 4)
> +#define NMI_LOW_PRIOR		(1ULL << 0)
> +#define NMI_LOCAL_HIGH_PRIOR	(NMI_LOCAL_BIT | NMI_HIGH_PRIOR)
> +#define NMI_LOCAL_NORMAL_PRIOR	(NMI_LOCAL_BIT | NMI_NORMAL_PRIOR)
> +#define NMI_LOCAL_LOW_PRIOR	(NMI_LOCAL_BIT | NMI_LOW_PRIOR)
> +
>  void stop_nmi(void);
>  void restart_nmi(void);
>  
 
>  static struct event_constraint unconstrained;
> diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
> index cd21b65..983fb54 100644
> --- a/arch/x86/kernel/kgdb.c
> +++ b/arch/x86/kernel/kgdb.c
> @@ -606,7 +606,7 @@ static struct notifier_block kgdb_notifier = {
>  	/*
>  	 * Lowest-prio notifier priority, we want to be notified last:
>  	 */
> -	.priority	= -INT_MAX,
> +	.priority	= NMI_LOCAL_LOW_PRIOR,
>  };
>  
>  /**


I had to add the below to make things build here.

---
Index: linux-2.6/arch/x86/kernel/kgdb.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/kgdb.c
+++ linux-2.6/arch/x86/kernel/kgdb.c
@@ -48,6 +48,7 @@
 #include <asm/apicdef.h>
 #include <asm/system.h>
 #include <asm/apic.h>
+#include <asm/nmi.h>
 
 struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] =
 {


