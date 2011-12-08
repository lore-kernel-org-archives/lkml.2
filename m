Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1LHW1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:27:39 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47560 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1LHW1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:27:36 -0500
Message-ID: <4EE139D1.4030503@gmail.com>
Date: Thu, 08 Dec 2011 23:27:29 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face
 detection
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>	<1322838172-11149-6-git-send-email-ming.lei@canonical.com>	<4EDD428B.9010800@gmail.com> <CACVXFVMR_n946HW1eYWEfcig_D6wFx5e3vEKmVHtERcmtsXX6g@mail.gmail.com>
In-Reply-To: <CACVXFVMR_n946HW1eYWEfcig_D6wFx5e3vEKmVHtERcmtsXX6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 04:42 AM, Ming Lei wrote:
>>> +/**
>>> + * struct v4l2_obj_detection
>>> + * @buf_index:       entry, index of v4l2_buffer for face detection

I would prefer having the frame sequence number here. It will be more
future proof IMHO. If for instance we decide to use such an ioctl on
a v4l2 sub-device, without dequeuing buffers, there will be no problem
with that. And still in your specific use case it's not big deal to
look up the buffer index given it's sequence number in the application.

>>> + * @centerx: return, position in x direction of detected object
>>> + * @centery: return, position in y direction of detected object
>>> + * @angle:   return, angle of detected object
>>> + *           0 deg ~ 359 deg, vertical is 0 deg, clockwise
>>> + * @sizex:   return, size in x direction of detected object
>>> + * @sizey:   return, size in y direction of detected object
>>> + * @confidence:      return, confidence level of detection result
>>> + *           0: the heighest level, 9: the lowest level
>>
>> Hmm, not a good idea to align a public interface to the capabilities
>> of a single hardware implementation.
> 
> I think that the current omap interface is general enough, so why can't
> we use it as public interface?

I meant exactly the line implying the range. What if for some hardware
it's 0..11 ?

> 
>> min/max confidence could be queried with
>> relevant controls and here we could remove the line implying range.
> 
> No, the confidence is used to describe the probability about
> the correctness of the current detection result. Anyway, no FD can
> make sure that it is 100% correct.  Other HW can normalize its
> confidence level to 0~9 so that application can handle it easily, IMO.

1..100 might be better, to minimize rounding errors. Nevertheless IMO if we
can export an exact range supported by FD device we should do it, and let
upper layers do the normalization. And the bigger numbers should mean higher
confidence, consistently for all devices.

Do you think we could assume that the FD threshold range (FD_LHIT register
in case of OMAP4) is always same as the result confidence level ?

If so then the confidence level range could possibly be queried with the
detection threshold control. We could name it V4L2_CID_FD_CONFIDENCE_THRESHOLD
for example.
I could take care of preparing the control class draft and the documentation
for it.

> 
>>> + * @reserved:        future extensions
>>> + */
>>> +struct v4l2_obj_detection {

How about changing name of this structure to v4l2_fd_primitive or v4l2_fd_shape ?

>>> +     __u16           centerx;
>>> +     __u16           centery;
>>> +     __u16           angle;
>>> +     __u16           sizex;
>>> +     __u16           sizey;
>>
>> How about using struct v4l2_rect in place of centerx/centery, sizex/sizey ?
>> After all it describes a rectangle. We could also use struct v4l2_frmsize_discrete
>> for size but there seems to be missing en equivalent for position, e.g.
> 
> Maybe user space would like to plot a circle or ellipse over the detected
> objection, and I am sure that I have seen this kind of plot over detected
> face before.

OK, in any way I suggest to replace all __u16 with __u32, to minimize performance
issues and be consistent with the data type specifying pixel values elsewhere in
V4L.
It makes sense to make 'confidence' __u32 as well and add a flags attribute to
indicate the shape.

>>
>>> +     __u16           confidence;
>>> +     __u32           reserved[4];

And then
	  __u32           reserved[10];

or
	  __u32           reserved[2];

>>> +};
>>> +
>>> +#define V4L2_FD_HAS_LEFT_EYE 0x1
>>> +#define V4L2_FD_HAS_RIGHT_EYE        0x2
>>> +#define V4L2_FD_HAS_MOUTH    0x4
>>> +#define V4L2_FD_HAS_FACE     0x8

Do you think we could change it to:

#define V4L2_FD_FL_LEFT_EYE	(1 << 0)
#define V4L2_FD_FL_RIGHT_EYE	(1 << 1)
#define V4L2_FD_FL_MOUTH	(1 << 2)
#define V4L2_FD_FL_FACE		(1 << 3)

and add:

#define V4L2_FD_FL_SMILE	(1 << 4)
#define V4L2_FD_FL_BLINK	(1 << 5)

?
>>> +
>>> +/**
>>> + * struct v4l2_fd_detection - VIDIOC_G_FD_RESULT argument
>>> + * @flag:    return, describe which objects are detected
>>> + * @left_eye:        return, left_eye position if detected
>>> + * @right_eye:       return, right_eye position if detected
>>> + * @mouth_eye:       return, mouth_eye position if detected
>>
>> mouth_eye ? ;)
> 
> Sorry, it should be mouth, :-)

:) also the word return could be omitted.

> 
>>
>>> + * @face:    return, face position if detected
>>> + */
>>> +struct v4l2_fd_detection {

How about changing the name to v4l2_fd_object ?

>>> +     __u32   flag;
>>> +     struct v4l2_obj_detection       left_eye;
>>> +     struct v4l2_obj_detection       right_eye;
>>> +     struct v4l2_obj_detection       mouth;
>>> +     struct v4l2_obj_detection       face;
>>
>> I would do this differently, i.e. put "flag" inside struct v4l2_obj_detection
>> and then struct v4l2_fd_detection would be simply an array of
>> struct v4l2_obj_detection, i.e.
>>
>> struct v4l2_fd_detection {
>>        unsigned int count;
>>        struct v4l2_obj_detection [V4L2_MAX_FD_OBJECT_NUM];
>> };
>>
>> This might be more flexible, e.g. if in the future some hardware supports
>> detecting wrinkles, we could easily add that by just defining a new flag:
>> V4L2_FD_HAS_WRINKLES, etc.
> 
> This is a bit flexible, but not explicit enough for describing
> interface, how about reserving these as below for future usage?
> 
> 	struct v4l2_fd_detection {
> 		__u32   flag;
> 		Struct v4l2_obj_detection       left_eye;
> 		Struct v4l2_obj_detection       right_eye;
> 		Struct v4l2_obj_detection       mouth;
> 		Struct v4l2_obj_detection       face;
> 		Struct v4l2_obj_detection       reserved[4];
> 	};

OK, and how about this:

 	struct v4l2_fd_object {
 		struct v4l2_fd_shape	left_eye;
 		struct v4l2_fd_shape	right_eye;
 		struct v4l2_fd_shape	mouth;
 		struct v4l2_fd_shape	face;
		__u32			reserved[33];	
 		__u32   		flags;
	} __packed;

?

-- 
Regards,
Sylwester
