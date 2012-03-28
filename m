Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab2C1HC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:02:59 -0400
Received: from csmtp2.one.com ([91.198.169.22]:44399 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab2C1HC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:02:58 -0400
From: "Henrik Rydberg" <rydberg@bitmath.se>
Date: Wed, 28 Mar 2012 09:03:51 +0200
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: autoload hid-multitouch as needed
Message-ID: <20120328070351.GA29947@polaris.bitmath.org>
References: <1332864735-18709-1-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332864735-18709-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> When the generic hid parsing of the report descriptors in hid-core
> detects that the device contains the field ContactID, the device should
> be handled by hid-multitouch, and hid-core should release it.
> This patch implements a temporary fix for hid-core to automatically
> call the loading of hid-multitouch. A better solution would involve
> userspace.
> 
> The code is inspired from what is done in the bttv module.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---
> 
> Hi guys,
> 
> I finally managed to find some time to resend this patch.

Great, please find some comments inline.

>  drivers/hid/hid-core.c |   33 ++++++++++++++++++++++++++++++++-
>  include/linux/hid.h    |    8 ++++++++
>  2 files changed, 40 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 990fe19..a84221e 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1210,6 +1210,31 @@ static struct bin_attribute dev_bin_attr_report_desc = {
>  	.size = HID_MAX_DESCRIPTOR_SIZE,
>  };
>  
> +#if defined(CONFIG_MODULES) && defined(MODULE)
> +/* Loading of hid_multitouch. This is done from the kernel until we come up
> + * with a more robust solution. */
> +static void hid_request_hid_mt_module_async(struct work_struct *work)
> +{
> +	request_module("hid-multitouch");
> +}
> +
> +static void hid_request_hid_mt_module(struct hid_device *dev)
> +{
> +	dev->request_hid_mt_module = 1;
> +	INIT_WORK(&dev->request_hid_mt_module_wk,
> +		hid_request_hid_mt_module_async);

This init would probably be better off as a static declaration; after
all, we do not need one workqueue per hid device.

> +	schedule_work(&dev->request_hid_mt_module_wk);
> +}
> +
> +static void hid_flush_request_modules(struct hid_device *dev)
> +{
> +	flush_work_sync(&dev->request_hid_mt_module_wk);
> +}
> +#else
> +#define hid_request_hid_mt_module(dev)
> +#define hid_flush_request_modules(dev)
> +#endif /* CONFIG_MODULES */
> +
>  int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
>  {
>  	static const char *types[] = { "Device", "Pointer", "Mouse", "Device",
> @@ -1235,7 +1260,9 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
>  				connect_mask & HID_CONNECT_HIDINPUT_FORCE))
>  		hdev->claimed |= HID_CLAIMED_INPUT;
>  	if (hdev->quirks & HID_QUIRK_MULTITOUCH) {
> -		/* this device should be handled by hid-multitouch, skip it */
> +		/* this device should be handled by hid-multitouch, request
> +		 * for hid-multitouch to be loaded and leave the device to it */
> +		hid_request_hid_mt_module(hdev);
>  		return -ENODEV;
>  	}
>  
> @@ -2107,6 +2134,8 @@ struct hid_device *hid_allocate_device(void)
>  	INIT_LIST_HEAD(&hdev->debug_list);
>  	sema_init(&hdev->driver_lock, 1);
>  
> +	hdev->request_hid_mt_module = 0;
> +

Allocated using kzalloc, so no need.

>  	return hdev;
>  err:
>  	put_device(&hdev->dev);
> @@ -2121,6 +2150,8 @@ static void hid_remove_device(struct hid_device *hdev)
>  		hid_debug_unregister(hdev);
>  		hdev->status &= ~HID_STAT_ADDED;
>  	}
> +	if (hdev->request_hid_mt_module)
> +		hid_flush_request_modules(hdev);

I would put the test inside the flush function instead, to restrict
the use of the bare variables.

>  }
>  
>  /**
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 3a95da6..0058ca9 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -538,6 +538,14 @@ struct hid_device {							/* device report descriptor */
>  	struct dentry *debug_events;
>  	struct list_head debug_list;
>  	wait_queue_head_t debug_wait;
> +
> +	/* This is a temporary fix to make hid-multitouch loadable from
> +	 * the kernel before we come up with more robust solution
> +	 * (with userspace involvement).
> +	 * In case we detect a multitouch device through the parsing of
> +	 * hid-core, we request for hid-multitouch to be loaded. */
> +	struct work_struct request_hid_mt_module_wk;
> +	bool request_hid_mt_module;

This increases memory per hid device, which is not so nice. A static
declaration in the core module ought to suffice. Probably needs
additional locking as well.

>  };
>  
>  static inline void *hid_get_drvdata(struct hid_device *hdev)
> -- 
> 1.7.7.6
> 

Thanks,
Henrik
