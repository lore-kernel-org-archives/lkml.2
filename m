Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab1LKKWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 05:22:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:34893 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1LKKWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 05:22:37 -0500
Message-ID: <4EE48465.9060706@infradead.org>
Date: Sun, 11 Dec 2011 08:22:29 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Haogang Chen <haogangchen@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Media: video: uvc: integer overflow in uvc_ioctl_ctrl_map()
References: <1322602345-26279-1-git-send-email-haogangchen@gmail.com> <201111300222.42162.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111300222.42162.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29-11-2011 23:22, Laurent Pinchart wrote:
> Hi Haogang,
>
> On Tuesday 29 November 2011 22:32:25 Haogang Chen wrote:
>> There is a potential integer overflow in uvc_ioctl_ctrl_map(). When a
>> large xmap->menu_count is passed from the userspace, the subsequent call
>> to kmalloc() will allocate a buffer smaller than expected.
>> map->menu_count and map->menu_info would later be used in a loop (e.g.
>> in uvc_query_v4l2_ctrl), which leads to out-of-bound access.
>>
>> The patch checks the ioctl argument and returns -EINVAL for zero or too
>> large values in xmap->menu_count.
>
> Thanks for the patch.

I'm assuming that either one of you will re-send the patches with the
pointed changes, so, I'm marking this one with "changes requested" at
patchwork.

>
>> Signed-off-by: Haogang Chen<haogangchen@gmail.com>
>> ---
>>   drivers/media/video/uvc/uvc_v4l2.c |    6 ++++++
>>   1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
>> b/drivers/media/video/uvc/uvc_v4l2.c index dadf11f..9a180d6 100644
>> --- a/drivers/media/video/uvc/uvc_v4l2.c
>> +++ b/drivers/media/video/uvc/uvc_v4l2.c
>> @@ -58,6 +58,12 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain
>> *chain, break;
>>
>>   	case V4L2_CTRL_TYPE_MENU:
>> +		if (xmap->menu_count == 0 ||
>> +		    xmap->menu_count>  INT_MAX / sizeof(*map->menu_info)) {
>
> I'd like to prevent excessive memory consumption by limiting the number of
> menu entries, similarly to how the driver limits the number of mappings.
> Defining UVC_MAX_CONTROL_MENU_ENTRIES to 32 in uvcvideo.h should be a
> reasonable value.
>
>> +			kfree(map);
>> +			return -EINVAL;
>
> I'd rather do
>
> 	ret = -EINVAL;
> 	goto done;
>
> to centralize error handling.
>
> If you're fine with both changes I can modify the patch, there's no need to
> resubmit.
>
>> +		}
>> +
>>   		size = xmap->menu_count * sizeof(*map->menu_info);
>>   		map->menu_info = kmalloc(size, GFP_KERNEL);
>>   		if (map->menu_info == NULL) {
>

