Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2JJQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:25:26 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38395 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2JJQZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:25:24 -0400
Date: Wed, 10 Oct 2012 11:24:28 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2] TPM: Provide a tpm_tis OF driver
Message-ID: <20121010162428.GA5013@ennui.austin.ibm.com>
References: <20121002210453.GA12231@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121002210453.GA12231@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101016-5518-0000-0000-0000084F8F11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Tue, Oct 02, 2012 at 03:04:53PM -0600, Jason Gunthorpe wrote:
> This provides an open firwmare driver binding for tpm_tis. OF
> is useful on arches where PNP is not used.
> 
> Allow the tpm_tis driver to be selected if OF is compiled in.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  drivers/char/tpm/Kconfig   |    2 +-
>  drivers/char/tpm/tpm_tis.c |   79 +++++++++++++++++++++++++++++++++++--------
>  2 files changed, 65 insertions(+), 16 deletions(-)
> 
> v2 changes:
>  - Add irq_autoprobe to tpm_tis_init to simplify the logic around
>    the autoprobe function
>  - Use platform functions in tis_of_probe_one
>  - Rename tis_drv to tis_driver to silence MODPOST warnings
>  - checkpatch cleanups
>  - Do not attempt to auto-probe the TPM on OF configurations
> 
[cut]
> @@ -768,7 +770,7 @@ static int tpm_tis_pnp_resume(struct pnp_dev *dev)
>  	return ret;
>  }
> 
> -static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
> +static const struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
>  	{"PNP0C31", 0},		/* TPM */
>  	{"ATM1200", 0},		/* Atmel */
>  	{"IFX0102", 0},		/* Infineon */
> @@ -792,7 +794,7 @@ static __devexit void tpm_tis_pnp_remove(struct pnp_dev *dev)
>  }
> 
> 
> -static struct pnp_driver tis_pnp_driver = {
> +static const struct pnp_driver tis_pnp_driver = {
>  	.name = "tpm_tis",
>  	.id_table = tpm_pnp_tbl,
>  	.probe = tpm_tis_pnp_init,

  Why change the structs to const here? This generates warnings for me:

drivers/char/tpm/tpm_tis.c: In function ‘init_tis’:
drivers/char/tpm/tpm_tis.c:885:3: warning: passing argument 1 of
‘pnp_register_driver’ discards ‘const’ qualifier from pointer target
type [enabled by default]
In file included from drivers/char/tpm/tpm_tis.c:24:0:
include/linux/pnp.h:469:5: note: expected ‘struct pnp_driver *’ but
argument is of type ‘const struct pnp_driver *’
drivers/char/tpm/tpm_tis.c: In function ‘cleanup_tis’:
drivers/char/tpm/tpm_tis.c:930:3: warning: passing argument 1 of
‘pnp_unregister_driver’ discards ‘const’ qualifier from pointer target
type [enabled by default]
In file included from drivers/char/tpm/tpm_tis.c:24:0:
include/linux/pnp.h:470:6: note: expected ‘struct pnp_driver *’ but
argument is of type ‘const struct pnp_driver *’

> @@ -821,12 +823,52 @@ static int tpm_tis_resume(struct device *dev)
> 
>  static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
> 
> -static struct platform_driver tis_drv = {
> +#ifdef CONFIG_OF
> +static const struct of_device_id tis_of_platform_match[] __devinitdata = {
> +	{.compatible = "tcg,tpm_tis"},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, tis_of_platform_match);
> +
> +static int __devinit tis_of_probe_one(struct platform_device *pdev)
> +{
> +	const struct resource *res;
> +	int irq;
> +
> +	if (!pdev->dev.of_node)
> +		return -ENODEV;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENODEV;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		irq = 0;
> +	return tpm_tis_init(&pdev->dev, res->start, res->end - res->start + 1,
> +			    irq, 0);
> +}
> +
> +static int __devexit tis_of_remove_one(struct platform_device *odev)
> +{
> +	struct tpm_chip *chip = dev_get_drvdata(&odev->dev);
> +	tpm_dev_vendor_release(chip);
> +	kfree(chip);
> +	return 0;
> +}
> +#endif
> +
> +static struct platform_driver tis_driver = {
>  	.driver = {
>  		.name = "tpm_tis",
>  		.owner		= THIS_MODULE,
>  		.pm		= &tpm_tis_pm,
> +		.of_match_table = of_match_ptr(tis_of_platform_match),
>  	},

  Patch v2 removes the ifdef around of_match_table, which now generates
an error:

drivers/char/tpm/tpm_tis.c:867:3: error: implicit declaration of
function ‘of_match_ptr’ [-Werror=implicit-function-declaration]
drivers/char/tpm/tpm_tis.c:867:34: error: ‘tis_of_platform_match’
undeclared here (not in a function)

Kent

> +#ifdef CONFIG_OF
> +	.probe = tis_of_probe_one,
> +	.remove = __devexit_p(tis_of_remove_one)
> +#endif
>  };
> 
>  static struct platform_device *pdev;
> @@ -842,15 +884,22 @@ static int __init init_tis(void)
>  		return pnp_register_driver(&tis_pnp_driver);
>  #endif
> 
> -	rc = platform_driver_register(&tis_drv);
> +	rc = platform_driver_register(&tis_driver);
>  	if (rc < 0)
>  		return rc;
> -	if (IS_ERR(pdev=platform_device_register_simple("tpm_tis", -1, NULL, 0)))
> +	/* TIS_MEM_BASE is only going to work on x86.. */
> +#ifndef CONFIG_OF
> +	pdev = platform_device_register_simple("tpm_tis", -1, NULL, 0);
> +	if (IS_ERR(pdev)) {
> +		platform_driver_unregister(&tis_driver);
>  		return PTR_ERR(pdev);
> -	if((rc=tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0)) != 0) {
> +	}
> +	rc = tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0, 1);
> +	if (rc != 0) {
>  		platform_device_unregister(pdev);
> -		platform_driver_unregister(&tis_drv);
> +		platform_driver_unregister(&tis_driver);
>  	}
> +#endif
>  	return rc;
>  }
> 
> @@ -882,7 +931,7 @@ static void __exit cleanup_tis(void)
>  	}
>  #endif
>  	platform_device_unregister(pdev);
> -	platform_driver_unregister(&tis_drv);
> +	platform_driver_unregister(&tis_driver);
>  }
> 
>  module_init(init_tis);
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

