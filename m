Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1BDM7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:59:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab1BDM73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:59:29 -0500
Date: Fri, 4 Feb 2011 13:59:16 +0100
From: Anton Arapov <anton@redhat.com>
To: Ian Campbell <ian.campbell@citrix.com>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] microcode: do not WARN_ON(cpu != 0) during resume
Message-ID: <20110204125916.GD11633@bandura.usersys.redhat.com>
References: <1261058024-32278-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261058024-32278-1-git-send-email-ian.campbell@citrix.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

  may we have this patch in -mm? It has an ack from Jeremy as well.

thanks,
Anton.

On Thu, Dec 17, 2009 at 01:53:44PM +0000, Ian Campbell wrote:
> 871b72dd "x86: microcode: use smp_call_function_single instead of
> set_cpus_allowed, cleanup of synchronization logic" included:
> 
>  static int mc_sysdev_resume(struct sys_device *dev)
>  {
> [...]
> +       /*
> +        * All non-bootup cpus are still disabled,
> +        * so only CPU 0 will apply ucode here.
> +        *
> +        * Moreover, there can be no concurrent
> +        * updates from any other places at this point.
> +        */
> +       WARN_ON(cpu != 0);
> 
> However suspend/resume under Xen doesn't need to hot unplug all the CPUs, so we
> don't; the hypervisor can manage the context save/restore for all CPUs.
> 
> It would be unnecessary to load microcode.ko in a Xen domU but if it does occur
> (e.g. because a distro installs the tools by default) we would like to avoid
> the warning on resume.
> 
> Since the real constraint here is that we are running on the CPU for which we
> would like to load microcode (which in all practical circumstances is CPU0)
> just check for that and return if we are resuming a different CPU.
> 
> There is no danger of concurrent updates, even if we ignore the fact that all
> but one CPUs are unplugged on native, because sysdev_resume() is single
> threaded.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Cc: Hugh Dickins <hugh@veritas.com>
> Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: Anton Arapov <aarapov@redhat.com>

> ---
>  arch/x86/kernel/microcode_core.c |   11 +----------
>  1 files changed, 1 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> index 378e9a8..1153062 100644
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -438,18 +438,9 @@ static int mc_sysdev_resume(struct sys_device *dev)
>  	int cpu = dev->id;
>  	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
>  
> -	if (!cpu_online(cpu))
> +	if (cpu != smp_processor_id())
>  		return 0;
>  
> -	/*
> -	 * All non-bootup cpus are still disabled,
> -	 * so only CPU 0 will apply ucode here.
> -	 *
> -	 * Moreover, there can be no concurrent
> -	 * updates from any other places at this point.
> -	 */
> -	WARN_ON(cpu != 0);
> -
>  	if (uci->valid && uci->mc)
>  		microcode_ops->apply_microcode(cpu);
>  
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Anton
