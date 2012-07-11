Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab2GKVyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 17:54:11 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:28130 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab2GKVyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 17:54:10 -0400
Message-ID: <1342043432.16730.899.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/2] x86: don't panic if master CPU haven't set
 cpu_callout_mask
From: Toshi Kani <toshi.kani@hp.com>
To: imammedo@redhat.com
Cc: linux-kernel@vger.kernel.org, prarit@redhat.com, oleg@redhat.com,
        rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, a.p.zijlstra@chello.nl, johnstul@us.ibm.com,
        toshi.kani@hp.com
Date: Wed, 11 Jul 2012 15:50:32 -0600
In-Reply-To: <1340108061-5128-3-git-send-email-imammedo@redhat.com>
References: <1340108061-5128-1-git-send-email-imammedo@redhat.com>
	 <1340108061-5128-3-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 14:22 -0600, Toshi Kani wrote:
> Gracefully cancel CPU initialization instead of panic when master
> CPU haven't managed to set cpu_callout_mask in time.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  arch/x86/kernel/smpboot.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 95948b9..6470470 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -175,8 +175,9 @@ static void __cpuinit smp_callin(void)
>  	}
>  
>  	if (!time_before(jiffies, timeout)) {
> -		panic("%s: CPU%d started up but did not get a callout!\n",
> +		pr_debug("%s: CPU%d started up but did not get a callout!\n",
>  		      __func__, cpuid);

Shouldn't we use pr_err() here?

> +		goto die;

Is it safe to call remove_siblinginfo() in this code path?  It has not
called set_cpu_sibling_map() yet.

Thanks,
-Toshi



>  	}
>  
>  	/*


