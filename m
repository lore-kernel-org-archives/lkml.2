Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2IUPLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:11:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65386 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab2IUPLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:11:50 -0400
MIME-Version: 1.0
In-Reply-To: <505C7687.1030001@redhat.com>
References: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com>
	<1346168638-32724-5-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQVAOEUHMSFHCpZLVK-Rbso3Rh1nUQHmfcujwb6tpUTz8A@mail.gmail.com>
	<CAErSpo58sSCPYF9Ug-o-f3odJovECkdxPOoahx9+Ob6kmP_srw@mail.gmail.com>
	<CAE9FiQWuVW6U9cE+iY0Gpua_0xhdxp6HxcWyhqqSN+L3Da_1Qg@mail.gmail.com>
	<CAErSpo5zeBVBowMyQS8QgAzrVbTJOb=Tuees9r1BnUZ3x13V0A@mail.gmail.com>
	<CAE9FiQXXB-qqWXc_pL-BVrboMzuvvPDPbEwK2To-taMg+NHu4A@mail.gmail.com>
	<505C7687.1030001@redhat.com>
Date: Fri, 21 Sep 2012 08:11:48 -0700
X-Google-Sender-Auth: FaZFcFiVNSj2wPxbkZ5q1TwIgb4
Message-ID: <CAE9FiQVALUUGFYBdU4NAsPq29ceS6B4oTmRad+FSLS1TeG2aKg@mail.gmail.com>
Subject: Re: [PATCH 4/5] PCI/IOV: simplify code by hotplug safe pci_get_domain_bus_and_slot()
From: Yinghai Lu <yinghai@kernel.org>
To: Don Dutile <ddutile@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 7:15 AM, Don Dutile <ddutile@redhat.com> wrote:
> On 09/21/2012 02:22 AM, Yinghai Lu wrote:
>>
>> On Thu, Sep 20, 2012 at 7:56 PM, Bjorn Helgaas<bhelgaas@google.com>
>> wrote:
>>>
>>> This is another thing I'm curious about.  How do you handle this
>>> situation today (before host bridge hot-add)?
>>>
>>> The DMAR I'm not so worried about because as far as I know, there's no
>>> such thing as a DMAR that's discovered by PCI enumeration.  We should
>>> discover it via ACPI, and that can happen before we enumerate anything
>>> behind a host bridge, so I don't really see any ordering problem
>>> between the DMAR and the PCI devices that would use it.
>>
>>
>> only need to have pci devices on that root bus scanned, and current intel
>> iommu
>> maintain one device scope to drhd with pointer to pci device... that
>> need to be fixed
>> too.
>>
> translation: you have an ACPI-DMAR setup bug?  a drhd can have multiple
> device
> scopes, one of which can be "all devices under bus X uses this IOMMU".
> If (dynamic) DMARs are scanned at root hot-plug time in ACPI hot-plug,
> the proper dmar-init should be completed before any PCI devs are scanned
> (and put into the proper iommu domain).

if you can check for-iommu branch,

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=shortlog;h=refs/heads/for-iommu
current implementation:

after root bus plugged in,
drivers/acpi/pci_root_hp.c::handle_root_bridge_insert() ==>
acpi_bus_add ==> drivers/acpi/pci_root.c::acpi_pci_root_add ==>
arch/x86/pci/acpi.c::pci_acpi_scan_root
so all pci devices get scanned.

later
handl_root_bridge_insert ==>acpi_bus_add ==>
drivers/acpi/pci_root.c::acpi_pci_root_start==>
pcibios_reserouce_survey_bus/pci_assign_unassigned_bus_resource
and call iommu acpi_pci_driver .add aka
drivers/iommu/dmar.c::acpi_pci_iommu_add ==> register_iommu ==>
handle_iommu_add ==> dmar_parse_dev ==> dmar_parse_dev_scope ==>
dmar_parse_one_dev_scope

that dmar_parse_one_dev_scope will find pci device pointer and put it
back into dmaru device pointer array.

in the boot path, it the same, dev_scope is parsed later after pci
devices get scanned.

We really should remove that cache array for device pointer...

-Yinghai
