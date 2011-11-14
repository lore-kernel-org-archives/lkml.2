Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1KNJyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 04:54:54 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36547 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1KNJyx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 04:54:53 -0500
MIME-Version: 1.0
In-Reply-To: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
Date: Mon, 14 Nov 2011 17:54:52 +0800
Message-ID: <CACVXFVPpXQUDh7wzv0+eKf97wSZRvJ4UaW7uJ+JfQG0_KM972g@mail.gmail.com>
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during shutdown
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        rjw@sisk.pl, stern@rowland.harvard.edu, hzpeterchen@gmail.com,
        stable <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 14, 2011 at 8:43 AM, Peter Chen <peter.chen@freescale.com> wrote:
> There may be an issue when the user issue "reboot/shutdown" command, then
> the device has shut down its hardware, after that, this runtime-pm featured
> device's driver will probably be scheduled to do its suspend routine,
> and at its suspend routine, it may access hardware, but the device has
> already shutdown physically, then the system hang may be occurred.
>
> I ran out this issue using an auto-suspend supported USB devices, like
> 3G modem, keyboard. The usb runtime suspend routine may be scheduled
> after the usb controller has been shut down, and the usb runtime suspend
> routine will try to suspend its roothub(controller), it will access
> register, then the system hang occurs as the controller is shutdown.
> Signed-off-by: Peter Chen <peter.chen@freescale.com>

This patch should make many guys happy about shutdown/reboot function,
at least fix the reboot issue on my panda board, maybe CC stable@kernel.org
is needed, :-)

> ---
>  drivers/base/core.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index bc8729d..78445f4 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -22,6 +22,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/mutex.h>
>  #include <linux/async.h>
> +#include <linux/pm_runtime.h>
>
>  #include "base.h"
>  #include "power/power.h"
> @@ -1742,6 +1743,8 @@ void device_shutdown(void)
>                 */
>                list_del_init(&dev->kobj.entry);
>                spin_unlock(&devices_kset->list_lock);
> +               /* Disable all device's runtime power management */
> +               pm_runtime_disable(dev);
>
>                if (dev->bus && dev->bus->shutdown) {
>                        dev_dbg(dev, "shutdown\n");
> --
> 1.7.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

thanks,
-- 
Ming Lei
