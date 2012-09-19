Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab2ISPpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:45:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36599 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab2ISPpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:45:08 -0400
Message-ID: <5059E87E.7070603@gmail.com>
Date: Wed, 19 Sep 2012 10:45:02 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt: Document general interrupt controller bindings
References: <1348045056-29769-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1348045056-29769-1-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 03:57 AM, Thierry Reding wrote:
> In order to use a device as interrupt controller, it needs to be marked
> with the DT interrupt-controller property. This commit adds rudimentary
> documentation about the required standard properties and describes the
> most commonly used interrupt specifiers.
> 
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
> This patch is for Rob's tree as it documents the general bindings.
> 
>  .../bindings/interrupt-controller/interrupts.txt   | 94 ++++++++++++++++++++++
>  1 file changed, 94 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> 
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> new file mode 100644
> index 0000000..6cafe3a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> @@ -0,0 +1,94 @@
> +Specifying interrupt information for devices
> +============================================
> +
> +1) Interrupt user nodes
> +-----------------------
> +
> +A device that generates interrupts can specify the interrupt controller to
> +which the interrupts are routed by passing the controller's phandle in the
> +"interrupt-parent" property.
> +
> +The "interrupts" property is a list of specifiers that describe each of the
> +interrupts. See section 2 below for details.
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
> +	gpio: gpio {
> +		compatible = "nvidia,tegra20-gpio";
> +		reg = <0x6000d000 0x1000>;
> +		interrupts = <0 32 0x04
> +			      0 33 0x04
> +			      0 34 0x04
> +			      0 35 0x04
> +			      0 55 0x04
> +			      0 87 0x04
> +			      0 89 0x04>;

Might be better to have an example where the parent here also follows
the documentation. There's no reason this needs to match a real binding,
so you could just drop the 1st cell.

Otherwise, I'll wait for Stephen to comment before I pick it up.

Rob

> +		#gpio-cells = <2>;
> +		gpio-controller;
> +		#interrupt-cells = <2>;
> +		interrupt-controller;
> +	};
> +
> +	i2c@7000c000 {
> +		status = "okay";
> +		clock-frequency = <400000>;
> +
> +		wm8903: wm8903@1a {
> +			compatible = "wlf,wm8903";
> +			reg = <0x1a>;
> +			interrupt-parent = <&gpio>;
> +			interrupts = <187 0x04>;
> +
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +
> +			micdet-cfg = <0>;
> +			micdet-delay = <100>;
> +			gpio-cfg = <0xffffffff 0xffffffff 0 0xffffffff 0xffffffff>;
> +		};
> +	};
> 

