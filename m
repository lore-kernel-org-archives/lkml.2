Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1BNLmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:42:38 -0500
Received: from service87.mimecast.com ([94.185.240.25]:56758 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752997Ab1BNLmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:42:36 -0500
Subject: Re: [PATCH] ARM: vfp: Always save VFP state in vfp_pm_suspend
From: Catalin Marinas <catalin.marinas@arm.com>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <1297638813-1315-1-git-send-email-ccross@android.com>
References: <1297638813-1315-1-git-send-email-ccross@android.com>
Organization: ARM Limited
Date: Mon, 14 Feb 2011 11:42:22 +0000
Message-ID: <1297683742.30092.11.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 14 Feb 2011 11:42:28.0658 (UTC) FILETIME=[41F09120:01CBCC3C]
X-MC-Unique: 111021411423105201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-13 at 23:13 +0000, Colin Cross wrote:
> vfp_pm_suspend should save the VFP state any time there is
> a last_VFP_context.  If it only saves when the VFP is enabled,
> the state can get lost when, on a UP system:
>    Thread 1 uses the VFP
>    Context switch occurs to thread 2, VFP is disabled but the
>       VFP context is not saved to allow lazy save and restore
>    Thread 2 initiates suspend
>    vfp_pm_suspend is called with the VFP disabled, but the
>       context has not been saved.

At this point is it guaranteed that the thread won't migrate to another
CPU? If not, we should use get/put_cpu.

> --- a/arch/arm/vfp/vfpmodule.c
> +++ b/arch/arm/vfp/vfpmodule.c
> @@ -415,13 +415,12 @@ static int vfp_pm_suspend(struct sys_device *dev, pm_message_t state)
>         struct thread_info *ti = current_thread_info();
>         u32 fpexc = fmrx(FPEXC);
> 
> -       /* if vfp is on, then save state for resumption */
> -       if (fpexc & FPEXC_EN) {
> +       /* save state for resume */
> +       if (last_VFP_context[ti->cpu]) {
>                 printk(KERN_DEBUG "%s: saving vfp state\n", __func__);
> -               vfp_save_state(&ti->vfpstate, fpexc);
> -
> -               /* disable, just in case */
> -               fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
> +               fmxr(FPEXC, fpexc | FPEXC_EN);
> +               vfp_save_state(last_VFP_context[ti->cpu], fpexc);
> +               fmxr(FPEXC, fpexc & ~FPEXC_EN);
>         }

We may want to set the last_VFP_context to NULL so that after resuming
(to the same thread) we force the VFP reload from the vfpstate
structure. The vfp_support_entry code ignores the reloading if the
last_VFP_context is the same as vfpstate.

-- 
Catalin


