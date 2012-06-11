Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab2FKCPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 22:15:46 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48034 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219Ab2FKCPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 22:15:44 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1206061711090.12739@axis700.grange>
References: <1338352042-26522-1-git-send-email-Ying.Liu@freescale.com>
	<Pine.LNX.4.64.1206061711090.12739@axis700.grange>
Date: Mon, 11 Jun 2012 10:15:42 +0800
Message-ID: <CA+8Hj82AZhc3UrFNOiRR5Cr8kKZiuMyVZ4AGkhJoe8p0o8T_+w@mail.gmail.com>
Subject: Re: [PATCH 1/1] mx3fb: support pan display with fb_set_var
From: Liu Ying <liu.y.victor@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Liu Ying <Ying.Liu@freescale.com>, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/6, Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Wed, 30 May 2012, Liu Ying wrote:
>
>> Users may call FBIOPUT_VSCREENINFO ioctrl to do pan display.
>> This ioctrl relies on fb_set_var() to do the job. fb_set_var()
>> calls custom fb_set_par() method and then calls custom
>> fb_pan_display() method. The current implementation of mx3fb
>> reinitializes IPU display controller every time the custom
>> fb_set_par() method is called, which makes the display flash
>> if fb_set_var() is called to do panning frequently. The custom
>> fb_pan_display() method checks if the current xoffset and
>> yoffset are different from previous ones before doing actual
>> panning, which prevents the panning from happening within the
>> fb_set_var() context. This patch checks new var info to decide
>> whether we really need to reinitialize IPU display controller.
>> We ignore xoffset and yoffset update because it doesn't require
>> to reinitialize the controller. Users may specify activate field
>> of var info with FB_ACTIVATE_NOW and FB_ACTIVATE_FORCE to
>> reinialize the controller by force. Meanwhile, this patch removes
>> the check in custom fb_pan_display() method mentioned before to
>> have the panning work within fb_set_var() context. It doesn't
>> hurt to do panning again if there is no update for xoffset and
>> yoffset.
>
> You are really addressing 2 separate problems here: (1) panning cannot be
> set using FBIOPUT_VSCREENINFO and (2) screen flashes every time
> fb_set_var() is called, even if only panning is required. The reason for
> the first one is, that in fb_set_var() info->var is already updated from
> the new *var when fb_pan_display() is called. So, as you correctly
> identified, the condition
>
> 	if (fbi->var.xoffset == var->xoffset &&
> 	    fbi->var.yoffset == var->yoffset)
> 		return 0;	/* No change, do nothing */
>
> is trivially met and no panning takes place. Instead, you can use your
> idea to cache var_info locally and check against that one to see, whether
> offsets have changed, instead of removing that check completely.
>
> To solve the second problem you can use your check against the cached copy
> of var_info. See below for more details.
>
Thanks for your review. I think your suggestion is good and I have
sent you an updated series of patches for your review. Please find
more detail feedback inline.
>>
>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>> ---
>>  drivers/video/mx3fb.c |   31 +++++++++++++++++++++++++++----
>>  1 files changed, 27 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
>> index e3406ab..238b9aa 100644
>> --- a/drivers/video/mx3fb.c
>> +++ b/drivers/video/mx3fb.c
>> @@ -269,6 +269,8 @@ struct mx3fb_info {
>>  	struct scatterlist		sg[2];
>>
>>  	u32				sync;	/* preserve var->sync flags */
>
> An incremental patch could then also remove the above .sync member and
> switch to using .cur_var.sync instead.
Ok. I have addressed this in an updated patch.
>
>> +
>> +	struct fb_var_screeninfo	cur_var; /* current var info */
>>  };
>>
>>  static void mx3fb_dma_done(void *);
>> @@ -721,6 +723,26 @@ static void mx3fb_dma_done(void *arg)
>>  	complete(&mx3_fbi->flip_cmpl);
>>  }
>>
>> +static bool mx3fb_need_not_to_set_par(struct fb_info *fbi)
>
> How about inverting logic and calling the function
> mx3fb_must_update_par()?
Ok. I use mx3fb_must_set_par() in an updated patch.
>
>> +{
>> +	struct mx3fb_info *mx3_fbi = fbi->par;
>> +	struct fb_var_screeninfo old_var = mx3_fbi->cur_var;
>> +	struct fb_var_screeninfo new_var = fbi->var;
>> +
>> +	if ((fbi->var.activate & FB_ACTIVATE_FORCE) &&
>> +	    (fbi->var.activate & FB_ACTIVATE_MASK) == FB_ACTIVATE_NOW)
>> +		return false;
>> +
>> +	/*
>> +	 * Ignore xoffset and yoffset update,
>> +	 * because pan display handles this case.
>> +	 */
>> +	old_var.xoffset = new_var.xoffset;
>> +	old_var.yoffset = new_var.yoffset;
>> +
>> +	return !memcmp(&old_var, &new_var, sizeof(struct fb_var_screeninfo));
>> +}
>> +
>>  static int __set_par(struct fb_info *fbi, bool lock)
>>  {
>>  	u32 mem_len;
>> @@ -732,6 +754,9 @@ static int __set_par(struct fb_info *fbi, bool lock)
>>  	struct idmac_video_param *video = &ichan->params.video;
>>  	struct scatterlist *sg = mx3_fbi->sg;
>>
>> +	if (mx3fb_need_not_to_set_par(fbi))
>> +		return 0;
>> +
>
> __set_par() is called from 2 locations: from mx3fb_set_par() and
> init_fb_chan(), called from probing. You don't need to perform the above
> check in init_fb_chan() - there you always have to configure. Maybe better
> put it in mx3fb_set_par() just before calling __set_par() like
>
> 	ret = mx3fb_must_set_par() ? __set_par() : 0;
>
> As mentioned above, this solves problem #2 and should go into patch #2.
Ok. I have implemented your suggestion in an updated patch and
splitted this single patch into 2 separate ones. One is to support pan
display with fb_set_var(), the other is to fix screen flash issue when
panning with fb_set_var() frequently.
>
>>  	/* Total cleanup */
>>  	if (mx3_fbi->txd)
>>  		sdc_disable_channel(mx3_fbi);
>> @@ -808,6 +833,8 @@ static int __set_par(struct fb_info *fbi, bool lock)
>>  	if (mx3_fbi->blank == FB_BLANK_UNBLANK)
>>  		sdc_enable_channel(mx3_fbi);
>>
>> +	mx3_fbi->cur_var = fbi->var;
>> +
>
> Yes, but preserve xoffset and yoffset - you don't apply them yet in
> __set_par().
Yes. I have perserved xoffset and yoffset in case fb is blanked when
calling __set_par() in an updated patch. I found that in case fb is
unblanked when calling __set_par(), fb smem_start address is set to
the controller, so I set mx3_fbi->cur_var.xoffset and
mx3_fbi->cur_var.yoffset to zero in __set_par() in this case. Please
fix me if I misunderstood anything.
>
>>  	return 0;
>>  }
>>
>> @@ -1068,10 +1095,6 @@ static int mx3fb_pan_display(struct
>> fb_var_screeninfo *var,
>>  		return -EINVAL;
>>  	}
>>
>> -	if (fbi->var.xoffset == var->xoffset &&
>> -	    fbi->var.yoffset == var->yoffset)
>> -		return 0;	/* No change, do nothing */
>> -
>
> I think, it would be better not to remove these completely, but check
> against cached .cur_var, and then update those values too.
Ok. I have addressed this in an updated patch.
>
>>  	y_bottom = var->yoffset;
>>
>>  	if (!(var->vmode & FB_VMODE_YWRAP))
>> --
>> 1.7.1
>
> Makes sense? Or have I misunderstood something?
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Best Regards,
Liu Ying
