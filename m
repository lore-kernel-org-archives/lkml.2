Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab2IUADA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:03:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56679 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2IUAC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:02:59 -0400
Message-ID: <505BAEAE.4040804@gmail.com>
Date: Fri, 21 Sep 2012 08:02:54 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Don Dutile <ddutile@redhat.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 4/5] PCI/IOV: simplify code by hotplug safe pci_get_domain_bus_and_slot()
References: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com> <1346168638-32724-5-git-send-email-jiang.liu@huawei.com> <CAE9FiQVAOEUHMSFHCpZLVK-Rbso3Rh1nUQHmfcujwb6tpUTz8A@mail.gmail.com> <CAErSpo58sSCPYF9Ug-o-f3odJovECkdxPOoahx9+Ob6kmP_srw@mail.gmail.com>
In-Reply-To: <CAErSpo58sSCPYF9Ug-o-f3odJovECkdxPOoahx9+Ob6kmP_srw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 07:59 AM, Bjorn Helgaas wrote:
> On Thu, Sep 20, 2012 at 2:38 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Tue, Aug 28, 2012 at 8:43 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>> Following code has a race window between pci_find_bus() and pci_get_slot()
>>> if PCI hotplug operation happens between them which removes the pci_bus.
>>> So use PCI hotplug safe interface pci_get_domain_bus_and_slot() instead,
>>> which also reduces code complexity.
>>>
>>> struct pci_bus *pci_bus = pci_find_bus(domain, busno);
>>> struct pci_dev *pci_dev = pci_get_slot(pci_bus, devfn);
>>>
>>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>>> ---
>>>  drivers/pci/iov.c |    8 ++------
>>>  1 file changed, 2 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>>> index aeccc91..b0fe771 100644
>>> --- a/drivers/pci/iov.c
>>> +++ b/drivers/pci/iov.c
>>> @@ -152,15 +152,11 @@ failed1:
>>>  static void virtfn_remove(struct pci_dev *dev, int id, int reset)
>>>  {
>>>         char buf[VIRTFN_ID_LEN];
>>> -       struct pci_bus *bus;
>>>         struct pci_dev *virtfn;
>>>         struct pci_sriov *iov = dev->sriov;
>>>
>>> -       bus = pci_find_bus(pci_domain_nr(dev->bus), virtfn_bus(dev, id));
>>> -       if (!bus)
>>> -               return;
>>> -
>>> -       virtfn = pci_get_slot(bus, virtfn_devfn(dev, id));
>>> +       virtfn = pci_get_domain_bus_and_slot(pci_domain_nr(dev->bus),
>>> +                       virtfn_bus(dev, id), virtfn_devfn(dev, id));
>>>         if (!virtfn)
>>>                 return;
>>>
>>
>> Hi,
>>
>> This one cause IOV regression, when remove bridge with pci devices under that.
>>
>> in that case, VFs  are stopped before PF, so they are not in device
>> tree anymore.
>> so pci_get_domain_bus_and_slot will not find those VFs.
>>
>> So the reference to PF is not released. Also vit_bus may not be released too.
>>
>> So you have to rework
>>     pci_get_domain_bus_and_slot to make it work on pci devices get stopped only.
>>
>> or just drop this from the tree.
> 
> pci_find_bus() is a broken interface (because there's no reference
> counting or safety with respect to hot-plug), and if the design
> depends on it, that means the design is broken, too.  I don't think
> reworking pci_get_domain_bus_and_slot() is the right answer.
> 
> It's not clear to me why we need the split between stopping and
> removing devices.  That split leads to these zombie devices that have
> been stopped and are no longer findable by bus_find_device() (which is
> used by pci_get_domain_bus_and_slot()), but still "exist" in some
> fashion until they're removed.  It's unreasonable for random PCI and
> driver code to have to worry about that zombie state.
> 
> I'll revert this patch for now to fix the regression.  Of course, that
> means we will still have the old problem of using the unsafe
> pci_find_bus().
Hi Bjorn,
	I'm working on to enhance unsafe calling of pci_find_bus().
	--Gerry

