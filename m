Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035Ab1CDRQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:16:33 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42792 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759888Ab1CDRQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:16:30 -0500
Date: Fri, 4 Mar 2011 18:16:19 +0100
From: Borislav Petkov <bp@amd64.org>
To: "J.P. Lacerda" <jp.lacerda@codethink.co.uk>
Cc: akpm@linux-foundation.org, johan.wessfeldt@gmail.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Fix mcheck_init_device() to handle
 misc_register() correctly
Message-ID: <20110304171619.GB9311@gere.osrc.amd.com>
References: <1299245367-20279-1-git-send-email-jp.lacerda@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299245367-20279-1-git-send-email-jp.lacerda@codethink.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 01:29:27PM +0000, J.P. Lacerda wrote:
> The return value for misc_register() was not being taken into account.
> Furthermore, if misc_register() fails, we must rollback any changes made by
> mcheck_init_device()

If you're going to fix all error paths here, you still need to handle
unrolling the setup done by mce_create_device() if we fail somewhere in
between.

> Signed-off-by: J.P. Lacerda <jp.lacerda@codethink.co.uk>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index d916183..20c2c44 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -2140,7 +2140,18 @@ static __init int mcheck_init_device(void)
>  	}
>  
>  	register_hotcpu_notifier(&mce_cpu_notifier);
> -	misc_register(&mce_log_device);
> +	err = misc_register(&mce_log_device);
> +

no newline here.

> +	if (err) {
> +		unregister_hotcpu_notifier(&mce_cpu_notifier);
> +
> +		for_each_online_cpu(i) {
> +			mce_remove_device(i);
> +		}

no need for braces around a single loop body statement.

> +
> +		sysdev_class_unregister(&mce_sysclass);
> +		free_cpumask_var(mce_dev_initialized);
> +	}
>  
>  	return err;

Anyway, while this is makes sense from correctness POV, if we hit an
error path here this early then something else is going terribly wrong
which would've screamed very loudly already. Are you hitting this on a
real workload or you caught this by code staring?

Because if it is the second case, the merit of fixing those error
paths vs adding code which is almost never executed is significantly
diminished.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
