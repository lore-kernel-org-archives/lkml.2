Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab1IGUiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 16:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348Ab1IGUiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 16:38:04 -0400
Message-ID: <4E67D5F7.6070103@redhat.com>
Date: Wed, 07 Sep 2011 16:37:11 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Joerg Roedel <joro@8bytes.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>	<1315410113-26608-3-git-send-email-joerg.roedel@amd.com>	<20110907184750.GA920@suse.de> <20110907191919.GA31674@8bytes.org> <20110907194445.GA2526@suse.de>
In-Reply-To: <20110907194445.GA2526@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 03:44 PM, Greg KH wrote:
> On Wed, Sep 07, 2011 at 09:19:19PM +0200, Joerg Roedel wrote:
>> Hi Greg,
>>
>> the bus_set_iommu() function will be called by the IOMMU driver. There
>> can be different drivers for the same bus, depending on the hardware. On
>> PCI for example, there can be the Intel or the AMD IOMMU driver that
>> implement the iommu-api and that register for that bus.
>
> Why are you pushing this down into the driver core?  What other busses
> becides PCI use/need this?
>
> If you can have a different IOMMU driver on the same bus, then wouldn't
> this be a per-device thing instead of a per-bus thing?
>
And given the dma api takes a struct device *, it'd be more efficient
to be tied into the device structure.
Device structure would get iommu ops set by parent(bus);
if a bus (segment) doesn't provide a unique/different/layered IOMMU
then the parent bus, it inherits the parent's iommu-ops.
setting the iommu-ops in the root bus struct, seeds the iommu-ops
for the (PCI) tree.

For intel & amd IOMMUs, in early pci (bios,root?) init, you would
seed the pci root busses with appropriate IOMMU support (based on
dmar/drhd & ivrs/ivhd data structures, respectively), and
then modify the PCI code to do the inheritence (PPB code inherits
unless specific device driver for a given PPB vid-did loads a
different iommu-ops for that segment/branch).

This would enable different types of IOMMUs for different devices
(or PCI segments, or branches of PCI trees) that are designed for
different tasks -- simple IOMMUs for legacy devices; complicated, io-page-faulting
IOMMUs for plug-in, high-end devices on virtualizing servers for PCI (SRIOV) endpoints.

and as Greg indicates, is only relevant to PCI.
The catch is that dev* has to be looked at for iommu support for dma-ops.

>
>> On Wed, Sep 07, 2011 at 11:47:50AM -0700, Greg KH wrote:
>>>> +#ifdef CONFIG_IOMMU_API
>>>> +int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops)
>>>> +{
>>>> +	if (bus->iommu_ops != NULL)
>>>> +		return -EBUSY;
>>>
>>> Busy?
>>
>> Yes, it signals to the IOMMU driver that another driver has already
>> registered for that bus. In the previous register_iommu() interface this
>> was just a BUG(), but I think returning an error to the caller is
>> better. It can be turned back into a BUG() if it is considered better,
>> though.
>
> Can you ever have more than one IOMMU driver per bus?  If so, this seems
> wrong (see above.)
>
>>>> +
>>>> +	bus->iommu_ops = ops;
>>>> +
>>>> +	/* Do IOMMU specific setup for this bus-type */
>>>> +	iommu_bus_init(bus, ops);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(bus_set_iommu);
>>>
>>> I don't understand what this function is for, and who would call it.
>>
>> It is called by the IOMMU driver.
>>
>>> Please provide kerneldoc that explains this.
>>
>> Will do.
>>
>>>> @@ -67,6 +68,9 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
>>>>    * @resume:	Called to bring a device on this bus out of sleep mode.
>>>>    * @pm:		Power management operations of this bus, callback the specific
>>>>    *		device driver's pm-ops.
>>>> + * @iommu_ops   IOMMU specific operations for this bus, used to attach IOMMU
>>>> + *              driver implementations to a bus and allow the driver to do
>>>> + *              bus-specific setup
>>>
>>> So why is this just not set by the bus itself, making the above function
>>> not needed at all?
>>
>> The IOMMUs are usually devices on the bus itself, so they are
>> initialized after the bus is set up and the devices on it are
>> populated.  So the function can not be called on bus initialization
>> because the IOMMU is not ready at this point.
>
> Ok, that makes more sense, please state as much in the documentation.
>
> thanks,
>
> greg k-h
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/iommu

