Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2KMQDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:03:09 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57480 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab2KMQDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:03:06 -0500
Message-ID: <50A26F27.3070806@gmail.com>
Date: Wed, 14 Nov 2012 00:02:47 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [RFC PATCH 1/6] driver core: add a bus notification to temporarily
 reject driver binding
References: <1352555839-18961-1-git-send-email-jiang.liu@huawei.com> <20121111052152.GA5795@kroah.com>
In-Reply-To: <20121111052152.GA5795@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 01:21 PM, Greg Kroah-Hartman wrote:
> On Sat, Nov 10, 2012 at 09:57:14PM +0800, Jiang Liu wrote:
>>  From: Jiang Liu <jiang.liu@huawei.com>
>>
>> There are several requirements to temporarily reject device driver
>> binding. Possible usage cases as below:
>> 1) We should avoid binding an unsafe driver to a device belonging to
>>    an active VFIO group, otherwise it will break the DMA isolation
>>    property of VFIO.
>> 2) When hot-removing a PCI hierachy, we should avoid binding device
>>    drivers to PCI devices going to be removed during the window
>>    between unbinding of device driver and destroying of device nodes.
>> 3) When hot-adding a PCI host bridge, we should temporarily disable
>>    driver binding before setting up corresponding IOMMU and IOAPIC.
>>
>> We may add a flag into struct device to temporarily disable driver
>> binding as in this thread https://patchwork.kernel.org/patch/1535721/.
> 
> I totally do not understand.  The bus controls this, if it does not want
> to bind a device to a driver, then don't do it.  It's really quite
> simple to just block the probe callback the bus gets, right?  Why create
> all of this extra, and confusing, interface instead?
Hi Greg,
	Thanks for your comments. 
	As you know, we already have an "drivers_autoprobe" flag for drivers,
we are trying to provide a similar mechanism for devices.
	But I'm not sure whether we could block the probe callback. For PCI
host bridge hotplug, that will effectively block the PCI host bridge hotplug
thread. For VFIO case, its goal is to reject binding unsafe drivers to PCI
devices belonging to active VFIO group, so it doesn't make sense to block
the driver probing thread too. So we are trying to return error code instead
of blocking in really_probe().
	Thanks!
	Gerry

> 
>> This patch proposes another solution to temporarily disable driver
>> binding by using bus notification mechanisms. It adds an notification
>> event to solicit if anybody has objections when binding a driver to a
>> device.
> 
> Sorry, but no, don't do this, it's way more confusing.
> 
> greg k-h
> 

