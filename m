Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab2KJWWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 17:22:43 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:37326 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2KJWWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 17:22:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] ACPI / platform: use ACPI device name instead of _HID._UID
Date: Sat, 10 Nov 2012 23:26:56 +0100
Message-ID: <1534244.mUMtElKoGc@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc4+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1352203971-9219-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1352203971-9219-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 06, 2012 02:12:51 PM Mika Westerberg wrote:
> Using _UID makes the ACPI platform bus code to depend on BIOS to get it
> right. If it doesn't we fail to create the platform device as the name
> should be unique.
> 
> The ACPI core already makes an unique name when it first creates the ACPI
> device so we can use that same name as the platform device name instead of
> trusting that the BIOS sets the _UIDs correctly.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>

Applied to linux-pm.git/linux-next.

Thanks,
Rafael


> ---
> This was suggested by Bjorn Helgaas in another thread. The patch applies on
> top of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
> linux-next.
> 
>  drivers/acpi/acpi_platform.c |   62 +++++++++++++++---------------------------
>  1 file changed, 22 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
> index a5a2346..dbb31d6 100644
> --- a/drivers/acpi/acpi_platform.c
> +++ b/drivers/acpi/acpi_platform.c
> @@ -120,25 +120,6 @@ static acpi_status acpi_platform_add_resources(struct acpi_resource *res,
>  	return AE_OK;
>  }
>  
> -static acpi_status acpi_platform_get_device_uid(struct acpi_device *adev,
> -						int *uid)
> -{
> -	struct acpi_device_info *info;
> -	acpi_status status;
> -
> -	status = acpi_get_object_info(adev->handle, &info);
> -	if (ACPI_FAILURE(status))
> -		return status;
> -
> -	status = AE_NOT_EXIST;
> -	if ((info->valid & ACPI_VALID_UID) &&
> -	     !kstrtoint(info->unique_id.string, 0, uid))
> -		status = AE_OK;
> -
> -	kfree(info);
> -	return status;
> -}
> -
>  /**
>   * acpi_create_platform_device - Create platform device for ACPI device node
>   * @adev: ACPI device node to create a platform device for.
> @@ -156,19 +137,12 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev)
>  	struct device *parent = NULL;
>  	struct resource_info ri;
>  	acpi_status status;
> -	int devid;
>  
>  	/* If the ACPI node already has a physical device attached, skip it. */
>  	if (adev->physical_node_count)
>  		return NULL;
>  
> -	/* Use the UID of the device as the new platform device id if found. */
> -	status = acpi_platform_get_device_uid(adev, &devid);
> -	if (ACPI_FAILURE(status))
> -		devid = -1;
> -
>  	memset(&ri, 0, sizeof(ri));
> -
>  	/* First, count the resources. */
>  	status = acpi_walk_resources(adev->handle, METHOD_NAME__CRS,
>  				     acpi_platform_count_resources, &ri);
> @@ -214,8 +188,8 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev)
>  		}
>  		mutex_unlock(&acpi_parent->physical_node_lock);
>  	}
> -	pdev = platform_device_register_resndata(parent, acpi_device_hid(adev),
> -						 devid, ri.res, ri.n, NULL, 0);
> +	pdev = platform_device_register_resndata(parent, dev_name(&adev->dev),
> +						 -1, ri.res, ri.n, NULL, 0);
>  	if (IS_ERR(pdev)) {
>  		dev_err(&adev->dev, "platform device creation failed: %ld\n",
>  			PTR_ERR(pdev));
> @@ -245,17 +219,7 @@ static acpi_status acpi_platform_match(acpi_handle handle, u32 depth,
>  	if (adev->physical_node_count)
>  		return AE_OK;
>  
> -	if (!strcmp(pdev->name, acpi_device_hid(adev))) {
> -		int devid;
> -
> -		/* Check that both name and UID match if it exists */
> -		status = acpi_platform_get_device_uid(adev, &devid);
> -		if (ACPI_FAILURE(status))
> -			devid = -1;
> -
> -		if (pdev->id != devid)
> -			return AE_OK;
> -
> +	if (!strcmp(dev_name(&pdev->dev), dev_name(&adev->dev))) {
>  		*(acpi_handle *)return_value = handle;
>  		return AE_CTRL_TERMINATE;
>  	}
> @@ -266,10 +230,28 @@ static acpi_status acpi_platform_match(acpi_handle handle, u32 depth,
>  static int acpi_platform_find_device(struct device *dev, acpi_handle *handle)
>  {
>  	struct platform_device *pdev = to_platform_device(dev);
> +	char *name, *tmp, *hid;
> +
> +	/*
> +	 * The platform device is named using the ACPI device name
> +	 * _HID:INSTANCE so we strip the INSTANCE out in order to find the
> +	 * correct device using its _HID.
> +	 */
> +	name = kstrdup(dev_name(dev), GFP_KERNEL);
> +	if (!name)
> +		return -ENOMEM;
> +
> +	tmp = name;
> +	hid = strsep(&tmp, ":");
> +	if (!hid) {
> +		kfree(name);
> +		return -ENODEV;
> +	}
>  
>  	*handle = NULL;
> -	acpi_get_devices(pdev->name, acpi_platform_match, pdev, handle);
> +	acpi_get_devices(hid, acpi_platform_match, pdev, handle);
>  
> +	kfree(name);
>  	return *handle ? 0 : -ENODEV;
>  }
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
