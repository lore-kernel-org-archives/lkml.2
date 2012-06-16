Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab2FPNzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 09:55:11 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:45515 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660Ab2FPNzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 09:55:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] ftrace: Disable function tracing during suspend/resume and hibernation, again
Date: Sat, 16 Jun 2012 16:00:28 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: rostedt@goodmis.org, mingo@kernel.org, lenb@kernel.org, pavel@ucw.cz,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120521065651.4142.36898.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120521065651.4142.36898.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206161600.28810.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2012, Srivatsa S. Bhat wrote:
> If function tracing is enabled for some of the low-level suspend/resume
> functions, it leads to triple fault during resume from suspend, ultimately
> ending up in a reboot instead of a resume (or a total refusal to come out
> of suspended state, on some machines).
> 
> This issue was explained in more detail in commit f42ac38c59e0a03d (ftrace:
> disable tracing for suspend to ram). However, the changes made by that commit
> got reverted by commit cbe2f5a6e84eebb (tracing: allow tracing of
> suspend/resume & hibernation code again). So, unfortunately since things are
> not yet robust enough to allow tracing of low-level suspend/resume functions,
> suspend/resume is still broken when ftrace is enabled.
> 
> So fix this by disabling function tracing during suspend/resume & hibernation.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: stable@vger.kernel.org

Queued up for 3.6 in linux-pm/linux-next.

Thanks,
Rafael


> ---
> 
>  kernel/power/hibernate.c |    6 ++++++
>  kernel/power/suspend.c   |    3 +++
>  2 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index e09dfbf..52a1817 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -352,6 +352,7 @@ int hibernation_snapshot(int platform_mode)
>  	}
>  
>  	suspend_console();
> +	ftrace_stop();
>  	pm_restrict_gfp_mask();
>  
>  	error = dpm_suspend(PMSG_FREEZE);
> @@ -377,6 +378,7 @@ int hibernation_snapshot(int platform_mode)
>  	if (error || !in_suspend)
>  		pm_restore_gfp_mask();
>  
> +	ftrace_start();
>  	resume_console();
>  	dpm_complete(msg);
>  
> @@ -479,6 +481,7 @@ int hibernation_restore(int platform_mode)
>  
>  	pm_prepare_console();
>  	suspend_console();
> +	ftrace_stop();
>  	pm_restrict_gfp_mask();
>  	error = dpm_suspend_start(PMSG_QUIESCE);
>  	if (!error) {
> @@ -486,6 +489,7 @@ int hibernation_restore(int platform_mode)
>  		dpm_resume_end(PMSG_RECOVER);
>  	}
>  	pm_restore_gfp_mask();
> +	ftrace_start();
>  	resume_console();
>  	pm_restore_console();
>  	return error;
> @@ -512,6 +516,7 @@ int hibernation_platform_enter(void)
>  
>  	entering_platform_hibernation = true;
>  	suspend_console();
> +	ftrace_stop();
>  	error = dpm_suspend_start(PMSG_HIBERNATE);
>  	if (error) {
>  		if (hibernation_ops->recover)
> @@ -555,6 +560,7 @@ int hibernation_platform_enter(void)
>   Resume_devices:
>  	entering_platform_hibernation = false;
>  	dpm_resume_end(PMSG_RESTORE);
> +	ftrace_start();
>  	resume_console();
>  
>   Close:
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 396d262..c8b7446 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -24,6 +24,7 @@
>  #include <linux/export.h>
>  #include <linux/suspend.h>
>  #include <linux/syscore_ops.h>
> +#include <linux/ftrace.h>
>  #include <trace/events/power.h>
>  
>  #include "power.h"
> @@ -212,6 +213,7 @@ int suspend_devices_and_enter(suspend_state_t state)
>  			goto Close;
>  	}
>  	suspend_console();
> +	ftrace_stop();
>  	suspend_test_start();
>  	error = dpm_suspend_start(PMSG_SUSPEND);
>  	if (error) {
> @@ -231,6 +233,7 @@ int suspend_devices_and_enter(suspend_state_t state)
>  	suspend_test_start();
>  	dpm_resume_end(PMSG_RESUME);
>  	suspend_test_finish("resume devices");
> +	ftrace_start();
>  	resume_console();
>   Close:
>  	if (suspend_ops->end)
> 
> 
> 

