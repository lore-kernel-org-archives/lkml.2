Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab2GDCzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 22:55:44 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61024 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2GDCzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 22:55:42 -0400
Message-ID: <4FF3AFDD.2090606@huawei.com>
Date: Wed, 4 Jul 2012 10:52:13 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>, Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [Resend with Ack][PATCH v1] PCI: allow acpiphp to handle PCIe
 ports without native PCIe hotplug capability
References: <1338795894-6292-1-git-send-email-jiang.liu@huawei.com> <CAErSpo7NiCsuM+UxveZbYxNsCiStMH5SLZ8EdFzJ7EduB306OQ@mail.gmail.com> <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
In-Reply-To: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, let's try it.

On 2012-7-3 23:59, Bjorn Helgaas wrote:
> Thinking about this some more, this still leaves the callers
> responsible for using pcie_cap_has_*(), which feels pretty
> error-prone.
> 
> I wonder if it'd be worth adding interfaces like:
> 
>   pcie_cap_read_word(const struct pci_dev *, int where, u16 *val);
>   pcie_cap_read_dword(const struct pci_dev *, int where, u32 *val);
>   pcie_cap_write_word(const struct pci_dev *, int where, u16 val);
>   pcie_cap_write_dword(const struct pci_dev *, int where, u32 val);
> 
> We might be able to encapsulate the v1/v2 differences inside these, e.g.,
> 
>   int pcie_cap_read_word(const struct pci_dev *dev, int where, u16 *val)
>   {
>       int pos;
> 
>       pos = pci_pcie_cap(dev);
>       if (!pos)
>           return -EINVAL;
> 
>       switch (where) {
>       case PCI_EXP_FLAGS:
>       case PCI_EXP_DEVCTL:
>       case PCI_EXP_DEVSTA:
>           return pci_read_config_word(dev, pos + where, val);
>       case PCI_EXP_LNKCTL:
>       case PCI_EXP_LNKSTA:
>           if (pcie_cap_has_lnkctl(dev))
>               return pci_read_config_word(dev, pos + where, val);
>           else {
>               *val = 0;
>               return 0;
>           }
>       case PCI_EXP_SLTCTL:
>       case PCI_EXP_SLTSTA:
>           if (pcie_cap_has_sltctl(dev))
>               return pci_read_config_word(dev, pos + where, val);
>           else {
>               *val = 0;
>               if (where == PCI_EXP_SLTSTA && dev->pcie_type ==
> PCI_EXP_TYPE_DOWNSTREAM)
>                   *val = PCI_EXP_SLTSTA_PDS;
>               return 0;
>       ...
>       };
>       return -EINVAL;
>   }
> 
> Any thoughts?
> 
> .
> 


