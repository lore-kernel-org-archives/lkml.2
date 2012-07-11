Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab2GKDK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 23:10:28 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:48217 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab2GKDKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 23:10:21 -0400
Message-ID: <4FFCEDDE.2080907@huawei.com>
Date: Wed, 11 Jul 2012 11:07:10 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <liuj97@gmail.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
Subject: Re: [RFC PATCH 05/14] PCI: add access functions for PCIe capabilities
 to hide PCIe spec differences
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com> <1341935655-5381-1-git-send-email-jiang.liu@huawei.com> <1341935655-5381-6-git-send-email-jiang.liu@huawei.com> <CAErSpo7k3=nUSTR+n1iX0Rddv2FQm+HzcqnC5VHxh1JKUdoNAw@mail.gmail.com>
In-Reply-To: <CAErSpo7k3=nUSTR+n1iX0Rddv2FQm+HzcqnC5VHxh1JKUdoNAw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-7-11 2:35, Bjorn Helgaas wrote:
>> diff --git a/drivers/pci/access.c b/drivers/pci/access.c
>> index ba91a7e..80ae022 100644
>> --- a/drivers/pci/access.c
>> +++ b/drivers/pci/access.c
>> @@ -469,3 +469,91 @@ void pci_cfg_access_unlock(struct pci_dev *dev)
>>         raw_spin_unlock_irqrestore(&pci_lock, flags);
>>  }
>>  EXPORT_SYMBOL_GPL(pci_cfg_access_unlock);
>> +
>> +static int
>> +pci_pcie_cap_get_offset(struct pci_dev *dev, int where, size_t sz)
>> +{
>> +       bool valid;
>> +
>> +       if (!pci_is_pcie(dev))
>> +               return -EINVAL;
>> +       if (where & (sz - 1))
>> +               return -EINVAL;
>> +
>> +       if (where < 0)
>> +               valid = false;
>> +       else if (where < PCI_EXP_DEVCAP)
>> +               valid = true;
>> +       else if (where < PCI_EXP_LNKCAP)
>> +               valid = pci_pcie_cap_has_devctl(dev);
>> +       else if (where < PCI_EXP_SLTCAP)
>> +               valid = pci_pcie_cap_has_lnkctl(dev);
>> +       else if (where < PCI_EXP_RTCTL)
>> +               valid = pci_pcie_cap_has_sltctl(dev);
>> +       else if (where < PCI_EXP_DEVCAP2)
>> +               valid = pci_pcie_cap_has_rtctl(dev);
>> +       else if (where < PCI_EXP_CAP2_SIZE)
>> +               valid = pci_pcie_cap_has_cap2(dev);
>> +       else
>> +               valid = false;
>> +
>> +       return valid ? where + pci_pcie_cap(dev) : -EINVAL;
>> +}
>> +
>> +int pci_pcie_cap_read_word(struct pci_dev *dev, int where, u16 *valp)
>> +{
>> +       *valp = 0;
>> +       where = pci_pcie_cap_get_offset(dev, where, sizeof(u16));
> 
> This is a really slick factorization; I like it much better than my
> proposal.  I would like it even *better* if it read something like
> this:
> 
>     bool implemented;
> 
>     *valp = 0;
>     if (!pci_is_pcie(dev) || where & 1)
>         return -EINVAL;
> 
>     implemented = pci_pcie_cap_implemented(dev, where);
>     if (implemented)
>         return pci_read_config_word(dev, pci_pcie_cap(dev) + where, valp);
> 
>     if (pci_is_pcie(dev) && where == PCI_EXP_SLTSTA ...
> 
> because I think it's useful to have the "pos + where" visual pattern
> in the pci_read_config_word() arguments.
Sure, for better readability.

> 
>> +       if (where >= 0)
>> +               return pci_read_config_word(dev, where, valp);
>> +
>> +       if (pci_is_pcie(dev) && where == PCI_EXP_SLTSTA &&
>> +           pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM)
>> +               *valp = PCI_EXP_SLTSTA_PDS;
> 
> I think we should be returning success in this case (SLTSTA for
> downstream port).  In fact, I think we should return success even when
> we're emulating the read of an unimplemented register from a v1
> capability.  The caller should not be aware at all that there is a
> difference between v1 and v2 capabilities.
> 
> I'd put the spec reference here rather than in read_dword(), since
> SLTSTA is a u16 and this is the natural way to read it.  Then maybe a
> short comment in read_dword() below.
Good point. Return success when reading unimplemented registeres, that
may simplify code. For we still should return -EINVAL when writing
unimplemented registers, right?

>> +EXPORT_SYMBOL(pci_pcie_cap_write_dword);
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 346b2d9..78767b2 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -1703,6 +1703,11 @@ static inline bool pci_pcie_cap_has_rtctl(const struct pci_dev *pdev)
>>                type == PCI_EXP_TYPE_RC_EC;
>>  }
>>
>> +extern int pci_pcie_cap_read_word(struct pci_dev *dev, int where, u16 *valp);
>> +extern int pci_pcie_cap_read_dword(struct pci_dev *dev, int where, u32 *valp);
>> +extern int pci_pcie_cap_write_word(struct pci_dev *dev, int where, u16 val);
>> +extern int pci_pcie_cap_write_dword(struct pci_dev *dev, int where, u32 val);
> 
> You don't need the "extern" here (and I think you'll probably remove
> these altogether, see below).
> 
>> +
>>  void pci_request_acs(void);
>>  bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags);
>>  bool pci_acs_path_enabled(struct pci_dev *start,
>> @@ -1843,5 +1848,10 @@ static inline struct eeh_dev *pci_dev_to_eeh_dev(struct pci_dev *pdev)
>>   */
>>  struct pci_dev *pci_find_upstream_pcie_bridge(struct pci_dev *pdev);
>>
>> +int pci_pcie_capability_read_word(struct pci_dev *dev, int where, u16 *val);
>> +int pci_pcie_capability_read_dword(struct pci_dev *dev, int where, u32 *val);
>> +int pci_pcie_capability_write_word(struct pci_dev *dev, int where, u16 val);
>> +int pci_pcie_capability_write_dword(struct pci_dev *dev, int where, u32 val);
> 
> There's some confusion here: pci_pcie_cap_* versus
> pci_pcie_capability_*.  I think you only need one set, and I prefer
> pci_pcie_capability_* to follow the example of
> pci_bus_find_capability().
The above confusion was caused by a dirty merge.

> 
>> +
>>  #endif /* __KERNEL__ */
>>  #endif /* LINUX_PCI_H */
>> diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
>> index 53274bf..ac60e22 100644
>> --- a/include/linux/pci_regs.h
>> +++ b/include/linux/pci_regs.h
>> @@ -542,9 +542,24 @@
>>  #define  PCI_EXP_OBFF_MSGA_EN  0x2000  /* OBFF enable with Message type A */
>>  #define  PCI_EXP_OBFF_MSGB_EN  0x4000  /* OBFF enable with Message type B */
>>  #define  PCI_EXP_OBFF_WAKE_EN  0x6000  /* OBFF using WAKE# signaling */
>> -#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 44      /* v2 endpoints end here */
>> +#define PCI_EXP_DEVSTA2                42      /* Device Status 2 */
>> +#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2 44 /* v2 endpoints end here */
>> +#define PCI_EXP_LNKCAP2                44      /* Link Capabilities 2 */
>>  #define PCI_EXP_LNKCTL2                48      /* Link Control 2 */
>> -#define PCI_EXP_SLTCTL2                56      /* Slot Control 2 */
>> +#define  PCI_EXP_LNKCTL2_TLS   0x0f    /* Target Link Speed */
>> +#define  PCI_EXP_LNKCTL2_EC    0x10    /* Enter Compliance */
>> +#define  PCI_EXP_LNKCTL2_HASD  0x20    /* Hardware Autonomous Speed Disable */
>> +#define  PCI_EXP_LNKCTL2_SD    0x40    /* Selectable De-emphasis */
>> +#define  PCI_EXP_LNKCTL2_TM    0x380   /* Transmit Margin */
>> +#define  PCI_EXP_LNKCTL2_EMC   0x400   /* Enter Modified Compliance */
>> +#define  PCI_EXP_LNKCTL2_CS    0x800   /* Compliance SOS */
>> +#define  PCI_EXP_LNKCTL2_CD    0x1000  /* Compliance De-emphasis */
>> +#define PCI_EXP_LNKSTA2                50      /* Link Status 2 */
>> +#define  PCI_EXP_LNKSTA2_CDL   0x01    /* Current De-emphasis Level */
>> +#define PCI_EXP_SLTCAP2                52      /* Slot Capabilities 2 */
>> +#define PCI_EXP_SLTCTL2                56      /* Slot Control 2*/
>> +#define PCI_EXP_SLTSTA2                58      /* Slot Status 2*/
>> +#define        PCI_EXP_CAP2_SIZE       60
> 
> Most of these changes look unrelated to the current patch.  They
> should be moved to a patch that uses the symbols you're adding.
Good point, create on demand:)

Thanks!
Gerry

