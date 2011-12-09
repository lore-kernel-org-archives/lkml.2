Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab1LIPKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:10:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52890 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab1LIPKt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:10:49 -0500
MIME-Version: 1.0
In-Reply-To: <4EE14787.8090509@gmail.com>
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>
	<1322838172-11149-7-git-send-email-ming.lei@canonical.com>
	<4EDD3DEE.6060506@gmail.com>
	<CACVXFVPrAro=3t-wpbR_cVahzcx7SCa2J=s2nyyKfQ6SG-i0VQ@mail.gmail.com>
	<4EDE90A3.7050900@gmail.com>
	<CACVXFVN=-0OQ_Tz+HznDug4baLmLNjxVE21gv6CGFoU+hzCtPQ@mail.gmail.com>
	<4EE14787.8090509@gmail.com>
Date: Fri, 9 Dec 2011 23:10:46 +0800
Message-ID: <CACVXFVNV3TLNvPMU4oj6X+Yj5wqhNvcU_ZpyCd1wMm8B2azT4w@mail.gmail.com>
Subject: Re: [RFC PATCH v1 6/7] media: video: introduce face detection driver module
From: Ming Lei <ming.lei@canonical.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 9, 2011 at 7:25 AM, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> On 12/07/2011 02:40 PM, Ming Lei wrote:
>>>> I understand the API you mentioned here should belong to kernel internal
>>>> API, correct me if it is wrong.
>>>
>>> Yes, I meant the in kernel design, i.e. generic face detection kernel module
>>> and an OMAP4 FDIF driver. It makes lots of sense to separate common code
>>> in this way, maybe even when there would be only OMAP devices using it.
>>
>> Yes, that is the motivation of the generic FD module. I think we can focus on
>> two use cases for the generic FD now:
>>
>> - one is to detect faces from user space image data
>>
>> - another one is to detect faces in image data generated from HW(SoC
>> internal bus, resize hardware)
>>
>> For OMAP4 hardware, input data is always from physically continuous
>> memory directly, so it is very easy to support the two cases. For the
>> use case 2,
>> if buffer copy is to be avoided, we can use the coming shared dma-buf[1]
>> to pass the image buffer produced by other HW to FD hw directly.
>
> Some H/W uses direct data buses to exchange data between processing blocks,
> and there is no need for additional memory. We only need to manage the data
> links, for which MC has been designed.

For OMAP4 FD, it is not needed to include FD into MC framework since a
intermediate buffer is always required. If your HW doesn't belong to this
case, what is the output of your HW FD in the link? Also sounds FD results
may not be needed at all for use space application in the case.

>
>>
>> For other FD hardware, if it supports to detect faces in image data from
>> physically continuous memory, I think the patch is OK to support it.
>>
>> If the FD hw doesn't support to detect faces from physically continuous
>> memory, I have some questions: how does user space app to parse the
>> FD result if application can't get the input image data? If user space can
>
> Do we need the map of detected objects on a input image in all cases ?

For normal cases, I think we need, :-)

> If an application needs only coordinates of detected object on a video
> signal to for example, focus on it, trigger some action, or just count
> detected faces, etc. Perhaps there are more practical similar use cases.

Could you provide some practical use cases about these?

>> get image data, how does it connect the image data with FD result? and
>
> If hardware provides frame sequence numbers the FD result can be associated
> with a frame, whether it's passing through H/W interconnect or is located
> in memory.

If FD result is associated with a frame, how can user space get the frame seq
if no v4l2 buffer is involved? Without a frame sequence, it is a bit
difficult to
retrieve FD results from user space.

>> what standard v4l2 ways(v4l2_buffer?) can the app use to describe the
>> image data?
>
> We have USERPTR and MMAP memeory buffer for streaming IO, those use
> v4l2_buffer 1). read()/write() is also used 2), mostly for compressed formats.
> Except that there are works on shared buffers.

If the input image data is from other HW(SoC bus, resizer HW, ...), is the
v4l2_buffer needed for the FD HW driver or application?

>
>>
>>> I'm sure now the Samsung devices won't fit in video output node based driver
>>> design. They read image data in different ways and also the FD result format
>>> is totally different.
>>
>> I think user space will need the FD result, so it is very important to define
>> API to describe the FD result format to user space. And the input about your
>> FD HW result format is certainly helpful to define the API.
>
> I'll post exact attributes generated by our FD detection H/W soon.

Good news, :-)

>>
>>>>
>>>>> AFAICS OMAP4 FDIF processes only data stored in memory, thus it seems
>>>>> reasonable to use the videodev interface for passing data to the kernel
>>>>> from user space.
>>>>>
>>>>> But there might be face detection devices that accept data from other
>>>>> H/W modules, e.g. transferred through SoC internal data buses between
>>>>> image processing pipeline blocks. Thus any new interfaces need to be
>>>>> designed with such devices in mind.
>>>>>
>>>>> Also the face detection hardware block might now have an input DMA
>>>>> engine in it, the data could be fed from memory through some other
>>>>> subsystem (e.g. resize/colour converter). Then the driver for that
>>>>> subsystem would implement a video node.
>>>>
>>>> I think the direct input image or frame data to FD should be from memory
>>>> no matter the actual data is from external H/W modules or input DMA because
>>>> FD will take lot of time to detect faces in one image or frame and FD can't
>>>> have so much memory to cache several images or frames data.
>>>
>>> Sorry, I cannot provide much details at the moment, but there exists hardware
>>> that reads data from internal SoC buses and even if it uses some sort of
>>> cache memory it doesn't necessarily have to be available for the user.
>>
>> Without some hardware background, it is not easy to give a generic FD module
>> design.
>
> Yes, please give me some time so I can prepare the list of requirements.
>
>>
>>> Still the FD result is associated with an image frame for such H/W, but not
>>> necessarily with a memory buffer queued by a user application.
>>
>> For user space application, it doesn't make sense to handle FD results
>> only without image data.  Even though there are other ways of input
>> image data to FD, user space still need to know the image data, so it makes
>> sense to associate FD result with a memory buffer.
>>
>>> How long it approximately takes to process single image for OMAP4 FDIF ?
>>
>> See the link[2], and my test result is basically consistent with the data.
>
> Thanks. The processing time is rather low, looks like we could easily detect
> objects in each frame with 30..50 fps.

The detection time on image or frame data may be changed a lot, are
you sure that your FD HW can handle the data flow correctly? I understand
you FD HW has to integrate at least two buffers for coping with the issue, so it
should introduce some extra HW cost.

>>
>>>>
>>>> If you have seen this kind of FD hardware design, please let me know.
>>>>
>>>>> I'm for leaving the buffer handling details for individual drivers
>>>>> and focusing on a standard interface for applications, i.e. new
>>>>
>>>> I think leaving buffer handling details in generic FD driver or
>>>> individual drivers
>>>> doesn't matter now, since it don't have effect on interfaces between kernel
>>>> and user space.
>>>
>>> I think you misunderstood me. I wasn't talking about core/driver module split,
>>> I meant we should not be making the user interface video node centric.
>>>
>>> I think for Samsung devices I'll need a capture video node for passing
>>
>> Why is it a capture video node instead of OUTPUT v4l2 device? I think the
>
> Let's forget about this capture device, I'm just in progress of learning
> our devices internals, that's quite huge IPs..
>
>> device name should be decided from the view of face detection function:
>> FD need input image data and produce detection result.
>
> No, we should be flexible about where the data comes from to a FD subsystem
> and how it is then processed - if it is passed to some other processing block
> or it is transferred to memory with DMA and returned to the user. And we
> should use Media Controller API to route the data according to application
> requirements.
> OMAP4 FDIF is pretty simple, we need to think more about integrating FD with
> existing data pipelines.

We are discussing about it, :-)

>
>>
>>> the result to the user. So instead of associating FD result with a buffer index
>>
>> See the explanation above.
>
> No, I still insist on using frame sequence number rather than buffer index :-)

As I mentioned above, how does user space get frame sequence number
for retrieving FD results if no v4l2_buffer is involved for FD driver
and application?

>>
>>> we could try to use the frame sequence number (struct v4l2_buffer.sequence,
>>> http://linuxtv.org/downloads/v4l-dvb-apis/buffer.html#v4l2-buffer).
>>
>> [1], http://marc.info/?t=132281644700005&r=1&w=2
>> [2], http://e2e.ti.com/support/embedded/linux/f/354/t/128938.aspx#462740
>
> 1) http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-qbuf.html
> 2) http://linuxtv.org/downloads/v4l-dvb-apis/func-write.html
>
>
> --
>
> Thanks,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

thanks,
--
Ming Lei
