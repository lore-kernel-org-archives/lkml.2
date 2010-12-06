Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab0LFRef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:34:35 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:46689 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752577Ab0LFRee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:34:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=tLJPpGvwtlbMfUCI3xV78o9/uCzaDqApy4IftFb3MLQUe1n4mQ1+tfY4jsI9BxGRYiSI7aVdTD0I5BcOaX7kw8O3qioFiephiqMFsOQz6k+i7fkMQ6/0oF7fkNiL3ea5;
Date: Mon, 6 Dec 2010 09:27:49 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Max Asbock <masbock@linux.vnet.ibm.com>, indou.takao@jp.fujitsu.com,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@kernel.org
Subject: Re: [patch 1/4] vt-d: quirk for masking vtd spec errors to platform
 error handling logic
Message-ID: <20101206092749.7f89f3fd@jbarnes-desktop>
In-Reply-To: <20101201062244.365995600@intel.com>
References: <20101201062225.292364637@intel.com>
	<20101201062244.365995600@intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 22:22:26 -0800
Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On platforms with Intel 7500 chipset, there were some reports of system
> hang/NMI's during kexec/kdump in the presence of interrupt-remapping enabled.
> 
> During kdump, there is a window where the devices might be still using old
> kernel's interrupt information, while the kdump kernel is coming up. This can
> cause vt-d faults as the interrupt configuration from the old kernel map to
> null IRTE entries in the new kernel etc. (with out interrupt-remapping enabled,
> we still have the same issue but in this case we will see benign spurious
> interrupt hit the new kernel).
> 
> Based on platform config settings, these platforms seem to generate NMI/SMI
> when a vt-d fault happens and there were reports that the resulting SMI causes
> the  system to hang.
> 
> Fix it by masking vt-d spec defined errors to platform error reporting logic.
> VT-d spec related errors are already handled by the VT-d OS code, so need to
> report the same erorr through other channels.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: stable@kernel.org [v2.6.32+]
> ---
>  drivers/pci/quirks.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> Index: tip/drivers/pci/quirks.c
> ===================================================================
> --- tip.orig/drivers/pci/quirks.c
> +++ tip/drivers/pci/quirks.c
> @@ -2764,6 +2764,26 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RI
>  DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
>  #endif /*CONFIG_MMC_RICOH_MMC*/
>  
> +#if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
> +/*
> + * This is a quirk for masking vt-d spec defined errors to platform error
> + * handling logic. With out this, platforms seem to generate NMI/SMI (based
> + * on the RAS config settings of the platform) when a vt-d fault happens and
> + * there were reports that the resulting SMI causes system to hang.
> + *
> + * VT-d spec related errors are already handled by the VT-d OS code, so no
> + * need to report the same erorr through other channels.
> + */
> +static void vtd_mask_spec_errors(struct pci_dev *dev)
> +{
> +	u32 word;
> +
> +	pci_read_config_dword(dev, 0x1AC, &word);
> +	pci_write_config_dword(dev, 0x1AC, word | (1 << 31));
> +}
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x342e, vtd_mask_spec_errors);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x3c28, vtd_mask_spec_errors);
> +#endif
>  
>  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
>  			  struct pci_fixup *end)

Can we make these registers and bits a bit more self-documenting (i.e.
#defines for both, maybe along with other useful bit definitions for
this reg)? Also, "error" is misspelled as "erorr" above. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
