Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1LFWBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:01:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37281 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1LFWBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:01:13 -0500
Message-ID: <4EDE90A3.7050900@gmail.com>
Date: Tue, 06 Dec 2011 23:01:07 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v1 6/7] media: video: introduce face detection driver
 module
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>	<1322838172-11149-7-git-send-email-ming.lei@canonical.com>	<4EDD3DEE.6060506@gmail.com> <CACVXFVPrAro=3t-wpbR_cVahzcx7SCa2J=s2nyyKfQ6SG-i0VQ@mail.gmail.com>
In-Reply-To: <CACVXFVPrAro=3t-wpbR_cVahzcx7SCa2J=s2nyyKfQ6SG-i0VQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 03:07 PM, Ming Lei wrote:
> Hi,
> 
> Thanks for your review.
> 
> On Tue, Dec 6, 2011 at 5:55 AM, Sylwester Nawrocki <snjw23@gmail.com> wrote:
>> Hi Ming,
>>
>> (I've pruned the Cc list, leaving just the mailing lists)
>>
>> On 12/02/2011 04:02 PM, Ming Lei wrote:
>>> This patch introduces one driver for face detection purpose.
>>>
>>> The driver is responsible for all v4l2 stuff, buffer management
>>> and other general things, and doesn't touch face detection hardware
>>> directly. Several interfaces are exported to low level drivers
>>> (such as the coming omap4 FD driver)which will communicate with
>>> face detection hw module.
>>>
>>> So the driver will make driving face detection hw modules more
>>> easy.
>>
>>
>> I would hold on for a moment on implementing generic face detection
>> module which is based on the V4L2 video device interface. We need to
>> first define an API that would be also usable at sub-device interface
>> level (http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html).
> 
> If we can define a good/stable enough APIs between kernel and user space,
> I think the patches can be merged first. For internal kernel APIs, we should
> allow it to evolve as new hardware comes or new features are to be introduced.

I also don't see a problem in discussing it a bit more;)

> 
> I understand the API you mentioned here should belong to kernel internal
> API, correct me if it is wrong.

Yes, I meant the in kernel design, i.e. generic face detection kernel module
and an OMAP4 FDIF driver. It makes lots of sense to separate common code
in this way, maybe even when there would be only OMAP devices using it.

I'm sure now the Samsung devices won't fit in video output node based driver
design. They read image data in different ways and also the FD result format
is totally different.

> 
>> AFAICS OMAP4 FDIF processes only data stored in memory, thus it seems
>> reasonable to use the videodev interface for passing data to the kernel
>> from user space.
>>
>> But there might be face detection devices that accept data from other
>> H/W modules, e.g. transferred through SoC internal data buses between
>> image processing pipeline blocks. Thus any new interfaces need to be
>> designed with such devices in mind.
>>
>> Also the face detection hardware block might now have an input DMA
>> engine in it, the data could be fed from memory through some other
>> subsystem (e.g. resize/colour converter). Then the driver for that
>> subsystem would implement a video node.
> 
> I think the direct input image or frame data to FD should be from memory
> no matter the actual data is from external H/W modules or input DMA because
> FD will take lot of time to detect faces in one image or frame and FD can't
> have so much memory to cache several images or frames data.

Sorry, I cannot provide much details at the moment, but there exists hardware
that reads data from internal SoC buses and even if it uses some sort of
cache memory it doesn't necessarily have to be available for the user.

Still the FD result is associated with an image frame for such H/W, but not
necessarily with a memory buffer queued by a user application.

How long it approximately takes to process single image for OMAP4 FDIF ?

> 
> If you have seen this kind of FD hardware design, please let me know.
> 
>> I'm for leaving the buffer handling details for individual drivers
>> and focusing on a standard interface for applications, i.e. new
> 
> I think leaving buffer handling details in generic FD driver or
> individual drivers
> doesn't matter now, since it don't have effect on interfaces between kernel
> and user space.

I think you misunderstood me. I wasn't talking about core/driver module split,
I meant we should not be making the user interface video node centric.

I think for Samsung devices I'll need a capture video node for passing
the result to the user. So instead of associating FD result with a buffer index
we could try to use the frame sequence number (struct v4l2_buffer.sequence,
http://linuxtv.org/downloads/v4l-dvb-apis/buffer.html#v4l2-buffer).

It might be much better as the v4l2 events are associated with the frame
sequence. And if we use controls then you get control events for free,
and each event carries a frame sequence number int it
(http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-dqevent.html).

-- 

Regards,
Sylwester
