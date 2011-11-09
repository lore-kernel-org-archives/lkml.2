Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab1KISj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 13:39:57 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48041 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1KISj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 13:39:56 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX180R9nUb4cbSp7/AmR/nki5
Date: Wed, 9 Nov 2011 10:39:45 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 6/8] of: add clock providers
Message-ID: <20111109183945.GL31337@atomide.com>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
 <1320801583-12774-7-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320801583-12774-7-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@secretlab.ca> [111108 16:51]:
> +
> +    /* external oscillator */
> +    osc: oscillator {
> +        compatible = "fixed-clock";
> +        #clock-cells = <1>;
> +        frequency  = <32678>;
> +        clock-output-name = "osc";
> +    };
> +
> +    /* phase-locked-loop device, generates a higher frequency clock
> +     * from the external oscillator reference */
> +    pll: pll {
> +        compatible = "some-pll-interface"
> +        #clock-cells = <1>;
> +        clock-input = <&osc 0>;
> +        clock-input-name = "ref";
> +        reg = <0x4c000 0x1000>;
> +        clock-output-name = "pll", "pll-switched";
> +    };

I think for the clocks we need something describing which bits
in the clock register the "pll" and "pll-switched" belong to.

Otherwise we'll end up having to map all that data in the clock
driver for various SoC variants.

> +    /* UART, using the low frequency oscillator for the baud clock,
> +     * and the high frequency switched PLL output for register
> +     * clocking */
> +    uart {
> +        compatible = "fsl,imx-uart";
> +        reg = <0xa000 0x1000>;
> +        interrupts = <33>;
> +        clock-input = <&osc 0>, <&pll 1>;
> +        clock-input-name = "baud", "register";
> +    };
> +

Here I think we need a better solution for finding the
clocks by name. Doing clock-input = <&osc 0>, <&pll 1> means
that we have redefine the uart for similar SoC many times.

How about using source + option in the name instead:

	   clock-source-name = "osc.osc", "pll.pll-switched";

This same solution would also work for the pinctrl names:

	   pinctrl-source-name = "uart1_rx.uart1_rx", "dss_data7.uart1_tx";

The reason I'm worried here is that just for omap2/3/4 we already
have 3 options for uart1 clock and 19 options for uart1_rx pin!

Using the signal names for both clocks and pinctrl would
allow defining the uart entry for for each reg address instead
of for each clock and pinctrl option.

Regards,

Tony
