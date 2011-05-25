Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab1EYIeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:34:01 -0400
Received: from service87.mimecast.com ([94.185.240.25]:40228 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932782Ab1EYId7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:33:59 -0400
Subject: Re: [PATCH v6 00/18] ARM: Add support for the Large Physical
 Address Extensions
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Marc Zyngier <Marc.Zyngier@arm.com>
In-Reply-To: <8yapqn7fyab.fsf@huya.qualcomm.com>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
	 <8yapqn7fyab.fsf@huya.qualcomm.com>
Organization: ARM Limited
Date: Wed, 25 May 2011 09:33:50 +0100
Message-ID: <1306312430.31249.7.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 25 May 2011 08:34:05.0886 (UTC) FILETIME=[82456DE0:01CC1AB6]
X-MC-Unique: 111052509335600101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 00:56 +0100, David Brown wrote:
> On Tue, May 24 2011, Catalin Marinas wrote:
> 
> > This set of patches adds support for the Large Physical Extensions on
> > the ARM architecture (available with the Cortex-A15 processor). LPAE
> > comes with a 3-level page table format (compared to 2-level for the
> > classic one), allowing up to 40-bit physical address space.
> 
> Do you expect non LPAE targets to be able to boot with these changes
> applied (and LPAE enabled)?  I am able to build this tree for the
> MSM8660 (with a minor patch below), but it fails to boot with LPAE
> enabled.  It seems to work fine with LPAE not enabled.

As Nicolas replied already, we can't run an LPAE kernel on non-LPAE
hardware. We could add some checks in head.S and branch to __error_p but
it only works if you have CONFIG_DEBUG_LL enabled.

> I did have to fix the msm timer code to get the branch you mentioned to
> compile.  The return type of the function changed back to 'void' without
> changing the returns:

I cc'ed Marc since he's maintaining the timer patches.

> ---
>  arch/arm/mach-msm/timer.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
> index 50cc0bc..6e659e4 100644
> --- a/arch/arm/mach-msm/timer.c
> +++ b/arch/arm/mach-msm/timer.c
> @@ -268,7 +268,7 @@ static void __cpuinit msm_local_timer_setup(struct clock_event_device *evt)
> 
>         /* Use existing clock_event for cpu 0 */
>         if (!smp_processor_id())
> -               return 0;
> +               return;
> 
>         writel(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
> 
> @@ -296,7 +296,8 @@ static void __cpuinit msm_local_timer_setup(struct clock_event_device *evt)
>         if (res) {
>                 pr_err("local_timer_setup: request_irq failed for %s\n",
>                        clock->clockevent.name);
> -               return res;
> +               /* TODO: How to handle this error. */
> +               return;
>         }
> 
>         clockevents_register_device(evt);

Thanks.

-- 
Catalin


