Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab2I1DbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 23:31:16 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39992 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab2I1DbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 23:31:14 -0400
MIME-Version: 1.0
In-Reply-To: <1348793563-19186-1-git-send-email-ming.lei@canonical.com>
References: <1348793563-19186-1-git-send-email-ming.lei@canonical.com>
Date: Fri, 28 Sep 2012 09:01:13 +0530
Message-ID: <CAK7N6vqS9PW85hgcA7EVzCk-TQo_ru4OcC5i0Rw-b2hvb4YoXg@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix possible missing of device probe
From: anish singh <anish198519851985@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ming,
Though I am not an expert in this driver core area but
I have been following this fix.So have some queries below:

On Fri, Sep 28, 2012 at 6:22 AM, Ming Lei <ming.lei@canonical.com> wrote:
> Inside bus_add_driver(), one device might be added into
should it not be "driver might be added into"?
> the bus or probed which is triggered by deferred probe
> just after completing of driver_attach() and before
> 'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)',
> so the device won't be probed by this driver.
So the corresponding device will not be probed.
>
> This patch moves the below line
>
>         'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)'
>
> before driver_attach() inside bus_add_driver().
>
> So fixes the problem since the below way can guarantee that
> no probe(dev) may be lost.
>
As I understand CPU0 is just calling bus_add_driver and driver_attach
is called and after that it was pre-empted and cpu1 came into picture.
Deferred probe started running on cpu1 and it didn't find the driver present
int the knode_bus and unloaded the driver(why it unloaded is already
explained by russell in his first post).
Hope my understanding is correct.
> CPU0                                    CPU1
> driver_register
>         ...
>         write(bus->driver_list)
>         smp_mb()
>         read(bus->device_list)
>         ...
>                                         device_add
>                                                 /* bus_add_device */
>                                                 write(bus->device_list)
>                                                 smp_mb()
>                                                 /* bus_probe_device*/
>                                                 read(bus->driver_list)
>
> And the smp_mb() has been implicit by UNLOCK+LOCK
> of 'klist' according to 'VARIETIES OF MEMORY BARRIER' part
> of Documentation/memory-barriers.txt.
>
> Reported-and-Tested-by: Russell King <linux@arm.linux.org.uk>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/base/bus.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 181ed26..3b5bddb 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -714,12 +714,12 @@ int bus_add_driver(struct device_driver *drv)
>         if (error)
>                 goto out_unregister;
>
> +       klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
>         if (drv->bus->p->drivers_autoprobe) {
>                 error = driver_attach(drv);
>                 if (error)
>                         goto out_unregister;
>         }
> -       klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
>         module_add_driver(drv->owner, drv);
>
>         error = driver_create_file(drv, &driver_attr_uevent);
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
