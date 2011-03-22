Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1CVAVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 20:21:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27215 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab1CVAVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 20:21:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6292"; a="81270308"
Message-ID: <94462146d712916438b435acb20c9f00.squirrel@www.codeaurora.org>
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB033D22EAE7@dbde02.ent.ti.com>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
    <1300485381-27201-1-git-send-email-carlv@codeaurora.org>
    <EAF47CD23C76F840A9E7FCE10091EFAB033D22EAE7@dbde02.ent.ti.com>
Date: Mon, 21 Mar 2011 17:21:10 -0700 (PDT)
Subject: RE: [PATCH 07/20] video: msm: Allow users to request a larger x 
     and y virtual fb
From: "Carl Vanderlip" <carlv@codeaurora.org>
To: "Janorkar, Mayuresh" <mayur@ti.com>
Cc: "Carl Vanderlip" <carlv@codeaurora.org>,
        "David Brown" <davidb@codeaurora.org>,
        "Daniel Walker" <dwalker@fifo99.com>,
        "Bryan Huntsman" <bryanh@codeaurora.org>,
        "Brian Swetland" <swetland@google.com>,
        "Dima Zavin" <dima@android.com>,
        "Rebecca Schultz Zavin" <rebecca@android.com>,
        "Colin Cross" <ccross@android.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/drivers/video/msm/msm_fb.c b/drivers/video/msm/msm_fb.c
>> index 04d0067..6af8b41 100644
>> --- a/drivers/video/msm/msm_fb.c
>> +++ b/drivers/video/msm/msm_fb.c

>> @@ -323,14 +327,46 @@ error:
>>
>>  static int msmfb_check_var(struct fb_var_screeninfo *var, struct
>> fb_info
>> *info)
>>  {
>> +	u32 size;
>> +
>>  	if ((var->xres != info->var.xres) ||
>>  	    (var->yres != info->var.yres) ||
>> -	    (var->xres_virtual != info->var.xres_virtual) ||
>> -	    (var->yres_virtual != info->var.yres_virtual) ||
>>  	    (var->xoffset != info->var.xoffset) ||
>>  	    (var->bits_per_pixel != info->var.bits_per_pixel) ||
>>  	    (var->grayscale != info->var.grayscale))
>>  		 return -EINVAL;
>> +
>> +	size = var->xres_virtual * var->yres_virtual *
>> +		(var->bits_per_pixel >> 3);
>
> How about defining a new macro BYTES_PER_PIXEL_VAR for fb_var_screeninfo
> also? That would make code more readable.
>
>> +	if (size > info->fix.smem_len)
>> +		return -EINVAL;
>> +	return 0;
>> +}

Name might be a little easy to confuse with the other BYTES_PER_PIXEL, but
overall readability would increase IMHO; Done.

>> +static int msmfb_set_par(struct fb_info *info)
>> +{
>> +	struct fb_var_screeninfo *var = &info->var;
>> +	struct fb_fix_screeninfo *fix = &info->fix;
>> +
>> +	/* we only support RGB ordering for now */
>> +	if (var->bits_per_pixel == 32 || var->bits_per_pixel == 24) {
>> +		var->red.offset = 0;
>> +		var->red.length = 8;
>> +		var->green.offset = 8;
>> +		var->green.length = 8;
>> +		var->blue.offset = 16;
>> +		var->blue.length = 8;
>
> var->red is a fb_bitfield variable.
> It provides offset, length and msb_right.
>
> struct fb_bitfield {
>     __u32 offset;                   /* beginning of bitfield        */
>     __u32 length;                   /* length of bitfield           */
>     __u32 msb_right;                /* != 0 : Most significant bit is */
>                                     /* right */
> }
> Please don't keep msb_right unassigned.
>
>> +	} else if (var->bits_per_pixel == 16) {
>> +		var->red.offset = 11;
>> +		var->red.length = 5;
>> +		var->green.offset = 5;
>> +		var->green.length = 6;
>> +		var->blue.offset = 0;
>> +		var->blue.length = 5;
>> +	} else
>> +		return -1;
>
> Please use standard error code provided by Linux kernel -EINVAL
> (-22 Invalid argument)
>
>> +	fix->line_length = var->xres * var->bits_per_pixel / 8;
> Why to divide by 8? Atleast use >>3, bitwise operations that would take
> less cpu cycles)
> As I stated earlier define a new macro for var also.
>
>> +
>>  	return 0;
>>  }

And Done. And done again... and while I'm at it, all the changes you
suggested are being pulled into v2 (except for updating Google's copyright
date (see: Brian Swetland's response)).

Thank you for reviewing my patches :)

   -Carl V.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

