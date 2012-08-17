Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab2HQFVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 01:21:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34530 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab2HQFVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 01:21:34 -0400
Message-ID: <502DD4C9.2030105@ti.com>
Date: Fri, 17 Aug 2012 10:51:13 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [PATCH] media: davinci: vpif: add check for NULL handler
References: <1345125720-24059-1-git-send-email-prabhakar.lad@ti.com> <1435592.88fOxbvhY7@avalon>
In-Reply-To: <1435592.88fOxbvhY7@avalon>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the review.

On Thursday 16 August 2012 08:43 PM, Laurent Pinchart wrote:
> Hi Prabhakar,
> 
> Thanks for the patch.
> 
> On Thursday 16 August 2012 19:32:00 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/video/davinci/vpif_capture.c |   12 +++++++-----
>>  drivers/media/video/davinci/vpif_display.c |   14 ++++++++------
>>  2 files changed, 15 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/media/video/davinci/vpif_capture.c
>> b/drivers/media/video/davinci/vpif_capture.c index 266025e..a87b7a5 100644
>> --- a/drivers/media/video/davinci/vpif_capture.c
>> +++ b/drivers/media/video/davinci/vpif_capture.c
>> @@ -311,12 +311,14 @@ static int vpif_start_streaming(struct vb2_queue *vq,
>> unsigned int count) }
>>
>>  	/* configure 1 or 2 channel mode */
>> -	ret = vpif_config_data->setup_input_channel_mode
>> -					(vpif->std_info.ycmux_mode);
>> +	if (vpif_config_data->setup_input_channel_mode) {
>> +		ret = vpif_config_data->setup_input_channel_mode
>> +						(vpif->std_info.ycmux_mode);
>>
>> -	if (ret < 0) {
>> -		vpif_dbg(1, debug, "can't set vpif channel mode\n");
>> -		return ret;
>> +		if (ret < 0) {
>> +			vpif_dbg(1, debug, "can't set vpif channel mode\n");
>> +			return ret;
>> +		}
> 
> This change looks good to me. However, note that you will need to get rid of 
> board code callbacks at some point to implement device tree support. It would 
> be worth thinking about how to do so now.
> 
Currently VPIF driver is only used by dm646x, and the handlers for this
in the the board code are not null. This patch is intended for da850
where this handlers will be null.

>>  	}
>>
>>  	/* Call vpif_set_params function to set the parameters and addresses */
>> diff --git a/drivers/media/video/davinci/vpif_display.c
>> b/drivers/media/video/davinci/vpif_display.c index e129c98..1e35f92 100644
>> --- a/drivers/media/video/davinci/vpif_display.c
>> +++ b/drivers/media/video/davinci/vpif_display.c
>> @@ -280,12 +280,14 @@ static int vpif_start_streaming(struct vb2_queue *vq,
>> unsigned int count) }
>>
>>  	/* clock settings */
>> -	ret =
>> -	    vpif_config_data->set_clock(ch->vpifparams.std_info.ycmux_mode,
>> -					ch->vpifparams.std_info.hd_sd);
>> -	if (ret < 0) {
>> -		vpif_err("can't set clock\n");
>> -		return ret;
>> +	if (vpif_config_data->set_clock) {
> 
> Does the DaVinci platform use the common clock framework ? If so, a better fix 
> for this would be to pass a clock name through platform data instead of using 
> a callback function.
> 
Currently DaVinci is not using the common clock framework.

Can you ACK this patch?

Thanks and Regards,
--Prabhakar

>> +		ret =
>> +		vpif_config_data->set_clock(ch->vpifparams.std_info.ycmux_mode,
>> +						ch->vpifparams.std_info.hd_sd);
>> +		if (ret < 0) {
>> +			vpif_err("can't set clock\n");
>> +			return ret;
>> +		}
>>  	}
>>
>>  	/* set the parameters and addresses */

