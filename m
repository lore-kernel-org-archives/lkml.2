Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab0H2Sqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:46:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43387 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab0H2Sqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:46:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KHnuFe4MR2HKl+4AN8fZiOeBp2o/Vm6gsZfAUkwsqLW7BOyVxAqPyPMwJiTJeaddm4
         MWIc5UjTjIZdB3gVkaeaNu2gI7hsVRN7vv1bMYuQDQDzCcEDBdD0wD6kNblSWtC2EPhC
         sxFWQgOW4TdDjIm7ZoK57FxdsgpGrO4xoOgxg=
MIME-Version: 1.0
In-Reply-To: <1283011478-27237-7-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-7-git-send-email-brgerst@gmail.com>
Date: Sun, 29 Aug 2010 21:41:06 +0300
X-Google-Sender-Auth: PActKVPj9uCdvuGinEU0D-Ngg-Y
Message-ID: <AANLkTi=G+=Hc3e8Z+HH6yJPGi4TM3TyYZ6UvdUpHyBsC@mail.gmail.com>
Subject: Re: [PATCH 06/11] x86-64: Fix %cs value in convert_from_fxsr()
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
> While %ds still contains the userspace selector, %cs is KERNEL_CS
> at this point.  Always get %cs from pt_regs.
>
> It actually is possible to get the correct segments for compat tasks,
> but that involves using the [f]xsave instruction without a REX.W prefix.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

It might be just me but the above description doesn't explain
anything. What's the problem here? What is this fixing?

> ---
>  arch/x86/kernel/i387.c |   18 ++++++++----------
>  1 files changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index c795675..b1a732d 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -383,19 +383,17 @@ convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
>  #ifdef CONFIG_X86_64
>        env->fip = fxsave->rip;
>        env->foo = fxsave->rdp;
> +       /*
> +        * should be actually ds/cs at fpu exception time, but
> +        * that information is not available in 64bit mode.
> +        */
> +       env->fcs = task_pt_regs(tsk)->cs;
>        if (tsk == current) {
> -               /*
> -                * should be actually ds/cs at fpu exception time, but
> -                * that information is not available in 64bit mode.
> -                */
> -               asm("mov %%ds, %[fos]" : [fos] "=r" (env->fos));
> -               asm("mov %%cs, %[fcs]" : [fcs] "=r" (env->fcs));
> +               savesegment(ds, env->fos);
>        } else {
> -               struct pt_regs *regs = task_pt_regs(tsk);
> -
> -               env->fos = 0xffff0000 | tsk->thread.ds;
> -               env->fcs = regs->cs;
> +               env->fos = tsk->thread.ds;
>        }
> +       env->fos |= 0xffff0000;
>  #else
>        env->fip = fxsave->fip;
>        env->fcs = (u16) fxsave->fcs | ((u32) fxsave->fop << 16);
> --
> 1.7.2.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
