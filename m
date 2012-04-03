Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab2DCI3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:29:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2DCI3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:29:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH] gpio: Device tree support for LPC32xx
Date: Tue, 3 Apr 2012 08:29:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
References: <1333407513-18231-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1333407513-18231-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204030829.21911.arnd@arndb.de>
X-Provags-ID: V02:K0:yzzYcwKMElbC2RshVImAUpvRph2qdifPQW8r5g+ywgD
 g1QbTTSx9LlboepXBUSDCnu82EtIYeaRIbv1qJnhe2A08kj9Vl
 T8XZjZHnFbQIFCLrUJW55pTwbBYjpmdZh24MQHtfzTVmg0ve6n
 Kt4r3ODbq1OBE18nLlEhPEv9oUWQXf5AQhJW9Q8VsGsKKDIVGQ
 iD2ZEthgjKdjbE3Mm03YHrzHNzF0tH42B+DnoDBrl3T/SdgxfF
 Rmqp+a7dxMNs2PDWv1lNmTeKbpbGprbTaq7zNvAefF6F9C1fJg
 eTykYTgYRHwUJWXjZbika0KDy1nWUzSaXzPHGOdZRGUdUpHBen
 2OXZGc44uK9NkSZC3kTo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2012, Roland Stigge wrote:
> This patch adds device tree support for gpio-lpc32xx.c
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Hi Roland,

I'm glad it worked. Some more comments:

> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt
> @@ -0,0 +1,71 @@
> +NXP LPC32xx SoC GPIO controller
> +
> +Required properties:
> +- compatible: "nxp,lpc32xx-gpio"
> +- reg: Physical base address and length of the controller's registers.
> +- #address-cells: For indexing of the subnodes (GPIO groups of the SoC)
> +- #size-cells: Always 0
> +- #gpio-cells: Should be two. The first cell is the pin number and the
> +  second cell is used to specify optional parameters:
> +  - bit 0 specifies polarity (0 for normal, 1 for inverted)

The description for #address-cells should mention that it's always <1>.
There should be no #gpio-cells in this node.

> +Required properties of sub-nodes which describe the GPIO groups of LPC32xx:
> +- gpio-controller: Marks the device node as a GPIO controller.
> +- #gpio-cells: Should be two. The first cell is the pin number and the
> +  second cell is used to specify optional parameters:
> +  - bit 0 specifies polarity (0 for normal, 1 for inverted)
> +- reg: Index of the GPIO group
> +- gpio-lines: Number of GPIOs in that subnode/GPIO group

While I suggested the gpio-lines property, I'm not sure if it's worth
including it when you don't actually use it.

You could add code to the probe function that sets the respective
fields in the gpio_chip structure, which would be particularly
interesting when you disable the unused banks by adding a
status="disabled" property (you already check for of_device_is_available()
in the loop). That will only work after all your gpio using code has
been converted to device tree probing, because it means the
hardcoded numbers don't work any more.

You can also let the user change that number if only the first X gpios
in one bank are actually used, or if some lpc32xx variants have fewer
gpio pins than others.

	Arnd
