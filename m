Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab0K3NIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 08:08:01 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53023 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab0K3NIA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 08:08:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aXEPOfUgpG117KMMwzfJcBmsYPZvvX0okXyZefHYA7wywxBgxAfqImbTCVoC/rAqwh
         vs9V7wUMJu0/xWhbRg8dOr2KQz2DIk73cfqhEIl1oHdRTAes1Qh8Mjp5tI1SEoWPzTn5
         bm65PiemFwDkJmYAgxeRZZfs4r41IbE1/MhkA=
MIME-Version: 1.0
In-Reply-To: <201011281312.49949.rjw@sisk.pl>
References: <201011281312.49949.rjw@sisk.pl>
Date: Tue, 30 Nov 2010 21:07:58 +0800
Message-ID: <AANLkTi=tgEug5EUpqV1-GLFh9rsD5obAyExe+V=CjsbO@mail.gmail.com>
Subject: Re: [PATCH] PM: Prevent dpm_prepare() from returning errors unnecessarily
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/28 Rafael J. Wysocki <rjw@sisk.pl>:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Currently dpm_prepare() returns error code if it finds that a device
> being suspended has a pending runtime resume request.  However, it
> should not do that if the checking for wakeup events is not enabled.
> On the other hand, if the checking for wakeup events is enabled, it
> can return error when a wakeup event is detected, regardless of its
> source.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/main.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -26,6 +26,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/sched.h>
>  #include <linux/async.h>
> +#include <linux/suspend.h>
>
>  #include "../base.h"
>  #include "power.h"
> @@ -1052,8 +1053,10 @@ static int dpm_prepare(pm_message_t stat
>                mutex_unlock(&dpm_list_mtx);
>
>                pm_runtime_get_noresume(dev);
> -               if (pm_runtime_barrier(dev) && device_may_wakeup(dev)) {
> -                       /* Wake-up requested during system sleep transition. */
> +               if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
> +                       pm_wakeup_event(dev, 0);
> +
> +               if (pm_check_wakeup_events()) {

If pm_check_wakeup_events returns true, it means there is no wakeup event
coming, so seems should handle normal suspend prepare, but why
abort the suspend here?

>                        pm_runtime_put_sync(dev);
>                        error = -EBUSY;
>                } else {



thanks,
-- 
Lei Ming
