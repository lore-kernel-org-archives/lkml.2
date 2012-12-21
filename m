Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2LUCVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:21:32 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:53250 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2LUCV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:21:26 -0500
Date: Fri, 21 Dec 2012 04:16:17 +0200
From: Ido Yariv <ido@wizery.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjur@brendeland.net>
Subject: Re: [RFCv2 05/11] remoteproc: Load firmware once.
Message-ID: <20121221021616.GC28692@WorkStation.localnet>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-6-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355501220-4572-6-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Fri, Dec 14, 2012 at 05:06:54PM +0100, Sjur Brændeland wrote:
> Load the firmware once and pave the way for two way
> communication of virtio configuration and status bits.
> The virtio ring device address is now stored in the resource
> table.
> 
> NOTE:  This patch requires device firmware change! The device
> 	memory layout changes. The virtio rings are no longer
> 	located at start of device memory. But the vring address
> 	can be read from the resource table. Also Carveout
> 	must be located before the virtio rings in the resource
> 	table.
> 
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

In case the remote processor is added, booted and then rebooted, the
program sections wont be reinitialized. This can be a bit problematic,
since the firmware might assume values are initialized in its data
sections.

How about the following alternative approach - instead of loading the
firmware in advance, we could allocate just a small (private) buffer,
holding a copy of the resource table. Our copy will be updated with the
addresses of the vrings we allocate, along with the notification ids.
Each time the remote processor is booted, we could reload the firmware
and overwrite the resource table section with our own private copy.
virtio's configuration space and status will probably need to be updated
in both copies of the resource table, so it would be consistent across
boots.

...

> -static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
> +static void rproc_fw_load(const struct firmware *fw, void *context)
>  {
> +	struct rproc *rproc = context;
>  	struct device *dev = &rproc->dev;
>  	const char *name = rproc->firmware;
>  	struct resource_table *table;
>  	int ret, tablesz;
>  
> +	if (!fw)
> +		goto release_fw;
> +
>  	ret = rproc_fw_sanity_check(rproc, fw);
>  	if (ret)
> -		return ret;
> +		goto release_fw;
>  
>  	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);
>  
> @@ -800,7 +805,7 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
>  	ret = rproc_enable_iommu(rproc);

iommu is enabled when the firmware is loaded, but disabled on shutdown,
so it could get out of balance when the remote processor is rebooted.

...

>  int rproc_boot(struct rproc *rproc)
>  {
> -	const struct firmware *firmware_p;
>  	struct device *dev;
>  	int ret;
>  
> @@ -1004,27 +967,28 @@ int rproc_boot(struct rproc *rproc)
>  	/* skip the boot process if rproc is already powered up */
>  	if (atomic_inc_return(&rproc->power) > 1) {
>  		ret = 0;
> -		goto unlock_mutex;
> +		goto downref_driver;

In case the rproc is already powered up, module_put should probably be
called to balance try_module_get. This is actually an existing bug in the
code.

Thanks,
Ido.
