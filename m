Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1JRIc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:32:28 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:57296 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1JRIc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:32:27 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9D3999.1080802@cam.ac.uk>
Date: Tue, 18 Oct 2011 09:32:25 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] input/cma3000_d0x: Support devices without pdata
References: <1318926486-10330-1-git-send-email-ricardo.ribalda@gmail.com> <1318926486-10330-2-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1318926486-10330-2-git-send-email-ricardo.ribalda@gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/11 09:28, Ricardo Ribalda Delgado wrote:
> Architechtures based on device-tree does not have platform data
check your spelling.
> associated to the spi/i2c devices.
> This patch allows those architechtures to use the cma3000 driver with
> a default configuration.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/input/misc/cma3000_d0x.c |   21 +++++++++++++++++++--
>  1 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
> index 1633b63..2f993d5 100644
> --- a/drivers/input/misc/cma3000_d0x.c
> +++ b/drivers/input/misc/cma3000_d0x.c
> @@ -62,6 +62,18 @@
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
I'm not that familiar with DT yet, but surely there is a means to supplying
the equivalent data?  I'd prefer to see that provided here as well.
> +
>  struct cma3000_accl_data {
>  	const struct cma3000_bus_ops *bus_ops;
>  	const struct cma3000_platform_data *pdata;
> @@ -283,19 +295,24 @@ EXPORT_SYMBOL(cma3000_resume);
>  struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
>  				       const struct cma3000_bus_ops *bops)
>  {
> -	const struct cma3000_platform_data *pdata = dev->platform_data;
> +	const struct cma3000_platform_data *pdata;
Leave this line alone....
>  	struct cma3000_accl_data *data;
>  	struct input_dev *input_dev;
>  	int rev;
>  	int error;
>  
> +	if (!dev->platform_data) {
> +		dev_info(dev, "platform data not found, using default\n");
> +		pdata = &cma3000_default_pdata;
> +	} else
> +		pdata = dev->platform_data;
> +
and this becomes

if (pdata == NULL) {
	dev_info(dev, "platform data not found, using default\n");
	pdata = &cma3000_default_pdata;
}

>  	if (!pdata) {
>  		dev_err(dev, "platform data not found\n");
>  		error = -EINVAL;
>  		goto err_out;
>  	}
This can't happen now so get rid of the test.
>  
> -
>  	/* if no IRQ return error */
>  	if (irq == 0) {
>  		error = -EINVAL;

