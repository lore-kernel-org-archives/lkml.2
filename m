Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1HISHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:07:17 -0400
Received: from imr3.ericy.com ([198.24.6.13]:38627 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab1HISHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:07:15 -0400
Subject: Re: [PATCH] drivers/hwmon/ibmaem.c: add missing kfree
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Julia Lawall <julia@diku.dk>
CC: Jean Delvare <khali@linux-fr.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1312902656-21520-1-git-send-email-julia@diku.dk>
References: <1312902656-21520-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 9 Aug 2011 11:04:12 -0700
Message-ID: <1312913052.9971.152.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 11:10 -0400, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> rs_resp is dynamically allocated in this function, so it should be freed
> before exiting in every case.  This collects the kfree and the return at
> the end of the function.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
Good catch. Applied.

Thanks,
Guenter


> ---
>  drivers/hwmon/ibmaem.c |   15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
> index 058e0ae..783d0c1 100644
> --- a/drivers/hwmon/ibmaem.c
> +++ b/drivers/hwmon/ibmaem.c
> @@ -399,13 +399,15 @@ static int aem_read_sensor(struct aem_data *data, u8 elt, u8 reg,
>  	aem_send_message(ipmi);
>  
>  	res = wait_for_completion_timeout(&ipmi->read_complete, IPMI_TIMEOUT);
> -	if (!res)
> -		return -ETIMEDOUT;
> +	if (!res) {
> +		res = -ETIMEDOUT;
> +		goto out;
> +	}
>  
>  	if (ipmi->rx_result || ipmi->rx_msg_len != rs_size ||
>  	    memcmp(&rs_resp->id, &system_x_id, sizeof(system_x_id))) {
> -		kfree(rs_resp);
> -		return -ENOENT;
> +		res = -ENOENT;
> +		goto out;
>  	}
>  
>  	switch (size) {
> @@ -430,8 +432,11 @@ static int aem_read_sensor(struct aem_data *data, u8 elt, u8 reg,
>  		break;
>  	}
>  	}
> +	res = 0;
>  
> -	return 0;
> +out:
> +	kfree(rs_resp);
> +	return res;
>  }
>  
>  /* Update AEM energy registers */
> 


