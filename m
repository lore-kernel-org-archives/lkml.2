Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1BWQZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 11:25:45 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34161 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab1BWQZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:25:43 -0500
Date: Wed, 23 Feb 2011 09:25:38 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [RFC PATCH 07/10] i2c: Convert i2c-octeon.c to use device tree.
Message-ID: <20110223162538.GB14597@angua.secretlab.ca>
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
 <1298408274-20856-8-git-send-email-ddaney@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298408274-20856-8-git-send-email-ddaney@caviumnetworks.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 12:57:51PM -0800, David Daney wrote:
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
> Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
> Cc: linux-i2c@vger.kernel.org
> ---
>  arch/mips/cavium-octeon/octeon-platform.c |   84 ---------------------------
>  arch/mips/include/asm/octeon/octeon.h     |    5 --
>  drivers/i2c/busses/i2c-octeon.c           |   88 +++++++++++++---------------
>  3 files changed, 41 insertions(+), 136 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
> index 56dbe54..99a20c6 100644
> --- a/drivers/i2c/busses/i2c-octeon.c
> +++ b/drivers/i2c/busses/i2c-octeon.c
> @@ -11,17 +11,21 @@
>   * warranty of any kind, whether express or implied.
>   */
>  
> +#include <linux/platform_device.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_address.h>
> +#include <linux/interrupt.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_i2c.h>

Nit: generally the of_*.h headers are kept together.  Also this patch
probably won't need of_address.h or of_irq.h after addressing my
comments below.

> +#include <linux/delay.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/init.h>
> -
> -#include <linux/io.h>
>  #include <linux/i2c.h>
> -#include <linux/interrupt.h>
> -#include <linux/delay.h>
> -#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
>  
>  #include <asm/octeon/octeon.h>
>  
> @@ -67,9 +71,7 @@ struct octeon_i2c {
>  	int irq;
>  	int twsi_freq;
>  	int sys_freq;
> -	resource_size_t twsi_phys;
>  	void __iomem *twsi_base;
> -	resource_size_t regsize;
>  	struct device *dev;
>  };
>  
> @@ -511,17 +513,18 @@ static int __devinit octeon_i2c_initlowlevel(struct octeon_i2c *i2c)
>  	return -EIO;
>  }
>  
> -static int __devinit octeon_i2c_probe(struct platform_device *pdev)
> +static int __devinit octeon_i2c_probe(struct platform_device *pdev,
> +				      const struct of_device_id *match)
>  {
>  	int irq, result = 0;
>  	struct octeon_i2c *i2c;
> -	struct octeon_i2c_data *i2c_data;
> -	struct resource *res_mem;
> +	const __be32 *data;
> +	int len;
>  
>  	/* All adaptors have an irq.  */
> -	irq = platform_get_irq(pdev, 0);
> -	if (irq < 0)
> -		return irq;
> +	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> +	if (!irq)
> +		return -ENXIO;

Platform_get_irq() works for dt registered devices, this hunk can be
dropped.

>  
>  	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
>  	if (!i2c) {
> @@ -530,32 +533,16 @@ static int __devinit octeon_i2c_probe(struct platform_device *pdev)
>  		goto out;
>  	}
>  	i2c->dev = &pdev->dev;
> -	i2c_data = pdev->dev.platform_data;
> -
> -	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -
> -	if (res_mem == NULL) {
> -		dev_err(i2c->dev, "found no memory resource\n");
> -		result = -ENXIO;
> -		goto fail_region;
> -	}

Ditto for platform_get_resource()

>  
> -	if (i2c_data == NULL) {
> -		dev_err(i2c->dev, "no I2C frequency data\n");
> -		result = -ENXIO;
> -		goto fail_region;
> -	}
> +	data = of_get_property(pdev->dev.of_node, "clock-rate", &len);
> +	if (data && len == sizeof(*data))
> +		i2c->twsi_freq = be32_to_cpup(data);
> +	else
> +		i2c->twsi_freq = 100000;

Seems to me that if the clock-rate (although it should be called
clock-frequency) property is not present, the driver should complain
loudly and refuse to load.  Don't fudge it.

>  
> -	i2c->twsi_phys = res_mem->start;
> -	i2c->regsize = resource_size(res_mem);
> -	i2c->twsi_freq = i2c_data->i2c_freq;
> -	i2c->sys_freq = i2c_data->sys_freq;
> +	i2c->sys_freq = octeon_get_io_clock_rate();
>  
> -	if (!request_mem_region(i2c->twsi_phys, i2c->regsize, res_mem->name)) {
> -		dev_err(i2c->dev, "request_mem_region failed\n");
> -		goto fail_region;
> -	}
> -	i2c->twsi_base = ioremap(i2c->twsi_phys, i2c->regsize);
> +	i2c->twsi_base = of_iomap(pdev->dev.of_node, 0);

This hunk can also be dropped.

>  
>  	init_waitqueue_head(&i2c->queue);
>  
> @@ -581,27 +568,27 @@ static int __devinit octeon_i2c_probe(struct platform_device *pdev)
>  
>  	i2c->adap = octeon_i2c_ops;
>  	i2c->adap.dev.parent = &pdev->dev;
> -	i2c->adap.nr = pdev->id >= 0 ? pdev->id : 0;
> +	i2c->adap.dev.of_node = pdev->dev.of_node;
>  	i2c_set_adapdata(&i2c->adap, i2c);
>  	platform_set_drvdata(pdev, i2c);
>  
> -	result = i2c_add_numbered_adapter(&i2c->adap);
> +	result = i2c_add_adapter(&i2c->adap);
>  	if (result < 0) {
>  		dev_err(i2c->dev, "failed to add adapter\n");
>  		goto fail_add;
>  	}
> -
>  	dev_info(i2c->dev, "version %s\n", DRV_VERSION);
>  
> -	return result;
> +	of_i2c_register_devices(&i2c->adap);
> +
> +	return 0;
>  
>  fail_add:
>  	platform_set_drvdata(pdev, NULL);
>  	free_irq(i2c->irq, i2c);
>  fail_irq:
>  	iounmap(i2c->twsi_base);
> -	release_mem_region(i2c->twsi_phys, i2c->regsize);
> -fail_region:
> +
>  	kfree(i2c);
>  out:
>  	return result;
> @@ -615,17 +602,25 @@ static int __devexit octeon_i2c_remove(struct platform_device *pdev)
>  	platform_set_drvdata(pdev, NULL);
>  	free_irq(i2c->irq, i2c);
>  	iounmap(i2c->twsi_base);
> -	release_mem_region(i2c->twsi_phys, i2c->regsize);
>  	kfree(i2c);
>  	return 0;
>  };
>  
> -static struct platform_driver octeon_i2c_driver = {
> +static struct of_device_id octeon_i2c_match[] = {
> +	{
> +		.compatible = "octeon,twsi",

Need documentation for this binding added to
Documentation/devicetree/bindings.  Compatible values for SoC devices
should generally be in the form "<vendor>,<soc-name>-<device-name>".

> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, octeon_i2c_match);
> +
> +static struct of_platform_driver octeon_i2c_driver = {

of_platform_driver is deprecated.  As long as the .of_match_table is
populated, a normal platform_driver will just work.

>  	.probe		= octeon_i2c_probe,
>  	.remove		= __devexit_p(octeon_i2c_remove),
>  	.driver		= {
>  		.owner	= THIS_MODULE,
>  		.name	= DRV_NAME,
> +		.of_match_table = octeon_i2c_match,
>  	},
>  };
>  
> @@ -633,20 +628,19 @@ static int __init octeon_i2c_init(void)
>  {
>  	int rv;
>  
> -	rv = platform_driver_register(&octeon_i2c_driver);
> +	rv = of_register_platform_driver(&octeon_i2c_driver);

Drop this change.

On that note, this routine is typically simplified to:
+ {
+ 	return platform_driver_register(&octeon_i2c_driver);
+ }

>  
>  static void __exit octeon_i2c_exit(void)
>  {
> -	platform_driver_unregister(&octeon_i2c_driver);
> +	of_unregister_platform_driver(&octeon_i2c_driver);

Drop this hunk.

>  }
>  
>  MODULE_AUTHOR("Michael Lawnick <michael.lawnick.ext@nsn.com>");
>  MODULE_DESCRIPTION("I2C-Bus adapter for Cavium OCTEON processors");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(DRV_VERSION);
> -MODULE_ALIAS("platform:" DRV_NAME);
>  
>  module_init(octeon_i2c_init);
>  module_exit(octeon_i2c_exit);
> -- 
> 1.7.2.3
> 
