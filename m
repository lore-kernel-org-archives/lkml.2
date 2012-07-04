Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2GDSHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 14:07:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48032 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2GDSHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 14:07:34 -0400
MIME-Version: 1.0
In-Reply-To: <4FF34CEF.3090400@redhat.com>
References: <1338795894-6292-1-git-send-email-jiang.liu@huawei.com>
 <CAErSpo7NiCsuM+UxveZbYxNsCiStMH5SLZ8EdFzJ7EduB306OQ@mail.gmail.com>
 <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com> <4FF34CEF.3090400@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 4 Jul 2012 12:07:11 -0600
Message-ID: <CAErSpo7=BzPX87qgKS_xkJg4o8BGDan-o7D9NqRiqKvH0kLjfQ@mail.gmail.com>
Subject: Re: [Resend with Ack][PATCH v1] PCI: allow acpiphp to handle PCIe
 ports without native PCIe hotplug capability
To: Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 1:50 PM, Don Dutile <ddutile@redhat.com> wrote:
> On 07/03/2012 11:59 AM, Bjorn Helgaas wrote:
>>
>> On Mon, Jul 2, 2012 at 10:16 PM, Bjorn Helgaas<bhelgaas@google.com>
>> wrote:
>>>
>>> On Mon, Jun 4, 2012 at 1:44 AM, Jiang Liu<jiang.liu@huawei.com>  wrote:
>>>>
>>>> Commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a (PCI / ACPI: Make
>>>> acpiphp
>>>> ignore root bridges using PCIe native hotplug) added code that made the
>>>> acpiphp driver completely ignore PCIe root complexes for which the
>>>> kernel
>>>> had been granted control of the native PCIe hotplug feature by the BIOS
>>>> through _OSC. Later commit 619a5182d1f38a3d629ee48e04fa182ef9170052
>>>> "PCI hotplug: Always allow acpiphp to handle non-PCIe bridges" relaxed
>>>> the constraints to allow acpiphp driver handle non-PCIe bridges under
>>>> such a complex. The constraint needs to be relaxed further to allow
>>>> acpiphp driver to hanlde PCIe ports without native PCIe hotplug
>>>> capability.
>>>>
>>>> Some MR-IOV switch chipsets, such PLX8696, support multiple virtual PCIe
>>>> switches and may migrate downstream ports among virtual switches.
>>>> To migrate a downstream port from the source virtual switch to the
>>>> target,
>>>> the port needs to be hot-removed from the source and hot-added into the
>>>> target. pciehp driver can't be used here because there's no slots within
>>>> the virtual PCIe switch. So acpiphp driver is used to support downstream
>>>> port migration. A typical configuration is as below:
>>>> [Root w/o native PCIe HP]
>>>>          [Upstream port of vswitch w/o native PCIe HP]
>>>>                  [Downstream port of vswitch w/ native PCIe HP]
>>>>                          [PCIe enpoint]
>>>>
>>>> Here acpiphp driver will be used to handle root ports and upstream port
>>>> in the virtual switch, and pciehp driver will be used to handle
>>>> downstream
>>>> ports in the virtual switch.
>>>>
>>>> Acked-by: Rafael J. Wysocki<rjw@sisk.pl>
>>>> Signed-off-by: Jiang Liu<liuj97@gmail.com>
>>>>
>>>> ---
>>>>   drivers/pci/hotplug/acpiphp_glue.c |   49
>>>> ++++++++++++++++++++++++++++-------
>>>>   1 files changed, 39 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/drivers/pci/hotplug/acpiphp_glue.c
>>>> b/drivers/pci/hotplug/acpiphp_glue.c
>>>> index 806c44f..4889448 100644
>>>> --- a/drivers/pci/hotplug/acpiphp_glue.c
>>>> +++ b/drivers/pci/hotplug/acpiphp_glue.c
>>>> @@ -115,6 +115,43 @@ static const struct acpi_dock_ops acpiphp_dock_ops
>>>> = {
>>>>          .handler = handle_hotplug_event_func,
>>>>   };
>>>>
>>>> +/* Check whether device is managed by native PCIe hotplug driver */
>>>> +static bool device_is_managed_by_native_pciehp(struct pci_dev *pdev)
>>>> +{
>>>> +       int pos;
>>>> +       u16 reg16;
>>>> +       u32 reg32;
>>>> +       acpi_handle tmp;
>>>> +       struct acpi_pci_root *root;
>>>> +
>>>> +       if (!pci_is_pcie(pdev))
>>>> +               return false;
>>>> +
>>>> +       /* Check whether PCIe port supports native PCIe hotplug */
>>>> +       pos = pci_pcie_cap(pdev);
>>>
>>>
>>> Add "if (!pos) return false;" here and you can drop the "if
>>> (!pci_is_pcie())" test above.
>>>
>>>> +       pci_read_config_word(pdev, pos + PCI_EXP_FLAGS,&reg16);
>>>> +       if (!(reg16&  PCI_EXP_FLAGS_SLOT))
>>>
>>>
>>> I think this is unsafe.  Per the PCIe v3.0 spec, sec 7.8.2 on p648,
>>> the "Slot Implemented" bit is undefined except for Downstream Ports,
>>> so we're using an undefined bit to decide whether to read
>>> PCI_EXP_SLTCAP.
>>>
>>> If the device has a v1 PCIe Capability, it is not required to even
>>> implement PCI_EXP_SLTCAP, so we could be reading garbage out of an
>>> unrelated capability.  This is in sec 7.8, p363, of the v1.1 PCIe
>>> spec.  I think v3.0 of the spec is dangerously incomplete because it
>>> doesn't include enough information to handle the v1 PCIe Capability
>>> correctly.
>>>
>>> There's a fair amount of work to fix this.  I started doing it, but
>>> decided I didn't have time to complete it.  Here's what I think we
>>> (and by "we," I'm afraid I mean "you" :)) should do:
>>>
>>>    - Add a "u16 pcie_flags" field in struct pci_dev and save the "PCI
>>> Express Capabilities Register" there in set_pcie_port_type().  All
>>> fields in that register are read-only, so it should be safe to cache
>>> it.
>>>    - Remove pcie_type from struct pci_dev and replace it with a
>>> pcie_type() inline that extracts it from pcie_flags.
>>>    - Rework the pcie_cap_has_*() macros in drivers/pci/pci.c to take a
>>> struct pci_dev * and use pcie_flags instead of type and flags.  This
>>> will remove the need for callers to read the flags themselves.
>>>    - Move the pcie_cap_has_*() macros to include/linux/pci_reg.h so
>>> they can be shared.
>>>    - Audit all uses of the Link registers (PCI_EXP_LNKCAP,
>>> PCI_EXP_LNKCTL, PCI_EXP_LNKSTA), Slot registers (PCI_EXP_SLTCAP,
>>> PCI_EXP_SLTCTL, PCI_EXP_SLTSTA), and Root registers (PCI_EXP_RTCAP,
>>> PCI_EXP_RTCTL, PCI_EXP_RTSTA) to make sure the register exists, either
>>> by using pcie_cap_has_*() or some other knowledge of the device.
>>
>>
>> Thinking about this some more, this still leaves the callers
>> responsible for using pcie_cap_has_*(), which feels pretty
>> error-prone.
>>
>> I wonder if it'd be worth adding interfaces like:
>>
>>    pcie_cap_read_word(const struct pci_dev *, int where, u16 *val);
>>    pcie_cap_read_dword(const struct pci_dev *, int where, u32 *val);
>>    pcie_cap_write_word(const struct pci_dev *, int where, u16 val);
>>    pcie_cap_write_dword(const struct pci_dev *, int where, u32 val);
>>
>
> I like your thinking!
>
>
>> We might be able to encapsulate the v1/v2 differences inside these, e.g.,
>>
>>    int pcie_cap_read_word(const struct pci_dev *dev, int where, u16 *val)
>>    {
>>        int pos;
>>
>>        pos = pci_pcie_cap(dev);
>>        if (!pos)
>>            return -EINVAL;
>>
> may want to change read value to 0 just in case callers are doing rtn value
> check and just value-read mask & go.  I believe for all the
> optional/version'd
> registers below, non-existent regs are required to be rtn-zero if not
> implemented.

Generally I prefer that if a function returns failure, it doesn't
modify the parameters passed by reference, but in this case, I think
you're right that we should set *val to zero to begin with.  It will
simplify the following code somewhat, too.

Note that most non-implemented registers should read as zero, but Slot
Status of Downstream Ports is an exception (spec v3.0, sec 7.8, line
25).

>>        switch (where) {
>>        case PCI_EXP_FLAGS:
>>        case PCI_EXP_DEVCTL:
>>        case PCI_EXP_DEVSTA:
>>            return pci_read_config_word(dev, pos + where, val);
>>        case PCI_EXP_LNKCTL:
>>        case PCI_EXP_LNKSTA:
>>            if (pcie_cap_has_lnkctl(dev))
>>                return pci_read_config_word(dev, pos + where, val);
>>            else {
>>                *val = 0;
>>                return 0;
>>            }
>>        case PCI_EXP_SLTCTL:
>>        case PCI_EXP_SLTSTA:
>>            if (pcie_cap_has_sltctl(dev))
>>                return pci_read_config_word(dev, pos + where, val);
>>            else {
>>                *val = 0;
>>                if (where == PCI_EXP_SLTSTA&&  dev->pcie_type ==
>>
>> PCI_EXP_TYPE_DOWNSTREAM)
>>                    *val = PCI_EXP_SLTSTA_PDS;
>>                return 0;
>>        ...
>>        };
>>        return -EINVAL;
>>    }
>>
>> Any thoughts?
>
>
> only one is that 'cap' is overused in PCI space, just like 'domain' in
> various kernel subsystems.  cap could be 'cap list structure'
> or a specific 'capability'.  I wish we had a better TLA for 'cap' and what
> it refers to. ... but that's my pet peeve...

I agree, 'cap' is overused and confusing.  Even "PCI Express
Capability Structure" as used in the spec seems slightly confusing to
me.  The existing pci_find_capability() interfaces spell out 'cap';
maybe we should, too.  Here are some possibilities, starting with my
current favorite:

  pci_pcie_capability_read_word()
  pci_pcie_cap_read_word()  (extension of existing pci_pcie_cap() idea)
  pci_express_cap_read_word()
