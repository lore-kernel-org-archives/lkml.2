Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab0IXUZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:25:25 -0400
Received: from imr3.ericy.com ([198.24.6.13]:37200 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab0IXUZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:25:24 -0400
Date: Fri, 24 Sep 2010 13:24:04 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Yuri Ershov <ext-yuri.ershov@nokia.com>
CC: eric.piel@tremplin-utc.net, samu.p.onkalo@nokia.com,
        akpm@linux-foundation.org, daniel@caiaq.de, ext-yuri.kululin@nokia.com,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [1/2] lis3: Add device owner
Message-ID: <20100924202404.GA20813@ericsson.com>
References: <ee6b20c71d49b8438ced798a9e561dbbd2991cf6.1282647258.git.ext-yuri.kululin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ee6b20c71d49b8438ced798a9e561dbbd2991cf6.1282647258.git.ext-yuri.kululin@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 02:33:20PM -0000, Yuri Ershov wrote:
> Add device owner and change /dev/freefall file operations owner
> according to the used driver
> 
> Signed-off-by: Yuri Kululin <ext-yuri.kululin@nokia.com>
> 
> ---
> drivers/hwmon/lis3lv02d.c |    8 ++++++--
>  drivers/hwmon/lis3lv02d.h |    2 ++
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> index e278f0e..0f1bd36 100644
> --- a/drivers/hwmon/lis3lv02d.c
> +++ b/drivers/hwmon/lis3lv02d.c
> @@ -591,8 +591,7 @@ static int lis3lv02d_misc_fasync(int fd, struct file *file, int on)
>  	return fasync_helper(fd, file, on, &lis3_dev.async_queue);
>  }
>  
> -static const struct file_operations lis3lv02d_misc_fops = {
> -	.owner   = THIS_MODULE,
> +static struct file_operations lis3lv02d_misc_fops = {
>  	.llseek  = no_llseek,
>  	.read    = lis3lv02d_misc_read,
>  	.open    = lis3lv02d_misc_open,
> @@ -1007,6 +1006,11 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
>  		goto out;
>  	}
>  
> +	if (dev->owner)
> +		lis3lv02d_misc_fops.owner = dev->owner;
> +	else
> +		lis3lv02d_misc_fops.owner = THIS_MODULE;
> +
If you retained the static assignment to .owner above, you would not need
the else part here.

Also, this depends on patch#2, which actually sets dev->owner.
So the problem isn't really addressed w/o patch #2. Given that,
I am not sure if it makes sense to have two separate patches.

If both patches were applied as one, you might not need the if ()
above in the first place. And if you do, you might still not have solved
the problem completely since .owner would not be set correctly
if dev->owner is NULL. 

On a higher level, reassigning the owner like this seems to be quite uncommon,
at least in hwmon. I would like to see an Acked-by from Eric to ensure
that the fix is correct.

Thanks,
Guenter
