Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab1INRwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 13:52:49 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50551 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754950Ab1INRws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 13:52:48 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Sep 2011 13:52:47 EDT
Message-ID: <4E70E88E.4090503@arm.com>
Date: Wed, 14 Sep 2011 18:46:54 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-6-git-send-email-robherring2@gmail.com>
In-Reply-To: <1316017900-19918-6-git-send-email-robherring2@gmail.com>
X-Enigmail-Version: 1.2.1
X-OriginalArrivalTime: 14 Sep 2011 17:46:33.0661 (UTC) FILETIME=[3E267ED0:01CC7306]
X-MC-Unique: 111091418463800701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/09/11 17:31, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This adds gic initialization using device tree data. The initialization
> functions are intended to be called by a generic OF interrupt
> controller parsing function once the right pieces are in place.
> 
> PPIs are handled using 3rd cell of interrupts properties to specify the cpu
> mask the PPI is assigned to.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> ---
>  Documentation/devicetree/bindings/arm/gic.txt |   53 ++++++++++++++++++++++++
>  arch/arm/common/gic.c                         |   55 +++++++++++++++++++++++--
>  arch/arm/include/asm/hardware/gic.h           |   10 +++++
>  3 files changed, 114 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/gic.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
> new file mode 100644
> index 0000000..6c513de
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/gic.txt
> @@ -0,0 +1,53 @@
> +* ARM Generic Interrupt Controller
> +
> +ARM SMP cores are often associated with a GIC, providing per processor
> +interrupts (PPI), shared processor interrupts (SPI) and software
> +generated interrupts (SGI).
> +
> +Primary GIC is attached directly to the CPU and typically has PPIs and SGIs.
> +Secondary GICs are cascaded into the upward interrupt controller and do not
> +have PPIs or SGIs.
> +
> +Main node required properties:
> +
> +- compatible : should be one of:
> +	"arm,cortex-a9-gic"
> +	"arm,arm11mp-gic"
> +- interrupt-controller : Identifies the node as an interrupt controller
> +- #interrupt-cells : Specifies the number of cells needed to encode an
> +  interrupt source.  The type shall be a <u32> and the value shall be 3.
> +
> +  The 1st cell is the interrupt number. 0-15 are reserved for SGIs. 16-31 are
> +  for PPIs.
> +
> +  The 2nd cell is the level-sense information, encoded as follows:
> +                    1 = low-to-high edge triggered
> +                    2 = high-to-low edge triggered
> +                    4 = active high level-sensitive
> +                    8 = active low level-sensitive
> +
> +  Only values of 1 and 4 are valid for GIC 1.0 spec.
> +
> +  The 3rd cell contains the mask of the cpu number for the interrupt source.
> +  The cpu mask is only valid for PPIs and shall be 0 for SPIs. This value shall
> +  be 0 for PPIs.
     ^^^^^^^^^^^^^

Typo here ? The way I understand it, it should read "For PPIs, this
value shall be the mask of the possible CPU numbers for the interrupt
source" (or something to similar effect...).

	M.
-- 
Jazz is not dead. It just smells funny...

