Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1HGOUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 10:20:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46590 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753260Ab1HGOUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 10:20:54 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/2/SZgPvb2OU7o2LsdUkQp6DU2o8R7UyOzk7qxKu
	0U9F8GLoj7dFpX
Message-ID: <4E3E9F41.3010307@gmx.de>
Date: Sun, 07 Aug 2011 14:20:49 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: stufever@gmail.com
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        lethal@linux-sh.org, Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: Re: [PATCH] viafb: replace strict_strtoul to kstrtoul and check return
 value
References: <1312723884-21790-1-git-send-email-wangshaoyan.pt@taobao.com>
In-Reply-To: <1312723884-21790-1-git-send-email-wangshaoyan.pt@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

On 08/07/2011 01:31 PM, stufever@gmail.com wrote:
> From: Wang Shaoyan<wangshaoyan.pt@taobao.com>
>
> This commit replace the function strict_strtoul(becasue commit 33ee3b2e), and check the return value to avoid such warning:
>
>    drivers/video/via/viafbdev.c:1992: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result

well I'm not against using the new functions but if you do this change please 
try to have a look why those were introduced.

> Signed-off-by: Wang Shaoyan<wangshaoyan.pt@taobao.com>
> ---
>   drivers/video/via/viafbdev.c |  137 ++++++++++++++++++++++++------------------
>   1 files changed, 79 insertions(+), 58 deletions(-)
>
> diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
> index 53aa443..5f638d6 100644
> --- a/drivers/video/via/viafbdev.c
> +++ b/drivers/video/via/viafbdev.c
> @@ -1158,7 +1158,8 @@ static ssize_t viafb_dvp0_proc_write(struct file *file,
>   	for (i = 0; i<  3; i++) {
>   		value = strsep(&pbuf, " ");
>   		if (value != NULL) {
> -			strict_strtoul(value, 0, (unsigned long *)&reg_val);
> +			if (kstrtoul(value, 0, (unsigned long *)&reg_val)<  0)
> +				return -EINVAL;

Ugh, the old code was ugly (casting u8* to unsigned long*) but you did not 
really improve it although the new functions were introduced for cases like 
this. You should use kstrtou8() here, I think.
It would also be nice if you could add range checks for the value entered as the 
behavior to -EINVAL on values > 255 but accepting too big values that are <= 255 
is not very consistent. Okay, as I know that doing this right would be difficult 
I'll accept this patch without them or without them being 100% accurate.

>   			DEBUG_MSG(KERN_INFO "DVP0:reg_val[%l]=:%x\n", i,
>   				  reg_val);
>   			switch (i) {
> @@ -1228,7 +1229,8 @@ static ssize_t viafb_dvp1_proc_write(struct file *file,
>   	for (i = 0; i<  3; i++) {
>   		value = strsep(&pbuf, " ");
>   		if (value != NULL) {
> -			strict_strtoul(value, 0, (unsigned long *)&reg_val);
> +			if (kstrtoul(value, 0, (unsigned long *)&reg_val)<  0)
> +				return -EINVAL;

Same here.

>   			switch (i) {
>   			case 0:
>   				viafb_write_reg_mask(CR9B, VIACR,
> @@ -1286,7 +1288,8 @@ static ssize_t viafb_dfph_proc_write(struct file *file,
>   	if (copy_from_user(&buf[0], buffer, length))
>   		return -EFAULT;
>   	buf[length - 1] = '\0';	/*Ensure end string */
> -	strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
> +	if (kstrtoul(&buf[0], 0, (unsigned long *)&reg_val)<  0)
> +		return -EINVAL;

Same here. And the &buf[0] is somewhat misleading, can you please correct it to 
be just buf?

>   	viafb_write_reg_mask(CR97, VIACR, reg_val, 0x0f);
>   	return count;
>   }
> @@ -1325,7 +1328,8 @@ static ssize_t viafb_dfpl_proc_write(struct file *file,
>   	if (copy_from_user(&buf[0], buffer, length))
>   		return -EFAULT;
>   	buf[length - 1] = '\0';	/*Ensure end string */
> -	strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
> +	if (kstrtoul(&buf[0], 0, (unsigned long *)&reg_val)<  0)
> +		return -EINVAL;

Same as above.

>   	viafb_write_reg_mask(CR99, VIACR, reg_val, 0x0f);
>   	return count;
>   }
> @@ -1394,8 +1398,9 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
>   		for (i = 0; i<  2; i++) {
>   			value = strsep(&pbuf, " ");
>   			if (value != NULL) {
> -				strict_strtoul(value, 0,
> -					(unsigned long *)&reg_val.Data);
> +				if (kstrtoul(value, 0,
> +					(unsigned long *)&reg_val.Data)<  0)
> +					return -EINVAL;

Again this u8 thing.

>   				switch (i) {
>   				case 0:
>   					reg_val.Index = 0x08;
> @@ -1431,8 +1436,9 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
>   		for (i = 0; i<  2; i++) {
>   			value = strsep(&pbuf, " ");
>   			if (value != NULL) {
> -				strict_strtoul(value, 0,
> -					(unsigned long *)&reg_val.Data);
> +				if (kstrtoul(value, 0,
> +					(unsigned long *)&reg_val.Data)<  0)
> +					return -EINVAL;

And again.

>   				switch (i) {
>   				case 0:
>   					reg_val.Index = 0x08;
> @@ -1950,61 +1956,76 @@ static int __init viafb_setup(void)
>   		if (!*this_opt)
>   			continue;
>
> -		if (!strncmp(this_opt, "viafb_mode1=", 12))
> +		if (!strncmp(this_opt, "viafb_mode1=", 12)) {
>   			viafb_mode1 = kstrdup(this_opt + 12, GFP_KERNEL);
> -		else if (!strncmp(this_opt, "viafb_mode=", 11))
> +		} else if (!strncmp(this_opt, "viafb_mode=", 11)) {
>   			viafb_mode = kstrdup(this_opt + 11, GFP_KERNEL);
> -		else if (!strncmp(this_opt, "viafb_bpp1=", 11))
> -			strict_strtoul(this_opt + 11, 0,
> -				(unsigned long *)&viafb_bpp1);
> -		else if (!strncmp(this_opt, "viafb_bpp=", 10))
> -			strict_strtoul(this_opt + 10, 0,
> -				(unsigned long *)&viafb_bpp);
> -		else if (!strncmp(this_opt, "viafb_refresh1=", 15))
> -			strict_strtoul(this_opt + 15, 0,
> -				(unsigned long *)&viafb_refresh1);
> -		else if (!strncmp(this_opt, "viafb_refresh=", 14))
> -			strict_strtoul(this_opt + 14, 0,
> -				(unsigned long *)&viafb_refresh);
> -		else if (!strncmp(this_opt, "viafb_lcd_dsp_method=", 21))
> -			strict_strtoul(this_opt + 21, 0,
> -				(unsigned long *)&viafb_lcd_dsp_method);
> -		else if (!strncmp(this_opt, "viafb_lcd_panel_id=", 19))
> -			strict_strtoul(this_opt + 19, 0,
> -				(unsigned long *)&viafb_lcd_panel_id);
> -		else if (!strncmp(this_opt, "viafb_accel=", 12))
> -			strict_strtoul(this_opt + 12, 0,
> -				(unsigned long *)&viafb_accel);
> -		else if (!strncmp(this_opt, "viafb_SAMM_ON=", 14))
> -			strict_strtoul(this_opt + 14, 0,
> -				(unsigned long *)&viafb_SAMM_ON);
> -		else if (!strncmp(this_opt, "viafb_active_dev=", 17))
> +		} else if (!strncmp(this_opt, "viafb_bpp1=", 11)) {
> +			if (kstrtoul(this_opt + 11, 0,
> +				(unsigned long *)&viafb_bpp1)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt, "viafb_bpp=", 10)) {
> +			if (kstrtoul(this_opt + 10, 0,
> +				(unsigned long *)&viafb_bpp)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt, "viafb_refresh1=", 15)) {
> +			if (kstrtoul(this_opt + 15, 0,
> +				(unsigned long *)&viafb_refresh1)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt, "viafb_refresh=", 14)) {
> +			if (kstrtoul(this_opt + 14, 0,
> +				(unsigned long *)&viafb_refresh)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt, "viafb_lcd_dsp_method=", 21)) {
> +			if (kstrtoul(this_opt + 21, 0,
> +				(unsigned long *)&viafb_lcd_dsp_method)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt, "viafb_lcd_panel_id=", 19)) {
> +			if (kstrtoul(this_opt + 19, 0,
> +				(unsigned long *)&viafb_lcd_panel_id)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt, "viafb_accel=", 12)) {
> +			if (kstrtoul(this_opt + 12, 0,
> +				(unsigned long *)&viafb_accel)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt, "viafb_SAMM_ON=", 14)) {
> +			if (kstrtoul(this_opt + 14, 0,
> +				(unsigned long *)&viafb_SAMM_ON)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt, "viafb_active_dev=", 17)) {
>   			viafb_active_dev = kstrdup(this_opt + 17, GFP_KERNEL);
> -		else if (!strncmp(this_opt,
> -			"viafb_display_hardware_layout=", 30))
> -			strict_strtoul(this_opt + 30, 0,
> -			(unsigned long *)&viafb_display_hardware_layout);
> -		else if (!strncmp(this_opt, "viafb_second_size=", 18))
> -			strict_strtoul(this_opt + 18, 0,
> -				(unsigned long *)&viafb_second_size);
> -		else if (!strncmp(this_opt,
> -			"viafb_platform_epia_dvi=", 24))
> -			strict_strtoul(this_opt + 24, 0,
> -				(unsigned long *)&viafb_platform_epia_dvi);
> -		else if (!strncmp(this_opt,
> -			"viafb_device_lcd_dualedge=", 26))
> -			strict_strtoul(this_opt + 26, 0,
> -				(unsigned long *)&viafb_device_lcd_dualedge);
> -		else if (!strncmp(this_opt, "viafb_bus_width=", 16))
> -			strict_strtoul(this_opt + 16, 0,
> -				(unsigned long *)&viafb_bus_width);
> -		else if (!strncmp(this_opt, "viafb_lcd_mode=", 15))
> -			strict_strtoul(this_opt + 15, 0,
> -				(unsigned long *)&viafb_lcd_mode);
> -		else if (!strncmp(this_opt, "viafb_lcd_port=", 15))
> +		} else if (!strncmp(this_opt,
> +			"viafb_display_hardware_layout=", 30)) {
> +			if (kstrtoul(this_opt + 30, 0,
> +			(unsigned long *)&viafb_display_hardware_layout)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt, "viafb_second_size=", 18)) {
> +			if (kstrtoul(this_opt + 18, 0,
> +				(unsigned long *)&viafb_second_size)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt,
> +			"viafb_platform_epia_dvi=", 24)) {
> +			if ( kstrtoul(this_opt + 24, 0,
> +				(unsigned long *)&viafb_platform_epia_dvi)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt,
> +			"viafb_device_lcd_dualedge=", 26)) {
> +			if (kstrtoul(this_opt + 26, 0,
> +				(unsigned long *)&viafb_device_lcd_dualedge)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt, "viafb_bus_width=", 16)) {
> +			if (kstrtoul(this_opt + 16, 0,
> +				(unsigned long *)&viafb_bus_width)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt, "viafb_lcd_mode=", 15)) {
> +			if (kstrtoul(this_opt + 15, 0,
> +				(unsigned long *)&viafb_lcd_mode)<  0)
> +				return -EINVAL;
> +		} else if (!strncmp(this_opt, "viafb_lcd_port=", 15)) {
>   			viafb_lcd_port = kstrdup(this_opt + 15, GFP_KERNEL);
> -		else if (!strncmp(this_opt, "viafb_dvi_port=", 15))
> +		} else if (!strncmp(this_opt, "viafb_dvi_port=", 15)) {
>   			viafb_dvi_port = kstrdup(this_opt + 15, GFP_KERNEL);
> +		}
>   	}
>   	return 0;
>   }

Please try to use the correct functions (kstrtoint, ...) here too, basically you 
should no longer have any need for casting pointers.


Thanks,

Florian Tobias Schandinat

