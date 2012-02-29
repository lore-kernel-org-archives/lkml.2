Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030408Ab2B2ScA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:32:00 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:35171 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030187Ab2B2Sb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:31:58 -0500
Date: Wed, 29 Feb 2012 10:31:52 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Hao, Xudong" <xudong.hao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kay, Allen M" <allen.m.kay@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: Re: [PATCH V2] Quirk for IVB graphics FLR errata
Message-ID: <20120229103152.59dcedd6@jbarnes-x220>
In-Reply-To: <403610A45A2B5242BD291EDAE8B37D300FCDA04B@SHSMSX102.ccr.corp.intel.com>
References: <403610A45A2B5242BD291EDAE8B37D300FCDA04B@SHSMSX102.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 174.253.241.144 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 03:11:24 +0000
"Hao, Xudong" <xudong.hao@intel.com> wrote:

> For IvyBridge Mobile platform, a system hang may occur if a
> FLR(Function Level Reset) is asserted to internal graphics.
> 
> This quirk patch is workaround for the IVB FLR errata issue.
> We are disabling the FLR reset handshake between the PCH and CPU
> display, then manually powering down the panel power sequencing and
> resetting the PCH display.
> 
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> Signed-off-by: Kay, Allen M <allen.m.kay@intel.com>
> ---
>  drivers/pci/quirks.c |   49
> +++++++++++++++++++++++++++++++++++++++++++++++++ 1 files changed, 49
> insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index
> 6476547..5223b80 100644 --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -29,6 +29,11 @@
>  #include <asm/dma.h>	/* isa_dma_bridge_buggy */
>  #include "pci.h"
>  
> +#include "../gpu/drm/i915/i915_reg.h"

Ugg... this is ugly.  Should probably go near the definition of the
quirk at any rate.

> +#include <asm/tsc.h>
> +/* 10 seconds */
> +#define IGD_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000)
> +

Same here, the asm/tsc.h can go at the top, but the timeout definition
should go near the reset function.

May as well make it a static const cycles_t as well.

> +#define MSG_CTL	0x45010
> +
> +static int reset_ivb_igd(struct pci_dev *dev, int probe) {
> +	u8 *mmio_base;
> +	u32 val;
> +
> +	if (probe)
> +		return 0;
> +
> +	mmio_base = ioremap_nocache(pci_resource_start(dev, 0),
> +				 pci_resource_len(dev, 0));
> +	if (!mmio_base)
> +		return -ENOMEM;
> +
> +	/* Work Around */
> +	*((u32 *)(mmio_base + MSG_CTL)) = 0x00000002;
> +	*((u32 *)(mmio_base + SOUTH_CHICKEN2)) = 0x00000005;
> +	val = *((u32 *)(mmio_base + PCH_PP_CONTROL)) & 0xfffffffe;
> +	*((u32 *)(mmio_base + PCH_PP_CONTROL)) = val;

These clobber existing values.  Since we're doing a reset, clobbering
PCH_PP_CONTROL should be ok, but clobbering SOUTH_CHICKEN2 is only ok
if the next driver that loads sets the right bits (if i915 was
previously using the device, it would have set a couple of bits).

But again since it's it a reset that's probably ok, but you should put
a comment indicating as much.

> +	do {
> +		cycles_t start_time = get_cycles();
> +		while (1) {
> +			val = *((u32 *)(mmio_base + PCH_PP_STATUS));
> +			if (((val & 0x80000000) == 0)
> +				&& ((val & 0x30000000) == 0))
> +				break;
> +			if (IGD_OPERATION_TIMEOUT < (get_cycles() -
> start_time))
> +				break;
> +			cpu_relax();
> +		}
> +	} while (0);
> +	*((u32 *)(mmio_base + 0xd0100)) = 0x00000002;
> +
> +	iounmap(pci_resource_start(dev, 0));
> +	return 0;
> +}
> +
>  #define PCI_DEVICE_ID_INTEL_82599_SFP_VF   0x10ed
> +#define PCI_DEVICE_ID_INTEL_IVB_M_VGA      0x0156
> +#define PCI_DEVICE_ID_INTEL_IVB_M2_VGA     0x0166
>  
>  static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
>  	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82599_SFP_VF,
>  		 reset_intel_82599_sfp_virtfn },
> +	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IVB_M_VGA,
> +		reset_ivb_igd },
> +	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IVB_M2_VGA,
> +		reset_ivb_igd },
>  	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
>  		reset_intel_generic_dev },
>  	{ 0 }

Looks ok otherwise, thanks.

Jesse
