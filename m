Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891Ab0KQHxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 02:53:13 -0500
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1026 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab0KQHxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 02:53:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Subject: Re: [PATCH 1/1] videobuf: Initialize lists in videobuf_buffer.
Date: Wed, 17 Nov 2010 08:52:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-tschai; KDE/4.4.5; x86_64; ; )
Cc: Andrew Chew <AChew@nvidia.com>, "pawel@osciak.com" <pawel@osciak.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1289939083-27209-1-git-send-email-achew@nvidia.com> <201011170811.06697.hverkuil@xs4all.nl> <4CE3814B.5010008@leadcoretech.com>
In-Reply-To: <4CE3814B.5010008@leadcoretech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011170852.53093.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 17, 2010 08:16:27 Figo.zhang wrote:
> On 11/17/2010 03:11 PM, Hans Verkuil wrote:
> > On Wednesday, November 17, 2010 02:38:09 Andrew Chew wrote:
> >>>> diff --git a/drivers/media/video/videobuf-dma-contig.c
> >>> b/drivers/media/video/videobuf-dma-contig.c
> >>>> index c969111..f7e0f86 100644
> >>>> --- a/drivers/media/video/videobuf-dma-contig.c
> >>>> +++ b/drivers/media/video/videobuf-dma-contig.c
> >>>> @@ -193,6 +193,8 @@ static struct videobuf_buffer
> >>> *__videobuf_alloc_vb(size_t size)
> >>>>    	if (vb) {
> >>>>    		mem = vb->priv = ((char *)vb) + size;
> >>>>    		mem->magic = MAGIC_DC_MEM;
> >>>> +		INIT_LIST_HEAD(&vb->stream);
> >>>> +		INIT_LIST_HEAD(&vb->queue);
> >>>
> >>> i think it no need to be init, it just a list-entry.
> >>
> >> Okay, if that's really the case, then sh_mobile_ceu_camera.c, pxa_camera.c, mx1_camera.c, mx2_camera.c, and omap1_camera.c needs to be fixed to remove that WARN_ON(!list_empty(&vb->queue)); in their videobuf_prepare() methods, because those WARN_ON's are assuming that vb->queue is properly initialized as a list head.
> >>
> >> Which will it be?
> >>
> >
> > These list entries need to be inited. It is bad form to have uninitialized
> > list entries. It is not as if this is a big deal to initialize them properly.
> 
> in kernel source code, list entry are not often to be inited.
> 
> for example, see mm/vmscan.c register_shrinker(), no one init the 
> shrinker->list.
> 
> another example: see mm/swapfile.c  add_swap_extent(), no one init the
> new_se->list.

I have to think some more about this. I'll get back to this today. BTW, I do
agree that the WARN_ON's are bogus and should be removed.

And BTW, this isn't going to work either (mx1_camera.c):

static int mx1_camera_setup_dma(struct mx1_camera_dev *pcdev)
{
        struct videobuf_buffer *vbuf = &pcdev->active->vb;
        struct device *dev = pcdev->icd->dev.parent;
        int ret;

        if (unlikely(!pcdev->active)) {
                dev_err(dev, "DMA End IRQ with no active buffer\n");
                return -EFAULT;
        }

The vbuf assignment should be moved after the 'if'.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
