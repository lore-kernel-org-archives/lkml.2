Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965538Ab0COSFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:05:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13361 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965385Ab0COSFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:05:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5921"; a="36412627"
Message-ID: <4B9E76B8.2000208@codeaurora.org>
Date: Mon, 15 Mar 2010 12:04:40 -0600
From: Jordan Crouse <jcrouse@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Jordan Crouse <jcrouse@codeaurora.org>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] drm: Allow platform devices to register as DRM devices
References: <4B8BE42C.1090401@codeaurora.org> <4B8BE489.7020402@codeaurora.org> <21d7e9971003141756l51d9e971x83b8b8cfbb0de25@mail.gmail.com>
In-Reply-To: <21d7e9971003141756l51d9e971x83b8b8cfbb0de25@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On Tue, Mar 2, 2010 at 2:00 AM, Jordan Crouse <jcrouse@codeaurora.org> wrote:
>> Allow platform devices without PCI resources to be DRM devices.
>>
>> Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
> 
> This patch has a bunch of whitespace damage at least in my inbox and
> also in patchwork

Yes, PBCAK.

> Please also be careful with the places you add copyrights, you moved a
> bunch of code
> from drm_drv.c to drm_pci.c and added a copyright for Code Aurora in
> drm_pci.c? You can
> only assert copyright if you actually wrote the code, otherwise the patch
> contains your authorship details and who contributed the code. I'm
> guessing you might have
> copyright over one file in this that being drm_platform.c, the rest
> I'm less sure about.
> 
> I also wonder if we could/should separate the arm drm support out from
> this patch (i.e.
> the __arm__ changes).

That might not be a bad idea, I'll do that.

> Some other misc comments below:
> 
>>  #
>>  menuconfig DRM
>>        tristate "Direct Rendering Manager (XFree86 4.1.0 and higher DRI
>> support)"
>> -       depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && MMU
> 
>>From what I can see the AGP || AGP==n is still required, you just want
> to drop the PCI
> dependancy??

I guess technically we could also drop the AGP requirement, but since it worked
on my box with AGP=n it seemed to me like a NOP.

>> +       depends on !EMULATED_CMPXCHG && MMU
>>
>> diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
>> index 8417cc4..4177f60 100644
>> --- a/drivers/gpu/drm/drm_bufs.c
>> +++ b/drivers/gpu/drm/drm_bufs.c
>> @@ -11,6 +11,7 @@
>>  *
>>  * Copyright 1999, 2000 Precision Insight, Inc., Cedar Park, Texas.
>>  * Copyright 2000 VA Linux Systems, Inc., Sunnyvale, California.
>> + * Copyright (c) 2009, Code Aurora Forum.
>>  * All Rights Reserved.
> 
> There have been much bigger changes to these files without copyright
> additions, I'm not sure how big something needs to be but I'm not 100% sure
> this comes close.
> 
>>  resource_size_t drm_get_resource_start(struct drm_device *dev, unsigned int
>> resource)
>>  {
>> +       if (drm_core_check_feature(dev, DRIVER_USE_PLATFORM_DEVICE)) {
>> +               struct resource *r;
>> +               r = platform_get_resource(dev->platformdev, IORESOURCE_MEM,
>> +                                            resource);
>> +
>> +               return r ? r->start : 0;
>> +       }
>> +
>> +#ifdef CONFIG_PCI
>>        return pci_resource_start(dev->pdev, resource);
>> +#endif
>> +
>> +       return 0;
>>  }
>>  EXPORT_SYMBOL(drm_get_resource_start);
>>
>>  resource_size_t drm_get_resource_len(struct drm_device *dev, unsigned int
>> resource)
>>  {
>> +       if (drm_core_check_feature(dev, DRIVER_USE_PLATFORM_DEVICE)) {
>> +               struct resource *r;
>> +               r = platform_get_resource(dev->platformdev, IORESOURCE_MEM,
>> +                       resource);
>> +
>> +               return r ? (r->end - r->start) : 0;
>> +       }
>> +
>> +#ifdef CONFIG_PCI
>>        return pci_resource_len(dev->pdev, resource);
>> +#endif
>> +
>> +       return 0;
>>  }
>>
>>  EXPORT_SYMBOL(drm_get_resource_len);
>> @@ -188,7 +213,7 @@ static int drm_addmap_core(struct drm_device * dev,
>> resource_size_t offset,
>>        switch (map->type) {
>>        case _DRM_REGISTERS:
>>        case _DRM_FRAME_BUFFER:
>> -#if !defined(__sparc__) && !defined(__alpha__) && !defined(__ia64__) &&
>> !defined(__powerpc64__) && !defined(__x86_64__)
>> +#if !defined(__sparc__) && !defined(__alpha__) && !defined(__ia64__) &&
>> !defined(__powerpc64__) && !defined(__x86_64__) && !defined(__arm__)
>>                if (map->offset + (map->size-1) < map->offset ||
>>                    map->offset < virt_to_phys(high_memory)) {
>>                        kfree(map);
> 
>> diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
>> index 766c468..b5171ed 100644
>> --- a/drivers/gpu/drm/drm_drv.c
>> +++ b/drivers/gpu/drm/drm_drv.c
>> @@ -24,6 +24,7 @@
>>  *
>>  * Copyright 1999, 2000 Precision Insight, Inc., Cedar Park, Texas.
>>  * Copyright 2000 VA Linux Systems, Inc., Sunnyvale, California.
>> + * Copyright (c) 2009, Code Aurora Forum.
>>  * All Rights Reserved.
> 
> again similiar, but even less code since you mostly remove code.
> 
>>  *
>>  * Permission is hereby granted, free of charge, to any person obtaining a
>> @@ -242,47 +243,20 @@ int drm_lastclose(struct drm_device * dev)
>>  *
>>  * Initializes an array of drm_device structures, and attempts to
>>  * initialize all available devices, using consecutive minors, registering
>> the
>> - * stubs and initializing the AGP device.
>> + * stubs and initializing the device.
>>  *
>>  * Expands the \c DRIVER_PREINIT and \c DRIVER_POST_INIT macros before and
>>  * after the initialization for driver customization.
>>  */
>>  int drm_init(struct drm_driver *driver)
>>  {
>> -       struct pci_dev *pdev = NULL;
>> -       const struct pci_device_id *pid;
>> -       int i;
>> -
>>        DRM_DEBUG("\n");
>> -
>>        INIT_LIST_HEAD(&driver->device_list);
>>
>> -       if (driver->driver_features & DRIVER_MODESET)
>> -               return pci_register_driver(&driver->pci_driver);
>> -
>> -       /* If not using KMS, fall back to stealth mode manual scanning. */
>> -       for (i = 0; driver->pci_driver.id_table[i].vendor != 0; i++) {
>> -               pid = &driver->pci_driver.id_table[i];
>> -
>> -               /* Loop around setting up a DRM device for each PCI device
>> -                * matching our ID and device class.  If we had the internal
>> -                * function that pci_get_subsys and pci_get_class used, we'd
>> -                * be able to just pass pid in instead of doing a two-stage
>> -                * thing.
>> -                */
>> -               pdev = NULL;
>> -               while ((pdev =
>> -                       pci_get_subsys(pid->vendor, pid->device,
>> pid->subvendor,
>> -                                      pid->subdevice, pdev)) != NULL) {
>> -                       if ((pdev->class & pid->class_mask) != pid->class)
>> -                               continue;
>> -
>> -                       /* stealth mode requires a manual probe */
>> -                       pci_dev_get(pdev);
>> -                       drm_get_dev(pdev, pid, driver);
>> -               }
>> -       }
>> -       return 0;
>> +       if (driver->driver_features & DRIVER_USE_PLATFORM_DEVICE)
>> +               return drm_platform_init(driver);
>> +       else
>> +               return drm_pci_init(driver);
>>  }
>>
>>  EXPORT_SYMBOL(drm_init);
>> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
>> index ab6c973..48a14a0 100644
>> --- a/drivers/gpu/drm/drm_edid.c
>> +++ b/drivers/gpu/drm/drm_edid.c
>> @@ -1220,6 +1220,9 @@ struct edid *drm_get_edid(struct drm_connector
>> *connector,
>>        int ret;
>>        struct edid *edid;
>>
>> +       if (drm_core_check_feature(connector->dev,
>> DRIVER_USE_PLATFORM_DEVICE))
>> +               return NULL;
>> +
> 
> 
> This makes no sense, having the ability to probe EDID or not is most
> definitely not a platform vs PCI problem.

Yeah, that was my poor man's "Don't probe EDID" hack.  I'm not sure if there
is a smart way to implicitly check to see if EDID should be probed, but I'm
worried about abusing the features flag too badly, though if a DRIVER_USE_EDID
is needed then we shouldn't be shy about using it.

> 
> 
> 
>>  {
>>        struct drm_irq_busid *p = data;
>>
>> +       if (drm_core_check_feature(dev, DRIVER_USE_PLATFORM_DEVICE))
>> +               return -EINVAL;
> 
> Not 100% sure about this, but if you only intend on KMS and don't need to
> inform userspace of irq support this should be okay.

Again, a "don't do this" hack.  I'll look at this more carefully and see if there
is a good way to evaluate this based on the hooks that the platform has defined.

> 
> 
>> diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
>> index 4ac900f..22aaaae 100644
>> --- a/drivers/gpu/drm/drm_vm.c
>> +++ b/drivers/gpu/drm/drm_vm.c
>> @@ -60,7 +60,7 @@ static pgprot_t drm_io_prot(uint32_t map_type, struct
>> vm_area_struct *vma)
>>                tmp = pgprot_writecombine(tmp);
>>        else
>>                tmp = pgprot_noncached(tmp);
>> -#elif defined(__sparc__)
>> +#elif defined(__sparc__) || defined(__arm__)
>>        tmp = pgprot_noncached(tmp);
>>  #endif
>>        return tmp;
>> @@ -600,6 +600,7 @@ int drm_mmap_locked(struct file *filp, struct
>> vm_area_struct *vma)
>>        }
>>
>>        switch (map->type) {
>> +#if !defined(__arm__)
>>        case _DRM_AGP:
>>                if (drm_core_has_AGP(dev) && dev->agp->cant_use_aperture) {
>>                        /*
>> @@ -614,20 +615,31 @@ int drm_mmap_locked(struct file *filp, struct
>> vm_area_struct *vma)
>>                        break;
>>                }
>>                /* fall through to _DRM_FRAME_BUFFER... */
>> +#endif
>>        case _DRM_FRAME_BUFFER:
>>        case _DRM_REGISTERS:
>>                offset = dev->driver->get_reg_ofs(dev);
>>                vma->vm_flags |= VM_IO; /* not in core dump */
>>                vma->vm_page_prot = drm_io_prot(map->type, vma);
>> +#if !defined(__arm__)
>>                if (io_remap_pfn_range(vma, vma->vm_start,
>>                                       (map->offset + offset) >> PAGE_SHIFT,
>>                                       vma->vm_end - vma->vm_start,
>>                                       vma->vm_page_prot))
>>                        return -EAGAIN;
>> +#else
>> +               if (remap_pfn_range(vma, vma->vm_start,
>> +                                       (map->offset + offset) >>
>> PAGE_SHIFT,
>> +                                       vma->vm_end - vma->vm_start,
>> +                                       vma->vm_page_prot))
>> +                       return -EAGAIN;
>> +#endif
>> +
>>                DRM_DEBUG("   Type = %d; start = 0x%lx, end = 0x%lx,"
>>                          " offset = 0x%llx\n",
>>                          map->type,
>>                          vma->vm_start, vma->vm_end, (unsigned long
>> long)(map->offset + offset));
>> +
>>                vma->vm_ops = &drm_vm_ops;
>>                break;
>>        case _DRM_CONSISTENT:
>> diff --git a/drivers/gpu/drm/i915/i915_drv.c
>> b/drivers/gpu/drm/i915/i915_drv.c
>> index cf4cb3e..29d26c2 100644
>> --- a/drivers/gpu/drm/i915/i915_drv.c
>> +++ b/drivers/gpu/drm/i915/i915_drv.c
>> @@ -392,7 +392,7 @@ int i965_reset(struct drm_device *dev, u8 flags)
>>  static int __devinit
>>  i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>  {
>> -       return drm_get_dev(pdev, ent, &driver);
>> +       return drm_get_pci_dev(pdev, ent, &driver);
>>  }
>>
>>  static void
>> diff --git a/drivers/gpu/drm/radeon/radeon_drv.c
>> b/drivers/gpu/drm/radeon/radeon_drv.c
>> index 8ba3de7..6586f6a 100644
>> --- a/drivers/gpu/drm/radeon/radeon_drv.c
>> +++ b/drivers/gpu/drm/radeon/radeon_drv.c
>> @@ -223,7 +223,7 @@ static struct drm_driver kms_driver;
>>  static int __devinit
>>  radeon_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>  {
>> -       return drm_get_dev(pdev, ent, &kms_driver);
>> +       return drm_get_pci_dev(pdev, ent, &kms_driver);
>>  }
>>
> 
> This also doesn't address noueau/vmwgfx entry points.

Yep, thats my bad.  I'll refresh and push better patches without whitespace stupidity.
Thanks for your comments.

Jordan

