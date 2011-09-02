Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab1IBUyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:54:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33770 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755910Ab1IBUyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:54:49 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19uYQBfOKdugdopxH8AAPQRjHfI5qnRbILcQsbbhK
	++J2+cspOlUuF+
Message-ID: <4E61428E.1050408@gmx.de>
Date: Fri, 02 Sep 2011 20:54:38 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, lethal@linux-sh.org,
        linux-fbdev@vger.kernel.org, francis.moro@gmail.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Herton Ronaldo Krzesinski <herton@mandriva.com.br>, stable@kernel.org
Subject: Re: [PATCH] fb: sh-mobile: Fix deadlock risk between lock_fb_info()
 and console_lock()
References: <4DF7B0B4.4060002@gmx.de>	<1308337359-3480-1-git-send-email-FlorianSchandinat@gmx.de>	<20110618104311.6d80ba50@neptune.home>	<20110618111934.26203dbf@neptune.home>	<4E5FA7F9.9030802@gmx.de>	<Pine.LNX.4.64.1109021802560.4731@axis700.grange>	<4E61086C.3050102@gmx.de> <20110902192403.10f9cff7@neptune.home>
In-Reply-To: <20110902192403.10f9cff7@neptune.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 05:24 PM, Bruno Prémont wrote:
> Following on Herton's patch "fb: avoid possible deadlock caused by
> fb_set_suspend" which moves lock_fb_info() out of fb_set_suspend()
> to its callers, correct sh-mobile's locking around call to
> fb_set_suspend() and the same sort of deaklocks with console_lock()
> due to order of taking the lock.
> 
> console_lock() must be taken while fb_info is already locked and fb_info
> must be locked while calling fb_set_suspend().
> 
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> Hi Florian,
> 
>> On the other hand I just noticed the original patch didn't have
>> Bruno's Signed-off and a commit message was missing. So may I ask you,
>> Bruno, to add your Signed-off or preferably resend the version tested
>> by Guennadi in the appropriate patch format.
> 
> Here it is with commit message and the Signed-off-by's.

Applied and added stable as Cc as I think this should be applied as well
whenever Herton's patch is applied.


Thanks,

Florian Tobias Schandinat

> 
> Thanks,
> Bruno
> 
> 
> 
> 
>  drivers/video/sh_mobile_hdmi.c |   47 ++++++++++++++++++++++-----------------
>  1 files changed, 26 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/video/sh_mobile_hdmi.c b/drivers/video/sh_mobile_hdmi.c
> index 7d54e2c..647ba98 100644
> --- a/drivers/video/sh_mobile_hdmi.c
> +++ b/drivers/video/sh_mobile_hdmi.c
> @@ -1111,6 +1111,7 @@ static long sh_hdmi_clk_configure(struct sh_hdmi *hdmi, unsigned long hdmi_rate,
>  static void sh_hdmi_edid_work_fn(struct work_struct *work)
>  {
>  	struct sh_hdmi *hdmi = container_of(work, struct sh_hdmi, edid_work.work);
> +	struct fb_info *info;
>  	struct sh_mobile_hdmi_info *pdata = hdmi->dev->platform_data;
>  	struct sh_mobile_lcdc_chan *ch;
>  	int ret;
> @@ -1123,8 +1124,9 @@ static void sh_hdmi_edid_work_fn(struct work_struct *work)
>  
>  	mutex_lock(&hdmi->mutex);
>  
> +	info = hdmi->info;
> +
>  	if (hdmi->hp_state == HDMI_HOTPLUG_CONNECTED) {
> -		struct fb_info *info = hdmi->info;
>  		unsigned long parent_rate = 0, hdmi_rate;
>  
>  		ret = sh_hdmi_read_edid(hdmi, &hdmi_rate, &parent_rate);
> @@ -1148,42 +1150,45 @@ static void sh_hdmi_edid_work_fn(struct work_struct *work)
>  
>  		ch = info->par;
>  
> -		console_lock();
> +		if (lock_fb_info(info)) {
> +			console_lock();
>  
> -		/* HDMI plug in */
> -		if (!sh_hdmi_must_reconfigure(hdmi) &&
> -		    info->state == FBINFO_STATE_RUNNING) {
> -			/*
> -			 * First activation with the default monitor - just turn
> -			 * on, if we run a resume here, the logo disappears
> -			 */
> -			if (lock_fb_info(info)) {
> +			/* HDMI plug in */
> +			if (!sh_hdmi_must_reconfigure(hdmi) &&
> +			    info->state == FBINFO_STATE_RUNNING) {
> +				/*
> +				 * First activation with the default monitor - just turn
> +				 * on, if we run a resume here, the logo disappears
> +				 */
>  				info->var.width = hdmi->var.width;
>  				info->var.height = hdmi->var.height;
>  				sh_hdmi_display_on(hdmi, info);
> -				unlock_fb_info(info);
> +			} else {
> +				/* New monitor or have to wake up */
> +				fb_set_suspend(info, 0);
>  			}
> -		} else {
> -			/* New monitor or have to wake up */
> -			fb_set_suspend(info, 0);
> -		}
>  
> -		console_unlock();
> +			console_unlock();
> +			unlock_fb_info(info);
> +		}
>  	} else {
>  		ret = 0;
> -		if (!hdmi->info)
> +		if (!info)
>  			goto out;
>  
>  		hdmi->monspec.modedb_len = 0;
>  		fb_destroy_modedb(hdmi->monspec.modedb);
>  		hdmi->monspec.modedb = NULL;
>  
> -		console_lock();
> +		if (lock_fb_info(info)) {
> +			console_lock();
>  
> -		/* HDMI disconnect */
> -		fb_set_suspend(hdmi->info, 1);
> +			/* HDMI disconnect */
> +			fb_set_suspend(info, 1);
>  
> -		console_unlock();
> +			console_unlock();
> +			unlock_fb_info(info);
> +		}
>  	}
>  
>  out:
> 

