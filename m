Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2HWBwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 21:52:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2HWBwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 21:52:19 -0400
Message-ID: <50358CA4.40008@redhat.com>
Date: Wed, 22 Aug 2012 21:51:32 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111104 Red Hat/3.1.16-2.el6_1 Thunderbird/3.1.16
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "Cui, Dexuan" <dexuan.cui@intel.com>, Jiang Liu <liuj97@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v3 00/32] provide interfaces to access PCIe capabilities
 registers
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com> <CAErSpo7WoEeWayMQ__H4jiKKmMdNgyLMYdRmJ0Nf0LoEKjFRmA@mail.gmail.com> <50325732.3000700@gmail.com> <CAErSpo4-SGH__kE5tPNzz+VO=V-GKOMdcKCqqy6s3=5sNKgG0w@mail.gmail.com> <50325C18.9030207@gmail.com> <CAErSpo6t9m0xmWkXfmONtbicjqLR_z5dLsjKCLWQfcktzRKkUA@mail.gmail.com> <CAErSpo5=OUM9veX8890USWegTG_Fhh10soxPJbjemd80bAO0qg@mail.gmail.com> <A25F549E4D43CD42B4C02DF47A1913230FE50780@SHSMSX102.ccr.corp.intel.com> <CAErSpo5ftvKLF2=1ixzp1KroNLKh_s-b5hi9aFv3X7PpqisGwg@mail.gmail.com>
In-Reply-To: <CAErSpo5ftvKLF2=1ixzp1KroNLKh_s-b5hi9aFv3X7PpqisGwg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 12:28 PM, Bjorn Helgaas wrote:
> On Mon, Aug 20, 2012 at 9:40 PM, Cui, Dexuan<dexuan.cui@intel.com>  wrote:
>> Bjorn Helgaas wrote on 2012-08-21:
>
>>> I am still concerned about reset_intel_82599_sfp_virtfn().  It looks
>>> wrong and possibly unnecessary.  It looks wrong because it sets
>>> PCI_EXP_DEVCTL_BCR_FLR and blindly clears all other bits in
>>> PCI_EXP_DEVCTL.  Most of the bits are probably cleared by the FLR
>>> anyway, but Aux Power PM Enable is RWS ("sticky"), so it is *not*
>>> modified by FLR.  Therefore, using reset_intel_82599_sfp_virtfn() has
>>> the probably unintended side effect of clearing Aux Power PM Enable.
>>>
>>> It looks possibly unnecessary because the generic pcie_flr() does
>>> essentially the same thing, so it's not clear why we need a special
>>> case for 82599.
>
>> I think reset_intel_82599_sfp_virtfn() is correct AND necessary.
>> (pcie_flr() doesn't work here)
>>
>> Please note the 82599 VF is a special PCIe device that doesn't report
>> PCIe FLR capability though actually it does support that.
>> That is why we put it in quirks.c. :-)
>>
>> The PCI_EXP_DEVCTL_AUX_PME bit of the 82599 VF is read-only and
>> always zero.
>>
>> Please see
>> http://www.intel.com/content/dam/doc/datasheet/82599-10-gbe-controller-datasheet.pdf
>> 9.5 Virtual Functions Configuration Space
>>    Table 9.7 VF PCIe Configuration Space
>>    9.5.2.2.1 VF Device Control Register (0xA8; RW)
>
> Thanks, Dexuan!
>
> The 82599 does report FLR in the DEVCAP for the PF (sec 9.3.10.4), but
> not in the DEVCAP for the VF (sec 9.5), which indeed means we can't
> use pcie_flr() on the VFs.  I wonder whether this error appears in any
> other devices.
>
It should not exist in any other VF device.  The SRIOV spec states
that all VFs must support FLR.  The 82599 quirk is just that...

> The VF DEVCTL register (sec 9.5.2.2.1) is RO and zero except for
> "Initiate FLR" unlike the PF DEVCTL (sec 9.3.10.5).  The
> read/modify/write done by pcie_flr() would work on the VF but is not
> necessary.
>
> The VF DEVSTA register (sec 9.5.2.2.2) does have an active
> "Transaction Pending" bit.  That suggests to me that we should wait
> for it to be clear, as pcie_flr() does.
>
> What would you think of a patch like the following?  My idea is to
> make it the same as pcie_flr() except for the absolutely necessary
> differences.  With this patch, the only difference is that we don't
> look at the 82599 DEVCAP FLR bit.
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index aa77538..7a451ff 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3081,10 +3081,36 @@ static int reset_intel_generic_dev(struct
> pci_dev *dev, int probe)
>
>   static int reset_intel_82599_sfp_virtfn(struct pci_dev *dev, int probe)
>   {
> +       int i;
> +       u16 status;
> +
> +       /*
> +        * http://www.intel.com/content/dam/doc/datasheet/82599-10-gbe-controller-datasheet.pdf
> +        *
> +        * The 82599 supports FLR on VFs, but FLR support is reported only
> +        * in the PF DEVCAP (sec 9.3.10.4), not in the VF DEVCAP (sec 9.5).
> +        * Therefore, we can't use pcie_flr(), which checks the VF DEVCAP.
> +        */
> +
>          if (probe)
>                  return 0;
>
> -       pcie_capability_write_word(dev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_BCR_FLR);
> +       /* Wait for Transaction Pending bit clean */
> +       for (i = 0; i<  4; i++) {
> +               if (i)
> +                       msleep((1<<  (i - 1)) * 100);
> +
> +               pcie_capability_read_word(dev, PCI_EXP_DEVSTA,&status);
> +               if (!(status&  PCI_EXP_DEVSTA_TRPND))
> +                       goto clear;
> +       }
> +
> +       dev_err(&dev->dev, "transaction is not cleared; "
> +                       "proceeding with reset anyway\n");
> +
> +clear:
> +       pcie_capability_set_word(dev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_BCR_FLR);
> +
>          msleep(100);
>
>          return 0;

