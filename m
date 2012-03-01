Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab2CAQbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 11:31:01 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:55746 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756163Ab2CAQbA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 11:31:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of x0155534@ti.com designates 10.180.24.66 as permitted sender) smtp.mail=x0155534@ti.com
MIME-Version: 1.0
In-Reply-To: <CABoJqzyRwBPf4LAhjK7+GpoN_5q06QhJ1XZzmRi=TJ3MGCZeLQ@mail.gmail.com>
References: <CANk4QSnOwTK6rDNVX381A-e+osyvGWJW99zQmpTvHndDUOYF7w@mail.gmail.com>
 <CABoJqzyRwBPf4LAhjK7+GpoN_5q06QhJ1XZzmRi=TJ3MGCZeLQ@mail.gmail.com>
From: "Shlyakhovoy, Kostyantyn" <x0155534@ti.com>
Date: Thu, 1 Mar 2012 18:30:36 +0200
Message-ID: <CABoJqzySAVcraWOB_ebj2bOcm0M3MfiACzspcXpQyOEUmU8KhQ@mail.gmail.com>
Subject: Fwd: [PATCH] PM / Driver core: leave runtime PM enabled during system shutdown
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From fe6b91f47080eb17d21cbf2a39311877d57f6938 Mon Sep 17 00:00:00 2001
> From: Alan Stern <stern@rowland.harvard.edu>
> Date: Tue, 6 Dec 2011 23:24:52 +0100
> Subject: [PATCH] PM / Driver core: leave runtime PM enabled during system
>  shutdown
>
> Disabling all runtime PM during system shutdown turns out not to be a
> good idea, because some devices may need to be woken up from a
> low-power state at that time.
>
> The whole point of disabling runtime PM for system shutdown was to
> prevent untimely runtime-suspend method calls.  This patch (as1504)
> accomplishes the same result by incrementing the usage count for each
> device and waiting for ongoing runtime-PM callbacks to finish.  This
> is what we already do during system suspend and hibernation, which
> makes sense since the shutdown method is pretty much a legacy analog
> of the pm->poweroff method.
>
> This fixes a recent regression on some OMAP systems introduced by
> commit af8db1508f2c9f3b6e633e2d2d906c6557c617f9 (PM / driver core:
> disable device's runtime PM during shutdown).
>
> Reported-and-tested-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/core.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index d8b3d89..919daa7 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1743,8 +1743,10 @@ void device_shutdown(void)
>                 */
>                list_del_init(&dev->kobj.entry);
>                spin_unlock(&devices_kset->list_lock);
> -               /* Disable all device's runtime power management */
> -               pm_runtime_disable(dev);
> +
> +               /* Don't allow any more runtime suspends */
> +               pm_runtime_get_noresume(dev);
> +               pm_runtime_barrier(dev);
>
>                if (dev->bus && dev->bus->shutdown) {
>                        dev_dbg(dev, "shutdown\n");
> --
> 1.7.6.5

Hi Greg,

This patch exists in linux-3.2.y branch and fixes a regression
introduced by commit af8db1508f2c9f3b6e633e2d2d906c6557c617f9 - PM /
driver core: disable device's runtime PM during shutdown. However the
regression was introduced in linux-3.0.y and linux-3.1.y also.
Could you, please, merge this fix to linux-3.0.y and linux-3.1.y as well?

Regards,
Konstantin
