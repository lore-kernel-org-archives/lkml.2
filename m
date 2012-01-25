Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab2AYC4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 21:56:46 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57933 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093Ab2AYC4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 21:56:43 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1201241258510.1200-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1201241258510.1200-100000@iolanthe.rowland.org>
Date: Wed, 25 Jan 2012 11:56:41 +0900
X-Google-Sender-Auth: X8sTXn-3fe2z3dV_L1c_y6AjxJQ
Message-ID: <CAH9JG2WEQ4hzvd=Lunfi=Y7LYF19Gs0CNT3WACCxNT1EvzhoyA@mail.gmail.com>
Subject: Re: [PATCH 1/5] Driver core: driver_find() drops reference before returning
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andy Walls <awalls@md.metrocast.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For s5p-{fimc,tv}

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On 1/25/12, Alan Stern <stern@rowland.harvard.edu> wrote:
> As part of the removal of get_driver()/put_driver(), this patch
> (as1510) changes driver_find(); it now drops the reference it acquires
> before returning.  The patch also adjusts all the callers of
> driver_find() to remove the now unnecessary calls to put_driver().
>
> In addition, the patch adds a warning to driver_find(): Callers must
> make sure the driver they are searching for does not get unloaded
> while they are using it.  This has always been the case; driver_find()
> has never prevented a driver from being unregistered or unloaded.
> Hence the patch will not introduce any new bugs.  The existing callers
> all seem to be okay in this respect, however I don't understand the
> video drivers well enough to be certain about them.
>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> CC: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Andy Walls <awalls@md.metrocast.net>
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
>
> ---
>
>  drivers/base/driver.c                       |    7 +++++--
>  drivers/input/gameport/gameport.c           |    1 -
>  drivers/input/serio/serio.c                 |    1 -
>  drivers/media/video/cx18/cx18-alsa-main.c   |    1 -
>  drivers/media/video/ivtv/ivtvfb.c           |    2 --
>  drivers/media/video/s5p-fimc/fimc-mdevice.c |    5 +----
>  drivers/media/video/s5p-tv/mixer_video.c    |    1 -
>  drivers/s390/net/smsgiucv_app.c             |    9 ++++-----
>  8 files changed, 10 insertions(+), 17 deletions(-)
>
> Index: usb-3.3/drivers/base/driver.c
> ===================================================================
> --- usb-3.3.orig/drivers/base/driver.c
> +++ usb-3.3/drivers/base/driver.c
> @@ -234,7 +234,6 @@ int driver_register(struct device_driver
>
>  	other = driver_find(drv->name, drv->bus);
>  	if (other) {
> -		put_driver(other);
>  		printk(KERN_ERR "Error: Driver '%s' is already registered, "
>  			"aborting...\n", drv->name);
>  		return -EBUSY;
> @@ -275,7 +274,9 @@ EXPORT_SYMBOL_GPL(driver_unregister);
>   * Call kset_find_obj() to iterate over list of drivers on
>   * a bus to find driver by name. Return driver if found.
>   *
> - * Note that kset_find_obj increments driver's reference count.
> + * This routine provides no locking to prevent the driver it returns
> + * from being unregistered or unloaded while the caller is using it.
> + * The caller is responsible for preventing this.
>   */
>  struct device_driver *driver_find(const char *name, struct bus_type *bus)
>  {
> @@ -283,6 +284,8 @@ struct device_driver *driver_find(const
>  	struct driver_private *priv;
>
>  	if (k) {
> +		/* Drop reference added by kset_find_obj() */
> +		kobject_put(k);
>  		priv = to_driver(k);
>  		return priv->driver;
>  	}
> Index: usb-3.3/drivers/input/gameport/gameport.c
> ===================================================================
> --- usb-3.3.orig/drivers/input/gameport/gameport.c
> +++ usb-3.3/drivers/input/gameport/gameport.c
> @@ -449,7 +449,6 @@ static ssize_t gameport_rebind_driver(st
>  	} else if ((drv = driver_find(buf, &gameport_bus)) != NULL) {
>  		gameport_disconnect_port(gameport);
>  		error = gameport_bind_driver(gameport, to_gameport_driver(drv));
> -		put_driver(drv);
>  	} else {
>  		error = -EINVAL;
>  	}
> Index: usb-3.3/drivers/input/serio/serio.c
> ===================================================================
> --- usb-3.3.orig/drivers/input/serio/serio.c
> +++ usb-3.3/drivers/input/serio/serio.c
> @@ -441,7 +441,6 @@ static ssize_t serio_rebind_driver(struc
>  	} else if ((drv = driver_find(buf, &serio_bus)) != NULL) {
>  		serio_disconnect_port(serio);
>  		error = serio_bind_driver(serio, to_serio_driver(drv));
> -		put_driver(drv);
>  		serio_remove_duplicate_events(serio, SERIO_RESCAN_PORT);
>  	} else {
>  		error = -EINVAL;
> Index: usb-3.3/drivers/media/video/cx18/cx18-alsa-main.c
> ===================================================================
> --- usb-3.3.orig/drivers/media/video/cx18/cx18-alsa-main.c
> +++ usb-3.3/drivers/media/video/cx18/cx18-alsa-main.c
> @@ -285,7 +285,6 @@ static void __exit cx18_alsa_exit(void)
>
>  	drv = driver_find("cx18", &pci_bus_type);
>  	ret = driver_for_each_device(drv, NULL, NULL, cx18_alsa_exit_callback);
> -	put_driver(drv);
>
>  	cx18_ext_init = NULL;
>  	printk(KERN_INFO "cx18-alsa: module unload complete\n");
> Index: usb-3.3/drivers/media/video/ivtv/ivtvfb.c
> ===================================================================
> --- usb-3.3.orig/drivers/media/video/ivtv/ivtvfb.c
> +++ usb-3.3/drivers/media/video/ivtv/ivtvfb.c
> @@ -1293,7 +1293,6 @@ static int __init ivtvfb_init(void)
>
>  	drv = driver_find("ivtv", &pci_bus_type);
>  	err = driver_for_each_device(drv, NULL, &registered,
> ivtvfb_callback_init);
> -	put_driver(drv);
>  	if (!registered) {
>  		printk(KERN_ERR "ivtvfb:  no cards found\n");
>  		return -ENODEV;
> @@ -1310,7 +1309,6 @@ static void ivtvfb_cleanup(void)
>
>  	drv = driver_find("ivtv", &pci_bus_type);
>  	err = driver_for_each_device(drv, NULL, NULL, ivtvfb_callback_cleanup);
> -	put_driver(drv);
>  }
>
>  module_init(ivtvfb_init);
> Index: usb-3.3/drivers/media/video/s5p-fimc/fimc-mdevice.c
> ===================================================================
> --- usb-3.3.orig/drivers/media/video/s5p-fimc/fimc-mdevice.c
> +++ usb-3.3/drivers/media/video/s5p-fimc/fimc-mdevice.c
> @@ -344,16 +344,13 @@ static int fimc_md_register_platform_ent
>  		return -ENODEV;
>  	ret = driver_for_each_device(driver, NULL, fmd,
>  				     fimc_register_callback);
> -	put_driver(driver);
>  	if (ret)
>  		return ret;
>
>  	driver = driver_find(CSIS_DRIVER_NAME, &platform_bus_type);
> -	if (driver) {
> +	if (driver)
>  		ret = driver_for_each_device(driver, NULL, fmd,
>  					     csis_register_callback);
> -		put_driver(driver);
> -	}
>  	return ret;
>  }
>
> Index: usb-3.3/drivers/media/video/s5p-tv/mixer_video.c
> ===================================================================
> --- usb-3.3.orig/drivers/media/video/s5p-tv/mixer_video.c
> +++ usb-3.3/drivers/media/video/s5p-tv/mixer_video.c
> @@ -58,7 +58,6 @@ static struct v4l2_subdev *find_and_regi
>  	}
>
>  done:
> -	put_driver(drv);
>  	return sd;
>  }
>
> Index: usb-3.3/drivers/s390/net/smsgiucv_app.c
> ===================================================================
> --- usb-3.3.orig/drivers/s390/net/smsgiucv_app.c
> +++ usb-3.3/drivers/s390/net/smsgiucv_app.c
> @@ -168,7 +168,7 @@ static int __init smsgiucv_app_init(void
>  	rc = dev_set_name(smsg_app_dev, KMSG_COMPONENT);
>  	if (rc) {
>  		kfree(smsg_app_dev);
> -		goto fail_put_driver;
> +		goto fail;
>  	}
>  	smsg_app_dev->bus = &iucv_bus;
>  	smsg_app_dev->parent = iucv_root;
> @@ -177,7 +177,7 @@ static int __init smsgiucv_app_init(void
>  	rc = device_register(smsg_app_dev);
>  	if (rc) {
>  		put_device(smsg_app_dev);
> -		goto fail_put_driver;
> +		goto fail;
>  	}
>
>  	/* convert sender to uppercase characters */
> @@ -191,12 +191,11 @@ static int __init smsgiucv_app_init(void
>  	rc = smsg_register_callback(SMSG_PREFIX, smsg_app_callback);
>  	if (rc) {
>  		device_unregister(smsg_app_dev);
> -		goto fail_put_driver;
> +		goto fail;
>  	}
>
>  	rc = 0;
> -fail_put_driver:
> -	put_driver(smsgiucv_drv);
> +fail:
>  	return rc;
>  }
>  module_init(smsgiucv_app_init);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
