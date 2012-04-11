Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab2DKWXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 18:23:03 -0400
Received: from masquerade.micron.com ([137.201.242.130]:41481 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761367Ab2DKWXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 18:23:01 -0400
Message-ID: <4F860440.60808@micron.com>
Date: Wed, 11 Apr 2012 15:22:56 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Jens Axboe <axboe@kernel.dk>, Sam Bradshaw <sbradshaw@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: mtip32xx: remove HOTPLUG_PCI_PCIE dependancy
References: <20120411183457.GA19379@kroah.com> <4F85E217.8060406@kernel.dk> <4F85EAA3.7010807@micron.com> <20120411204041.GA14375@kroah.com>
In-Reply-To: <20120411204041.GA14375@kroah.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8BIT
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No--10.254100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/2012 1:40 PM, Greg KH wrote:

> On Wed, Apr 11, 2012 at 01:33:39PM -0700, Asai Thambi S P wrote:
>> On 4/11/2012 12:57 PM, Jens Axboe wrote:
>>
>>> On 2012-04-11 20:34, Greg KH wrote:
>>>> This removes the HOTPLUG_PCI_PCIE dependency on the driver and makes it
>>>> depend on PCI.
>>>
>>> I think it's an old dependency. I've built and run it here without as
>>> well, and no functional issues either.
>>>
>>> Sam/Asai?
>>>
>>
>>
>> Both driver and device will work fine without PCIe hotplug dependency. This
>> dependency is required for supporting surprise removal and surprise insertion
>> of the device on systems with PCIe hotplug controller.
> 
> But that's not a driver-specific thing at all.  All PCI drivers need to
> be able to handle this (I like how you constantly check the pci id,
> that's cute.)
> 
> So I think a basic dependancy on PCI should be fine here.

The P320 is different from existing PCIe devices supporting surprise removal
and surprise insertion (SRSI) capability (aka hotplug). We equate the hotplug
functionality enabled by PCIe hotplug controllers to that of any other storage
endpoint (SAS, SATA, FC, etc). For those devices, hotplug functionality is
enabled by the transport layer and propagated up to host storage stack for
handling.

There are two types of users for P320 device – 1) those with systems that have
PCIe hotplug controllers and intend to use hotplug and 2) those who do not
need or intend to use hotplug. The HOTPLUG_PCI_PCIE dependency enables users
in the first bucket to use the device’s capability without affecting those in
the second bucket.  While there aren’t many systems today that have PCIe
hotplug controllers, you will begin to see such systems very soon.

The mtip32xx driver depends on remove() being called for graceful handling of
surprise removal events.  Such cleanup is necessary to enable clean surprise
insertion of the same/different device in the same slot. We do check the PCI
id in non-fast path code to detect the surprise removal and fail any
outstanding I/Os with -ENODEV, but the driver still depends on the pci core
with help from the pcie hotplug module to call remove() for cleanup, hence the
HOTPLUG_PCI_PCIE dependency.

--
Regards,
Asai Thambi
