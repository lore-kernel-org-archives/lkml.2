Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1HYNG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 09:06:28 -0400
Received: from thoth.sbs.de ([192.35.17.2]:28350 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab1HYNGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 09:06:25 -0400
Message-ID: <4E5648B9.7050106@siemens.com>
Date: Thu, 25 Aug 2011 15:06:01 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Brian King <brking@linux.vnet.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: Broken pci_block_user_cfg_access interface
References: <4E54D5D7.8050807@siemens.com> <4E551298.2000302@linux.vnet.ibm.com> <4E5613BA.5070101@siemens.com> <4E5647DA.1060901@linux.vnet.ibm.com>
In-Reply-To: <4E5647DA.1060901@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-25 15:02, Brian King wrote:
> On 08/25/2011 04:19 AM, Jan Kiszka wrote:
>> On 2011-08-24 17:02, Brian King wrote:
>>> On 08/24/2011 05:43 AM, Jan Kiszka wrote:
>>>> Hi,
>>>>
>>>> trying to port the generic device interrupt masking pattern of
>>>> uio_pci_generic to KVM's device assignment code, I stumbled over some
>>>> fundamental problem with the current pci_block/unblock_user_cfg_access
>>>> interface: it does not provide any synchronization between blocking
>>>> sides. This allows user space to trigger a kernel BUG, just run two
>>>>
>>>> while true; do echo 1 > /sys/bus/pci/devices/<some-device>/reset; done
>>>>
>>>> loops in parallel and watch the kernel oops.
>>>>
>>>> Instead of some funky open-coded locking mechanism, we would rather need
>>>> a plain mutex across both the user space access (via sysfs) and the
>>>> sections guarded by pci_block/unblock_user_cfg_access so far. But I'm
>>>> not sure which of them already allow sleeping, specifically if the IPR
>>>> driver would be fine with such a change. Can someone in the CC list
>>>> comment on this?
>>>
>>> The ipr driver calls pci_block/unblock_user_cfg_access from interrupt
>>> context, so a mutex won't work.
>>
>> Ugh. What precisely does it have to do with the config space while
>> running inside an IRQ handler (or holding a lock that synchronizes it
>> with such a handler)?
> 
> The ipr driver can get an error interrupt which will trigger the driver
> to reset the adapter. While the adapter is going through reset we need
> to ensure user config accesses are blocked, since many ipr adapters
> won't respond on the PCI bus during this time.

What about offloading the reset to thread context (workqueue etc.)?

> 
> 
>>> API that works best for the ipr driver is to allow for many block calls,
>>> but a single unblock call unblocks access. It seems like what might
>>> work well in the case above is a block count. Each call to pci_block
>>> increments a count. Each pci_unblock decrements the count and only
>>> actually do the unblock if the count drops to zero. It should be reasonably
>>> simple for ipr to use that sort of an API as well.
>>
>> That will just paper over the underlying bug: multiple kernel users (!=
>> sysfs access) fiddle with the config space in an unsynchronized fashion.
>> Think of sysfs-triggered pci_reset_function while your ipr driver does
>> its accesses.
> 
> I took a look at the sysfs triggered pci reset function and don't see any way
> that the controlling device driver ever gets to be involved in this reset.
> If code outside the ipr driver were to reset the adapter, the adapter firmware
> would be left in an uninitialized state and until scsi core starts timing
> out ops and driving EH, the card would be unusable. I can't imagine the
> ipr driver is unique in this.

Right, that's why a PCI core service is needed for coordination.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
