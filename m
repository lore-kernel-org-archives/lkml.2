Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1IQP4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 11:56:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41815 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab1IQP4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 11:56:16 -0400
Date: Sat, 17 Sep 2011 09:56:15 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2 RESEND 2] gpio-vx855: add device tree binding
Message-ID: <20110917155615.GT3523@ponder.secretlab.ca>
References: <20110916181220.E12109D401C@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916181220.E12109D401C@zog.reactivated.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 07:12:20PM +0100, Daniel Drake wrote:
> This is needed to enable the HDD LED on the OLPC XO-1.5 laptop,
> enabled through devicetree and the gpio-leds driver.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  .../devicetree/bindings/gpio/gpio_vx855.txt        |   20 ++++++++++++++++++++
>  drivers/gpio/gpio-vx855.c                          |    5 +++++
>  2 files changed, 25 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio_vx855.txt
> 
> v2: extended the documentation with information about the pin numbering
> scheme, which matches that of the driver.
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio_vx855.txt b/Documentation/devicetree/bindings/gpio/gpio_vx855.txt
> new file mode 100644
> index 0000000..17285a5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio_vx855.txt
> @@ -0,0 +1,20 @@
> +VIA VX855 GPIO controller
> +
> +Required properties:
> +- compatible : "via,vx855-gpio"
> +- #gpio-cells : Should be two. The first cell is the pin number and the
> +  second cell is used to specify optional parameters:
> +  - bit 0 specifies polarity (0 for normal, 1 for inverted)
> +- gpio-controller : Marks the device node as a GPIO controller.
> +
> +As VIA differentiates between GPI, GPO and GPIO on its 42 available pins,
> +with each pin type restarting numbering at 0, the following numbering scheme
> +is used in the device tree for the pin number:
> +
> +PIN NO		VIA NAME
> +0..13		GPI 0..13
> +14..26		GPO 0..12
> +27..41		GPIO 0..14
> +
> +For example, GPIO 11 (VIA name) is referred to with pin number 38 in the
> +device tree.

Binding looks good.

> diff --git a/drivers/gpio/gpio-vx855.c b/drivers/gpio/gpio-vx855.c
> index ef5aabd..5b7e9ba 100644
> --- a/drivers/gpio/gpio-vx855.c
> +++ b/drivers/gpio/gpio-vx855.c
> @@ -31,6 +31,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/pci.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
>  
>  #define MODULE_NAME "vx855_gpio"
>  
> @@ -216,6 +217,10 @@ static void vx855gpio_gpio_setup(struct vx855_gpio *vg)
>  	c->ngpio = NR_VX855_GP;
>  	c->can_sleep = 0;
>  	c->names = vx855gpio_names;
> +
> +#ifdef CONFIG_OF_GPIO
> +	c->of_node = of_find_compatible_node(NULL, NULL, "via,vx855-gpio");
> +#endif

drivers/mfd/vx855.c should be modified to assign pdev->of_node, which
can be used here for setting up c->of_node.  Also, if there is any
possibility of more than one of these being in a system, then you
should use something like of_find_matching_node_by_address() for
additional safety.

g.
