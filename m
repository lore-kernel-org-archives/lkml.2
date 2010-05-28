Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab0E1VOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 17:14:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932Ab0E1VOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 17:14:35 -0400
Date: Fri, 28 May 2010 14:09:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] powernow-k8: Fix section mismatch
Message-Id: <20100528140908.057f2348.akpm@linux-foundation.org>
In-Reply-To: <20100525152858.GA24836@aftab>
References: <20100525152858.GA24836@aftab>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 17:28:58 +0200
Borislav Petkov <borislav.petkov@amd.com> wrote:

> Fix the following warning:
> 
> "WARNING: arch/x86/kernel/built-in.o(.exit.text+0x72):
> Section mismatch in reference from the function powernowk8_exit() to the variable .cpuinit.data:cpb_nb
> 
> The function __exit powernowk8_exit() references a variable
> __cpuinitdata cpb_nb. This is often seen when error handling in the exit
> function uses functionality in the init path. The fix is often to remove
> the __cpuinitdata annotation of cpb_nb so it may be used outside an init
> section."
> 
> Cc: <stable@kernel.org>
> Reported-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> index 6f3dc8f..7ec2123 100644
> --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> @@ -1497,8 +1497,8 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
>   * simply keep the boost-disable flag in sync with the current global
>   * state.
>   */
> -static int __cpuinit cpb_notify(struct notifier_block *nb, unsigned long action,
> -				void *hcpu)
> +static int cpb_notify(struct notifier_block *nb, unsigned long action,
> +		      void *hcpu)
>  {
>  	unsigned cpu = (long)hcpu;
>  	u32 lo, hi;
> @@ -1528,7 +1528,7 @@ static int __cpuinit cpb_notify(struct notifier_block *nb, unsigned long action,
>  	return NOTIFY_OK;
>  }
>  
> -static struct notifier_block __cpuinitdata cpb_nb = {
> +static struct notifier_block cpb_nb = {
>  	.notifier_call		= cpb_notify,
>  };

I _think_ this is notabug.  If CONFIG_HOTPLUG_CPU=y, this code/data
doesn't get discarded.  If CONFIG_HOTPLUG_CPU=n,
[un]register_cpu_notifier() is a no-op.

But apparently the build system _did_ detect such a reference, so
what's going on?  Maybe I'm confused again.


This code needs work.  It should use hotcpu_notifier() rather than
diving down into the lower-level register_cpu_notifier().  If this is
done then linker magic will cause all the hotplug-specific code to be
omitted from vmlinux if CONFIG_HOTPLUG_CPU=n, and I suppose it will fix
the above warning.


