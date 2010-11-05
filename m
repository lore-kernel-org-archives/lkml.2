Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0KECgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 22:36:14 -0400
Received: from imr4.ericy.com ([198.24.6.8]:52184 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab0KECgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 22:36:10 -0400
Date: Thu, 4 Nov 2010 19:35:25 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 4/8] hwmon: applesmc: Handle new
 temperature format
Message-ID: <20101105023525.GC28308@ericsson.com>
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
 <1288511434-5662-5-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1288511434-5662-5-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 03:50:30AM -0400, Henrik Rydberg wrote:
> The recent Macbooks have temperature registers of a new type.
> This patch adds the logic to handle them.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hwmon/applesmc.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index 0207618..ec92aff 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -733,13 +733,19 @@ static ssize_t applesmc_show_temperature(struct device *dev,
>  	ret = applesmc_get_entry_by_index(index, &entry);
>  	if (ret)
>  		return ret;
> +	if (entry.len > 2)
> +		return -EINVAL;
>  
> -	ret = applesmc_read_entry(&entry, buffer, 2);
> +	ret = applesmc_read_entry(&entry, buffer, entry.len);
>  	if (ret)
>  		return ret;
>  
> -	temp = buffer[0]*1000;
> -	temp += (buffer[1] >> 6) * 250;
> +	if (entry.len == 2) {
> +		temp = buffer[0]*1000;
> +		temp += (buffer[1] >> 6) * 250;
> +	} else {
> +		temp = buffer[0] * 4000;
> +	}

Another comment - in the next patch, you check for entry.len == 0.
If that can happen, you would need to check it here as well.

Guenter
