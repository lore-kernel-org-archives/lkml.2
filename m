Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2ITUid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 16:38:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39588 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2ITUib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 16:38:31 -0400
MIME-Version: 1.0
In-Reply-To: <1346168638-32724-5-git-send-email-jiang.liu@huawei.com>
References: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com>
	<1346168638-32724-5-git-send-email-jiang.liu@huawei.com>
Date: Thu, 20 Sep 2012 13:38:29 -0700
X-Google-Sender-Auth: 4G6z3osOk7JTbZ7vKoKh6CZSPRM
Message-ID: <CAE9FiQVAOEUHMSFHCpZLVK-Rbso3Rh1nUQHmfcujwb6tpUTz8A@mail.gmail.com>
Subject: Re: [PATCH 4/5] PCI/IOV: simplify code by hotplug safe pci_get_domain_bus_and_slot()
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Don Dutile <ddutile@redhat.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 8:43 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Following code has a race window between pci_find_bus() and pci_get_slot()
> if PCI hotplug operation happens between them which removes the pci_bus.
> So use PCI hotplug safe interface pci_get_domain_bus_and_slot() instead,
> which also reduces code complexity.
>
> struct pci_bus *pci_bus = pci_find_bus(domain, busno);
> struct pci_dev *pci_dev = pci_get_slot(pci_bus, devfn);
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  drivers/pci/iov.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index aeccc91..b0fe771 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -152,15 +152,11 @@ failed1:
>  static void virtfn_remove(struct pci_dev *dev, int id, int reset)
>  {
>         char buf[VIRTFN_ID_LEN];
> -       struct pci_bus *bus;
>         struct pci_dev *virtfn;
>         struct pci_sriov *iov = dev->sriov;
>
> -       bus = pci_find_bus(pci_domain_nr(dev->bus), virtfn_bus(dev, id));
> -       if (!bus)
> -               return;
> -
> -       virtfn = pci_get_slot(bus, virtfn_devfn(dev, id));
> +       virtfn = pci_get_domain_bus_and_slot(pci_domain_nr(dev->bus),
> +                       virtfn_bus(dev, id), virtfn_devfn(dev, id));
>         if (!virtfn)
>                 return;
>

Hi,

This one cause IOV regression, when remove bridge with pci devices under that.

in that case, VFs  are stopped before PF, so they are not in device
tree anymore.
so pci_get_domain_bus_and_slot will not find those VFs.

So the reference to PF is not released. Also vit_bus may not be released too.

So you have to rework
    pci_get_domain_bus_and_slot to make it work on pci devices get stopped only.

or just drop this from the tree.

BTW, Bjorn,
for the similar reason,  you need to apply
http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=e5a50aa3dfca1331c7c783412b1524bea06d2752

 PCI: Split out stop_bus_device and remove_bus_dev again.

 So later could use them for pci root bus hotplug support.

Also restore old behavoir: stop all at first then remove all.

-v2: only split the functions.

the reason is:

We stop all VFs at first , stop PF

before we stop PF, we can not remove VFs,

otherwise virtfn_remove does not work properly to remove reference and
virtfn bus while can not find vf.

I would like to have
 PCI: Split out stop_bus_device and remove_bus_dev again.
fold into

http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=commitdiff;h=282e1d655fe7c7c2e6b0dd8166c4c6b7c2a1219b

-Yinghai
