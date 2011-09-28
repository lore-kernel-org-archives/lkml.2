Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1I1J6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:58:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:43869 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1I1J6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:58:17 -0400
Message-ID: <4E82EFAD.5060108@infradead.org>
Date: Wed, 28 Sep 2011 06:58:05 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Gary Thomas <gary@mlbassoc.com>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Ravi, Deepthy" <deepthy.ravi@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 4/8] ispvideo: Add support for G/S/ENUM_STD ioctl
References: <1315488922-16152-1-git-send-email-deepthy.ravi@ti.com> <201109081921.28051.laurent.pinchart@ideasonboard.com> <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D09083D@dbde03.ent.ti.com> <201109161506.16505.laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E739404EC8113E2@dbde02.ent.ti.com> <4E824EC4.20305@infradead.org> <4E8252F1.9@mlbassoc.com>
In-Reply-To: <4E8252F1.9@mlbassoc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-09-2011 19:49, Gary Thomas escreveu:
> On 2011-09-27 16:31, Mauro Carvalho Chehab wrote:
>> Em 19-09-2011 12:31, Hiremath, Vaibhav escreveu:
>>>
>>>> -----Original Message-----
>>>> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
>>>> Sent: Friday, September 16, 2011 6:36 PM
>>>> To: Ravi, Deepthy
>>>> Cc: linux-media@vger.kernel.org; tony@atomide.com; linux@arm.linux.org.uk;
>>>> linux-omap@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
>>>> kernel@vger.kernel.org; mchehab@infradead.org; g.liakhovetski@gmx.de;
>>>> Hiremath, Vaibhav
>>>> Subject: Re: [PATCH 4/8] ispvideo: Add support for G/S/ENUM_STD ioctl
>>>>
>>>> Hi Deepthy,
>>>>
>>>> On Friday 16 September 2011 15:00:53 Ravi, Deepthy wrote:
>>>>> On Thursday, September 08, 2011 10:51 PM Laurent Pinchart wrote:
>>>>>> On Thursday 08 September 2011 15:35:22 Deepthy Ravi wrote:
>>>>>>> From: Vaibhav Hiremath<hvaibhav@ti.com>
>>>>>>>
>>>>>>> In order to support TVP5146 (for that matter any video decoder),
>>>>>>> it is important to support G/S/ENUM_STD ioctl on /dev/videoX
>>>>>>> device node.
>>>>>>
>>>>>> Why so ? Shouldn't it be queried on the subdev output pad directly ?
>>>>>
>>>>> Because standard v4l2 application for analog devices will call these std
>>>>> ioctls on the streaming device node. So it's done on /dev/video to make
>>>> the
>>>>> existing apllication work.
>>>>
>>>> Existing applications can't work with the OMAP3 ISP (and similar complex
>>>> embedded devices) without userspace support anyway, either in the form of
>>>> a
>>>> GStreamer element or a libv4l plugin. I still believe that analog video
>>>> standard operations should be added to the subdev pad operations and
>>>> exposed
>>>> through subdev device nodes, exactly as done with formats.
>>>>
>>> [Hiremath, Vaibhav] Laurent,
>>>
>>> I completely agree with your point that, existing application will not work without setting links properly.
>>> But I believe the assumption here is, media-controller should set the links (along with pad formants) and
>>> all existing application should work as is. Isn't it?
>>
>> Yes.
>>
>>> The way it is being done currently is, set the format at the pad level which is same as analog standard resolution and use existing application for streaming...
>>
>> Yes.
>>
>>> I am ok, if we add s/g/enum_std api support at sub-dev level but this should also be supported on streaming device node.
>>
>> Agreed. Standards selection should be done at device node, just like any other
>> device.
> 
> So how do you handle a part like the TVP5150 that is standard agnostic?
> That device can sense the standard from the input signal and sets the
> result appropriately.
> 
See the em28xx driver. It uses tvp5150 at the device node, and works properly.

It should be noticed, however, that the implementation at tvp5150 doesn't
implement standards detection properly, due to hardware limitation.

A proper implementation of standards detection is to get the standards mask from
userspace and let the driver detect between the standards that the userspace is
expecting.

So, userspace could, for example, do things like:

	v4l2_std_id std = V4L2_STD_PAL_M | V4L2_STD_NTSC_M | V4L2_STD_PAL_DK;

	ioctl (fd, VIDIOC_S_STD, &std);
	msleep (100);
	ioctl (fd, VIDIOC_G_STD, &std);
	if (std & V4L2_STD_625_50)
		height = 576;
	else
		height = 480;

The above code won't work with the current tvp5150 driver, due to two reasons:

1) The tvp5150 register 0x28 doesn't allow an arbitrary standards mask like the above.
The driver does support standards detection, if V4L2_STD_ALL is passed into it.

2) even if V4L2_STD_ALL is used, the driver currently doesn't implement a
vidioc_g_std callback. So, the driver cannot return back to userspace and to
the bridge driver what standard were detected. Without this information, userspace
might use the wrong number of lines when allocating the buffer, and this won't
work.

Of course, patches for fixing this are welcome.

Thanks,
Mauro
