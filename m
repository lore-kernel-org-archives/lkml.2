Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1K1DmM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 22:42:12 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46055 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1K1DmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 22:42:10 -0500
MIME-Version: 1.0
In-Reply-To: <4ED26837.7070003@gmail.com>
References: <1322281904-14526-1-git-send-email-tom.leiming@gmail.com>
	<1322281904-14526-4-git-send-email-tom.leiming@gmail.com>
	<4ED1652A.8080701@gmail.com>
	<CACVXFVOh=_wAmQB1fm88RTbwoJxCo5w57-TpiH8zx5V-CC_TqA@mail.gmail.com>
	<4ED26837.7070003@gmail.com>
Date: Mon, 28 Nov 2011 11:42:07 +0800
Message-ID: <CACVXFVNLDGDCuTuqN0puYfXkMgPgWsmghV2F4kHLu7OD5GSZog@mail.gmail.com>
Subject: Re: [PATCH 3/3] drivers/misc: introduce face detection module driver(fdif)
From: Ming Lei <tom.leiming@gmail.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-media <linux-media@vger.kernel.org>, tony@atomide.com,
        arnd@arndb.de, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

Great thanks for providing so detailed v4l2 background.

On Mon, Nov 28, 2011 at 12:41 AM, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> Hi Ming,
>
> On 11/27/2011 04:40 AM, Ming Lei wrote:
>> Hi guys,
>>
>> Thanks for your comment.
>>
>> On Sun, Nov 27, 2011 at 6:16 AM, Sylwester Nawrocki <snjw23@gmail.com> wrote:
>>> Cc: LMML
>>>
>>> On 11/26/2011 05:31 AM, tom.leiming@gmail.com wrote:
>>>> From: Ming Lei <ming.lei@canonical.com>
>>>>
>>>> One face detection IP[1] is integared inside OMAP4 SoC, so
>>>> introduce this driver to make face detection function work
>>>> on OMAP4 SoC.
>>>
>>> Face detection IP is of course not specific to OMAP, I've seen it in
>>> other SoCs already and integrated with the video capture pipeline.
>>
>> Yes, the driver is platform independent, so at least it can support
>> the same IP on different platforms.
>
> It's all good, however we need to ensure interoperability with existing
> drivers. I mean it shouldn't be difficult to setup data processing
> pipelines containing  various types of devices, like video capture,
> resizers, filters, etc. The situation where each type of device makes up
> their own interface is rather far from ideal.

Yes, so it does make sense to implement FD based on v4l2 framework.

>
>>>
>>> And it clearly belongs to the media subsystem, there is already an
>>> infrastructure there that don't need to be re-invented, like buffer
>>> management and various IO method support.
>>>
>>> I think there is not much needed on top of that to support FD. We have
>>> already various mem-to-mem devices in V4L2, like video or image encoders
>>> or video post-processors.
>>
>> I have thought about the FD implementation on v4l2 core, but still not
>> very clear
>> how to do it. I will study v4l2 further to figure out how to do it.
>
> I think we need a new user interface for that, the closest match would be
> the Video Output Interface [1], IMHO this could be used as a base. I got
> a bit confused by the additional working memory requirement and thought

I think the working memory is used by FD HW module to run its built-in face
detection algorithm, so that lots of ram can be saved in the module.

> the FDIF needs input and output memory buffers to process single image
> frame. But that's not the case so there is no reason to bother with

I think only output memory buffers are enough for FD device, we can get
the detection result from ioctl, then let application to handle it.

> the mem-to-mem interface.
>
> Unfortunately there is no example of virtual output device driver in v4l2
> yet. There is only one for the capture devices - drivers/media/video/vivi.c
>
> For video output one uses V4L2_BUF_TYPE_VIDEO_OUTPUT buffer type instead of
> V4L2_BUF_TYPE_VIDEO_CAPTURE and at the kernel side .vidioc_*_out operations
> of struct v4l2_ioctl_ops should be implemented, rather than .vidioc_*_cap.

It is very helpful.

>>
>> Now below are the basic requirements from FD:
>>
>> - FD on video stream or pictures from external files
>> - FD on video stream or pictures from video device
>> (such as camera)
>
> It's up to the applications in what way the image data is loaded into
> memory buffer, if it comes from a file or from other device. Once it is in
> standard v4l2 buffer object it can be shared between v4l2 drivers,
> still user space needs to queue/de-queue buffers. See QBUF/DQBUF ioctls
> [4] for more information.

If the image data comes from a device(capture device, or resize
post-processing),
face detect module should use the buffer directly and avoid
to copy image data from capture or resize buffer if the image format is
same with what FD requires and the buffer is physical continuous.

But I am not sure how to handle this case? Could we need to add a ioctl to
make FD device see the buffer from capture or resize device?

Also, could you give a introduction about how v4l2 handles resize if
HW is capable of resizing?

>
>> - the input video format may be different for different FD IP
>
> That's normally handled by each v4l2 device, see [2] for details at the
> user side, and vidioc_s_fmt_vid_cap() in vivi for example.

Agree.

>> - one method is required to start or stop FD
>
> I suppose VIDIOC_STREAMON/VIDIOC_STREAMOFF would do the job, see [3] and
> start/stop_streaming functions in vivi.

Agree.

>> - one method is required to report the detection results to user space
>
> Perhaps we need new ioctl(s) for that. And possibly some new controls,
> or even new control class [5], [6].

Agree.

> It would also be good to get requirements for other hardware implementations
> existing out there. I might be able to look at the Samsung ones eventually,
> but cannot guarantee this.

It is great for you to provide some information about FD on Samsung SoC,
so that we can figure out a more generic implementation to make support
for new FD IP easier.

>>
>> Any suggestions on how to implement FD on v4l2?
>>
>> thanks,
>> --
>> Ming Lei
>
> --
> Regards,
> Sylwester
>
> [1] http://linuxtv.org/downloads/v4l-dvb-apis/devices.html
> [2] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-fmt.html
> [3] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-streamon.html
> [4] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-qbuf.html
> [5] http://linuxtv.org/downloads/v4l-dvb-apis/control.html
> [6] http://linuxtv.org/downloads/v4l-dvb-apis/extended-controls.html
>


thanks,
-- 
Ming Lei
