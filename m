Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3AGXuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:50:08 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:44323 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3AGXuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:50:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUn=bcgOLFzBwsBT1-O1poRNy9qYTb0w9EAya3_inKqAw@mail.gmail.com>
References: <20121030040237.GA10472@google.com> <1352003971-22278-1-git-send-email-yinghai@kernel.org>
 <CAE9FiQUn=bcgOLFzBwsBT1-O1poRNy9qYTb0w9EAya3_inKqAw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 7 Jan 2013 16:49:41 -0700
Message-ID: <CAErSpo5Z57asEXbfesOjXMEPj4WM3YMbzQH3s-v_NBrnPNmuVQ@mail.gmail.com>
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

[+cc David, Michal, Koichi, Ben, Paul]

On Fri, Dec 7, 2012 at 12:15 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sat, Nov 3, 2012 at 9:39 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> For root bus hot add, fw could assign some resource for the devices for
>> that root bus before notifying os via acpi, we should check and use those
>> resources at first just like we do for booting path.
>>
>> At first, we need to refactor x86 pci pcibios_allocate related functions
>> for booting path to take bus as parameter.
>>
>> After that, we could use the survey function for hot add root bus.
>>
>> based on pci/yinghai-for-pci-root-bus-hotplug
>>
>> could get from
>>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-survey-resources
>>
>> Yinghai Lu (8):
>>   PCI, x86: Separate out pcibios_allocate_bridge_resources()
>>   PCI, x86: Separate out pcibios_allocate_dev_resources()
>>   PCI, x86: Let pcibios_allocate_bus_resources() take bus instead
>>   PCI, x86: Separate out rom resource claim
>>   PCI, x86: Add pcibios_fw_addr_done
>>   PCI, x86: Remove __init for hw/fw allocated functions
>>   PCI, x86: Claim FW allocated resources in hot add path.
>>   PCI, ACPI: reserve fw allocated resource for hot added root bus
>>
>>  arch/x86/pci/i386.c     |  185 +++++++++++++++++++++++++++++++----------------
>>  drivers/acpi/pci_root.c |    4 +-
>>  drivers/pci/bus.c       |    2 +
>>  include/linux/pci.h     |    1 +
>>  4 files changed, 127 insertions(+), 65 deletions(-)
>>
>
> Bjorn,
>
> Can you queue those 8 patches for v3.9 in pci tree?
>
> So I  could resend out other pci root hotplug patches.

I'm really sorry that it's taken me so long to get to these.

I applied these to my pci/yinghai-survey-resources branch.  I
re-ordered the last two and reworked some of the changelogs.

In general these look good.  My main concern is that they only touch
x86, without touching the similar code in frv, microblaze, mn10300,
and powerpc.

This code (pcibios_resource_survey(), pcibios_assign_resources(),
pcibios_allocate_resources(), pcibios_allocate_bus_resources()) was
obviously copied from x86 originally, and I'd like to preserve the
similarity between them.  It would be even better to refactor it so
it's actually *shared*, but I don't think that's a requirement right
now.

If we allow it to diverge now, it will make it harder to refactor and
harder to notice when bug fixes should be applied to all of them.  For
example, looking at pcibios_allocate_resources(), commit 575939cf5
added some SR-IOV support to x86.  Should similar code be added for
frv, microblaze, mn10300, and powerpc?

Anybody else have thoughts on this?

Bjorn
