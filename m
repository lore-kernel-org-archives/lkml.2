Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab2EUVHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:07:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:54329 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871Ab2EUVHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:07:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155344767"
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 21 May 2012 14:05:53 -0700
In-Reply-To: <20120521164959.GE16454@sgi.com>
References: <20120521164959.GE16454@sgi.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337634353.1997.144.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 11:49 -0500, Dimitri Sivanich wrote:
> The smp_irq_move_cleanup_interrupt routine should be checking for a valid
> irq_cfg pointer prior to accessing it.  It also seems that this should be
> done after taking the desc lock.

I think these changes are correct. Did you see any crashes during module
unload etc?

Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>

> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux/arch/x86/kernel/apic/io_apic.c
> @@ -2478,9 +2478,12 @@ asmlinkage void smp_irq_move_cleanup_int
>  		if (!desc)
>  			continue;
>  
> -		cfg = irq_cfg(irq);
>  		raw_spin_lock(&desc->lock);
>  
> +		cfg = irq_cfg(irq);
> +		if (!cfg)
> +			goto unlock;
> +
>  		/*
>  		 * Check if the irq migration is in progress. If so, we
>  		 * haven't received the cleanup request yet for this irq.


