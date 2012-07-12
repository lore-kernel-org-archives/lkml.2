Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161310Ab2GLQbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:31:52 -0400
Received: from mout6.freenet.de ([195.4.92.96]:55405 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933647Ab2GLQbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:31:51 -0400
Message-Id: <201207121629.q6CGTatR003685@mail.maya.org>
Date: Thu, 12 Jul 2012 18:29:37 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Joerg.Roedel@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] pci: ACS quirk for AMD southbridge
In-Reply-To: <20120712050653.20439.11009.stgit@bling.home>
References: <20120712050653.20439.11009.stgit@bling.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alex,

I tested the patch below against linux 3.4.4 and with this
PCI WLAN-device:

06:07.0 Network controller: Ralink corp. RT2800 802.11n PCI
06:07.0 0280: 1814:0601

The device resides behind a PCI to PCI bridge:

00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to PCI Bridge (rev 40) (prog-if 01 [Subtractive decode])
00:14.4 0604: 1002:4384 (rev 40) (prog-if 01 [Subtractive decode])

The device works fine in kvm / 64bit. Surprisingly, it isn't necessary
at all to put the PCI to PCI bridge to the VM. It's enough to put the
WLAN-device to the VM and bind it to vfio-pci. That's all. The bridge
isn't bound to vfio-pci (it's bound to nothing).

I stripped off linux-pci because I'm no member of this list.


Thanks.
kind regards,
Andreas


Alex Williamson wrote:
> We've confirmed that peer-to-peer between these devices is
> not possible.  We can therefore claim that they support a
> subset of ACS.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Tested-by: Andreas Hartmann <andihartmann@01019freenet.de>
> Cc: Joerg Roedel <Joerg.Roedel@amd.com>
> ---
> 
> Two things about this patch make me a little nervous.  The
> first is that I'd really like to have a pci_is_pcie() test
> in pci_mf_no_p2p_acs_enabled(), but these devices don't
> have a PCIe capability.  That means that if there was a
> topology where these devices sit on a legacy PCI bus,
> we incorrectly return that we're ACS safe here.  That leads
> to my second problem, pciids seems to suggest that some of
> these functions have been around for a while.  Is it just
> this package that's peer-to-peer safe, or is it safe to
> assume that any previous assembly of these functions is
> also p2p safe.  Maybe we need to factor in device revs if
> that uniquely identifies this package?
> 
> Looks like another useful device to potentially quirk
> would be:
> 
> 00:15.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0)
> 00:15.1 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1)
> 00:15.2 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB900 PCI to PCI bridge (PCIE port 2)
> 00:15.3 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB900 PCI to PCI bridge (PCIE port 3)
> 
> 00:15.0 0604: 1002:43a0
> 00:15.1 0604: 1002:43a1
> 00:15.2 0604: 1002:43a2
> 00:15.3 0604: 1002:43a3
> 
>  drivers/pci/quirks.c |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 4ebc865..2c84961 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3271,11 +3271,40 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
>  	return pci_dev_get(dev);
>  }
>  
> +/*
> + * Multifunction devices that do not support peer-to-peer between
> + * functions can claim to support a subset of ACS.  Such devices
> + * effectively enable request redirect (RR) and completion redirect (CR)
> + * since all transactions are redirected to the upstream root complex.
> + */
> +static int pci_mf_no_p2p_acs_enabled(struct pci_dev *dev, u16 acs_flags)
> +{
> +	if (!dev->multifunction)
> +		return -ENODEV;
> +
> +	/* Filter out flags not applicable to multifunction */
> +	acs_flags &= (PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC | PCI_ACS_DT);
> +
> +	return acs_flags & ~(PCI_ACS_RR | PCI_ACS_CR) ? 0 : 1;
> +}
> +
>  static const struct pci_dev_acs_enabled {
>  	u16 vendor;
>  	u16 device;
>  	int (*acs_enabled)(struct pci_dev *dev, u16 acs_flags);
>  } pci_dev_acs_enabled[] = {
> +	/*
> +	 * AMD/ATI multifunction southbridge devices.  AMD has confirmed
> +	 * that peer-to-peer between these devices is not possible, so
> +	 * they do support a subset of ACS even though the capability is
> +	 * not exposed in config space.
> +	 */
> +	{ PCI_VENDOR_ID_ATI, 0x4385, pci_mf_no_p2p_acs_enabled },
> +	{ PCI_VENDOR_ID_ATI, 0x439c, pci_mf_no_p2p_acs_enabled },
> +	{ PCI_VENDOR_ID_ATI, 0x4383, pci_mf_no_p2p_acs_enabled },
> +	{ PCI_VENDOR_ID_ATI, 0x439d, pci_mf_no_p2p_acs_enabled },
> +	{ PCI_VENDOR_ID_ATI, 0x4384, pci_mf_no_p2p_acs_enabled },
> +	{ PCI_VENDOR_ID_ATI, 0x4399, pci_mf_no_p2p_acs_enabled },
>  	{ 0 }
>  };
>  
> 
