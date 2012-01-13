Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab2AMVQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 16:16:34 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39265 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab2AMVQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 16:16:31 -0500
Message-ID: <4F109F1D.1050408@gmail.com>
Date: Fri, 13 Jan 2012 22:16:13 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        riverful.kim@samsung.com
Subject: Re: [RFC PATCH v2 6/8] media: v4l2: introduce two IOCTLs for object
 detection
References: <1323871214-25435-1-git-send-email-ming.lei@canonical.com> <1323871214-25435-7-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1323871214-25435-7-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

sorry for the late response. It's all looking better now, however there
is still a few things that could be improved.

On 12/14/2011 03:00 PM, Ming Lei wrote:
> This patch introduces two new IOCTLs and related data
> structure which will be used by the coming video device
> with object detect capability.
>
> The two IOCTLs and related data structure will be used by
> user space application to retrieve the results of object
> detection.
>
> The utility fdif[1] is useing the two IOCTLs to find
> objects(faces) deteced in raw images or video streams.
>
> [1],http://kernel.ubuntu.com/git?p=ming/fdif.git;a=shortlog;h=refs/heads/v4l2-fdif
>
> Signed-off-by: Ming Lei<ming.lei@canonical.com>
> ---
> v2:
> 	- extend face detection API to object detection API
> 	- introduce capability of V4L2_CAP_OBJ_DETECTION for object detection
> 	- 32/64 safe array parameter
> ---
>   drivers/media/video/v4l2-ioctl.c |   41 ++++++++++++-
>   include/linux/videodev2.h        |  124 ++++++++++++++++++++++++++++++++++++++
>   include/media/v4l2-ioctl.h       |    6 ++
>   3 files changed, 170 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index ded8b72..575d445 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -2140,6 +2140,30 @@ static long __video_do_ioctl(struct file *file,
>   		dbgarg(cmd, "index=%d", b->index);
>   		break;
>   	}
> +	case VIDIOC_G_OD_RESULT:
> +	{
> +		struct v4l2_od_result *or = arg;
> +
> +		if (!ops->vidioc_g_od_result)
> +			break;
> +
> +		ret = ops->vidioc_g_od_result(file, fh, or);
> +
> +		dbgarg(cmd, "index=%d", or->frm_seq);
> +		break;
> +	}

> +	case VIDIOC_G_OD_COUNT:
> +	{
> +		struct v4l2_od_count *oc = arg;
> +
> +		if (!ops->vidioc_g_od_count)
> +			break;
> +
> +		ret = ops->vidioc_g_od_count(file, fh, oc);
> +
> +		dbgarg(cmd, "index=%d", oc->frm_seq);
> +		break;
> +	}

I'm uncertain if we need this ioctl at all. Now struct v4l2_od_result is:

struct v4l2_od_result {
	__u32			frame_sequence;
	__u32			object_count;
	__u32			reserved[6];
	struct v4l2_od_object	objects[0];
};

and

struct v4l2_od_object {
	__u16			type;
	__u16			confidence;
	union {
		struct v4l2_od_face_desc  face;
		struct v4l2_od_eye_desc   eye;
		struct v4l2_od_mouth_desc mouth;
		__u8	rawdata[60];
	} o;
};

If we had added a 'size' field to struct v4l2_od_result, i.e.

struct v4l2_od_result {
	__u32			size;
	__u32			frame_sequence;
	__u32			objects_count;
	__u32			reserved[5];
	struct v4l2_od_object	objects[0];
};

the application could have allocated memory for the objects array and
have the 'size' member set to the size of that allocation. Then it
would have called VIDIOC_G_OD_RESULT and the driver would have filled
the 'objects'  array, if it was big enough for the requested result
data. The driver would also update the 'objects_count'. If the size 
would be too small to fit the result data, i.e.

size < number_of_detected_objects * sizeof(struct v4l2_od_object)

the driver could return -ENOSPC error while also setting 'size' to 
the required value. Something similar is done with 
VIDIOC_G_EXT_CTRLS ioctl [3].

There is one more OD API requirement, for camera sensors with embedded
SoC ISP that support face detection, i.e. VIDIOC_G_OD_RESULT should 
allow to retrieve face detection result for the very last image frame,
i.e. current frame.

One solution to support this could be adding a 'flags' field, i.e.

struct v4l2_od_result {
	__u32			size;
	__u32			flags;
	__u32			frame_sequence;
	__u32			objects_count;
	__u16			group_index;
	__u16			group_count;
	__u16			reserved[7];
	struct v4l2_od_object	objects[0];
};

and additionally group_index to specify which face object the user is
interested in. I'm not saying we have to implement this now but it's
good to consider beforehand. The group_count would be used to return 
the number of detected faces. What do you think ?

/* flags */
#define V4L2_OD_FL_SEL_FRAME_SEQ	(0 << 0)
#define V4L2_OD_FL_SEL_FRAME_LAST	(1 << 0)
#define V4L2_OD_FL_SEL_GROUP		(1 << 1)

Or maybe we should just use "face_" instead of "group_" ?

>   	default:
>   		if (!ops->vidioc_default)
>   			break;
> @@ -2241,7 +2265,22 @@ static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
>
>   static int is_64_32_array_args(unsigned int cmd, void *parg, int *extra_len)
>   {
> -	return 0;
> +	int ret = 0;
> +
> +	switch (cmd) {
> +	case VIDIOC_G_OD_RESULT: {
> +		struct v4l2_od_result *or = parg;
> +
> +		*extra_len = or->obj_cnt *
> +			sizeof(struct v4l2_od_object);
> +		ret = 1;
> +		break;
> +	}
> +	default:
> +		break;
> +	}
> +
> +	return ret;
>   }
>
>   long
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 4b752d5..c08ceaf 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -270,6 +270,9 @@ struct v4l2_capability {
>   #define V4L2_CAP_RADIO			0x00040000  /* is a radio device */
>   #define V4L2_CAP_MODULATOR		0x00080000  /* has a modulator */
>
> +/* The device has capability of object detection */
> +#define V4L2_CAP_OBJ_DETECTION		0x00100000
> +
>   #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
>   #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
>   #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
> @@ -2160,6 +2163,125 @@ struct v4l2_create_buffers {
>   	__u32			reserved[8];
>   };
>
> +/**
> + * struct v4l2_od_obj_desc
> + * @centerx:	return, position in x direction of detected object

How about following convention:
    * @centerx:	[out] position of an object in horizontal direction

?
> + * @centery:	return, position in y direction of detected object
> + * @sizex:	return, size in x direction of detected object

    * @sizex:	[out] size of an object in horizontal direction

> + * @sizey:	return, size in y direction of detected object
> + * @angle:	return, angle of detected object
> + * 		0 deg ~ 359 deg, vertical is 0 deg, clockwise

So this is angle in Z axis as on figure [1], Roll [2], right ?
First let's make this number in 0.01 deg units, then our range would
be 0 ... 35999. Then we need a proper description, it's all going to
be described in the Docbook so we don't need to be that verbose at 
the comments.

 * @angle: [out] angle of object rotation in Z axis (depth) in 0.01 deg units

Of course any better definitions are welcome :)

> + * @reserved:	future extensions
> + */
> +struct v4l2_od_obj_desc {
> +	__u16		centerx;
> +	__u16		centery;
> +	__u16		sizex;
> +	__u16		sizey;
> +	__u16		angle;
> +	__u16		reserved[5];

I would prefer to avoid repeating myself again - for all pixel position
and size in v4l2 we normally use __u32, so let's follow this. Sending
same  patch over and over isn't helpful, even if by some miracle you've
had convinced me, there will be other people that won't accept that :-)

And let's not be afraid of adding new data types to v4l2, which likely
are anyway going to be needed in the future. How about:

struct v4l2_pix_position {
	__s32	x;
	__s32	y;
};

struct v4l2_pix_size {
	__u32	width;
	__u32	height;
};

Alternatively we might reuse the v4l2_frmsize_discrete structure,
however new structure has my preference.

struct v4l2_od_obj_desc {
	struct v4l2_pix_position	center;
	struct v4l2_pix_size		size;
	__u16				angle;
	__u16				reserved[5];
};

OR

struct v4l2_od_obj_desc {
	struct v4l2_pix_position	center;
	struct v4l2_frmsize_discrete	size;
	__u16				angle;
	__u16				reserved[3];
};

sizeof(struct v4l2_od_obj_desc) = 6 * 4

> +};
> +
> +/**
> + * struct v4l2_od_face_desc
> + * @id:		return, used to be associated with detected eyes, mouth,
> + * 		and other objects inside this face, and each face in one
> + * 		frame has a unique id, start from 1
> + * @smile_level:return, smile level of the face

For the smile_level it shouldn't hurt if we assume standard value range
of 0...99, but this would go to the DocBook, your comment above is fine,
except s/:return/: [out].

> + * @f:		return, face description
> + */
> +struct v4l2_od_face_desc {
> +	__u16	id;

Actually I was going to propose something like this 'id' member:) I think
we'll also need a method for user space to retrieve FD result by such sort
of a key, in addition to or instead of the frame_sequence key.

However, to be more generic, perhaps we could move it to the v4l2_od_obj_desc
structure ? And rename it to group_index, which would mean a positive non-zero
sequence number assigned to a group of objects, e.g. it would be one value
per face, eyes and mouth data set ? What do you think ?

> +	__u8	smile_level;
> +	__u8    reserved[15];
> +
> +	struct v4l2_od_obj_desc	f;
> +};

It might be good idea to align the data structures' size to at least
4 bytes. I would have changed your proposed structure to:

struct v4l2_od_face_desc {
	__u16	id;
	__u16	smile_level;
	__u16   reserved[10];
	struct v4l2_od_obj_desc	face;
};

sizeof(struct v4l2_od_face_desc) = 12 * 4

> +
> +/**
> + * struct v4l2_od_eye_desc
> + * @face_id:	return, used to associate with which face, 0 means
> + * 		no face associated with the eye
> + * @blink_level:return, blink level of the eye
> + * @e:		return, eye description
> + */
> +struct v4l2_od_eye_desc {
> +	__u16	face_id;
> +	__u8	blink_level;
> +	__u8    reserved[15];
> +
> +	struct v4l2_od_obj_desc	e;
> +};

How about:

struct v4l2_od_eye_desc {
	__u16	face_id;
	__u16	blink_level;
	__u16   reserved[10];
	struct v4l2_od_obj_desc	eye;
};
sizeof(struct v4l2_od_eye_desc) = 12 * 4

?
> +/**
> + * struct v4l2_od_mouth_desc
> + * @face_id:	return, used to associate with which face, 0 means
> + * 		no face associated with the mouth
> + * @m:		return, mouth description
> + */
> +struct v4l2_od_mouth_desc {
> +	__u16	face_id;
> +	__u8    reserved[16];
> +
> +	struct v4l2_od_obj_desc	m;
> +};
and

struct v4l2_od_mouth_desc {
	__u16	face_id;
	__u16   reserved[11];
	struct v4l2_od_obj_desc	mouth;
};
sizeof(struct v4l2_od_mouth_desc) = 12 * 4

> +
> +enum v4l2_od_type {
> +	V4L2_OD_TYPE_FACE		= 1,
> +	V4L2_OD_TYPE_LEFT_EYE		= 2,
> +	V4L2_OD_TYPE_RIGHT_EYE		= 3,
> +	V4L2_OD_TYPE_MOUTH		= 4,
> +	V4L2_OD_TYPE_USER_DEFINED	= 255,

Let's not add any "user defined" types, at the time anything more
is needed it should be added here explicitly.

> +	V4L2_OD_TYPE_MAX_CNT		= 256,

	V4L2_OD_TYPE_MAX		= 256, ?

But what do you think it is needed for ?

> +};
> +
> +/**
> + * struct v4l2_od_object
> + * @type:	return, type of detected object

How about

+ * @type:	[out] object type (from enum v4l2_od_type)

?
> + * @confidence:	return, confidence level of detection result
> + * 		0: the heighest level, 100: the lowest level

    * @confidence: [out] confidence level of the detection result
?
Let's leave the range specification for the DocBook.

> + * @face:	return, detected face object description
> + * @eye:	return, detected eye object description
> + * @mouth:	return, detected mouth object description
> + * @rawdata:	return, user defined data

No user defined data please. How the applications are supposed to know what
rawdata means ? If any new structure is needed it should be added to the union.
Let's treat 'rawdata' as a place holder only. This is how the "__u8 data[64];" 
array is specified for struct v4l2_event:

"__u8	data[64]	Event data. Defined by the event type. The union
                        should be used to define easily accessible type
                        for events."

> + */
> +struct v4l2_od_object {
> +	enum v4l2_od_type	type;

	__u16			type;

to avoid having enumeration in the user space interface ?

> +	__u16			confidence;

	__u32	reserved[7];

> +	union {
> +		struct v4l2_od_face_desc face;

> +		struct v4l2_od_face_desc eye;
> +		struct v4l2_od_face_desc mouth;

I guess you meant
		struct v4l2_od_eye_desc   eye;
		struct v4l2_od_mouth_desc mouth;
?
> +		__u8	rawdata[60];
> +	} o;

won't probably hurt here and would allow future extensions.

> +};

I think being able to fit struct v4l2_od_object in the "u" union of
struct v4l2_event is a must have, as events seem crucial for the
whole object detection interface. For instance user application could
set thresholds for some parameters to get notified with an event when
any gets out of configured bounds. The event interface could be also
used for retrieving OD result instead of polling with VIDIOC_G_OD_RESULT.
Currently struct v4l2_event is:

struct v4l2_event {
	__u32				type;
	union {
		struct v4l2_event_vsync		vsync;
		struct v4l2_event_ctrl		ctrl;
		struct v4l2_event_frame_sync	frame_sync;
		__u8				data[64];
	} u;
	__u32				pending;
	__u32				sequence;
	struct timespec			timestamp;
	__u32				id;
	__u32				reserved[8];
};

Hence we have only 64 bytes for struct v4l2_event_od. It seems that
you kept that when designing the above data structures ?

With my corrections above  sizeof(struct v4l2_od_object) (without the
reserved field would be 13 * 4, which isn't bad. I'm just a bit 
concerned about the structures alignment.

> +/**
> + * struct v4l2_od_result - VIDIOC_G_OD_RESULT argument
> + * @frm_seq:	entry, frame sequence No.

    * @frame_sequence: [in] frame sequence number

> + * @obj_cnt:	return, how many objects detected in frame @frame_seq
    * @object_count: [out] number of object detected for @frame_sequence

> + * @reserved:	reserved for future use
> + * @od:		return, result of detected objects in frame @frame_seq

    * @od: [out] objects detected for @frame_sequence ?

> + */
> +struct v4l2_od_result {
> +	__u32			frm_seq;
> +	__u32			obj_cnt;
> +	__u32			reserved[6];
> +	struct v4l2_od_object	od[0];

Let's make this:

  	struct v4l2_od_object	objects[0];

> +};
> +
> +/**
> + * struct v4l2_od_count - VIDIOC_G_OD_COUNT argument
> + * @frm_seq:	entry, frame sequence No. for ojbect detection
> + * @obj_cnt:	return, how many objects detected from the @frm_seq
> + * @reserved:	reserved for future useage.
> + */
> +struct v4l2_od_count {
> +	__u32	frm_seq;
> +	__u32	obj_cnt;
> +	__u32	reserved[6];
> +};

This structure can go away if we change the VIDIOC_G_OD_RESULT
semantics as I described above..

> +
>   /*
>    *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
>    *
> @@ -2254,6 +2376,8 @@ struct v4l2_create_buffers {
>      versions */
>   #define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
>   #define VIDIOC_PREPARE_BUF	_IOWR('V', 93, struct v4l2_buffer)
> +#define VIDIOC_G_OD_COUNT	_IOWR('V', 94, struct v4l2_od_count)
> +#define VIDIOC_G_OD_RESULT	_IOWR('V', 95, struct v4l2_od_result)
>
>   /* Reminder: when adding new ioctls please add support for them to
>      drivers/media/video/v4l2-compat-ioctl32.c as well! */
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index 4d1c74a..81a32a3 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -270,6 +270,12 @@ struct v4l2_ioctl_ops {
>   	int (*vidioc_unsubscribe_event)(struct v4l2_fh *fh,
>   					struct v4l2_event_subscription *sub);
>
> +	/* object detect IOCTLs */
> +	int (*vidioc_g_od_count) (struct file *file, void *fh,
> +					struct v4l2_od_count *arg);

..and this ioctl too.

> +	int (*vidioc_g_od_result) (struct file *file, void *fh,
> +					struct v4l2_od_result *arg);
> +
>   	/* For other private ioctls */
>   	long (*vidioc_default)	       (struct file *file, void *fh,
>   					bool valid_prio, int cmd, void *arg);

[1] http://i.stack.imgur.com/qb6hU.png
[2] http://www.dtic.mil/cgi-bin/GetTRDoc?AD=ADA434817
[3] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-ext-ctrls.html

--
Thanks,
Sylwester
