Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab2GKCxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 22:53:15 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:37208 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2GKCxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 22:53:13 -0400
Message-ID: <4FFCE9C0.3050705@huawei.com>
Date: Wed, 11 Jul 2012 10:49:36 +0800
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
Subject: Re: [RFC PATCH 06/14] PCI: use PCIe cap access functions to simplify
 PCI core implementation
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com> <1341935655-5381-1-git-send-email-jiang.liu@huawei.com> <1341935655-5381-7-git-send-email-jiang.liu@huawei.com> <CAErSpo5bx8+tdx5NFUuJurYRVDA42h2Bbrn0EdBJBF=J-8Muqg@mail.gmail.com>
In-Reply-To: <CAErSpo5bx8+tdx5NFUuJurYRVDA42h2Bbrn0EdBJBF=J-8Muqg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-7-11 2:35, Bjorn Helgaas wrote:
>> @@ -2042,7 +1994,6 @@ void pci_free_cap_save_buffers(struct pci_dev *dev)
>>   */
>>  void pci_enable_ari(struct pci_dev *dev)
>>  {
>> -       int pos;
>>         u32 cap;
>>         u16 ctrl;
>>         struct pci_dev *bridge;
>> @@ -2050,8 +2001,7 @@ void pci_enable_ari(struct pci_dev *dev)
>>         if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
>>                 return;
>>
>> -       pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI);
>> -       if (!pos)
>> +       if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI))
> 
> What's going on here?  This looks wrong, and unrelated to the rest of the patch.
Yeah, it's a bug. My original idea is to get rid of "int pos", and it should be
if (!pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI))

> 
>>                 return;
>>
>>         bridge = dev->bus->self;
>> @@ -2059,17 +2009,14 @@ void pci_enable_ari(struct pci_dev *dev)
>>                 return;
>>
>>         /* ARI is a PCIe cap v2 feature */
> 
> If we're doing this right, we should be able to remove this comment
> (and similar ones below).
Will remove them.

> 
>> -       pos = pci_pcie_cap2(bridge);
>> -       if (!pos)
>> +       if (pci_pcie_cap_read_dword(bridge, PCI_EXP_DEVCAP2, &cap) ||
>> +          !(cap & PCI_EXP_DEVCAP2_ARI))
> 
> I don't think there's any point in checking every return from
> pci_pcie_cap_read_dword().  We've already checked pci_is_pcie() above,
> and checking here just clutters the code.  In cases like this, my
> opinion is that clean code leads to fewer bugs, and that benefit
> outweighs whatever technical "every return must be checked" benefit
> there might be.
Good point!

>> @@ -2223,17 +2152,14 @@ EXPORT_SYMBOL(pci_disable_obff);
>>   */
>>  static bool pci_ltr_supported(struct pci_dev *dev)
>>  {
>> -       int pos;
>>         u32 cap;
>>
>>         /* LTR is a PCIe cap v2 feature */
>> -       pos = pci_pcie_cap2(dev);
>> -       if (!pos)
>> +       if (pci_pcie_cap_read_dword(dev, PCI_EXP_DEVCAP2, &cap) ||
>> +           !(cap & PCI_EXP_DEVCAP2_LTR))
>>                 return false;
> 
> How about if you restructure this to avoid the double negatives?  E.g.,
> 
>     pci_pcie_cap_read_dword(dev, PCI_EXP_DEVCAP2, &cap);
>     if (cap & PCI_EXP_DEVCAP2_LTR)
>             return true;
> 
>     return false;
> 
Good point.

Thanks!
Gerry

