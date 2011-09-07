Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab1IGUDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 16:03:08 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:34779 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756774Ab1IGUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 16:03:06 -0400
From: Kevin Hilman <khilman@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <ccross@android.com>, <rjw@sisk.pl>
Subject: Re: [PATCH v2 2/5] cpu_pm: call notifiers during suspend
Organization: Texas Instruments, Inc.
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
	<1315060755-4613-3-git-send-email-santosh.shilimkar@ti.com>
Date: Wed, 07 Sep 2011 13:02:59 -0700
In-Reply-To: <1315060755-4613-3-git-send-email-santosh.shilimkar@ti.com>
	(Santosh Shilimkar's message of "Sat, 3 Sep 2011 20:09:12 +0530")
Message-ID: <87k49knmrw.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Santosh Shilimkar <santosh.shilimkar@ti.com> writes:

> From: Colin Cross <ccross@android.com>
>
> Implements syscore_ops in cpu_pm to call the cpu and
> cpu cluster notifiers during suspend and resume,
> allowing drivers receiving the notifications to
> avoid implementing syscore_ops.
>
> Signed-off-by: Colin Cross <ccross@android.com>
> [santosh.shilimkar@ti.com: Rebased against 3.1-rc4]
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

I don't think using syscore_ops is right here.  The platform code should
decide where in its own suspend path the notifiers should be triggered.

The reason is because while the syscore_ops run late in the suspend
path, they still run before some platform-specific decisions about the
low-power states are made.  That means that any notifiers that need to
use information about the target low-power state (e.g. whether context
will be lost or not) cannot do so since that information has not yet
been decided until the platform_suspend_ops->enter() runs.

Basically, I think the cpu_*_pm_enter() calls should be called by
platform-specific code, not by common code.

Kevin

> ---
>  kernel/cpu_pm.c |   33 +++++++++++++++++++++++++++++++++
>  1 files changed, 33 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/cpu_pm.c b/kernel/cpu_pm.c
> index 54aa892..3d115d0 100644
> --- a/kernel/cpu_pm.c
> +++ b/kernel/cpu_pm.c
> @@ -20,6 +20,7 @@
>  #include <linux/module.h>
>  #include <linux/notifier.h>
>  #include <linux/spinlock.h>
> +#include <linux/syscore_ops.h>
>  
>  static DEFINE_RWLOCK(cpu_pm_notifier_lock);
>  static RAW_NOTIFIER_HEAD(cpu_pm_notifier_chain);
> @@ -113,3 +114,35 @@ int cpu_cluster_pm_exit(void)
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(cpu_cluster_pm_exit);
> +
> +#ifdef CONFIG_PM
> +static int cpu_pm_suspend(void)
> +{
> +	int ret;
> +
> +	ret = cpu_pm_enter();
> +	if (ret)
> +		return ret;
> +
> +	ret = cpu_cluster_pm_enter();
> +	return ret;
> +}
> +
> +static void cpu_pm_resume(void)
> +{
> +	cpu_cluster_pm_exit();
> +	cpu_pm_exit();
> +}
> +
> +static struct syscore_ops cpu_pm_syscore_ops = {
> +	.suspend = cpu_pm_suspend,
> +	.resume = cpu_pm_resume,
> +};
> +
> +static int cpu_pm_init(void)
> +{
> +	register_syscore_ops(&cpu_pm_syscore_ops);
> +	return 0;
> +}
> +core_initcall(cpu_pm_init);
> +#endif
