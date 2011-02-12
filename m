Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1BLJ0L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 04:26:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42885 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1BLJ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 04:26:06 -0500
Date: Sat, 12 Feb 2011 02:26:00 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, linux-input@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Walter Goossens <waltergoossens@home.nl>
Subject: Re: [PATCH v3] altera_ps2: Add devicetree support
Message-ID: <20110212092600.GE17755@angua.secretlab.ca>
References: <AANLkTikxSrwOfU=m_h+6G5hQMk6drOpqOPSfbBdzg53g@mail.gmail.com>
 <1296702304-30471-1-git-send-email-thomas@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296702304-30471-1-git-send-email-thomas@wytron.com.tw>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 11:05:04AM +0800, Thomas Chou wrote:
> Signed-off-by: Walter Goossens <waltergoossens@home.nl>
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> ---
> v2 use const and add compat version.
> v3 change compatible vendor to ALTR.
>    add dts binding doc.
> 
>  .../devicetree/bindings/serio/altera_ps2.txt       |    4 ++++
>  drivers/input/serio/altera_ps2.c                   |   11 +++++++++--
>  2 files changed, 13 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/serio/altera_ps2.txt
> 
> diff --git a/Documentation/devicetree/bindings/serio/altera_ps2.txt b/Documentation/devicetree/bindings/serio/altera_ps2.txt
> new file mode 100644
> index 0000000..4d9eecc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serio/altera_ps2.txt
> @@ -0,0 +1,4 @@
> +Altera UP PS/2 controller
> +
> +Required properties:
> +- compatible : should be "ALTR,ps2-1.0".
> diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
> index 7998560..d94b4a3 100644
> --- a/drivers/input/serio/altera_ps2.c
> +++ b/drivers/input/serio/altera_ps2.c
> @@ -19,6 +19,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> +#include <linux/of.h>
>  
>  #define DRV_NAME "altera_ps2"
>  
> @@ -173,6 +174,12 @@ static int __devexit altera_ps2_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static const struct of_device_id altera_ps2_match[] = {
> +	{ .compatible = "ALTR,ps2-1.0", },
> +	{},
> +}
> +MODULE_DEVICE_TABLE(of, altera_ps2_match);
> +

Should be:

#ifdef CONFIG_OF
static const struct of_device_id altera_ps2_match[] = {
	{ .compatible = "ALTR,ps2-1.0", },
	{},
}
MODULE_DEVICE_TABLE(of, altera_ps2_match);
#else /* CONFIG_OF */
#define altera_ps2_match NULL
#endif /* CONFIG_OF */

Otherwise the driver will be advertising that it provides device tree
support when CONFIG_OF is disabled.

Otherwise, looks good to me.  Feel free to add my acked-by line.

g.

>  /*
>   * Our device driver structure
>   */
> @@ -182,6 +189,7 @@ static struct platform_driver altera_ps2_driver = {
>  	.driver	= {
>  		.name	= DRV_NAME,
>  		.owner	= THIS_MODULE,
> +		.of_match_table = altera_ps2_match,
>  	},
>  };
>  
> @@ -189,13 +197,12 @@ static int __init altera_ps2_init(void)
>  {
>  	return platform_driver_register(&altera_ps2_driver);
>  }
> +module_init(altera_ps2_init);
>  
>  static void __exit altera_ps2_exit(void)
>  {
>  	platform_driver_unregister(&altera_ps2_driver);
>  }
> -
> -module_init(altera_ps2_init);
>  module_exit(altera_ps2_exit);
>  
>  MODULE_DESCRIPTION("Altera University Program PS2 controller driver");
> -- 
> 1.7.3.5
> 
