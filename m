Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763Ab0J2L2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 07:28:08 -0400
Received: from smtp.nokia.com ([192.100.105.134]:24151 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761320Ab0J2L2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 07:28:06 -0400
Subject: Re: [patch] misc/bh1770glc: error handling in
 bh1770_power_state_store()
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: ext Dan Carpenter <error27@gmail.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <20101028044149.GU6062@bicker>
References: <20101028044149.GU6062@bicker>
Content-Type: text/plain
Organization: Nokia Oyj
Date: Fri, 29 Oct 2010 14:27:54 +0300
Message-Id: <1288351674.30706.4.camel@4fid08082>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2010 11:27:58.0412 (UTC) FILETIME=[569E90C0:01CB775C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 06:41 +0200, ext Dan Carpenter wrote:
> There was a signedness bug so "ret" was never less than zero and that
> breaks the error handling.  Also in the original code it would overwrite
> ret and the result is still negative but it's bogus number instead of
> the correct error code.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Samu Onkalo <samu.p.onkalo@nokia.com>

> 
> diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
> index cee632e..d79a972 100644
> --- a/drivers/misc/bh1770glc.c
> +++ b/drivers/misc/bh1770glc.c
> @@ -649,7 +649,7 @@ static ssize_t bh1770_power_state_store(struct device *dev,
>  {
>  	struct bh1770_chip *chip =  dev_get_drvdata(dev);
>  	unsigned long value;
> -	size_t ret;
> +	ssize_t ret;
>  
>  	if (strict_strtoul(buf, 0, &value))
>  		return -EINVAL;
> @@ -659,8 +659,12 @@ static ssize_t bh1770_power_state_store(struct device *dev,
>  		pm_runtime_get_sync(dev);
>  
>  		ret = bh1770_lux_rate(chip, chip->lux_rate_index);
> -		ret |= bh1770_lux_interrupt_control(chip, BH1770_ENABLE);
> +		if (ret < 0) {
> +			pm_runtime_put(dev);
> +			goto leave;
> +		}
>  
> +		ret = bh1770_lux_interrupt_control(chip, BH1770_ENABLE);
>  		if (ret < 0) {
>  			pm_runtime_put(dev);
>  			goto leave;

