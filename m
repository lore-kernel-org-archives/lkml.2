Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1HYNYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:24:20 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:52597 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1HYNYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:24:16 -0400
Message-ID: <4E564CF9.5070209@linux.vnet.ibm.com>
Date: Thu, 25 Aug 2011 08:24:09 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: Broken pci_block_user_cfg_access interface
References: <4E54D5D7.8050807@siemens.com> <4E551298.2000302@linux.vnet.ibm.com> <4E5613BA.5070101@siemens.com> <20110825094031.GA3727@redhat.com> <4E5648EB.5030302@linux.vnet.ibm.com> <4E564A45.2040300@linux.vnet.ibm.com> <4E564B1D.2090201@siemens.com>
In-Reply-To: <4E564B1D.2090201@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 08:16 AM, Jan Kiszka wrote:
> On 2011-08-25 15:12, Brian King wrote:
>> On 08/25/2011 08:06 AM, Brian King wrote:
>>> On 08/25/2011 04:40 AM, Michael S. Tsirkin wrote:
>>>> On Thu, Aug 25, 2011 at 11:19:54AM +0200, Jan Kiszka wrote:
>>>>> On 2011-08-24 17:02, Brian King wrote:
>>>>>> On 08/24/2011 05:43 AM, Jan Kiszka wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> trying to port the generic device interrupt masking pattern of
>>>>>>> uio_pci_generic to KVM's device assignment code, I stumbled over some
>>>>>>> fundamental problem with the current pci_block/unblock_user_cfg_access
>>>>>>> interface: it does not provide any synchronization between blocking
>>>>>>> sides. This allows user space to trigger a kernel BUG, just run two
>>>>>>>
>>>>>>> while true; do echo 1 > /sys/bus/pci/devices/<some-device>/reset; done
>>>>>>>
>>>>>>> loops in parallel and watch the kernel oops.
>>>>>>>
>>>>>>> Instead of some funky open-coded locking mechanism, we would rather need
>>>>>>> a plain mutex across both the user space access (via sysfs) and the
>>>>>>> sections guarded by pci_block/unblock_user_cfg_access so far. But I'm
>>>>>>> not sure which of them already allow sleeping, specifically if the IPR
>>>>>>> driver would be fine with such a change. Can someone in the CC list
>>>>>>> comment on this?
>>>>>>
>>>>>> The ipr driver calls pci_block/unblock_user_cfg_access from interrupt
>>>>>> context, so a mutex won't work.
>>>>>
>>>>> Ugh. What precisely does it have to do with the config space while
>>>>> running inside an IRQ handler (or holding a lock that synchronizes it
>>>>> with such a handler)?
>>>>>
>>>>>> When the pci_block/unblock API was
>>>>>> originally added, it did not have the checking it has today to detect
>>>>>> if it is being called nested. This was added some time later. The
>>>>>
>>>>> For a reason...
>>>>>
>>>>>> API that works best for the ipr driver is to allow for many block calls,
>>>>>> but a single unblock call unblocks access. It seems like what might
>>>>>> work well in the case above is a block count. Each call to pci_block
>>>>>> increments a count. Each pci_unblock decrements the count and only
>>>>>> actually do the unblock if the count drops to zero. It should be reasonably
>>>>>> simple for ipr to use that sort of an API as well.
>>>>>
>>>>> That will just paper over the underlying bug: multiple kernel users (!=
>>>>> sysfs access) fiddle with the config space in an unsynchronized fashion.
>>>>> Think of sysfs-triggered pci_reset_function while your ipr driver does
>>>>> its accesses.
>>>>>
>>>>> So it's pointless to tweak the current pci_block semantics, we rather
>>>>> need to establish a new mechanism that synchronizes *all* users of the
>>>>> config space.
>>>>>
>>>>> Jan
>>>>
>>>> It does look like all of the problems are actually around reset.
>>>> So maybe all we need to do is synchronize the sysfs-triggered
>>>> pci_reset_function with pci_block/unblock_user_cfg_access?
>>>>
>>>> In other words, when reset is triggered from sysfs, it
>>>> should obey pci_block/unblock_user_cfg_access
>>>> restrictions?
>>>>
>>>> It does not look like reset needs to sleep, so fixing
>>>> that should not be hard, right?
>>>
>>> This sounds reasonable to me. Although I think we still have the driver issue
>>> I described in my previous mail. Perhaps the best way to resolve that would
>>> be to allow the adapter driver to register a reset function so that the
>>> driver could be the one driving the reset, allowing the driver to synchronize
>>> the reset with whatever else might be going on and also then reinitialize
>>> the adapter firmware, etc. If no driver was loaded or no driver specific
>>> reset function registered, the current reset mechanism would be invoked.
>>
>> This would also allow the driver to do unique types of resets for different
>> adapter types. Some of the adapters the ipr driver supports need to get
>> reset via BIST, others via PCIe warm reset, etc. 
> 
> Is this broken ATM? I thought the PCI core would simply try all methods
> + has a quirks section for completely funky devices.

Yes. Its certainly broken for ipr. If the ipr driver is loaded, it really needs
to be the one doing the reset. If its not loaded, I may need to add a few
quirks for these adapters to properly handle this function.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


