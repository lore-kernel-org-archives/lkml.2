Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab2DRItL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:49:11 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35032 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2DRItI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:49:08 -0400
Date: Wed, 18 Apr 2012 11:49:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: volokh <volokh@telros.ru>
Cc: mchehab@infradead.org, devel@driverdev.osuosl.org, my84@bk.ru,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, justinmattock@gmail.com, pradheep.sh@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] Staging: go7007: detector features - add new tuning
 option
Message-ID: <20120418084936.GK6498@mwanda>
References: <1334735415.1693.9.camel@VPir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334735415.1693.9.camel@VPir>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F8E7F93.000C,ss=1,re=3.899,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 11:50:15AM +0400, volokh wrote:
> >From a600b33c0824bf1b5031f820f8afaefa9e51dc16 Mon Sep 17 00:00:00 2001
> From: Volokh Konstantin <my84@bk.ru>
> Date: Tue, 17 Apr 2012 21:39:15 +0400
> Subject: [PATCH] Staging: go7007: detector features - add new tuning option
>  for card(     V4L2_MPEG_VIDEO_ENCODING_H263    
>  ,V4L2_CID_MPEG_VIDEO_B_FRAMES) - add
>  framesizes&frameintervals control - tested&realize motion
>  detector control(     GO7007IOC_REGION_NUMBER    
>  ,GO7007IOC_PIXEL_THRESOLD     ,GO7007IOC_MOTION_THRESOLD   
>   ,GO7007IOC_TRIGGER     ,GO7007IOC_REGION_CONTROL    
>  ,GO7007IOC_CLIP_LEFT     ,GO7007IOC_CLIP_TOP    
>  ,GO7007IOC_CLIP_WIDTH     ,GO7007IOC_CLIP_HEIGHT)
> 
> Tested with  Angelo PCI-MPG24(Adlink) with go7007&tw2804 onboard
> 
> With Utility script for conversation to 'c' style based on checkpatch.pl
> 

Something went desperately wrong with your style script...  :(

This patch needs to be broken up into multiple patches.  For example
one patch could remove the #ifdefed out dead code.  Pull all the
unrelated cleanups out into their own patches.

> @@ -159,6 +152,8 @@ static u32 get_frame_type_flag(struct go7007_buffer *gobuf, int format)
>  		default:
>  			return 0;
>  		}
> +	default:
> +	  break;

Use 8 space tabs.

>  	}
>  
>  	return 0;
> @@ -171,7 +166,7 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
>  
>  	if (fmt != NULL && fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MJPEG &&
>  			fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MPEG &&
> -			fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_MPEG4)
> +			fmt->fmt.pix.pixelformat != V4L2_PIX_FMT_H263)
>  		return -EINVAL;
>  
>  	switch (go->standard) {
> @@ -303,11 +298,10 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
>  		go->gop_header_enable = 1;
>  		go->dvd_mode = 0;
>  		break;
> -	/* Backwards compatibility only! */
> -	case V4L2_PIX_FMT_MPEG4:
> -		if (go->format == GO7007_FORMAT_MPEG4)
> +	case V4L2_PIX_FMT_H263:
> +		if (go->format == GO7007_FORMAT_H263)
>  			break;
> -		go->format = GO7007_FORMAT_MPEG4;
> +		go->format = GO7007_FORMAT_H263;
>  		go->pali = 0xf5;
>  		go->aspect_ratio = GO7007_RATIO_1_1;
>  		go->gop_size = go->sensor_framerate / 1000;
> @@ -334,112 +328,388 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
>  	return 0;
>  }
>  
> -#if 0
> -static int clip_to_modet_map(struct go7007 *go, int region,
> -		struct v4l2_clip *clip_list)
> +static int md_g_ctrl(struct v4l2_control *ctrl, struct go7007 *go)
>  {
> -	struct v4l2_clip clip, *clip_ptr;
> -	int x, y, mbnum;
> -
> -	/* Check if coordinates are OK and if any macroblocks are already
> -	 * used by other regions (besides 0) */
> -	clip_ptr = clip_list;
> -	while (clip_ptr) {
> -		if (copy_from_user(&clip, clip_ptr, sizeof(clip)))
> -			return -EFAULT;
> -		if (clip.c.left < 0 || (clip.c.left & 0xF) ||
> -				clip.c.width <= 0 || (clip.c.width & 0xF))
> -			return -EINVAL;
> -		if (clip.c.left + clip.c.width > go->width)
> -			return -EINVAL;
> -		if (clip.c.top < 0 || (clip.c.top & 0xF) ||
> -				clip.c.height <= 0 || (clip.c.height & 0xF))
> -			return -EINVAL;
> -		if (clip.c.top + clip.c.height > go->height)
> -			return -EINVAL;
> -		for (y = 0; y < clip.c.height; y += 16)
> -			for (x = 0; x < clip.c.width; x += 16) {
> -				mbnum = (go->width >> 4) *
> -						((clip.c.top + y) >> 4) +
> -					((clip.c.left + x) >> 4);
> -				if (go->modet_map[mbnum] != 0 &&
> -						go->modet_map[mbnum] != region)
> -					return -EBUSY;
> -			}
> -		clip_ptr = clip.next;
> +	switch (ctrl->id) {
> +	case GO7007IOC_REGION_NUMBER:
> +	ctrl->value = go->fCurrentRegion;
> +	break;
> +	case GO7007IOC_PIXEL_THRESOLD:
> +	ctrl->value = (go->modet[go->fCurrentRegion].pixel_threshold<<1)+1;
> +	break;
> +	case GO7007IOC_MOTION_THRESOLD:
> +	ctrl->value = (go->modet[go->fCurrentRegion].motion_threshold<<1)+1;
> +	break;
> +	case GO7007IOC_TRIGGER:
> +	ctrl->value = (go->modet[go->fCurrentRegion].mb_threshold<<1)+1;
> +	break;
> +	case GO7007IOC_CLIP_LEFT:
> +	ctrl->value = go->fClipRegion.left;
> +	break;
> +	case GO7007IOC_CLIP_TOP:
> +	ctrl->value = go->fClipRegion.top;
> +	break;
> +	case GO7007IOC_CLIP_WIDTH:
> +	ctrl->value = go->fClipRegion.width;
> +	break;
> +	case GO7007IOC_CLIP_HEIGHT:
> +	ctrl->value = go->fClipRegion.height;
> +	break;
> +	case GO7007IOC_REGION_CONTROL:
> +	default:
> +	return -EINVAL;

Indenting on switch statements should look like this:

	switch (ctrl->id) {
	case GO7007IOC_REGION_NUMBER:
		ctrl->value = go->fCurrentRegion;
		break;
	case GO7007IOC_PIXEL_THRESOLD:

etc.

>  	}
> +	return 0;
> +}
>  
> -	/* Clear old region macroblocks */
> -	for (mbnum = 0; mbnum < 1624; ++mbnum)
> -		if (go->modet_map[mbnum] == region)
> +static void ClearModetMap(struct go7007 *go, char Region)

The original code used "region" and that was better than "Region".
Anyway, don't do unrelated renaming because it messes up the patch.

> +{
> +  /* Clear old region macroblocks */
> +	int mbnum;

Put a blank line here.

> +	for (mbnum = 0; mbnum < sizeof(go->modet_map); ++mbnum)
> +		if (go->modet_map[mbnum] == Region)
>  			go->modet_map[mbnum] = 0;
> +}
>  
> -	/* Claim macroblocks in this list */
> -	clip_ptr = clip_list;
> -	while (clip_ptr) {
> -		if (copy_from_user(&clip, clip_ptr, sizeof(clip)))
> -			return -EFAULT;
> -		for (y = 0; y < clip.c.height; y += 16)
> -			for (x = 0; x < clip.c.width; x += 16) {
> -				mbnum = (go->width >> 4) *
> -						((clip.c.top + y) >> 4) +
> -					((clip.c.left + x) >> 4);
> -				go->modet_map[mbnum] = region;
> -			}
> -		clip_ptr = clip.next;
> +static int RectToModetMap(
> +	struct go7007 *go,
> +	char Region,
> +	struct v4l2_rect *Rect,
> +	int Delete)
> +{
> +	register int x, y, mbnum;
> +  /* Check if coordinates are OK and if any macroblocks are already
> +   * used by other regions (besides 0) */
> +/*  if(Rect)*/
> +	if (
> +	Rect->left < 0 || (
> +	Rect->left & 0xF) || Rect->width <= 0 || (
> +	Rect->width & 0xF))
> +		return -EINVAL;

I'm not sure what went wrong here with indenting.  You used a tool
to do this automatically?  Can you redo it, it's not worth reviewing
as is.

So basically this was not a proper review at all, and I understand
that.  Please break it up into small patch, fix the style issues,
and we'll review it properly next time.

regards,
dan carpenter

