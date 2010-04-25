Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0DYQUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 12:20:50 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:50768 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab0DYQUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 12:20:48 -0400
X-Greylist: delayed 1160 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Apr 2010 12:20:48 EDT
X-SENDER-IP: [85.228.126.153]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArobABsE1EtV5H6ZPGdsb2JhbAAHgw+EUpRWAQEBATWtPI9vgSaCeW0E
X-IronPort-AV: E=Sophos;i="4.52,270,1270418400"; 
   d="scan'208";a="511866479"
Message-ID: <4BD46753.9010807@pelagicore.com>
Date: Sun, 25 Apr 2010 18:01:23 +0200
From: =?UTF-8?B?UmljaGFyZCBSw7ZqZm9ycw==?= 
	<richard.rojfors@pelagicore.com>
Organization: Pelagicore AB
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100411 Iceowl/1.0b1 Icedove/3.0.4
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Douglas Schilling Landgraf <dougsland@gmail.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] media: Add timberdale video-in driver
References: <1271435291.11641.45.camel@debian> <4BD45EB1.5020804@redhat.com>
In-Reply-To: <4BD45EB1.5020804@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2010 05:24 PM, Mauro Carvalho Chehab wrote:
> Richard Röjfors wrote:
>> This patch adds the timberdale video-in driver.
>>
>> The video IP of timberdale delivers the video data via DMA.
>> The driver uses the DMA api to handle DMA transfers, and make use
>> of the V4L2 videobuffers to handle buffers against user space.
>> Due to some timing constraint it makes sense to do DMA into an
>> intermediate buffer and then copy the data to vmalloc:ed buffers.
>>
>> If available the driver uses an encoder to get/set the video standard
>>
>> Signed-off-by: Richard Röjfors<richard.rojfors@pelagicore.com>
>> +#define TIMBLOGIW_DMA_BUFFER_SIZE	(TIMBLOGIW_BYTES_PER_LINE * 576)
>
> ...
>
>> +static int __timblogiw_alloc_dma(struct timblogiw_fh *fh, struct device *dev)
>> +{
>> +	dma_addr_t addr;
>> +	int err, i, pos;
>> +	int bytes_per_desc = TIMBLOGIW_LINES_PER_DESC *
>> +		timblogiw_bytes_per_line(fh->cur_norm);
>> +
>> +	fh->dma.cookie = -1;
>> +	fh->dma.dev = dev;
>> +
>> +	fh->dma.buf = kzalloc(TIMBLOGIW_DMA_BUFFER_SIZE, GFP_KERNEL);
>> +	if (!fh->dma.buf)
>> +		return -ENOMEM;
>
>
> Why do you need a fixed DMA buffer size? Just allocate the buffer size dynamically at
> buffer_prepare callback.
>> +	videobuf_queue_vmalloc_init(&fh->vb_vidq,&timblogiw_video_qops,
>> +			NULL,&fh->queue_lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
>> +			V4L2_FIELD_NONE, sizeof(struct videobuf_buffer), fh);
>
> You should be using, instead, videobuf_dma_sg or videobuf_cont, instead of
> using videobuf-vmalloc. This way, you'll avoid double buffering.

1. dma_sg can not be used, the DMA engine requires the memory blocks to be aligned on a factor of 
bytes per line, so 4K pages wouldn't work.

2.
I tried using videobuf-dma-contig, but got poor performance. I can not really explain why, I though 
it's due to the fact that the contiguous buffer is allocated coherent -> no caching.
I saw both gstreamer and mplayer perform very badly.
The frame grabber requires the DMA transfer for a frame beeing started while the frame is decoded. 
When I tested using contigous buffers gstreamer sometimes was that slow that it sometimes missed to 
have a frame queued when a transfer was finished, so I got frame drops. Any other ideas of the poor 
performance? otherwise I would like to go for the double buffered solution.

Thanks
--Richard
