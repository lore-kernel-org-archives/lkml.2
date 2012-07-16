Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2GPRaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:30:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58267 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab2GPRaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:30:08 -0400
MIME-Version: 1.0
In-Reply-To: <5002F420.40801@gmail.com>
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
 <1341935655-5381-1-git-send-email-jiang.liu@huawei.com> <1341935655-5381-6-git-send-email-jiang.liu@huawei.com>
 <CAErSpo7k3=nUSTR+n1iX0Rddv2FQm+HzcqnC5VHxh1JKUdoNAw@mail.gmail.com>
 <4FFCEDDE.2080907@huawei.com> <CAErSpo4JrgU2RHoNDWcm13otgdKVXuGxahE0pbuAD73nZvTZFQ@mail.gmail.com>
 <4FFD1FE7.6010504@huawei.com> <CAErSpo7ZtrYtz_8iB8=8nbQBtntPtyi8BLg6K+D7mQjnfj-KCg@mail.gmail.com>
 <4FFE3CEC.80804@huawei.com> <CAErSpo4Adjo8e3YmSJCvNjosouUzuAQqpTm1rm=CAYvFmuDpyg@mail.gmail.com>
 <5002F420.40801@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 16 Jul 2012 11:29:44 -0600
Message-ID: <CAErSpo6AGAHJYYhOKmtL5a9_W5Kuyq3-zLLqWsURbrYJJYEoNA@mail.gmail.com>
Subject: Re: [RFC PATCH 05/14] PCI: add access functions for PCIe capabilities
 to hide PCIe spec differences
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Don Dutile <ddutile@redhat.com>,
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

On Sun, Jul 15, 2012 at 10:47 AM, Jiang Liu <liuj97@gmail.com> wrote:
> On 07/13/2012 04:49 AM, Bjorn Helgaas wrote:
>>> Hi Bjorn,
>>>         It's a little risk to change these PCIe capabilities access
>>> functions as void. On some platform with hardware error detecting/correcting
>>> capabilities, such as EEH on Power, it would be better to return
>>> error code if hardware error happens during accessing configuration registers.
>>>         As I know, coming Intel Xeon processor may provide PCIe hardware
>>> error detecting capability similar to EEH on power.
>>
>> I guess I'm playing devil's advocate here.  As a general rule, people
>> don't check the return value of pci_read_config_*() or
>> pci_write_config_*().  Unless you change them all, most callers of
>> pci_pcie_capability_read_*() and _write_*() won't check the returns
>> either.  So I'm not sure return values are an effective way to detect
>> those hardware errors.
>>
>> How do these EEH errors get detected or reported today?  Do the
>> drivers check every config access for success?  Adding those checks
>> and figuring out how to handle errors at every possible point doesn't
>> seem like a recipe for success.
>
> Hi Bjorn,
>         Sorry for later reply, on travel these days.
>         Yeah, it's true that most driver doesn't check return values of configuration
> access functions, but there are still some drivers which do check return value of
> pci_read_config_xxx(). For example, pciehp driver checks return value of CFG access
> functions.
>
>         It's not realistic to enhance all drivers, but we may focus on a small set of
> drivers for hardwares on specific high-end servers. For RAS features, we can never provide
> perfect solutions, so we prefer some improvements. After all a small improvement is still
> an improvement:)
>
>         I'm only familiar with PCI on IA64 and x86. For PowerPC, I just know that the OS
> may query firmware whether there's some hardware faults if pci_cfg_read_xxx() returns
> all 1s. For PCI on IA64, SAL may handle PCI hardware errors and return error code to
> pci_cfg_read_xxx(). For x86, I think it will have some mechanisms to report hardware faults
> like SAL on IA64.
>
>         So how about keeping consistence with pci_cfg_read_xxx() and pci_user_cfg_read_xxx()?

My goal is "the caller should never have to know whether this is a v1
or v2 capability."  Returning any error other than one passed along
from pci_read/write_config_xxx() means we miss that goal.  Perhaps the
goal is unattainable, but I haven't been convinced yet.

I think hardware error detection is irrelevant to this discussion.
After reading Documentation/PCI/pci-error-recovery.txt, I'm even less
convinced that checking return values from pci_read/write_config_xxx()
or pci_pcie_capability_read/write_xxx() is a useful way to detect
hardware errors.

Having drivers detect hardware failures by checking for config access
errors is neither necessary nor sufficient.  It's not necessary
because a platform can implement a config accessor that checks *every*
access and reports failures to the driver via the pci_error_handler
framework.  It's not sufficient because config accesses are rare
(usually only at init-time), and hardware failures may happen at
arbitrary other times.

In my opinion, the only relevant question is whether a caller of
pci_pcie_capability_read/write_xxx() needs to know whether a register
is implemented (i.e., we have a v2 capability) or not.  For reads, I
don't think there's a case where fabricating a value of zero when
reading an unimplemented register is a problem.

Writes are obviously more interesting, but I'm still not sure there's
a case where silently dropping a write to an unimplemented register is
a problem.  The "capability" registers are read-only, so there's no
problem if we drop writes to them.  The "status" registers are
generally RO or RW1C, where it's only meaningful to write a non-zero
value if you're previously *read* a non-zero value.  The "control"
registers are often RW, of course, but generally it's only meaningful
to write a non-zero value when a non-zero bit in the "capability"
register has previously told you that something is supported.

Bjorn
