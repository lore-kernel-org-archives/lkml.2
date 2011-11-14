Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab1KNWZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 17:25:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39276 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab1KNWZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 17:25:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Chen <peter.chen@freescale.com>, gregkh@suse.de
Subject: Re: [PATCH 1/1] driver core: disable device's runtime pm during shutdown
Date: Mon, 14 Nov 2011 23:27:37 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        stern@rowland.harvard.edu, hzpeterchen@gmail.com
References: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
In-Reply-To: <1321231380-11631-1-git-send-email-peter.chen@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201111142327.37524.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 14, 2011, Peter Chen wrote:
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

Greg, do you want me to take this one?

Rafael


> ---
>  drivers/base/core.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index bc8729d..78445f4 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -22,6 +22,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/mutex.h>
>  #include <linux/async.h>
> +#include <linux/pm_runtime.h>
>  
>  #include "base.h"
>  #include "power/power.h"
> @@ -1742,6 +1743,8 @@ void device_shutdown(void)
>  		 */
>  		list_del_init(&dev->kobj.entry);
>  		spin_unlock(&devices_kset->list_lock);
> +		/* Disable all device's runtime power management */
> +		pm_runtime_disable(dev);
>  
>  		if (dev->bus && dev->bus->shutdown) {
>  			dev_dbg(dev, "shutdown\n");
> 

