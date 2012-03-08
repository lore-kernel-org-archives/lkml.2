Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab2CHSn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:43:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33458 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363Ab2CHSnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:43:25 -0500
Date: Thu, 8 Mar 2012 10:43:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH] staging: ram_console: Fix section mismatches
Message-ID: <20120308184320.GA29273@kroah.com>
References: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
 <1331197684-9163-1-git-send-email-sboyd@codeaurora.org>
 <20120308175645.GA22682@kroah.com>
 <4F58F677.8030102@codeaurora.org>
 <20120308182349.GB32187@kroah.com>
 <4F58FBA6.60509@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F58FBA6.60509@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 10:34:14AM -0800, Stephen Boyd wrote:
> On 03/08/12 10:23, Greg KH wrote:
> > On Thu, Mar 08, 2012 at 10:12:07AM -0800, Stephen Boyd wrote:
> >> On 03/08/12 09:56, Greg KH wrote:
> >>> On Thu, Mar 08, 2012 at 01:08:04AM -0800, Stephen Boyd wrote:
> >>>> WARNING: vmlinux.o(.text+0x25d5fc): Section mismatch in reference
> >>>> from the function ram_console_driver_probe() to the function
> >>>> .init.text:ram_console_init()
> >>>> The function ram_console_driver_probe() references
> >>>> the function __init ram_console_init().
> >>>> This is often because ram_console_driver_probe lacks a __init
> >>>> annotation or the annotation of ram_console_init is wrong.
> >>>>
> >>>> Mark ram_console_driver_probe() as __devinit because it's a probe
> >>>> function and propagate the __devinit markings to the __init
> >>>> functions the probe calls.
> >>> What .config configuration causes this to happen?  I don't see this here
> >>> in my builds, what am I doing wrong?
> >>>
> >> #
> >> # Android
> >> #
> >> CONFIG_ANDROID=y
> >> # CONFIG_ANDROID_BINDER_IPC is not set
> >> # CONFIG_ASHMEM is not set
> >> # CONFIG_ANDROID_LOGGER is not set
> >> CONFIG_ANDROID_RAM_CONSOLE=y
> >> # CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION is not set
> >> # CONFIG_ANDROID_TIMED_OUTPUT is not set
> >> # CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
> >> # CONFIG_ANDROID_SWITCH is not set
> >> # CONFIG_PHONE is not set
> >>
> >>
> >> Perhaps you're missing this patch if you're on an ARM compiler?
> >>
> >> 6e2e340 (ARM: 7324/1: modpost: Fix section warnings for ARM for many
> >> compilers, 2012-02-14)
> > Nope, I'm building this on x86-64 which warns on this type of thing all
> > the time.
> >
> > My .config looks like this:
> >
> > #
> > # Android
> > #
> > CONFIG_ANDROID=y
> > CONFIG_ANDROID_BINDER_IPC=y
> > CONFIG_ASHMEM=y
> > CONFIG_ANDROID_LOGGER=m
> > CONFIG_ANDROID_PERSISTENT_RAM=y
> > CONFIG_ANDROID_RAM_CONSOLE=y
> > CONFIG_ANDROID_TIMED_OUTPUT=y
> > # CONFIG_ANDROID_TIMED_GPIO is not set
> > CONFIG_ANDROID_LOW_MEMORY_KILLER=y
> > CONFIG_ANDROID_SWITCH=m
> > CONFIG_ANDROID_SWITCH_GPIO=m
> > CONFIG_ANDROID_INTF_ALARM=y
> > CONFIG_ANDROID_INTF_ALARM_DEV=y
> > CONFIG_ANDROID_ALARM_OLDDRV_COMPAT=y
> >
> > And I can't duplicate this at all.  Could the recent fixes that John
> > sent me be the reason?  Or something else?
> >
> 
> This patch is based on your staging-next branch at c5ee121 (staging:
> android: ram_console: drop verbose ram_console support, 2012-03-07). It
> applied that ARM patch on top because I'm compiling with ARM.

The ram_console just got reworked a bunch by the patches I applied a few
hours ago (and you had responded to that thread), so even if I wanted to
take your patch, I can't :)

Care to redo it if it is needed after the rework that just happened?

> It looks like aggressive inlining by the x86 compiler hides this from
> you. I see that if I mark ram_console_init() as noinline
> 
> diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
> index 73215e2..c468fa2 100644
> --- a/drivers/staging/android/ram_console.c
> +++ b/drivers/staging/android/ram_console.c
> @@ -205,7 +205,7 @@ ram_console_save_old(struct ram_console_buffer *buffer, char *dest)
>                &buffer->data[0], buffer->start);
>  }
>  
> -static int __init ram_console_init(struct ram_console_buffer *buffer,
> +static noinline int __init ram_console_init(struct ram_console_buffer *buffer,
>                                    size_t buffer_size, char *old_buf)
>  {
>  #ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
> 
> 
> then I see the section mismatch when compiling on x86. Otherwise I don't
> see anything. Is there a bug in the section mismatch detection with
> respect to compiler inlining?

Possibly, but probably not, if the code is inlined, then there is no
error happening, so there's nothing to detect, right?

thanks,

greg k-h
