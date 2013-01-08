Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3AHR51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:57:27 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:65182 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab3AHR5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:57:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5Z57asEXbfesOjXMEPj4WM3YMbzQH3s-v_NBrnPNmuVQ@mail.gmail.com>
References: <20121030040237.GA10472@google.com> <1352003971-22278-1-git-send-email-yinghai@kernel.org>
 <CAE9FiQUn=bcgOLFzBwsBT1-O1poRNy9qYTb0w9EAya3_inKqAw@mail.gmail.com> <CAErSpo5Z57asEXbfesOjXMEPj4WM3YMbzQH3s-v_NBrnPNmuVQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 8 Jan 2013 10:57:03 -0700
Message-ID: <CAErSpo4LS7ShCbeOm1s9ob1MjPfUSWn9J96UHRBP6van54swQA@mail.gmail.com>
Subject: Re: [PATCH 0/8] PCI, ACPI, x86: Reserve fw allocated resource for
 hot-add root bus
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 4:49 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc David, Michal, Koichi, Ben, Paul]
>
> On Fri, Dec 7, 2012 at 12:15 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Sat, Nov 3, 2012 at 9:39 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> For root bus hot add, fw could assign some resource for the devices for
>>> that root bus before notifying os via acpi, we should check and use those
>>> resources at first just like we do for booting path.
>>>
>>> At first, we need to refactor x86 pci pcibios_allocate related functions
>>> for booting path to take bus as parameter.
>>>
>>> After that, we could use the survey function for hot add root bus.
>>>
>>> based on pci/yinghai-for-pci-root-bus-hotplug
>>>
>>> could get from
>>>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-survey-resources
>>>
>>> Yinghai Lu (8):
>>>   PCI, x86: Separate out pcibios_allocate_bridge_resources()
>>>   PCI, x86: Separate out pcibios_allocate_dev_resources()
>>>   PCI, x86: Let pcibios_allocate_bus_resources() take bus instead
>>>   PCI, x86: Separate out rom resource claim
>>>   PCI, x86: Add pcibios_fw_addr_done
>>>   PCI, x86: Remove __init for hw/fw allocated functions
>>>   PCI, x86: Claim FW allocated resources in hot add path.
>>>   PCI, ACPI: reserve fw allocated resource for hot added root bus
>>>
>>>  arch/x86/pci/i386.c     |  185 +++++++++++++++++++++++++++++++----------------
>>>  drivers/acpi/pci_root.c |    4 +-
>>>  drivers/pci/bus.c       |    2 +
>>>  include/linux/pci.h     |    1 +
>>>  4 files changed, 127 insertions(+), 65 deletions(-)
>>>
>>
>> Bjorn,
>>
>> Can you queue those 8 patches for v3.9 in pci tree?
>>
>> So I  could resend out other pci root hotplug patches.
>
> I'm really sorry that it's taken me so long to get to these.
>
> I applied these to my pci/yinghai-survey-resources branch.  I
> re-ordered the last two and reworked some of the changelogs.

To be clear about this, the pci/yinghai-survey-resources branch I
mentioned is a staging branch that just gets build test coverage.  I
don't plan to actually merge this or put it into -next until the
questions below are resolved.

My inclination, until I'm persuaded otherwise, is to wait for patches
that preserve the similarities among these architectures.

> In general these look good.  My main concern is that they only touch
> x86, without touching the similar code in frv, microblaze, mn10300,
> and powerpc.
>
> This code (pcibios_resource_survey(), pcibios_assign_resources(),
> pcibios_allocate_resources(), pcibios_allocate_bus_resources()) was
> obviously copied from x86 originally, and I'd like to preserve the
> similarity between them.  It would be even better to refactor it so
> it's actually *shared*, but I don't think that's a requirement right
> now.
>
> If we allow it to diverge now, it will make it harder to refactor and
> harder to notice when bug fixes should be applied to all of them.  For
> example, looking at pcibios_allocate_resources(), commit 575939cf5
> added some SR-IOV support to x86.  Should similar code be added for
> frv, microblaze, mn10300, and powerpc?
>
> Anybody else have thoughts on this?
>
> Bjorn
