Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab2LVTAs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 14:00:48 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:40405 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2LVTAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 14:00:46 -0500
Message-ID: <50D60349.7080400@linux.vnet.ibm.com>
Date: Sat, 22 Dec 2012 17:00:25 -0200
From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        brking@linux.vnet.ibm.com, benh@au1.ibm.com,
        Betty Dall <betty.dall@hp.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: Re: drm: Added ppc64 root device getter
References: <50CA5EE2.30206@linux.vnet.ibm.com> <CAErSpo6BfWGYH+=ygS6qWT-YFKPuywooVgLWm+g_eB2dMw3iKQ@mail.gmail.com>
In-Reply-To: <CAErSpo6BfWGYH+=ygS6qWT-YFKPuywooVgLWm+g_eB2dMw3iKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12122219-9254-0000-0000-00000B1EE969
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 09:31 PM, Bjorn Helgaas wrote:
> [+cc Betty]
>
> On Thu, Dec 13, 2012 at 4:04 PM, Lucas Kannebley Tavares
> <lucaskt@linux.vnet.ibm.com>  wrote:
>> On architectures such as ppc64, there is no root bus device (it belongs
>> to the hypervisor). DRM attempted to get one, causing a null-pointer
>> dereference.
>
> In addition to ppc64, at least ia64 and parisc have the same situation
> of the PCI host bridge not appearing as a  PCI device itself.
>
>> Signed-off-by: Lucas Kannebley Tavares<lucaskt@linux.vnet.ibm.com>
>>
>> --
>> diff --git a/arch/powerpc/platforms/pseries/Makefile
>> b/arch/powerpc/platforms/pseries/Makefile
>> index 890622b..ddfdda8 100644
>> --- a/arch/powerpc/platforms/pseries/Makefile
>> +++ b/arch/powerpc/platforms/pseries/Makefile
>> @@ -1,6 +1,8 @@
>>   ccflags-$(CONFIG_PPC64)                        := -mno-minimal-toc
>>   ccflags-$(CONFIG_PPC_PSERIES_DEBUG)    += -DDEBUG
>>
>> +drm-y                  += drm_pci.o
>> +
>>   obj-y                  := lpar.o hvCall.o nvram.o reconfig.o \
>>                             setup.o iommu.o event_sources.o ras.o \
>>                             firmware.o power.o dlpar.o mobility.o
>> diff --git a/arch/powerpc/platforms/pseries/drm_pci.c
>> b/arch/powerpc/platforms/pseries/drm_pci.c
>> new file mode 100644
>> index 0000000..da6675e
>> --- /dev/null
>> +++ b/arch/powerpc/platforms/pseries/drm_pci.c
>> @@ -0,0 +1,24 @@
>> +/*
>> + * Copyright (C) 2012 Lucas Kannebley Tavares, IBM Corporation
>> + *
>> + * pSeries specific routines for DRM.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
>> + */
>> +
>> +inline struct pci_device *drm_get_parent_device(struct drm_device *dev) {
>> +       return (dev->pdev->bus->self == NULL) ? dev->pdev :
>> dev->pdev->bus->self;
>
> So for DRM devices on a root bus, the parent is the DRM device itself,
> while for DRM devices deeper in the hierarchy, the parent is the
> upstream P2P bridge?  That doesn't really make sense to me.  If the
> caller operates on the DRM device in some cases and on the bridge in
> other cases, it's going to need to know the difference, so hiding the
> difference in this wrapper seems counterproductive.
>
>> +}
>> +
>> diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
>> index eb37466..5a8a4f5 100644
>> --- a/drivers/gpu/drm/drm_pci.c
>> +++ b/drivers/gpu/drm/drm_pci.c
>> @@ -466,6 +466,10 @@ void drm_pci_exit(struct drm_driver *driver, struct
>> pci_driver *pdriver)
>>   }
>>   EXPORT_SYMBOL(drm_pci_exit);
>>
>> +inline __weak struct pci_device *drm_get_parent_device(struct drm_device
>> *dev) {
>> +       return dev->pdev->bus->self;
>> +}
>> +
>>   int drm_pcie_get_speed_cap_mask(struct drm_device *dev, u32 *mask)
>>   {
>>          struct pci_dev *root;
>> @@ -479,7 +483,7 @@ int drm_pcie_get_speed_cap_mask(struct drm_device *dev,
>> u32 *mask)
>>                  return -EINVAL;
>>
>>          // find PCI device for capabilities
>> -       root = dev->pdev->bus->self;
>> +       root = drm_get_parent_device(dev);
>>
>>          // some architectures might not have host bridges as PCI devices
>>          if (root == NULL)
>
> What tree does this apply to?  Upstream doesn't have the "if (root ==
> NULL)" check yet.  That check looks like the sort of thing you'd need
> to avoid the null pointer dereference.  So maybe adding that check and
> the associated code is enough to fix the problem, even without adding
> drm_get_parent_device().
>
> With the code in the tree, it looks like you'd dereference a null
> pointer in pci_pcie_cap(root), so I assume that's what you tripped
> over.
>
> I'm not really sure that code outside the PCI core should be looking
> at capabilities of upstream devices like this.  It seems like the sort
> of thing where the core might need to provide better interfaces.
>
> Bjorn
>

Ok Bjorn, thanks for the comments, indeed I had a dirty tree here and 
didn't realize it, sorry. Either way I'm then sending the "if (root == 
NULL)" patch as a reply to this. I'm sending it along with another 
independent patch (they are NOT a series) that changes 
pci_read_config_dword calls to pci_capability_read_dword ones on the drm 
driver. There were only a couple of those to start with.

-- 
Lucas Kannebley Tavares
Software Engineer
IBM Linux Technology Center

