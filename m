Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2IUBvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 21:51:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57877 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab2IUBvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 21:51:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo58sSCPYF9Ug-o-f3odJovECkdxPOoahx9+Ob6kmP_srw@mail.gmail.com>
References: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com>
	<1346168638-32724-5-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQVAOEUHMSFHCpZLVK-Rbso3Rh1nUQHmfcujwb6tpUTz8A@mail.gmail.com>
	<CAErSpo58sSCPYF9Ug-o-f3odJovECkdxPOoahx9+Ob6kmP_srw@mail.gmail.com>
Date: Thu, 20 Sep 2012 18:51:04 -0700
X-Google-Sender-Auth: A_SdLiPmKKPvYJpsrnX5FVAtczo
Message-ID: <CAE9FiQWuVW6U9cE+iY0Gpua_0xhdxp6HxcWyhqqSN+L3Da_1Qg@mail.gmail.com>
Subject: Re: [PATCH 4/5] PCI/IOV: simplify code by hotplug safe pci_get_domain_bus_and_slot()
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        Don Dutile <ddutile@redhat.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 4:59 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Sep 20, 2012 at 2:38 PM, Yinghai Lu <yinghai@kernel.org> wrote:
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

That is not zombie state. that is driver unloaded, and not in /sys, /proc.
that pci device only can be found under bus->devices.

just like we have pci_device_add and pci_bus_add_device
or acpi add and acpi start.

Splitting stop and remove should be more clean than mixing stop and remove.

>
> I'll revert this patch for now to fix the regression.  Of course, that
> means we will still have the old problem of using the unsafe
> pci_find_bus().
>
>> BTW, Bjorn,
>> for the similar reason,  you need to apply
>> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=e5a50aa3dfca1331c7c783412b1524bea06d2752
>> ...
>> the reason is:
>>
>> We stop all VFs at first , stop PF
>> before we stop PF, we can not remove VFs,
>>
>> otherwise virtfn_remove does not work properly to remove reference and
>> virtfn bus while can not find vf.
>
> I'll apply this one, too, for now.  I put them both on the
> pci/yinghai-revert-pci_find_bus-and-remove-cleanup branch.  Let me
> know if that's not what you expected.

Yes, they are good.

>
> I'm not happy about either reverting Jiang's patch or splitting
> stop/remove again.  It complicates the design and the code.  I'll
> apply them because they're regressions, and we don't have time for
> redesign before 3.7.  But I encourage you to think about how to do
> this more cleanly.

That will need to redesign sriov implementation.

Also that pci root bus add/start, stop/remove will need special
sequence to make ioapic
and dmar to be started early before normal pci device drivers and
stopped after normal pci device drivers.

-Yinghai
