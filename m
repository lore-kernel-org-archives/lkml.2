Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1CGG4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 01:56:43 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54937 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1CGG4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 01:56:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BETitou3dX6Ld8gUzP9pa5OzVZpjkWAOXnGrUtpzlCY7q3wwlvIeYwuVsJHHaOjAlI
         w3H6ghlYzSkP0vFUy0MRIzF+Jd0mmiQu8zvHHIRQbx/iEMBQD2NwxSwaykqJDBJkKzYV
         flGxoBe5wzFKd5iEEP1MvNqr4yVMOZumoSWwM=
MIME-Version: 1.0
In-Reply-To: <1299263516-18858-1-git-send-email-johan.wessfeldt@gmail.com>
References: <1299263516-18858-1-git-send-email-johan.wessfeldt@gmail.com>
Date: Mon, 7 Mar 2011 07:56:42 +0100
Message-ID: <AANLkTikMY+7ApHCXY_jjue9RRCE-ORKrj4pAyy5H0W8_@mail.gmail.com>
Subject: Re: [PATCH] x86: mce: Potential memory leaks when initializing mcheck devices
From: Johan Wessfeldt <johan.wessfeldt@gmail.com>
To: tglx@linutronix.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Johan Wessfeldt <johan.wessfeldt@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops
missed another call to free_cpumask_var().  Will send a v2 patch

Regards
// Johan W

On Fri, Mar 4, 2011 at 7:31 PM, Johan Wessfeldt
<johan.wessfeldt@gmail.com> wrote:
> This patch makes sure cleanup is done properly when mcheck fails
> initializing any of its resources.
>
> Note!
> It should be safe to call mce_remove_device on ANY of the cpus as
> mce_remove_device checks if corresponding cpu was initialized
> before removing its resources.
>
> Please review.
>
> Signed-off-by: Johan Wessfeldt <johan.wessfeldt@gmail.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   17 ++++++++++++++---
>  1 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index d916183..273f2f6 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -2136,15 +2136,26 @@ static __init int mcheck_init_device(void)
>        for_each_online_cpu(i) {
>                err = mce_create_device(i);
>                if (err)
> -                       return err;
> +                       goto out_unreg;
>        }
>
>        register_hotcpu_notifier(&mce_cpu_notifier);
> -       misc_register(&mce_log_device);
> +       err = misc_register(&mce_log_device);
> +       if (err)
> +               goto out_unreg_hotcpu;
> +
> +       return 0;
> +
> +out_unreg_hotcpu:
> +       unregister_hotcpu_notifier(&mce_cpu_notifier);
> +out_unreg:
> +       for_each_online_cpu(i)
> +               mce_remove_device(i);
>
> +       sysdev_class_unregister(&mce_sysclass);
> +       free_cpumask_var(mce_dev_initialized);
>        return err;
>  }
> -
>  device_initcall(mcheck_init_device);
>
>  /*
> --
> 1.7.2.3
>
>
