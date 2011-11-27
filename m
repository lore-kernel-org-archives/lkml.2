Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab1K0Qlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 11:41:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64550 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab1K0Qld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 11:41:33 -0500
Message-ID: <4ED26837.7070003@gmail.com>
Date: Sun, 27 Nov 2011 17:41:27 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-media <linux-media@vger.kernel.org>, tony@atomide.com,
        arnd@arndb.de, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/misc: introduce face detection module driver(fdif)
References: <1322281904-14526-1-git-send-email-tom.leiming@gmail.com>	<1322281904-14526-4-git-send-email-tom.leiming@gmail.com>	<4ED1652A.8080701@gmail.com> <CACVXFVOh=_wAmQB1fm88RTbwoJxCo5w57-TpiH8zx5V-CC_TqA@mail.gmail.com>
In-Reply-To: <CACVXFVOh=_wAmQB1fm88RTbwoJxCo5w57-TpiH8zx5V-CC_TqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

On 11/27/2011 04:40 AM, Ming Lei wrote:
> Hi guys,
> 
> Thanks for your comment.
> 
> On Sun, Nov 27, 2011 at 6:16 AM, Sylwester Nawrocki <snjw23@gmail.com> wrote:
>> Cc: LMML
>>
>> On 11/26/2011 05:31 AM, tom.leiming@gmail.com wrote:
>>> From: Ming Lei <ming.lei@canonical.com>
>>>
>>> One face detection IP[1] is integared inside OMAP4 SoC, so
>>> introduce this driver to make face detection function work
>>> on OMAP4 SoC.
>>
>> Face detection IP is of course not specific to OMAP, I've seen it in 
>> other SoCs already and integrated with the video capture pipeline.
> 
> Yes, the driver is platform independent, so at least it can support
> the same IP on different platforms.

It's all good, however we need to ensure interoperability with existing
drivers. I mean it shouldn't be difficult to setup data processing
pipelines containing  various types of devices, like video capture,
resizers, filters, etc. The situation where each type of device makes up
their own interface is rather far from ideal.

>>
>> And it clearly belongs to the media subsystem, there is already an 
>> infrastructure there that don't need to be re-invented, like buffer 
>> management and various IO method support.
>>
>> I think there is not much needed on top of that to support FD. We have 
>> already various mem-to-mem devices in V4L2, like video or image encoders
>> or video post-processors.
> 
> I have thought about the FD implementation on v4l2 core, but still not
> very clear
> how to do it. I will study v4l2 further to figure out how to do it.

I think we need a new user interface for that, the closest match would be
the Video Output Interface [1], IMHO this could be used as a base. I got
a bit confused by the additional working memory requirement and thought
the FDIF needs input and output memory buffers to process single image
frame. But that's not the case so there is no reason to bother with
the mem-to-mem interface.

Unfortunately there is no example of virtual output device driver in v4l2
yet. There is only one for the capture devices - drivers/media/video/vivi.c

For video output one uses V4L2_BUF_TYPE_VIDEO_OUTPUT buffer type instead of
V4L2_BUF_TYPE_VIDEO_CAPTURE and at the kernel side .vidioc_*_out operations
of struct v4l2_ioctl_ops should be implemented, rather than .vidioc_*_cap.

> 
> Now below are the basic requirements from FD:
> 
> - FD on video stream or pictures from external files
> - FD on video stream or pictures from video device
> (such as camera)

It's up to the applications in what way the image data is loaded into
memory buffer, if it comes from a file or from other device. Once it is in
standard v4l2 buffer object it can be shared between v4l2 drivers,
still user space needs to queue/de-queue buffers. See QBUF/DQBUF ioctls
[4] for more information.

> - the input video format may be different for different FD IP

That's normally handled by each v4l2 device, see [2] for details at the
user side, and vidioc_s_fmt_vid_cap() in vivi for example.

> - one method is required to start or stop FD

I suppose VIDIOC_STREAMON/VIDIOC_STREAMOFF would do the job, see [3] and
start/stop_streaming functions in vivi.

> - one method is required to report the detection results to user space

Perhaps we need new ioctl(s) for that. And possibly some new controls,
or even new control class [5], [6].

It would also be good to get requirements for other hardware implementations
existing out there. I might be able to look at the Samsung ones eventually,
but cannot guarantee this.

> 
> Any suggestions on how to implement FD on v4l2?
> 
> thanks,
> --
> Ming Lei

-- 
Regards,
Sylwester

[1] http://linuxtv.org/downloads/v4l-dvb-apis/devices.html
[2] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-fmt.html
[3] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-streamon.html
[4] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-qbuf.html
[5] http://linuxtv.org/downloads/v4l-dvb-apis/control.html
[6] http://linuxtv.org/downloads/v4l-dvb-apis/extended-controls.html
