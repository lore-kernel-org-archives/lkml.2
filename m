Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1LKKb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 05:31:27 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:51238 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1LKKbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 05:31:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Media: video: uvc: integer overflow in uvc_ioctl_ctrl_map()
Date: Sun, 11 Dec 2011 11:31:37 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.3; x86_64; ; )
Cc: Haogang Chen <haogangchen@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1322602345-26279-1-git-send-email-haogangchen@gmail.com> <201111300222.42162.laurent.pinchart@ideasonboard.com> <4EE48465.9060706@infradead.org>
In-Reply-To: <4EE48465.9060706@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112111131.37867.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Sunday 11 December 2011 11:22:29 Mauro Carvalho Chehab wrote:
> On 29-11-2011 23:22, Laurent Pinchart wrote:
> > Hi Haogang,
> > 
> > On Tuesday 29 November 2011 22:32:25 Haogang Chen wrote:
> >> There is a potential integer overflow in uvc_ioctl_ctrl_map(). When a
> >> large xmap->menu_count is passed from the userspace, the subsequent call
> >> to kmalloc() will allocate a buffer smaller than expected.
> >> map->menu_count and map->menu_info would later be used in a loop (e.g.
> >> in uvc_query_v4l2_ctrl), which leads to out-of-bound access.
> >> 
> >> The patch checks the ioctl argument and returns -EINVAL for zero or too
> >> large values in xmap->menu_count.
> > 
> > Thanks for the patch.
> 
> I'm assuming that either one of you will re-send the patches with the
> pointed changes, so, I'm marking this one with "changes requested" at
> patchwork.

The modified patch is included in my latest pull request.

I had forgotten to CC stable@kernel.org in the commit message. I've updated 
the uvcvideo-next branch, but have you already pulled from it ? If so, could 
you add Cc: stable@kernel.org to the patch, or should I send a v2 for the pull 
request ?

> >> Signed-off-by: Haogang Chen<haogangchen@gmail.com>
> >> ---
> >> 
> >>   drivers/media/video/uvc/uvc_v4l2.c |    6 ++++++
> >>   1 files changed, 6 insertions(+), 0 deletions(-)
> >> 
> >> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> >> b/drivers/media/video/uvc/uvc_v4l2.c index dadf11f..9a180d6 100644
> >> --- a/drivers/media/video/uvc/uvc_v4l2.c
> >> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> >> @@ -58,6 +58,12 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain
> >> *chain, break;
> >> 
> >>   	case V4L2_CTRL_TYPE_MENU:
> >> +		if (xmap->menu_count == 0 ||
> >> +		    xmap->menu_count>  INT_MAX / sizeof(*map->menu_info)) {
> > 
> > I'd like to prevent excessive memory consumption by limiting the number
> > of menu entries, similarly to how the driver limits the number of
> > mappings. Defining UVC_MAX_CONTROL_MENU_ENTRIES to 32 in uvcvideo.h
> > should be a reasonable value.
> > 
> >> +			kfree(map);
> >> +			return -EINVAL;
> > 
> > I'd rather do
> > 
> > 	ret = -EINVAL;
> > 	goto done;
> > 
> > to centralize error handling.
> > 
> > If you're fine with both changes I can modify the patch, there's no need
> > to resubmit.
> > 
> >> +		}
> >> +
> >> 
> >>   		size = xmap->menu_count * sizeof(*map->menu_info);
> >>   		map->menu_info = kmalloc(size, GFP_KERNEL);
> >>   		if (map->menu_info == NULL) {

-- 
Regards,

Laurent Pinchart
