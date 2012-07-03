Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab2GCTuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:50:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab2GCTuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:50:19 -0400
Message-ID: <4FF34CEF.3090400@redhat.com>
Date: Tue, 03 Jul 2012 15:50:07 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <jiang.liu@huawei.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: Re: [Resend with Ack][PATCH v1] PCI: allow acpiphp to handle PCIe
 ports without native PCIe hotplug capability
References: <1338795894-6292-1-git-send-email-jiang.liu@huawei.com> <CAErSpo7NiCsuM+UxveZbYxNsCiStMH5SLZ8EdFzJ7EduB306OQ@mail.gmail.com> <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
In-Reply-To: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 11:59 AM, Bjorn Helgaas wrote:
> On Mon, Jul 2, 2012 at 10:16 PM, Bjorn Helgaas<bhelgaas@google.com>  wrote:
>> On Mon, Jun 4, 2012 at 1:44 AM, Jiang Liu<jiang.liu@huawei.com>  wrote:
>>> Commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a (PCI / ACPI: Make acpiphp
>>> ignore root bridges using PCIe native hotplug) added code that made the
>>> acpiphp driver completely ignore PCIe root complexes for which the kernel
>>> had been granted control of the native PCIe hotplug feature by the BIOS
>>> through _OSC. Later commit 619a5182d1f38a3d629ee48e04fa182ef9170052
>>> "PCI hotplug: Always allow acpiphp to handle non-PCIe bridges" relaxed
>>> the constraints to allow acpiphp driver handle non-PCIe bridges under
>>> such a complex. The constraint needs to be relaxed further to allow
>>> acpiphp driver to hanlde PCIe ports without native PCIe hotplug capability.
>>>
>>> Some MR-IOV switch chipsets, such PLX8696, support multiple virtual PCIe
>>> switches and may migrate downstream ports among virtual switches.
>>> To migrate a downstream port from the source virtual switch to the target,
>>> the port needs to be hot-removed from the source and hot-added into the
>>> target. pciehp driver can't be used here because there's no slots within
>>> the virtual PCIe switch. So acpiphp driver is used to support downstream
>>> port migration. A typical configuration is as below:
>>> [Root w/o native PCIe HP]
>>>          [Upstream port of vswitch w/o native PCIe HP]
>>>                  [Downstream port of vswitch w/ native PCIe HP]
>>>                          [PCIe enpoint]
>>>
>>> Here acpiphp driver will be used to handle root ports and upstream port
>>> in the virtual switch, and pciehp driver will be used to handle downstream
>>> ports in the virtual switch.
>>>
>>> Acked-by: Rafael J. Wysocki<rjw@sisk.pl>
>>> Signed-off-by: Jiang Liu<liuj97@gmail.com>
>>>
>>> ---
>>>   drivers/pci/hotplug/acpiphp_glue.c |   49 ++++++++++++++++++++++++++++-------
>>>   1 files changed, 39 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
>>> index 806c44f..4889448 100644
>>> --- a/drivers/pci/hotplug/acpiphp_glue.c
>>> +++ b/drivers/pci/hotplug/acpiphp_glue.c
>>> @@ -115,6 +115,43 @@ static const struct acpi_dock_ops acpiphp_dock_ops = {
>>>          .handler = handle_hotplug_event_func,
>>>   };
>>>
>>> +/* Check whether device is managed by native PCIe hotplug driver */
>>> +static bool device_is_managed_by_native_pciehp(struct pci_dev *pdev)
>>> +{
>>> +       int pos;
>>> +       u16 reg16;
>>> +       u32 reg32;
>>> +       acpi_handle tmp;
>>> +       struct acpi_pci_root *root;
>>> +
>>> +       if (!pci_is_pcie(pdev))
>>> +               return false;
>>> +
>>> +       /* Check whether PCIe port supports native PCIe hotplug */
>>> +       pos = pci_pcie_cap(pdev);
>>
>> Add "if (!pos) return false;" here and you can drop the "if
>> (!pci_is_pcie())" test above.
>>
>>> +       pci_read_config_word(pdev, pos + PCI_EXP_FLAGS,&reg16);
>>> +       if (!(reg16&  PCI_EXP_FLAGS_SLOT))
>>
>> I think this is unsafe.  Per the PCIe v3.0 spec, sec 7.8.2 on p648,
>> the "Slot Implemented" bit is undefined except for Downstream Ports,
>> so we're using an undefined bit to decide whether to read
>> PCI_EXP_SLTCAP.
>>
>> If the device has a v1 PCIe Capability, it is not required to even
>> implement PCI_EXP_SLTCAP, so we could be reading garbage out of an
>> unrelated capability.  This is in sec 7.8, p363, of the v1.1 PCIe
>> spec.  I think v3.0 of the spec is dangerously incomplete because it
>> doesn't include enough information to handle the v1 PCIe Capability
>> correctly.
>>
>> There's a fair amount of work to fix this.  I started doing it, but
>> decided I didn't have time to complete it.  Here's what I think we
>> (and by "we," I'm afraid I mean "you" :)) should do:
>>
>>    - Add a "u16 pcie_flags" field in struct pci_dev and save the "PCI
>> Express Capabilities Register" there in set_pcie_port_type().  All
>> fields in that register are read-only, so it should be safe to cache
>> it.
>>    - Remove pcie_type from struct pci_dev and replace it with a
>> pcie_type() inline that extracts it from pcie_flags.
>>    - Rework the pcie_cap_has_*() macros in drivers/pci/pci.c to take a
>> struct pci_dev * and use pcie_flags instead of type and flags.  This
>> will remove the need for callers to read the flags themselves.
>>    - Move the pcie_cap_has_*() macros to include/linux/pci_reg.h so
>> they can be shared.
>>    - Audit all uses of the Link registers (PCI_EXP_LNKCAP,
>> PCI_EXP_LNKCTL, PCI_EXP_LNKSTA), Slot registers (PCI_EXP_SLTCAP,
>> PCI_EXP_SLTCTL, PCI_EXP_SLTSTA), and Root registers (PCI_EXP_RTCAP,
>> PCI_EXP_RTCTL, PCI_EXP_RTSTA) to make sure the register exists, either
>> by using pcie_cap_has_*() or some other knowledge of the device.
>
> Thinking about this some more, this still leaves the callers
> responsible for using pcie_cap_has_*(), which feels pretty
> error-prone.
>
> I wonder if it'd be worth adding interfaces like:
>
>    pcie_cap_read_word(const struct pci_dev *, int where, u16 *val);
>    pcie_cap_read_dword(const struct pci_dev *, int where, u32 *val);
>    pcie_cap_write_word(const struct pci_dev *, int where, u16 val);
>    pcie_cap_write_dword(const struct pci_dev *, int where, u32 val);
>

I like your thinking!

> We might be able to encapsulate the v1/v2 differences inside these, e.g.,
>
>    int pcie_cap_read_word(const struct pci_dev *dev, int where, u16 *val)
>    {
>        int pos;
>
>        pos = pci_pcie_cap(dev);
>        if (!pos)
>            return -EINVAL;
>
may want to change read value to 0 just in case callers are doing rtn value
check and just value-read mask & go.  I believe for all the optional/version'd
registers below, non-existent regs are required to be rtn-zero if not implemented.

>        switch (where) {
>        case PCI_EXP_FLAGS:
>        case PCI_EXP_DEVCTL:
>        case PCI_EXP_DEVSTA:
>            return pci_read_config_word(dev, pos + where, val);
>        case PCI_EXP_LNKCTL:
>        case PCI_EXP_LNKSTA:
>            if (pcie_cap_has_lnkctl(dev))
>                return pci_read_config_word(dev, pos + where, val);
>            else {
>                *val = 0;
>                return 0;
>            }
>        case PCI_EXP_SLTCTL:
>        case PCI_EXP_SLTSTA:
>            if (pcie_cap_has_sltctl(dev))
>                return pci_read_config_word(dev, pos + where, val);
>            else {
>                *val = 0;
>                if (where == PCI_EXP_SLTSTA&&  dev->pcie_type ==
> PCI_EXP_TYPE_DOWNSTREAM)
>                    *val = PCI_EXP_SLTSTA_PDS;
>                return 0;
>        ...
>        };
>        return -EINVAL;
>    }
>
> Any thoughts?

only one is that 'cap' is overused in PCI space, just like 'domain' in
various kernel subsystems.  cap could be 'cap list structure'
or a specific 'capability'.  I wish we had a better TLA for 'cap' and what
it refers to. ... but that's my pet peeve...

> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

