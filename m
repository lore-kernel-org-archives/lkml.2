Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab2BNAM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:12:28 -0500
Received: from cpc7-stkp7-2-0-cust918.10-2.cable.virginmedia.com ([86.22.251.151]:35882
	"EHLO freya" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752962Ab2BNAMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:12:25 -0500
X-Greylist: delayed 2999 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Feb 2012 19:12:25 EST
Date: Mon, 13 Feb 2012 23:22:05 +0000
From: Ben Dooks <ben-i2c@fluff.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        kernel@pengutronix.de
Subject: Re: [PATCH 2/3] i2c: Add Congatec CGEB I2C driver
Message-ID: <20120213232204.GF2999@freya.fluff.org>
References: <1328102793-4313-1-git-send-email-s.hauer@pengutronix.de>
 <1328102793-4313-3-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328102793-4313-3-git-send-email-s.hauer@pengutronix.de>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 02:26:32PM +0100, Sascha Hauer wrote:
> This driver provides a I2C bus driver for the CGEB interface
> found on some Congatec x86 modules. No devices are registered
> on the bus, the user has to do this via the i2c device /sys
> interface.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/i2c/busses/Kconfig             |    7 +
>  drivers/i2c/busses/Makefile            |    1 +
>  drivers/i2c/busses/i2c-congatec-cgeb.c |  206 ++++++++++++++++++++++++++++++++
>  3 files changed, 214 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/busses/i2c-congatec-cgeb.c
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index a3afac4..cc8eb22 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -696,6 +696,13 @@ config I2C_EG20T
>  	  ML7213/ML7223 is companion chip for Intel Atom E6xx series.
>  	  ML7213/ML7223 is completely compatible for Intel EG20T PCH.
>  
> +config I2C_CONGATEC_CGEB
> +	tristate "Congatec CGEB I2C driver"
> +	depends on MFD_CONGATEC_CGEB
> +	help
> +	  This driver provides support for the I2C busses accssable via
> +	  the Congatec CGEB interface found on Congatec boards.
> +
>  comment "External I2C/SMBus adapter drivers"
>  
>  config I2C_DIOLAN_U2C
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index fba6da6..4aab659 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -69,6 +69,7 @@ obj-$(CONFIG_I2C_VERSATILE)	+= i2c-versatile.o
>  obj-$(CONFIG_I2C_OCTEON)	+= i2c-octeon.o
>  obj-$(CONFIG_I2C_XILINX)	+= i2c-xiic.o
>  obj-$(CONFIG_I2C_EG20T)         += i2c-eg20t.o
> +obj-$(CONFIG_I2C_CONGATEC_CGEB)	+= i2c-congatec-cgeb.o
>  
>  # External I2C/SMBus adapter drivers
>  obj-$(CONFIG_I2C_DIOLAN_U2C)	+= i2c-diolan-u2c.o
> diff --git a/drivers/i2c/busses/i2c-congatec-cgeb.c b/drivers/i2c/busses/i2c-congatec-cgeb.c
> new file mode 100644
> index 0000000..a387662
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-congatec-cgeb.c
> @@ -0,0 +1,206 @@
> +/*
> + * CGEB i2c driver
> + *
> + * (c) 2011 Sascha Hauer, Pengutronix

I'm going to note that (c) is not a universally legal representation of
Copyright &copy; symbol. You probably want to add Copyright to the front
of that.

> +static int cgeb_i2c_xfer(struct i2c_adapter *adapter,
> +		struct i2c_msg *msgs, int num)
> +{
> +	struct cgeb_function_parameters fps;
> +	int i, ret;
> +	unsigned long flags = CG_I2C_FLAG_START;
> +	struct cgeb_i2c_priv *priv = i2c_get_adapdata(adapter);
> +	unsigned long rdlen, wrlen;
> +	unsigned char *rdbuf, *wrbuf, *raw_wrbuf;
> +	unsigned short lmax = 0;

Small note, it would have looked better to organise the longer items towards the top.

> +	/*
> +	 * With cgeb the I2C address is part of the write data
> +	 * buffer, so allocate a buffer with the length of the
> +	 * longest write buffer + 1
> +	 */
> +	for (i = 0; i < num; i++)
> +		if (!(msgs[i].flags & I2C_M_RD))
> +			lmax = max(lmax, msgs[i].len);
> +
> +	raw_wrbuf = kmalloc(lmax + 1, GFP_KERNEL);
> +	if (!raw_wrbuf)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < num; i++) {
> +
> +		if (msgs[i].flags & I2C_M_RD) {
> +			rdbuf = msgs[i].buf;
> +			rdlen = msgs[i].len;
> +			wrbuf = NULL;
> +			wrlen = 0;
> +		} else {
> +			rdbuf = NULL;
> +			rdlen = 0;
> +			wrbuf = msgs[i].buf;
> +			wrlen = msgs[i].len;
> +		}
> +
> +		raw_wrbuf[0] = msgs[i].addr << 1;
> +		if (wrlen)
> +			memcpy(&raw_wrbuf[1], wrbuf, wrlen);
> +
> +		if (msgs[i].flags & I2C_M_RD)
> +			raw_wrbuf[0] |= 1;

Hmm, surely buts of that can go in the above if () statement?

> +		if (i == num - 1)
> +			flags |= CG_I2C_FLAG_STOP;
> +
> +		dev_dbg(&adapter->dev,
> +				"%s: rd: %p/%ld wr: %p/%ld flags: 0x%08lx %s\n",
> +				__func__, rdbuf, rdlen, raw_wrbuf, wrlen + 1,
> +				flags,
> +				msgs[i].flags & I2C_M_RD ? "READ" : "WRITE");
> +
> +		memset(&fps, 0, sizeof(fps));
> +
> +		fps.unit = priv->unit;
> +		fps.pars[0] = wrlen + 1;
> +		fps.pars[1] = rdlen;
> +		fps.pars[2] = flags;
> +		fps.iptr = raw_wrbuf;
> +		fps.optr = rdbuf;
> +
> +		ret = cgeb_call(priv->board, &fps, CgebI2CTransfer);
> +		if (ret) {
> +			ret = -EREMOTEIO;
> +			goto out;
> +		}
> +	}
> +
> +	ret = num;
> +
> +out:
> +	kfree(raw_wrbuf);
> +
> +	return ret;
> +
> +}


> +static int __devinit cgeb_i2c_probe(struct platform_device *pdev)
> +{
> +	struct cgeb_i2c_priv *priv;
> +	struct cgeb_pdata *pdata = pdev->dev.platform_data;
> +	int ret;
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;

it might be nice to print an error, but not necessary.

> +	strcpy(priv->adapter.name, pdev->name);
> +	priv->adapter.owner		= THIS_MODULE;
> +	priv->adapter.algo		= &cgeb_i2c_algo;
> +	priv->adapter.dev.parent	= &pdev->dev;
> +	priv->unit = pdata->unit;
> +	priv->board = pdata->board;
> +	i2c_set_adapdata(&priv->adapter, priv);
> +
> +	platform_set_drvdata(pdev, priv);
> +
> +	ret = cgeb_i2c_set_speed(priv, 400000);
> +	if (ret)
> +		/*
> +		 * not a critical error, we can continue with the default speed.
> +		 */
> +		dev_warn(&pdev->dev, "Could not set speed to 400KHz\n");
> +
> +	ret = i2c_add_adapter(&priv->adapter);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "registration failed\n");
> +		return ret;
> +	}
> +
> +	dev_info(&pdev->dev, "registered\n");
> +
> +	return 0;
> +};
> +
> +static int __devexit cgeb_i2c_remove(struct platform_device *pdev)
> +{
> +	struct cgeb_i2c_priv *priv = platform_get_drvdata(pdev);
> +
> +	i2c_del_adapter(&priv->adapter);
> +
> +	platform_set_drvdata(pdev, NULL);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver cgeb_i2c_driver = {
> +	.probe		= cgeb_i2c_probe,
> +	.remove		= __exit_p(cgeb_i2c_remove),

__devexit_p here.

> +	.driver	= {
> +		.name	= "cgeb-i2c",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init cgeb_i2c_driver_init(void)
> +{
> +	return platform_driver_register(&cgeb_i2c_driver);
> +}
> +
> +static void __exit cgeb_i2c_driver_exit(void)
> +{
> +	platform_driver_unregister(&cgeb_i2c_driver);
> +}
> +
> +module_init(cgeb_i2c_driver_init);
> +module_exit(cgeb_i2c_driver_exit);
> +
> +MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
> +MODULE_DESCRIPTION("cgeb i2c driver");
> +MODULE_LICENSE("GPL");
