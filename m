Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab1JBRZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 13:25:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42498 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1JBRZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 13:25:10 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.135.251]
In-Reply-To: <20110929200423.GB26760@kroah.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
 <1316792756-3395-9-git-send-email-joerg.roedel@amd.com> <20110929200423.GB26760@kroah.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 2 Oct 2011 19:24:49 +0200
Message-ID: <CAK=WgbabhTk-iAqdW1kSMtzdQNpxdz1kKhEMZDGXwYNknCONGQ@mail.gmail.com>
Subject: Re: [PATCH 08/10] iommu/omap: Use bus_set_iommu instead of register_iommu
To: Greg KH <greg@kroah.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, joro@8bytes.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for the late response; we had a big holiday here and I was
forced away from my keyboard :)

On Thu, Sep 29, 2011 at 11:04 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Sep 23, 2011 at 05:45:54PM +0200, Joerg Roedel wrote:
>> -     register_iommu(&omap_iommu_ops);
>> +     bus_set_iommu(&platform_bus_type, &omap_iommu_ops);
>
> I too worry about this.
>
> It kind of looks like the omap code should not be using the platform bus
> code for this, but instead, use their own bus code, as I'm sure that not
> all platform devices really work properly with this iommu controller,
> right?

You're right that not all omap platform devices will work with this
iommu device.

But maybe it's worth explaining the bigger difference here: there is
no omap bus really that makes sense here as much as pci does with x86.

On OMAP each iommu device services a single, and specific, on-chip
device (and not a group of devices that resides on a specific hardware
bus). E.g. on OMAP4 we have an iommu for the DSP, and another one for
the dual Cortex M3.

Those remote processors devices happen to be platform devices (because
there isn't really any relevant hardware bus here), and board code (or
DT) will set their iommu archdata to point at the relevant iommu
devices they're physically attached to. This way their drivers will be
able to configure the appropriate iommu devices as needed.

Binding the iommu ops to the platform bus will not enable other
platform drivers to configure the iommu: no other device will have the
relevant iommu archdata set, and any attempt to erroneously configure
the iommu by an unrelated driver will immediately fail (i.e.
iommu_attach_device() will fail).

In that sense, binding the iommu ops to the platform bus does not
increase the chance of error. I guess it even reduces it, because
today the iommu ops are globally accessible.

I was worried that with this change, sub-devices of the original
platform device, that belong to a different bus (e.g. virtio or
rpmsg), might not be able to access those iommu ops anymore. But I
guess that as long as we set the parent-child device hierarchy
appropriately, that would be a non issue.

Thanks,
Ohad.
