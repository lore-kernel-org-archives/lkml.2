Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab1JRP7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:59:31 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:46763 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab1JRP7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:59:30 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9DA263.9000205@cam.ac.uk>
Date: Tue, 18 Oct 2011 16:59:31 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/7] input/cma3000_d0x: Support devices without pdata
References: <1318952886-835-1-git-send-email-ricardo.ribalda@gmail.com> <1318952886-835-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1318952886-835-2-git-send-email-ricardo.ribalda@gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/11 16:48, Ricardo Ribalda Delgado wrote:
> Architectures based on device-tree does not have platform data
> associated to the spi/i2c devices. Instead they can have some of
> the options embedded in the device tree.
> 
> This patch allows the cma3000  driver to get the configuration
> from the platform_data, the device tree, or in the wort case,
> just use a default configuration.
> 
Looks good to me but you'll need an ack from someone more
familiar with DT.
> ---
> 
> v3: Fixes suggested by Jonathan Cameron
>     -Add support for the device tree
> 
> v2: Fixes suggested by Jonathan Cameron
>     -Spelling
>     -Simplify pdata!=NULL check
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/input/misc/cma3000_d0x.c |   84 +++++++++++++++++++++++++++++++++-----
>  1 files changed, 73 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
> index 1633b63..604a32f 100644
> --- a/drivers/input/misc/cma3000_d0x.c
> +++ b/drivers/input/misc/cma3000_d0x.c
> @@ -23,6 +23,7 @@
>  #include <linux/slab.h>
>  #include <linux/input.h>
>  #include <linux/input/cma3000.h>
> +#include <linux/of.h>
>  
>  #include "cma3000_d0x.h"
>  
> @@ -62,9 +63,21 @@
>  #define BIT_TO_2G  18
>  #define BIT_TO_8G  71
>  
> +static struct cma3000_platform_data cma3000_default_pdata = {
> +	.mdthr = 0x8,
> +	.mdfftmr = 0x33,
> +	.ffthr = 0x8,
> +	.mode = CMAMODE_MEAS400,
> +	.g_range = CMARANGE_2G,
> +	.fuzz_x = BIT_TO_2G,
> +	.fuzz_y = BIT_TO_2G,
> +	.fuzz_z = BIT_TO_2G,
> +	.irqflags = 0,
> +};
> +
>  struct cma3000_accl_data {
>  	const struct cma3000_bus_ops *bus_ops;
> -	const struct cma3000_platform_data *pdata;
> +	struct cma3000_platform_data pdata;
>  
>  	struct device *dev;
>  	struct input_dev *input_dev;
> @@ -182,7 +195,7 @@ static int cma3000_reset(struct cma3000_accl_data *data)
>  
>  static int cma3000_poweron(struct cma3000_accl_data *data)
>  {
> -	const struct cma3000_platform_data *pdata = data->pdata;
> +	struct cma3000_platform_data *pdata = &data->pdata;
>  	u8 ctrl = 0;
>  	int ret;
>  
> @@ -280,22 +293,57 @@ void cma3000_resume(struct cma3000_accl_data *data)
>  }
>  EXPORT_SYMBOL(cma3000_resume);
>  
> +#ifdef CONFIG_OF
> +void cma3000_get_pdata_of(struct device *dev, struct cma3000_accl_data *data)
> +{
> +	const __be32 *property;
> +	int len;
> +
> +	property = of_get_property(dev->of_node, "vti,mdthr", &len);
> +	if (property && len == sizeof(int))
> +		data->pdata.mdthr = be32_to_cpup(property);
> +
> +	property = of_get_property(dev->of_node, "vti,mdfftmr", &len);
> +	if (property && len == sizeof(int))
> +		data->pdata.mdfftmr = be32_to_cpup(property);
> +
> +	property = of_get_property(dev->of_node, "vti,mode", &len);
> +	if (property && len == sizeof(int))
> +		data->pdata.mode = be32_to_cpup(property);
> +
> +	property = of_get_property(dev->of_node, "vti,g_range", &len);
> +	if (property && len == sizeof(int))
> +		data->pdata.g_range = be32_to_cpup(property);
> +
> +	property = of_get_property(dev->of_node, "vti,fuzz_x", &len);
> +	if (property && len == sizeof(int))
> +		data->pdata.fuzz_x = be32_to_cpup(property);
> +
> +	property = of_get_property(dev->of_node, "vti,fuzz_y", &len);
> +	if (property && len == sizeof(int))
> +		data->pdata.fuzz_y = be32_to_cpup(property);
> +
> +	property = of_get_property(dev->of_node, "vti,fuzz_z", &len);
> +	if (property && len == sizeof(int))
> +		data->pdata.fuzz_z = be32_to_cpup(property);
> +
> +	property = of_get_property(dev->of_node, "vti,irqflags", &len);
> +	if (property && len == sizeof(int))
> +		data->pdata.irqflags = be32_to_cpup(property);
> +
> +	return;
> +}
> +#endif
> +
>  struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
>  				       const struct cma3000_bus_ops *bops)
>  {
> -	const struct cma3000_platform_data *pdata = dev->platform_data;
> +	struct cma3000_platform_data *pdata;
>  	struct cma3000_accl_data *data;
>  	struct input_dev *input_dev;
>  	int rev;
>  	int error;
>  
> -	if (!pdata) {
> -		dev_err(dev, "platform data not found\n");
> -		error = -EINVAL;
> -		goto err_out;
> -	}
> -
> -
>  	/* if no IRQ return error */
>  	if (irq == 0) {
>  		error = -EINVAL;
> @@ -309,10 +357,24 @@ struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
>  		goto err_free_mem;
>  	}
>  
> +	/*Init platform data*/
> +	if (dev->platform_data != NULL) {
> +		memcpy(&data->pdata, dev->platform_data, sizeof(data->pdata));
> +	} else {
> +		memcpy(&data->pdata, &cma3000_default_pdata,
> +				sizeof(data->pdata));
> +		#ifdef CONFIG_OF
> +		if (dev->of_node != NULL)
> +			cma3000_get_pdata_of(dev, data);
> +		 else
Alignment is a little strange here, + for consistency of formatting
I'd just double the next line and use a #else 
> +		#endif
> +		dev_info(dev, "platform data not found, using default\n");
> +	}
> +	pdata = &data->pdata;
> +
>  	data->dev = dev;
>  	data->input_dev = input_dev;
>  	data->bus_ops = bops;
> -	data->pdata = pdata;
>  	data->irq = irq;
>  	mutex_init(&data->mutex);
>  

