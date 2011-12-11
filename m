Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1LKRnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 12:43:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34340 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1LKRns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 12:43:48 -0500
Message-ID: <4EE4EBCF.8000202@gmail.com>
Date: Sun, 11 Dec 2011 18:43:43 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v1 6/7] media: video: introduce face detection driver
 module
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>	<1322838172-11149-7-git-send-email-ming.lei@canonical.com>	<4EDD3DEE.6060506@gmail.com>	<CACVXFVPrAro=3t-wpbR_cVahzcx7SCa2J=s2nyyKfQ6SG-i0VQ@mail.gmail.com>	<4EDE90A3.7050900@gmail.com>	<CACVXFVN=-0OQ_Tz+HznDug4baLmLNjxVE21gv6CGFoU+hzCtPQ@mail.gmail.com>	<4EE14787.8090509@gmail.com> <CACVXFVNV3TLNvPMU4oj6X+Yj5wqhNvcU_ZpyCd1wMm8B2azT4w@mail.gmail.com>
In-Reply-To: <CACVXFVNV3TLNvPMU4oj6X+Yj5wqhNvcU_ZpyCd1wMm8B2azT4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 04:10 PM, Ming Lei wrote:
> On Fri, Dec 9, 2011 at 7:25 AM, Sylwester Nawrocki <snjw23@gmail.com> wrote:
>> On 12/07/2011 02:40 PM, Ming Lei wrote:
>>> Yes, that is the motivation of the generic FD module. I think we can focus on
>>> two use cases for the generic FD now:
>>>
>>> - one is to detect faces from user space image data
>>>
>>> - another one is to detect faces in image data generated from HW(SoC
>>> internal bus, resize hardware)
>>>
>>> For OMAP4 hardware, input data is always from physically continuous
>>> memory directly, so it is very easy to support the two cases. For the
>>> use case 2,
>>> if buffer copy is to be avoided, we can use the coming shared dma-buf[1]
>>> to pass the image buffer produced by other HW to FD hw directly.
>>
>> Some H/W uses direct data buses to exchange data between processing blocks,
>> and there is no need for additional memory. We only need to manage the data
>> links, for which MC has been designed.
> 
> For OMAP4 FD, it is not needed to include FD into MC framework since a
> intermediate buffer is always required. If your HW doesn't belong to this
> case, what is the output of your HW FD in the link? Also sounds FD results
> may not be needed at all for use space application in the case.

The result data is similar to OMAP4 one, plus a few other attributes.
User buffers may be filled by other than FD device driver.

>>> For other FD hardware, if it supports to detect faces in image data from
>>> physically continuous memory, I think the patch is OK to support it.
>>>
>>> If the FD hw doesn't support to detect faces from physically continuous
>>> memory, I have some questions: how does user space app to parse the
>>> FD result if application can't get the input image data? If user space can
>>
>> Do we need the map of detected objects on a input image in all cases ?
> 
> For normal cases, I think we need, :-)
> 
>> If an application needs only coordinates of detected object on a video
>> signal to for example, focus on it, trigger some action, or just count
>> detected faces, etc. Perhaps there are more practical similar use cases.
> 
> Could you provide some practical use cases about these?

As above, and any device with a camera that controls something and makes
decision according to presence of human face in his view.

>>> get image data, how does it connect the image data with FD result? and
>>
>> If hardware provides frame sequence numbers the FD result can be associated
>> with a frame, whether it's passing through H/W interconnect or is located
>> in memory.
> 
> If FD result is associated with a frame, how can user space get the frame seq
> if no v4l2 buffer is involved? Without a frame sequence, it is a bit
> difficult to retrieve FD results from user space.

If you pass image data in memory buffers from user space, yes, it could be
impossible. If there is no buffers you don't need to associate FD result
with particular image data. There will be just ascending frame identifiers
in reported fd result data...

>>> what standard v4l2 ways(v4l2_buffer?) can the app use to describe the
>>> image data?
>>
>> We have USERPTR and MMAP memeory buffer for streaming IO, those use
>> v4l2_buffer 1). read()/write() is also used 2), mostly for compressed formats.
>> Except that there are works on shared buffers.
> 
> If the input image data is from other HW(SoC bus, resizer HW, ...), is the
> v4l2_buffer needed for the FD HW driver or application?

Not really, still v4l2_buffer may be used by other (sub)driver within same video
processing pipeline.

>>>> How long it approximately takes to process single image for OMAP4 FDIF ?
>>>
>>> See the link[2], and my test result is basically consistent with the data.
>>
>> Thanks. The processing time is rather low, looks like we could easily detect
>> objects in each frame with 30..50 fps.
> 
> The detection time on image or frame data may be changed a lot, are
> you sure that your FD HW can handle the data flow correctly? I understand
> you FD HW has to integrate at least two buffers for coping with the issue, so it
> should introduce some extra HW cost.
> 

I'm not absolutely sure, untill I write the driver and test it myself.. ;)

[...]
>> No, I still insist on using frame sequence number rather than buffer index :-)
> 
> As I mentioned above, how does user space get frame sequence number
> for retrieving FD results if no v4l2_buffer is involved for FD driver
> and application?

It will be included in the FD result... or in a dedicated v4l2 event data structure.
More important, at the end of the day, we'll be getting buffers with image data
at some stage of a video pipeline, which would contain same frame identifier
(I think we can ignore v4l2_buffer.field for FD purpose).

-- 

Regards,
Sylwester
