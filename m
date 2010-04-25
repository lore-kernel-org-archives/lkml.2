Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab0DYPYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 11:24:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab0DYPYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 11:24:46 -0400
Message-ID: <4BD45EB1.5020804@redhat.com>
Date: Sun, 25 Apr 2010 12:24:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: =?UTF-8?B?UmljaGFyZCBSw7ZqZm9ycw==?= 
	<richard.rojfors@pelagicore.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Douglas Schilling Landgraf <dougsland@gmail.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] media: Add timberdale video-in driver
References: <1271435291.11641.45.camel@debian>
In-Reply-To: <1271435291.11641.45.camel@debian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Röjfors wrote:
> This patch adds the timberdale video-in driver.
> 
> The video IP of timberdale delivers the video data via DMA.
> The driver uses the DMA api to handle DMA transfers, and make use
> of the V4L2 videobuffers to handle buffers against user space.
> Due to some timing constraint it makes sense to do DMA into an
> intermediate buffer and then copy the data to vmalloc:ed buffers.
> 
> If available the driver uses an encoder to get/set the video standard
> 
> Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
> +#define TIMBLOGIW_DMA_BUFFER_SIZE	(TIMBLOGIW_BYTES_PER_LINE * 576)

...

> +static int __timblogiw_alloc_dma(struct timblogiw_fh *fh, struct device *dev)
> +{
> +	dma_addr_t addr;
> +	int err, i, pos;
> +	int bytes_per_desc = TIMBLOGIW_LINES_PER_DESC *
> +		timblogiw_bytes_per_line(fh->cur_norm);
> +
> +	fh->dma.cookie = -1;
> +	fh->dma.dev = dev;
> +
> +	fh->dma.buf = kzalloc(TIMBLOGIW_DMA_BUFFER_SIZE, GFP_KERNEL);
> +	if (!fh->dma.buf)
> +		return -ENOMEM;


Why do you need a fixed DMA buffer size? Just allocate the buffer size dynamically at
buffer_prepare callback.
> +	videobuf_queue_vmalloc_init(&fh->vb_vidq, &timblogiw_video_qops,
> +			NULL, &fh->queue_lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +			V4L2_FIELD_NONE, sizeof(struct videobuf_buffer), fh);

You should be using, instead, videobuf_dma_sg or videobuf_cont, instead of
using videobuf-vmalloc. This way, you'll avoid double buffering.

-- 

Cheers,
Mauro
