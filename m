Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238Ab1CDVih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:38:37 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:56058 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941Ab1CDVig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:38:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GoicQ8zMInFLYEUO3lhY5nBc6kmOy1cCsfn74kM7VNajHK5sjgOFnlWb4fe41uiqQ5
         0TjWYkhadsfhtMZ7c8HKcoZ/fJbZlGCY2kc5RA9KZJIAXa1gDvdAgbajhF/p9bnTjKJk
         DKS1aYwQr2AkDyUI/ixTC0jpM0SNuCrGo3p/k=
MIME-Version: 1.0
In-Reply-To: <1299245367-20279-1-git-send-email-jp.lacerda@codethink.co.uk>
References: <1299245367-20279-1-git-send-email-jp.lacerda@codethink.co.uk>
Date: Fri, 4 Mar 2011 22:38:35 +0100
Message-ID: <AANLkTi=bPk+AjP_JLA2p0+FB_beekBt1fikVx0KA87Fh@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: Fix mcheck_init_device() to handle
 misc_register() correctly
From: Johan Wessfeldt <johan.wessfeldt@gmail.com>
To: "J.P. Lacerda" <jp.lacerda@codethink.co.uk>
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 2:29 PM, J.P. Lacerda <jp.lacerda@codethink.co.uk> wrote:
> The return value for misc_register() was not being taken into account.
> Furthermore, if misc_register() fails, we must rollback any changes made by
> mcheck_init_device()
>
> Signed-off-by: J.P. Lacerda <jp.lacerda@codethink.co.uk>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index d916183..20c2c44 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -2140,7 +2140,18 @@ static __init int mcheck_init_device(void)
>        }
>
>        register_hotcpu_notifier(&mce_cpu_notifier);
> -       misc_register(&mce_log_device);
> +       err = misc_register(&mce_log_device);
> +
> +       if (err) {
> +               unregister_hotcpu_notifier(&mce_cpu_notifier);
> +
> +               for_each_online_cpu(i) {
> +                       mce_remove_device(i);
> +               }
> +
> +               sysdev_class_unregister(&mce_sysclass);
> +               free_cpumask_var(mce_dev_initialized);
> +       }
>
>        return err;
>  }
> --
> 1.7.1
>
>
I want to thank J.P. Lacerda for pointing out an additional leak that I
missed in my first version. ie. calling free_cpumask_var(mce_dev_initialized).

Regards.
// Johan W.
