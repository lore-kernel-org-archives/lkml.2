Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2DPTEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:04:44 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:51541
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578Ab2DPTEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:04:41 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 16 Apr 2012 14:04:35 -0500
From: Scott Wood <scottwood@freescale.com>
To: chenhui zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <galak@kernel.crashing.org>
Subject: Re: fsl_pmc: update device bindings
Message-ID: <20120416190435.GA5992@schlenkerla.am.freescale.net>
References: <1331890262-25391-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1331890262-25391-1-git-send-email-chenhui.zhao@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 11:31:02PM -0000, chenhui zhao wrote:
> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt b/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
> index 07256b7..d296e88 100644
> --- a/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
> +++ b/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
> @@ -9,22 +9,26 @@ Properties:
>  
>    "fsl,mpc8548-pmc" should be listed for any chip whose PMC is
>    compatible.  "fsl,mpc8536-pmc" should also be listed for any chip
> -  whose PMC is compatible, and implies deep-sleep capability.
> +  whose PMC is compatible, and implies deep-sleep capability and
> +  wake on user defined packet(wakeup on ARP). "fsl,p1022-pmc"

s/packet(wakeup/packet (wakeup/

> +  should be listed for any chip whose PMC is compatible, and
> +  implies lossless Ethernet capability during sleep or deep sleep.

fsl,p1022-pmc also implies that deep sleep exists.

It should also imply JOG support, though so should fsl,mpc8536-pmc. 
Hopefully nothing has yet claimed compatibility with fsl,mpc8536-pmc that
doesn't have JOG (this writeup shouldn't be considered exhaustive
regarding what compatibility means).

>    "fsl,mpc8641d-pmc" should be listed for any chip whose PMC is
>    compatible; all statements below that apply to "fsl,mpc8548-pmc" also
>    apply to "fsl,mpc8641d-pmc".
>  
>    Compatibility does not include bit assignments in SCCR/PMCDR/DEVDISR; these
> -  bit assignments are indicated via the sleep specifier in each device's
> -  sleep property.
> +  bit assignments are indicated via the clock nodes. Device which has a

"Devices which have" or "A device which has"

> +  controllable clock source should have a "fsl,pmc-handle" property pointing
> +  to the clock node.
>  
>  - reg: For devices compatible with "fsl,mpc8349-pmc", the first resource
>    is the PMC block, and the second resource is the Clock Configuration
>    block.
>  
> -  For devices compatible with "fsl,mpc8548-pmc", the first resource
> -  is a 32-byte block beginning with DEVDISR.
> +  For devices compatible with "fsl,mpc8548-pmc", the resource is a 32-byte
> +  block beginning with the register DEVDISR.

What is this change for?  There's no requirement that other bindings
which are compatible with this one limit themselves to one resource.

>  - interrupts: For "fsl,mpc8349-pmc"-compatible devices, the first
>    resource is the PMC block interrupt.
> @@ -33,31 +37,42 @@ Properties:
>    this is a phandle to an "fsl,gtm" node on which timer 4 can be used as
>    a wakeup source from deep sleep.
>  
> -Sleep specifiers:
> -
> -  fsl,mpc8349-pmc: Sleep specifiers consist of one cell.  For each bit
> -  that is set in the cell, the corresponding bit in SCCR will be saved
> -  and cleared on suspend, and restored on resume.  This sleep controller
> -  supports disabling and resuming devices at any time.
> -
> -  fsl,mpc8536-pmc: Sleep specifiers consist of three cells, the third of
> -  which will be ORed into PMCDR upon suspend, and cleared from PMCDR
> -  upon resume.  The first two cells are as described for fsl,mpc8578-pmc.
> -  This sleep controller only supports disabling devices during system
> -  sleep, or permanently.
> +Clock nodes:
> +The clock nodes are to describe the masks in PM controller registers for each
> +soc clock.
> +- fsl,pmcdr-mask: For "fsl,mpc8548-pmc"-compatible devices, some blocks as
> +  wake-up sources can run in low power mode. If a block used as a wake-up
> +  source in low power mode, the corresponding bit in the register PMCDR should
> +  be cleared on suspend and set on resume. If setting bits of the mask,
> +  the corresponding blocks will be used as wake-up sources.

How about:

fsl,pmcdr: For "fsl,mpc8548-pmc"-compatible devices.  Some blocks can run
in low power mode as wake-up sources.  When entering low power mode, no
bit set in the "fsl,pmcdr" property of any device to be used as a wakeup
source shall be set in PMCDR.

> -  fsl,mpc8548-pmc: Sleep specifiers consist of one or two cells, the
> -  first of which will be ORed into DEVDISR (and the second into
> -  DEVDISR2, if present -- this cell should be zero or absent if the
> -  hardware does not have DEVDISR2) upon a request for permanent device
> -  disabling.  This sleep controller does not support configuring devices
> -  to disable during system sleep (unless supported by another compatible
> -  match), or dynamically.
> +- fsl,sccr-mask: For "fsl,mpc8349-pmc"-compatible devices, the corresponding
> +  bit specified by the mask in SCCR will be saved and cleared on suspend, and
> +  restored on resume.

fsl,sccr: For "fsl,mpc8349-pmc"-compatible devices.  The bits set in
a device's "fsl,sccr" property must be set in the SCCR register whenever
that device is to be clocked.

> -Example:
> +- fsl,devdisr-mask: Contain one or two cells, depending on the availability of
> +  DEVDISR2 register.  For compatible devices, the mask will be ORed into DEVDISR
> +  or DEVDISR2 when the clock should be permenently disabled.

fsl,devdisr: Contains two cells if DEVDISR2 is available, otherwise one
cell.  ORing the first cell into DEVDISR and the second cell (if present)
into DEVDISR2 will permanently disable the device (until SoC reset). 

For "fsl,pmcdr", "fsl,sccr", and "fsl,devdisr", more than one device may
contain the same or overlapping bit assignments.  Care must be taken not
to put such a bit in the disabled state unless all devices associated
with that bit are to be disabled.

> +Example 2:
> +	power@e0070 {
> +		compatible = "fsl,mpc8548-pmc", "fsl,mpc8536-pmc";

"fsl,mpc8536-pmc" is more specific and should come first.

-Scott

