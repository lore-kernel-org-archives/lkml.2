Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2JAPwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:52:34 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62210 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2JAPwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:52:32 -0400
Message-ID: <5069BC3C.8070407@gmail.com>
Date: Mon, 01 Oct 2012 10:52:28 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH v2] dt: Document general interrupt controller bindings
References: <1348143410-32656-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1348143410-32656-1-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 07:16 AM, Thierry Reding wrote:
> In order to use a device as interrupt controller, it needs to be marked
> with the DT interrupt-controller property. This commit adds rudimentary
> documentation about the required standard properties and describes the
> most commonly used interrupt specifiers.
> 
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
> Changes in v2:
> - update interrupt client description as per Stephen's suggestions
> - use an example for the two cell specifier where both the client and
>   the parent use two cell specifiers, as suggested by Rob, to reduce
>   the possibility for confusion
> 

Applied.

Rob

>  .../bindings/interrupt-controller/interrupts.txt   | 95 ++++++++++++++++++++++
>  1 file changed, 95 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> 
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> new file mode 100644
> index 0000000..72a06c0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> @@ -0,0 +1,95 @@
> +Specifying interrupt information for devices
> +============================================
> +
> +1) Interrupt client nodes
> +-------------------------
> +
> +Nodes that describe devices which generate interrupts must contain an
> +"interrupts" property. This property must contain a list of interrupt
> +specifiers, one per output interrupt. The format of the interrupt specifier is
> +determined by the interrupt controller to which the interrupts are routed; see
> +section 2 below for details.
> +
> +The "interrupt-parent" property is used to specify the controller to which
> +interrupts are routed and contains a single phandle referring to the interrupt
> +controller node. This property is inherited, so it may be specified in an
> +interrupt client node or in any of its parent nodes.
> +
> +2) Interrupt controller nodes
> +-----------------------------
> +
> +A device is marked as an interrupt controller with the "interrupt-controller"
> +property. This is a empty, boolean property. An additional "#interrupt-cells"
> +property defines the number of cells needed to specify a single interrupt.
> +
> +It is the responsibility of the interrupt controller's binding to define the
> +length and format of the interrupt specifier. The following two variants are
> +commonly used:
> +
> +  a) one cell
> +  -----------
> +  The #interrupt-cells property is set to 1 and the single cell defines the
> +  index of the interrupt within the controller.
> +
> +  Example:
> +
> +	vic: intc@10140000 {
> +		compatible = "arm,versatile-vic";
> +		interrupt-controller;
> +		#interrupt-cells = <1>;
> +		reg = <0x10140000 0x1000>;
> +	};
> +
> +	sic: intc@10003000 {
> +		compatible = "arm,versatile-sic";
> +		interrupt-controller;
> +		#interrupt-cells = <1>;
> +		reg = <0x10003000 0x1000>;
> +		interrupt-parent = <&vic>;
> +		interrupts = <31>; /* Cascaded to vic */
> +	};
> +
> +  b) two cells
> +  ------------
> +  The #interrupt-cells property is set to 2 and the first cell defines the
> +  index of the interrupt within the controller, while the second cell is used
> +  to specify any of the following flags:
> +    - bits[3:0] trigger type and level flags
> +        1 = low-to-high edge triggered
> +        2 = high-to-low edge triggered
> +        4 = active high level-sensitive
> +        8 = active low level-sensitive
> +
> +  Example:
> +
> +	i2c@7000c000 {
> +		gpioext: gpio-adnp@41 {
> +			compatible = "ad,gpio-adnp";
> +			reg = <0x41>;
> +
> +			interrupt-parent = <&gpio>;
> +			interrupts = <160 1>;
> +
> +			gpio-controller;
> +			#gpio-cells = <1>;
> +
> +			interrupt-controller;
> +			#interrupt-cells = <2>;
> +
> +			nr-gpios = <64>;
> +		};
> +
> +		sx8634@2b {
> +			compatible = "smtc,sx8634";
> +			reg = <0x2b>;
> +
> +			interrupt-parent = <&gpioext>;
> +			interrupts = <3 0x8>;
> +
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			threshold = <0x40>;
> +			sensitivity = <7>;
> +		};
> +	};
> 
