Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2EGQ2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:28:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46655 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756701Ab2EGQ2Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:28:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120506151156.GA13805@hp-xd.sh.intel.com>
References: <20120506151156.GA13805@hp-xd.sh.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 7 May 2012 09:27:54 -0700
Message-ID: <CAErSpo5-iwY1X6GrKzEAHM=eZS1hs_6wNV1fB0GhLuo3YQcV-A@mail.gmail.com>
Subject: Re: [PATCH] PCI: save/restore max Latency Value for device LTR
To: Xudong Hao <xudong.hao@linux.intel.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, xiantao.zhang@intel.com, xudong.hao@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 6, 2012 at 8:11 AM, Xudong Hao <xudong.hao@linux.intel.com> wrote:
> LTR: Save Max snoop/no-snoop Latency Value in pci_save_pcie_state, and restore them in pci_restore_pcie_state.
>
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
>
> ---
>  drivers/pci/pci.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 111569c..c8573c3 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -875,6 +875,12 @@ static int pci_save_pcie_state(struct pci_dev *dev)
>        pci_read_config_word(dev, pos + PCI_EXP_LNKCTL2, &cap[i++]);
>    if (pcie_cap_has_sltctl2(dev->pcie_type, flags))
>        pci_read_config_word(dev, pos + PCI_EXP_SLTCTL2, &cap[i++]);
> +   if (pci_ltr_supported(dev)) {
> +       pci_read_config_word(dev, pos + PCI_LTR_MAX_SNOOP_LAT,
> +                           &cap[i++]);
> +       pci_read_config_word(dev, pos + PCI_LTR_MAX_NOSNOOP_LAT,
> +                           &cap[i++]);
> +   }
>
>    return 0;
>  }
> @@ -908,6 +914,12 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
>        pci_write_config_word(dev, pos + PCI_EXP_LNKCTL2, cap[i++]);
>    if (pcie_cap_has_sltctl2(dev->pcie_type, flags))
>        pci_write_config_word(dev, pos + PCI_EXP_SLTCTL2, cap[i++]);
> +   if (pci_ltr_supported(dev)) {
> +       pci_write_config_word(dev, pos + PCI_LTR_MAX_SNOOP_LAT,
> +                           cap[i++]);
> +       pci_write_config_word(dev, pos + PCI_LTR_MAX_NOSNOOP_LAT,
> +                           cap[i++]);
> +   }
>  }
>

This doesn't make any sense to me.  "pos" is the offset of the PCI
Express Capability (identifier 10h).  LTR is a separate extended
capability (identifier 18h), so you at least have to look up its
offset.

Bjorn
