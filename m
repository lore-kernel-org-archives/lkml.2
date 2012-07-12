Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab2GLC6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:58:51 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:48415 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2GLC6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:58:49 -0400
Message-ID: <4FFE3CEC.80804@huawei.com>
Date: Thu, 12 Jul 2012 10:56:44 +0800
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
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com> <1341935655-5381-1-git-send-email-jiang.liu@huawei.com> <1341935655-5381-6-git-send-email-jiang.liu@huawei.com> <CAErSpo7k3=nUSTR+n1iX0Rddv2FQm+HzcqnC5VHxh1JKUdoNAw@mail.gmail.com> <4FFCEDDE.2080907@huawei.com> <CAErSpo4JrgU2RHoNDWcm13otgdKVXuGxahE0pbuAD73nZvTZFQ@mail.gmail.com> <4FFD1FE7.6010504@huawei.com> <CAErSpo7ZtrYtz_8iB8=8nbQBtntPtyi8BLg6K+D7mQjnfj-KCg@mail.gmail.com>
In-Reply-To: <CAErSpo7ZtrYtz_8iB8=8nbQBtntPtyi8BLg6K+D7mQjnfj-KCg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-7-12 1:52, Bjorn Helgaas wrote:
>> Hi Bjorn,
>>         Seems it would be better to return error code for unimplemented
>> registers, otherwise following code will becomes more complex. A special
>> error code for unimplemented registers, such as -EIO?
> 
> I think you're asking about returning error for *reads* of
> unimplemented registers?  I guess I still think it's OK to completely
> hide the v1 nastiness inside these accessors, and return success with
> a zero value when reading.  Having several different error returns
> seems like overkill for this case.  Nobody wants to distinguish
> between different reasons for failure.
> 
> I'm actually not sure that it's worth returning an error even when
> *writing* an unimplemented register.  What if we return success and
> just drop the write?
> 
> Maybe these should even be void functions.  It feels like the only
> real use of the return value is to detect programmer error, and I
> don't think that's very effective.  If we remove the return values,
> people will have to focus on the *data*, which seems more important
> anyway.
Hi Bjorn,
	It's a little risk to change these PCIe capabilities access
functions as void. On some platform with hardware error detecting/correcting
capabilities, such as EEH on Power, it would be better to return
error code if hardware error happens during accessing configuration registers.
	As I know, coming Intel Xeon processor may provide PCIe hardware
error detecting capability similar to EEH on power.

>> static void rtl_disable_clock_request(struct pci_dev *pdev)
>> {
>>         u16 ctl;
>>
>>         if (!pci_pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &ctl)) {
>>                 ctl &= ~PCI_EXP_LNKCTL_CLKREQ_EN;
>>                 pci_pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, ctl);
>>         }
>> }
> 
> I would write that as:
> 
>     if (!pci_is_pcie(pdev)
>         return;
> 
>     pci_pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &ctl);
>     if (ctl & PCI_EXP_LNKCTL_CLKREQ_EN)
>         pci_pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, ctl &
> ~PCI_EXP_LNKCTL_CLKREQ_EN);
> 
> which does the right thing regardless of what we do for return values,
> and saves a config write in the case where LNKCTL is implemented and
> CLKREQ_EN is already cleared.
When clearing a flag, we could do that. But if we are trying to set a
flag, it would be better to make sure the target register does exist.

