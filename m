Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab0LEVhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 16:37:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:35451 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751768Ab0LEVhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 16:37:06 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+gRmYZdeygFuk+I/f7CYg0ZJKtYjCbXbUUGRJkkc
	ncivCZze6QdhIi
Message-ID: <4CFC05FC.90909@gmx.de>
Date: Sun, 05 Dec 2010 22:37:00 +0100
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
CC: linux-kernel@vger.kernel.org, Joseph Chan <JosephChan@via.com.tw>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] drivers/video/via/viafbdev.c: Check return value of strict_strtoul().
References: <1dda71ee1b12baa2366520b894d83d7b0abefc5c.1291433779.git.tfransosi@gmail.com> <0b32968e295b04d3ced937e2e17771ad1fd0f633.1291434520.git.tfransosi@gmail.com>
In-Reply-To: <0b32968e295b04d3ced937e2e17771ad1fd0f633.1291434520.git.tfransosi@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thiago Farina schrieb:
> This fix the following warnings:

You could have made my job easier by
(1) mentioning that the first and the second email you sent are different
(2) highlighting the difference

I think your patch is correct, but I just saw a huge patch series by Alexey 
Dobriyan on the LKML with much more invasive changes in this area (basically 
eliminating strict_strtoul). I'll keep your second email as a backup but won't 
apply it now as it would conflict with the series which obsolates it anyway.


Thanks,

Florian Tobias Schandinat

> 
> drivers/video/via/viafbdev.c:1144: warning: ignoring return value of ‘strict_strtoul’, declared with attribute warn_unused_result
> drivers/video/via/viafbdev.c:1214: warning: ignoring return value of ‘strict_strtoul’, declared with attribute warn_unused_result
> drivers/video/via/viafbdev.c:1272: warning: ignoring return value of ‘strict_strtoul’, declared with attribute warn_unused_result
> drivers/video/via/viafbdev.c:1311: warning: ignoring return value of ‘strict_strtoul’, declared with attribute warn_unused_result
> drivers/video/via/viafbdev.c:1380: warning: ignoring return value of ‘strict_strtoul’, declared with attribute warn_unused_result
> drivers/video/via/viafbdev.c:1417: warning: ignoring return value of ‘strict_strtoul’, declared with attribute warn_unused_result
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  drivers/video/via/viafbdev.c |   40 +++++++++++++++++++++++++++++++++-------
>  1 files changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
> index d298cfc..9a53ec3 100644
> --- a/drivers/video/via/viafbdev.c
> +++ b/drivers/video/via/viafbdev.c
> @@ -1131,6 +1131,8 @@ static ssize_t viafb_dvp0_proc_write(struct file *file,
>  	char buf[20], *value, *pbuf;
>  	u8 reg_val = 0;
>  	unsigned long length, i;
> +	int ret;
> +
>  	if (count < 1)
>  		return -EINVAL;
>  	length = count > 20 ? 20 : count;
> @@ -1141,7 +1143,10 @@ static ssize_t viafb_dvp0_proc_write(struct file *file,
>  	for (i = 0; i < 3; i++) {
>  		value = strsep(&pbuf, " ");
>  		if (value != NULL) {
> -			strict_strtoul(value, 0, (unsigned long *)&reg_val);
> +			ret = strict_strtoul(value, 0, (unsigned long *)&reg_val);
> +			if (ret < 0)
> +				return ret;
> +
>  			DEBUG_MSG(KERN_INFO "DVP0:reg_val[%l]=:%x\n", i,
>  				  reg_val);
>  			switch (i) {
> @@ -1201,6 +1206,8 @@ static ssize_t viafb_dvp1_proc_write(struct file *file,
>  	char buf[20], *value, *pbuf;
>  	u8 reg_val = 0;
>  	unsigned long length, i;
> +	int ret;
> +
>  	if (count < 1)
>  		return -EINVAL;
>  	length = count > 20 ? 20 : count;
> @@ -1211,7 +1218,10 @@ static ssize_t viafb_dvp1_proc_write(struct file *file,
>  	for (i = 0; i < 3; i++) {
>  		value = strsep(&pbuf, " ");
>  		if (value != NULL) {
> -			strict_strtoul(value, 0, (unsigned long *)&reg_val);
> +			ret = strict_strtoul(value, 0, (unsigned long *)&reg_val);
> +			if (ret < 0)
> +				return ret;
> +
>  			switch (i) {
>  			case 0:
>  				viafb_write_reg_mask(CR9B, VIACR,
> @@ -1263,13 +1273,17 @@ static ssize_t viafb_dfph_proc_write(struct file *file,
>  	char buf[20];
>  	u8 reg_val = 0;
>  	unsigned long length;
> +	int ret;
> +
>  	if (count < 1)
>  		return -EINVAL;
>  	length = count > 20 ? 20 : count;
>  	if (copy_from_user(&buf[0], buffer, length))
>  		return -EFAULT;
>  	buf[length - 1] = '\0';	/*Ensure end string */
> -	strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
> +	ret = strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
> +	if (ret < 0)
> +		return ret;
>  	viafb_write_reg_mask(CR97, VIACR, reg_val, 0x0f);
>  	return count;
>  }
> @@ -1302,13 +1316,17 @@ static ssize_t viafb_dfpl_proc_write(struct file *file,
>  	char buf[20];
>  	u8 reg_val = 0;
>  	unsigned long length;
> +	int ret;
> +
>  	if (count < 1)
>  		return -EINVAL;
>  	length = count > 20 ? 20 : count;
>  	if (copy_from_user(&buf[0], buffer, length))
>  		return -EFAULT;
>  	buf[length - 1] = '\0';	/*Ensure end string */
> -	strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
> +	ret = strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
> +	if (ret < 0)
> +		return ret;
>  	viafb_write_reg_mask(CR99, VIACR, reg_val, 0x0f);
>  	return count;
>  }
> @@ -1365,6 +1383,8 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
>  	char buf[30], *value, *pbuf;
>  	struct IODATA reg_val;
>  	unsigned long length, i;
> +	int ret;
> +
>  	if (count < 1)
>  		return -EINVAL;
>  	length = count > 30 ? 30 : count;
> @@ -1377,8 +1397,11 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
>  		for (i = 0; i < 2; i++) {
>  			value = strsep(&pbuf, " ");
>  			if (value != NULL) {
> -				strict_strtoul(value, 0,
> -					(unsigned long *)&reg_val.Data);
> +				ret = strict_strtoul(value, 0,
> +						(unsigned long *)&reg_val.Data);
> +				if (ret < 0)
> +					return ret;
> +
>  				switch (i) {
>  				case 0:
>  					reg_val.Index = 0x08;
> @@ -1414,8 +1437,11 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
>  		for (i = 0; i < 2; i++) {
>  			value = strsep(&pbuf, " ");
>  			if (value != NULL) {
> -				strict_strtoul(value, 0,
> +				ret = strict_strtoul(value, 0,
>  					(unsigned long *)&reg_val.Data);
> +				if (ret < 0)
> +					return ret;
> +
>  				switch (i) {
>  				case 0:
>  					reg_val.Index = 0x08;

