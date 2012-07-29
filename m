Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2G2QWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 12:22:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37139 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab2G2QWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 12:22:44 -0400
Message-ID: <5015634E.5050007@gmail.com>
Date: Mon, 30 Jul 2012 00:22:38 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Don Dutile <ddutile@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v2 04/32] PCI: add PCIe capabilities access functions
 to hide differences among PCIe specs
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com> <1343147504-25891-5-git-send-email-jiang.liu@huawei.com> <500F0FBF.9080903@redhat.com>
In-Reply-To: <500F0FBF.9080903@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 05:12 AM, Don Dutile wrote:
> On 07/24/2012 12:31 PM, Jiang Liu wrote:
>> +int pci_pcie_capability_read_word(struct pci_dev *dev, int pos, u16 *val)
>> +{
>> +    int ret = 0;
>> +
>> +    *val = 0;
>> +    if (pos&  1)
>> +        return -EINVAL;
>> +
>> +    if (pci_pcie_capability_reg_implemented(dev, pos)) {
>> +        ret = pci_read_config_word(dev, pci_pcie_cap(dev) + pos, val);
>> +        /*
>> +         * Reset *val to 0 if pci_read_config_word() fails, it may
>> +         * have been written as 0xFFFF if hardware error happens
>> +         * during pci_read_config_word().
>> +         */
>> +        if (ret)
>> +            *val = 0;
>> +    } else if (pos == PCI_EXP_SLTSTA&&
>> +         pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM) {
>> +        *val = PCI_EXP_SLTSTA_PDS;
>> +    }
> Don't you want the above if check done 1st, and not the
> pci_pcie_capability_reg_implemented(dev, pos) check ?
> Isn't PCI_EXP_SLTCTL an implemented register, looking at this snippet?:
>> +    switch (pos) {
>         <snip>
>> +    case PCI_EXP_SLTCAP:
>> +    case PCI_EXP_SLTCTL:
>> +    case PCI_EXP_SLTSTA:
>> +        return pci_pcie_cap_has_sltctl(dev);
>   and the above function is:
> 
>> +static inline bool pci_pcie_cap_has_sltctl(const struct pci_dev *dev)
>> +{
>> +    int type = pci_pcie_type(dev);
>> +
>> +    return pci_pcie_cap_version(dev)>  1 ||
>> +           type == PCI_EXP_TYPE_ROOT_PORT ||
>> +           (type == PCI_EXP_TYPE_DOWNSTREAM&&
>> +        dev->pcie_flags_reg&  PCI_EXP_FLAGS_SLOT);
>> +}
> 
> or is PCI_EXP_FLAGS_SLOT not set when it should be, then the first condition
> fails, and this function forces the val to 1b ?
Hi Don,
	Yes, that's the purpose. PCIe spec v2/v3 defines that hardware should return
a value with bit PCI_EXP_SLTSTA_PDS set if PCI_EXP_SLTSTA register is not implemented.
So for PCIe v1 hardwares, we try to behave in the same way as v2/v3.
	Regards!
	Gerry
