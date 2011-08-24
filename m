Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab1HXPDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:03:17 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54008 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160Ab1HXPDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:03:14 -0400
Message-ID: <4E551298.2000302@linux.vnet.ibm.com>
Date: Wed, 24 Aug 2011 10:02:48 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: Broken pci_block_user_cfg_access interface
References: <4E54D5D7.8050807@siemens.com>
In-Reply-To: <4E54D5D7.8050807@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 05:43 AM, Jan Kiszka wrote:
> Hi,
> 
> trying to port the generic device interrupt masking pattern of
> uio_pci_generic to KVM's device assignment code, I stumbled over some
> fundamental problem with the current pci_block/unblock_user_cfg_access
> interface: it does not provide any synchronization between blocking
> sides. This allows user space to trigger a kernel BUG, just run two
> 
> while true; do echo 1 > /sys/bus/pci/devices/<some-device>/reset; done
> 
> loops in parallel and watch the kernel oops.
> 
> Instead of some funky open-coded locking mechanism, we would rather need
> a plain mutex across both the user space access (via sysfs) and the
> sections guarded by pci_block/unblock_user_cfg_access so far. But I'm
> not sure which of them already allow sleeping, specifically if the IPR
> driver would be fine with such a change. Can someone in the CC list
> comment on this?

The ipr driver calls pci_block/unblock_user_cfg_access from interrupt
context, so a mutex won't work. When the pci_block/unblock API was
originally added, it did not have the checking it has today to detect
if it is being called nested. This was added some time later. The
API that works best for the ipr driver is to allow for many block calls,
but a single unblock call unblocks access. It seems like what might
work well in the case above is a block count. Each call to pci_block
increments a count. Each pci_unblock decrements the count and only
actually do the unblock if the count drops to zero. It should be reasonably
simple for ipr to use that sort of an API as well.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


