Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1KUEjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 23:39:31 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59148 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1KUEj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 23:39:29 -0500
MIME-Version: 1.0
In-Reply-To: <20111120120043.GB20535@8bytes.org>
References: <20111117170800.3125.84150.stgit@bling.home>
	<20111118104651.GJ5627@amd.com>
	<1321628190.26410.63.camel@bling.home>
	<20111118152710.GA5098@amd.com>
	<1321633956.26410.126.camel@bling.home>
	<20111120120043.GB20535@8bytes.org>
Date: Mon, 21 Nov 2011 12:39:27 +0800
Message-ID: <CANqQZNEFDiQc68DBgvRY9Q+LXdQZfVym5GY_XOuNwnaA=7RtjQ@mail.gmail.com>
Subject: Re: [PATCH] iommu: Include MSI susceptibility to DMA in creating
 iommu groups
From: Kai Huang <mail.kai.huang@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 20, 2011 at 8:00 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Fri, Nov 18, 2011 at 09:32:36AM -0700, Alex Williamson wrote:
>> I guess I fail to see the difference.  We group devices behind certain
>> bridges together because we can't distinguish DMA from those devices.
>> MSI presents an address window across all devices for which we
>> potentially can't distinguish between any of them.
>
> With an IOMMU the address window is per-device and not shared between
> all devices. A MSI message is nothing more than a DMA write transaction
> to a specific address. This message has a requestor-id so an IOMMU can
> distinguish between devices. The AMD IOMMU for example uses that to
> implement per-device remapping tables.

In my understanding the Interrupt Remapping provides device isolation
from the security perspective. The VFIO framework is designed to
"expose direct device access to userspace, in a secure, IOMMU
protected environment" (copied from vfio.txt, I am not familiar with
vfio). Without Interrupt Remapping, an spurious interrupt issued by
user space driver may crash other groups or the whole system entirely.
>From this point, I think it is reasonable to disable group without
Interrupt Remapping support in IOMMU, or at least give user a notice.

-cody

>
>> The trouble is that interrupt remapping closing a hole in DMA isolation
>> is a platform issue.  Is vfio supposed to know that on architecture foo
>> we don't have such a hole and we don't need to look for interrupt
>> remapping.  Or maybe that platform bar solved it differently and we need
>> to instead check flag MSI_OK.  Current KVM doesn't care about this
>> because it only does device assignment on x86.
>
> From device standpoint a MSI transaction is always a DMA memory write
> to a given address range. The IOMMU-API should export a feature flag
> whether it supports filtering on those transaction or not. We have that
> today with the IOMMU_CAP_INTR_REMAP. I agree that the interface to get
> this information is ugly because a domain is needed. But the interface
> can be fixed. While doing this I suggest to rename that feature
> IOMMU_CAP_INTR_ISOLATION or something like that.
> VFIO can then check for this flag on module-load and refuse to load if
> it is not available.
>
> Regards,
>
>        Joerg
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
