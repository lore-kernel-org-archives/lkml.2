Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab2FLRIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:08:13 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33691 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752807Ab2FLRIL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:08:11 -0400
MIME-Version: 1.0
In-Reply-To: <1339142492-13625-5-git-send-email-xudong.hao@intel.com>
References: <1339142492-13625-1-git-send-email-xudong.hao@intel.com> <1339142492-13625-5-git-send-email-xudong.hao@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 12 Jun 2012 11:07:48 -0600
Message-ID: <CAErSpo6VuffgjUh3nguFH3E8fPmwA2Hj+C+pXZsYN7h_C9M5Kg@mail.gmail.com>
Subject: Re: [PATCH 4/4] PCI: save/restore max Latency Value for device LTR
To: Xudong Hao <xudong.hao@intel.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, alex.williamson@redhat.com,
        ddutile@redhat.com, myron.stowe@redhat.com, xiantao.zhang@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 2:01 AM, Xudong Hao <xudong.hao@intel.com> wrote:
> LTR: Save Max snoop/no-snoop Latency Value in pci_save_pcie_state, and restore
> them in pci_restore_pcie_state.
>
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> ---
>  drivers/pci/pci.c   |   71 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  drivers/pci/probe.c |    5 +++-
>  2 files changed, 71 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 35127c1..7172f15 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -912,6 +912,54 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
>                pci_write_config_word(dev, pos + PCI_EXP_SLTCTL2, cap[i++]);
>  }
>
> +#define PCI_LTR_SAVE_REGS      2
> +
> +static int pci_save_ltr_value(struct pci_dev *dev)
> +{
> +       int i = 0, pos;
> +       struct pci_cap_saved_state *save_state;
> +       u16 *cap;
> +       u16 ctrl;
> +
> +       pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_LTR);
> +       if (!pos)
> +               return -ENOTSUPP;
> +
> +       /* Check if LTR is eanbled before save value */
> +       pci_read_config_word(dev, pos + PCI_EXP_DEVCTL2, &ctrl);

This is totally broken.  "pos" is the LTR Extended Capability (spec
section 7.25).  PCI_EXP_DEVCTL2 is a field in the PCI Express
Capability structure (section 7.8).

> +       if (!(ctrl & PCI_EXP_LTR_EN))
> +               return -ENOTSUPP;
> +
> +       save_state = pci_find_saved_cap(dev, PCI_EXT_CAP_ID_LTR);
> +       if (!save_state) {
> +               dev_err(&dev->dev, "buffer not found in %s\n", __func__);
> +               return -ENOMEM;
> +       }
> +       cap = (u16 *)&save_state->cap.data[0];
> +
> +       pci_read_config_word(dev, pos + PCI_LTR_MAX_SNOOP_LAT, &cap[i++]);
> +       pci_read_config_word(dev, pos + PCI_LTR_MAX_NOSNOOP_LAT, &cap[i++]);
> +       return 0;
> +}
> +
> +static void pci_restore_ltr_value(struct pci_dev *dev)
> +{
> +       int i = 0, pos;
> +       struct pci_cap_saved_state *save_state;
> +       u16 *cap;
> +
> +       if (!pci_ltr_supported(dev))
> +               return;
> +
> +       save_state = pci_find_saved_cap(dev, PCI_EXT_CAP_ID_LTR);
> +       pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_LTR);
> +       if (!save_state || !pos)
> +               return;
> +       cap = (u16 *)&save_state->cap.data[0];
> +
> +       pci_write_config_word(dev, pos + PCI_LTR_MAX_SNOOP_LAT, cap[i++]);
> +       pci_write_config_word(dev, pos + PCI_LTR_MAX_NOSNOOP_LAT, cap[i++]);
> +}
>
>  static int pci_save_pcix_state(struct pci_dev *dev)
>  {
> @@ -966,6 +1014,11 @@ pci_save_state(struct pci_dev *dev)
>                return i;
>        if ((i = pci_save_pcix_state(dev)) != 0)
>                return i;
> +
> +       if (pci_ltr_supported(dev))
> +               if ((i = pci_save_ltr_value(dev)) != 0)
> +                       return i;
> +
>        return 0;
>  }
>
> @@ -1034,6 +1087,7 @@ void pci_restore_state(struct pci_dev *dev)
>        pci_restore_pcix_state(dev);
>        pci_restore_msi_state(dev);
>        pci_restore_iov_state(dev);
> +       pci_restore_ltr_value(dev);
>
>        dev->state_saved = false;
>  }
> @@ -1955,12 +2009,15 @@ static void pci_add_saved_cap(struct pci_dev *pci_dev,
>  * @size: requested size of the buffer
>  */
>  static int pci_add_cap_save_buffer(
> -       struct pci_dev *dev, char cap, unsigned int size)
> +       struct pci_dev *dev, char cap, unsigned int size, bool is_extcap)
>  {
>        int pos;
>        struct pci_cap_saved_state *save_state;
>
> -       pos = pci_find_capability(dev, cap);
> +       if (is_extcap)
> +               pos = pci_find_ext_capability(dev, cap);
> +       else
> +               pos = pci_find_capability(dev, cap);
>        if (pos <= 0)
>                return 0;
>
> @@ -1984,15 +2041,21 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev)
>        int error;
>
>        error = pci_add_cap_save_buffer(dev, PCI_CAP_ID_EXP,
> -                                       PCI_EXP_SAVE_REGS * sizeof(u16));
> +                                       PCI_EXP_SAVE_REGS * sizeof(u16), 0);
>        if (error)
>                dev_err(&dev->dev,
>                        "unable to preallocate PCI Express save buffer\n");
>
> -       error = pci_add_cap_save_buffer(dev, PCI_CAP_ID_PCIX, sizeof(u16));
> +       error = pci_add_cap_save_buffer(dev, PCI_CAP_ID_PCIX, sizeof(u16), 0);
>        if (error)
>                dev_err(&dev->dev,
>                        "unable to preallocate PCI-X save buffer\n");
> +
> +       error = pci_add_cap_save_buffer(dev, PCI_EXT_CAP_ID_LTR,
> +                                       PCI_LTR_SAVE_REGS * sizeof(u16), 1);
> +       if (error)
> +               dev_err(&dev->dev,
> +                       "unable to preallocate LTR save buffer\n");
>  }
>
>  void pci_free_cap_save_buffers(struct pci_dev *dev)
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 658ac97..a6eb509 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1232,7 +1232,10 @@ static void pci_init_capabilities(struct pci_dev *dev)
>        /* MSI/MSI-X list */
>        pci_msi_init_pci_dev(dev);
>
> -       /* Buffers for saving PCIe and PCI-X capabilities */
> +       /*
> +        * Buffers for saving PCIe and PCI-X capabilities
> +        * and for saving LTR extented capabilities.
> +        */
>        pci_allocate_cap_save_buffers(dev);
>
>        /* Power Management */
> --
> 1.5.5
>
