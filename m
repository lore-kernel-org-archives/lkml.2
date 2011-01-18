Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1ARQrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:47:16 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41961 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab1ARQrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:47:13 -0500
Subject: Re: [PATCH 0/0] Panic on softdog timeout
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Anithra P Janakiraman <anithra@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <4D358B34.7040902@linux.vnet.ibm.com>
References: <4D358B34.7040902@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 18 Jan 2011 08:35:27 -0800
Message-ID: <1295368527.31327.193.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 18:14 +0530, Anithra P Janakiraman wrote:
> We currently have no way of determining the reason for failure when a 
> softdog timeout occurs. At the minimum a snapshot of the system would 
> help to determine the cause.
> The attached patch invokes panic on softdog timeout iff kdump is 
> configured, if kdump is not configured it works as usual.

This sounds like a decent idea.  But, is it something that should be a
bit more optional?  We currently have boot options for when to reboot or
panic for other things, and this is really the first use of
kexec_crash_image outside of kexec itself.  Is it really the best switch
to use?

Will this break anyone who expects a quick, clean, reboot and instead
gets a kdump?  Should we make _all_ emergency_restart()s use kdump?

You might have noticed, but your subject is a little wonky.  It should
probably just omit the 1/1 stuff when you only have a single patch
series.  The subject is pretty short and doesn't really explain what's
going on.  Could you beef it up a bit?

> @@ -48,6 +48,7 @@
>  #include <linux/init.h>
>  #include <linux/jiffies.h>
>  #include <linux/uaccess.h>
> +#include <linux/kexec.h>
> 
>  #define PFX "SoftDog: "
> 
> @@ -99,10 +100,15 @@
>         if (soft_noboot)
>                 printk(KERN_CRIT PFX "Triggered - Reboot ignored.\n");
>         else {
> -               printk(KERN_CRIT PFX "Initiating system reboot.\n");
> -               emergency_restart();
> -               printk(KERN_CRIT PFX "Reboot didn't ?????\n");
> -       }
> +               if (kexec_crash_image) {
> +                       printk(KERN_CRIT PFX "Initiating kdump. \n");
> +                       panic("Watchdog timer expired.");
> +               } else {
> +                       printk(KERN_CRIT PFX "Initiating system reboot. \n");
> +                       emergency_restart();
> +                       printk(KERN_CRIT PFX "Reboot didn't ?????\n");
> +               }
> +             }
>  }

The whitespace here is a bit damaged.  You might want to double-check
what your editor did to it.

Also, it's a bit more conventional to append patches to emails rather
than actually attach them.

Please also find some maintainers of this code or people you expect to
accept it, and cc them.  People are likely to miss this on LKML.

>  struct kimage *kexec_image;
>  struct kimage *kexec_crash_image;
> +EXPORT_SYMBOL(kexec_crash_image);

EXPORT_SYMBOL_GPL(), perhaps?

It also isn't _immediately_ obvious why you're doing this.  A quick
little blurb in the patch description would help.

-- Dave

