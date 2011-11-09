Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1KIAuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:50:21 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:44531 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1KIAuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:50:19 -0500
X-Greylist: delayed 1574 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Nov 2011 19:50:19 EST
Message-ID: <4EB9C824.5070504@emcraft.com>
Date: Wed, 09 Nov 2011 04:24:04 +0400
From: Ilya Yanok <yanok@emcraft.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ilya Yanok <yanok@emcraft.com>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] twl-core: fix oops while calling twl_i2c_* for unbound
 driver
References: <1312232428-31001-1-git-send-email-yanok@emcraft.com>
In-Reply-To: <1312232428-31001-1-git-send-email-yanok@emcraft.com>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is still unfixed. twl_i2c_{read,write} are exported and can be 
called before driver initialization so we have to check it before 
dereferencing twl_map.

Regards, Ilya.

02.08.2011 1:00, Ilya Yanok wrote:
> Check inuse variable before trying to access twl_map to prevent
> dereferencing of uninitialized variable.
>
> Signed-off-by: Ilya Yanok<yanok@emcraft.com>
> ---
>   drivers/mfd/twl-core.c |   16 ++++++++--------
>   1 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index 01ecfee..c7bc222 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -362,13 +362,13 @@ int twl_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
>   		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
>   		return -EPERM;
>   	}
> -	sid = twl_map[mod_no].sid;
> -	twl =&twl_modules[sid];
> -
>   	if (unlikely(!inuse)) {
> -		pr_err("%s: client %d is not initialized\n", DRIVER_NAME, sid);
> +		pr_err("%s: not initialized\n", DRIVER_NAME);
>   		return -EPERM;
>   	}
> +	sid = twl_map[mod_no].sid;
> +	twl =&twl_modules[sid];
> +
>   	mutex_lock(&twl->xfer_lock);
>   	/*
>   	 * [MSG1]: fill the register address data
> @@ -419,13 +419,13 @@ int twl_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
>   		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
>   		return -EPERM;
>   	}
> -	sid = twl_map[mod_no].sid;
> -	twl =&twl_modules[sid];
> -
>   	if (unlikely(!inuse)) {
> -		pr_err("%s: client %d is not initialized\n", DRIVER_NAME, sid);
> +		pr_err("%s: not initialized\n", DRIVER_NAME);
>   		return -EPERM;
>   	}
> +	sid = twl_map[mod_no].sid;
> +	twl =&twl_modules[sid];
> +
>   	mutex_lock(&twl->xfer_lock);
>   	/* [MSG1] fill the register address data */
>   	msg =&twl->xfer_msg[0];

