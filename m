Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2BVVEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:04:09 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:39270 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2BVVEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:04:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.180.109.228 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <1328948321-14791-1-git-send-email-yinghai@kernel.org>
References: <1328948321-14791-1-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 22 Feb 2012 13:03:44 -0800
Message-ID: <CAErSpo6cRdc3YnyqD4U6WtOMNPW_=VGCotwE9iBvu=rBs1UeRw@mail.gmail.com>
Subject: Re: [PATCH] PCI: move pci_find_saved_cap out of linux/pci.h
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 11, 2012 at 12:18 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> Only have user in driver/pci/pci.c
>
> Don't need to put it in global pci.h

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> Signed-off-by: Yinghai Lu <yinghai@kernel.org.
>
> ---
>  drivers/pci/pci.c   |   19 +++++++++++++++++++
>  include/linux/pci.h |   19 -------------------
>  2 files changed, 19 insertions(+), 19 deletions(-)
>
> Index: linux-2.6/drivers/pci/pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci.c
> +++ linux-2.6/drivers/pci/pci.c
> @@ -825,6 +825,19 @@ EXPORT_SYMBOL(pci_choose_state);
>  #define pcie_cap_has_sltctl2(type, flags)              \
>                ((flags & PCI_EXP_FLAGS_VERS) > 1)
>
> +static struct pci_cap_saved_state *pci_find_saved_cap(
> +       struct pci_dev *pci_dev, char cap)
> +{
> +       struct pci_cap_saved_state *tmp;
> +       struct hlist_node *pos;
> +
> +       hlist_for_each_entry(tmp, pos, &pci_dev->saved_cap_space, next) {
> +               if (tmp->cap.cap_nr == cap)
> +                       return tmp;
> +       }
> +       return NULL;
> +}
> +
>  static int pci_save_pcie_state(struct pci_dev *dev)
>  {
>        int pos, i = 0;
> @@ -1869,6 +1882,12 @@ void platform_pci_wakeup_init(struct pci
>        platform_pci_sleep_wake(dev, false);
>  }
>
> +static void pci_add_saved_cap(struct pci_dev *pci_dev,
> +       struct pci_cap_saved_state *new_cap)
> +{
> +       hlist_add_head(&new_cap->next, &pci_dev->saved_cap_space);
> +}
> +
>  /**
>  * pci_add_save_buffer - allocate buffer for saving given capability registers
>  * @dev: the PCI device
> Index: linux-2.6/include/linux/pci.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pci.h
> +++ linux-2.6/include/linux/pci.h
> @@ -368,25 +368,6 @@ static inline int pci_channel_offline(st
>        return (pdev->error_state != pci_channel_io_normal);
>  }
>
> -static inline struct pci_cap_saved_state *pci_find_saved_cap(
> -       struct pci_dev *pci_dev, char cap)
> -{
> -       struct pci_cap_saved_state *tmp;
> -       struct hlist_node *pos;
> -
> -       hlist_for_each_entry(tmp, pos, &pci_dev->saved_cap_space, next) {
> -               if (tmp->cap.cap_nr == cap)
> -                       return tmp;
> -       }
> -       return NULL;
> -}
> -
> -static inline void pci_add_saved_cap(struct pci_dev *pci_dev,
> -       struct pci_cap_saved_state *new_cap)
> -{
> -       hlist_add_head(&new_cap->next, &pci_dev->saved_cap_space);
> -}
> -
>  /*
>  * The first PCI_BRIDGE_RESOURCE_NUM PCI bus resources (those that correspond
>  * to P2P or CardBus bridge windows) go in a table.  Additional ones (for
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
