Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab1IUFge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:36:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:29492 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab1IUFgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:36:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,414,1312182000"; 
   d="scan'208";a="51208066"
Message-ID: <4E7977DE.10009@intel.com>
Date: Wed, 21 Sep 2011 13:36:30 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Iceowl/1.0b2 Icedove/3.1.13
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V5][PATCH 2/6] x86, nmi: create new NMI handler routines
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com> <1316529792-6560-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1316529792-6560-3-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 10:43 PM, Don Zickus wrote:
> The NMI handlers used to rely on the notifier infrastructure.  This worked
> great until we wanted to support handling multiple events better.
> 
> One of the key ideas to the nmi handling is to process _all_ the handlers for
> each NMI.  The reason behind this switch is because NMIs are edge triggered.
> If enough NMIs are triggered, then they could be lost because the cpu can
> only latch at most one NMI (besides the one currently being processed).
> 
> In order to deal with this we have decided to process all the NMI handlers
> for each NMI.  This allows the handlers to determine if they recieved an
> event or not (the ones that can not determine this will be left to fend
> for themselves on the unknown NMI list).
> 
> As a result of this change it is now possible to have an extra NMI that
> was destined to be received for an already processed event.  Because the
> event was processed in the previous NMI, this NMI gets dropped and becomes
> an 'unknown' NMI.  This of course will cause printks that scare people.
> 
> However, we prefer to have extra NMIs as opposed to losing NMIs and as such
> are have developed a basic mechanism to catch most of them.  That will be
> a later patch.
> 
> To accomplish this idea, I unhooked the nmi handlers from the notifier
> routines and created a new mechanism loosely based on doIRQ.  The reason
> for this is the notifier routines have a couple of shortcomings.  One we
> could't guarantee all future NMI handlers used NOTIFY_OK instead of
> NOTIFY_STOP.  Second, we couldn't keep track of the number of events being
> handled in each routine (most only handle one, perf can handle more than one).
> Third, I wanted to eventually display which nmi handlers are registered in
> the system in /proc/interrupts to help see who is generating NMIs.
> 
> The patch below just implements the new infrastructure but doesn't wire it up
> yet (that is the next patch).  Its design is based on doIRQ structs and the
> atomic notifier routines.  So the rcu stuff in the patch isn't entirely untested
> (as the notifier routines have soaked it) but it should be double checked in
> case I copied the code wrong.
> 
> V2:
>   - use kstrdup to copy/allocate device name
>   - fix-up _GPL oops
> 
> V3:
>   - fix leak in register_nmi_handler error path
>   - removed _raw annotations from rcu_dereference
> 
> V4:
>   - handle kstrndup failure
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/include/asm/nmi.h |   19 +++++
>  arch/x86/kernel/nmi.c      |  157 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 176 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
> index 4886a68..6d04b28 100644
> --- a/arch/x86/include/asm/nmi.h
> +++ b/arch/x86/include/asm/nmi.h
> @@ -42,6 +42,25 @@ void arch_trigger_all_cpu_backtrace(void);
>  #define NMI_LOCAL_NORMAL_PRIOR	(NMI_LOCAL_BIT | NMI_NORMAL_PRIOR)
>  #define NMI_LOCAL_LOW_PRIOR	(NMI_LOCAL_BIT | NMI_LOW_PRIOR)
>  
> +#define NMI_FLAG_FIRST	1
> +
> +enum {
> +	NMI_LOCAL=0,
> +	NMI_UNKNOWN,
> +	NMI_EXTERNAL,
> +	NMI_MAX
> +};
> +
> +#define NMI_DONE	0
> +#define NMI_HANDLED	1
> +
> +typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
> +
> +int register_nmi_handler(unsigned int, nmi_handler_t, unsigned long,
> +			 const char *);
> +
> +void unregister_nmi_handler(unsigned int, const char *);
> +
>  void stop_nmi(void);
>  void restart_nmi(void);
>  
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index 68d758a..c2df58a 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -13,6 +13,9 @@
>  #include <linux/kprobes.h>
>  #include <linux/kdebug.h>
>  #include <linux/nmi.h>
> +#include <linux/delay.h>
> +#include <linux/hardirq.h>
> +#include <linux/slab.h>
>  
>  #if defined(CONFIG_EDAC)
>  #include <linux/edac.h>
> @@ -21,6 +24,28 @@
>  #include <linux/atomic.h>
>  #include <asm/traps.h>
>  #include <asm/mach_traps.h>
> +#include <asm/nmi.h>
> +
> +#define NMI_MAX_NAMELEN	16
> +struct nmiaction {
> +	struct nmiaction __rcu *next;

Why not just use struct list_head here and use list_xxx_rcu family to
operate on the list?  IMHO, that will make code simpler without much
overhead.

Best Regards,
Huang Ying
