Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab0HXExu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 00:53:50 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:24879 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357Ab0HXExr (ORCPT
	<rfc822;groupwise-jlee@novell.com:3:2>);
	Tue, 24 Aug 2010 00:53:47 -0400
Message-Id: <4C73DCF5020000230001F361@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Mon, 23 Aug 2010 22:53:41 -0600
From: "Joey Lee" <jlee@novell.com>
To: <trenn@suse.de>
Cc: <mjg59@srcf.ucam.org>, <gregkh@suse.de>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
 detect
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, 

於 一，2010-08-23 於 19:53 +0200，Thomas Renninger 提到：
> > 
> > I'm still kind of reluctant about this - doing the blacklisting here 
> > means that there's no way for a native driver to inhibit registration 
> > from occuring until after opregion setup has taken place, and we found 
> > that that was necessary on some 915 so I suspect it is on gma500 as 
> > well. Perhaps it should just be done as a module option, and then 
> > distributions who want to deal with this case could set it by default?
> Hm, needing a module option to get a system running is not what the user expects.
> By default, the system should run fine and a module option should be added
> as a workaround or for debugging only.
> 
> What do you think about below patch which introduces:
>   - the blacklist based on the previous patch and comments
>   - the module param -> as workaround and for trying out
>   - let video.ko and i915_opregion share the same func to check
>     for opregion support
> 
> Should I add a drm/i915 list for this to get another review?

I respined your patch and build it on 2.6.34 kernel success, but it
causes depmod detected a loop warning then ignore video.ko and i915.ko

linux-4byd:/usr/src/linux-2.6.34-12/drivers/acpi # depmod
WARNING: Loop
detected: /lib/modules/2.6.34-12-desktop/kernel/drivers/acpi/video.ko
needs i915.ko which needs video.ko again!
WARNING:
Module /lib/modules/2.6.34-12-desktop/kernel/drivers/acpi/video.ko
ignored, due to loop
WARNING:
Module /lib/modules/2.6.34-12-desktop/kernel/drivers/gpu/drm/i915/i915.ko ignored, due to loop
WARNING:
Module /lib/modules/2.6.34-12-desktop/kernel/drivers/platform/x86/msi-laptop.ko ignored, due to loop

I think because i915.ko already dependency to video.h when we add
opregion support. 
So, now, video.c could not be includ i915_drm.h


Thank's
Joey Lee

> 
> -----------------
> drm i915: Better communicate opregion support with video.ko
> 
> and add a i915 module parameter to enable/disable opregion code
> and add a blacklist where we know opregion currently does not work.
> 
> This code is compile tested only on latest 2.6 Linus git tree.
> Thorough review or some testing is still needed.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: joeyli.kernel@gmail.com
> CC: gregkh@suse.de
> CC: Dennis.Jansen@web.de
> CC: linux-acpi@vger.kernel.org
> CC: mjg@redhat.com
> 
> ---
>  drivers/acpi/video.c                 |   16 +++++--
>  drivers/gpu/drm/i915/i915_opregion.c |   77 +++++++++++++++++++++++++++++++--
>  include/drm/i915_drm.h               |    1 +
>  include/linux/pci_ids.h              |    2 +
>  4 files changed, 86 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 67dec0c..b91b51e 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -46,6 +46,9 @@
>  #include <acpi/acpi_drivers.h>
>  #include <linux/suspend.h>
>  #include <acpi/video.h>
> +#if defined(CONFIG_DRM_I915) || defined(CONFIG_DRM_I915_MODULE)
> +#include <drm/i915_drm.h>
> +#endif
>  
>  #define PREFIX "ACPI: "
>  
> @@ -2557,17 +2560,20 @@ static int __init intel_opregion_present(void)
>  {
>  #if defined(CONFIG_DRM_I915) || defined(CONFIG_DRM_I915_MODULE)
>  	struct pci_dev *dev = NULL;
> -	u32 address;
> +	int err;
>  
>  	for_each_pci_dev(dev) {
>  		if ((dev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
>  			continue;
>  		if (dev->vendor != PCI_VENDOR_ID_INTEL)
>  			continue;
> -		pci_read_config_dword(dev, 0xfc, &address);
> -		if (!address)
> -			continue;
> -		return 1;
> +		err = intel_opregion_device_support(dev);
> +		if (err == 0)
> +			return 1;
> +		else
> +			ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No opregion support"
> +					  " on Intel graphics card: %d\n",
> +					  err));
>  	}
>  #endif
>  	return 0;
> diff --git a/drivers/gpu/drm/i915/i915_opregion.c b/drivers/gpu/drm/i915/i915_opregion.c
> index ea5d3fe..eb49896 100644
> --- a/drivers/gpu/drm/i915/i915_opregion.c
> +++ b/drivers/gpu/drm/i915/i915_opregion.c
> @@ -26,6 +26,8 @@
>   */
>  
>  #include <linux/acpi.h>
> +#include <linux/pci_ids.h>
> +#include <linux/pci.h>
>  #include <acpi/video.h>
>  
>  #include "drmP.h"
> @@ -464,15 +466,43 @@ blind_set:
>  	goto end;
>  }
>  
> -int intel_opregion_init(struct drm_device *dev, int resume)
> +static int i915_opregion = 1;
> +module_param_named(opregion, i915_opregion, int, 0400);
> +MODULE_PARM_DESC(opregion, "opregion support (backlight,display output,..) "
> +		 "(1=on [default], 0=off, 2=force)");
> +
> +static const struct pci_device_id intel_opregion_blacklist[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_VGA_0) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SCH_VGA_1) },
> +	{ }
> +};
> +
> +/* Returns zero if opregion device is supported or an error code if not */
> +int intel_opregion_device_support(struct pci_dev *pdev)
>  {
> -	struct drm_i915_private *dev_priv = dev->dev_private;
> -	struct intel_opregion *opregion = &dev_priv->opregion;
> +	struct intel_opregion opregion;
>  	void *base;
>  	u32 asls, mboxes;
> -	int err = 0;
> +	int i, err = 0;
> +
> +	if (i915_opregion == 0)
> +		return -ENODEV;
> +
> +	for (i = 0; intel_opregion_blacklist[i].device != 0; i++) {
> +		if (pdev->device == intel_opregion_blacklist[i].device) {
> +			if (i915_opregion != 2) {
> +				DRM_INFO("opregion support blacklisted for"
> +					 " device %s, let video.ko handle it\n",
> +					 pci_name(pdev));
> +				return -ENOTSUPP;
> +			} else {
> +				DRM_INFO("Force opregion on blacklisted"
> +					 " device %s\n", pci_name(pdev));
> +			}
> +		}
> +	}
>  
> -	pci_read_config_dword(dev->pdev, PCI_ASLS, &asls);
> +	pci_read_config_dword(pdev, PCI_ASLS, &asls);
>  	DRM_DEBUG_DRIVER("graphic opregion physical addr: 0x%x\n", asls);
>  	if (asls == 0) {
>  		DRM_DEBUG_DRIVER("ACPI OpRegion not supported!\n");
> @@ -483,6 +513,43 @@ int intel_opregion_init(struct drm_device *dev, int resume)
>  	if (!base)
>  		return -ENOMEM;
>  
> +	opregion.header = base;
> +	if (memcmp(opregion.header->signature, OPREGION_SIGNATURE, 16)) {
> +		DRM_DEBUG_DRIVER("opregion signature mismatch\n");
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	mboxes = opregion.header->mboxes;
> +	if (!(mboxes & MBOX_ACPI)) {
> +		DRM_DEBUG_DRIVER("Public ACPI methods not supported\n");
> +		err = -ENOTSUPP;
> +		goto out;
> +	}
> +
> +out:
> +	iounmap(opregion.header);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(intel_opregion_device_support);
> +
> +int intel_opregion_init(struct drm_device *dev, int resume)
> +{
> +	struct drm_i915_private *dev_priv = dev->dev_private;
> +	struct intel_opregion *opregion = &dev_priv->opregion;
> +	void *base;
> +	u32 asls, mboxes;
> +	int err = 0;
> +
> +	err = intel_opregion_device_support(dev->pdev);
> +	if (err)
> +		return err;
> +
> +	pci_read_config_dword(dev->pdev, PCI_ASLS, &asls);
> +	base = ioremap(asls, OPREGION_SZ);
> +	if (!base)
> +		return -ENOMEM;
> +
>  	opregion->header = base;
>  	if (memcmp(opregion->header->signature, OPREGION_SIGNATURE, 16)) {
>  		DRM_DEBUG_DRIVER("opregion signature mismatch\n");
> diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
> index 8f8b072..3fa5f20 100644
> --- a/include/drm/i915_drm.h
> +++ b/include/drm/i915_drm.h
> @@ -40,6 +40,7 @@ extern bool i915_gpu_raise(void);
>  extern bool i915_gpu_lower(void);
>  extern bool i915_gpu_busy(void);
>  extern bool i915_gpu_turbo_disable(void);
> +extern int intel_opregion_device_support(struct pci_dev *pdev);
>  #endif
>  
>  /* Each region is a minimum of 16k, and there are at most 255 of them.
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index f6a3b2d..2861dd8 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2675,6 +2675,8 @@
>  #define PCI_DEVICE_ID_INTEL_82443GX_0	0x71a0
>  #define PCI_DEVICE_ID_INTEL_82443GX_2	0x71a2
>  #define PCI_DEVICE_ID_INTEL_82372FB_1	0x7601
> +#define PCI_DEVICE_ID_INTEL_SCH_VGA_0	0x8108
> +#define PCI_DEVICE_ID_INTEL_SCH_VGA_1	0x8109
>  #define PCI_DEVICE_ID_INTEL_SCH_LPC	0x8119
>  #define PCI_DEVICE_ID_INTEL_SCH_IDE	0x811a
>  #define PCI_DEVICE_ID_INTEL_82454GX	0x84c4

