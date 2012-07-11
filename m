Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab2GKRwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 13:52:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50665 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab2GKRw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 13:52:27 -0400
MIME-Version: 1.0
In-Reply-To: <4FFD1FE7.6010504@huawei.com>
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
 <1341935655-5381-1-git-send-email-jiang.liu@huawei.com> <1341935655-5381-6-git-send-email-jiang.liu@huawei.com>
 <CAErSpo7k3=nUSTR+n1iX0Rddv2FQm+HzcqnC5VHxh1JKUdoNAw@mail.gmail.com>
 <4FFCEDDE.2080907@huawei.com> <CAErSpo4JrgU2RHoNDWcm13otgdKVXuGxahE0pbuAD73nZvTZFQ@mail.gmail.com>
 <4FFD1FE7.6010504@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 11 Jul 2012 11:52:05 -0600
Message-ID: <CAErSpo7ZtrYtz_8iB8=8nbQBtntPtyi8BLg6K+D7mQjnfj-KCg@mail.gmail.com>
Subject: Re: [RFC PATCH 05/14] PCI: add access functions for PCIe capabilities
 to hide PCIe spec differences
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 12:40 AM, Jiang Liu <jiang.liu@huawei.com> wrote:
> On 2012-7-11 11:40, Bjorn Helgaas wrote:
>
>>> Good point. Return success when reading unimplemented registeres, that
>>> may simplify code. For we still should return -EINVAL when writing
>>> unimplemented registers, right?
>>
>> Yeah, I guess it's OK to return -EINVAL when *writing* to an
>> unimplemented register.  Hopefully the caller is structured such that
>> we don't even try to write in that case.  It'd be interesting to audit
>> the callers and explore that, but I haven't done that.
> Hi Bjorn,
>         Seems it would be better to return error code for unimplemented
> registers, otherwise following code will becomes more complex. A special
> error code for unimplemented registers, such as -EIO?

I think you're asking about returning error for *reads* of
unimplemented registers?  I guess I still think it's OK to completely
hide the v1 nastiness inside these accessors, and return success with
a zero value when reading.  Having several different error returns
seems like overkill for this case.  Nobody wants to distinguish
between different reasons for failure.

I'm actually not sure that it's worth returning an error even when
*writing* an unimplemented register.  What if we return success and
just drop the write?

Maybe these should even be void functions.  It feels like the only
real use of the return value is to detect programmer error, and I
don't think that's very effective.  If we remove the return values,
people will have to focus on the *data*, which seems more important
anyway.

> static void rtl_disable_clock_request(struct pci_dev *pdev)
> {
>         u16 ctl;
>
>         if (!pci_pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &ctl)) {
>                 ctl &= ~PCI_EXP_LNKCTL_CLKREQ_EN;
>                 pci_pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, ctl);
>         }
> }

I would write that as:

    if (!pci_is_pcie(pdev)
        return;

    pci_pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &ctl);
    if (ctl & PCI_EXP_LNKCTL_CLKREQ_EN)
        pci_pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, ctl &
~PCI_EXP_LNKCTL_CLKREQ_EN);

which does the right thing regardless of what we do for return values,
and saves a config write in the case where LNKCTL is implemented and
CLKREQ_EN is already cleared.

Bjorn
