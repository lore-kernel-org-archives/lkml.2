Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1KUPZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:25:17 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:12397
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808Ab1KUPZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:25:15 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 21 Nov 2011 23:37:18 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 6/8] of: add clock providers
Message-ID: <20111121153716.GA16417@S2100-06.ap.freescale.net>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
 <1320801583-12774-7-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1320801583-12774-7-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 06:19:41PM -0700, Grant Likely wrote:
> Based on work by Ben Herrenschmidt and Jeremy Kerr, this patch adds an
> of_clk_get function to allow platforms to retrieve clock data from the
> device tree.
> 
> Platform register a provider through of_clk_add_provider, which will be
> called when a device references the provider's OF node for a clock
> reference.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  .../devicetree/bindings/clock/clock-bindings.txt   |  109 +++++++++++++++++
>  drivers/of/Kconfig                                 |    6 +
>  drivers/of/Makefile                                |    1 +
>  drivers/of/clock.c                                 |  129 ++++++++++++++++++++
>  include/linux/of_clk.h                             |   37 ++++++
>  5 files changed, 282 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/clock-bindings.txt
>  create mode 100644 drivers/of/clock.c
>  create mode 100644 include/linux/of_clk.h
> 
> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> new file mode 100644
> index 0000000..4770c7e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> @@ -0,0 +1,109 @@
> +This binding is a work-in-progress, and are based on some experimental
> +work by benh[1].
> +
> +Sources of clock signal can be represented by any node in the device
> +tree.  Those nodes are designated as clock providers.  Clock consumer
> +nodes use a phandle and clock specifier pair to connect clock provider
> +outputs to clock inputs.  Similar to the gpio specifiers, a clock
> +specifier is an array of one more more cells identifying the clock
> +output on a device.  The length of a clock specifier is defined by the
> +value of a #clock-cells property in the clock provider node.
> +
> +[1] http://patchwork.ozlabs.org/patch/31551/
> +
> +==Clock providers==
> +
> +Required properties:
> +#clock-cells:	   Number of cells in a clock specifier; typically will be
> +		   set to 1
> +
> +Optional properties:
> +clock-output-name: Recommended to be a list of strings of clock output signal
> +		   names indexed by the first cell in the clock specifier.
> +		   However, the meaning of clock-output-names is domain

s/clock-output-names/clock-output-name?

> +		   specific to the clock provider, and is only provided to
> +		   encourage using the same meaning for the majority of clock
> +		   providers.  This format may not work for clock providers
> +		   using a complex clock specifier format.  In those cases it
> +		   is recommended to omit this property and create a binding
> +		   specific names property.
> +
> +		   Clock consumer nodes must never directly reference
> +		   the provider's clock-output-names property.

s/clock-output-names/clock-output-name?

> +
> +For example:
> +
> +    oscillator {
> +        #clock-cells = <1>;
> +        clock-output-name = "ckil", "ckih";
> +    };
> +
> +- this node defines a device with two clock outputs, the first named
> +  "ckil" and the second named "ckih".  Consumer nodes always reference
> +  clocks by index. The names should reflect the clock output signal
> +  names for the device.
> +
> +==Clock consumers==
> +
> +Required properties:
> +clock-input:	List of phandle and clock specifier pairs, one pair
> +		for each clock input to the device.
> +clock-input-name: List of clock input name strings sorted in the same
> +		order as the clock-input property.  Consumers drivers
> +		will use clock-input-name to match clock input names
> +		with clock-input specifiers.
> +
> +For example:
> +
> +    uart {
> +        clock-input = <&osc 1> <&ref 0>;
				 ^
Comma is missed?

> +        clock-input-name = "baud", "register";
> +    };

[...]

> +struct clk *of_clk_get(struct device_node *np, int index)
> +{
> +	struct of_phandle_args clkspec;
> +	struct clk *clk;
> +	int rc;
> +
> +	if (index < 0)
> +		return NULL;
> +
> +	rc = of_parse_phandle_with_args(np, "clock", "#clock-cells", index,

According to binding document above, s/clock/clock-input?

> +					&clkspec);
> +	if (rc)
> +		return NULL;
> +
> +	clk = __of_clk_get_from_provider(&clkspec);
> +	of_node_put(clkspec.np);
> +	return clk;
> +}
> +
> +struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
> +{
> +	int index = 0;
> +
> +	if (name)
> +		index = of_property_match_string(np, "clock-input-names", name);

If it fails to match name, we may want to force 'index' back to 0.

Also according to binding document above,
s/clock-input-names/clock-input-name?  Hope you do not want to
change binding document to get them aligned.  I have written code
per binding document :)

Regards,
Shawn

> +	return of_clk_get(np, index);
> +}

