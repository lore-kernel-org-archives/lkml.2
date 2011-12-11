Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab1LKR1M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 12:27:12 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37819 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1LKR1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 12:27:09 -0500
Message-ID: <4EE4E7E7.8080401@gmail.com>
Date: Sun, 11 Dec 2011 18:27:03 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v1 5/7] media: v4l2: introduce two IOCTLs for face
 detection
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>	<1322838172-11149-6-git-send-email-ming.lei@canonical.com>	<4EDD428B.9010800@gmail.com>	<CACVXFVMR_n946HW1eYWEfcig_D6wFx5e3vEKmVHtERcmtsXX6g@mail.gmail.com>	<4EE139D1.4030503@gmail.com> <CACVXFVOj_OGxSqRp+2fJ-nQQrkpv3vLwocP=8qdyXncUhyqESA@mail.gmail.com>
In-Reply-To: <CACVXFVOj_OGxSqRp+2fJ-nQQrkpv3vLwocP=8qdyXncUhyqESA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/09/2011 05:34 AM, Ming Lei wrote:
>>>>> + * struct v4l2_obj_detection
>>>>> + * @buf_index:       entry, index of v4l2_buffer for face detection
>>
>> I would prefer having the frame sequence number here. It will be more
>> future proof IMHO. If for instance we decide to use such an ioctl on
>> a v4l2 sub-device, without dequeuing buffers, there will be no problem
>> with that. And still in your specific use case it's not big deal to
>> look up the buffer index given it's sequence number in the application.
> 
> OK, take your suggestion to use frame index, but I still have question
> about it, see my question in another thread.

Buffer index is not enough as it's local to a DMA engine and applications,
while frame sequence is unique throughout whole pipeline.

>>>>> + * @centerx: return, position in x direction of detected object
>>>>> + * @centery: return, position in y direction of detected object
>>>>> + * @angle:   return, angle of detected object
>>>>> + *           0 deg ~ 359 deg, vertical is 0 deg, clockwise
>>>>> + * @sizex:   return, size in x direction of detected object
>>>>> + * @sizey:   return, size in y direction of detected object
>>>>> + * @confidence:      return, confidence level of detection result
>>>>> + *           0: the heighest level, 9: the lowest level
>>>>
>>>> Hmm, not a good idea to align a public interface to the capabilities
>>>> of a single hardware implementation.
>>>
>>> I think that the current omap interface is general enough, so why can't
>>> we use it as public interface?
>>
>> I meant exactly the line implying the range. What if for some hardware
>> it's 0..11 ?
> 
> We can let driver to normalize it to user which doesn't care if the range
> is 0~11 or 10~21, a uniform range should always make user happy,
> shouldn't it?

Perhaps yes, I don't have strong opinion on how much knowing an exact range
is important.

>>>> min/max confidence could be queried with
>>>> relevant controls and here we could remove the line implying range.
>>>
>>> No, the confidence is used to describe the probability about
>>> the correctness of the current detection result. Anyway, no FD can
>>> make sure that it is 100% correct.  Other HW can normalize its
>>> confidence level to 0~9 so that application can handle it easily, IMO.
>>
>> 1..100 might be better, to minimize rounding errors. Nevertheless IMO if we
>> can export an exact range supported by FD device we should do it, and let
>> upper layers do the normalization. And the bigger numbers should mean higher
>> confidence, consistently for all devices.
> 
> Looks 1..100 is better, and I will change it to 1..100.

Or do we make it 0..100 and assume 0 is impossible (insignificant) value ?

>> Do you think we could assume that the FD threshold range (FD_LHIT register
>> in case of OMAP4) is always same as the result confidence level ?
> 
> No, they are different. FD_LHIT is used to guild FD HW to detect more
> faces but more false positives __or__ less faces but less false positives.

OK. But still value range for them is 0..9, isn't it ?

> A control class is needed to be introduced for adjusting this value of FD
> HW, and I think a normalized range is better too.

We don't necessarily need to think about v4l2 application as an end user
program.

>> If so then the confidence level range could possibly be queried with the
>> detection threshold control. We could name it V4L2_CID_FD_CONFIDENCE_THRESHOLD
> 
> As I said above, there is no advantage to export the range to user, and a
> uniform range will make user happy.

We don't need to export anything, i.e. no additional effort is needed.
As you may know, each control has min/max/step value associated with it and
each driver must initialize it to sane values. Control properties can be
queried by applications
(http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-queryctrl.html).

This is the only overhead for applications, to query the controls. What
they usually normally do, in order to initialize control panels, etc.

[...]
>>>>> +struct v4l2_obj_detection {
>>
>> How about changing name of this structure to v4l2_fd_primitive or v4l2_fd_shape ?
> 
> I think v4l2_obj_detection is better because it can be reused to describe
> some other kind of object detection from video in the future.

Perhaps name "v4l2_fd_object" would fit better for this type of data.


>>>>> +     __u16           centerx;
>>>>> +     __u16           centery;
>>>>> +     __u16           angle;
>>>>> +     __u16           sizex;
>>>>> +     __u16           sizey;
>>>>
>>>> How about using struct v4l2_rect in place of centerx/centery, sizex/sizey ?
>>>> After all it describes a rectangle. We could also use struct v4l2_frmsize_discrete
>>>> for size but there seems to be missing en equivalent for position, e.g.
>>>
>>> Maybe user space would like to plot a circle or ellipse over the detected
>>> objection, and I am sure that I have seen this kind of plot over detected
>>> face before.

More important is what is returned from face detector. In all cases I'm aware those
are rectangles. The application may do anything with the data

>>
>> OK, in any way I suggest to replace all __u16 with __u32, to minimize performance
>> issues and be consistent with the data type specifying pixel values elsewhere in
>> V4L.
> 
> OK, but may introduce more memory footprint for the fd result.

So maybe:

struct v4l2_point {
	__s32	x;
	__s32	y;
};

struct v4l2_size {
	__s32	w;
	__s32	h;
};

struct v4l2_fd_object {
	__u32			flags;
	__s16           	confidence;
	__s16           	angle;
	struct v4l2_size	size;
	struct v4l2_point	center;
	__u16			reserved[4];
} __packed;

For flags we might need something like:
#define V4L2_FD_OBJ_RECTANGLE  (1 << 0)
...

OR

struct v4l2_fd_object {
	union {
		struct v4l2_rect rect;
		__u32	data[4];
	}u;
} __packed;

And I'm not sure if we need parameters like confidence or angle in v4l2_fd_object
data structure. Isn't it enough to have such properties per struct
v4l2_fd_detection only ? In your driver you don't even use other struct
v4l2_obj_detection instances than 'face'. It's rather significant waste of memory.

>> It makes sense to make 'confidence' __u32 as well and add a flags attribute to
>> indicate the shape.
> 
> Sounds good.
...
>> #define V4L2_FD_FL_LEFT_EYE     (1 << 0)
>> #define V4L2_FD_FL_RIGHT_EYE    (1 << 1)
>> #define V4L2_FD_FL_MOUTH        (1 << 2)
>> #define V4L2_FD_FL_FACE         (1 << 3)
> 
> OK
> 
>> and add:
>>
>> #define V4L2_FD_FL_SMILE        (1 << 4)
>> #define V4L2_FD_FL_BLINK        (1 << 5)
> 
> Do you have any suggestion about how to describe this kind of
> detection?

We could add smile_level and blink_level to struct v4l2_fd_result.
And then keep the two above flags or not.

>>>>> +/**
>>>>> + * struct v4l2_fd_detection - VIDIOC_G_FD_RESULT argument
>>>>> + * @flag:    return, describe which objects are detected
>>>>> + * @left_eye:        return, left_eye position if detected
>>>>> + * @right_eye:       return, right_eye position if detected
>>>>> + * @mouth_eye:       return, mouth_eye position if detected
...
>>>>> + * @face:    return, face position if detected
>>>>> + */
>>>>> +struct v4l2_fd_detection {
>>
>> How about changing the name to v4l2_fd_object ?
> 
> I think the structure is used to describe one single detection result which
> may include several kind of objects detected, so sounds
> v4l2_fd_detection is better than v4l2_fd_object(s?).

"detection" doesn't really say if it is face detection process' configuration
or its result. I believe we can do better than
v4l2_fd_detection/v4l2_obj_detection pair.


>>>>> +     __u32   flag;
>>>>> +     struct v4l2_obj_detection       left_eye;
>>>>> +     struct v4l2_obj_detection       right_eye;
>>>>> +     struct v4l2_obj_detection       mouth;
>>>>> +     struct v4l2_obj_detection       face;
>>>>
>>>> I would do this differently, i.e. put "flag" inside struct v4l2_obj_detection
>>>> and then struct v4l2_fd_detection would be simply an array of
>>>> struct v4l2_obj_detection, i.e.
>>>>
>>>> struct v4l2_fd_detection {
>>>>        unsigned int count;
>>>>        struct v4l2_obj_detection [V4L2_MAX_FD_OBJECT_NUM];
>>>> };
>>>>
>>>> This might be more flexible, e.g. if in the future some hardware supports
>>>> detecting wrinkles, we could easily add that by just defining a new flag:
>>>> V4L2_FD_HAS_WRINKLES, etc.
>>>
>>> This is a bit flexible, but not explicit enough for describing
>>> interface, how about reserving these as below for future usage?
>>>
>>>       struct v4l2_fd_detection {
>>>               __u32   flag;
>>>               Struct v4l2_obj_detection       left_eye;
>>>               Struct v4l2_obj_detection       right_eye;
>>>               Struct v4l2_obj_detection       mouth;
>>>               Struct v4l2_obj_detection       face;
>>>               Struct v4l2_obj_detection       reserved[4];
>>>       };
>>
>> OK, and how about this:
>>
>>        struct v4l2_fd_object {
>>                struct v4l2_fd_shape    left_eye;
>>                struct v4l2_fd_shape    right_eye;
>>                struct v4l2_fd_shape    mouth;
>>                struct v4l2_fd_shape    face;
>>                __u32                   reserved[33];
> 
> Why is struct 'v4l2_fd_shape    reserved[4]' removed?

We can still add struct v4l2_fd_shape in place of the reserved[]
array in future if needed. But something else than v4l2_fd_shape may be
needed, so plain u32 array looked more reasonable to me.

>>                __u32                   flags;
>>        } __packed;
> 
> Why is '__packed' needed? It will introduce performance loss if we have
> not good reason to do it.

IMHO we can use attribute packed to make sure the structure layout is same
on all architectures. And design the data structure so performance loss
is minimal, i.e. no weird padding is necessary.

The face detector output structure might then be:

struct v4l2_fd_detection {	
	struct v4l2_fd_object	left_eye;
	struct v4l2_fd_object	right_eye;
	struct v4l2_fd_object	mouth;
	struct v4l2_fd_object	face;
	__s32           	confidence;
	__s32           	angle;
	__u32			flags;
	__u32			smile_level;
	__u32			blink_level;
	__u32                   reserved[37];
} __packed;


But I can't stop myself from thinking it's better to use the v4l2 event API
for passing FD output data between drivers and applications. You basically
reimplemented it in patches 6/7, 7/7. The "only" issue is that event type
specific payload size in struct v4l2_event is only 64 bytes and maximum count
of detected faces per frame isn't constant API wide and hardware dependant...


-- 

Regards,
Sylwester
