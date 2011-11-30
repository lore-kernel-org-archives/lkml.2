Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1K3C2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:28:35 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59500 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1K3C2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:28:33 -0500
MIME-Version: 1.0
In-Reply-To: <201111300222.42162.laurent.pinchart@ideasonboard.com>
References: <1322602345-26279-1-git-send-email-haogangchen@gmail.com>
	<201111300222.42162.laurent.pinchart@ideasonboard.com>
Date: Tue, 29 Nov 2011 21:28:32 -0500
Message-ID: <CAHrvArQy2N4jUBQpBG+mey9KE412cURK9CU=1xZ_xodA_Vb8Jw@mail.gmail.com>
Subject: Re: [PATCH] Media: video: uvc: integer overflow in uvc_ioctl_ctrl_map()
From: Haogang Chen <haogangchen@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hard limit sounds good to me. But if you want to centralize error
handling, please make sure that "goto done" only frees map, but not
map->menu_info in that case.

- Haogang




On Tue, Nov 29, 2011 at 8:22 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
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
>
>> Signed-off-by: Haogang Chen <haogangchen@gmail.com>
>> ---
>>  drivers/media/video/uvc/uvc_v4l2.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
>> b/drivers/media/video/uvc/uvc_v4l2.c index dadf11f..9a180d6 100644
>> --- a/drivers/media/video/uvc/uvc_v4l2.c
>> +++ b/drivers/media/video/uvc/uvc_v4l2.c
>> @@ -58,6 +58,12 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain
>> *chain, break;
>>
>>       case V4L2_CTRL_TYPE_MENU:
>> +             if (xmap->menu_count == 0 ||
>> +                 xmap->menu_count > INT_MAX / sizeof(*map->menu_info)) {
>
> I'd like to prevent excessive memory consumption by limiting the number of
> menu entries, similarly to how the driver limits the number of mappings.
> Defining UVC_MAX_CONTROL_MENU_ENTRIES to 32 in uvcvideo.h should be a
> reasonable value.
>
>> +                     kfree(map);
>> +                     return -EINVAL;
>
> I'd rather do
>
>        ret = -EINVAL;
>        goto done;
>
> to centralize error handling.
>
> If you're fine with both changes I can modify the patch, there's no need to
> resubmit.
>
>> +             }
>> +
>>               size = xmap->menu_count * sizeof(*map->menu_info);
>>               map->menu_info = kmalloc(size, GFP_KERNEL);
>>               if (map->menu_info == NULL) {
>
> --
> Regards,
>
> Laurent Pinchart
>
