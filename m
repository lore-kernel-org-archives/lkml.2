Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab2GJSgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 14:36:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40722 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2GJSgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 14:36:20 -0400
MIME-Version: 1.0
In-Reply-To: <1341935655-5381-8-git-send-email-jiang.liu@huawei.com>
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com>
 <1341935655-5381-1-git-send-email-jiang.liu@huawei.com> <1341935655-5381-8-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 10 Jul 2012 12:35:59 -0600
Message-ID: <CAErSpo6+JuA9ySsB+Qt70AVC6mNvzbpptJS=zpOZAT2RD=1AdA@mail.gmail.com>
Subject: Re: [RFC PATCH 07/14] hotplug/PCI: use PCIe cap access functions to
 simplify implementation
To: Jiang Liu <liuj97@gmail.com>
Cc: Don Dutile <ddutile@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
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

On Tue, Jul 10, 2012 at 9:54 AM, Jiang Liu <liuj97@gmail.com> wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
>
> Use PCIe cap access functions to simplify pcihp_slot.c
>
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  drivers/pci/hotplug/pcihp_slot.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/pci/hotplug/pcihp_slot.c b/drivers/pci/hotplug/pcihp_slot.c
> index 8c05a18..08ca019 100644
> --- a/drivers/pci/hotplug/pcihp_slot.c
> +++ b/drivers/pci/hotplug/pcihp_slot.c
> @@ -103,8 +103,7 @@ static void program_hpp_type2(struct pci_dev *dev, struct hpp_type2 *hpp)
>                 return;
>
>         /* Find PCI Express capability */

Drop the comment, too.

> -       pos = pci_pcie_cap(dev);
> -       if (!pos)
> +       if (!pci_is_pcie(dev))
>                 return;
>
>         if (hpp->revision > 1) {
> @@ -114,16 +113,18 @@ static void program_hpp_type2(struct pci_dev *dev, struct hpp_type2 *hpp)
>         }
>
>         /* Initialize Device Control Register */
> -       pci_read_config_word(dev, pos + PCI_EXP_DEVCTL, &reg16);
> +       if (pci_pcie_cap_read_word(dev, PCI_EXP_DEVCTL, &reg16))
> +               return;
>         reg16 = (reg16 & hpp->pci_exp_devctl_and) | hpp->pci_exp_devctl_or;
> -       pci_write_config_word(dev, pos + PCI_EXP_DEVCTL, reg16);
> +       pci_pcie_cap_write_word(dev, PCI_EXP_DEVCTL, reg16);
>
>         /* Initialize Link Control Register */
>         if (dev->subordinate) {
> -               pci_read_config_word(dev, pos + PCI_EXP_LNKCTL, &reg16);
> -               reg16 = (reg16 & hpp->pci_exp_lnkctl_and)
> -                       | hpp->pci_exp_lnkctl_or;
> -               pci_write_config_word(dev, pos + PCI_EXP_LNKCTL, reg16);
> +               if (pci_pcie_cap_read_word(dev, PCI_EXP_LNKCTL, &reg16)) {
> +                       reg16 = (reg16 & hpp->pci_exp_lnkctl_and)
> +                               | hpp->pci_exp_lnkctl_or;
> +                       pci_pcie_cap_write_word(dev, PCI_EXP_LNKCTL, reg16);
> +               }
>         }
>
>         /* Find Advanced Error Reporting Enhanced Capability */
> --
> 1.7.9.5
>
